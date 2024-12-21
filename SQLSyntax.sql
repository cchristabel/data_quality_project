USE SQLQualityCleaned
GO

/*
TABLE OF REFERENCE

1. Performed quality checks on each table and did an order by 
	to put the ones that did not pass the quallity checks first.
	The quality check queries are in order of the tables
			i.	  Artists
			ii.	  Attendees
			iii.  Concerts
			iv.	  Merchandise
			v.	  Performances
			vi.	  Sponsors
			vii.  Tickets
			viii. Venues

2. A stored procedure to calculate ZScores

3. A stored procedure to compare ZScores

4. A View to see when and where an artist will be performing

5. A view to see outliers

6. A select query to find venues with a capacity less than 2000
*/ 


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

/* 
Artits

- STEP 1 ID Checks: Check if ArtistID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	ArtistName, Genre and Country to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(ArtistID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ArtistID_Check,
    CASE WHEN ISNumeric(AvgPerformanceRating) = 1 THEN 'TRUE' ELSE 'FALSE' END AS AvgPerRating_Check,
	CASE WHEN ISNumeric(NumPerformances) = 1 THEN 'TRUE' ELSE 'FALSE' END AS NumPer_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY ArtistName, Genre, Country) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(ArtistID) = 0 OR ISNumeric(AvgPerformanceRating) = 0 OR ISNUMERIC(NumPerformances) = 0 OR
    ArtistID IS NULL OR AvgPerformanceRating < 0 OR
    NumPerformances < 0 OR
	(
		LEN(LTRIM(RTRIM(ArtistName))) = 0 OR
		LEN(ArtistName) <> LEN(LTRIM(RTRIM(ArtistName))) OR
        TRY_CAST(ArtistName AS FLOAT) IS NOT NULL
	) OR
    (
		LEN(LTRIM(RTRIM(Genre))) = 0 OR
		LEN(Genre) <> LEN(LTRIM(RTRIM(Genre))) OR
        TRY_CAST(Genre AS FLOAT) IS NOT NULL
	) OR
    (
		LEN(LTRIM(RTRIM(Country))) = 0 OR
		LEN(Country) <> LEN(LTRIM(RTRIM(Country))) OR
        TRY_CAST(Country AS FLOAT) IS NOT NULL
	) 
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Artists
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/* 
Attendees

- STEP 1 ID Checks: Check if AttendeeID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	TicketID, Fullname and Email to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(AttendeeID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS AttendeeID_Check,
    CASE WHEN ISNumeric(TicketID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS Ticket_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY AttendeeID, FullName, Email) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(AttendeeID) = 0 OR ISNumeric(TicketID) = 0 OR
    AttendeeID IS NULL OR
	(
		LEN(LTRIM(RTRIM(FullName))) = 0 OR
        LEN(FullName) <> LEN(LTRIM(RTRIM(FullName))) OR
        TRY_CAST(FullName AS FLOAT) IS NOT NULL
	) OR
    (
		LEN(LTRIM(RTRIM(Email))) = 0 OR
		LEN(Email) <> LEN(LTRIM(RTRIM(Email))) OR
        TRY_CAST(Email AS FLOAT) IS NOT NULL OR
		Email NOT LIKE '%@%.%'
	) OR
    (
		LEN(LTRIM(RTRIM(CheckInStatus))) = 0 OR
		LEN(CheckInStatus) <> LEN(LTRIM(RTRIM(CheckInStatus))) OR
        TRY_CAST(CheckInStatus AS FLOAT) IS NOT NULL OR
		CheckInStatus NOT IN ('Checked In', 'Not Checked In')
	) 
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Attendees
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/*
Concerts

- STEP 1 ID Checks: Check if ConcertID, ArtistID, VenueID and TicketSales are numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of RecreationID 
		and MunicipalityID to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report 
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(ConcertID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ConcertID_Check,
    CASE WHEN ISNumeric(ArtistID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ArtistID_Check,
	CASE WHEN ISNumeric(VenueID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS VenueID_Check,
	CASE WHEN ISNumeric(TicketSales) = 1 THEN 'TRUE' ELSE 'FALSE' END AS TicketSales_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY ConcertID, ArtistID, VenueID, TicketSales) AS DuplicateCount,

-- STEP 3
    CASE
        WHEN 
		ISNUMERIC(ConcertID) = 0 OR ISNUMERIC(ArtistID) = 0 OR 
		ISNUMERIC(VenueID) = 0 OR ISNUMERIC(TicketSales) = 0 OR
		ConcertID IS NULL OR
		TRY_CAST([Date] AS DATE) IS NULL 
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Concerts
ORDER BY ResultIssuerReport DESC;

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

/* 
Merchandise

- STEP 1 ID Checks: Check if MerchandiseID and TicketID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	TicketID, Price and StockLevel to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(MerchandiseID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS MerchandiseID_Check,
    CASE WHEN ISNumeric(TicketID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS Ticket_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY TicketID, [Price(kr)], StockLevel) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(MerchandiseID) = 0 OR ISNumeric(TicketID) = 0 OR
	ISNumeric([Price(kr)]) = 0 OR ISNumeric(StockLevel) = 0 OR
	ISNumeric(NumSales) = 0 OR ISNumeric(ZScores_NumSales) = 0 OR
    MerchandiseID IS NULL OR
	(
		LEN(LTRIM(RTRIM(ItemName))) = 0 OR
        LEN(ItemName) <> LEN(LTRIM(RTRIM(ItemName)))
	) 
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Merchandise
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/* 
Performances

- STEP 1 ID Checks: Check if PerformanceID and ConcertID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	ConcertID and StartTime to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(PerformanceID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS PerformanceID_Check,
    CASE WHEN ISNumeric(ConcertID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ConcertID_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY ConcertID, StartTime) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(PerformanceID) = 0 OR ISNumeric(ConcertID) = 0 OR
	ISNumeric(Duration) = 0 OR
    PerformanceID IS NULL OR
	TRY_CAST(StartTime AS TIME) IS NULL OR 
	TRY_CAST(EndTime AS TIME) IS NULL
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Performances
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/* 
Sponsors

- STEP 1 ID Checks: Check if SponsorID and ConcertID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	ConcertID, SponsorName and SponsorLevel to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(SponsorID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS SponsorID_Check,
    CASE WHEN ISNumeric(ConcertID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ConcertID_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY ConcertID, SponsorName, SponsorLevel) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(SponsorID) = 0 OR ISNumeric(ConcertID) = 0 OR
	ISNumeric(ContributionAmount) = 0 OR ISNUMERIC(NumEventsSponsored) = 0 OR
    SponsorID IS NULL OR
	(
		LEN(LTRIM(RTRIM(SponsorName))) = 0 OR
        LEN(SponsorName) <> LEN(LTRIM(RTRIM(SponsorName)))
	) 
	OR SponsorLevel NOT IN ('Platinum', 'Gold', 'Silver', 'Bronze')
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Sponsors
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/* 
Tickets

- STEP 1 ID Checks: Check if TicketID and ConcertID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	ConcertID, TicketType and Price to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(TicketID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS TicketID_Check,
    CASE WHEN ISNumeric(ConcertID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS ConcertID_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY ConcertID, TicketType, Price) AS DuplicateCount,


-- STEP 3
CASE WHEN 
    ISNumeric(TicketID) = 0 OR ISNumeric(ConcertID) = 0 OR
	ISNumeric(Price) = 0 OR ISNUMERIC([Availability]) = 0 OR
    TicketID IS NULL OR
	(
		LEN(LTRIM(RTRIM(TicketType))) = 0 OR
        LEN(TicketType) <> LEN(LTRIM(RTRIM(TicketType)))
	) 
	OR TicketType NOT IN ('VIP', 'General', 'Premium')
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Tickets
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

/* 
Venues

- STEP 1 ID Checks: Check if VenueID is numeric
- STEP 2 Duplicate Check: Count occurrences of each combination of 
	VenueName, Location and Capacity to identify duplicates
- STEP 3 Result Issuer Report: Evaluate conditions to issue a report, 
	it checks that non nullable columns do not contain null values, 
	numeric columns just contains numeric values,
	string columns does not have an empty string, 
	does not contain unnecessary spaces and does not have numeric values
*/

SELECT
-- STEP 1:  
    CASE WHEN ISNumeric(VenueID) = 1 THEN 'TRUE' ELSE 'FALSE' END AS VenueID_Check,

-- STEP 2
    COUNT(*) OVER (PARTITION BY VenueName, [Location], Capacity) AS DuplicateCount,

-- STEP 3
CASE WHEN 
    ISNumeric(VenueID) = 0 OR ISNumeric(Capacity) = 0 OR
	ISNumeric(NumEvents) = 0  OR
    VenueID IS NULL OR
	(
		LEN(LTRIM(RTRIM(VenueName))) = 0 OR
        LEN(VenueName) <> LEN(LTRIM(RTRIM(VenueName)))
	) 
	OR
	(
		LEN(LTRIM(RTRIM([Location]))) = 0 OR
        LEN([Location]) <> LEN(LTRIM(RTRIM([Location])))
	) 
	OR
	TRY_CAST(VenueRating AS FLOAT) IS NULL OR
	TRY_CAST(ZScores_VenueRating AS FLOAT) IS NULL
THEN 'Data Quality Issues Detected'
ELSE 'Data Quality Checks Passed'
END AS ResultIssuerReport

FROM Venues
ORDER BY ResultIssuerReport DESC;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--Procedure to calculate ZScores

CREATE PROCEDURE CalculateZScores
    @TableName NVARCHAR(255),
    @ColumnName NVARCHAR(255)
AS
BEGIN
    DECLARE @DynamicSQL NVARCHAR(MAX);
    SET @DynamicSQL = 
        'SELECT ROUND((' + @ColumnName + ' - AVG(' + @ColumnName + ') 
		 OVER ()) / STDEVP(' + @ColumnName + ') OVER (), 3) AS ZScore ' +
        'FROM ' + @TableName;
    EXEC sp_executesql @DynamicSQL;
END;

 
--Executing
EXEC CalculateZScores
	@TableName = 'Merchandise',
    @ColumnName = 'NumSales'
GO

EXEC CalculateZScores
	@TableName = 'Venues',
    @ColumnName = 'VenueRating';
GO

--Deleting procedure
DROP PROCEDURE CalculateZScores;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--Procedure to compare ZScores

CREATE PROCEDURE CompareZScores
AS
BEGIN
    SELECT 
        NumSales,
        ZScores_NumSales AS Excel_ZScores,
        ROUND((NumSales + - AVG(NumSales) 
		OVER ()) / STDEVP(NumSales) OVER (), 3) AS SQL_ZScore,
        CASE 
            WHEN ZScores_NumSales = ROUND((NumSales + - AVG(NumSales) 
		OVER ()) / STDEVP(NumSales) OVER (), 3) THEN 'Match'
            ELSE 'No Match'
        END AS MatchResult
    FROM 
          Merchandise;
END;

 -- Execute the stored procedure
EXEC CompareZScores;

DROP PROCEDURE CompareZScores

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--View to see where an artist will be performing, which date, start time and endtime

CREATE VIEW ArtistPerformanceInfo
AS
	SELECT
		a.ArtistName,
		a.Genre,
		a.Country,
		c.[Date],
		v.VenueName,
		v.[Location],
		v.Capacity,
		p.StartTime,
		p.EndTime
	FROM Artists AS a
	INNER JOIN Concerts AS c ON c.ArtistID = a.ArtistID
	INNER JOIN Venues AS v ON v.VenueID = c.VenueID
	INNER JOIN Performances AS p ON p.ConcertID = c.ConcertID


SELECT *
FROM ArtistPerformanceInfo

DROP VIEW ArtistPerformanceInfo

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--View to find outliers


CREATE VIEW ZScore_Outliers 
AS
SELECT
    VenueID,
	[Location],
	VenueRating,
	Zscores_VenueRating,
    CASE
        WHEN Zscores_VenueRating >= -3 AND Zscores_VenueRating <= 3 THEN 'Within Range'
        ELSE 'Outside Range'
    END AS ZScoreRangeStatus
FROM
    Venues;


SELECT *
FROM ZScore_Outliers
ORDER BY ZScoreRangestatus;

DROP VIEW ZScore_Outliers
 
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--A select query to find venues with a capacity less than 2000

SELECT *
FROM Venues
WHERE Capacity < 2000;

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------