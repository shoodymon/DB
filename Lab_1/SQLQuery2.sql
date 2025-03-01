USE Hotel;

INSERT INTO RoomTypes (Type, Price) VALUES
('Single', 1500.0),
('Double ', 2400.0),
('Family', 3000.0);

INSERT INTO Rooms (Number, TypeCode, Floor) VALUES
(101, 1, 1),
(102, 1, 1),
(201, 2, 2),
(202, 2, 2),
(301, 3, 3),
(302, 1, 3),
(401, 2, 4),
(402, 3, 4),
(501, 2, 5),
(502, 1, 5);

INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber) VALUES
('Романков','Стасян','Губенкович','МР4857263'),
('Борсуков','Ростик','Алладинович','МР9375932'),
('Дмитриенко','Артурчик','Тигранович','МР4759237'),
('Ябубович','Иллидан','Джамшутович','МР0192345');

INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate) VALUES
(1, 1, '15/02/2025', '19/02/2025'),
(2, 3, '16/02/2025', '26/02/2025'),
(3, 5, '17/02/2025', '23/02/2025'),
(4, 4, '18/02/2025', '08/03/2025');