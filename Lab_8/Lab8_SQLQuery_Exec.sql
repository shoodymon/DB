USE Hotel;
GO

EXEC GetClientsInRoomLastMonth @RoomCode = 11;
EXEC GetClientsInRoomLastMonth @RoomCode = 12;
EXEC GetClientsInRoomLastMonth @RoomCode = 13;

DECLARE @Tomorrow DATE = DATEADD(DAY, 1, GETDATE());
EXEC GetRoomsBookedForDate @CheckInDate = @Tomorrow;

DECLARE @TotalRevenue DECIMAL;
EXEC GetRoomOccupancyDatesAndRevenueLastMonth 
    @RoomCode = 11, 
    @TotalRevenue = @TotalRevenue OUTPUT;
PRINT @TotalRevenue;