USE Hotel;

-- 1.	ѕодсчитать количество номеров в отеле. 
SELECT COUNT(*) AS TotalRooms FROM Rooms;

-- 2.	ѕодсчитать среднее количество номеров на этаже отел€.
SELECT AVG(RoomsPerFloor) AS AvgRoomsPerFloor
FROM (
    SELECT Floor, COUNT(*) AS RoomsPerFloor
    FROM Rooms
    GROUP BY Floor
) AS FloorsCount;

-- 3.	ќпределить максимальную стоимость проживани€ в отеле.
SELECT MAX(Price) AS MaxPrice FROM RoomTypes;

-- 4.	ќпределить среднюю продолжительность  проживани€ в отеле.
SELECT AVG(DATEDIFF(day, CheckInDate, CheckOutDate)) AS AvgStayDuration
FROM Status
WHERE CheckOutDate IS NOT NULL;

-- 5.	ќпределить максимальную продолжительность проживани€ в отеле в прошлом мес€це.
SELECT MAX(DATEDIFF(day, CheckInDate, CheckOutDate)) AS MaxStayDurationLastMonth
FROM Status
WHERE (CheckInDate BETWEEN '01/02/2025' AND '28/02/2025' OR 
      CheckOutDate BETWEEN '01/02/2025' AND '28/02/2025' OR
      (CheckInDate < '01/02/2025' AND CheckOutDate > '28/02/2025'));

-- 6.	ќпределить количество клиентов, проживавших в отеле на прошлой неделе.
--		—егодн€ 24 феврал€(пн). ƒелаем дл€ 17-23 фервал€
SELECT COUNT(DISTINCT ClientCode) AS ClientsLastWeek
FROM Status
WHERE (CheckInDate BETWEEN '17/02/2025' AND '23/02/2025' OR 
      CheckOutDate BETWEEN '17/02/2025' AND '23/02/2025' OR
      (CheckInDate < '17/02/2025' AND (CheckOutDate > '17/02/2025' OR CheckOutDate IS NULL)));

-- 7.	ќпределить суммарное количество номеров, забронированных на следующую неделю.
--		—егодн€ 24 феврал€(пн). ƒелаем дл€ 3-9 марта
SELECT COUNT(*) AS BookedRoomsNextWeek
FROM Status
WHERE (CheckInDate BETWEEN '03/03/2025' AND '09/03/2025' OR 
      CheckOutDate BETWEEN '03/03/2025' AND '09/03/2025' OR
      (CheckInDate < '03/03/2025' AND (CheckOutDate > '03/03/2025' OR CheckOutDate IS NULL)));