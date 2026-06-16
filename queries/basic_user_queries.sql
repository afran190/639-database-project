-- SQL queries supporting the users' tasks

-- task 1: Retrieve all assignments associated with a specific 
-- photographer by joining PHOTOGRAPHER, ASSIGNMENT_CARD, and ASSIGNMENT. 

SELECT p.first_name,
p.last_name,
ac.card_number,
a.assignment_title,
a.year,
a.filing_place,
 a.grm_container_number
FROM `PHOTOGRAPHER` p
JOIN `ASSIGNMENT_CARD` ac ON p.photographer_id = ac.photographer_id
JOIN `ASSIGNMENT` a  ON ac.card_id = a.card_id
WHERE  p.last_name = 'Eisenstaedt'
ORDER BY a.year;

-- task 2: Retrieve all negative types associated with a specific assignment by querying 
-- ASSIGNMENT_NEGATIVE_TYPE and NEGATIVE_TYPE.

SELECT a.assignment_title,
nt.negative_type_name,
nt.negative_type_description
FROM `ASSIGNMENT` a
JOIN `ASSIGNMENT_NEGATIVE_TYPE` ant ON a.assignment_id    = ant.assignment_id
JOIN `NEGATIVE_TYPE` nt ON ant.negative_type_id = nt.negative_type_id
WHERE  a.assignment_title = 'Minamata Disease Documentation';

-- task 3: Look up the GRM container number and barcode associated with a specific assignment to 
-- locate physical materials in the offsite archive.

SELECT a.assignment_title,
a.grm_container_number,
 g.grm_barcode,
a.filing_place
FROM `ASSIGNMENT` a
JOIN `GRM_BARCODE` g ON a.assignment_id = g.assignment_id
WHERE a.assignment_title = 'Fort Peck Dam';

-- task 4: Retrieve current contact information for a photographer or their estate by 
-- querying CONTACT_INFO joined to PHOTOGRAPHER or ESTATE.
 
SELECT 'Photographer' AS contact_type,
p.first_name,
p.last_name,
ci.street_address,
ci.city,
ci.state,
ci.zip_code,
ci.country,
ci.phone,
ci.email
FROM `PHOTOGRAPHER` p
JOIN `CONTACT_INFO` ci ON p.contact_info_id = ci.contact_info_id
WHERE p.last_name = 'Smith'
UNION ALL
SELECT 'Estate' AS contact_type,
e.first_name,
e.last_name,
ci.street_address,
ci.city,
ci.state,
ci.zip_code,
ci.country,
ci.phone,
ci.email
FROM `ESTATE` e
JOIN `CONTACT_INFO` ci   ON e.contact_info_id  = ci.contact_info_id
JOIN `PHOTOGRAPHER` p    ON e.photographer_id   = p.photographer_id
WHERE p.last_name = 'Smith';

-- task 5: Retrieve all estate members associated with a specific photographer, including their relationship type 
-- and contact information. 

SELECT p.first_name  AS photographer_first,
p.last_name   AS photographer_last,
e.first_name  AS estate_first,
e.last_name   AS estate_last,
ert.relationship_name,
ci.phone,
ci.email,
ci.city,
ci.state
FROM `PHOTOGRAPHER`p
JOIN `ESTATE`e ON p.photographer_id = e.photographer_id
JOIN `ESTATE_RELATIONSHIP_TYPE` ert ON e.relationship_type_id = ert.relationship_type_id
LEFT JOIN `CONTACT_INFO` ci ON e.contact_info_id = ci.contact_info_id
WHERE p.last_name = 'Capa';

-- task 6: Identify the requester associated with a specific return record, determining whether the requester 
-- is the photographer themselves or an estate member.  

SELECT rr.return_record_id,
CASE WHEN pr.photographer_requester_id IS NOT NULL AND er.estate_requester_id IS NOT NULL
THEN 'Both Photographer & Estate'
WHEN pr.photographer_requester_id IS NOT NULL THEN 'Photographer'
WHEN er.estate_requester_id IS NOT NULL THEN 'Estate'
END AS requester_source,
COALESCE(pp.first_name, ep.first_name) AS requester_first,
COALESCE(pp.last_name, ep.last_name)   AS requester_last, rr.date_started
FROM `RETURN_RECORD` rr
LEFT JOIN `PHOTOGRAPHER_REQUESTER` pr ON rr.photographer_requester_id = pr.photographer_requester_id
LEFT JOIN `PHOTOGRAPHER` pp ON pr.photographer_id  = pp.photographer_id
LEFT JOIN `ESTATE_REQUESTER` er  ON rr.estate_requester_id = er.estate_requester_id
LEFT JOIN `ESTATE` e ON er.estate_id = e.estate_id
LEFT JOIN `PHOTOGRAPHER` ep ON e.photographer_id = ep.photographer_id
ORDER BY rr.return_record_id;

-- task 7: Retrieve all return records ordered by date_requested ascending to prioritize the longest-standing 
-- outstanding requests. 

SELECT rr.return_record_id,
rs.status_name,
pl.level_name,
rr.date_started,
rr.google_drive_link
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS`  rs ON rr.return_status_id  = rs.return_status_id
JOIN `PRIORITY_LEVEL` pl ON rr.priority_level_id = pl.priority_level_id
WHERE rs.status_name <> 'Completed'
ORDER BY rr.date_started ASC;

-- task 8: Retrieve all return records flagged with a high priority level, including those escalated by a 
-- received legal document. 

SELECT rr.return_record_id,
rs.status_name,
pl.level_name,
rr.date_started
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS`  rs ON rr.return_status_id  = rs.return_status_id
JOIN `PRIORITY_LEVEL` pl ON rr.priority_level_id = pl.priority_level_id
WHERE pl.level_name IN ('Critical', 'High') OR  rr.return_record_id IN (
SELECT ld.return_record_id FROM   `LEGAL_DOCUMENT` ld )
ORDER BY pl.priority_level_id ASC, rr.date_started ASC;

-- task 9: Update the return status of a specific return record from "Not Started" to "In Progress" when 
-- processing begins. 

UPDATE `RETURN_RECORD`
SET `return_status_id` = (SELECT `return_status_id`
FROM `RETURN_STATUS` WHERE  `status_name` = 'In Progress')
WHERE `return_record_id` = 5 AND  `return_status_id` = (SELECT `return_status_id`
FROM `RETURN_STATUS` WHERE  `status_name` = 'Pending Review');

SELECT rr.return_record_id, rs.status_name
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
WHERE rr.return_record_id = 5;

-- task 10 & 12: Update the return status of a specific return record to "Completed" once shipment has been 
-- confirmed as delivered and signed for. And then  update the confirmation status of a shipment from "Pending" 
-- to "Signed" once delivery is confirmed. 

START TRANSACTION;

UPDATE `CONFIRMATION_STATUS`
SET `signed_for`  = 1,
`date_signed` = NOW()
WHERE `confirm_status_id` = (SELECT `confirm_status_id`
FROM `SHIPMENT` WHERE  `return_record_id` = 1
);

UPDATE `RETURN_RECORD`
SET`return_status_id` = (SELECT `return_status_id`
FROM `RETURN_STATUS` WHERE  `status_name` = 'Completed')
WHERE `return_record_id` = 1;

COMMIT;

SELECT rr.return_record_id,
rs.status_name,
cs.signed_for,
cs.date_signed
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
JOIN `SHIPMENT` s ON rr.return_record_id = s.return_record_id
JOIN `CONFIRMATION_STATUS` cs ON s.confirm_status_id = cs.confirm_status_id
WHERE rr.return_record_id = 1;

-- task 11:  Insert a new shipment record for a return, including carrier, tracking number, and ship date. 

INSERT INTO `SHIPMENT` (`return_record_id`, `carrier_id`, `confirm_status_id`,
`tracking_number`, `ship_date`)
VALUES (3,
(SELECT `carrier_id` FROM `CARRIER` WHERE `carrier_name` = 'FedEx'),
(SELECT `confirm_status_id` FROM `CONFIRMATION_STATUS` WHERE  `signed_for` = 0 LIMIT 1),
'FX-8821-0042-2024', CURDATE());

SELECT s.shipment_id,
s.tracking_number,
c.carrier_name,
s.ship_date,
 cs.signed_for
FROM `SHIPMENT` s JOIN `CARRIER` c ON s.carrier_id = c.carrier_id
JOIN `CONFIRMATION_STATUS` cs ON s.confirm_status_id = cs.confirm_status_id
WHERE s.return_record_id = 3
ORDER BY s.shipment_id DESC
LIMIT 1;

-- task 13:  Insert a new legal document record associated with a return record when papers are received, 
-- recording the date served and description. 

INSERT INTO `LEGAL_DOCUMENT` (`return_record_id`, `date_served`, `description`)
VALUES (2, CURDATE(), 'Signed affidavit from George Silk estate authorizing 
return of Melbourne Olympics negatives');


SELECT ld.legal_doc_id,
ld.return_record_id,
ld.date_served,
ld.description
FROM  `LEGAL_DOCUMENT` ld
WHERE ld.return_record_id = 2
ORDER BY ld.legal_doc_id DESC
LIMIT 1;

-- task 14:  Retrieve the Google Drive folder link for a specific return record to access all 
-- correspondence and shipping documentation

SELECT rr.return_record_id,
rr.google_drive_link,
rs.status_name,
rr.date_started
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
WHERE rr.return_record_id = 4;

-- task 15: Generate a list of all completed returns including the photographer name, assignments returned, 
-- ship date, and confirmation status for historical records.
 
CREATE VIEW `vw_completed_returns` AS
SELECT rr.return_record_id,
p.first_name AS photographer_first,
p.last_name AS photographer_last,
a.assignment_title,
a.year AS assignment_year,
s.tracking_number,
s.ship_date,
c.carrier_name,
CASE WHEN cs.signed_for = 1 THEN 'Signed' ELSE 'Awaiting Signature'
END AS confirmation, cs.date_signed
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
JOIN `ASSIGNMENT` a ON rr.return_record_id  = a.return_record_id
JOIN `ASSIGNMENT_CARD` ac ON a.card_id = ac.card_id
JOIN `PHOTOGRAPHER` p ON ac.photographer_id = p.photographer_id
LEFT JOIN `SHIPMENT` s ON rr.return_record_id = s.return_record_id
LEFT JOIN `CARRIER` c ON s.carrier_id = c.carrier_id
LEFT JOIN `CONFIRMATION_STATUS` cs ON s.confirm_status_id = cs.confirm_status_id
WHERE rs.status_name = 'Completed';

SELECT * FROM `vw_completed_returns`;

-- Query 15: trigger for then a new shipment is inserted for a return record,
-- automatically update that return record's status to  "Shipped."

DELIMITER $$
CREATE TRIGGER `trg_shipment_update_status`
AFTER INSERT ON `SHIPMENT`
FOR EACH ROW
UPDATE `RETURN_RECORD`
SET `return_status_id` = (
SELECT `return_status_id` FROM `RETURN_STATUS` WHERE `status_name` = 'Shipped')
WHERE `return_record_id` = NEW.`return_record_id`;
END $$
DELIMITER ;

INSERT INTO `CONFIRMATION_STATUS` (`signed_for`, `date_signed`)
VALUES (0, NULL);

INSERT INTO `SHIPMENT` (`return_record_id`, `carrier_id`, `confirm_status_id`, `tracking_number`, `ship_date`)
VALUES (5, (SELECT `carrier_id` FROM `CARRIER` WHERE `carrier_name` = 'UPS'),
(SELECT MAX(`confirm_status_id`) FROM `CONFIRMATION_STATUS`),
'UPS-1Z888BB20256', CURDATE());

SELECT rr.return_record_id,
rs.status_name AS status_after_trigger,
s.tracking_number,
s.ship_date
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
JOIN `SHIPMENT` s ON rr.return_record_id = s.return_record_id
WHERE rr.return_record_id = 5
ORDER BY s.shipment_id DESC
LIMIT 1;

-- Query 16: Remove a cancelled legal document from the system.

SELECT legal_doc_id, return_record_id, description
FROM   `LEGAL_DOCUMENT`
WHERE  return_record_id = 2;

DELETE FROM `LEGAL_DOCUMENT`
WHERE  `return_record_id` = 2
  AND  `description` LIKE '%George Silk%';

SELECT legal_doc_id, return_record_id, description
FROM   `LEGAL_DOCUMENT`
WHERE  return_record_id = 2;


