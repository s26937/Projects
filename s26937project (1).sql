
--1.
CREATE PROCEDURE AddArtworkToExhibition
    @ArtWorkID INT,
    @ExhibitionID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM ArtWorks WHERE ArtWorkID = @ArtWorkID)
    BEGIN
        RAISERROR('Artwork with ArtWorkID %d does not exist.', 16, 1, @ArtWorkID);
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Exhibitions WHERE ExhibitionID = @ExhibitionID)
    BEGIN
        RAISERROR('Exhibition with ExhibitionID %d does not exist.', 16, 2, @ExhibitionID);
        RETURN;
    END
    
    IF EXISTS (SELECT 1 FROM ArtworkExhibition WHERE ArtWorkID = @ArtWorkID AND ExhibitionID = @ExhibitionID)
    BEGIN
        RAISERROR('Artwork with ArtWorkID %d is already assigned to Exhibition with ExhibitionID %d.', 16, 3, @ArtWorkID, @ExhibitionID);
        RETURN;
    END
    
    INSERT INTO ArtworkExhibition (ArtWorkID, ExhibitionID)
    VALUES (@ArtWorkID, @ExhibitionID);
    
END;

--2.
CREATE PROCEDURE AddCustomerFeedback
    @CustomerID INT,
    @ExhibitionID INT,
    @Comment VARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
    BEGIN
        RAISERROR('Customer with CustomerID %d does not exist.', 16, 1, @CustomerID);
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Exhibitions WHERE ExhibitionID = @ExhibitionID)
    BEGIN
        RAISERROR('Exhibition with ExhibitionID %d does not exist.', 16, 1, @ExhibitionID);
        RETURN;
    END

    INSERT INTO CustomerFeedback (Comment, Date, CustomerID, ExhibitionID)
    VALUES (@Comment, GETDATE(), @CustomerID, @ExhibitionID);
END

--3.

CREATE PROCEDURE RetrieveEmployeesByLocation
    @LocationID INT
AS
BEGIN
    DECLARE @EmployeeID INT;
    DECLARE @EmployeeName VARCHAR(100);
    DECLARE @Position VARCHAR(100);
    DECLARE @EmployeeLocationID INT;
    DECLARE @EmployeeCount INT;

    SELECT @EmployeeCount = COUNT(*)
    FROM Employees
    WHERE LocationID = @LocationID;


    IF @EmployeeCount = 0
    BEGIN
        PRINT 'No employees found for LocationID ' + CAST(@LocationID AS VARCHAR);
        RETURN; -- Exit the procedure
    END

    DECLARE EmployeeCursor CURSOR FOR
    SELECT EmployeeID, Name, Position, LocationID
    FROM Employees
    WHERE LocationID = @LocationID;

    OPEN EmployeeCursor;
    FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @EmployeeName, @Position, @EmployeeLocationID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT 'EmployeeID: ' + CAST(@EmployeeID AS VARCHAR) + ', Name: ' + @EmployeeName + ', Position: ' + @Position + ', LocationID: ' + CAST(@EmployeeLocationID AS VARCHAR);
        FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @EmployeeName, @Position, @EmployeeLocationID;
    END

    CLOSE EmployeeCursor;
    DEALLOCATE EmployeeCursor;
END

--trigger 1
CREATE TRIGGER PreventDeleteActiveArtwork
ON ArtWorks
AFTER DELETE
AS
BEGIN
    DECLARE @ArtWorkID INT;
    DECLARE @CurrentDate DATE = GETDATE();

    DECLARE DeletedArtworkCursor CURSOR FOR
    SELECT ArtWorkID FROM Deleted;

    OPEN DeletedArtworkCursor;
    FETCH NEXT FROM DeletedArtworkCursor INTO @ArtWorkID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM ArtworkExhibition ae
            JOIN Exhibitions e ON ae.ExhibitionID = e.ExhibitionID
            WHERE ae.ArtWorkID = @ArtWorkID
            AND e.StartDate <= @CurrentDate
            AND e.EndDate >= @CurrentDate
        )
        BEGIN
            RAISERROR('Cannot delete artwork %d as it is part of an active exhibition.', 16, 1, @ArtWorkID);
            ROLLBACK TRANSACTION; 
            RETURN;
        END

        FETCH NEXT FROM DeletedArtworkCursor INTO @ArtWorkID;
    END

    CLOSE DeletedArtworkCursor;
    DEALLOCATE DeletedArtworkCursor;
END


--trigger 2 
CREATE TRIGGER UpdateArtistStyleOnArtworkUpdate
ON ArtWorks
AFTER UPDATE
AS
BEGIN
    DECLARE @ArtistID INT;
    DECLARE @NewStyle VARCHAR(100);

    DECLARE UpdatedArtworksCursor CURSOR FOR
    SELECT ArtWorkID, ArtistID
    FROM inserted;

    OPEN UpdatedArtworksCursor;
    FETCH NEXT FROM UpdatedArtworksCursor INTO @ArtistID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        IF EXISTS (SELECT 1 FROM Artists WHERE ArtistID = @ArtistID)
        BEGIN
           
            SELECT @NewStyle = Style FROM Artists WHERE ArtistID = @ArtistID;

            
            UPDATE ArtWorks
            SET Style = @NewStyle
            WHERE ArtistID = @ArtistID;
        END
        ELSE
        BEGIN
            RAISERROR('Cannot update artist style. Artist with ID %d does not exist.', 16, 1, @ArtistID);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        FETCH NEXT FROM UpdatedArtworksCursor INTO @ArtistID;
    END

    CLOSE UpdatedArtworksCursor;
    DEALLOCATE UpdatedArtworksCursor;
END