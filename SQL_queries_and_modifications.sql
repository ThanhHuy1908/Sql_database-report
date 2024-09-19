--Create the output file and start logging
--If using Oracle 18c or 21c, be sure to include the path to the directory where you want the .txt to be saved. If using Oracle on Omega, do not include a directory path.

start 'C:\Users\thanh\Downloads\3304_Project3Starter_thn'
spool 'C:\Users\thanh\Downloads\3304_Project3_thn.txt'
set echo on

--Project 2 Solution
--INSY 3304-001
--Project 2


-- PART II

-- Change the session date format to include the time using the following command:
ALTER SESSION SET nls_date_format='MM/DD/YYYY HH12:MI AM' ;

-- 2. Add the necessary commands to make sure all column headings show in their entirety--no column headings should be truncated.
COLUMN PmtDesc FORMAT A15
COLUMN ApptStatusDesc FORMAT A15
COLUMN ProviderFName FORMAT A15
COLUMN ProviderLName FORMAT A15
COLUMN InsCoName FORMAT A20
COLUMN BillingTypeDesc FORMAT A15
COLUMN BlockDesc FORMAT A10
COLUMN PatientFName FORMAT A15
COLUMN PatientLName FORMAT A15
COLUMN TreatmentDesc FORMAT A25

-- 3. Line size should be set to at least 150 and no more than 200 to minimize column wrapping.
SET LINESIZE 175

-- 4. Table aliases and dot notation should be used properly where applicable.Note: This will be done throughout various statement in Part III.

-- 5. Change the TreatmentDesc to “Cortizone Injection 2” for TreatmentCode CI2.
UPDATE TREATMENT_thn
SET TreatmentDesc = 'Cortizone Injection 2'
WHERE TreatmentCode = 'CI2';

-- 6. Change the ApptStatus to “NC” for Appointment 109.
UPDATE APPOINTMENT_thn
SET ApptStatusCode = 'NC'
WHERE ApptID = 109;

-- 7. Change the ApptStatus to “CM” and the PmtStatus to “PD” for Appointment 107.
UPDATE APPOINTMENT_thn
SET ApptStatusCode = 'CM',
    PmtStatus = 'PD'
WHERE ApptID = 107;

-- 8. Add a new Appointment. Generate the ApptID by incrementing the max ApptID by 1.
INSERT INTO APPOINTMENT_thn (ApptID, ApptDateTime, PatientID, BillingType, InsCoID, ProvID, ApptStatusCode, PmtStatus)
SELECT MAX(ApptID) + 1, TO_DATE('02/21/2024 10:00AM', 'MM/DD/YYYY HH:MIAM'), 105, 'I', 323, 3, 'NC', 'NP'
FROM APPOINTMENT_thn;

-- Add treatment code PT60 to the Appointment above.
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_thn),'PT60');

-- 9. Add a new Appointment. Generate the ApptID by incrementing the max ApptID by 1.
INSERT INTO APPOINTMENT_thn (ApptID, ApptDateTime, PatientID, BillingType, ProvID, ApptStatusCode, PmtStatus)
VALUES ((SELECT MAX(ApptID) + 1 FROM APPOINTMENT_thn), TO_DATE('02/22/2024 10:00AM', 'MM/DD/YYYY HH:MIAM'), 15, 'SP', 2, 'NC', 'NP');

-- Add treatment code PSF to the Appointment above
INSERT INTO APPTDETAIL_thn (ApptID, TreatmentCode)
VALUES ((SELECT MAX(ApptID) FROM APPOINTMENT_thn), 'PSF');

-- 10. Change the phone number for Patient 15 to 817-555-8918.
UPDATE PATIENT_thn
SET PatientPhone = '817-555-8918'
WHERE PatientID = 15;

-- 11. Commit all changes above.
COMMIT;

-- PART III

-- 1. List the patient ID, first name, last name, and phone number for all patients. Combine the first and last name into one column (include a space between them). Sort by last name in ascending order, and use the following column headings: Patient ID, Patient Name, Phone.

SELECT PatientID AS "Patient ID",
       PatientFName || ' ' || PatientLName AS "Patient Name",
       '(' || SUBSTR(PatientPhone, 1, 3) || ') ' || SUBSTR(PatientPhone, 4, 3) || '-' || SUBSTR(PatientPhone, 7, 4) AS "Phone"
FROM PATIENT_thn
ORDER BY PatientLName;


-- 2. List the block code, treatment code, treatment description, and treatment rate for all rows in the Treatment table. Sort by block code then by treatment code, both in ascending order. Format the rate as currency. Use the following column headings: Block_Code, Treatment_Code, Treatment_Desc, Rate.

SELECT BlockCode AS "Block_Code",
       TreatmentCode AS "Treatment_Code",
       TreatmentDesc AS "Treatment_Desc",
       TO_CHAR(TreatmentRate, '$9999.99') AS "Rate"
FROM TREATMENT_thn
ORDER BY BlockCode, TreatmentCode;


-- 3. For all appointments, list the appointment ID, appointment date and time, patient ID, patient first and last name (in one column), patient phone number, and provider first and last name (in one column). Sort by appointment ID in ascending order. Format the date/time with a 2-digit year and a comma between the date and time (e.g., ‘01/01/24, 10:00AM’). Format the phone number as ‘(###) ###-####’ by using concatenation and the SUBSTR function. Use the following column headings: ApptID, Date/Time, Patient, Phone, Provider.

SELECT A.ApptID AS "ApptID",
       TO_CHAR(A.ApptDateTime, 'MM/DD/YY, HH:MIAM') AS "Date/Time",
       P.PatientFName || ' ' || P.PatientLName AS "Patient",
       '(' || SUBSTR(P.PatientPhone, 1, 3) || ') ' || SUBSTR(P.PatientPhone, 4, 3) || '-' || SUBSTR(P.PatientPhone, 7, 4) AS "Phone",
       PR.ProviderFName || ' ' || PR.ProviderLName AS "Provider"
FROM APPOINTMENT_thn A
JOIN PATIENT_thn P ON A.PatientID = P.PatientID
JOIN PROVIDER_thn PR ON A.ProvID = PR.ProvID
ORDER BY A.ApptID;



-- 4. List the appointment ID, treatment code, treatment description, block code, block code description, block minutes, and treatment rate for the treatment code(s) with the highest rate in each appointment. Use the following column headings: ApptID, TreatCode, TreatDesc, BlockCode, BlockCodeDesc, Minutes, Rate.

SELECT APPTDETAIL_thn.ApptID AS "ApptID",
       T.TreatmentCode AS "TreatCode",
       T.TreatmentDesc AS "TreatDesc",
       T.BlockCode AS "BlockCode",
       B.BlockDesc AS "BlockCodeDesc",
       B.BlockMinutes AS "Minutes",
       TO_CHAR(T.TreatmentRate, '$9999.99') AS "Rate"
FROM (
    SELECT AD.ApptID AS ApptID,
           MAX(TreatmentRate) AS MaxRate
    FROM APPTDETAIL_thn AD
    JOIN TREATMENT_thn T ON AD.TreatmentCode = T.TreatmentCode
    GROUP BY AD.ApptID
) MaxRates
JOIN APPTDETAIL_thn ON MaxRates.ApptID = APPTDETAIL_thn.ApptID
JOIN TREATMENT_thn T ON APPTDETAIL_thn.TreatmentCode = T.TreatmentCode AND T.TreatmentRate = MaxRates.MaxRate
JOIN BLOCKCODE_thn B ON T.BlockCode = B.BlockCode;



-- 5. List the appointment ID, treatment desc, and rate for the treatment with the highest rate in appointment 111. Show the rate formatted as currency, and use the following column headings: ApptID, Treatment, Rate.

SELECT AD.ApptID AS "ApptID",
       T.TreatmentDesc AS "Treatment",
       TO_CHAR(MAX(T.TreatmentRate), '$9999.99') AS "Rate"
FROM APPTDETAIL_thn AD
JOIN TREATMENT_thn T ON AD.TreatmentCode = T.TreatmentCode
WHERE AD.ApptID = 111
GROUP BY AD.ApptID, T.TreatmentDesc;


-- 6. List the block code, block description, block minutes, and the count of treatment codes associated with each block code. Sort by treatment code count in ascending order. Use the following column headings: BlockCode, Description, Minutes, TreatmentCount.

SELECT BC.BlockCode AS "BlockCode",
       BC.BlockDesc AS "Description",
       BC.BlockMinutes AS "Minutes",
       COUNT(T.TreatmentCode) AS "TreatmentCount"
FROM BLOCKCODE_thn BC
LEFT JOIN TREATMENT_thn T ON BC.BlockCode = T.BlockCode
GROUP BY BC.BlockCode, BC.BlockDesc, BC.BlockMinutes
ORDER BY COUNT(T.TreatmentCode);


-- 7. List the provider ID, provider first name, provider last name, and count of appointments for each provider. Sort by count in descending order. Use the following column headings: Provider ID, First Name, Last Name, Appt Count.

SELECT A.ProvID AS "Provider ID",
       PR.ProviderFName AS "First Name",
       PR.ProviderLName AS "Last Name",
       COUNT(A.ApptID) AS "Appt Count"
FROM APPOINTMENT_thn A
JOIN PROVIDER_thn PR ON A.ProvID = PR.ProvID
GROUP BY A.ProvID, PR.ProviderFName, PR.ProviderLName
ORDER BY "Appt Count" DESC;


-- 8. For each appointment, list the patient ID, patient last name, appointment ID, appointment date (without the time), and provider last name. Sort in ascending order by patient ID. Use the following column headings: Patient ID, Last Name, Appt ID, Appt Date, Provider.

SELECT A.PatientID AS "Patient ID",
       P.PatientLName AS "Last Name",
       A.ApptID AS "Appt ID",
       TO_CHAR(A.ApptDateTime, 'MM/DD/YY') AS "Appt Date",
       PR.ProviderLName AS "Provider"
FROM APPOINTMENT_thn A
JOIN PATIENT_thn P ON A.PatientID = P.PatientID
JOIN PROVIDER_thn PR ON A.ProvID = PR.ProvID
ORDER BY A.PatientID;


-- 9. For each appointment, list the appointment ID, appointment date/time, count of treatment codes, and total rate charged.  Sort by total charge then by appointment ID, both in descending order. Format the rate as currency. Use the following column headings: ApptID, Date/Time, TreatmentCount, TotalCharge.

SELECT 
    A.ApptID AS "ApptID",
    A.ApptDateTime AS "Date/Time",
    COUNT(AD.TreatmentCode) AS "TreatmentCount",
    TO_CHAR(SUM(T.TreatmentRate), '$9999.99') AS "TotalCharge"
FROM 
    APPOINTMENT_thn A
JOIN 
    APPTDETAIL_thn AD ON A.ApptID = AD.ApptID
JOIN 
    TREATMENT_thn T ON AD.TreatmentCode = T.TreatmentCode
GROUP BY 
    A.ApptID, A.ApptDateTime
ORDER BY 
    SUM(T.TreatmentRate) DESC, A.ApptID DESC;

-- 10. List the treatment code, treatment description, and count of appointments for each treatment code. Use the following column headings: TreatmentCode, Description, ApptCount. 

SELECT 
    T.TreatmentCode AS "TreatmentCode",
    T.TreatmentDesc AS "Description",
    COUNT(A.ApptID) AS "ApptCount"
FROM 
    TREATMENT_thn T
LEFT OUTER JOIN 
    APPTDETAIL_thn AD ON T.TreatmentCode = AD.TreatmentCode
LEFT OUTER JOIN 
    APPOINTMENT_thn A ON AD.ApptID = A.ApptID
GROUP BY 
    T.TreatmentCode, T.TreatmentDesc
ORDER BY 
    T.TreatmentCode;


-- 11. List the provider ID, provider first name and last name (combined into one column), and total rate charged by each provider. Format the total rate as currency. Sort by total rate in descending order. Use the following column headings: Provider ID, Name, Total Charges.

SELECT
    PROVIDER_thn.ProvID AS "Provider ID",
    PROVIDER_thn.ProviderFName || ' ' || PROVIDER_thn.ProviderLName AS "Name",
    TO_CHAR(SUM(TREATMENT_thn.TreatmentRate), '$99999.99') AS "Total Charges"
FROM
    PROVIDER_thn
JOIN
    APPOINTMENT_thn ON PROVIDER_thn.ProvID = APPOINTMENT_thn.ProvID
JOIN
    APPTDETAIL_thn ON APPOINTMENT_thn.ApptID = APPTDETAIL_thn.ApptID
JOIN
    TREATMENT_thn ON APPTDETAIL_thn.TreatmentCode = TREATMENT_thn.TreatmentCode
GROUP BY
    PROVIDER_thn.ProvID, PROVIDER_thn.ProviderFName, PROVIDER_thn.ProviderLName
ORDER BY
    SUM(TREATMENT_thn.TreatmentRate) DESC;



-- 12. List the appointment ID, appointment date/time, and total rate charged for each appointment that has been paid in full. Format the total rate as currency. Sort by total rate charged in descending order. Use the following column headings: Appt ID, Date/Time, Amt Paid.

SELECT A.ApptID AS "Appt ID",
       A.ApptDateTime AS "Date/Time",
       TO_CHAR(SUM(T.TreatmentRate), '$9999.99') AS "Amt Paid"
FROM APPOINTMENT_thn A
JOIN APPTDETAIL_thn AD ON A.ApptID = AD.ApptID
JOIN TREATMENT_thn T ON AD.TreatmentCode = T.TreatmentCode
WHERE A.PmtStatus = 'PD'
GROUP BY A.ApptID, A.ApptDateTime
ORDER BY SUM(T.TreatmentRate) DESC;

-- 13. List the percentage of appointments that are assigned to an insurance company. Format the percentage as ##.#% (e.g., 24.7%). Use the following column headin: Percentage with Insurance.

SELECT
    TO_CHAR(COUNT(CASE WHEN InsCoID IS NOT NULL THEN 1 END) / COUNT(*) * 100, 'FM999.9') || '%' AS "Percentage with Insurance"
FROM
    APPOINTMENT_thn;

-- 14. List the average rate charged for all treatment codes in the treatment code table, formatted as currency. Use Avg_Rate as the column heading.

SELECT TO_CHAR(AVG(TreatmentRate), '$9999.99') AS "Avg_Rate"
FROM TREATMENT_thn;

-- 15. List the appointment ID, appointment date, patient last name, and total minutes for each appointment. Format the total minutes as ‘## Minutes’ (e.g., 25 Minutes). Sort by appointment date and use the following column headings: ApptID, Date, Patient, Duration.

SELECT
    A.ApptID AS "ApptID",
    TO_CHAR(A.ApptDateTime, 'MM/DD/YYYY') AS "Date",
    P.PatientLName AS "Patient",
    TO_CHAR(COUNT(AD.TreatmentCode) * 25, 'FM00') || ' Minutes' AS "Duration"
FROM
    APPOINTMENT_thn A
JOIN
    PATIENT_thn P ON A.PatientID = P.PatientID
JOIN
    APPTDETAIL_thn AD ON A.ApptID = AD.ApptID
GROUP BY
    A.ApptID, A.ApptDateTime, P.PatientLName
ORDER BY
    A.ApptDateTime;





-- 16. List the appointment ID, treatment code, treatment description, block minutes, and rate of the treatment with the lowest rate in each appointment. Format the rate as currency and use the following column headings: ApptID, TreatmentCode, Description, Minutes, Rate.

SELECT
    A.ApptID AS "ApptID",
    TD.TreatmentCode AS "TreatmentCode",
    TD.TreatmentDesc AS "Description",
    TD.BlockCode AS "Block Code",
    TO_CHAR(MR.min_rate, '$9999.99') AS "Rate"
FROM
    APPOINTMENT_thn A
JOIN
    APPTDETAIL_thn AD ON A.ApptID = AD.ApptID
JOIN
    TREATMENT_thn TD ON AD.TreatmentCode = TD.TreatmentCode
JOIN
    (
        SELECT
            AD.ApptID,
            MIN(TT.TreatmentRate) AS min_rate
        FROM
            APPTDETAIL_thn AD
        JOIN
            TREATMENT_thn TT ON AD.TreatmentCode = TT.TreatmentCode
        GROUP BY
            AD.ApptID
    ) MR ON A.ApptID = MR.ApptID
JOIN
    TREATMENT_thn TT ON MR.min_rate = TT.TreatmentRate
ORDER BY
    A.ApptID;


-- 17. List the treatment code, treatment description, block minutes, and rate for the treatments with a rate greater than the average treatment rate. Format the price as currency. Use the following column headings: Treatment Code, Description, Minutes, Rate.

SELECT
    TreatmentCode AS "Treatment Code",
    TreatmentDesc AS "Description",
    BlockCode AS "Minutes",
    TO_CHAR(TreatmentRate, '$9999.99') AS "Rate"
FROM
    TREATMENT_thn
WHERE
    TreatmentRate > (SELECT AVG(TreatmentRate) FROM TREATMENT_thn);



-- 18. List the appointment ID, appointment date, patient ID, patient last name, and patient phone number for all appointments on or before 2/20/24. Sort by appointment date then by patient ID, both in ascending order. Format the date as “mm-dd-yyyy” (no time) and use the following column headings: ApptID, Date, PatientID, Name, Phone.

SELECT
    A.ApptID AS "ApptID",
    TO_CHAR(A.ApptDateTime, 'MM-DD-YYYY') AS "Date",
    A.PatientID AS "PatientID",
    P.PatientFName || ' ' || P.PatientLName AS "Name",
    P.PatientPhone AS "Phone"
FROM
    APPOINTMENT_thn A
JOIN
    PATIENT_thn P ON A.PatientID = P.PatientID
WHERE
    TRUNC(A.ApptDateTime) <= TO_DATE('2024-02-20', 'YYYY-MM-DD')
ORDER BY
    TO_CHAR(A.ApptDateTime, 'MM-DD-YYYY'), A.PatientID;


-- 19. List the patient ID, first name, last name, and phone number of all patients whose first or last names start with the letter ‘J’ and sort by patient ID. Format the phone number as ‘###-###-####’ using concatenation and the SUBSTR function. Use the following column headings: PatientID, First Name, Last Name, Phone.

SELECT 
    PatientID AS "PatientID",
    PatientFName AS "First Name",
    PatientLName AS "Last Name",
    SUBSTR(PatientPhone, 1, 3) || '-' || SUBSTR(PatientPhone, 4, 3) || '-' || SUBSTR(PatientPhone, 7) AS "Phone"
FROM 
    PATIENT_thn
WHERE 
    PatientFName LIKE 'J%' OR PatientLName LIKE 'J%'
ORDER BY 
    PatientID;

-- 20. List the appointment status code, status description, and count of appointments for each status. Sort by count of appointments in descending order, and use the following column headings: Status Code, Description, Appt Count.

SELECT
    AS_status.ApptStatusCode AS "Status Code",
    AS_status.ApptStatusDesc AS "Description",
    COUNT(*) AS "Appt Count"
FROM
    APPOINTMENT_thn AT
JOIN
    APPTSTATUS_thn AS_status
        ON AT.ApptStatusCode = AS_status.ApptStatusCode
GROUP BY
    AS_status.ApptStatusCode, AS_status.ApptStatusDesc
ORDER BY
    COUNT(*) DESC;




--Stop logging to the output file
set echo off

--Close and save the output file
spool off


