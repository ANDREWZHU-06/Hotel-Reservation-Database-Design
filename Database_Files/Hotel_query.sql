/* query 5-star hotel */
select Hotel_name
from Hotel
where Hotel_star = 5


/* query the oders that have been canceled */
select Orders_id,
Hotel_id,
Users_id
from orders
where Progress = 'canceled'


/* query oders in Feb,2023 */
select Orders_id,
Hotel_id,
Users_id,
payment_day
from orders
where payment_day >= '2023-02-01 00:00:00'
AND payment_day <= '2023-03-01 00:00:00'
order by payment_day desc


/*query top 3 price room in each hotel*/
SELECT  hotel_name,
room_name,
bedtype,
price
From(
select h.hotel_name,
r.room_name,
r.bedtype,
r.price,
RANK()OVER(partition by h.hotel_name order by r.price desc) posn
from Hotel h join Room r
on h.hotel_id = r.hotel_id
) as rk
where rk.posn <= 3

/* query info with 5-star rating */
SELECT u.Users_name,
h.Hotel_name,
r.Rating,
r.Comment_content
FROM Review r
join Hotel h on h.hotel_id = r.hotel_id
join Users u on u.Users_id = r.Users_id
where r.Rating = 5


/* query the most loyal customer of every hotel */
SELECT 
    h.Hotel_name,
    u.Users_id,
    u.Users_name,
    uo.OrderCount
FROM 
    Hotel h
JOIN 
    (SELECT 
         o.Hotel_id,
         o.Users_id,
         COUNT(*) AS OrderCount
     FROM 
         Orders o
     GROUP BY 
         o.Hotel_id, o.Users_id
	HAVING COUNT(*) > 1
    ) uo ON h.Hotel_id = uo.Hotel_id
JOIN 
    Users u ON u.Users_id = uo.Users_id
LEFT JOIN 
    (SELECT 
         Hotel_id, 
         MAX(OrderCount) AS MaxOrders
     FROM 
         (SELECT 
              Hotel_id, 
              Users_id, 
              COUNT(*) AS OrderCount
          FROM 
              Orders
          GROUP BY 
              Hotel_id, Users_id
		  HAVING COUNT(*) > 1
         ) AS UserOrderCounts
     GROUP BY 
         Hotel_id
    ) mo ON uo.Hotel_id = mo.Hotel_id AND uo.OrderCount = mo.MaxOrders;

