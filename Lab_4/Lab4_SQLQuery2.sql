USE Hotel;

--SELECT * FROM Rooms;
--SELECT * FROM RoomTypes;

-- 1.	������ ������� ���������� ����� 50 ���.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE RoomTypes.Price > 50.00;

-- ������ � ��������
--SELECT r.RoomCode, r.Number, r.Floor, rt.Type, rt.Price
--FROM Rooms r
--JOIN RoomTypes rt ON r.TypeCode = rt.TypeCode
--WHERE rt.Price > 50.00;

--SELECT * FROM Rooms;
--SELECT * FROM RoomTypes;
--SELECT * FROM Status;
-- 2.	������ �������, ��������������� �� ��������� ������.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, Status.CheckOutDate
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
JOIN Status ON Rooms.RoomCode = Status.RoomCode
WHERE Status.CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09';


-- 3.	������ ��������, ������� ����� �� ������.
SELECT DISTINCT Clients.ClientCode, Clients.LastName, Clients.FirstName, Clients.MiddleName
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
WHERE Status.CheckOutDate IS NULL OR Status.CheckOutDate >= '2025-03-03';

-- 4.	������ ����� ������� �������.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price
FROM Rooms
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE RoomTypes.Price = (SELECT MIN(Price) FROM RoomTypes);

-- 5.	������ ��������, ����������� � ������� ����� �� ������ �����.
SELECT 
	Clients.ClientCode,
	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
	Rooms.Number,
	Rooms.Floor,
	Status.CheckOutDate
FROM Clients
JOIN Status ON Clients.ClientCode = Status.ClientCode
JOIN Rooms ON Status.RoomCode = Rooms.RoomCode
JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
WHERE RoomTypes.Type = 'Lux'
AND Rooms.Floor = 2
AND (Status.CheckOutDate IS NULL OR Status.CheckOutDate > '2025-02-24');