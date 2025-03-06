USE Hotel;

-- ������� ���� ��������� ����� �������, ����� ���� � ������ � ������� 50 ���.
UPDATE RoomTypes SET Price = 40.00 WHERE TypeCode = 1;
UPDATE RoomTypes SET Price = 70.00 WHERE TypeCode = 2;
UPDATE RoomTypes SET Price = 120.00 WHERE TypeCode = 3;

-- ������� ��� "����" ��� ������� 5
INSERT INTO RoomTypes (Type, Price)
VALUES ('Lux', 200.00);

-- ������� ������ ���� "����" �� ������ �����
INSERT INTO Rooms (Number, TypeCode, Floor)
VALUES (204, 4, 2), (205, 4, 2);

-- ������� �������� � ������ "����" �� ������ �����
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(1, 11, '20/02/2025', '28/02/2025'), -- �������� � �����
(3, 12, '21/02/2025', NULL); -- ���������� � ����� ��� ���� ������