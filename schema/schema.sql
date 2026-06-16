CREATE DATABASE `LIFE_assignment_return_system`;

USE `LIFE_assignment_return_system`;

CREATE TABLE `PHOTOGRAPHER_TYPE` (
   `photographer_type_id` INT NOT NULL AUTO_INCREMENT,
   `type_name` VARCHAR(50) NOT NULL,
   PRIMARY KEY (`photographer_type_id`)
);


CREATE TABLE `PUBLICATION` (
   `publication_id` INT NOT NULL AUTO_INCREMENT,
   `publication_name` VARCHAR(100) NOT NULL,
   PRIMARY KEY (`publication_id`)
);


CREATE TABLE `CONTACT_INFO` (
   `contact_info_id` INT NOT NULL AUTO_INCREMENT,
   `street_address` VARCHAR(255),
   `city` VARCHAR(100),
   `state` VARCHAR(100),
   `zip_code` VARCHAR(20),
   `country` VARCHAR(100),
   `phone` VARCHAR(30),
   `email` VARCHAR(255),
   `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`contact_info_id`)
);


CREATE TABLE `NEGATIVE_TYPE` (
   `negative_type_id` INT NOT NULL AUTO_INCREMENT,
   `negative_type_name` VARCHAR(50) NOT NULL,
   `negative_type_description` VARCHAR(255),
   PRIMARY KEY (`negative_type_id`)
);


CREATE TABLE `ESTATE_RELATIONSHIP_TYPE` (
   `relationship_type_id` INT NOT NULL AUTO_INCREMENT,
   `relationship_name` VARCHAR(100) NOT NULL,
   `relationship_description` VARCHAR(250),
   PRIMARY KEY (`relationship_type_id`)
);


CREATE TABLE `RETURN_STATUS` (
   `return_status_id` INT NOT NULL AUTO_INCREMENT,
   `status_name` VARCHAR(50) NOT NULL,
   `status_description` VARCHAR(255),
   PRIMARY KEY (`return_status_id`)
);


CREATE TABLE `PRIORITY_LEVEL` (
   `priority_level_id` INT NOT NULL AUTO_INCREMENT,
   `level_name` VARCHAR(50) NOT NULL,
   `level_description` VARCHAR(255),
   PRIMARY KEY (`priority_level_id`)
);


CREATE TABLE `CONFIRMATION_STATUS` (
   `confirm_status_id` INT NOT NULL AUTO_INCREMENT,
   `signed_for` BOOLEAN NOT NULL DEFAULT 0,
   `date_signed` TIMESTAMP,
   PRIMARY KEY (`confirm_status_id`)
);


CREATE TABLE `CARRIER` (
   `carrier_id` INT NOT NULL AUTO_INCREMENT,
   `carrier_name` VARCHAR(100) NOT NULL,
   PRIMARY KEY (`carrier_id`)
);


CREATE TABLE `PHOTOGRAPHER` (
   `photographer_id` INT NOT NULL AUTO_INCREMENT,
   `first_name` VARCHAR(100) NOT NULL,
   `last_name` VARCHAR(100) NOT NULL,
   `contact_info_id` INT,
   `photographer_type_id` INT NOT NULL,
   PRIMARY KEY (`photographer_id`),
   FOREIGN KEY (`contact_info_id`) REFERENCES `CONTACT_INFO` (`contact_info_id`),
   FOREIGN KEY (`photographer_type_id`) REFERENCES `PHOTOGRAPHER_TYPE` (`photographer_type_id`)
);


CREATE TABLE `PUBLICATION_PHOTOGRAPHER` (
   `publication_id`   INT NOT NULL,
   `photographer_id`  INT NOT NULL,
   PRIMARY KEY (`publication_id`, `photographer_id`),
   FOREIGN KEY (`publication_id`) REFERENCES `PUBLICATION` (`publication_id`),
   FOREIGN KEY (`photographer_id`) REFERENCES `PHOTOGRAPHER` (`photographer_id`)
);


CREATE TABLE `ASSIGNMENT_CARD` (
   `card_id` INT NOT NULL AUTO_INCREMENT,
   `photographer_id` INT NOT NULL,
   `card_number` INT NOT NULL,
   PRIMARY KEY (`card_id`),
   FOREIGN KEY (`photographer_id`) REFERENCES `PHOTOGRAPHER` (`photographer_id`)
);


CREATE TABLE `ESTATE` (
   `estate_id` INT NOT NULL AUTO_INCREMENT,
   `photographer_id` INT NOT NULL,
   `contact_info_id` INT,
   `relationship_type_id` INT NOT NULL,
   `first_name` VARCHAR(100) NOT NULL,
   `last_name` VARCHAR(100) NOT NULL,
   `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`estate_id`),
   FOREIGN KEY (`photographer_id`) REFERENCES `PHOTOGRAPHER` (`photographer_id`),
   FOREIGN KEY (`contact_info_id`) REFERENCES `CONTACT_INFO` (`contact_info_id`),
   FOREIGN KEY (`relationship_type_id`) REFERENCES `ESTATE_RELATIONSHIP_TYPE` (`relationship_type_id`)
);


CREATE TABLE `PHOTOGRAPHER_REQUESTER` (
   `photographer_requester_id` INT NOT NULL AUTO_INCREMENT,
   `photographer_id` INT NULL,
   `date_requested` DATE NOT NULL,
   PRIMARY KEY (`photographer_requester_id`),
   FOREIGN KEY (`photographer_id`) REFERENCES `PHOTOGRAPHER` (`photographer_id`)
);


CREATE TABLE `ESTATE_REQUESTER` (
   `estate_requester_id` INT NOT NULL AUTO_INCREMENT,
   `estate_id`           INT NOT NULL,
   `date_requested` DATE NOT NULL,
   PRIMARY KEY (`estate_requester_id`),
   FOREIGN KEY (`estate_id`) REFERENCES `ESTATE` (`estate_id`)
);


CREATE TABLE `RETURN_RECORD` (
   `return_record_id` INT NOT NULL AUTO_INCREMENT,
   `estate_requester_id` INT,
   `photographer_requester_id` INT,
   `return_status_id` INT NOT NULL,
   `priority_level_id` INT NOT NULL,
   `date_started` DATE NOT NULL,
   `google_drive_link` VARCHAR(500) NOT NULL,
   `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`return_record_id`),
   FOREIGN KEY (`estate_requester_id`) REFERENCES `ESTATE_REQUESTER` (`estate_requester_id`),
   FOREIGN KEY (`photographer_requester_id`) REFERENCES `PHOTOGRAPHER_REQUESTER` (`photographer_requester_id`),
   FOREIGN KEY (`return_status_id`) REFERENCES `RETURN_STATUS` (`return_status_id`),
   FOREIGN KEY (`priority_level_id`) REFERENCES `PRIORITY_LEVEL` (`priority_level_id`)
);


CREATE TABLE `ASSIGNMENT` (
   `assignment_id` INT NOT NULL AUTO_INCREMENT,
   `card_id` INT  NOT NULL,
   `return_record_id` INT NOT NULL,
   `filing_place` VARCHAR(50) NOT NULL,
   `assignment_title` VARCHAR(255) NOT NULL,
   `assignment_description` VARCHAR(500),
   `year` YEAR NOT NULL,
   `grm_container_number` VARCHAR(50),
   `black_and_white_neg` BOOLEAN,
   `color_transparency`  BOOLEAN,
   `notes` TEXT,
   `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`assignment_id`),
   FOREIGN KEY (`card_id`) REFERENCES `ASSIGNMENT_CARD` (`card_id`),
   FOREIGN KEY (`return_record_id`) REFERENCES `RETURN_RECORD` (`return_record_id`)
);


CREATE TABLE `ASSIGNMENT_NEGATIVE_TYPE` (
   `assignment_id`    INT NOT NULL,
   `negative_type_id` INT NOT NULL,
   PRIMARY KEY (`assignment_id`, `negative_type_id`),
   FOREIGN KEY (`assignment_id`) REFERENCES `ASSIGNMENT` (`assignment_id`),
   FOREIGN KEY (`negative_type_id`) REFERENCES `NEGATIVE_TYPE` (`negative_type_id`)
);


CREATE TABLE `GRM_BARCODE` (
   `grm_barcode` INT NOT NULL,
   `assignment_id` INT NOT NULL,
   PRIMARY KEY (`grm_barcode`),
   FOREIGN KEY (`assignment_id`) REFERENCES `ASSIGNMENT` (`assignment_id`)
);


CREATE TABLE `SHIPMENT` (
   `shipment_id` INT NOT NULL AUTO_INCREMENT,
   `return_record_id` INT NOT NULL,
   `carrier_id` INT NULL,
   `confirm_status_id` INT NULL,
   `tracking_number` VARCHAR(100) NOT NULL,
   `ship_date` DATE,
   PRIMARY KEY (`shipment_id`),
   FOREIGN KEY (`return_record_id`) REFERENCES `RETURN_RECORD` (`return_record_id`),
   FOREIGN KEY (`carrier_id`) REFERENCES `CARRIER` (`carrier_id`),
   FOREIGN KEY (`confirm_status_id`) REFERENCES `CONFIRMATION_STATUS` (`confirm_status_id`)
);


CREATE TABLE `LEGAL_DOCUMENT` (
   `legal_doc_id` INT NOT NULL AUTO_INCREMENT,
   `return_record_id` INT NULL,
   `date_served` DATE NOT NULL,
   `description` VARCHAR(500),
   PRIMARY KEY (`legal_doc_id`),
   FOREIGN KEY (`return_record_id`) REFERENCES `RETURN_RECORD` (`return_record_id`)
);
