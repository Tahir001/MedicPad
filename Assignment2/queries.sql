-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- CSC 343: Group Assignment 2
-- Fall 2019 | UTM

-- Parter 1's Name: Tahir Muhammad

-- Parter 2's Name: Charbel El Feghali


-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- BEGIN
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- ++++++++++++++++++++
--  Q1
-- ++++++++++++++++++++

SELECT HName, City FROM Hospital
WHERE AnnualBudget > 3000000
ORDER BY AnnualBudget DESC;

-- ++++++++++++++++++++
--  Q2
-- ++++++++++++++++++++

SELECT DISTINCT P.FirstName, P.LastName, P.Gender, P.DateOfBirth
FROM Person P, Diagnose D
WHERE D.PatientID = P.ID
AND Disease LIKE '%Cancer%'
AND YEAR(CURDATE())-YEAR(P.DateOfBirth) <= 40
AND P.City = 'Toronto';

-- ++++++++++++++++++++
--  Q3.A
-- ++++++++++++++++++++

SELECT Specialty, AVG(Salary)
FROM Physician
GROUP BY Specialty;

-- ++++++++++++++++++++
--  Q3.B
-- ++++++++++++++++++++

SELECT Specialty, AVG(Salary)
FROM Physician P, Hospital H
WHERE P.HName = H.HName AND (H.City = 'Toronto' OR H.City = 'Hamilton')
GROUP BY Specialty
HAVING COUNT(PhysicianID) >= 5;

-- ++++++++++++++++++++
--  Q3.C
-- ++++++++++++++++++++

SELECT YearsOfPractice, AVG(Salary)
FROM Nurse
GROUP BY YearsOfPractice
ORDER BY YearsOfPractice DESC;

-- ++++++++++++++++++++
--  Q4
-- ++++++++++++++++++++

SELECT HName, COUNT(PatientID)
FROM Admission
WHERE Date BETWEEN '2017-08-05' AND '2017-08-10' GROUP BY HName;

-- ++++++++++++++++++++
--  Q5.A
-- ++++++++++++++++++++

SELECT DName
FROM Department
GROUP BY DName
HAVING COUNT(DName) = (SELECT DISTINCT COUNT(HName) FROM Hospital);

-- ++++++++++++++++++++
--  Q5.B
-- ++++++++++++++++++++

SELECT HName, DName
FROM (SELECT Physician.HName, Physician.DName, count(*) AS Num
    FROM Physician JOIN Nurse_Work
    ON Physician.DName = Nurse_Work.DName AND Physician.HName = Nurse_Work.HName GROUP BY Physician.HName, Physician.DName) AS T
WHERE T.Num = (SELECT MAX(Num) FROM (SELECT Physician.HName, Physician.DName, count(*) AS Num FROM Physician JOIN Nurse_Work ON Physician.DName = Nurse_Work.DName AND Physician.HName = Nurse_Work.HName GROUP BY Physician.HName, Physician.DName) AS T);

-- ++++++++++++++++++++
--  Q5.C
-- ++++++++++++++++++++

SELECT DName
FROM Department
GROUP BY DName
HAVING COUNT(DName) = 1;

-- ++++++++++++++++++++
--  Q6.A
-- ++++++++++++++++++++

SELECT FirstName, LastName
FROM Person P, (SELECT NurseID, COUNT(PatientID) FROM Patient GROUP BY NurseID HAVING COUNT(PatientID) < 3) AS T
WHERE T.NurseID = P.ID ORDER BY LastName;

-- ++++++++++++++++++++
--  Q6.B
-- ++++++++++++++++++++

SELECT FirstName, LastName
FROM Patient P, Diagnose D, Person B
WHERE B.ID = P.PatientID AND P.PatientID = D.PatientID AND D.Prognosis = 'poor' AND P.NurseID IN (SELECT NurseID
                  FROM (SELECT NurseID, COUNT(PatientID)
                        FROM Patient GROUP BY NurseID HAVING COUNT(PatientID) < 3) AS T1);
                        
-- ++++++++++++++++++++
--  Q7
-- ++++++++++++++++++++

SELECT Date
FROM (SELECT Date, COUNT(PatientID) AS Num
      FROM Admission
      WHERE HName = 'Hamilton General Hospital'
      GROUP BY Date) AS T
WHERE T.Num = (SELECT MAX(Num)
               FROM (SELECT Date, COUNT(PatientID) AS Num
                     FROM Admission
                     WHERE HName = 'Hamilton General Hospital' GROUP BY Date) AS T1);
-- ++++++++++++++++++++
--  Q8
-- ++++++++++++++++++++

SELECT DrugCode, Name, T.Sum AS TotalSales
FROM (SELECT D.DrugCode, D.Name, SUM(UnitCost) AS Sum
      FROM Drug D, Prescription P
      WHERE D.DrugCode = P.DrugCode
      GROUP BY D.DrugCode) AS T
WHERE T.Sum = (SELECT MAX(Sum)
               FROM (SELECT D.DrugCode, SUM(UnitCost) AS Sum 
                     FROM Drug D, Prescription P
                     WHERE D.DrugCode = P.DrugCode
                     GROUP BY D.DrugCode) AS T1);
                     
-- ++++++++++++++++++++
--  Q9
-- ++++++++++++++++++++

SELECT DISTINCT P.ID, FirstName, LastName, Gender
FROM Person P, Diagnose D, Take T, MedicalTest M
WHERE P.ID = D.PatientID AND T.PatientID = D.PatientID AND M.TestID = T.TestID AND D.Disease = 'Diabetes' AND M.Name <> 'Lymphocytes' AND M.Name <> 'Red Blood Cell';

-- ++++++++++++++++++++
--  Q10.A
-- ++++++++++++++++++++

SELECT DISTINCT D.Disease, D.Prognosis
FROM Physician P, Diagnose D
WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID;

-- ++++++++++++++++++++
--  Q10.B
-- ++++++++++++++++++++

SELECT P.PatientID, SUM(Fee)
FROM Patient P, MedicalTest M, Take T
WHERE P.PatientID = T.PatientID AND T.TestID = M.TestID AND (P.PatientID IN (SELECT DISTINCT D.PatientID FROM Physician P, Diagnose D WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID))
GROUP BY PatientID;

-- ++++++++++++++++++++
--  Q10.C
-- ++++++++++++++++++++

SELECT PatientID, SUM(UnitCost) AS TotalCost
FROM Prescription P, Drug D WHERE P.DrugCode = D.DrugCode AND (PatientID IN (SELECT DISTINCT D.PatientID FROM Physician P, Diagnose D WHERE P.HName = 'University of Toronto Medical Centre' AND P.DName = 'Intensive Care Unit' AND P.PhysicianID = D.PhysicianID))
GROUP BY PatientID
ORDER BY TotalCost DESC;

-- ++++++++++++++++++++
--  Q11
-- ++++++++++++++++++++

SELECT P.ID, P.FirstName, P.LastName
FROM Person P, Patient B, Admission A WHERE P.ID = B.PatientID AND A.PatientID = B.PatientID AND (A.Category = "urgent" OR A.Category = "standard")
GROUP BY P.ID
HAVING COUNT(HName) = 2;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- END
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
