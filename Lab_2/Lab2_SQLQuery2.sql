USE Hotel;

-- 1. ������� ��� ������� ����������.
SELECT * FROM Status;

-- 2. ������� ������ �������� � �������� �������.
SELECT * FROM Clients
WHERE LastName = '������';

-- 3. ������� ������ ������� ���� 1 �� ������ �����.
SELECT * FROM Rooms
WHERE TypeCode = 1 AND Floor = 2;

-- 4. ������� ������ ����� ������� � ������ �������� 5, 10, 15 ����� ���������� ������.
-- C�������� ����� - ����
SELECT RoomCode FROM Status
WHERE CheckInDate IN ('05/03/2025', '10/03/2025', '15/03/2025');

-- 5. ������� ������ ����� �������, ��������������� �� ��������� ������.
-- ��������� ������ - � 24.02.2025 �� 02.03.2025
SELECT RoomCode FROM Status
WHERE CheckOutDate BETWEEN '24/02/2025' AND '02/03/2025';

-- 6. ������� ������ ��������� �������.
-- ����� ��������� ���������, ���� ��� ��� � ������� Status � ������ ����� ������
-- ��� ���� ���� ������ ��� ���������
SELECT r.* FROM Rooms r
WHERE r.RoomCode NOT IN (
    SELECT s.RoomCode FROM Status s
    WHERE s.CheckOutDate IS NULL OR s.CheckOutDate > '24/02/2025'
);

-- 7. ������� ������ ��������, ������� ������� ���������� �� "�".
SELECT * FROM Clients
WHERE LastName LIKE '�%';