USE Hotel;

--	��������� �������� ���������� ������ ��������� ��������� �������:
--	1. ��������� ������ ������� ������� ����� � ��������� �� ����.
SELECT Rooms.RoomCode, Rooms.Number, RoomTypes.Type, RoomTypes.Price
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE Rooms.Floor = 2
ORDER BY Rooms.Number;

--	2. ��������� ������ ��������, ����������� �� ������� ����� � ���������  ������ � ��� ����.
SELECT 
	Clients.ClientCode,
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
	Rooms.Number,
	Rooms.Floor,
	RoomTypes.Type,
	Status.CheckInDate
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
JOIN Rooms ON Status.RoomCode = Rooms.RoomCode
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE Rooms.Floor = 3
AND (Status.CheckOutDate IS NULL OR Status.CheckOutDate > '2025-02-28')
ORDER BY Rooms.Number;

--	3. ��������� ������� ������ ���������� � ������� �����.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price,
	   CASE 
           WHEN Status.RoomCode IS NULL THEN '��������'
           WHEN Status.CheckOutDate IS NULL THEN '����� ���������'
           WHEN Status.CheckOutDate > '2025-02-28' THEN '����� �� ' + CONVERT(VARCHAR, Status.CheckOutDate, 103)
           ELSE '��������'
       END AS Status,
       CASE 
           WHEN Status.ClientCode IS NOT NULL THEN CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName)
           ELSE NULL
       END AS Client
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
LEFT JOIN Status ON Rooms.RoomCode = Status.RoomCode 
AND (Status.CheckOutDate IS NULL OR Status.CheckOutDate > '2025-02-28')
LEFT JOIN Clients ON Status.ClientCode = Clients.ClientCode
ORDER BY Rooms.Floor, Rooms.Number;

--	4. ��������� �������, ���������� �������� � ������� � �������� �� ��������� ������.
SELECT
	Rooms.RoomCode,
	Rooms.Number,
	Rooms.Floor,
	RoomTypes.Type,
	RoomTypes.Price,
	Clients.ClientCode,
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
	Status.CheckInDate,
	Status.CheckOutDate
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
JOIN Status ON Rooms.RoomCode = Status.RoomCode 
JOIN Clients ON Status.ClientCode = Clients.ClientCode
WHERE (Status.CheckInDate BETWEEN '2025-03-03' AND '2025-03-09'
       OR Status.CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09'
       OR (Status.CheckInDate < '2025-03-03' AND (Status.CheckOutDate > '2025-03-09' OR Status.CheckOutDate IS NULL)))
ORDER BY Rooms.Number;
 
--	��������� �������� UNION, EXCEPT, INTERSECT ��������� ��������� �������:
--	1.	����� ������������� ����� ��������.
--INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
--VALUES ('������', '������', '����������', '��7634211');
--DELETE FROM Clients 
--WHERE clientcode IN (11, 12);

SELECT Clients.LastName, COUNT(*) AS NumberOfClients
FROM Clients
GROUP BY Clients.LastName
HAVING COUNT(*) > 1;

--	2.	��������� ������ ��������, ������� ����� ��������� � ����� � ������������� ������ �� ��������� ������.
SELECT DISTINCT
	Clients.ClientCode,
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
WHERE Status.CheckOutDate < '2025-03-03'

INTERSECT

SELECT DISTINCT 
	Clients.ClientCode,
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
WHERE (Status.CheckInDate BETWEEN '2025-03-03' AND '2025-03-09'
       OR Status.CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09'
       OR (Status.CheckInDate < '2025-03-03' AND (Status.CheckOutDate > '2025-03-09' OR Status.CheckOutDate IS NULL)));

--	3.	��������� ������ ��������, ��������� ��� ����������� � ����� � ��� �� ������.
--INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
--VALUES (1, 1, '2025-01-10', '2025-01-15');

SELECT 
	Clients.ClientCode, 
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
	Rooms.RoomCode, 
	Rooms.Number, 
	COUNT(*) AS TimesStayed
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
JOIN Rooms ON Status.RoomCode = Rooms.RoomCode
GROUP BY Clients.ClientCode, Clients.LastName, Clients.FirstName, Clients.MiddleName, Rooms.RoomCode, Rooms.Number 
HAVING COUNT(*) > 1
ORDER BY Clients.LastName, Rooms.Number
