USE Hotel;
GO

--1.	������������ ������  ��������, ����������� � �������� ������ � ������� ������.
CREATE PROCEDURE GetClientsInRoomLastMonth
    @RoomCode INT
AS
BEGIN
    SELECT DISTINCT 
        Clients.ClientCode,
        CONCAT(Clients.LastName, ' ', Clients.FirstName, ' ', Clients.MiddleName) AS FullName,
        Clients.PassportNumber,
		Archive.CheckInDate,
		Archive.CheckOutDate
    FROM Clients
    INNER JOIN Archive ON Clients.ClientCode = Archive.ClientCode
    WHERE Archive.RoomCode = @RoomCode
      AND MONTH(Archive.CheckOutDate) = MONTH(GETDATE()) - 1
      AND YEAR(Archive.CheckOutDate) = YEAR(GETDATE())
	ORDER BY Archive.CheckInDate ASC;
END
GO

--2.	������������ ������ �������, ��������������� �� ������.
CREATE PROCEDURE GetRoomsBookedForDate
    @CheckInDate DATE
AS
BEGIN
    SELECT DISTINCT 
        Rooms.RoomCode,
        Rooms.Number,
        Rooms.TypeCode,
        Rooms.Floor,
        Rooms.WindowCount
    FROM Rooms
    INNER JOIN Status ON Rooms.RoomCode = Status.RoomCode
    WHERE Status.CheckInDate = @CheckInDate
END
GO

--3.	������������ ������ ��� ����� ��� ������� �������� ����� � ������� ������. 
--��������� ������� �� ����� ������ ������ �������� ����������.
CREATE PROCEDURE GetRoomOccupancyDatesAndRevenueLastMonth
    @RoomCode INT,
    @TotalRevenue DECIMAL OUTPUT
AS
BEGIN
    -- ������ ��� ���������
    SELECT Archive.CheckInDate
    FROM Archive
    WHERE Archive.RoomCode = @RoomCode
      AND MONTH(Archive.CheckInDate) = MONTH(GETDATE()) - 1
      AND YEAR(Archive.CheckInDate) = YEAR(GETDATE());
	
	--������������� ������
	SELECT COUNT(*) AS OccupiedDays
	FROM Archive
	WHERE Archive.RoomCode = @RoomCode
	  AND MONTH(Archive.CheckInDate) = MONTH(GETDATE()) - 1
	  AND YEAR(Archive.CheckInDate) = YEAR(GETDATE());

    -- ��������� �������
    SELECT @TotalRevenue = ISNULL(SUM(RoomTypes.Price), 0)
    FROM Archive
    INNER JOIN Rooms ON Archive.RoomCode = Rooms.RoomCode
    INNER JOIN RoomTypes ON Rooms.TypeCode = RoomTypes.TypeCode
    WHERE Archive.RoomCode = @RoomCode
      AND MONTH(Archive.CheckInDate) = MONTH(GETDATE()) - 1
      AND YEAR(Archive.CheckInDate) = YEAR(GETDATE());

	SELECT @TotalRevenue AS TotalRevenue;
END
GO
