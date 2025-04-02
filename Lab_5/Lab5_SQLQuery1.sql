USE Hotel;

--	Используя операции соединения таблиц построить следующие запросы:
--	1. Составить список номеров второго этажа с указанием их типа.
SELECT Rooms.RoomCode, Rooms.Number, RoomTypes.Type, RoomTypes.Price
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE Rooms.Floor = 2
ORDER BY Rooms.Number;

--	2. Составить список клиентов, проживающих на третьем этаже с указанием  номера и его типа.
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

--	3. Составить таблицу полной информации о номерах отеля.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price,
	   CASE 
           WHEN Status.RoomCode IS NULL THEN 'Свободен'
           WHEN Status.CheckOutDate IS NULL THEN 'Занят бессрочно'
           WHEN Status.CheckOutDate > '2025-02-28' THEN 'Занят до ' + CONVERT(VARCHAR, Status.CheckOutDate, 103)
           ELSE 'Свободен'
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

--	4. Составить таблицу, содержащую сведения о номерах и клиентах на следующую неделю.
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
 
--	Используя операции UNION, EXCEPT, INTERSECT построить следующие запросы:
--	1.	Найти однофамильцев среди клиентов.
--INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
--VALUES ('Иванов', 'Сергей', 'Васильевич', 'МР7634211');
--DELETE FROM Clients 
--WHERE clientcode IN (11, 12);

SELECT Clients.LastName, COUNT(*) AS NumberOfClients
FROM Clients
GROUP BY Clients.LastName
HAVING COUNT(*) > 1;

--	2.	Составить список клиентов, которые ранее проживали в отеле и забронировали номера на следующую неделю.
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

--	3.	Составить список клиентов, несколько раз проживавших в одном и том же номере.
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
