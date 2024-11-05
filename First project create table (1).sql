-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-01-26 15:43:36.518

-- tables
-- Table: ArtWorks
CREATE TABLE ArtWorks (
    ArtWorkID int  NOT NULL,
    Title varchar(100)  NOT NULL,
    creationDate date  NOT NULL,
    ArtistID int  NOT NULL,
    CONSTRAINT ArtWorks_pk PRIMARY KEY (ArtWorkID)
);

-- Table: Artists
CREATE TABLE Artists (
    ArtistID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Style varchar(100)  NOT NULL,
    CONSTRAINT Artists_pk PRIMARY KEY (ArtistID)
);

-- Table: ArtworkAcquisition
CREATE TABLE ArtworkAcquisition (
    ArtworkAcquisitionID int  NOT NULL,
    Date date  NOT NULL,
    Price money  NOT NULL,
    ArtWorkID int  NOT NULL,
    CONSTRAINT ArtworkAcquisition_pk PRIMARY KEY (ArtworkAcquisitionID)
);

-- Table: ArtworkExhibition
CREATE TABLE ArtworkExhibition (
    ArtworkExhibitionID int  NOT NULL,
    ArtWorkID int  NOT NULL,
    ExhibitionID int  NOT NULL,
    CONSTRAINT ArtworkExhibition_pk PRIMARY KEY (ArtworkExhibitionID)
);

-- Table: CustomerFeedback
CREATE TABLE CustomerFeedback (
    CustomerFeedbackID int  NOT NULL,
    Comment varchar(100)  NOT NULL,
    Date date  NOT NULL,
    CustomerID int  NOT NULL,
    ExhibitionID int  NOT NULL,
    CONSTRAINT CustomerFeedback_pk PRIMARY KEY (CustomerFeedbackID)
);

-- Table: Customers
CREATE TABLE Customers (
    CustomerID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    ContactInfo varchar(100)  NOT NULL,
    CONSTRAINT Customers_pk PRIMARY KEY (CustomerID)
);

-- Table: Employees
CREATE TABLE Employees (
    EmployeeID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Position varchar(100)  NOT NULL,
    LocationID int  NOT NULL,
    CONSTRAINT Employees_pk PRIMARY KEY (EmployeeID)
);

-- Table: Exhibitions
CREATE TABLE Exhibitions (
    ExhibitionID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    StartDate Date  NOT NULL,
    EndDate Date  NOT NULL,
    Theme varchar(100)  NOT NULL,
    CONSTRAINT Exhibitions_pk PRIMARY KEY (ExhibitionID)
);

-- Table: GaleryLocations
CREATE TABLE GaleryLocations (
    LocationID int  NOT NULL,
    Adress varchar(100)  NOT NULL,
    CONSTRAINT GaleryLocations_pk PRIMARY KEY (LocationID)
);

-- Table: RegulatoryCompliance
CREATE TABLE RegulatoryCompliance (
    RegulatoryComplianceID int  NOT NULL,
    Name varchar(100)  NOT NULL,
    Status varchar(100)  NOT NULL,
    ArtWorks_ArtWorkID int  NOT NULL,
    CONSTRAINT RegulatoryCompliance_pk PRIMARY KEY (RegulatoryComplianceID)
);

-- Table: Sales
CREATE TABLE Sales (
    SaleID int  NOT NULL,
    SaleDate date  NOT NULL,
    SalePrice money  NOT NULL,
    CustomerID int  NOT NULL,
    ArtWorkID int  NOT NULL,
    EmployeeID int  NOT NULL,
    CONSTRAINT Sales_pk PRIMARY KEY (SaleID)
);

-- End of file.

