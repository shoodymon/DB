USE Hotel;

-- 1. ������� ������� ������ � �������� �������� ������ �� ���������� ����
INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES 
    (1, 3, '2022-06-15', '2022-06-20'),
    (2, 5, '2023-07-10', '2023-07-15'),
    (3, 11, '2024-01-05', '2024-01-12');
GO

CREATE TABLE Archive (
    ArchiveID INT IDENTITY(1,1) PRIMARY KEY,
    ClientCode INT,
    RoomCode INT,
    CheckInDate DATE,
    CheckOutDate DATE,
    FOREIGN KEY (ClientCode) REFERENCES Clients(ClientCode),
    FOREIGN KEY (RoomCode) REFERENCES Rooms(RoomCode)
);
GO

INSERT INTO Archive (ClientCode, RoomCode, CheckInDate, CheckOutDate)
SELECT ClientCode, RoomCode, CheckInDate, CheckOutDate
FROM Status
WHERE YEAR(CheckInDate) < 2025;
GO

SELECT * FROM Archive;
GO

-- 2. �������� � ������� ������� ���� ����������� ���� � ������ ������
ALTER TABLE Rooms
ADD WindowCount INT;
GO

UPDATE Rooms
SET WindowCount = 
    CASE 
        WHEN Floor % 2 = 0 THEN 2  -- ������ ����� - 2 ����
        ELSE 1                     -- �������� ����� - 1 ����
    END;
GO

SELECT * FROM Rooms;
GO

-- 3. ���������������� ������� ��������� �� ����� ��������� � ������ ��������
-- �������� ������� �� ���� "�������"
CREATE INDEX IX_Clients_LastName ON Clients(LastName);
GO

-- �������� ������� �� ���� "����� ��������"
CREATE INDEX IX_Clients_PassportNumber ON Clients(PassportNumber);
GO

-- 4. ������� �� ������� ���������� ������ � ��������� ������� �� ���������� ����
-- ������� �������� ������ � ����� (���� �� ������� ��� � ���� 1)
INSERT INTO Archive (ClientCode, RoomCode, CheckInDate, CheckOutDate)
SELECT ClientCode, RoomCode, CheckInDate, CheckOutDate
FROM Status
WHERE YEAR(CheckInDate) < 2025 AND NOT EXISTS (
    SELECT 1 FROM Archive 
    WHERE Archive.ClientCode = Status.ClientCode 
    AND Archive.RoomCode = Status.RoomCode 
    AND Archive.CheckInDate = Status.CheckInDate
);
GO

DELETE FROM Status
WHERE YEAR(CheckInDate) < 2025;
GO

-- 5. ������� �� ������� ��������� ��������, ������� �� ��������� � ����� � ���� ����
WITH ClientsStayedIn2025 AS (
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckInDate) = 2025
    UNION
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckOutDate) = 2025 OR CheckOutDate IS NULL
)

DELETE FROM Status
WHERE ClientCode NOT IN (SELECT ClientCode FROM ClientsStayedIn2025);
GO

WITH ClientsStayedIn2025 AS (
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckInDate) = 2025
    UNION
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckOutDate) = 2025 OR CheckOutDate IS NULL
)
DELETE FROM Archive
WHERE ClientCode NOT IN (SELECT ClientCode FROM ClientsStayedIn2025);
GO

WITH ClientsStayedIn2025 AS (
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckInDate) = 2025
    UNION
    SELECT DISTINCT ClientCode FROM Status WHERE YEAR(CheckOutDate) = 2025 OR CheckOutDate IS NULL
)
DELETE FROM Clients
WHERE ClientCode NOT IN (SELECT ClientCode FROM ClientsStayedIn2025);
GO
