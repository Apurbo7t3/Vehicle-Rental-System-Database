-- queries

-- query 1
select booking_id, users.name as customer_name,
vehicles.name as vehicle_name, start_date, end_date, bookings.status
from bookings
inner join users on bookings.user_id = users.user_id
inner join vehicles on bookings.vehicle_id=vehicles.vehicle_id;

-- quuery 2
select * from vehicles
where not exists(
select * 
from bookings
where bookings.vehicle_id=vehicles.vehicle_id
)
order by vehicle_id;

-- quuery 3
select * from vehicles
where type = 'car' AND status = 'available';

-- quuery 4
select name as vehicle_name, count(*) as total_bookings 
from vehicles
inner join bookings on bookings.vehicle_id=vehicles.vehicle_id
group by vehicles.vehicle_id
having count(*)>2;

