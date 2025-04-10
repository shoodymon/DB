USE Hotel;
GO

--1.	������� �������������, ���������� ������ ���������� � ���������� �������
CREATE VIEW InfoOccupiedRooms AS
SELECT
	Status.EntryCode,
    Status.ClientCode,
    CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
    Clients.PassportNumber,
    Status.RoomCode,
    Rooms.Number,
    Rooms.TypeCode,
    RoomTypes.Type,
    RoomTypes.Price,
    Rooms.Floor,
    Rooms.WindowCount,
    Status.CheckInDate,
    Status.CheckOutDate
FROM
	Status
JOIN
    Clients ON Status.ClientCode = Clients.ClientCode
JOIN
	Rooms ON Status.RoomCode = Rooms.RoomCode
JOIN
	RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE 
    Status.CheckOutDate IS NULL OR Status.CheckOutDate > GETDATE();
GO

-- � ������� ���������� ������������� ���������� ������� �������, ������������� ������ ����.
SELECT TOP 5 InfoOccupiedRooms.FullName
FROM InfoOccupiedRooms
ORDER BY InfoOccupiedRooms.CheckInDate ASC;
GO

--2.	������� �������������, ���������� ������ ���������� ��� ���� ������� �����. 
CREATE VIEW InfoHotelRooms AS
SELECT
	Rooms.RoomCode,
	Rooms.Number,
	Rooms.Floor,
	Rooms.WindowCount,
	Rooms.TypeCode,
	RoomTypes.Type,
	RoomTypes.Price
FROM
	Rooms
JOIN
	RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode;
GO

--� ������� ���������� ������������� ���������� ���������� ����� ������� �������.
SELECT COUNT(*) AS MostExpensiveRoomsCount
FROM InfoHotelRooms
WHERE InfoHotelRooms.Price = (SELECT MAX(InfoHotelRooms.Price) FROM InfoHotelRooms);
GO

--3.	������� �������������, ���������� ���������� � ������� ������� ���������� ������� � ������ ������. 
CREATE VIEW AvgStayTime AS 
SELECT 
	Archive.RoomCode,
	Rooms.Number,
	Rooms.TypeCode,
	RoomTypes.Type,
	AVG(DATEDIFF(day, Archive.CheckInDate, Archive.CheckOutDate)) AS AverageStayDuration
FROM
	Archive
JOIN
	Rooms ON Archive.RoomCode = Rooms.RoomCode
JOIN
	RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE
    Archive.CheckOutDate IS NOT NULL
GROUP BY
    Archive.RoomCode, Rooms.Number, Rooms.TypeCode, RoomTypes.Type;
GO

--� ������� ���������� ������������� ���������� ������ � ���������� ������� ������������������ ���������� � ���.
SELECT 
	AvgStayTime.RoomCode,
	AvgStayTime.Number,
	AvgStayTime.Type,
	AvgStayTime.AverageStayDuration
FROM
	AvgStayTime
WHERE 
	AvgStayTime.AverageStayDuration = (SELECT MIN(AvgStayTime.AverageStayDuration) FROM AvgStayTime);
GO

--4.	������� �������������, ���������� ���������� � ��������, ����������� � ����� � ������� ������. 
CREATE VIEW InfoClientsLastMonth AS
WITH MarchPeriod AS (
    SELECT 
        '2025-03-01' AS MonthStart,
        '2025-03-31' AS MonthEnd
)
SELECT 
    Clients.ClientCode,
    CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
    Clients.PassportNumber,
    Archive.RoomCode,
    Rooms.Number,
    RoomTypes.Type,
    RoomTypes.Price,
    Archive.CheckInDate,
    Archive.CheckOutDate,
    -- ������ ���������� ���� ���������� � �����
    CASE
        -- ������ ������ � ����� � ������ � �����
        WHEN Archive.CheckInDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd 
            AND Archive.CheckOutDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd
        THEN CAST(DAY(Archive.CheckOutDate) - DAY(Archive.CheckInDate) + 1 AS INT)
        
        -- ������ ������ �� ����� � ������ � �����
        WHEN Archive.CheckInDate < MarchPeriod.MonthStart 
            AND Archive.CheckOutDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd
        THEN CAST(DAY(Archive.CheckOutDate) AS INT)
        
        -- ������ ������ � ����� � ������ ����� ����� (��� ��� �� ������)
        WHEN Archive.CheckInDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd 
            AND (Archive.CheckOutDate > MarchPeriod.MonthEnd OR Archive.CheckOutDate IS NULL)
        THEN CAST(31 - DAY(Archive.CheckInDate) + 1 AS INT)
        
        -- ������ ������ �� ����� � ������ ����� ����� (��� ��� �� ������)
        WHEN Archive.CheckInDate < MarchPeriod.MonthStart 
            AND (Archive.CheckOutDate > MarchPeriod.MonthEnd OR Archive.CheckOutDate IS NULL)
        THEN 31
    END AS DaysInMarch,
    
    -- ������ ��������� ���������� �� ����
    CASE
        -- ������ ������ � ����� � ������ � �����
        WHEN Archive.CheckInDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd 
            AND Archive.CheckOutDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd
        THEN CAST(DAY(Archive.CheckOutDate) - DAY(Archive.CheckInDate) + 1 AS INT) * RoomTypes.Price
        
        -- ������ ������ �� ����� � ������ � �����
        WHEN Archive.CheckInDate < MarchPeriod.MonthStart 
            AND Archive.CheckOutDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd
        THEN CAST(DAY(Archive.CheckOutDate) AS INT) * RoomTypes.Price
        
        -- ������ ������ � ����� � ������ ����� ����� (��� ��� �� ������)
        WHEN Archive.CheckInDate BETWEEN MarchPeriod.MonthStart AND MarchPeriod.MonthEnd 
            AND (Archive.CheckOutDate > MarchPeriod.MonthEnd OR Archive.CheckOutDate IS NULL)
        THEN CAST(31 - DAY(Archive.CheckInDate) + 1 AS INT) * RoomTypes.Price
        
        -- ������ ������ �� ����� � ������ ����� ����� (��� ��� �� ������)
        WHEN Archive.CheckInDate < MarchPeriod.MonthStart 
            AND (Archive.CheckOutDate > MarchPeriod.MonthEnd OR Archive.CheckOutDate IS NULL)
        THEN 31 * RoomTypes.Price
    END AS MarchCost
FROM
    Archive
JOIN 
    Clients ON Archive.ClientCode = Clients.ClientCode
JOIN
    Rooms ON Archive.RoomCode = Rooms.RoomCode
JOIN
    RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
CROSS JOIN
    MarchPeriod
WHERE 
    -- ���������� ���� �� �������� �������� �� ���� 2025
    (Archive.CheckInDate <= MarchPeriod.MonthEnd) AND 
    (Archive.CheckOutDate IS NULL OR Archive.CheckOutDate >= MarchPeriod.MonthStart);
GO

--� ������� ���������� ������������� ���������� ������� ��������� �� ������� �����.
SELECT SUM(InfoClientsLastMonth.MarchCost) AS MarchCashRevenue
FROM InfoClientsLastMonth;
GO