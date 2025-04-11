USE Hotel;
GO

INSERT INTO Archive (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES
    (1, 11, '2025-03-25', '2025-03-28'),  
    (2, 11, '2025-03-15', '2025-03-20'),  
    (3, 12, '2025-03-10', '2025-03-18'), 
    (4, 13, '2025-03-01', '2025-03-07'),  
    (5, 12, '2025-03-22', '2025-03-27');  
GO

INSERT INTO Status (ClientCode, RoomCode, CheckInDate, CheckOutDate)
VALUES
    (3, 13, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), DATEADD(DAY, 3, CAST(GETDATE() AS DATE))),
    (4, 11, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), NULL),
    (5, 12, DATEADD(DAY, 1, CAST(GETDATE() AS DATE)), DATEADD(DAY, 2, CAST(GETDATE() AS DATE)));
GO
