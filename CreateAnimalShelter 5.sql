CREATE DATABASE AnimalShelterDB
ON 
(
    NAME = AnimalShelterDB,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AnimalShelterDB.mdf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = AnimalShelterDB_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AnimalShelterDB_log.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 1MB
);
GO

USE AnimalShelterDB
GO
--Create table to store the animal types
CREATE TABLE Animal_Type (
    Animal_TypeID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL
);
GO
--Create table to store the animal breeds
CREATE TABLE Animal_Breed (
    Animal_BreedID INT PRIMARY KEY IDENTITY(100,1),
    Name VARCHAR(50) NOT NULL,
    Size VARCHAR(20) NOT NULL
);
GO
--Create table to store the animal colors and patterns
CREATE TABLE Color (
    ColorID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL
);
GO
--Create table to store the kennels and their size
CREATE TABLE Kennel (
    KennelNumber INT PRIMARY KEY,
    Size VARCHAR(20) NOT NULL
);
GO

--Create table to store the data on animal 
CREATE TABLE Animal (
    AnimalID INT PRIMARY KEY IDENTITY(1001,1),
    Name VARCHAR(50) NOT NULL,
    Animal_TypeID INT,
    Animal_BreedID INT,
    ColorID INT,
    Gender VARCHAR(10),
    Birth_Date DATE NULL,
    Admission_Date DATE NOT NULL,
    Weight DECIMAL(5,2) NULL,
    KennelNumber INT NULL,
    Adoption_Status VARCHAR(20) NOT NULL,
    Sterilized BIT NOT NULL,
    Notes TEXT,
    FOREIGN KEY (Animal_TypeID) REFERENCES Animal_Type(Animal_TypeID),
    FOREIGN KEY (Animal_BreedID) REFERENCES Animal_Breed(Animal_BreedID),
    FOREIGN KEY (ColorID) REFERENCES Color(ColorID),
    FOREIGN KEY (KennelNumber) REFERENCES Kennel(KennelNumber)
);
GO
--Make the current date the admission date by default
ALTER TABLE Animal
ADD CONSTRAINT DF_Admission DEFAULT GetDate() FOR Admission_Date
GO 
--Make sure the animal's birth date is before the admission date
ALTER TABLE Animal
ADD CONSTRAINT CK_BirthDate CHECK (Birth_Date <= Admission_Date)
GO 

--Create table to store the data on medications
CREATE TABLE Medication (
    MedID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(255) NULL,
    Medication_Name VARCHAR(100) NOT NULL
);
GO
--Create table to store the data on vets taht the animals see
CREATE TABLE Veterinarian (
    VetID INT PRIMARY KEY IDENTITY(1,1),
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    PracticeName VARCHAR(100) NULL,
    Address VARCHAR(255) NULL,
    State VARCHAR(50) NULL,
    City VARCHAR(50) NULL,
    Postal_Code VARCHAR(10) NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Practice_Phone VARCHAR(20)NOT NULL
);
GO
--Ensure each email given is unique
ALTER TABLE Veterinarian
ADD CONSTRAINT UC_Email UNIQUE (Email)
GO
--Create table to store the data on which animal takes which medication, when they take it, 
--the dosage and the vet who perscribed the meds
CREATE TABLE Animal_Medication (
    MedID INT,
    AnimalID INT,
    Dose VARCHAR(50) NOT NULL,
    Time DATETIME NOT NULL,
    VetID INT NOT NULL,
    PRIMARY KEY (MedID, AnimalID),
    FOREIGN KEY (MedID) REFERENCES Medication(MedID),
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (VetID) REFERENCES Veterinarian(VetID)
);
GO
--Create table to store the data on vaccinations
CREATE TABLE Vaccination (
    VaccineID INT PRIMARY KEY IDENTITY(1,1),
    Vaccination_Time DATETIME,
    AnimalID INT NOT NULL,
    Vaccine_Name VARCHAR(100) NOT NULL,
    Batch VARCHAR(50) NULL,
    VetID INT,
    Comments TEXT NULL,
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (VetID) REFERENCES Veterinarian(VetID)
);
GO
--Make the current date the default one for when the vaccination took place
ALTER TABLE Vaccination 
ADD CONSTRAINT DF_VaccinationTime DEFAULT GetDate() FOR Vaccination_Time
GO
--Create table to store the data on people
CREATE TABLE Person (
    PersonID INT PRIMARY KEY IDENTITY(1,1),
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Birth_Date DATE NULL,
    Address VARCHAR(255) NULL,
    State VARCHAR(50) NULL,
    City VARCHAR(50) NULL,
    Postal_Code VARCHAR(10) NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL
);
GO
--Ensure each email entered by people are unique
ALTER TABLE Person
ADD CONSTRAINT UC_PersonEmail UNIQUE (Email)
GO
--Ensure each person's phone number is unique
ALTER TABLE Person
ADD CONSTRAINT UC_PersonPhone UNIQUE (Phone)
GO
--Create table to store the data on fosters
CREATE TABLE Foster (
    AnimalID INT,
    PersonID INT,
    Start_Date DATE,
    End_Date DATE NULL,
    Notes TEXT NULL,
    PRIMARY KEY (AnimalID, PersonID, Start_Date),
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);
GO
--Create table to store the data on adoptions
CREATE TABLE Adoption (
    AnimalID INT,
    PersonID INT,
    Adoption_Date DATE,
    PRIMARY KEY (AnimalID, PersonID, Adoption_Date),
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);
GO
--Create table to store the data on staff
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Birth_Date DATE NULL,
    Hire_Date DATE NULL,
    Address VARCHAR(255) NULL,
    State VARCHAR(50) NULL,
    City VARCHAR(50) NULL,
    Postal_Code VARCHAR(10) NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Salary DECIMAL(10,2) NULL
);
GO
--ensure dates are logically sound
ALTER TABLE Staff
ADD CONSTRAINT CH_Hiredate CHECK (Hire_Date >Birth_Date)
GO 
--Ensure each email is unique
ALTER TABLE Staff
ADD CONSTRAINT UC_StaffEmail UNIQUE (Email)
GO
--Ensure each phone number is unique
ALTER TABLE Staff
ADD CONSTRAINT UC_StaffPhone UNIQUE (Phone)
GO
--Create table to store the data on animal visitations
CREATE TABLE Visitation (
    AnimalID INT,
    VisitDate DATETIME,
    PersonID INT,
    StaffID INT,
    PRIMARY KEY (AnimalID, VisitDate, PersonID),
    FOREIGN KEY (AnimalID) REFERENCES Animal(AnimalID),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
GO
--Create table to store the data on staff shifts
CREATE TABLE Staff_Shift (
    ShiftID INT PRIMARY KEY IDENTITY(1,1),
    StaffID INT NOT NULL,
    Start_Time DATETIME NOT NULL,
    End_Time DATETIME NOT NULL,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
GO
--Create table to store the data on types of resources
CREATE TABLE Resource_Type (
    Resource_TypeID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL
);
GO
--Create table to store the data on resources the animal shelter has
CREATE TABLE Resource (
    ResourceID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(255) NULL,
    Resource_Type INT NOT NULL,
    Aquire_Date DATE NOT NULL,
    Donation BIT NOT NULL,
    Status VARCHAR(50) NULL,
    FOREIGN KEY (Resource_Type) REFERENCES Resource_Type(Resource_TypeID)
);
GO

ALTER TABLE Resource
ADD CONSTRAINT DF_AquireDate DEFAULT GETDATE() FOR Aquire_Date
GO

USE AnimalShelterDB
GO
CREATE TABLE Audit
(AuditID INT PRIMARY KEY IDENTITY(1,1),
Entity NVARCHAR(20) NOT NULL,
PrimaryKeyOneName TEXT NOT NULL,
PrimaryKeyOneValue INT NOT NULL,
PrimaryKeyTwoName TEXT,
PrimaryKeyTwoValue INT,
PrimaryKeyThreeName TEXT,
PrimaryKeyThreeValue DateTime,
TransactionType NVARCHAR(1) NOT NULL,
TransactionDate DATETIME NOT NULL,
LogInID NVARCHAR(30) NOT NULL)
GO

--Indexes
CREATE NONCLUSTERED INDEX idx_animal_type ON Animal(Animal_TypeID);
CREATE NONCLUSTERED INDEX idx_animal_breed ON Animal(Animal_BreedID);
CREATE NONCLUSTERED INDEX idx_color ON Animal(ColorID);
CREATE NONCLUSTERED INDEX idx_kennel ON Animal(KennelNumber);
CREATE NONCLUSTERED INDEX idx_resource_type ON Resource(Resource_Type);
CREATE NONCLUSTERED INDEX idx_vaccine_vet ON Vaccination(VetID);
CREATE NONCLUSTERED INDEX idx_med_vet ON Animal_Medication(VetID);
GO

--Triggers. All triggers create records in the audit table to monitor user activty 

--Generates a record in audit table for each insert, delete and update operation performed on the Adoption table
CREATE TRIGGER trAdoption
ON Adoption
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Adoption'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted) --test if the operation was insert
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,', PersonID',PersonID,'Adoption_Date',Adoption_Date, 
			@TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted) --test if the operation was delete
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'PersonID',PersonID,'Adoption_Date',Adoption_Date, 
			@TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted) --test if the operation was update
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'PersonID',PersonID,'Adoption_Date',Adoption_Date, 
			@TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Animal table
CREATE TRIGGER trAnimal
ON Animal
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Animal'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Animal_Breed table
CREATE TRIGGER trAnimalBreed
ON Animal_Breed
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Animal_Breed'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Animal_BreedID',Animal_BreedID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Animal_BreedID',Animal_BreedID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity,'Animal_BreedID',Animal_BreedID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Animal_Type table
CREATE TRIGGER trAnimalType
ON Animal_Type
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Animal_Type'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Animal_TypeID',Animal_TypeID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Animal_TypeID',Animal_TypeID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity,'Animal_TypeID',Animal_TypeID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Color table
CREATE TRIGGER trColor
ON Color
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Color'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ColorID',ColorID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ColorID',ColorID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ColorID',ColorID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Foster table
CREATE TRIGGER trFoster
ON Foster
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Foster'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'PersonID',PersonID,'Start_Date',Start_Date, 
			@TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'PersonID',PersonID,'Start_Date',Start_Date, 
			@TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'PersonID',PersonID,'Start_Date',Start_Date, 
			@TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Kennel table
CREATE TRIGGER trKennel
ON Kennel
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Kennel'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'KennelNumber',KennelNumber, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'KennelNumber',KennelNumber, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'KennelNumber',KennelNumber, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Medication table
CREATE TRIGGER trMedication
ON Medication
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Medication'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Medication', MedID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Medication',MedID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Medication',MedID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Person table
CREATE TRIGGER trPerson
ON Person
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Person'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'PersonID',PersonID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'PersonID',PersonID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity,'PersonID',PersonID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Resource table
CREATE TRIGGER trResource
ON dbo.Resource
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Resource'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ResourceID',ResourceID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ResourceID',ResourceID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ResourceID',ResourceID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Resource_Type table
CREATE TRIGGER trResourceType
ON Resource_Type
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Resource_Type'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Resource_TypeID', Resource_TypeID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Resource_TypeID', Resource_TypeID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'Resource_TypeID',Resource_TypeID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Staff table
CREATE TRIGGER trStaff
ON Staff
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Staff'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'StaffID',StaffID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'StaffID',StaffID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'StaffID',StaffID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Staff_Shift table
CREATE TRIGGER trStaffShift
ON Staff_Shift
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Staff_Shift'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ShiftID',ShiftID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ShiftID',ShiftID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'ShiftID',ShiftID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Vaccination table
CREATE TRIGGER trVaccination
ON Vaccination
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Vaccination'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VaccineID',VaccineID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VaccineID',VaccineID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VaccineID', VaccineID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Veterinarian table
CREATE TRIGGER trVeterinarian
ON Veterinarian
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Veterinarian'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VetID',VetID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VetID',VetID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'VetID',VetID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Visitation table
CREATE TRIGGER trVisitation
ON Visitation
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Visitation'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity,PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue,TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID', AnimalID, 'PersonID', PersonID, 'VisitDate', VisitDate, 
			@TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID', AnimalID, 'PersonID', PersonID, 'VisitDate', VisitDate, 
			@TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			PrimaryKeyThreeName, PrimaryKeyThreeValue, TransactionType, TransactionDate, LogInID)
			SELECT @Entity,'AnimalID', AnimalID, 'PersonID', PersonID, 'VisitDate', VisitDate, 
			@TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO

--Generates a record in audit table for each insert, delete and update operation performed on the Animal_Medication table
CREATE TRIGGER trAnimalMedication
ON Animal_Medication
AFTER INSERT, DELETE, UPDATE
AS 
	BEGIN 
		DECLARE @SysUser NVARCHAR(30), @Entity NVARCHAR(20), @TransactionType NVARCHAR(1), @date DATETIME, @PK INT

		SET @SysUser=SYSTEM_USER
		SET @Entity='Animal_Medication'
		SET @date=GETDATE()

		SET NOCOUNT ON
		IF EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
		BEGIN 
			SET @TransactionType='I'
			INSERT INTO Audit(Entity,PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'MedID',MedID, @TransactionType, @date, @SysUser FROM inserted 
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND NOT EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='D'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			TransactionType, TransactionDate, LogInID)
			SELECT @Entity, 'AnimalID',AnimalID,'MedID',MedID, @TransactionType, @date, @SysUser FROM deleted
		END
		ELSE IF EXISTS(SELECT * FROM deleted) AND EXISTS(SELECT * FROM inserted)
		BEGIN 
			SET @TransactionType='U'
			INSERT INTO Audit(Entity, PrimaryKeyOneName, PrimaryKeyOneValue, PrimaryKeyTwoName, PrimaryKeyTwoValue,
			 TransactionType, TransactionDate, LogInID)
			SELECT @Entity,'AnimalID',AnimalID,'MedID',MedID, @TransactionType, @date, @SysUser FROM inserted
		END
	END
	GO




USE AnimalShelterDB
GO
--Inserting data into Animal_Type
INSERT INTO Animal_Type ( Name) VALUES
( 'Dog'),
( 'Cat'),
( 'Rabbit'),
( 'Bird'),
( 'Guinea Pig');

-- Inserting data into Animal_Breed
INSERT INTO Animal_Breed ( Name, Size) VALUES
( 'Labrador Retriever', 'Large'),
( 'German Shepherd', 'Large'),
( 'Golden Retriever', 'Large'),
( 'Pug', 'Small'),
( 'Beagle', 'Medium'),
( 'Siamese', 'Medium'),
( 'Persian', 'Medium'),
( 'Maine Coon', 'Large'),
( 'Bengal', 'Medium'),
( 'Scottish Fold', 'Small'),
( 'Holland Lop', 'Small'),
( 'Mini Rex', 'Small'),
( 'Dutch', 'Small'),
( 'Parakeet', 'Small'),
( 'Cockatiel', 'Small'),
( 'American Shorthair', 'Small');

-- Inserting data into Color
INSERT INTO Color ( Name) VALUES
( 'Black'),
( 'White'),
( 'Brown'),
( 'Golden'),
( 'Gray'),
( 'Tabby'),
( 'Calico'),
( 'Spotted'),
( 'Orange'),
( 'Cream');

-- Inserting data into Kennel
INSERT INTO Kennel (KennelNumber, Size) VALUES
(1, 'Large'),
(2, 'Large'),
(3, 'Medium'),
(4, 'Small'),
(5, 'Small'),
(6, 'Large'),
(7, 'Medium'),
(8, 'Small'),
(9, 'Medium'),
(10, 'Large');

-- Inserting data into Animal
INSERT INTO Animal ( Name, Animal_TypeID, Animal_BreedID, ColorID, Gender, Birth_Date, Admission_Date, Weight, KennelNumber, Adoption_Status, Sterilized, Notes) VALUES
( 'Buddy', 1, 101, 4, 'Male', '2023-03-15', '2024-01-20', 25.5, 1, 'Available', 1, 'Friendly and energetic.'),
( 'Lucy', 1, 103, 4, 'Female', '2022-11-01', '2024-02-10', 22.1, 2, 'Adopted', 1, 'Good with children.'),
( 'Max', 2, 101, 6, 'Male', '2024-01-05', '2024-03-01', 4.2, 3, 'Available', 0, 'Playful and curious.'),
( 'Bella', 2, 102, 7, 'Female', '2023-05-20', '2024-03-15', 3.8, 4, 'Available', 1, 'Loves to be petted.'),
( 'Rocky', 1, 104, 1, 'Male', '2023-07-10', '2024-04-01', 7.9, 5, 'Available', 0, 'Needs a patient owner.'),
( 'Daisy', 1, 102, 3, 'Female', '2022-09-25', '2024-01-25', 28.7, 6, 'Adopted', 1, 'Well-trained.'),
( 'Oliver', 2, 103, 5, 'Male', '2023-12-12', '2024-02-28', 6.1, 7, 'Available', 1, 'Gentle giant.'),
( 'Luna', 2, 104, 8, 'Female', '2023-04-01', '2024-03-20', 4.5, 8, 'Available', 0, 'Very active.'),
( 'Charlie', 1, 105, 3, 'Male', '2023-06-18', '2024-04-05', 11.3, 9, 'Available', 1, 'Loves to explore.'),
('Sophie', 1, 101, 2, 'Female', '2024-02-01', '2024-04-10', 23.0, 10, 'Available', 0, 'Sweet and affectionate.'),
( 'Leo', 3, 101, 3, 'Male', '2024-03-01', '2024-04-15', 1.5, 4, 'Available', 0, 'Enjoys hay.'),
( 'Mia', 3, 102, 2, 'Female', '2023-11-10', '2024-04-18', 1.2, 5, 'Available', 1, 'Loves to cuddle.'),
( 'Coco', 4, 101, 1, 'Male', '2024-01-15', '2024-04-20', 0.3, 8, 'Available', 0, 'Talkative.'),
( 'Sunny', 4, 102, 4, 'Female', '2023-10-01', '2024-04-22', 0.4, 9, 'Available', 1, 'Loves to sing.'),
( 'Peanut', 5, 101, 3, 'Male', '2024-02-20', '2024-04-25', 0.8, 3, 'Available', 0, 'Curious and squeaky.'),
( 'Shadow', 2, 105, 1, 'Male', '2023-09-01', '2024-03-05', 3.5, 4, 'Available', 1, 'Independent.'),
( 'Ginger', 2, 101, 9, 'Female', '2023-07-22', '2024-03-10', 4.0, 5, 'Available', 0, 'Loves attention.'),
( 'Hunter', 1, 102, 1, 'Male', '2023-05-05', '2024-03-12', 30.1, 6, 'Available', 1, 'Protective.'),
( 'Penny', 1, 105, 8, 'Female', '2023-10-30', '2024-03-18', 10.5, 7, 'Available', 0, 'Great sniffer.'),
( 'Milo', 2, 102, 2, 'Male', '2024-01-28', '2024-03-22', 3.2, 8, 'Available', 1, 'Calm and quiet.'),
( 'Hazel', 1, 103, 3, 'Female', '2023-08-15', '2024-03-25', 24.8, 9, 'Available', 0, 'Loves to play fetch.'),
( 'Finn', 1, 104, 5, 'Male', '2023-11-22', '2024-03-28', 8.1, 10, 'Available', 1, 'Charming personality.'),
( 'Cleo', 2, 103, 7, 'Female', '2023-06-01', '2024-03-30', 5.5, 1, 'Available', 0, 'Majestic and fluffy.'),
( 'Jasper', 1, 101, 1, 'Male', '2024-03-05', '2024-04-02', 26.3, 2, 'Available', 1, 'Loyal companion.'),
( 'Willow', 2, 104, 6, 'Female', '2023-09-18', '2024-04-04', 4.8, 3, 'Available', 0, 'Energetic and sleek.'),
( 'Tucker', 1, 105, 2, 'Male', '2023-12-25', '2024-04-06', 12.0, 4, 'Available', 1, 'Friendly with everyone.'),
( 'Stella', 2, 105, 7, 'Female', '2024-01-10', '2024-04-08', 3.0, 5, 'Available', 0, 'Sweet and gentle.'),
( 'Ace', 1, 102, 1, 'Male', '2023-07-01', '2024-04-10', 29.5, 6, 'Available', 1, 'Intelligent and strong.'),
( 'Piper', 1, 103, 4, 'Female', '2023-11-05', '2024-04-12', 21.5, 7, 'Available', 0, 'Loves attention.'),
( 'Ziggy', 2, 101, 8, 'Male', '2024-02-15', '2024-04-14', 4.1, 8, 'Available', 1, 'Quirky and fun.'),
( 'Daisy', 3, 101, 3, 'Female', '2024-01-20', '2024-04-16', 1.3, 9, 'Available', 0, 'Loves to hop.'),
( 'Thumper', 3, 102, 1, 'Male', '2023-10-05', '2024-04-18', 1.6, 10, 'Available', 1, 'Playful and curious.'),
( 'Kiwi', 4, 101, 5, 'Female', '2024-03-10', '2024-04-20', 0.2, 1, 'Available', 0, 'Loves to chirp.'),
( 'Rio', 4, 102, 9, 'Male', '2023-12-01', '2024-04-22', 0.3, 2, 'Available', 1, 'Colorful and friendly.'),
( 'Nugget', 5, 101, 3, 'Female', '2024-02-25', '2024-04-24', 0.7, 3, 'Available', 0, 'Sweet and cuddly.'),
( 'Bandit', 1, 104, 1, 'Male', '2023-09-20', '2024-04-26', 7.5, 4, 'Available', 1, 'Mischievous but loving.'),
( 'Lily', 2, 102, 2, 'Female', '2023-07-15', '2024-04-28', 3.9, 5, 'Available', 0, 'Graceful and calm.'),
( 'Bear', 1, 102, 3, 'Male', '2023-06-01', '2024-04-30', 31.0, 6, 'Available', 1, 'Strong and loyal.'),
( 'Skylar', 1, 103, 4, 'Female', '2023-10-10', '2024-05-02', 23.5, 7, 'Available', 0, 'Energetic and playful.'),
( 'Salem', 2, 103, 1, 'Male', '2024-01-01', '2024-05-04', 5.8, 8, 'Available', 1, 'Mysterious and charming.'),
( 'Bubbles', 3, 101, 2, 'Female', '2024-02-05', '2024-05-06', 1.4, 9, 'Available', 0, 'Loves to explore.'),
( 'Patches', 3, 103, 8, 'Male', '2023-11-15', '2024-05-08', 1.1, 10, 'Available', 1, 'Unique markings.'),
( 'Blue', 4, 102, 5, 'Male', '2024-03-15', '2024-05-10', 0.4, 1, 'Available', 0, 'Beautiful singer.'),
( 'Goldie', 4, 101, 4, 'Female', '2023-12-05', '2024-05-12', 0.3, 2, 'Available', 1, 'Sweet temperament.'),
( 'Hammy', 5, 101, 3, 'Male', '2024-03-01', '2024-05-14', 0.9, 3, 'Available', 0, 'Loves to burrow.'),
( 'Roxy', 1, 101, 1, 'Female', '2023-08-20', '2024-02-01', 24.0, 1, 'Adopted', 1, 'Great family dog.'),
( 'Simba', 2, 101, 9, 'Male', '2023-06-10', '2024-02-15', 4.5, 3, 'Adopted', 1, 'King of his kennel.'),
( 'Shadow', 1, 105, 1, 'Male', '2022-12-01', '2024-03-01', 11.8, 9, 'Adopted', 1, 'Loyal and loving.'),
( 'Angel', 2, 102, 2, 'Female', '2023-04-15', '2024-03-10', 3.6, 4, 'Adopted', 1, 'Sweet and gentle.'),
('Thor', 1, 102, 1, 'Male', '2023-01-01', '2024-04-01', 32.5, 6, 'Adopted', 1, 'Powerful and friendly.');



-- Inserting data into Animal_Kennel (Note: This table might be redundant based on the Animal table structure)
-- Assuming each animal is in one kennel at a time, the KennelNumber in the Animal table serves this purpose.
-- If an animal can be in multiple kennels simultaneously for some reason, then these inserts would be valid.
-- However, based on the initial design, we'll skip these for now to avoid potential confusion.


-- Inserting data into Medication
INSERT INTO Medication ( Description, Medication_Name) VALUES
( 'Antibiotic for infections', 'Amoxicillin'),
( 'Pain relief medication', 'Carprofen'),
( 'Flea and tick prevention', 'Fipronil'),
( 'Dewormer', 'Pyrantel'),
( 'Vaccination booster', 'DHPP');

-- Inserting data into Veterinarian
INSERT INTO Veterinarian ( First_Name, Last_Name, PracticeName, Address, State, City, Postal_Code, Email, Phone, Practice_Phone) VALUES
( 'Alice', 'Smith', 'Animal Care Clinic', '123 Main St', 'CA', 'Los Angeles', '90001', 'alice.smith@email.com', '555-123-4567', '555-987-6543'),
('Bob', 'Johnson', 'Pet Wellness Center', '456 Oak Ave', 'NY', 'New York', '10001', 'bob.johnson@email.com', '212-555-7890', '212-555-0987'),
('Carol', 'Williams', 'Happy Paws Vet', '789 Pine Ln', 'TX', 'Houston', '77001', 'carol.williams@email.com', '713-555-2345', '713-555-5432'),
( 'David', 'Brown', 'All Creatures Vet', '246 Elm St', 'FL', 'Miami', '33101', 'david.brown@email.com', '305-555-6789', '305-555-9876'),
( 'Emily', 'Davis', 'Gentle Care Animal Hospital', '135 Maple Dr', 'GA', 'Atlanta', '30301', 'emily.davis@email.com', '404-555-0123', '404-555-3210');

-- Inserting data into Table_Medication
INSERT INTO Animal_Medication (MedID, AnimalID, Dose, Time, VetID) VALUES
(1, 1001, '10 mg', '2024-02-01 10:00:00', 1),
(2, 1002, '5 mg', '2024-02-15 14:30:00', 3),
(3, 1003, '1 application', '2024-03-05 09:00:00', 3),
(4, 1004, '15 mg', '2024-03-20 11:15:00', 4),
(5, 1005, '1 dose', '2024-04-02 13:00:00', 5),
(1, 1006, '12 mg', '2024-02-03 11:00:00', 1),
(2, 1007, '6 mg', '2024-02-17 15:30:00', 2),
(3, 1008, '1 application', '2024-03-07 10:00:00', 3),
(4, 1009, '18 mg', '2024-03-22 12:15:00', 4),
(5, 1010, '1 dose', '2024-04-04 14:00:00', 5),
(1, 1011, '8 mg', '2024-02-05 09:30:00', 3),
(2, 1012, '4 mg', '2024-02-19 13:00:00', 2),
(3, 1013, '1 application', '2024-03-09 08:30:00', 3),
(4, 1014, '12 mg', '2024-03-24 10:45:00', 4),
(5, 1015, '1 dose', '2024-04-06 12:30:00', 5),
(1, 1016, '11 mg', '2024-02-07 10:30:00', 3),
(2, 1017, '5.5 mg', '2024-02-21 14:00:00', 2),
(3, 1018, '1 application', '2024-03-11 09:30:00', 3),
(4, 1019, '16.5 mg', '2024-03-26 11:45:00', 4),
(5, 1020, '1 dose', '2024-04-08 13:30:00', 4),
(1, 1021, '9.5 mg', '2024-02-09 11:30:00', 1),
(2, 1022, '4.75 mg', '2024-02-23 15:00:00', 4),
(3, 1023, '1 application', '2024-03-13 10:30:00', 3),
(4, 1024, '14.25 mg', '2024-03-28 12:45:00', 4),
(5, 1025, '1 dose', '2024-04-10 14:30:00', 5),
(1, 1026, '13 mg', '2024-02-11 12:30:00', 1),
(2, 1027, '6.5 mg', '2024-02-25 16:00:00', 2),
(3, 1028, '1 application', '2024-03-15 11:30:00', 3),
(4, 1029, '19.5 mg', '2024-03-30 13:45:00', 4),
(5, 1030, '1 dose', '2024-04-12 15:30:00', 5),
(1, 1031, '7.5 mg', '2024-02-13 09:00:00', 3),
(2, 1032, '3.75 mg', '2024-02-27 12:30:00', 2),
(3, 1033, '1 application', '2024-03-17 08:00:00', 3),
(4, 1034, '11.25 mg', '2024-04-01 10:15:00', 4),
(5, 1035, '1 dose', '2024-04-14 12:00:00', 5),
(1, 1036, '10.5 mg', '2024-02-15 10:00:00', 1),
(2, 1037, '5.25 mg', '2024-03-01 13:30:00', 2),
(3, 1038, '1 application', '2024-03-19 09:00:00', 3),
(4, 1039, '15.75 mg', '2024-04-03 11:15:00', 3),
(5, 1040, '1 dose', '2024-04-16 13:00:00', 5),
(1, 1041, '9 mg', '2024-02-17 11:00:00', 1),
(2, 1042, '4.5 mg', '2024-03-03 14:30:00', 2),
(3, 1043, '1 application', '2024-03-21 10:00:00', 3),
(4, 1044, '13.5 mg', '2024-04-05 12:15:00', 4),
(5, 1045, '1 dose', '2024-04-18 14:00:00', 5),
(1, 1046, '14 mg', '2024-02-19 12:00:00', 5),
(2, 1047, '7 mg', '2024-03-05 15:30:00', 2),
(3, 1048, '1 application', '2024-03-23 11:00:00', 3),
(4, 1049, '21 mg', '2024-04-07 13:15:00', 4),
(5, 1050, '1 dose', '2024-04-20 15:00:00', 5);


-- Inserting data into Vaccinations
INSERT INTO Vaccination ( Vaccination_Time, AnimalID, Vaccine_Name, Batch, VetID, Comments) VALUES
( '2024-02-01 08:00:00', 1001, 'Rabies', 'RAB123', 2, 'Initial vaccination'),
( '2024-02-15 10:30:00', 1002, 'DHPP', 'DHP456', 2, 'First booster'),
('2024-03-05 14:00:00', 1003, 'FVRCP', 'FVR789', 3, 'Initial vaccination'),
( '2024-03-20 09:00:00', 1004, 'Rabies', 'RAB123', 4, 'Initial vaccination'),
( '2024-04-02 11:00:00', 1005, 'Bordetella', 'BOR234', 5, 'For kennel cough'),
( '2024-02-03 09:00:00', 1006, 'Rabies', 'RAB123', 1, 'Initial vaccination'),
( '2024-02-17 11:30:00', 1007, 'DHPP', 'DHP456', 2, 'First booster'),
( '2024-03-07 15:00:00', 1008, 'FVRCP', 'FVR789', 2, 'Initial vaccination'),
('2024-03-22 10:00:00', 1009, 'Rabies', 'RAB123', 4, 'Initial vaccination'),
( '2024-04-04 12:00:00', 1010, 'Bordetella', 'BOR234', 5, 'For kennel cough'),
( '2024-02-05 08:30:00', 1011, 'Myxomatosis', 'MYX567', 1, 'Initial vaccination'),
( '2024-02-19 11:00:00', 1012, 'RHDV', 'RHD890', 5, 'Initial vaccination'),
( '2024-03-09 14:30:00', 1013, 'Canarypox', 'CAN112', 3, 'Initial vaccination'),
( '2024-03-24 09:30:00', 1014, 'PBFD', 'PBF345', 4, 'Initial vaccination'),
( '2024-04-06 11:30:00', 1015, 'Distemper', 'DIS678', 2, 'Initial vaccination'),
( '2024-02-07 08:00:00', 1016, 'Rabies', 'RAB901', 1, 'Annual booster'),
( '2024-02-21 10:30:00', 1017, 'FVRCP', 'FVR234', 2, 'Annual booster'),
( '2024-03-11 14:00:00', 1018, 'DHPP', 'DHP567', 5, 'Annual booster'),
( '2024-03-26 09:00:00', 1019, 'Bordetella', 'BOR890', 4, 'Annual booster'),
( '2024-04-08 11:00:00', 1020, 'Rabies', 'RAB901', 5, 'Annual booster'),
( '2024-02-09 08:30:00', 1021, 'DHPP', 'DHP567', 1, 'First in series'),
( '2024-02-23 11:00:00', 1022, 'FVRCP', 'FVR234', 2, 'First in series'),
( '2024-03-13 14:30:00', 1023, 'Rabies', 'RAB901', 3, 'First in series'),
( '2024-03-28 09:30:00', 1024, 'Bordetella', 'BOR890', 4, 'First in series'),
( '2024-04-10 11:30:00', 1025, 'DHPP', 'DHP567', 5, 'Second in series'),
( '2024-02-11 08:00:00', 1026, 'Rabies', 'RAB901', 1, 'Initial vaccination'),
( '2024-02-25 10:30:00', 1027, 'FVRCP', 'FVR234', 5, 'Initial vaccination'),
( '2024-03-15 14:00:00', 1028, 'DHPP', 'DHP567', 3, 'Initial vaccination'),
( '2024-03-30 09:00:00', 1029, 'Bordetella', 'BOR890', 4, 'For kennel cough'),
( '2024-04-12 11:00:00', 1030, 'Rabies', 'RAB901', 5, 'Initial vaccination'),
( '2024-02-13 08:30:00', 1031, 'Myxomatosis', 'MYX567', 1, 'Initial vaccination'),
( '2024-02-27 11:00:00', 1032, 'RHDV', 'RHD890', 2, 'Initial vaccination'),
( '2024-03-17 14:30:00', 1033, 'Canarypox', 'CAN112', 3, 'Initial vaccination'),
( '2024-04-01 09:30:00', 1034, 'PBFD', 'PBF345', 4, 'Initial vaccination'),
( '2024-04-14 11:30:00', 1035, 'Distemper', 'DIS678', 5, 'Initial vaccination'),
( '2024-02-15 08:00:00', 1036, 'Rabies', 'RAB901', 2, 'Annual booster'),
( '2024-03-01 10:30:00', 1037, 'FVRCP', 'FVR234', 2, 'Annual booster'),
( '2024-03-19 14:00:00', 1038, 'DHPP', 'DHP567', 3, 'Annual booster'),
( '2024-04-03 09:00:00', 1039, 'Bordetella', 'BOR890', 4, 'Annual booster'),
( '2024-04-16 11:00:00', 1040, 'Rabies', 'RAB901', 5, 'Annual booster'),
( '2024-02-17 08:30:00', 1041, 'DHPP', 'DHP567', 1, 'First in series'),
( '2024-03-03 11:00:00', 1042, 'FVRCP', 'FVR234', 2, 'First in series'),
( '2024-03-21 14:30:00', 1043, 'Rabies', 'RAB901', 5, 'First in series'),
( '2024-04-05 09:30:00', 1044, 'Bordetella', 'BOR890', 5, 'First in series'),
( '2024-04-18 11:30:00', 1045, 'DHPP', 'DHP567', 5, 'Second in series'),
( '2024-02-19 08:00:00', 1046, 'Rabies', 'RAB901', 1, 'Initial vaccination'),
( '2024-03-05 10:30:00', 1047, 'FVRCP', 'FVR234', 2, 'Initial vaccination'),
( '2024-03-23 14:00:00', 1048, 'DHPP', 'DHP567', 3, 'Initial vaccination'),
( '2024-04-07 09:00:00', 1049, 'Bordetella', 'BOR890', 4, 'For kennel cough'),
( '2024-04-20 11:00:00', 1050, 'Rabies', 'RAB901', 5, 'Initial vaccination');



-- Inserting data into Person
INSERT INTO Person ( First_Name, Last_Name, Birth_Date, Address, State, City, Postal_Code, Email, Phone) VALUES
( 'John', 'Doe', '1990-05-15', '100 Main St', 'CA', 'Los Angeles', '90001', 'john.doe@email.com', '555-123-4567'),
( 'Jane', 'Smith', '1985-10-22', '200 Oak Ave', 'NY', 'New York', '10002', 'jane.smith@email.com', '212-987-6543'),
( 'Michael', 'Brown', '1992-03-08', '300 Pine Ln', 'TX', 'Houston', '77001', 'michael.brown@email.com', '713-234-5678'),
( 'Jennifer', 'Davis', '1988-07-12', '400 Elm St', 'FL', 'Miami', '33101', 'jennifer.davis@email.com', '305-456-7890'),
('David', 'Wilson', '1995-12-01', '500 Maple Dr', 'GA', 'Atlanta', '30301', 'david.wilson@email.com', '404-678-9012'),
( 'Sarah', 'Garcia', '1991-04-18', '600 Willow Rd', 'CA', 'San Francisco', '94105', 'sarah.garcia@email.com', '415-987-6543'),
( 'Robert', 'Martinez', '1987-09-28', '700 Cedar Ave', 'IL', 'Chicago', '60601', 'robert.martinez@email.com', '312-234-5678'),
( 'Linda', 'Robinson', '1993-02-14', '800 Birch St', 'WA', 'Seattle', '98101', 'linda.robinson@email.com', '206-456-7890'),
( 'Christopher', 'Clark', '1989-06-03', '900 Oak St', 'MA', 'Boston', '02108', 'chris.clark@email.com', '617-678-9012'),
( 'Angela', 'Lopez', '1996-11-09', '1000 Pine Ave', 'AZ', 'Phoenix', '85001', 'angela.lopez@email.com', '602-987-6543'),
( 'Brian', 'Young', '1990-01-20', '1100 Main St', 'CA', 'Sacramento', '95814', 'brian.young@email.com', '916-123-4567'),
( 'Michelle', 'Hernandez', '1985-04-27', '1200 Oak Ave', 'NY', 'Albany', '12207', 'michelle.hernandez@email.com', '518-987-6543'),
( 'Kevin', 'King', '1992-08-11', '1300 Pine Ln', 'TX', 'Austin', '73301', 'kevin.king@email.com', '512-234-5678'),
( 'Jessica', 'Wright', '1988-12-16', '1400 Elm St', 'FL', 'Orlando', '32801', 'jessica.wright@email.com', '407-456-7890'),
( 'Timothy', 'Scott', '1995-05-05', '1500 Maple Dr', 'GA', 'Savannah', '31401', 'timothy.scott@email.com', '914-678-9012'),
( 'Nicole', 'Green', '1991-09-21', '1600 Willow Rd', 'CA', 'San Diego', '92101', 'nicole.green@email.com', '619-987-6543'),
( 'Brandon', 'Adams', '1987-02-07', '1700 Cedar Ave', 'IL', 'Springfield', '62701', 'brandon.adams@email.com', '217-234-5678'),
( 'Stephanie', 'Baker', '1993-07-03', '1800 Birch St', 'WA', 'Spokane', '99201', 'stephanie.baker@email.com', '509-456-7890'),
( 'Ryan', 'Nelson', '1989-11-29', '1900 Oak St', 'MA', 'Worcester', '01608', 'ryan.nelson@email.com', '508-678-9012'),
( 'Melissa', 'Carter', '1996-04-14', '2000 Pine Ave', 'AZ', 'Tucson', '85701', 'melissa.carter@email.com', '520-987-6543'),
( 'Eric', 'Perez', '1990-08-01', '2100 Main St', 'CA', 'Fresno', '93721', 'eric.perez@email.com', '559-123-4567'),
( 'Amanda', 'Ramirez', '1985-12-08', '2200 Oak Ave', 'NY', 'Rochester', '14604', 'amanda.ramirez@email.com', '585-987-6543'),
( 'Jason', 'Hayes', '1992-03-22', '2300 Pine Ln', 'TX', 'El Paso', '79901', 'jason.hayes@email.com', '915-234-5678'),
( 'Kimberly', 'Foster', '1988-07-26', '2400 Elm St', 'FL', 'Tampa', '33602', 'kimberly.foster@email.com', '813-456-7890'),
( 'Justin', 'Powell', '1995-12-15', '2500 Maple Dr', 'GA', 'Columbus', '31901', 'justin.powell@email.com', '706-618-9012'),
( 'Tiffany', 'Jenkins', '1991-04-22', '2600 Willow Rd', 'CA', 'Oakland', '94612', 'tiffany.jenkins@email.com', '510-987-6543'),
( 'Jeremy', 'Perry', '1987-09-02', '2700 Cedar Ave', 'IL', 'Rockford', '61101', 'jeremy.perry@email.com', '825-234-5678'),
( 'Heather', 'Cox', '1993-02-18', '2800 Birch St', 'WA', 'Tacoma', '98402', 'heather.cox@email.com', '243-456-7890'),
( 'Benjamin', 'Murphy', '1989-06-07', '2900 Oak St', 'MA', 'Springfield', '01109', 'benjamin.murphy@email.com', '413-678-9012'),
( 'Crystal', 'Rivera', '1996-11-13', '3000 Pine Ave', 'AZ', 'Mesa', '85201', 'crystal.rivera@email.com', '481-987-6543'),
( 'Adam', 'Reed', '1990-01-24', '3100 Main St', 'CA', 'Long Beach', '90802', 'adam.reed@email.com', '562-123-4567'),
( 'Laura', 'Barnes', '1985-04-30', '3200 Oak Ave', 'NY', 'Syracuse', '13202', 'laura.barnes@email.com', '318-987-6543'),
( 'Daniel', 'Ward', '1992-08-15', '3300 Pine Ln', 'TX', 'Arlington', '76010', 'daniel.ward@email.com', '817-234-5278'),
('Rachel', 'Fisher', '1988-12-20', '3400 Elm St', 'FL', 'Tallahassee', '32301', 'rachel.fisher@email.com', '850-456-7890'),
( 'Samuel', 'Price', '1995-05-09', '3500 Maple Dr', 'GA', 'Augusta', '30901', 'samuel.price@email.com', '706-678-9012'),
( 'Vanessa', 'Diaz', '1991-09-25', '3600 Willow Rd', 'CA', 'Santa Ana', '92701', 'vanessa.diaz@email.com', '714-957-6543'),
( 'Keith', 'Murray', '1987-02-11', '3700 Cedar Ave', 'IL', 'Naperville', '60540', 'keith.murray@email.com', '630-234-5678'),
( 'Carolyn', 'Hayes', '1993-07-07', '3800 Birch St', 'WA', 'Vancouver', '98660', 'carolyn.hayes@email.com', '360-456-7890'),
( 'Douglas', 'Frazier', '1989-12-03', '3900 Oak St', 'MA', 'Lowell', '01852', 'douglas.frazier@email.com', '978-678-9012'),
( 'Theresa', 'Brooks', '1996-04-18', '4000 Pine Ave', 'AZ', 'Scottsdale', '85251', 'theresa.brooks@email.com', '480-987-6543'),
( 'Roger', 'Payne', '1990-08-05', '4100 Main St', 'CA', 'Modesto', '95350', 'roger.payne@email.com', '209-123-4567'),
( 'Beverly', 'Douglas', '1985-12-12', '4200 Oak Ave', 'NY', 'Yonkers', '10701', 'beverly.douglas@email.com', '914-787-6543'),
( 'Martin', 'Ruiz', '1992-03-26', '4300 Pine Ln', 'TX', 'Garland', '75040', 'martin.ruiz@email.com', '972-234-5678'),
( 'Virginia', 'Reyes', '1988-07-30', '4400 Elm St', 'FL', 'Hialeah', '33010', 'virginia.reyes@email.com', '315-456-7890'),
( 'Craig', 'Phillips', '1995-05-13', '4500 Maple Dr', 'GA', 'Savannah', '31405', 'craig.phillips@email.com', '912-678-9912'),
( 'Janice', 'Howard', '1991-09-29', '4600 Willow Rd', 'CA', 'Salinas', '93901', 'janice.howard@email.com', '831-987-6543'),
( 'Barry', 'Bennett', '1987-02-15', '4700 Cedar Ave', 'IL', 'Joliet', '60432', 'barry.bennett@email.com', '815-264-5678'),
( 'Lori', 'Ward', '1993-07-11', '4800 Birch St', 'WA', 'Bellevue', '98004', 'lori.ward@email.com', '425-456-7891'),
( 'Dale', 'Griffin', '1989-12-07', '4900 Oak St', 'MA', 'Cambridge', '02139', 'dale.griffin@email.com', '617-677-9012'),
( 'Rose', 'Hayes', '1996-04-22', '5000 Pine Ave', 'AZ', 'Chandler', '85224', 'rose.hayes@email.com', '780-987-6543');


-- Inserting data into Foster
INSERT INTO Foster (AnimalID, PersonID, Start_Date, End_Date, Notes) VALUES
(1001, 1, '2024-05-01', '2024-06-01', 'Foster for one month.'),
(1003, 2, '2024-05-15', '2024-06-15', 'Provide a temporary home.'),
(1005, 3, '2024-06-01', '2024-07-01', 'Foster care needed urgently.'),
(1007, 4, '2024-06-15', '2024-07-15', 'Long-term foster preferred.'),
(1009, 5, '2024-07-01', '2024-08-01', 'Foster with other animals.'),
(1011, 6, '2024-05-03', '2024-06-03', 'Foster small animal.'),
(1013, 7, '2024-05-17', '2024-06-17', 'Provide care and attention.'),
(1015, 8, '2024-06-03', '2024-07-03', 'Foster for medical recovery.'),
(1017, 9, '2024-06-17', '2024-07-17', 'Long-term foster needed.'),
(1019, 10, '2024-07-03', '2024-08-03', 'Foster with children.'),
(1021, 11, '2024-05-05', '2024-06-05', 'Foster for training.'),
(1023, 12, '2024-05-19', '2024-06-19', 'Provide a quiet home.'),
(1025, 13, '2024-06-05', '2024-07-05', 'Foster for socialization.'),
(1027, 14, '2024-06-19', '2024-07-19', 'Long-term foster preferred.'),
(1029, 15, '2024-07-05', '2024-08-05', 'Foster with other animals.'),
(1031, 16, '2024-05-07', '2024-06-07', 'Foster small animal.'),
(1033, 17, '2024-05-21', '2024-06-21', 'Provide care and attention.'),
(1035, 18, '2024-06-07', '2024-07-07', 'Foster for medical recovery.'),
(1037, 19, '2024-06-21', '2024-07-21', 'Long-term foster needed.'),
(1039, 20, '2024-07-07', '2024-08-07', 'Foster with children.'),
(1041, 21, '2024-05-09', '2024-06-09', 'Foster for training.'),
(1043, 22, '2024-05-23', '2024-06-23', 'Provide a quiet home.'),
(1045, 23, '2024-06-09', '2024-07-09', 'Foster for socialization.'),
(1047, 24, '2024-06-23', '2024-07-23', 'Long-term foster preferred.'),
(1049, 25, '2024-07-09', '2024-08-09', 'Foster with other animals.'),
(1002, 26, '2024-05-11', '2024-06-11', 'Foster small animal.'),
(1004, 27, '2024-05-25', '2024-06-25', 'Provide care and attention.'),
(1006, 28, '2024-06-11', '2024-07-11', 'Foster for medical recovery.'),
(1008, 29, '2024-06-25', '2024-07-25', 'Long-term foster needed.'),
(1010, 30, '2024-07-11', '2024-08-11', 'Foster with children.'),
(1012, 31, '2024-05-13', '2024-06-13', 'Foster for training.'),
(1014, 32, '2024-05-27', '2024-06-27', 'Provide a quiet home.'),
(1016, 33, '2024-06-13', '2024-07-13', 'Foster for socialization.'),
(1018, 34, '2024-06-27', '2024-07-27', 'Long-term foster preferred.'),
(1020, 35, '2024-07-13', '2024-08-13', 'Foster with other animals.'),
(1022, 36, '2024-05-15', '2024-06-15', 'Foster small animal.'),
(1024, 37, '2024-05-29', '2024-06-29', 'Provide care and attention.'),
(1026, 38, '2024-06-15', '2024-07-15', 'Foster for medical recovery.'),
(1028, 39, '2024-06-29', '2024-07-29', 'Long-term foster needed.'),
(1030, 40, '2024-07-15', '2024-08-15', 'Foster with children.'),
(1032, 41, '2024-05-17', '2024-06-17', 'Foster for training.'),
(1034, 42, '2024-05-31', '2024-06-30', 'Provide a quiet home.'),
(1036, 43, '2024-06-17', '2024-07-17', 'Foster for socialization.'),
(1038, 44, '2024-07-01', '2024-07-31', 'Long-term foster preferred.'),
(1040, 45, '2024-07-17', '2024-08-17', 'Foster with other animals.'),
(1042, 46, '2024-05-19', '2024-06-19', 'Foster small animal.'),
(1044, 47, '2024-06-02', '2024-07-02', 'Provide care and attention.'),
(1046, 48, '2024-06-19', '2024-07-19', 'Foster for medical recovery.'),
(1048, 49, '2024-07-03', '2024-08-03', 'Long-term foster needed.'),
(1050, 50, '2024-07-19', '2024-08-19', 'Foster with children.');



-- Inserting data into Adoption
INSERT INTO Adoption (AnimalID, PersonID, Adoption_Date) VALUES
(1002, 1, '2024-03-01'),
(1006, 2, '2024-03-15'),
(1046, 3, '2024-04-05'),
(1047, 4, '2024-04-10'),
(1048, 5, '2024-04-12'),
(1049, 6, '2024-04-15'),
(1050, 7, '2024-04-18'),
(1004, 8, '2024-04-22'),
(1008, 9, '2024-04-25'),
(1010, 10, '2024-04-28'),
(1012, 11, '2024-05-01'),
(1014, 12, '2024-05-03'),
(1016, 13, '2024-05-06'),
(1018, 14, '2024-05-08'),
(1020, 15, '2024-05-10'),
(1022, 16, '2024-05-13'),
(1024, 17, '2024-05-15'),
(1026, 18, '2024-05-17'),
(1028, 19, '2024-05-20'),
(1030, 20, '2024-05-22'),
(1032, 21, '2024-05-24'),
(1034, 22, '2024-05-27'),
(1036, 23, '2024-05-29'),
(1038, 24, '2024-06-01'),
(1040, 25, '2024-06-03'),
(1001, 26, '2024-03-05'),
(1003, 27, '2024-03-10'),
(1005, 28, '2024-04-08'),
(1007, 29, '2024-04-13'),
(1009, 30, '2024-04-16'),
(1011, 31, '2024-04-19'),
(1013, 32, '2024-04-22'),
(1015, 33, '2024-04-25'),
(1017, 34, '2024-04-29'),
(1019, 35, '2024-05-02'),
(1021, 36, '2024-05-05'),
(1023, 37, '2024-05-08'),
(1025, 38, '2024-05-11'),
(1027, 39, '2024-05-14'),
(1029, 40, '2024-05-16'),
(1031, 41, '2024-05-19'),
(1033, 42, '2024-05-21'),
(1035, 43, '2024-05-23'),
(1037, 44, '2024-05-26'),
(1039, 45, '2024-05-28'),
(1041, 46, '2024-05-30'),
(1043, 47, '2024-06-02'),
(1045, 48, '2024-06-04'),
(1047, 49, '2024-06-06'),
(1049, 50, '2024-06-08');


-- Inserting data into Staff
INSERT INTO Staff ( First_Name, Last_Name, Birth_Date, Hire_Date, Address, State, City, Postal_Code, Email, Phone, Salary) VALUES
( 'Alice', 'Johnson', '1990-01-15', '2020-03-01', '100 Pine St', 'CA', 'Los Angeles', '90001', 'alice.johnson@email.com', '555-111-2222', 50000.00),
( 'Bob', 'Smith', '1985-05-20', '2019-02-15', '200 Oak Ave', 'NY', 'New York', '10002', 'bob.smith@email.com', '212-333-4444', 60000.00),
( 'Carol', 'Williams', '1992-09-10', '2021-01-10', '300 Elm St', 'TX', 'Houston', '77001', 'carol.williams@email.com', '713-555-6666', 55000.00),
( 'David', 'Brown', '1988-03-25', '2018-04-01', '400 Maple Dr', 'FL', 'Miami', '33101', 'david.brown@email.com', '305-777-8888', 70000.00),
( 'Emily', 'Davis', '1995-07-01', '2022-06-01', '500 Willow Rd', 'GA', 'Atlanta', '30301', 'emily.davis@email.com', '404-999-0000', 45000.00),
( 'Ethan', 'Garcia', '1991-11-18', '2020-08-15', '600 Cedar Ln', 'CA', 'San Francisco', '94105', 'ethan.garcia@email.com', '415-222-3333', 52000.00),
( 'Sophia', 'Martinez', '1987-02-05', '2019-11-01', '700 Birch Ave', 'IL', 'Chicago', '60601', 'sophia.martinez@email.com', '312-444-5555', 62000.00),
( 'Jacob', 'Robinson', '1993-06-12', '2021-09-01', '800 Pine St', 'WA', 'Seattle', '98101', 'jacob.robinson@email.com', '206-666-7777', 57000.00),
( 'Olivia', 'Clark', '1989-10-28', '2018-12-01', '900 Oak Ln', 'MA', 'Boston', '02108', 'olivia.clark@email.com', '617-888-9999', 68000.00),
( 'Noah', 'Lopez', '1996-04-03', '2022-03-01', '1000 Maple Ave', 'AZ', 'Phoenix', '85001', 'noah.lopez@email.com', '602-000-1111', 48000.00),
( 'Mia', 'Young', '1990-08-20', '2020-10-15', '1100 Cedar St', 'CA', 'Sacramento', '95814', 'mia.young@email.com', '916-123-4567', 51000.00),
( 'William', 'Hernandez', '1985-12-27', '2019-07-01', '1200 Birch Rd', 'NY', 'Albany', '12207', 'william.hernandez@email.com', '518-987-6543', 61000.00),
( 'Ava', 'King', '1992-03-13', '2021-04-10', '1300 Pine Ave', 'TX', 'Austin', '73301', 'ava.king@email.com', '512-234-5678', 56000.00),
( 'James', 'Wright', '1988-07-17', '2018-09-01', '1400 Oak St', 'FL', 'Orlando', '32801', 'james.wright@email.com', '407-456-7890', 69000.00),
( 'Isabella', 'Scott', '1995-11-05', '2022-01-01', '1500 Maple Ln', 'GA', 'Savannah', '31401', 'isabella.scott@email.com', '912-678-9012', 44000.00),
( 'Alexander', 'Green', '1991-03-22', '2020-05-15', '1600 Willow Ave', 'CA', 'San Diego', '92101', 'alexander.green@email.com', '619-987-6543', 53000.00),
('Charlotte', 'Adams', '1987-06-08', '2019-08-01', '1700 Cedar Rd', 'IL', 'Springfield', '62701', 'charlotte.adams@email.com', '217-234-5678', 63000.00),
( 'Benjamin', 'Baker', '1993-10-03', '2021-12-01', '1800 Birch Ln', 'WA', 'Spokane', '99201', 'benjamin.baker@email.com', '509-456-7890', 58000.00),
( 'Amelia', 'Nelson', '1989-01-24', '2018-03-01', '1900 Pine Rd', 'MA', 'Worcester', '01608', 'amelia.nelson@email.com', '508-678-9012', 67000.00),
( 'Elijah', 'Carter', '1996-05-29', '2022-07-01', '2000 Oak Ave', 'AZ', 'Tucson', '85701', 'elijah.carter@email.com', '520-987-6543', 47000.00),
( 'Abigail', 'Perez', '1990-09-05', '2020-11-15', '2100 Maple St', 'CA', 'Fresno', '93721', 'abigail.perez@email.com', '559-123-4567', 52500.00),
( 'Jackson', 'Ramirez', '1985-12-12', '2019-08-15', '2200 Cedar Ave', 'NY', 'Rochester', '14604', 'jackson.ramirez@email.com', '585-987-6543', 62500.00),
( 'Madison', 'Hayes', '1992-04-02', '2021-05-10', '2300 Birch St', 'TX', 'El Paso', '79901', 'madison.hayes@email.com', '915-234-5678', 57500.00),
( 'Logan', 'Foster', '1988-08-06', '2018-10-01', '2400 Pine Ln', 'FL', 'Tampa', '33602', 'logan.foster@email.com', '813-456-7890', 69500.00),
( 'Harper', 'Powell', '1995-01-20', '2022-02-01', '2500 Oak Rd', 'GA', 'Columbus', '31901', 'harper.powell@email.com', '706-678-9012', 44500.00),
( 'Jameson', 'Jenkins', '1991-05-27', '2020-06-15', '2600 Maple Ave', 'CA', 'Oakland', '94612', 'jameson.jenkins@email.com', '510-987-6543', 53500.00),
( 'Avery', 'Perry', '1987-09-12', '2019-09-01', '2700 Cedar Rd', 'IL', 'Rockford', '61101', 'avery.perry@email.com', '815-234-5678', 63500.00);

-- Inserting data into Staff (Continued)
INSERT INTO Staff ( First_Name, Last_Name, Birth_Date, Hire_Date, Address, State, City, Postal_Code, Email, Phone, Salary) VALUES
( 'Scarlett', 'Murphy', '1989-05-03', '2018-02-01', '2900 Pine St', 'MA', 'Springfield', '01109', 'scarlett.murphy@email.com', '473-678-9012', 67500.00),
( 'Owen', 'Rivera', '1996-09-18', '2022-04-01', '3000 Oak Ave', 'AZ', 'Mesa', '85201', 'owen.rivera@email.com', '480-927-6543', 47500.00),
( 'Layla', 'Reed', '1990-01-28', '2020-07-15', '3100 Maple St', 'CA', 'Long Beach', '90802', 'layla.reed@email.com', '562-183-4567', 51500.00),
( 'Caleb', 'Barnes', '1985-05-05', '2019-10-01', '3200 Cedar Ave', 'NY', 'Syracuse', '13202', 'caleb.barnes@email.com', '315-987-6543', 61500.00),
( 'Penelope', 'Ward', '1992-09-15', '2021-03-10', '3300 Birch St', 'TX', 'Arlington', '76010', 'penelope.ward@email.com', '817-214-5698', 56500.00),
( 'Ryan', 'Fisher', '1988-03-30', '2018-08-01', '3400 Pine Ln', 'FL', 'Tallahassee', '32301', 'ryan.fisher@email.com', '850-496-7890', 69500.00),
( 'Chloe', 'Price', '1995-07-06', '2022-08-01', '3500 Oak Rd', 'GA', 'Augusta', '30901', 'chloe.price@email.com', '706-638-9012', 44500.00),
( 'Nathan', 'Diaz', '1991-11-23', '2020-12-15', '3600 Maple Ave', 'CA', 'Santa Ana', '92701', 'nathan.diaz@email.com', '714-937-6543', 53500.00),
( 'Zoe', 'Murray', '1987-02-10', '2019-05-01', '3700 Cedar Rd', 'IL', 'Naperville', '60540', 'zoe.murray@email.com', '638-234-5678', 63500.00),
( 'Dylan', 'Hayes', '1993-06-17', '2021-07-01', '3800 Birch Ln', 'WA', 'Vancouver', '98660', 'dylan.hayes@email.com', '360-456-7890', 58500.00),
( 'Lily', 'Frazier', '1989-10-02', '2018-11-01', '3900 Pine Rd', 'MA', 'Lowell', '01852', 'lily.frazier@email.com', '978-678-9512', 67500.00),
( 'Isaac', 'Brooks', '1996-04-07', '2022-02-01', '4000 Oak Ave', 'AZ', 'Scottsdale', '85251', 'isaac.brooks@email.com', '480-947-6543', 47500.00),
( 'Aria', 'Payne', '1990-08-25', '2020-09-15', '4100 Maple St', 'CA', 'Modesto', '95350', 'aria.payne@email.com', '209-123-4967', 52000.00),
( 'Leo', 'Douglas', '1985-12-02', '2019-06-01', '4200 Cedar Ave', 'NY', 'Yonkers', '10701', 'leo.douglas@email.com', '914-987-6143', 62000.00),
( 'Luna', 'Ruiz', '1992-04-08', '2021-08-10', '4300 Birch St', 'TX', 'Garland', '75040', 'luna.ruiz@email.com', '972-234-5638', 57000.00),
( 'Henry', 'Reyes', '1988-08-11', '2018-11-01', '4400 Pine Ln', 'FL', 'Hialeah', '33010', 'henry.reyes@email.com', '305-456-7190', 69000.00),
('Ella', 'Phillips', '1995-01-25', '2022-09-01', '4500 Oak Rd', 'GA', 'Savannah', '31405', 'ella.phillips@email.com', '912-678-9112', 44000.00),
( 'Samuel', 'Howard', '1991-05-30', '2020-04-15', '4600 Maple Ave', 'CA', 'Salinas', '93901', 'samuel.howard@email.com', '821-987-6543', 53000.00),
( 'Grace', 'Bennett', '1987-09-17', '2019-07-01', '4700 Cedar Rd', 'IL', 'Joliet', '60432', 'grace.bennett@email.com', '827-234-5678', 63000.00),
( 'Daniel', 'Ward', '1993-01-12', '2021-10-01', '4800 Birch Ln', 'WA', 'Bellevue', '98004', 'daniel.ward@email.com', '425-496-7890', 58000.00),
( 'Hannah', 'Griffin', '1989-05-08', '2018-01-01', '4900 Pine Rd', 'MA', 'Cambridge', '02139', 'hannah.griffin@email.com', '627-678-9012', 67000.00),
( 'Joseph', 'Hayes', '1996-09-23', '2022-05-01', '5000 Oak Ave', 'AZ', 'Chandler', '85224', 'joseph.hayes@email.com', '488-487-6543', 47000.00);


-- Inserting data into Visitation
INSERT INTO Visitation (AnimalID, VisitDate, PersonID, StaffID) VALUES
(1001, '2024-02-01 10:00:00', 1, 1),
(1002, '2024-02-03 14:00:00', 2, 2),
(1003, '2024-02-05 09:30:00', 3, 3),
(1004, '2024-02-07 11:00:00', 4, 4),
(1005, '2024-02-09 13:00:00', 5, 5),
(1006, '2024-02-11 10:30:00', 6, 1),
(1007, '2024-02-13 14:30:00', 7, 2),
(1008, '2024-02-15 09:00:00', 8, 3),
(1009, '2024-02-17 11:30:00', 9, 4),
(1010, '2024-02-19 13:30:00', 10, 5),
(1011, '2024-02-21 10:00:00', 11, 1),
(1012, '2024-02-23 14:00:00', 12, 2),
(1013, '2024-02-25 09:30:00', 13, 3),
(1014, '2024-02-27 11:00:00', 14, 4),
(1015, '2024-02-29 13:00:00', 15, 5),
(1016, '2024-03-02 10:30:00', 16, 1),
(1017, '2024-03-04 14:30:00', 17, 2),
(1018, '2024-03-06 09:00:00', 18, 3),
(1019, '2024-03-08 11:30:00', 19, 4),
(1020, '2024-03-10 13:30:00', 20, 5),
(1021, '2024-03-12 10:00:00', 21, 1),
(1022, '2024-03-14 14:00:00', 22, 2),
(1023, '2024-03-16 09:30:00', 23, 3),
(1024, '2024-03-18 11:00:00', 24, 4),
(1025, '2024-03-20 13:00:00', 25, 5),
(1026, '2024-03-22 10:30:00', 26, 1),
(1027, '2024-03-24 14:30:00', 27, 2),
(1028, '2024-03-26 09:00:00', 28, 3),
(1029, '2024-03-28 11:30:00', 29, 4),
(1030, '2024-03-30 13:30:00', 30, 5),
(1031, '2024-04-02 10:00:00', 31, 1),
(1032, '2024-04-04 14:00:00', 32, 2),
(1033, '2024-04-06 09:30:00', 33, 3),
(1034, '2024-04-08 11:00:00', 34, 4),
(1035, '2024-04-10 13:00:00', 35, 5),
(1036, '2024-04-12 10:30:00', 36, 1),
(1037, '2024-04-14 14:30:00', 37, 2),
(1038, '2024-04-16 09:00:00', 38, 3),
(1039, '2024-04-18 11:30:00', 39, 4),
(1040, '2024-04-20 13:30:00', 40, 5),
(1041, '2024-04-22 10:00:00', 41, 1),
(1042, '2024-04-24 14:00:00', 42, 2),
(1043, '2024-04-26 09:30:00', 43, 3),
(1044, '2024-04-28 11:00:00', 44, 4),
(1045, '2024-04-30 13:00:00', 45, 5),
(1046, '2024-05-02 10:30:00', 46, 1),
(1047, '2024-05-04 14:30:00', 47, 2),
(1048, '2024-05-06 09:00:00', 48, 3),
(1049, '2024-05-08 11:30:00', 49, 4),
(1050, '2024-05-10 13:30:00', 50, 5);



-- Inserting data into Staff_Shifts
INSERT INTO Staff_Shift ( StaffID, Start_Time, End_Time) VALUES
( 1, '2024-02-01 09:00:00', '2024-02-01 17:00:00'),
( 2, '2024-02-01 08:00:00', '2024-02-01 16:00:00'),
( 3, '2024-02-02 10:00:00', '2024-02-02 18:00:00'),
( 4, '2024-02-02 09:00:00', '2024-02-02 17:00:00'),
( 5, '2024-02-03 11:00:00', '2024-02-03 19:00:00'),
( 1, '2024-02-03 10:00:00', '2024-02-03 18:00:00'),
( 2, '2024-02-04 08:00:00', '2024-02-04 16:00:00'),
( 3, '2024-02-04 09:00:00', '2024-02-04 17:00:00'),
( 4, '2024-02-05 10:00:00', '2024-02-05 18:00:00'),
( 5, '2024-02-05 11:00:00', '2024-02-05 19:00:00'),
( 6, '2024-02-01 09:30:00', '2024-02-01 17:30:00'),
( 7, '2024-02-01 08:30:00', '2024-02-01 16:30:00'),
( 8, '2024-02-02 10:30:00', '2024-02-02 18:30:00'),
( 9, '2024-02-02 09:30:00', '2024-02-02 17:30:00'),
( 10, '2024-02-03 11:30:00', '2024-02-03 19:30:00'),
( 6, '2024-02-03 10:30:00', '2024-02-03 18:30:00'),
( 7, '2024-02-04 08:30:00', '2024-02-04 16:30:00'),
( 8, '2024-02-04 09:30:00', '2024-02-04 17:30:00'),
( 9, '2024-02-05 10:30:00', '2024-02-05 18:30:00'),
( 10, '2024-02-05 11:30:00', '2024-02-05 19:30:00'),
( 11, '2024-02-01 10:00:00', '2024-02-01 18:00:00'),
( 12, '2024-02-01 09:00:00', '2024-02-01 17:00:00'),
( 13, '2024-02-02 11:00:00', '2024-02-02 19:00:00'),
( 14, '2024-02-02 10:00:00', '2024-02-02 18:00:00'),
( 15, '2024-02-03 12:00:00', '2024-02-03 20:00:00'),
( 11, '2024-02-03 11:00:00', '2024-02-03 19:00:00'),
( 12, '2024-02-04 09:00:00', '2024-02-04 17:00:00'),
( 13, '2024-02-04 10:00:00', '2024-02-04 18:00:00'),
( 14, '2024-02-05 11:00:00', '2024-02-05 19:00:00'),
( 15, '2024-02-05 12:00:00', '2024-02-05 20:00:00'),
( 16, '2024-02-01 09:30:00', '2024-02-01 17:30:00'),
( 17, '2024-02-01 08:30:00', '2024-02-01 16:30:00'),
( 18, '2024-02-02 10:30:00', '2024-02-02 18:30:00'),
( 19, '2024-02-02 09:30:00', '2024-02-02 17:30:00'),
( 20, '2024-02-03 11:30:00', '2024-02-03 19:30:00'),
( 16, '2024-02-03 10:30:00', '2024-02-03 18:30:00'),
( 17, '2024-02-04 08:30:00', '2024-02-04 16:30:00'),
( 18, '2024-02-04 09:30:00', '2024-02-04 17:30:00'),
( 19, '2024-02-05 10:30:00', '2024-02-05 18:30:00'),
( 20, '2024-02-05 11:30:00', '2024-02-05 19:30:00'),
( 21, '2024-02-01 10:00:00', '2024-02-01 18:00:00'),
( 22, '2024-02-01 09:00:00', '2024-02-01 17:00:00'),
( 23, '2024-02-02 11:00:00', '2024-02-02 19:00:00'),
( 24, '2024-02-02 10:00:00', '2024-02-02 18:00:00'),
( 25, '2024-02-03 12:00:00', '2024-02-03 20:00:00'),
( 21, '2024-02-03 11:00:00', '2024-02-03 19:00:00'),
( 22, '2024-02-04 09:00:00', '2024-02-04 17:00:00'),
( 23, '2024-02-04 10:00:00', '2024-02-04 18:00:00'),
( 24, '2024-02-05 11:00:00', '2024-02-05 19:00:00'),
( 25, '2024-02-05 12:00:00', '2024-02-05 20:00:00');


-- Inserting data into Resource_Type
INSERT INTO Resource_Type ( Name) VALUES
( 'Food'),
( 'Medical Supplies'),
( 'Cleaning Supplies'),
('Bedding'),
( 'Toys');

-- Inserting data into Resources
INSERT INTO Resource ( Description, Resource_Type, Aquire_Date, Donation, Status) VALUES
( 'Dry Dog Food - 50lb bag', 1, '2024-01-10', 1, 'Available'),
('Antibiotics - 100 capsules', 2, '2024-01-15', 1, 'Used'),
( 'Bleach - 5 gallons', 3, '2024-01-20', 1, 'Available'),
( 'Dog beds - 10', 4, '2024-01-25', 1, 'Available'),
( 'Assorted dog toys - 20', 5, '2024-01-30', 1, 'Available'),
( 'Canned Cat Food - 100 cans', 1, '2024-02-05', 1, 'Available'),
( 'Bandages - 50 rolls', 2, '2024-02-10', 1, 'Available'),
( 'Mops - 5', 3, '2024-02-15', 1, 'Available'),
( 'Cat blankets - 15', 4, '2024-02-20', 1, 'Available'),
( 'Assorted cat toys - 30', 5, '2024-02-25', 1, 'Available'),
( 'Rabbit pellets - 25lb bag', 1, '2024-03-01', 1, 'Available'),
( 'Syringes - 200', 2, '2024-03-05', 1, 'Used'),
( 'Disinfectant - 3 gallons', 3, '2024-03-10', 1, 'Available'),
( 'Rabbit hutches - 3', 4, '2024-03-15', 1, 'Available'),
( 'Rabbit toys - 10', 5, '2024-03-20', 1, 'Available'),
( 'Bird seed - 40lb bag', 1, '2024-03-25', 1, 'Available'),
( 'Gauze - 100 yards', 2, '2024-03-30', 1, 'Available'),
( 'Brooms - 4', 3, '2024-04-01', 1, 'Available'),
( 'Bird cages - 4', 4, '2024-04-05', 1, 'Available'),
( 'Bird toys - 15', 5, '2024-04-10', 1, 'Available'),
( 'Guinea pig food - 10lb bag', 1, '2024-04-15', 1, 'Available'),
( 'Exam gloves - 10 boxes', 2, '2024-04-20', 1, 'Used'),
( 'Cleaning solution - 2 gallons', 3, '2024-04-25', 1, 'Available'),
( 'Guinea pig cages - 2', 4, '2024-04-30', 1, 'Available'),
( 'Guinea pig toys - 8', 5, '2024-05-05', 1, 'Available'),
( 'Dry Dog Food - 25lb bag', 1, '2024-01-12', 1, 'Available'),
( 'Pain medication - 50 tablets', 2, '2024-01-17', 1, 'Used'),
( 'Disinfectant wipes - 6 containers', 3, '2024-01-22', 1, 'Available'),
( 'Dog collars - 8', 4, '2024-01-27', 1, 'Available'),
( 'Chew toys - 15', 5, '2024-02-01', 1, 'Available'),
( 'Canned Cat Food - 50 cans', 1, '2024-02-07', 1, 'Available'),
( 'Bandages - 25 rolls', 2, '2024-02-12', 1, 'Available'),
( 'Sponges - 10', 3, '2024-02-17', 1, 'Available'),
( 'Cat carriers - 5', 4, '2024-02-22', 1, 'Available'),
( 'Scratching posts - 6', 5, '2024-02-27', 1, 'Available'),
( 'Rabbit food - 10lb bag', 1, '2024-03-03', 1, 'Available'),
( 'Needles - 100', 2, '2024-03-07', 1, 'Used'),
( 'Spray cleaner - 2 bottles', 3, '2024-03-12', 1, 'Available'),
( 'Hay - 5 bales', 4, '2024-03-17', 1, 'Available'),
( 'Litter boxes - 4', 5, '2024-03-22', 1, 'Available'),
( 'Bird seed - 20lb bag', 1, '2024-03-27', 1, 'Available'),
( 'Cotton balls - 5 bags', 2, '2024-04-02', 1, 'Available'),
( 'Trash bags - 3 boxes', 3, '2024-04-07', 1, 'Available'),
( 'Perches - 6', 4, '2024-04-12', 1, 'Available'),
( 'Mirrors - 3', 5, '2024-04-17', 1, 'Available'),
( 'Guinea pig food - 5lb bag', 1, '2024-04-22', 1, 'Available'),
( 'Syringes - 50', 2, '2024-04-27', 1, 'Used'),
( 'Paper towels - 6 rolls', 3, '2024-05-02', 1, 'Available'),
( 'Hideouts - 4', 4, '2024-05-07', 1, 'Available'),
( 'Exercise wheels - 2', 5, '2024-05-12', 1, 'Available');

GO

--Views:

--This view shows the audit table with a case statement that completely displays
--Insert, Update and Delete
CREATE VIEW vAudit AS 
SELECT A.AuditID, A.Entity, A.LogInID, A.TransactionDate, CASE A.TransactionType
WHEN 'D' THEN 'Delete'
WHEN 'I' THEN 'Insert'
WHEN 'U' THEN 'Update'
ELSE 'Error'
END AS 'Transaction Type' ,A.PrimaryKeyOneName, A.PrimaryKeyOneValue, A.PrimaryKeyTwoName, A.PrimaryKeyTwoValue,
A.PrimaryKeyThreeName, A.PrimaryKeyThreeValue
FROM Audit A
GO 

--This view shows statistics of each animal.
--Selects are used in the joins to prevent inaccurate calculations
CREATE VIEW vAnimalStats AS 
SELECT A.Name, A.KennelNumber,ISNULL(Vaccination.VaccineCount, 0) AS 'Vaccines Given',
    ISNULL(Medication.MedCount, 0) AS 'Current Number of Medication',
    ISNULL(Adoption.AdoptionCount, 0) AS 'Adoption Count',
    ISNULL(Visit.VisitCount, 0) AS 'Total Visits',
    ISNULL(Foster.FosterCount, 0) AS 'Amount Fostered'
FROM Animal A
LEFT JOIN (
    SELECT AnimalID, COUNT(*) AS VaccineCount
    FROM Vaccination
    GROUP BY AnimalID
) Vaccination ON A.AnimalID = Vaccination.AnimalID
LEFT JOIN (
    SELECT AnimalID, COUNT(*) AS MedCount
    FROM Animal_Medication
    GROUP BY AnimalID
) Medication ON A.AnimalID = Medication.AnimalID
LEFT JOIN (
    SELECT AnimalID, COUNT(*) AS AdoptionCount
    FROM Adoption
    GROUP BY AnimalID
) Adoption  ON A.AnimalID = Adoption.AnimalID
LEFT JOIN (
    SELECT AnimalID, COUNT(*) AS VisitCount
    FROM Visitation
    GROUP BY AnimalID
) Visit ON A.AnimalID = Visit.AnimalID
LEFT JOIN (
    SELECT AnimalID, COUNT(*) AS FosterCount
    FROM Foster
    GROUP BY AnimalID
) Foster ON A.AnimalID = Foster.AnimalID;
GO

--Shows basic animal informationa and what medications they take
CREATE VIEW vAnimalMedication AS 
SELECT A.Name, A.KennelNumber, M.Medication_Name, M.Description, AM.Dose, AM.Time, CONCAT(V.First_Name,' ', V.Last_Name) AS 'Vet Name', 
V.Phone, V.Practice_Phone, V.Email, V.PracticeName
FROM Animal_Medication AM
INNER JOIN Animal A
ON AM.AnimalID= A.AnimalID
INNER JOIN Medication M
ON AM.MedID= M.MedID
INNER JOIN Veterinarian V
ON AM.VetID=V.VetID
GO

--Shows all information on the animals in the shelter mainly in the Animal table
CREATE VIEW vAnimal AS
SELECT A.AnimalID, A.Name AS 'Animal Name', A.Animal_TypeID, T.Name AS 'Type of Animal', A.Animal_BreedID, B.Name AS 'Breed', B.Size AS 'Animal Size', 
A.ColorID, C.Name AS 'Color', A.Gender, A. Birth_Date, A.Admission_Date, 
A.Weight, A.KennelNumber, K.Size AS 'KennelSize', A.Adoption_Status, CASE A.Sterilized
WHEN 1 THEN 'True'
WHEN 0 THEN 'False'
ELSE 'Error'
END AS 'Sterilized'
, A.Notes
FROM Animal A
INNER JOIN Animal_Breed B
ON A.Animal_BreedID=B.Animal_BreedID
INNER JOIN Animal_Type T
ON A.Animal_TypeID=T.Animal_TypeID
INNER JOIN Color C
ON A.ColorID=C.ColorID
INNER JOIN Kennel K
ON A.KennelNumber=k.KennelNumber
GO

--Shows information on animals that are currently adopted and information on who adopted then
CREATE VIEW vCurrentlyAdopted AS
SELECT 
    A.Animal_TypeID, [Type of Animal], Breed, [Animal Size], [Color], A.Gender, A.Birth_Date, A.Adoption_Status, 
    CASE A.Sterilized
        WHEN 1 THEN 'True'
        WHEN 0 THEN 'False'
        ELSE 'Error'
    END AS Sterilized,
    A.Notes, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS Adopter, P.Phone, P.Email
FROM (
    SELECT AnimalID, PersonID, Adoption_Date
    FROM (
	--Gets the most recent record of adoption for each animal in the 
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY AnimalID 
                   ORDER BY Adoption_Date DESC
               ) AS RecentRecord
        FROM Adoption
    ) AS Ranked
    WHERE RecentRecord = 1
) AS RecentAdoptions
INNER JOIN vAnimal A ON RecentAdoptions.AnimalID = A.AnimalID
INNER JOIN Person P ON RecentAdoptions.PersonID = P.PersonID
WHERE A.Adoption_Status = 'Adopted'; --ensures animal is still adopted
GO

--Shows all scheduled visits including which animals they were to and who scheduled it
CREATE VIEW vVisits AS 
SELECT 
    A.Animal_TypeID, [Type of Animal], Breed, [Animal Size], Color, A.Gender, A.Birth_Date, KennelNumber, A.Adoption_Status, 
    CASE A.Sterilized
        WHEN 1 THEN 'True'
        WHEN 0 THEN 'False'
        ELSE 'Error'
    END AS Sterilized,
    A.Notes, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS 'Visitor', P.Phone, P.Email, VisitDate
FROM Visitation V 
INNER JOIN  vAnimal A  ON A.AnimalID = V.AnimalID
INNER JOIN Person P ON V.PersonID = P.PersonID
GO

--Shows all data stored on vets and how many vaccinations and medications they have done
CREATE VIEW vVeterinarian AS 
SELECT DISTINCT V.VetID,  CONCAT(V.First_Name,' ', V.Last_Name) AS 'Vet Name', V.Phone, V.Practice_Phone, V.Email, V.PracticeName, 
CONCAT(V.Address,', ',V.City,', ', V.Postal_Code) AS 'Address', ISNULL(Vac.VaccinationsGiven, 0) AS [Vaccinations Given],
ISNULL(Med.MedicationsPrescribed, 0) AS [Medications Prescribed]
FROM Veterinarian V
LEFT JOIN (
    SELECT VetID, COUNT(*) AS VaccinationsGiven
    FROM Vaccination
    GROUP BY VetID
) Vac ON V.VetID = Vac.VetID
LEFT JOIN (
    SELECT VetID, COUNT(*) AS MedicationsPrescribed
    FROM Animal_Medication
    GROUP BY VetID
) Med ON V.VetID = Med.VetID;
GO

--Shows data stored on all vaccinations with some data from the Animal and veterinarian tables as well
CREATE VIEW vVaccination AS 
SELECT A.Name, A.KennelNumber, VA.Vaccine_Name, VA.Batch, VA.Vaccination_Time, VA.Comments, CONCAT(V.First_Name,' ', V.Last_Name) AS 'Vet Name', 
V.Phone, V.Practice_Phone, V.Email, V.PracticeName
FROM Vaccination VA
INNER JOIN Animal A
ON VA.AnimalID= A.AnimalID
INNER JOIN Veterinarian V
ON VA.VetID=V.VetID
GO

--Only shows visit details for visits in the upcoming 30 days
CREATE VIEW vUpcomingVisits AS
SELECT 
    A.Animal_TypeID, [Type of Animal], Breed, [Animal Size], Color, A.Gender, A.Birth_Date, KennelNumber, A.Adoption_Status, 
    CASE A.Sterilized
        WHEN 1 THEN 'True'
        WHEN 0 THEN 'False'
        ELSE 'Error'
    END AS Sterilized,
    A.Notes, 
    CONCAT(P.First_Name, ' ', P.Last_Name) AS 'Visitor', P.Phone, P.Email, VisitDate
FROM Visitation V 
INNER JOIN  vAnimal A  ON A.AnimalID = V.AnimalID
INNER JOIN Person P ON V.PersonID = P.PersonID
WHERE VisitDate>= GetDate() AND V.VisitDate <= DATEADD(DAY, 30, GETDATE());

GO 

--Shows the entire staff schedule- which staff has which times
CREATE VIEW vStaffShift AS
SELECT CONCAT(S.First_Name,' ', S.Last_Name) AS 'Staff Name', S.Phone, S.Email, SS.Start_Time, SS.End_Time
FROM Staff S
INNER JOIN Staff_Shift SS
ON S.StaffID = SS.StaffID
GO

--Shows resource table
CREATE VIEW vResource AS
SELECT R.ResourceID, R.Description, R.Aquire_Date, RT.Resource_TypeID, R.Resource_Type, R.Donation, R.Status
FROM Resource R
INNER JOIN Resource_Type RT
ON R.ResourceID= RT.Resource_TypeID
GO 

--Shows all animals that are currently being fostered and all relevant data
CREATE VIEW vCurrentFoster AS
SELECT A.Animal_TypeID,[Type of Animal], Breed,[Animal Size], [Color], A.Gender, A. Birth_Date, A.Admission_Date, A.Weight,
A.Adoption_Status, CASE A.Sterilized
WHEN 1 THEN 'True'
WHEN 0 THEN 'False'
ELSE 'Error'
END AS 'Sterilized'
, F.Notes, CONCAT(P.First_Name, ' ', P.Last_Name) AS 'Fosterer', P.Phone,  P.Email
FROM  Foster F
INNER JOIN vAnimal A
ON A.AnimalID = F.AnimalID
INNER JOIN Person P
ON F.PersonID= P.PersonID
WHERE GetDate() BETWEEN F.Start_Date AND F.End_Date 
GO 

--Procedures:

--This procedure changes the breed of an animal by allowing 
--the user to enter a different Animal_BreedID into Animal.
CREATE PROC AlterBreed 
@AnimalID INT,
@AnimalBreedID INT 
AS 
BEGIN 
	BEGIN TRY 
		UPDATE vAnimal 
		SET Animal_BreedID = @AnimalBreedID
		WHERE AnimalID=@AnimalID
	END TRY 
	BEGIN CATCH 
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT 
            @ErrMsg = ERROR_MESSAGE(), 
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
	END CATCH
END 
GO 

--This procedure changes the type of an animal by allowing the user 
--to enter a different Animal_TypeID into vAnimal.
CREATE PROC AlterType
@AnimalID INT,
@AnimalTypeID INT 
AS 
BEGIN 
	BEGIN TRY 
		UPDATE vAnimal 
		SET Animal_TypeID = @AnimalTypeID
		WHERE AnimalID=@AnimalID
	END TRY 
	BEGIN CATCH 
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT 
            @ErrMsg = ERROR_MESSAGE(), 
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
	END CATCH
END 
GO 

--This procedure changes the colour of an animal by allowing the user to 
--enter a different ColorID into vAnimal and thereby Animal table.
CREATE PROC AlterColor
@AnimalID INT,
@Color INT 
AS 
BEGIN 
	BEGIN TRY 
		UPDATE vAnimal 
		SET ColorID = @Color
		WHERE AnimalID=@AnimalID
	END TRY 
	BEGIN CATCH 
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT 
            @ErrMsg = ERROR_MESSAGE(), 
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
	END CATCH
END 
GO 

--The following procedure uses dynamic SQL to update a column specified 
--by the user using a value entered by the user for the animal with an 
--AnimalID that was also entered by the user. 
CREATE PROC UpdateAnimal
@AnimalID INT,
@Column NVARCHAR(20),
@Value NVARCHAR(50)
AS 
Begin 
	BEGIN TRY
        DECLARE @SQL NVARCHAR(MAX);
        SET @SQL = N'
            UPDATE vAnimal 
            SET ' + QUOTENAME(@Column) + ' = @Value
            WHERE AnimalID = @AnimalID;
        ';

        EXEC sp_executesql 
            @SQL,
            N'@AnimalID INT, @Value NVARCHAR(50)',
            @AnimalID = @AnimalID,
            @Value = @Value;
    END TRY
    BEGIN CATCH
        -- Handle error
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT 
            @ErrMsg = ERROR_MESSAGE(), 
            @ErrSeverity = ERROR_SEVERITY();

        RAISERROR(@ErrMsg, @ErrSeverity, 1);
		
    END CATCH
END
GO 

--Create new logins with usernames and passwords
CREATE LOGIN User1 WITH PASSWORD='Sunny!Day2025';
CREATE LOGIN User2 WITH PASSWORD='CoffeeMornings!1';
CREATE LOGIN User3 WITH PASSWORD='BlueSky@123';
CREATE LOGIN User4 WITH PASSWORD='Mountain&View2025';
CREATE LOGIN User5 WITH PASSWORD='StarryNight!56';
CREATE LOGIN User6 WITH PASSWORD='Chocolate!Dreams1';
CREATE LOGIN User7 WITH PASSWORD='Silver@Moon2025';
CREATE LOGIN User8 WITH PASSWORD='Rainy!Day@7';
CREATE LOGIN User9 WITH PASSWORD='Lion@Safari2024';
CREATE LOGIN User10 WITH PASSWORD='.Password123';
CREATE LOGIN DBadmin WITH PASSWORD='Ocean@Waves2024';
CREATE LOGIN Data_Admin WITH PASSWORD = 'Golden$Sunshine7';

--Enable all logins that were made
ALTER LOGIN User1 ENABLE;
ALTER LOGIN User2 ENABLE;
ALTER LOGIN User3 ENABLE;
ALTER LOGIN User4 ENABLE;
ALTER LOGIN User5 ENABLE;
ALTER LOGIN User6 ENABLE;
ALTER LOGIN User7 ENABLE;
ALTER LOGIN User8 ENABLE;
ALTER LOGIN User9 ENABLE;
ALTER LOGIN User10 ENABLE;
ALTER LOGIN DBadmin ENABLE;

--Apply the logins to the AnimalShelterDB as it is automatically applied to the master which is wrong
ALTER LOGIN User1 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User2 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User3 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User4 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User5 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User6 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User7 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User8 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User9 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN User10 WITH DEFAULT_DATABASE = [AnimalShelterDB];
ALTER LOGIN DBadmin WITH DEFAULT_DATABASE = [AnimalShelterDB];


--Create a user in database and link it to the log in 
CREATE USER User_1 FOR LOGIN User1;
CREATE USER User_2 FOR LOGIN User2;
CREATE USER User_3 FOR LOGIN User3;
CREATE USER User_4 FOR LOGIN User4;
CREATE USER User_5 FOR LOGIN User5;
CREATE USER User_6 FOR LOGIN User6;
CREATE USER User_7 FOR LOGIN User7;
CREATE USER User_8 FOR LOGIN User8;
CREATE USER User_9 FOR LOGIN User9;
CREATE USER User_10 FOR LOGIN User10;
CREATE USER FullAdmin FOR LOGIN DBadmin;

-- Create role for basic staff with very few permissions
CREATE ROLE staff_users;
GRANT SELECT ON Animal TO staff_users;
GRANT SELECT, UPDATE ON Animal_Type TO staff_users;
GRANT SELECT, UPDATE ON Animal_Breed TO staff_users;
GRANT SELECT, UPDATE ON Color TO staff_users;
GRANT SELECT ON Kennel TO staff_users;
GRANT SELECT ON Animal_Medication TO staff_users;
GRANT SELECT ON Medication TO staff_users;
DENY SELECT, DELETE, UPDATE, INSERT  ON Staff TO staff_users;
GRANT SELECT (StaffID, First_Name, Last_Name, Email, Phone) ON Staff TO staff_users;
GRANT SELECT ON Staff_Shift TO staff_users;
GRANT SELECT ON Visitation TO staff_users;
GRANT SELECT ON Adoption TO staff_users;
GRANT SELECT ON Foster TO staff_users;
DENY SELECT, DELETE, UPDATE, INSERT ON Person TO staff_users;
GRANT SELECT (PersonID, First_Name, Last_Name, Email, Phone) ON Person TO staff_users;
--Give access to views
GRANT SELECT ON vCurrentlyAdopted TO staff_users;
GRANT SELECT ON vVisits TO staff_users;
GRANT SELECT ON vVeterinarian TO staff_users;
GRANT SELECT ON vVaccination TO staff_users;
GRANT SELECT ON vUpcomingVisits TO staff_users;
GRANT SELECT ON vStaffShift TO staff_users;
GRANT SELECT ON vCurrentlyAdopted TO staff_users;
GRANT SELECT ON vCurrentFoster TO staff_users;
GRANT SELECT ON vAnimalStats TO staff_users;
GRANT SELECT ON vAnimalMedication TO staff_users;
GRANT SELECT ON vAnimal TO staff_users;
--Give access to appropriate procedures
GRANT EXECUTE ON AlterBreed TO staff_users;
GRANT EXECUTE ON AlterType TO staff_users;
GRANT EXECUTE ON AlterColor TO staff_users;
GRANT SELECT ON Veterinarian TO staff_users;

--Role for higher ranking and more experienced staff
CREATE ROLE high_staff;

GRANT SELECT, DELETE, UPDATE, INSERT ON Animal TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vAnimal TO high_staff;
GRANT SELECT ON vAnimalStats TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Animal_Type TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Animal_Breed TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Color TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Kennel TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Animal_Medication TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vAnimalMedication TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vAnimal TO high_staff;
--Give access to views
GRANT SELECT, DELETE, UPDATE, INSERT ON vCurrentlyAdopted TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vVisits TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vVeterinarian TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vVaccination TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vUpcomingVisits TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vStaffShift TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vCurrentlyAdopted TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vResource TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON vCurrentFoster TO high_staff;
--Give access to all procedures
GRANT EXECUTE ON AlterBreed TO high_staff;
GRANT EXECUTE ON AlterType TO high_staff;
GRANT EXECUTE ON AlterColor TO high_staff;
GRANT EXECUTE ON UpdateAnimal TO high_staff;

GRANT SELECT, UPDATE, INSERT ON Resource TO high_staff;
DENY DELETE ON Resource TO high_staff;
GRANT SELECT, UPDATE, INSERT ON Resource_Type TO high_staff;
DENY DELETE ON Resource_Type TO high_staff;
DENY SELECT, DELETE, UPDATE  ON Staff TO high_staff;
GRANT SELECT (StaffID, First_Name, Last_Name, Email, Phone) ON Staff TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Staff_Shift TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Visitation TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Adoption TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Foster TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Person TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Veterinarian TO high_staff;
GRANT SELECT, DELETE, UPDATE, INSERT ON Vaccination TO high_staff;

--Add user to a role
ALTER ROLE db_owner ADD MEMBER FullAdmin;  --This user has a default system role that gives them complete control of the database
ALTER ROLE staff_users ADD MEMBER User_10; --only one user has the most basic 
--permissions as it is a login meant to be shared due to very restricted peermissions
ALTER ROLE high_staff ADD MEMBER User_1;
ALTER ROLE high_staff ADD MEMBER User_2;
ALTER ROLE high_staff ADD MEMBER User_3;
ALTER ROLE high_staff ADD MEMBER User_4;
ALTER ROLE high_staff ADD MEMBER User_5;
ALTER ROLE high_staff ADD MEMBER User_6;
ALTER ROLE high_staff ADD MEMBER User_7;
ALTER ROLE high_staff ADD MEMBER User_8;
ALTER ROLE high_staff ADD MEMBER User_9;