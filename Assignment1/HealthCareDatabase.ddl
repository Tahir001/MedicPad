/*
Assignment 1
University of Toronto | CSC343 - Managing Databases with SQL 

Completed by:
Tahir Muhammad  
Charbel El-Feghali 

Implementation of the Health Car Industry Database. 

Below is our List of Assumptions which was used to create the ER diagram, and the DDL file. 

- Assumption 1: Date of birth would be a string
- Assumption 2: Postal code has 6 digits (North American)
- Assumption 3: Phone number would be 10 digits (North American)
- Assumption 4: Primary Key of Person is inherited by IS-A relationship, but we renamed them again (accordingly) in those tables for convenience
		a) Person IS A Nurse is now represented by NurseId in Nurse entity.
		b) Person IS A Patient is now represented by PatientId in Patient entity.
		c) Person IS A Physician is now represented by PhysicianId in Physician entity.
- Assumption 5: A postal code for a specific city is unique.
- Assumption 6: We assume that a doctor would only be able to see the same patient once.
- Assumption 7: We assume that dateTime is extremely specific, down to a millisecond.
		Hence, no two patients will ever be diagnosed at exactly the same time. (or the doctors assigning the patients)
- Assumption 8: If a patient is no longer a patient, their admit date (& data) should stay in the record for the next 5 years
- Assumption 9: If a hospital burns down/shuts down, the medical department of it is also shut down
- Assumption 10: If a person dies, their telephone number (work, home, Cell) would stay the same until re-assigned.
- Assumption 11: Assuming that multiple patients can be admitted at the same time.
- Assumption 12: A physician can only have 1 medicalSpeciality.
- Assumption 13: A patient cant undergo more than 1 medical test at the same time.
- Assumption 14: Bridge table to create a link between any of the other tables, to get required info as needed.
- Assumption 15: Any dollar amount is in Canadian dollars. (For example salaries, Fee, budgets).
*/

# ------------------------------------- SQL DDL Script ------------------------------------- #



# Use of Assumption 1
CREATE TABLE IF NOT EXISTS Person (
PersonId VARCHAR(255) NOT NULL,
DateOfBirth VARCHAR(255),
Gender VARCHAR(10),
PRIMARY KEY (PersonId)
);

# Use of Assumption 5.
# This is a Weak Entity
CREATE TABLE IF NOT EXISTS Address(
PersonId VARCHAR(255) NOT NULL,
Street VARCHAR(50),
City VARCHAR(50),
Province VARCHAR(50),
PostalCode VARCHAR(6),
PRIMARY KEY (PersonId, Street, City, Province, PostalCode),
FOREIGN KEY (PersonId)
REFERENCES Person(PersonId)
ON DELETE CASCADE
ON UPDATE CASCADE
);


FOREIGN KEY (HospitalName)
REFERENCES Hospital(HospitalName)
ON DELETE CASCADE
ON UPDATE CASCADE,
/*If a person dies, there phone number stays i.e So set to null If a persons id is updated, shud reflected the updated id */

CREATE TABLE IF NOT EXISTS TelephoneNumber(
Number VARCHAR(10) NOT NULL,
PersonId VARCHAR(255),
ContactType VARCHAR(20) NOT NULL,
PRIMARY KEY (Number),
FOREIGN KEY(PersonId) 
REFERENCES Person(PersonId) 
ON DELETE SET NULL 
ON UPDATE CASCADE
);

# Use of Assumption 4a
CREATE TABLE IF NOT EXISTS Nurse (
NurseId VARCHAR(255) NOT NULL,
YearlySalaryCAD INT,
YearsInPractice INT,
CHECK (YearlySalaryCAD>=0),
CHECK (YearsInPractive>=0),
PRIMARY KEY (NurseId)
);

# Use of Assumption 4b
CREATE TABLE IF NOT EXISTS Patient (
PatientId VARCHAR(255) NOT NULL,
HealthInsurance VARCHAR(20),
PRIMARY KEY (PatientId)
);

# Use of Assumption 4c
CREATE TABLE IF NOT EXISTS Physician (
PhysicianId VARCHAR(255) NOT NULL,
MedicalSpecialty VARCHAR(50),
YearsInPractice INT,
YearlySalaryCAD INT,
CHECK (YearlySalaryCAD>=0),
CHECK (YearsInPractive>=0),
PRIMARY KEY (PhysicianId)
);



# Use of Assumptions 6 & 7.
CREATE TABLE IF NOT EXISTS Diagnosis(
DateofDiagnosis DateTime NOT NULL,
PhysicianId VARCHAR(255),
PatientId VARCHAR(255),
PatientCondition VARCHAR(50),
DiagnosedDisease VARCHAR(50),
Prognosis VARCHAR(20) NOT NULL,
PRIMARY KEY (DateofDiagnosis),
FOREIGN KEY(PatientId)
	REFERENCES Patient(PatientId)
	ON DELETE SET NULL 
	ON UPDATE CASCADE,
FOREIGN KEY(PhysicianId)
	REFERENCES Physician(PhysicianId)
	ON DELETE SET NULL 
	ON UPDATE CASCADE
);

CREATE TABLE Hospital (
HospitalName VARCHAR(255) NOT NULL,
StreetAddress VARCHAR(50),
City VARCHAR(50),
AnnualBudget INT,
PRIMARY KEY (HospitalName)
);

# Use of Assumption 8
# This is a weak Entity.
CREATE TABLE AdmissionsRecord (
AdmitTime datetime,
HospitalName VARCHAR(255),
PatientId VARCHAR(255),
Priority VARCHAR(50),
PRIMARY KEY (AdmitTime, PatientId),
FOREIGN KEY (PatientId)
REFERENCES Patient(PatientId)
ON UPDATE CASCADE
ON DELETE NO ACTION,
FOREIGN KEY (HospitalName)
REFERENCES Hospital(HospitalName)
ON UPDATE CASCADE
ON DELETE CASCADE
);

#Use of Assumption 15
CREATE TABLE MedicalDepartment (
DepartmentName VARCHAR(50) NOT NULL,
HospitalName VARCHAR(255) NOT NULL,
AnnualBudget INT,
PRIMARY KEY (HospitalName, DepartmentName),
FOREIGN KEY (HospitalName)
REFERENCES Hospital(HospitalName)
ON DELETE CASCADE
ON UPDATE CASCADE
);


# Use of Assumption 12
CREATE TABLE BelongsTo (
PhysicianId VARCHAR(255),
MedicalSpecialty VARCHAR(50),
HospitalName VARCHAR(255),
DepartmentName VARCHAR(50),
PRIMARY KEY (MedicalSpecialty, PhysicianId),
FOREIGN KEY (HospitalName)
REFERENCES Hospital(HospitalName)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (PhysicianId)
REFERENCES Physician(PhysicianId)
ON DELETE CASCADE
ON UPDATE CASCADE
);


#Use of Assumption 15
CREATE TABLE MedicalTest (
TestId INT,
Name VARCHAR(20),
Fee INT,
PRIMARY KEY (TestId)
);

# Use of Assumption 8, 13,
# This is a weak Entity
CREATE TABLE Undergoes (
PatientId VARCHAR(255),
TestId INT,
Date Datetime,
Result VARCHAR(500),
PRIMARY KEY (Date, PatientId, TestId),
FOREIGN KEY (PatientId)
REFERENCES Patient(PatientId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (TestID)
REFERENCES MedicalTest(TestId)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE Drug (
DrugCode INT,
Name VARCHAR(255),
Category VARCHAR(20),
UnitCost INT,
PRIMARY KEY (DrugCode)
);

# This is a weak entitiy
# Use of Assumption 14 & 8 (generalized).
CREATE TABLE Prescription (
Date Datetime,
PatientId VARCHAR(255),
PhysicianId VARCHAR(255),
DrugCode INT,
PRIMARY KEY (DrugCode, PatientId, Date, PhysicianId),
FOREIGN KEY (PhysicianId)
REFERENCES Physician(PhysicianId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (PatientId)
REFERENCES Patient(PatientId)
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY (DrugCode)
REFERENCES Drug(DrugCode)
ON DELETE NO ACTION
ON UPDATE CASCADE
);

