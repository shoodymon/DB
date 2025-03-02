USE Hotel;

-- 1. Вывести всю таблицу «Состояние».
SELECT * FROM Status;

-- 2. Вывести список клиентов с фамилией «Иванов».
SELECT * FROM Clients
WHERE LastName = 'Иванов';

-- 3. Вывести список номеров типа 1 на втором этаже.
SELECT * FROM Rooms
WHERE TypeCode = 1 AND Floor = 2;

-- 4. Вывести список кодов номеров с датами вселения 5, 10, 15 числа следующего месяца.
-- Cледующий месяц - март
SELECT RoomCode FROM Status
WHERE CheckInDate IN ('05/03/2025', '10/03/2025', '15/03/2025');

-- 5. Вывести список кодов номеров, освобождающихся на следующей неделе.
-- Следующая неделя - с 24.02.2025 по 02.03.2025
SELECT RoomCode FROM Status
WHERE CheckOutDate BETWEEN '24/02/2025' AND '02/03/2025';

-- 6. Вывести список свободных номеров.
-- Номер считается свободным, если его нет в таблице Status с пустой датой выезда
-- или если дата выезда уже наступила
SELECT r.* FROM Rooms r
WHERE r.RoomCode NOT IN (
    SELECT s.RoomCode FROM Status s
    WHERE s.CheckOutDate IS NULL OR s.CheckOutDate > '24/02/2025'
);

-- 7. Вывести список клиентов, фамилии которых начинаются на "К".
SELECT * FROM Clients
WHERE LastName LIKE 'К%';