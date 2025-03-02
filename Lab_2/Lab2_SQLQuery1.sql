USE Hotel;

-- ������� ������� � �������� "������" ��� ������� 2
INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
VALUES ('������', '����', '���������', '��5678901');

-- ������� ������� � �������� �� "�" ��� ������� 7
INSERT INTO Clients (LastName, FirstName, MiddleName, PassportNumber)
VALUES ('������', '����', '��������', '��2345678');

-- ������� ����� ���� 1 �� ������ ����� ��� ������� 3
-- ��������, ���� �� ��� ����� ������
INSERT INTO Rooms (Number, TypeCode, Floor)
VALUES (203, 1, 2);

-- ������� ������������ � ������ ������ 5, 10, 15 ����� ��� ������� 4
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(5, 2, '05/03/2025', '10/03/2025'),
(5, 6, '10/03/2025', '15/03/2025'),
(6, 10, '15/03/2025', '20/03/2025');

-- ������� ������������ � ������ ������ �� ��������� ������ ��� ������� 5
-- ������� ���� 24.02.2025, ��������� ������ - 24.02.2025 - 02.03.2025
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
(6, 7, '20/02/2025', '25/02/2025'),
(6, 8, '21/02/2025', '28/02/2025'),
(5, 9, '22/02/2025', '01/03/2025');

-- ��������, ��� � ��� ���� ��������� ������ ��� ������� 6
-- ������ 1,2,3,4,5 ��� ������, ������� �������������� �����
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES (5, 2, '01/02/2025', '10/02/2025');