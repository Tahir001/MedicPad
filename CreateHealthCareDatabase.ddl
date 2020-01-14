-- +++++++++++++++++++++++++++++++++++++++++++++++++
-- 	CSC343 -- UTM Databases -- Fall 2019
-- 	CREATE TABLES for Ministry of Health
-- 	Tahir Muhammad & Charbel El-Feghali
-- +++++++++++++++++++++++++++++++++++++++++++++++++
-- ---------------------------------------------
--  DDL Statements for the Database. 
-- ---------------------------------------------

-- ---------------------------------------------
--  DDL Statements for Person
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Person (
	PersonId VARCHAR(255) NOT NULL,
	DateOfBirth VARCHAR(255),
	Gender VARCHAR(10),
	Primary Key (PersonId)
);


-- ---------------------------------------------
--  DDL Statements for Address
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for Nurse
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Nurse (
	NurseId VARCHAR(255) NOT NULL,
	YearlySalaryCAD INT,
	YearsInPractice INT,
	CHECK (YearlySalaryCAD>=0),
	CHECK (YearsInPractive>=0),
	PRIMARY KEY (NurseId)
);


-- ---------------------------------------------
--  DDL Statements for Telephones
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for Patient
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Patient (
	PatientId VARCHAR(255) NOT NULL,
	HealthInsurance VARCHAR(20),
	PRIMARY KEY (PatientId)
);


-- ---------------------------------------------
--  DDL Statements for Physician
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Physician (
	PhysicianId VARCHAR(255) NOT NULL,
	MedicalSpecialty VARCHAR(50),
	YearsInPractice INT,
	YearlySalaryCAD INT,
	CHECK (YearlySalaryCAD>=0),
	CHECK (YearsInPractive>=0),
	PRIMARY KEY (PhysicianId)
);


-- ---------------------------------------------
--  DDL Statements for Diagnosis
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for Hospital
-- ---------------------------------------------

CREATE TABLE Hospital (
	HospitalName VARCHAR(255) NOT NULL,
	StreetAddress VARCHAR(50),
	City VARCHAR(50),
	AnnualBudget INT,
	PRIMARY KEY (HospitalName)
);


-- ---------------------------------------------
--  DDL Statements for Admission records
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for the Medical Department
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for Relationship
-- ---------------------------------------------

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

-- ---------------------------------------------
--  DDL Statements for Medical Test
-- ---------------------------------------------

CREATE TABLE MedicalTest (
	TestId INT,
	Name VARCHAR(20),
	Fee INT,
	PRIMARY KEY (TestId)
);


-- ---------------------------------------------
--  DDL Statements for Relationship 
-- ---------------------------------------------

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


-- ---------------------------------------------
--  DDL Statements for Drug
-- ---------------------------------------------

CREATE TABLE Drug (
	DrugCode INT,
	Name VARCHAR(255),
	Category VARCHAR(20),
	UnitCost INT,
	PRIMARY KEY (DrugCode)
);


-- ---------------------------------------------
--  DDL Statements for Prescription
-- ---------------------------------------------

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

