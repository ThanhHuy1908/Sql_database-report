
-- the output file and be sure to include the full path.This will start logging to the specified file.
spool 'C:\Users\thanh\Downloads\project2_thn.sql'

-- Send all input and output to the file.
set echo on


-- Thanh Huy Nguyen
-- INSY 3304-001
-- Project 2

-- DROP all tables (to start with a blank/empty database each time we run the file to avoid errors caused when trying to recreate tables that already exist)

DROP TABLE APPTDETAIL_thn;
DROP TABLE APPOINTMENT_thn;
DROP TABLE TREATMENT_thn;
DROP TABLE PATIENT_thn;
DROP TABLE BILLINGTYPE_thn CASCADE CONSTRAINTS;
DROP TABLE INSURANCECO_thn CASCADE CONSTRAINTS;
DROP TABLE PROVIDER_thn CASCADE CONSTRAINTS;
DROP TABLE APPTSTATUS_thn CASCADE CONSTRAINTS;
DROP TABLE PMTSTATUS_thn CASCADE CONSTRAINTS;
DROP TABLE BLOCKCODE_thn;


/* Part IA
CREATE the tables using the best data types, and create them in the proper order to
avoid referential integrity constraint violations (i.e., you cannot create
a table containing a FK until its PK table has already been created). */

CREATE TABLE BLOCKCODE_thn (
BlockCode VARCHAR(2),
BlockDesc 	VARCHAR(15) NOT NULL,
BlockMinutes 	NUMBER(10,2) NOT NULL,
PRIMARY KEY (BlockCode)
);

CREATE TABLE PMTSTATUS_thn (
PmtStatus VARCHAR(2),
PmtDes 		VARCHAR(50) NOT NULL,
PRIMARY KEY (PmtStatus)
);

CREATE TABLE APPTSTATUS_thn (
ApptStatusCode VARCHAR(15),
ApptStatusDesc	VARCHAR(50) NOT NULL,
PRIMARY KEY (ApptStatusCode)
);

CREATE TABLE PROVIDER_thn (
ProvID NUMBER(5),
ProvFName 	VARCHAR(15) NOT NULL,
ProvLName 	VARCHAR(15) NOT NULL,
PRIMARY KEY (ProvID)
);

CREATE TABLE INSURANCECO_thn (
InsCoID VARCHAR(5),
InsCoName 	VARCHAR(15) NOT NULL,
PRIMARY KEY (InsCoID)
);

CREATE TABLE BILLINGTYPE_thn (
BillingType VARCHAR(10),
BillingTypeDesc VARCHAR(15) NOT NULL,
PRIMARY KEY (BillingType)
);

CREATE TABLE PATIENT_thn (
PatientID NUMBER(5),
PatientFName 	VARCHAR(15) NOT NULL,
PatientLName 	VARCHAR(15) NOT NULL,
PatientPhone VARCHAR(15),
PRIMARY KEY (PatientID)
);

CREATE TABLE TREATMENT_thn (
TreatmentCode VARCHAR(5),
TreatmentDesc 	VARCHAR(50) NOT NULL,
TreatmentRate 	NUMBER(10,2)NOT NULL,
BlockCode 	VARCHAR(2) NOT NULL,
PRIMARY KEY (TreatmentCode),
FOREIGN KEY (BlockCode) REFERENCES BLOCKCODE_thn
);

CREATE TABLE APPOINTMENT_thn (
ApptID NUMBER(5),
ApptDate 	DATE NOT NULL,
ApptTime 	VARCHAR(20) NOT NULL,
PatientID 	NUMBER(5) NOT NULL,
BillingType 	VARCHAR(10) NOT NULL,
InsCoID 	VARCHAR(5),
ProvID 		NUMBER(5) NOT NULL,
ApptStatusCode 	VARCHAR(15) NOT NULL,
PmtStatus 	VARCHAR(2) NOT NULL,
PRIMARY KEY (ApptID) ,
FOREIGN KEY (PatientID) REFERENCES PATIENT_thn,
FOREIGN KEY (BillingType) REFERENCES BILLINGTYPE_thn,
FOREIGN KEY (InsCoID) REFERENCES INSURANCECO_thn(InsCoID),
FOREIGN KEY (ProvID) REFERENCES PROVIDER_thn(ProvID),
FOREIGN KEY (ApptStatusCode) REFERENCES APPTSTATUS_thn(ApptStatusCode),
FOREIGN KEY (PmtStatus) REFERENCES PMTSTATUS_thn(PmtStatus)
);

CREATE TABLE APPTDETAIL_thn (
ApptID NUMBER(5),
TreatmentCode VARCHAR(5),
PRIMARY KEY (ApptID, TreatmentCode),
FOREIGN KEY (ApptID) REFERENCES APPOINTMENT_thn,
FOREIGN KEY (TreatmentCode) REFERENCES TREATMENT_thn
);


/*Part IB Note: DESCRIBE is a utility statement, not an SQL statement, so there is no semi- colon at the end */
DESCRIBE BLOCKCODE_thn;
DESCRIBE PMTSTATUS_thn;
DESCRIBE APPTSTATUS_thn;
DESCRIBE PROVIDER_thn;
DESCRIBE INSURANCECO_thn;
DESCRIBE BILLINGTYPE_thn;
DESCRIBE PATIENT_thn;
DESCRIBE TREATMENT_thn;
DESCRIBE APPOINTMENT_thn;
DESCRIBE APPTDETAIL_thn;



-- Part IIA

-- Inserting sample data into BLOCKCODE_thn table
INSERT INTO BLOCKCODE_thn (BlockCode, BlockDesc, BlockMinutes) 
VALUES ('L1', 'Level 1', 15);
INSERT INTO BLOCKCODE_thn (BlockCode, BlockDesc, BlockMinutes) 
VALUES ('L2', 'Level 2', 20);
INSERT INTO BLOCKCODE_thn (BlockCode, BlockDesc, BlockMinutes) 
VALUES ('L3', 'Level 3', 30);
INSERT INTO BLOCKCODE_thn (BlockCode, BlockDesc, BlockMinutes) 
VALUES ('L4', 'Level 4', 60);

-- Inserting sample data into PMTSTATUS_thn table
INSERT INTO PMTSTATUS_thn (PmtStatus, PmtDes)
VALUES ('PD', 'Paid in Full');
INSERT INTO PMTSTATUS_thn (PmtStatus, PmtDes)
VALUES ('PP', 'Partial Payment');
INSERT INTO PMTSTATUS_thn (PmtStatus, PmtDes)
VALUES ('NP', 'Not Paid');

-- Inserting sample data into APPTSTATUS_thn table
INSERT INTO APPTSTATUS_thn (ApptStatusCode, ApptStatusDesc) 
VALUES ('CM', 'Complete');
INSERT INTO APPTSTATUS_thn (ApptStatusCode, ApptStatusDesc) 
VALUES ('CN', 'Confirmed');
INSERT INTO APPTSTATUS_thn (ApptStatusCode, ApptStatusDesc) 
VALUES ('NC', 'Not Confirmed');

-- Inserting sample data into PROVIDER_thn table
INSERT INTO PROVIDER_thn (ProvID, ProvFName, ProvLName)
VALUES (1, 'Kay', 'Jones');
INSERT INTO PROVIDER_thn (ProvID, ProvFName, ProvLName)
VALUES (2, 'Michael', 'Smith');
INSERT INTO PROVIDER_thn (ProvID, ProvFName, ProvLName)
VALUES (5, 'Janice', 'May');
INSERT INTO PROVIDER_thn (ProvID, ProvFName, ProvLName)
VALUES (3, 'Ray', 'Schultz');

-- Inserting sample data into INSURANCECO_thn table
INSERT INTO INSURANCECO_thn (InsCoID, InsCoName)
VALUES (210, 'State Farm');
INSERT INTO INSURANCECO_thn (InsCoID, InsCoName)
VALUES (323, 'Humana');
INSERT INTO INSURANCECO_thn (InsCoID, InsCoName)
VALUES (129, 'Blue Cross');
INSERT INTO INSURANCECO_thn (InsCoID, InsCoName)
VALUES (135, 'TriCare');

-- Inserting sample data into BILLINGTYPE_thn table
INSERT INTO BILLINGTYPE_thn (BillingType, BillingTypeDesc)
VALUES ('I', 'Insurance');
INSERT INTO BILLINGTYPE_thn (BillingType, BillingTypeDesc)
VALUES ('SP', 'Self-Pay');
INSERT INTO BILLINGTYPE_thn (BillingType, BillingTypeDesc)
VALUES ('WC', 'Worker''s Comp');

-- Inserting sample data into PATIENT_thn table
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (101, 'Wesley', 'Tanner', '(817)555-1193');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (100, 'Brenda', 'Rhodes', '(214)555-9191');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (15, 'Jeff', 'Miner', '(469)555-2301');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (77, 'Kim', 'Jackson', '(817)555-4911');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (119, 'Mary', 'Vaughn', '(817)555-2334');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (97, 'Chris', 'Mancha', '(469)555-3440');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (28, 'Renee', 'Walker', '(214)555-9285');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (105, 'Johnny', 'Redmond', '(214)555-1084');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (84, 'James', 'Clayton', '(214)555-9285');
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName, PatientPhone)
VALUES (23, 'Shelby', 'Davis', '(817)555-1198');

-- Inserting sample data into TREATMENT_thn table
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('NP', 'New Patient', 45, 'L1');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('GBP', 'General Back Pain', 60, 'L2');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('XR', 'X-Ray', 250, 'L2');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('PSF', 'Post-Surgery Follow Up', 30, 'L1');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('SR', 'Suture Removal', 50, 'L2');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('PT30', 'Physical Therapy 30', 60, 'L3');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('BI', 'Back Injury', 60, 'L2');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('PT60', 'Physical Therapy 60', 110, 'L4');
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('HP', 'Hip Pain', 60, 'L2');


-- Inserting sample data into APPOINTMENT_thn table

INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (101, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '09:00:00', 101, 'I', 323, 2, 'CM', 'PD');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (102, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '09:00:00', 100, 'I', 129, 5, 'CM', 'PP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (103, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '10:00:00', 15, 'SP', NULL, 2, 'CM', 'PD');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (104, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '10:30:00', 77, 'WC', 210, 1, 'CM', 'PD');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (105, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '10:30:00', 119, 'I', 129, 2, 'CM', 'PP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (106, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '10:30:00', 97, 'SP', NULL, 3, 'CM', 'NP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (107, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '11:30:00', 28, 'I', 129, 3, 'CN', 'PP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (108, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '11:30:00', 105, 'I', 323, 2, 'CN', 'NP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (109, TO_DATE('2024-02-19', 'YYYY-MM-DD'), '14:00:00', 84, 'I', 135, 5, 'CN', 'NP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (110, TO_DATE('2024-02-20', 'YYYY-MM-DD'), '08:30:00', 84, 'I', 135, 3, 'NC', 'NP');
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
VALUES (111, TO_DATE('2024-02-20', 'YYYY-MM-DD'), '08:30:00', 23, 'WC', 323, 5, 'CN', 'NP');

-- Inserting data into APPTDETAIL_thn table
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (101, 'NP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (101, 'GBP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (101, 'XR');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (102, 'PSF');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (102, 'SR');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (103, 'PSF');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (103, 'SR');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (104, 'PT30');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (105, 'NP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (105, 'BI');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (106, 'PT60');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (107, 'PT30');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (108, 'GBP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (109, 'PSF');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (109, 'SR');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (110, 'PT60');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (111, 'NP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (111, 'HP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (111, 'XR');

-- Commit the changes
COMMIT;

--Part IIB

-- SELECT statements for each table to list all contents
SELECT * FROM BLOCKCODE_thn;
SELECT * FROM PMTSTATUS_thn;
SELECT * FROM APPTSTATUS_thn;
SELECT * FROM PROVIDER_thn;
SELECT * FROM INSURANCECO_thn;
SELECT * FROM BILLINGTYPE_thn;
SELECT * FROM PATIENT_thn;
SELECT * FROM TREATMENT_thn;
SELECT * FROM APPOINTMENT_thn;
SELECT * FROM APPTDETAIL_thn;

-- Commit the changes 
COMMIT;

--Part III

-- Modify the phone number of Patient 100
UPDATE PATIENT_thn
SET PatientPhone = '2145551234'
WHERE PatientID = 100;

-- Add Patient 120 (Amanda Green, no phone number)
INSERT INTO PATIENT_thn (PatientID, PatientFName, PatientLName)
VALUES (120, 'Amanda', 'Green');

-- Add a treatment to the TREATMENT table
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('CI1', 'Cortizone Injection 1', 50.00, 'L1');

-- Add another treatment to the TREATMENT table
INSERT INTO TREATMENT_thn (TreatmentCode, TreatmentDesc, TreatmentRate, BlockCode)
VALUES ('CI2', 'Cortizone Injection 2', 100.00, 'L1');

-- Change the appointment date/time for Appt 108
UPDATE APPOINTMENT_thn
SET ApptDate = TO_DATE('2024-02-21', 'YYYY-MM-DD'), ApptTime = '09:00:00'
WHERE ApptID = 108;

-- Change the billing type of Appt 107 to WC
UPDATE APPOINTMENT_thn
SET BillingType = 'WC'
WHERE ApptID = 107;

-- Add a new appointment (ApptID 112)
INSERT INTO APPOINTMENT_thn (ApptID, ApptDate, ApptTime, PatientID, BillingType, ProvID, ApptStatusCode, PmtStatus)
VALUES (112, TO_DATE('2024-02-21', 'YYYY-MM-DD'), '09:00:00', 120, 'SP', 2, 'NC', 'NP');

-- Add treatment codes for Appt 112 to the APPTDETAIL table
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (112, 'NP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (112, 'HP');
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (112, 'CI2');

-- Delete the treatment code 'BI' from Appt 105
DELETE FROM APPTDETAIL_thn
WHERE ApptID = 105 AND TreatmentCode = 'BI';

-- Add the treatment code 'GBP' for Appt 105
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES (105, 'GBP');

-- Commit the changes to make them permanent
COMMIT;

/* Part IV
Retrieve all data from each table and sort by the PK */

SELECT * FROM BLOCKCODE_thn
ORDER BY BlockCode;

SELECT * FROM BILLINGTYPE_thn
ORDER BY BillingType;

SELECT * FROM INSURANCECO_thn
ORDER BY InsCoID;

SELECT * FROM PROVIDER_thn
ORDER BY ProvID;

SELECT * FROM APPTSTATUS_thn
ORDER BY ApptStatusCode;

SELECT * FROM PMTSTATUS_thn
ORDER BY PmtStatus;

SELECT * FROM TREATMENT_thn
ORDER BY TreatmentCode;

SELECT * FROM PATIENT_thn
ORDER BY PatientID;

SELECT * FROM APPOINTMENT_thn
ORDER BY ApptID;

SELECT * FROM APPTDETAIL_thn
ORDER BY ApptID, TreatmentCode;



-- Turn off logging to the txt file
set echo off

-- CLose the txt file
spool off
