--USE Hotel;

---- 1.	ѕодсчитать количество номеров в отеле. 
--SELECT COUNT(*) AS TotalRooms FROM Rooms;

---- 2.	ѕодсчитать среднее количество номеров на этаже отел€.
--SELECT AVG(RoomsPerFloor) AS AvgRoomsPerFloor
--FROM (
--    SELECT Floor, COUNT(*) AS RoomsPerFloor
--    FROM Rooms
--    GROUP BY Floor
--) AS FloorsCount;

---- 3.	ќпределить максимальную стоимость проживани€ в отеле.
--SELECT MAX(Price) AS MaxPrice FROM RoomTypes;

---- 4.	ќпределить среднюю продолжительность  проживани€ в отеле.
--SELECT AVG(DATEDIFF(day, CheckInDate, CheckOutDate)) AS AvgStayDuration
--FROM Status
--WHERE CheckOutDate IS NOT NULL;

---- 5.	ќпределить максимальную продолжительность проживани€ в отеле в прошлом мес€це.
--SELECT MAX(DATEDIFF(day, CheckInDate, CheckOutDate)) AS MaxStayDurationLastMonth
--FROM Status
--WHERE (CheckInDate BETWEEN '01/02/2025' AND '28/02/2025' OR 
--      CheckOutDate BETWEEN '01/02/2025' AND '28/02/2025' OR
--      (CheckInDate < '01/02/2025' AND CheckOutDate > '28/02/2025'));

---- 6.	ќпределить количество клиентов, проживавших в отеле на прошлой неделе.
----		—егодн€ 24 феврал€(пн). ƒелаем дл€ 17-23 фервал€
--SELECT COUNT(DISTINCT ClientCode) AS ClientsLastWeek
--FROM Status
--WHERE (CheckInDate BETWEEN '17/02/2025' AND '23/02/2025' OR 
--      CheckOutDate BETWEEN '17/02/2025' AND '23/02/2025' OR
--      (CheckInDate < '17/02/2025' AND (CheckOutDate > '17/02/2025' OR CheckOutDate IS NULL)));

---- 7.	ќпределить суммарное количество номеров, забронированных на следующую неделю.
----		—егодн€ 24 феврал€(пн). ƒелаем дл€ 3-9 марта
--SELECT COUNT(*) AS BookedRoomsNextWeek
--FROM Status
--WHERE (CheckInDate BETWEEN '03/03/2025' AND '09/03/2025' OR 
--      CheckOutDate BETWEEN '03/03/2025' AND '09/03/2025' OR
--      (CheckInDate < '03/03/2025' AND (CheckOutDate > '03/03/2025' OR CheckOutDate IS NULL)));


USE Hotel;

-- 1. ѕодсчитать количество номеров в отеле.
SELECT COUNT(*) AS TotalRooms FROM Rooms;

-- 2. ѕодсчитать среднее количество номеров на этаже отел€.
SELECT Floor, COUNT(*) AS RoomsPerFloor
FROM Rooms
GROUP BY Floor
ORDER BY Floor;

-- ƒополнительно: общее среднее количество номеров на этаж
SELECT AVG(RoomsCount) AS AvgRoomsPerFloor
FROM (
    SELECT Floor, COUNT(*) AS RoomsCount
    FROM Rooms
    GROUP BY Floor
) AS FloorStats;

--SELECT 
--    COUNT(*) / COUNT(DISTINCT Floor) AS AvgRoomsPerFloor
--FROM 
--    Rooms;

--SELECT 
--    CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT Floor) AS AvgRoomsPerFloor
--FROM 
--    Rooms;

-- 3. ќпределить максимальную стоимость проживани€ в отеле.
SELECT TypeCode, Type, MAX(Price) AS MaxPrice 
FROM RoomTypes
GROUP BY TypeCode, Type
ORDER BY MAX(Price) DESC;

-- 4. ќпределить среднюю продолжительность проживани€ в отеле.
SELECT AVG(DATEDIFF(day, CheckInDate, CheckOutDate)) AS AvgStayDuration
FROM Status
WHERE CheckOutDate IS NOT NULL
GROUP BY YEAR(CheckInDate), MONTH(CheckInDate)
ORDER BY YEAR(CheckInDate), MONTH(CheckInDate);

-- 5. ќпределить максимальную продолжительность проживани€ в отеле в прошлом мес€це.
SELECT MAX(DATEDIFF(day, CheckInDate, CheckOutDate)) AS MaxStayDurationLastMonth
FROM Status
WHERE MONTH(CheckInDate) = MONTH(DATEADD(month, -1, GETDATE()))
AND YEAR(CheckInDate) = YEAR(DATEADD(month, -1, GETDATE()))
GROUP BY YEAR(CheckInDate), MONTH(CheckInDate)
HAVING MAX(DATEDIFF(day, CheckInDate, CheckOutDate)) > 0;

-- 6. ќпределить количество клиентов, проживавших в отеле на прошлой неделе.
SELECT COUNT(DISTINCT ClientCode) AS ClientsLastWeek
FROM Status
WHERE CheckInDate <= DATEADD(week, -1, GETDATE()) + 6 -- конец прошлой недели
AND (CheckOutDate >= DATEADD(week, -1, GETDATE()) OR CheckOutDate IS NULL) -- начало прошлой недели или еще проживает
GROUP BY DATEPART(week, CheckInDate)
ORDER BY DATEPART(week, CheckInDate);

---- 7. ќпределить суммарное количество номеров, забронированных на следующую неделю.
--SELECT 
--    DATEPART(week, CheckInDate) AS WeekNumber,
--    COUNT(*) AS BookedRoomsNextWeek
--FROM Status
--WHERE CheckInDate <= DATEADD(week, 1, GETDATE()) + 6 -- конец следующей недели
--AND (CheckOutDate >= DATEADD(week, 1, GETDATE()) OR CheckOutDate IS NULL) -- начало следующей недели или еще будет проживать
--GROUP BY DATEPART(week, CheckInDate)
--HAVING COUNT(*) > 0
--ORDER BY WeekNumber;

-- 7. ќпределить суммарное количество номеров, забронированных на следующую неделю.
SELECT COUNT(*) AS BookedRoomsNextWeek
FROM Status
WHERE CheckInDate <= DATEADD(week, 1, GETDATE()) + 6 -- конец следующей недели
AND (CheckOutDate >= DATEADD(week, 1, GETDATE()) OR CheckOutDate IS NULL); -- начало следующей недели или еще будет проживать