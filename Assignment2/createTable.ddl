-- +++++++++++++++++++++++++++++++++++++++++++++
-- CSC343 -- UTM Databases -- Fall 2019
--         CREATE TABLES for MoH
-- +++++++++++++++++++++++++++++++++++++++++++++
-- ---------------------------------------------
--  DDL Statements for Hospital
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Hospital(
	HName varchar(60) NOT NULL,
	AnnualBudget integer NOT NULL,
	City varchar(60),
	Street varchar(60),
	PRIMARY KEY (HName)
);

-- ---------------------------------------------
--  DDL Statements for Department
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Department(
	DName varchar(60) NOT NULL,
	HName varchar(60) NOT NULL,
	Budget integer NOT NULL,
	PRIMARY KEY (DName, HName),
	FOREIGN KEY (HName) REFERENCES Hospital(HName) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Person
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Person(
	ID integer NOT NULL,
	FirstName varchar(60),
	LastName varchar(60),
	Gender varchar(60),
	PostalCode varchar(60),
	Street varchar(60),
	City varchar(60),
	Province varchar(60),
	DateOfBirth date,
	PRIMARY KEY (ID)
);

-- ---------------------------------------------
--  DDL Statements for Phone
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Phone(
	ID integer NOT NULL,
	Number bigint NOT NULL,
	Type varchar(20),
	PRIMARY KEY (ID, Number),
	FOREIGN KEY (ID) REFERENCES Person (ID) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Physician
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Physician(
	PhysicianID integer NOT NULL,
	YearsOfPractice integer NOT NULL,
	Salary integer NOT NULL,
	Specialty varchar(100),
	DName varchar(60),
	HName varchar(60),
	PRIMARY KEY (PhysicianID),
	FOREIGN KEY (PhysicianID) REFERENCES Person (ID) ON DELETE CASCADE,
	FOREIGN KEY (DName, HName) REFERENCES Department (DName, HName) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Nurse
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Nurse(
	NurseID integer NOT NULL,
	YearsOfPractice integer NOT NULL,
	Salary integer NOT NULL,
	PRIMARY KEY (NurseID),
	FOREIGN KEY (NurseID) REFERENCES Person (ID) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Patient
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Patient(
	PatientID integer NOT NULL,
	InsuranceType varchar(20),
	NurseID integer NOT NULL,
	PRIMARY KEY (PatientID),
	FOREIGN KEY (PatientID) REFERENCES Person (ID) ON DELETE CASCADE,
	FOREIGN KEY (NurseID) REFERENCES Nurse (NurseID) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Admission
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Admission(
	HName varchar(60) NOT NULL,
	PatientID integer NOT NULL,
	Date date NOT NULL,
	Category varchar(60),
	PRIMARY KEY (HName, PatientID, Date),
	FOREIGN KEY (HName) REFERENCES Hospital(HName) ON DELETE CASCADE,
	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Drug
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Drug(
	DrugCode varchar(20) NOT NULL,
	Name varchar(100) NOT NULL, 
	Category varchar(100), 
	UnitCost integer NOT NULL,
	PRIMARY KEY (DrugCode)
);

-- ---------------------------------------------
--  DDL Statements for Diagnose
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS Diagnose(
	PhysicianID integer NOT NULL,
	PatientID integer NOT NULL,
	Disease varchar(200),
	Prognosis varchar(60),
	Date date NOT NULL,
	PRIMARY KEY (PhysicianID,PatientID,Date),
	FOREIGN KEY (PhysicianID) REFERENCES Physician (PhysicianID) ON DELETE CASCADE,
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID) ON DELETE CASCADE
);


-- ---------------------------------------------
--  DDL Statements for Prescription
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Prescription(
	PhysicianID integer NOT NULL,
	PatientID integer NOT NULL,
	DrugCode varchar(20) NOT NULL,
	Dosage varchar(20),
	Date date NOT NULL,
	PRIMARY KEY (PhysicianID,PatientID,DrugCode,Date),
	FOREIGN KEY (PhysicianID) REFERENCES Physician (PhysicianID) ON DELETE CASCADE,
	FOREIGN KEY (PatientID) REFERENCES Patient (PatientID) ON DELETE CASCADE,
	FOREIGN KEY (DrugCode) REFERENCES Drug (DrugCode) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for MedicalTest
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS MedicalTest(
	TestID int NOT NULL,
	Name varchar(60),
	Fee DECIMAL(10,2),
	PRIMARY KEY (TestID)
);

-- ---------------------------------------------
--  DDL Statements for Take
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Take(
	TestID integer NOT NULL,
	PatientID integer NOT NULL,
	Date date NOT NULL,
	Result varchar(200),
	PRIMARY KEY (TestID, PatientID, Date),
	FOREIGN KEY (TestID) REFERENCES MedicalTest(TestID) ON DELETE CASCADE,
	FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE
);

-- ---------------------------------------------
--  DDL Statements for Nur_Work
-- ---------------------------------------------

CREATE TABLE IF NOT EXISTS Nurse_Work(
	NurseID integer NOT NULL,
	DName varchar(60) NOT NULL,
	HName varchar(60) NOT NULL,
	PRIMARY KEY (NurseID, DName, HName),
	FOREIGN KEY (DName, HName) REFERENCES Department(DName, HName) ON DELETE CASCADE,
	FOREIGN KEY (NurseID) REFERENCES Nurse(NurseID) ON DELETE CASCADE
);
-- ++++++++++++++++++++++++++++++++++++++++++++++
-- ++++++++++++++++++++++++++++++++++++++++++++++