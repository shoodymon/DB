USE Hotel;

-- Добавим клиента с фамилией "Иванов" для запроса 2
INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
VALUES ('Иванов', 'Петр', 'Сергеевич', 'МР5678901');

-- Добавим клиента с фамилией на "К" для запроса 7
INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
VALUES ('Козлов', 'Иван', 'Петрович', 'МР2345678');

-- Добавим номер типа 1 на втором этаже для запроса 3
-- Проверим, есть ли уже такие номера
INSERT INTO Rooms (Number, TypeCode, Floor)
VALUES (203, 1, 2);

-- Добавим бронирования с датами заезда 5, 10, 15 марта для запроса 4
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(5, 2, '05/03/2025', '10/03/2025'),
(5, 6, '10/03/2025', '15/03/2025'),
(6, 10, '15/03/2025', '20/03/2025');

-- Добавим бронирования с датами выезда на следующей неделе для запроса 5
-- Текущая дата 24.02.2025, следующая неделя - 24.02.2025 - 02.03.2025
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(6, 7, '20/02/2025', '25/02/2025'),
(6, 8, '21/02/2025', '28/02/2025'),
(5, 9, '22/02/2025', '01/03/2025');

-- Убедимся, что у нас есть свободные номера для запроса 6
-- Номера 1,2,3,4,5 уже заняты, добавим освободившиеся ранее
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES (5, 2, '01/02/2025', '10/02/2025');