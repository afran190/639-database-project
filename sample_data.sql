-- Data Insertion; the SQL INSERTS that follow were generated with the 
-- assistance of Anthropic's Calude AI language model. I cannot share my company data
-- so I had to use the AI tool to create fake data that follows similar formatting

USE `LIFE_assignment_return_system`;

INSERT INTO `PHOTOGRAPHER_TYPE` (`type_name`) VALUES
('Staff'),
('Contract'),
('Freelance'),
('Contributing'),
('String Correspondent');

INSERT INTO `PUBLICATION` (`publication_name`) VALUES
('LIFE'),
('LIFE International'),
('Fortune'),
('Sports Illustrated'),
('Time');

INSERT INTO `CONTACT_INFO` (`street_address`, `city`, `state`, `zip_code`, `country`, `phone`, `email`) VALUES
('142 West 57th Street',    'New York',      'NY', '10019', 'United States', '212-555-0101', 'e.eisenstaedt@example.com'),
('88 Beacon Street',        'Boston',        'MA', '02108', 'United States', '617-555-0202', 'g.silk@example.com'),
('310 Riverside Drive',     'New York',      'NY', '10025', 'United States', '212-555-0303', 'm.bourkewhite@example.com'),
('1500 Magazine Street',    'New Orleans',   'LA', '70130', 'United States', '504-555-0404', 'w.eugene.smith@example.com'),
('22 Avenue Montaigne',     'Paris',         NULL, '75008', 'France',        '+33-1-5555-0505', 'r.capa@example.com'),
('4701 Willard Avenue',     'Chevy Chase',   'MD', '20815', 'United States', '301-555-0601', 'j.eisenstaedt.estate@example.com'),
('15 Gramercy Park South',  'New York',      'NY', '10003', 'United States', '212-555-0702', 'silk.estate@example.com'),
('900 West End Avenue',     'New York',      'NY', '10025', 'United States', '212-555-0803', 'bw.trust@example.com'),
('PO Box 4823',             'Tucson',        'AZ', '85717', 'United States', '520-555-0904', 'smith.heirs@example.com'),
('7 Rue Scribe',            'Paris',         NULL, '75009', 'France',        '+33-1-5555-1005', 'capa.foundation@example.com'),
('225 Park Avenue South',   'New York',      'NY', '10003', 'United States', '212-555-1100', 'archive.dept@example.com'),
('225 Park Avenue South',   'New York',      'NY', '10003', 'United States', '212-555-1101', 'legal.dept@example.com');

INSERT INTO `NEGATIVE_TYPE` (`negative_type_name`, `negative_type_description`) VALUES
('35mm B&W',        'Standard 35mm black-and-white negative strip'),
('35mm Color',      'Standard 35mm color negative strip'),
('4x5 Transparency','4x5 inch large-format color transparency sheet film'),
('120 B&W',         'Medium-format 120 roll black-and-white negative'),
('120 Color',       'Medium-format 120 roll color negative or transparency');

INSERT INTO `ESTATE_RELATIONSHIP_TYPE` (`relationship_name`, `relationship_description`) VALUES
('Spouse',              'Surviving husband or wife of the photographer'),
('Child',               'Son or daughter of the photographer'),
('Sibling',             'Brother or sister of the photographer'),
('Foundation Director', 'Director of a foundation established for the photographer''s estate'),
('Executor',            'Legal executor of the photographer''s estate');

INSERT INTO `RETURN_STATUS` (`status_name`, `status_description`) VALUES
('Pending Review',   'Return request received; materials not yet pulled'),
('In Progress',      'Materials identified and being prepared for return'),
('Ready to Ship',    'Materials packed and awaiting shipment'),
('Shipped',          'Materials dispatched to recipient'),
('Completed',        'Materials received and return confirmed');

INSERT INTO `PRIORITY_LEVEL` (`level_name`, `level_description`) VALUES
('Critical',  'Legal obligation or court-ordered deadline'),
('High',      'Estate settlement or time-sensitive request'),
('Medium',    'Standard return with no pressing deadline'),
('Low',       'Informational inquiry; return not yet confirmed'),
('Deferred',  'Return postponed pending further research or negotiation');

INSERT INTO `CONFIRMATION_STATUS` (`signed_for`, `date_signed`) VALUES
(1, '2024-03-15 14:22:00'),
(1, '2024-05-02 10:45:00'),
(0, NULL),
(1, '2024-07-20 09:30:00'),
(0, NULL);

INSERT INTO `CARRIER` (`carrier_name`) VALUES
('FedEx'),
('UPS'),
('USPS'),
('DHL Express'),
('Hand Delivery');

SELECT COUNT(*) AS photographer_type_count FROM `PHOTOGRAPHER_TYPE`;
SELECT COUNT(*) AS publication_count FROM `PUBLICATION`;
SELECT COUNT(*) AS contact_info_count FROM `CONTACT_INFO`;
SELECT COUNT(*) AS negative_type_count FROM `NEGATIVE_TYPE`;
SELECT COUNT(*) AS estate_rel_type_count FROM `ESTATE_RELATIONSHIP_TYPE`;
SELECT COUNT(*) AS return_status_count FROM `RETURN_STATUS`;
SELECT COUNT(*) AS priority_level_count FROM `PRIORITY_LEVEL`;
SELECT COUNT(*) AS confirmation_status_count FROM `CONFIRMATION_STATUS`;
SELECT COUNT(*) AS carrier_count FROM `CARRIER`;

INSERT INTO `PHOTOGRAPHER` (`first_name`, `last_name`, `contact_info_id`, `photographer_type_id`) VALUES
('Alfred',   'Eisenstaedt', 1, 1),
('George',   'Silk',        2, 1),
('Margaret', 'Bourke-White',3, 1),
('W. Eugene','Smith',       4, 2),
('Robert',   'Capa',        5, 3);

INSERT INTO `PUBLICATION_PHOTOGRAPHER` (`publication_id`, `photographer_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(2, 1),
(2, 5),
(3, 4),
(4, 2),
(5, 3);

INSERT INTO `ASSIGNMENT_CARD` (`photographer_id`, `card_number`) VALUES
(1, 10001),
(1, 10002),
(2, 20001),
(3, 30001),
(4, 40001),
(4, 40002),
(5, 50001);

INSERT INTO `ESTATE` (`photographer_id`, `contact_info_id`, `relationship_type_id`, `first_name`, `last_name`) VALUES
(1, 6,  2, 'Jill',      'Eisenstaedt'),
(2, 7,  1, 'Marjorie',  'Silk'),
(3, 8,  5, 'Roger',     'White'),
(4, 9,  2, 'Aileen',    'Smith'),
(5, 10, 4, 'Bernard',   'Capa');

SELECT p.first_name, p.last_name, pt.type_name
FROM `PHOTOGRAPHER` p
JOIN `PHOTOGRAPHER_TYPE` pt ON p.photographer_type_id = pt.photographer_type_id;

SELECT e.first_name AS estate_contact, e.last_name, p.last_name AS photographer, ert.relationship_name
FROM `ESTATE` e
JOIN `PHOTOGRAPHER` p ON e.photographer_id = p.photographer_id
JOIN `ESTATE_RELATIONSHIP_TYPE` ert ON e.relationship_type_id = ert.relationship_type_id;

INSERT INTO `PHOTOGRAPHER_REQUESTER` (`photographer_id`, `date_requested`) VALUES
(1, '2024-01-10'),
(2, '2024-02-18'),
(4, '2024-03-05'),
(NULL, '2024-06-12'),
(5, '2024-08-01');

INSERT INTO `ESTATE_REQUESTER` (`estate_id`, `date_requested`) VALUES
(1, '2024-01-15'),
(3, '2024-02-20'),
(4, '2024-04-01'),
(5, '2024-06-15'),
(2, '2024-09-10');

INSERT INTO `RETURN_RECORD` (`estate_requester_id`, `photographer_requester_id`, `return_status_id`, `priority_level_id`, `date_started`, `google_drive_link`) VALUES
(1,    NULL, 5, 2, '2024-01-20', 'https://drive.google.com/drive/folders/abc123-eisenstaedt-return'),
(NULL, 2,    4, 3, '2024-02-25', 'https://drive.google.com/drive/folders/def456-silk-return'),
(2,    NULL, 3, 1, '2024-03-01', 'https://drive.google.com/drive/folders/ghi789-bourkewhite-return'),
(3,    3,    2, 2, '2024-04-10', 'https://drive.google.com/drive/folders/jkl012-smith-return'),
(4,    NULL, 1, 3, '2024-06-20', 'https://drive.google.com/drive/folders/mno345-capa-return');

SELECT rr.return_record_id, rs.status_name, pl.level_name, rr.date_started
FROM `RETURN_RECORD` rr
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id
JOIN `PRIORITY_LEVEL` pl ON rr.priority_level_id = pl.priority_level_id;

INSERT INTO `ASSIGNMENT` (`card_id`, `return_record_id`, `filing_place`, `assignment_title`, `assignment_description`, `year`, `grm_container_number`, `black_and_white_neg`, `color_transparency`, `notes`) VALUES
(1, 1, '10245',   'V-J Day Times Square',         'Sailor kissing nurse on Victory over Japan Day',                  '1945', 'V90001', 1, 0, 'Iconic image; handle with care'),
(2, 1, '10246-A', 'Sophia Loren at the Plaza',     'Portrait session at the Plaza Hotel',                            '1961', 'V90002', 1, 1, NULL),
(3, 2, '20387',   'Melbourne Olympics Coverage',    'Track and field events at 1956 Summer Games',                    '1956', 'V90103', 1, 1, 'Some frames water-damaged'),
(4, 3, '30510-A', 'Fort Peck Dam',                 'Construction of Fort Peck Dam for inaugural LIFE cover',         '1936', 'V90204', 1, 0, 'First ever LIFE magazine cover image'),
(5, 4, '40122',   'Country Doctor',                'Dr. Ernest Ceriani tending patients in Kremmling, Colorado',     '1948', 'V90305', 1, 0, 'Seminal photo essay'),
(6, 4, '40123-A', 'Minamata Disease Documentation','Mercury poisoning effects in Minamata, Japan',                   '1972', 'V90306', 1, 0, 'Sensitive content; estate restrictions apply'),
(7, 5, '50064',   'D-Day Omaha Beach',             'Allied landing at Normandy Beach, June 6 1944',                  '1944', 'V90407', 1, 0, 'Surviving frames from famous lost negatives');

INSERT INTO `ASSIGNMENT_NEGATIVE_TYPE` (`assignment_id`, `negative_type_id`) VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 1),
(3, 2),
(4, 1),
(5, 1),
(6, 1),
(6, 4),
(7, 1);

INSERT INTO `GRM_BARCODE` (`grm_barcode`, `assignment_id`) VALUES
(900001, 1),
(900002, 2),
(900003, 3),
(900004, 4),
(900005, 5),
(900006, 6),
(900007, 7);

SELECT a.assignment_id, a.assignment_title, a.filing_place, a.grm_container_number, ac.card_number, p.last_name AS photographer
FROM `ASSIGNMENT` a
JOIN `ASSIGNMENT_CARD` ac ON a.card_id = ac.card_id
JOIN `PHOTOGRAPHER` p ON ac.photographer_id = p.photographer_id;

SELECT a.assignment_title, nt.negative_type_name
FROM `ASSIGNMENT_NEGATIVE_TYPE` ant
JOIN `ASSIGNMENT` a ON ant.assignment_id = a.assignment_id
JOIN `NEGATIVE_TYPE` nt ON ant.negative_type_id = nt.negative_type_id;

INSERT INTO `SHIPMENT` (`return_record_id`, `carrier_id`, `confirm_status_id`, `tracking_number`, `ship_date`) VALUES
(1, 1, 1, 'FX-7742-0098-2024', '2024-03-10'),
(2, 2, 2, 'UPS-1Z999AA10124',  '2024-05-01'),
(3, NULL, NULL, 'PENDING',      NULL),
(4, 4, 4, 'DHL-2024-88431',    '2024-07-18'),
(5, NULL, NULL, 'PENDING',      NULL);

INSERT INTO `LEGAL_DOCUMENT` (`return_record_id`, `date_served`, `description`) VALUES
(3, '2024-02-28', 'Signed release form from Bourke-White estate executor authorizing return of all negatives'),
(4, '2024-04-05', 'Notarized letter from Aileen Smith requesting return of Minamata negatives'),
(4, '2024-04-05', 'Intellectual property transfer agreement for W. Eugene Smith estate'),
(5, '2024-06-18', 'Robert Capa Foundation legal request for D-Day negative return'),
(1, '2024-01-18', 'Estate affidavit confirming Jill Eisenstaedt as rightful heir to assignment materials');

SELECT s.shipment_id, c.carrier_name, s.tracking_number, s.ship_date, cs.signed_for, cs.date_signed
FROM `SHIPMENT` s
LEFT JOIN `CARRIER` c ON s.carrier_id = c.carrier_id
LEFT JOIN `CONFIRMATION_STATUS` cs ON s.confirm_status_id = cs.confirm_status_id;

SELECT ld.legal_doc_id, ld.date_served, ld.description, rs.status_name AS return_status
FROM `LEGAL_DOCUMENT` ld
JOIN `RETURN_RECORD` rr ON ld.return_record_id = rr.return_record_id
JOIN `RETURN_STATUS` rs ON rr.return_status_id = rs.return_status_id;