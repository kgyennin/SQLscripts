USE master
GO

IF EXISTS (SELECT name FROM SYSDATABASES
		WHERE name = 'ETMS')
	DROP DATABASE ETMS
GO

CREATE DATABASE ETMS
GO

USE ETMS
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'Expense')
	DROP TABLE Expense
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'TimeSheet')
	DROP TABLE Timesheet
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'Project')
	DROP TABLE Project
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'Employee')
	DROP TABLE Employee
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'Department')
	DROP TABLE Department
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'Client')
	DROP TABLE Client
GO

CREATE TABLE Client
(
	ClientCode			VARCHAR(10)	PRIMARY KEY	NOT NULL,
	ClientName			VARCHAR(50)				NOT NULL,
	ContactName			VARCHAR(50)				NOT NULL,
	ContactPhone		VARCHAR(15)				NOT NULL,
	Location			VARCHAR(50)				NOT NULL
)

CREATE TABLE Department
(
	DepartmentCode		VARCHAR(10) PRIMARY KEY	NOT NULL,
	DepartmentName		VARCHAR(50)				NOT NULL
)

CREATE TABLE Employee
(
	EmployeeCode		VARCHAR(10) PRIMARY KEY		NOT NULL,
	DepartmentCode		VARCHAR(10)					NOT NULL
		FOREIGN KEY(DepartmentCode) REFERENCES Department(DepartmentCode),
	FirstName			VARCHAR(25)				NOT NULL,
	LastName			VARCHAR(25)				NOT NULL,
	DateOfBirth			SMALLDATETIME			NULL,
	Address				VARCHAR(50)				NULL,
	City				VARCHAR(20)				NULL,
	Province			VARCHAR(30)				NULL,
	PostalCode			VARCHAR(15)				NULL,
	Country				VARCHAR(30)				NULL,
	Password			VARCHAR(75)				NOT NULL,
	Salt				VARCHAR(24)				NULL,
	EmailAddress		VARCHAR(50)				NOT NULL,
	WorkPhone			VARCHAR(25)				NULL,
	CellPhone			VARCHAR(25)				NULL,
	HomePhone			VARCHAR(25)				NULL,
	EmploymentType		VARCHAR(15)				NOT NULL,
	Status				BIT						NULL,
	ExpireDate			SMALLDATETIME			NULL,
	Picture				IMAGE					NULL
)

--CREATE TABLE Project
CREATE TABLE Project
(
ProjectCode VARCHAR(10) PRIMARY KEY NOT NULL,
ClientCode VARCHAR(10) NOT NULL
FOREIGN KEY(ClientCode) REFERENCES Client (ClientCode),
ProjectDescription VARCHAR(50) NULL,
Phase VARCHAR(15) NOT NULL,
BillCode VARCHAR(3) NOT NULL,
DisciplineCode VARCHAR(10) NULL,
TaskCode VARCHAR(10) NULL,
ProjectCost MONEY NULL,
ProjectTimeLine VARCHAR(15) NULL,
ProjectStartDate SMALLDATETIME NULL,
ProjectEndDate SMALLDATETIME NULL
)


CREATE TABLE TimeSheet
(
	ProjectCode			VARCHAR(10)				NOT NULL
		FOREIGN KEY (ProjectCode) REFERENCES Project (ProjectCode),
	EmployeeCode		VARCHAR(10)				NOT NULL
		FOREIGN KEY (EmployeeCode) REFERENCES Employee (EmployeeCode),
	DepartmentCode		VARCHAR(10)				NOT NULL
		FOREIGN KEY (DepartmentCode) REFERENCES Department (DepartmentCode),
	WeekEnding			SMALLDATETIME			NOT NULL,
	Submitted			BIT						NOT NULL DEFAULT 0,
	Approved			BIT						NOT NULL DEFAULT 0,
	--TimeSheetDate		SMALLDATETIME			NOT NULL DEFAULT GETDATE(),
	--PRIMARY KEY (ProjectCode, EmployeeCode, DepartmentCode),
	HourSun				DECIMAL(4,2)			NOT NULL,
	HourMon				DECIMAL(4,2)			NOT NULL,
	HourTues			DECIMAL(4,2)			NOT NULL,
	HourWed				DECIMAL(4,2)			NOT NULL,
	HourThur			DECIMAL(4,2)			NOT NULL,
	HourFri				DECIMAL(4,2)			NOT NULL,
	HourSat				DECIMAL(4,2)			NOT NULL,
	Comment				VARCHAR(50)				NULL,
	CONSTRAINT PK_TimeSheet PRIMARY KEY CLUSTERED
	(EmployeeCode,ProjectCode,WeekEnding)
 
)

CREATE TABLE Expense
(
	Date			SMALLDATETIME	NOT NULL,
	EmployeeCode	VARCHAR(10)		NOT NULL
		FOREIGN KEY (EmployeeCode) REFERENCES Employee (EmployeeCode),       
	ProjectCode		VARCHAR(10)		NOT NULL
		FOREIGN KEY (ProjectCode) REFERENCES Project (ProjectCode),
	ClientCode		VARCHAR(10)		NOT NULL
		FOREIGN KEY (ClientCode) REFERENCES Client (ClientCode),
	MonthEnding		SMALLDATETIME,
	Description		VARCHAR(50),
	Kilometer		DECIMAL(6),
	Auto			DECIMAL(8,2),
	Transport		DECIMAL(8,2),
	Lodging			DECIMAL(8,2),
	Meal			DECIMAL(8,2),
	Others			DECIMAL(8,2),
	ExchangeRate	DECIMAL(6,5),
	Submitted		BIT		NOT NULL DEFAULT 0,
	Approved		BIT		NOT NULL DEFAULT 0,		
	Comment			VARCHAR(100)
	CONSTRAINT PK_Expense PRIMARY KEY CLUSTERED
		(Date, EmployeeCode,ProjectCode)
)

/***********************************************/
/*		     Insert Data					   */
/***********************************************/

INSERT INTO Client 
VALUES('CLIENT01', 'Rally Engineering', 'Jim Jones', '(780)4444444', 'Edmonton, Alberta')
INSERT INTO Client
VALUES('CLIENT02', 'MMX Corp', 'Axl Signas', '(403)1123434', 'Calgary, Alberta')

INSERT INTO Department
VALUES('DEPT101','Information Technology')
INSERT INTO Department
VALUES('DEPT102','Business')
INSERT INTO Department
VALUES('DEPT103','Human Resources')

INSERT INTO Employee
VALUES('E100000000', 'DEPT101', 'Kwaku', 'Gyennin', '01/01/1989', '123 Null Court', 'Edmonton', 'Alberta', 'T8X 2K8', 'Canada', 'E631C13CE45AADA515475B30769550AAB2027BE4', NULL, 'kgyennin@excite.com', NULL, NULL, '(780)1212121', 'Employee', 0, NULL, NULL)
INSERT INTO Employee
VALUES('A100000000', 'DEPT101', 'Peter', 'Olise', '02/02/1980', '345 Null Court', 'Edmonton', 'Alberta', 'T8X 2K8', 'Canada', 'BBBB9B27979007D6FC9394C7C845563D50499FFB', NULL, 'polise@gmail.com', NULL, NULL, '(780)1212123', 'Accountant', 0, NULL, NULL)
INSERT INTO Employee
VALUES('M100000000', 'DEPT101', 'Babacar', 'Kide', '03/03/1982', '678 Null Court', 'Edmonton', 'Alberta', 'T8X 2K8', 'Canada', 'C1E6DAC921D52EBD0D4FE68E204BC16C0B4CF102', NULL, 'bkide@gmail.com', NULL, NULL, '(780)1212122', 'Manager', 0, NULL, NULL)

INSERT INTO Project
VALUES('RE-18-999', 'CLIENT01','Web Application' ,'Phase_Search', 'T55', '1234-IT', '1-Admin/IT', 10000, '2 weeks', '03/19/2012', '04/02/2012')
INSERT INTO Project
VALUES('RE-11-111', 'CLIENT01', 'OS Installation', 'Phase_Start', 'H87', '4321-IT','3-Admin/SA', 25000.90, '1 month', '03/15/2012', '04/15/2012')
INSERT INTO Project
VALUES('RE-22-222', 'CLIENT02', 'Router Setup', 'Phase_Research', 'H88', '2187-IT','2-Admin/SA', 15000.00, '4 month', '04/15/2012', '08/21/2012')
INSERT INTO Project
VALUES('RE-33-424', 'CLIENT01', 'Business Software', 'Phase_Start', 'H87', '2468-IT','5-Admin/SA', 25000, '1 year', '03/30/2012', '04/01/2013')
INSERT INTO Project
VALUES('RE-32-276', 'CLIENT01', 'Military Software', 'Phase_Develop', 'H22', '1111-IT','9-Admin/SA', 2000, '4 month', '03/30/2012', '08/01/2012')
INSERT INTO Project
VALUES('RE-22-777', 'CLIENT01', 'OS Development', 'Phase_Start', 'H67', '1357-IT','7-Admin/SA', 250000, '2 year', '03/30/2012', '05/01/2014')

INSERT INTO Timesheet(ProjectCode, EmployeeCode, DepartmentCode, WeekEnding, Submitted, HourSun, HourMon, HourTues, HourWed, HourThur, HourFri, HourSat)
VALUES ('RE-18-999', 'E100000000', 'DEPT101', '02/03/2012', 1, 4.5, 5.5, 5, 7,5,7.5,4)
INSERT INTO Timesheet(ProjectCode, EmployeeCode, DepartmentCode, WeekEnding, Submitted, HourSun, HourMon, HourTues, HourWed, HourThur, HourFri, HourSat)
VALUES ('RE-11-111', 'M100000000', 'DEPT101', '03/31/2012', 1, 6.5, 8.5, 8.5, 8,5,7,2)
INSERT INTO Timesheet(ProjectCode, EmployeeCode, DepartmentCode, WeekEnding, Submitted, HourSun, HourMon, HourTues, HourWed, HourThur, HourFri, HourSat)
VALUES ('RE-18-999', 'A100000000', 'DEPT101', '03/31/2012', 1, 8, 8, 8, 7,5,7.5,0)
INSERT INTO Timesheet(ProjectCode, EmployeeCode, DepartmentCode, WeekEnding, Submitted, HourSun, HourMon, HourTues, HourWed, HourThur, HourFri, HourSat)
VALUES ('RE-33-424', 'E100000000', 'DEPT101', '04/14/2012', 1, 8, 8, 8, 7,5,7.5,0)
INSERT INTO Timesheet(ProjectCode, EmployeeCode, DepartmentCode, WeekEnding, Submitted, HourSun, HourMon, HourTues, HourWed, HourThur, HourFri, HourSat)
VALUES ('RE-33-424', 'M100000000', 'DEPT101', '04/07/2012', 0, 7, 8, 6, 7,5,7.5,2)

INSERT INTO Expense
VALUES('03/19/2012', 'E100000000', 'RE-18-999', 'CLIENT01', '03/31/2012', 'Setup Two PCs in Calgary', 0, 0, 45.80, 0, 0, 12.55, 0,1,0, NULL)
INSERT INTO Expense
VALUES('03/26/2012', 'E100000000', 'RE-18-999', 'CLIENT01', '03/31/2012', 'Configure Cisco Router in Calgary', 0, 0, 45.80, 120.60, 15.50, 12.55, 0,1,0, NULL)


/***********************************************/
/*		 Stored Procedures					   */
/***********************************************/

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'AddTimeSheet')
	DROP PROCEDURE AddTimeSheet
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ApproveTimeSheet')
	DROP PROCEDURE ApproveTimeSheet
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'UpdateTimeSheet')
	DROP PROCEDURE UpdateTimeSheet
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'AddProject')
	DROP PROCEDURE AddProject
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'UpdateProject')
	DROP PROCEDURE UpdateProject
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ViewProject')
	DROP PROCEDURE ViewProject
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ViewProjects')
	DROP PROCEDURE ViewProjects
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'AddEmployee')
DROP PROCEDURE AddEmployee
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ViewEmployee')
	DROP PROCEDURE ViewEmployee
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'UpdateEmployee')
	DROP PROCEDURE UpdateEmployee
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'GetTimeSheet')
	DROP PROCEDURE GetTimeSheet
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'GetTimeSheetList')
	DROP PROCEDURE GetTimeSheetList
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ApproveExpense')
	DROP PROCEDURE ApproveExpense
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'GetExpenseList')
	DROP PROCEDURE GetExpenseList
GO

IF EXISTS(SELECT name FROM SYSOBJECTS
		WHERE name = 'GetEmployeeExpenses')
	DROP PROCEDURE GetEmployeeExpenses
GO

IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'MakeNewEmployeeCode')
	DROP PROCEDURE MakeNewEmployeeCode
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ViewPassword')
	DROP PROCEDURE ViewPassword
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ChangeEmail')
	DROP PROCEDURE ChangeEmail
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ChangePassword')
	DROP PROCEDURE ChangePassword
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'ViewSalt')
	DROP PROCEDURE ViewSalt
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'GetClientCode')
	DROP PROCEDURE GetClientCode
GO
IF EXISTS (SELECT name FROM SYSOBJECTS
		WHERE name = 'GetClientName')
	DROP PROCEDURE GetClientName
GO

--DROP PROCEDURE ViewTimeSheet

-- PROCEDURE AddTimeSheet
CREATE PROCEDURE AddTimeSheet(@EmployeeCode VARCHAR(10),
@ProjectCode VARCHAR(10),
@DepartmentCode	VARCHAR(10),
@WeekEnding SMALLDATETIME,
@ClientCode	VARCHAR(10),
@ProjectDescription VARCHAR(50),
@Phase CHAR(15),
@BillCode CHAR(3),
@HourSun DECIMAL(4,2),
@HourMon DECIMAL(4,2),
@HourTues DECIMAL(4,2),
@HourWed DECIMAL(4,2),
@HourThur DECIMAL(4,2),
@HourFri DECIMAL(4,2),
@HourSat DECIMAL(4,2))
AS
IF @EmployeeCode IS NULL
	RAISERROR('Error! EmployeeCode is needed to specify in AddTimeSheet',16,1)
ELSE IF @DepartmentCode IS NULL
	RAISERROR('Error! DepartmentCode needs to be provided in AddTimeSheet',16,1)
ELSE IF @ProjectCode IS NULL
	RAISERROR('Error! ProjectCode needs to be provided in AddTimeSheet',16,1)
ELSE IF @WeekEnding IS NULL
	RAISERROR('Error! Week Ending needs to be provided in AddTimeSheet',16,1)
ELSE IF @ClientCode IS NULL
	RAISERROR('Error! Client Code was not provided in AddTimeSheet', 16,1)
ELSE IF @Phase IS NULL
	RAISERROR('Error! Project Phase needs to be provided in AddTimeSheet',16,1)
ELSE IF @BillCode IS NULL
	RAISERROR('Error! Bill Code was not provided in AddTimeSheet', 16,1)
ELSE IF @HourMon IS NULL OR 
@HourTues IS NULL OR 
@HourWed IS NULL OR 
@HourThur IS NULL OR 
@HourFri IS NULL OR 
@HourSat IS NULL OR 
@HourSun IS NULL
	RAISERROR('Error! All workday Hours was not provided in AddTimeSheet', 16,1)
ELSE
BEGIN
DECLARE @ReturnCode INT
SET @ReturnCode = 1

INSERT INTO Timesheet
VALUES(@ProjectCode, @EmployeeCode, @DepartmentCode, @WeekEnding, 1, 0, @HourSun, @HourMon, @HourTues, @HourWed, @HourThur, @HourFri, @HourSat, NULL)
END

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure in AddTimeSheet',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE ApproveTimeSheet
CREATE PROCEDURE ApproveTimeSheet(@ApproveValue INT = NULL,
									@EmployeeCode VARCHAR(10) = NULL,
									@ProjectCode VARCHAR(10) = NULL,
									@WeekEnding DATETIME = NULL)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @ApproveValue IS NULL
		RAISERROR('Approve Value - parameter required:@ApproveValue.',16,1)
	ELSE
	BEGIN
		UPDATE TimeSheet
		SET TimeSheet.Approved = @ApproveValue
		WHERE TimeSheet.EmployeeCode = @EmployeeCode
		AND TimeSheet.ProjectCode = @ProjectCode
		AND TimeSheet.WeekEnding = @WeekEnding 
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ELSE
			RAISERROR('update TimeSheet error', 16, 1)
	END		
RETURN @ReturnCode
GO

-- PROCEDURE UpdateTimeSheet
CREATE PROCEDURE UpdateTimeSheet
(
	@ProjectCode	VARCHAR(20),
	@HourSun		DECIMAL(4,2),
	@HourMon		DECIMAL(4,2),
	@HourTues		DECIMAL(4,2),
	@HourWed		DECIMAL(4,2),
	@HourThur		DECIMAL(4,2),
	@HourFri		DECIMAL(4,2),
	@HourSat		DECIMAL(4,2)
)
AS
UPDATE TimeSheet
SET HourSun = @HourSun,
	HourMon = @HourMon,
	HourTues = @HourTues,
	HourWed = @HourWed,
	HourThur = @HourThur,
	HourFri = @HourFri, 
	HourSat = @HourSat 
WHERE ProjectCode = @ProjectCode
GO

-- PROCEDURE AddProject
CREATE PROCEDURE AddProject (
@ProjectCode VARCHAR(10),
@ClientCode VARCHAR(10),
@ProjectDescription VARCHAR(50),
@Phase VARCHAR(15),
@BillCode VARCHAR(3),
@DisciplineCode VARCHAR(10),
@TaskCode VARCHAR(10),
@ProjectCost MONEY,
@ProjectTimeLine VARCHAR(15),
@ProjectStartDate SMALLDATETIME,
@ProjectEndDate SMALLDATETIME
)
AS
IF @ProjectCode IS NULL
RAISERROR('Error! ProjectCode is needed to specify in AddEmployee',16,1)
ELSE
BEGIN
DECLARE @ReturnCode INT
SET @ReturnCode = 1
INSERT INTO Project
VALUES(@ProjectCode, @ClientCode, @ProjectDescription,@Phase,@BillCode,@DisciplineCode,
@TaskCode, @ProjectCost, @ProjectTimeLine, @ProjectStartDate, @ProjectEndDate)
END
IF @@ERROR = 0
SET @ReturnCode = 0
ELSE
RAISERROR('Error! There is a problem with stored procedure, AddProject',16,1)
RETURN @ReturnCode
GO

--PROCEDURE UpdateProject
CREATE PROCEDURE UpdateProject
(
@ProjectCode VARCHAR(20),
@ClientCode VARCHAR(10),
@ProjectDescription VARCHAR(50),
@Phase VARCHAR(15),
@BillCode VARCHAR(3),
@DisciplineCode VARCHAR(10),
@TaskCode VARCHAR(10),
@ProjectCost MONEY,
@ProjectTimeLine VARCHAR(15),
@ProjectStartDate SMALLDATETIME,
@ProjectEndDate SMALLDATETIME
)
AS
UPDATE Project
SET ProjectCode = @ProjectCode,
ClientCode = @ClientCode,
ProjectDescription = @ProjectDescription,
Phase = @Phase,
BillCode = @BillCode,
DisciplineCode = @DisciplineCode,
TaskCode = @TaskCode,
ProjectCost = @ProjectCost,
ProjectTimeLine = @ProjectTimeLine,
ProjectStartDate = @ProjectStartDate,
ProjectEndDate = @ProjectEndDate
WHERE ProjectCode = @ProjectCode
GO

-- PROCEDURE ViewProject
CREATE PROCEDURE ViewProject (@ProjectCode CHAR(9))
AS
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SELECT ProjectCode, ClientCode, ProjectDescription, Phase, BillCode
FROM Project
WHERE ProjectCode = @ProjectCode

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure in ViewProjects',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE ViewProjects
CREATE PROCEDURE ViewProjects
AS
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SELECT ProjectCode, ClientCode, ProjectDescription, Phase, BillCode
FROM Project

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure in ViewProjects',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE AddEmployee
CREATE PROCEDURE AddEmployee (
@EmployeeCode VARCHAR(10),
@DepartmentCode VARCHAR(10),
@FirstName VARCHAR(25),
@LastName VARCHAR(25),
@DateofBirth SMALLDATETIME,
@Status BIT,
@Password VARCHAR(75),
@Salt VARCHAR(24) = NULL,
@EmailAddress VARCHAR(50),
@Address VARCHAR(50) = NULL,
@City VARCHAR(20) = NULL,
@Province VARCHAR(30) = NULL,
@PostalCode VARCHAR(15) = NULL,
@Country VARCHAR(30) = NULL,
@WorkPhone VARCHAR(25) = NULL,
@CellPhone VARCHAR(25) = NULL,
@HomePhone VARCHAR (25) = NULL,
@EmploymentType VARCHAR(15) = NULL,
@ExpireDate SMALLDATETIME = NULL,
@Picture IMAGE = NULL)
AS
IF @EmployeeCode IS NULL
	RAISERROR('Error! EmployeeCode is needed to specify in AddEmployee',16,1)
ELSE IF @DepartmentCode IS NULL
	RAISERROR('Error! DepartmentCode needs to be provided in AddEmployee',16,1)
ELSE IF @FirstName IS NULL
	RAISERROR('Error! First Name needs to be provided in AddEmployee',16,1)
ELSE IF @LastName IS NULL
	RAISERROR('Error! Last Name needs to be provided in AddEmployee',16,1)
ELSE IF @Password IS NULL
	RAISERROR('Error! Password needs to be provided in AddEmployee',16,1)
ELSE IF @EmailAddress IS NULL
	RAISERROR('Error! E-mail Address was not provided in AddEmployee', 16,1)
ELSE IF @Status IS NULL
	RAISERROR('Error! Status needs to be provided in AddEmployee',16,1)
ELSE IF @DateofBirth IS NULL
	RAISERROR('Error! DateofBirth needs to be provided in AddEmployee',16,1)
ELSE
BEGIN
DECLARE @ReturnCode INT
SET @ReturnCode = 1

INSERT INTO Employee
VALUES(@EmployeeCode, @DepartmentCode, @FirstName, @LastName, @DateofBirth, @Address, @City, 
@Province, @PostalCode, @Country, @Password, @Salt, @EmailAddress, @WorkPhone, @CellPhone, @HomePhone, @EmploymentType, 
@Status, @ExpireDate, @Picture)
END

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure, AddEmployee',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE ViewEmployee
CREATE PROCEDURE ViewEmployee (@EmployeeCode VARCHAR(15) = NULL, 
@Password VARCHAR(75) = NULL)
AS
IF @EmployeeCode IS NULL
	RAISERROR('Error! Employee Code was not provided in stored procedure ViewEmployee.', 16,1)
ELSE IF @Password IS NULL
	RAISERROR('Error! Password was not provided in stored procedure ViewEmployee.', 16,1)
ELSE
BEGIN
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SELECT DepartmentCode, FirstName, LastName, DateOfBirth, EmailAddress,Status,
isnull(Address, 'N/A') as 'Address',
isnull(City, 'N/A') as 'City',
isnull(Province, 'N/A') as 'Province',
isnull(PostalCode, 'N/A') as 'PostalCode',
isnull(Country, 'N/A') as 'Country',
isnull(WorkPhone, 'N/A') as 'WorkPhone',
isnull(CellPhone, 'N/A') as 'CellPhone',
isnull(HomePhone, 'N/A') as 'HomePhone',
isnull(EmploymentType, 'N/A') as 'Position',
isnull(CONVERT(VARCHAR(15), ExpireDate), 'N/A') as 'Date Ended',
isnull(Picture, 'N/A') as 'Picture'
FROM Employee
WHERE EmployeeCode = @EmployeeCode AND Password = @Password 
END
IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure, ViewEmployee',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE UpdateEmployee
CREATE PROCEDURE UpdateEmployee (
@EmployeeCode VARCHAR(10),
@DepartmentCode VARCHAR(10),
@FirstName VARCHAR(25),
@LastName VARCHAR(25),
@DateofBirth SMALLDATETIME,
@Status BIT,
@EmailAddress VARCHAR(50),
@Address VARCHAR(50) = NULL,
@City VARCHAR(20) = NULL,
@Province VARCHAR(30) = NULL,
@PostalCode VARCHAR(15) = NULL,
@Country VARCHAR(30) = NULL,
@WorkPhone VARCHAR(25) = NULL,
@CellPhone VARCHAR(25) = NULL,
@HomePhone VARCHAR (25) = NULL,
@EmploymentType VARCHAR(15) = NULL,
@ExpireDate SMALLDATETIME = NULL,
@Picture IMAGE = NULL)
AS
IF @EmployeeCode IS NULL
	RAISERROR('Error! EmployeeCode is needed to specify in AddEmployee',16,1)
ELSE IF @DepartmentCode IS NULL
	RAISERROR('Error! DepartmentCode needs to be provided in AddEmployee',16,1)
ELSE IF @FirstName IS NULL
	RAISERROR('Error! First Name needs to be provided in AddEmployee',16,1)
ELSE IF @LastName IS NULL
	RAISERROR('Error! Last Name needs to be provided in AddEmployee',16,1)
ELSE IF @EmailAddress IS NULL
	RAISERROR('Error! E-mail Address was not provided in AddEmployee', 16,1)
ELSE IF @Status IS NULL
	RAISERROR('Error! Status needs to be provided in AddEmployee',16,1)
ELSE IF @DateofBirth IS NULL
	RAISERROR('Error! DateofBirth needs to be provided in AddEmployee',16,1)
ELSE
BEGIN
DECLARE @ReturnCode INT
SET @ReturnCode = 1

UPDATE Employee
SET DepartmentCode = @DepartmentCode, 
FirstName = @FirstName, 
LastName = @LastName, 
DateofBirth = @DateofBirth,
Address = @Address, 
City = @City, 
Province = @Province, 
PostalCode = @PostalCode, 
Country = @Country, 
EmailAddress = @EmailAddress, 
WorkPhone = @WorkPhone, 
CellPhone = @CellPhone, 
HomePhone = @HomePhone, 
EmploymentType = @EmploymentType, 
Status = @Status, 
ExpireDate = @ExpireDate, 
Picture = @Picture
WHERE EmployeeCode = @EmployeeCode
END

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure, AddEmployee',16,1)
RETURN @ReturnCode
GO

-- PROCEDURE GetTimeSheet
CREATE PROCEDURE GetTimeSheet (@EmployeeCode VARCHAR(10) = NULL,
								@ProjectCode VARCHAR(10) = NULL,
								@WeekEnding DATETIME = NULL)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @WeekEnding IS NULL
		RAISERROR('WEEEK ENDING-parameter required:@WeekEnding.',16,1)
	ELSE
	BEGIN
		SELECT	TimeSheet.ProjectCode,
				TimeSheet.EmployeeCode,
				TimeSheet.DepartmentCode,
				TimeSheet.WeekEnding,
				TimeSheet.Submitted,
				TimeSheet.Approved,
				TimeSheet.HourSun,
				TimeSheet.HourMon,
				TimeSheet.HourTues,
				TimeSheet.HourWed,
				TimeSheet.HourThur,
				TimeSheet.HourFri,
				TimeSheet.HourSat,
				TimeSheet.Comment
		FROM TimeSheet
		WHERE TimeSheet.EmployeeCode = @EmployeeCode
		AND TimeSheet.ProjectCode = @ProjectCode
		AND TimeSheet.WeekEnding = @WeekEnding 
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ElSE
			RAISERROR('GetTimeSheet Select error.', 16,1)
	END
RETURN @ReturnCode
Go

-- PROCEDURE GetTimeSheetList
CREATE PROCEDURE GetTimeSheetList (@WeekEnding DATETIME = NULL, @Submitted BIT=NULL, @Approved BIT=NULL) 								
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @WeekEnding IS NULL
		RAISERROR('WEEEK ENDING-parameter required:@WeekEnding.',16,1)
	ELSE
	BEGIN
	IF @Submitted = 1 AND @Approved = 0
		SELECT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				TimeSheet.ProjectCode,
				TimeSheet.WeekEnding,
				TimeSheet.Submitted,
				TimeSheet.Approved
		FROM Employee, TimeSheet
		WHERE TimeSheet.EmployeeCode = Employee.EmployeeCode
		AND TimeSheet.WeekEnding = @WeekEnding
		AND TimeSheet.Submitted = @Submitted
		AND TimeSheet.Approved = @Approved
	ELSE IF @Submitted = 0 AND @Approved = 1
		SELECT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				TimeSheet.ProjectCode,
				TimeSheet.WeekEnding,
				TimeSheet.Submitted,
				TimeSheet.Approved
		FROM Employee, TimeSheet
		WHERE TimeSheet.EmployeeCode = Employee.EmployeeCode
		AND TimeSheet.WeekEnding = @WeekEnding
		AND TimeSheet.Submitted = @Submitted
		AND TimeSheet.Approved = @Approved
	ELSE
		SELECT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				TimeSheet.ProjectCode,
				TimeSheet.WeekEnding,
				TimeSheet.Submitted,
				TimeSheet.Approved
		FROM Employee, TimeSheet
		WHERE TimeSheet.EmployeeCode = Employee.EmployeeCode
		AND TimeSheet.WeekEnding = @WeekEnding
		AND TimeSheet.Submitted = @Submitted
		AND TimeSheet.Approved = @Approved
		
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ElSE
			RAISERROR('GetTimeSheetList Select error.', 16,1)
	END
RETURN @ReturnCode
GO

--Stored Procedure Get Employee Expense List
CREATE PROCEDURE GetExpenseList (@MonthEnding DATETIME = NULL, @Submitted BIT=NULL, @Approved BIT=NULL) 								
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @MonthEnding IS NULL
		RAISERROR('MONTH ENDING-parameter required:@MonthEnding.',16,1)
	ELSE
	BEGIN
	IF @Submitted = 1 AND @Approved = 0
		SELECT DISTINCT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				Expense.ProjectCode,
				Expense.MonthEnding,
				Expense.Submitted,
				Expense.Approved
		FROM Employee, Expense
		WHERE Expense.EmployeeCode = Employee.EmployeeCode
		AND Expense.MonthEnding = @MonthEnding
		AND Expense.Submitted = @Submitted
		AND Expense.Approved = @Approved
	ELSE IF @Submitted = 0 AND @Approved = 1
		SELECT DISTINCT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				Expense.ProjectCode,
				Expense.MonthEnding,
				Expense.Submitted,
				Expense.Approved
		FROM Employee, Expense
		WHERE Expense.EmployeeCode = Employee.EmployeeCode
		AND Expense.MonthEnding = @MonthEnding
		AND Expense.Submitted = @Submitted
		AND Expense.Approved = @Approved
	ELSE
		SELECT DISTINCT Employee.EmployeeCode,
				Employee.FirstName + ' ' + Employee.LastName AS 'EmployeeName',
				Expense.ProjectCode,
				Expense.MonthEnding,
				Expense.Submitted,
				Expense.Approved
		FROM Employee, Expense
		WHERE Expense.EmployeeCode = Employee.EmployeeCode
		AND Expense.MonthEnding = @MonthEnding
		AND Expense.Submitted = @Submitted
		AND Expense.Approved = @Approved
		
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ElSE
			RAISERROR('GetExpenseList Select error.', 16,1)
	END
RETURN @ReturnCode
GO

-- Get Employee Expenses
CREATE PROCEDURE GetEmployeeExpenses(@EmployeeCode VARCHAR(10) = NULL,
									@ProjectCode VARCHAR(10) = NULL,
									@MonthEnding DATETIME = NULL)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @MonthEnding IS NULL
		RAISERROR('MONTH ENDING-parameter required:@MonthEnding.',16,1)
	ELSE
	BEGIN
		SELECT	Expense.Date,
				Expense.Description,
				Expense.Kilometer,
				Expense.Auto,
				Expense.Transport,
				Expense.Lodging,
				Expense.Meal,
				Expense.Others, 
				Expense.ExchangeRate,
				Expense.Comment
		FROM Expense
		WHERE Expense.EmployeeCode = @EmployeeCode
		AND Expense.ProjectCode = @ProjectCode
		AND Expense.MonthEnding = @MonthEnding 
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ElSE
			RAISERROR('GetEmployeeExpense Select error.', 16,1)
	END
RETURN @ReturnCode
Go

--  ApproveExpense PROCEDURE
CREATE PROCEDURE ApproveExpense(@ApproveValue INT = NULL,
									@EmployeeCode VARCHAR(10) = NULL,
									@ProjectCode VARCHAR(10) = NULL,
									@MonthEnding DATETIME = NULL)
AS
	DECLARE @ReturnCode INT
	SET @ReturnCode = 1
	IF @ApproveValue IS NULL
		RAISERROR('Approve Value - parameter required:@ApproveValue.',16,1)
	ELSE
	BEGIN
		UPDATE Expense
		SET Expense.Approved = @ApproveValue
		WHERE Expense.EmployeeCode = @EmployeeCode
		AND Expense.ProjectCode = @ProjectCode
		AND Expense.MonthEnding = @MonthEnding 
		IF @@ERROR = 0
			SET @ReturnCode = 0
		ELSE
			RAISERROR('update Expense error', 16, 1)
	END		
RETURN @ReturnCode
GO


CREATE PROCEDURE MakeNewEmployeeCode (@EmploymentType VARCHAR(15) = NULL, 
@EmployeeCode VARCHAR(10) = NULL OUTPUT)
AS
DECLARE @ReturnCode INT
SET @ReturnCode = 1
IF (@EmploymentType IS NULL)
	RAISERROR('Please enter an Employment Type for MakeNewEmployeeCode', 16, 1)
ELSE
BEGIN
DECLARE @NumberofRows INT 
SET @NumberofRows= (SELECT COUNT(*) FROM Employee WHERE EmploymentType LIKE @EmploymentType)
IF(@EmploymentType = 'Accountant' AND @NumberofRows <> 0)
BEGIN
	SET @EmployeeCode = 'A'+ CAST((@NumberofRows+100000001) AS VARCHAR(10))
END
ELSE IF(@EmploymentType = 'Manager' AND @NumberofRows <> 0)
BEGIN
	SET @EmployeeCode = 'M'+ CAST((@NumberofRows+100000001) AS VARCHAR(10))
END
ELSE IF(@EmploymentType = 'Employee' AND @NumberofRows <> 0)
BEGIN
	SET @EmployeeCode = 'E'+ CAST((@NumberofRows+100000001) AS VARCHAR(10))
END
END
IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error!! Problem with MakeNewEmployeeCode!',16,1)
RETURN @ReturnCode
GO

CREATE PROCEDURE ViewPassword (@EmployeeCode VARCHAR(15) = NULL, 
@Password VARCHAR(75) = NULL OUTPUT)
AS
IF (@EmployeeCode IS NULL)
	RAISERROR('Error! EmployeeCode is not supplied in stored procedure ViewPaswword', 16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SET @Password = (SELECT Password
FROM Employee
WHERE EmployeeCode = @EmployeeCode)

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with ViewPassword', 16, 1)
RETURN @ReturnCode
GO

CREATE PROCEDURE ViewSalt (@EmployeeCode VARCHAR(15) = NULL, 
@Salt VARCHAR(24) = NULL OUTPUT)
AS
IF (@EmployeeCode IS NULL)
	RAISERROR('Error! EmployeeCode is not supplied in stored procedure ViewSalt', 16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SET @Salt = (SELECT Salt
FROM Employee
WHERE EmployeeCode = @EmployeeCode)

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with ViewSalt', 16, 1)
RETURN @ReturnCode
GO

CREATE PROCEDURE ChangeEmail (@EmployeeCode VARCHAR(15) = NULL, @Email VARCHAR(50) = NULL)
AS
IF (@EmployeeCode IS NULL)
	RAISERROR('Error! EmployeeCode is not supplied in stored procedure ChangeEmail', 16,1)
ELSE IF (@Email IS NULL)
	RAISERROR('Error! Email is not supplied in stored procedure ChangeEmail', 16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

UPDATE Employee
SET EmailAddress = @Email
WHERE EmployeeCode = @EmployeeCode

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with ChangeEmail', 16, 1)
RETURN @ReturnCode
GO

CREATE PROCEDURE ChangePassword (@EmployeeCode VARCHAR(15) = NULL, 
@Password VARCHAR(75),
@Salt VARCHAR(25))
AS
IF (@EmployeeCode IS NULL)
	RAISERROR('Error! EmployeeCode is not supplied in stored procedure ChangePassword', 16,1)
ELSE IF (@Password IS NULL)
	RAISERROR('Error! Password is not supplied in stored procedure ChangePassword', 16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

UPDATE Employee
SET Password = @Password,
	Salt = @Salt
WHERE EmployeeCode = @EmployeeCode

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with ChangePassword', 16, 1)
RETURN @ReturnCode
GO

-- PROCEDURE GetClientCode
CREATE PROCEDURE GetClientCode (@ClientName VARCHAR(50) = NULL, 
@ClientCode VARCHAR(10) = NULL OUTPUT)
AS

IF @ClientName IS NULL
	RAISERROR('Error! Client Name is not provided!',16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SET @ClientCode = (SELECT ClientCode FROM Client WHERE ClientName = @ClientName)

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure GetClientCode', 16,1)
GO

-- PROCEDURE GetClientName
CREATE PROCEDURE GetClientName (@ClientCode VARCHAR(10) = NULL, 
@ClientName VARCHAR(50) = NULL OUTPUT)
AS

IF @ClientCode IS NULL
	RAISERROR('Error! Client Code is not provided!',16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1

SET @ClientName = (SELECT ClientName FROM Client WHERE ClientCode = @ClientCode)

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure GetClientName', 16,1)
GO

CREATE PROCEDURE EmployeeProjects(@EmployeeCode IS NULL)
AS
IF @EmployeeCode IS NULL
	RAISERROR('Error! EmployeeCode is not provided in stored procedure EmployeeProjects',16,1)
ELSE
DECLARE @ReturnCode INT
SET @ReturnCode = 1
SELECT p.ProjectCode, p.ProjectDescription
FROM Project p INNER JOIN Timesheet t ON 
	p.ProjectCode = t.ProjectCode INNER JOIN Employee e ON
		t.EmployeeCode = e.EmployeeCode
WHERE e.EmployeeCode = @EmployeeCode

IF @@ERROR = 0
	SET @ReturnCode = 0
ELSE
	RAISERROR('Error! There is a problem with stored procedure EmployeeProjects', 16,1)
RETURN @ReturnCode
GO
	
