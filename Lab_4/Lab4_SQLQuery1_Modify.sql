USE Hotel;

-- Изменим цены некоторых типов номеров, чтобы были и дороже и дешевле 50 руб.
UPDATE RoomTypes SET Price = 40.00 WHERE TypeCode = 1;
UPDATE RoomTypes SET Price = 70.00 WHERE TypeCode = 2;
UPDATE RoomTypes SET Price = 120.00 WHERE TypeCode = 3;

-- Добавим тип "Люкс" для задания 5
INSERT INTO RoomTypes (Type, Price)
VALUES ('Lux', 200.00);

-- Добавим номера типа "Люкс" на втором этаже
INSERT INTO Rooms (Number, TypeCode, Floor)
VALUES (204, 4, 2), (205, 4, 2);

-- Заселим клиентов в номера "Люкс" на втором этаже
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(1, 11, '20/02/2025', '28/02/2025'), -- Романков в Люксе
(3, 12, '21/02/2025', NULL); -- Дмитриенко в Люксе без даты выезда