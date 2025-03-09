--USE Hotel;

----SELECT * FROM Rooms;
----SELECT * FROM RoomTypes;

---- 1.	Список номеров стоимостью более 50 руб.
--SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price
--FROM Rooms
--JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
--WHERE RoomTypes.Price > 50.00;

---- Версия с алиасами
----SELECT r.RoomCode, r.Number, r.Floor, rt.Type, rt.Price
----FROM Rooms r
----JOIN RoomTypes rt ON r.TypeCode = rt.TypeCode
----WHERE rt.Price > 50.00;

----SELECT * FROM Rooms;
----SELECT * FROM RoomTypes;
----SELECT * FROM Status;
---- 2.	Список номеров, освобождающихся на следующей неделе.
--SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, Status.CheckOutDate
--FROM Rooms
--JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
--JOIN Status ON Rooms.RoomCode = Status.RoomCode
--WHERE Status.CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09';


---- 3.	Список клиентов, имеющих бронь на номера.
--SELECT DISTINCT Clients.ClientCode, Clients.LastName, Clients.FirstName, Clients.MiddleName
--FROM Clients
--JOIN Status ON Clients.ClientCode = Status.ClientCode
--WHERE Status.CheckOutDate IS NULL OR Status.CheckOutDate >= '2025-03-03';

---- 4.	Список самых дешевых номеров.
--SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, RoomTypes.Type, RoomTypes.Price
--FROM Rooms
--JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
--WHERE RoomTypes.Price = (SELECT MIN(Price) FROM RoomTypes);

---- 5.	Список клиентов, проживающих в номерах «Люкс» на втором этаже.
--SELECT 
--	Clients.ClientCode,
--	CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
--	Rooms.Number,
--	Rooms.Floor,
--	Status.CheckOutDate
--FROM Clients
--JOIN Status ON Clients.ClientCode = Status.ClientCode
--JOIN Rooms ON Status.RoomCode = Rooms.RoomCode
--JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
--WHERE RoomTypes.Type = 'Lux'
--AND Rooms.Floor = 2
--AND (Status.CheckOutDate IS NULL OR Status.CheckOutDate > '2025-02-24');


-- ПОДЗАПРОСЫ

Use Hotel;

---- 1.	Список номеров стоимостью более 50 руб.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor, 
       (SELECT Type FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) AS Type,
       (SELECT Price FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) AS Price
FROM Rooms
WHERE (SELECT Price FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) > 50.00;

---- 2.	Список номеров, освобождающихся на следующей неделе.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor,
       (SELECT Type FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) AS Type,
       (SELECT CheckOutDate FROM Status WHERE RoomCode = Rooms.RoomCode 
        AND CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09') AS CheckOutDate
FROM Rooms
WHERE EXISTS (
    SELECT 1 FROM Status 
    WHERE RoomCode = Rooms.RoomCode 
    AND CheckOutDate BETWEEN '2025-03-03' AND '2025-03-09'
);

---- 3.	Список клиентов, имеющих бронь на номера.
SELECT DISTINCT Clients.ClientCode, Clients.LastName, Clients.FirstName, Clients.MiddleName
FROM Clients
WHERE EXISTS (
    SELECT 1 FROM Status 
    WHERE ClientCode = Clients.ClientCode 
    AND (CheckOutDate IS NULL OR CheckOutDate >= '2025-03-03')
);

---- 4.	Список самых дешевых номеров.
SELECT Rooms.RoomCode, Rooms.Number, Rooms.Floor,
       (SELECT Type FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) AS Type,
       (SELECT Price FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) AS Price
FROM Rooms
WHERE (SELECT Price FROM RoomTypes WHERE TypeCode = Rooms.TypeCode) = 
      (SELECT MIN(Price) FROM RoomTypes);

---- 5.	Список клиентов, проживающих в номерах «Люкс» на втором этаже.
SELECT 
    Clients.ClientCode,
    CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
    (SELECT Number FROM Rooms WHERE RoomCode = 
        (SELECT RoomCode FROM Status WHERE ClientCode = Clients.ClientCode 
         AND (CheckOutDate IS NULL OR CheckOutDate > '2025-02-24'))) AS Number,
    (SELECT Floor FROM Rooms WHERE RoomCode = 
        (SELECT RoomCode FROM Status WHERE ClientCode = Clients.ClientCode 
         AND (CheckOutDate IS NULL OR CheckOutDate > '2025-02-24'))) AS Floor,
    (SELECT CheckOutDate FROM Status WHERE ClientCode = Clients.ClientCode 
     AND (CheckOutDate IS NULL OR CheckOutDate > '2025-02-24')) AS CheckOutDate
FROM Clients
WHERE EXISTS (
    SELECT 1 FROM Status 
    WHERE ClientCode = Clients.ClientCode 
    AND (CheckOutDate IS NULL OR CheckOutDate > '2025-02-24')
    AND RoomCode IN (
        SELECT RoomCode FROM Rooms 
        WHERE Floor = 2 
        AND TypeCode = (SELECT TypeCode FROM RoomTypes WHERE Type = 'Lux')
    )
);