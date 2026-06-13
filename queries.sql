
-- table creation 

CREATE TABLE IF NOT EXISTS users(
	user_id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	email VARCHAR(200) UNIQUE NOT NULL,
	phone VARCHAR(20) NOT NULL,
	role VARCHAR(200) NOT NULL DEFAULT 'Customer',

	CONSTRAINT check_role CHECK(role IN ('Admin','Customer'))
);

CREATE TABLE IF NOT EXISTS vehicles(
	vehicle_id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	type VARCHAR(200) NOT NULL,
	model VARCHAR(100) NOT NULL,
 	registration_number VARCHAR(200) UNIQUE NOT NULL,
	rental_price INT NOT NULL,
	status VARCHAR(20) NOT NULL DEFAULT 'available',

	CONSTRAINT check_price CHECK(rental_price>=0),
	CONSTRAINT check_type CHECK(type IN ('car', 'bike', 'truck','van', 'SUV')),
	CONSTRAINT check_availability CHECK(status IN ('available', 'rented', 'maintenance'))
);

CREATE TABLE IF NOT EXISTS bookings (
	booking_id SERIAL PRIMARY KEY,
	user_id INT NOT NULL REFERENCES users(user_id),
	vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	status VARCHAR(20) NOT NULL DEFAULT 'pending',
	total_cost INT NOT NULL,

	CONSTRAINT check_rent_dates CHECK (end_date >= start_date),
	CONSTRAINT check_total_price CHECK (total_cost >= 0),
	CONSTRAINT check_status CHECK (status IN ('completed', 'confirmed', 'pending', 'returned'))
);


-- Inserting data
INSERT INTO users (name, email, phone, role) VALUES
('Alice', 'alice@example.com', '1234567890', 'Customer'),
('Bob', 'bob@example.com', '0987654321', 'Admin'),
('Charlie', 'charlie@example.com', '1122334455', 'Customer');

INSERT INTO vehicles (name, type, model, registration_number, rental_price, status) VALUES
('Toyota Corolla', 'car', '2022', 'ABC-123', 50, 'available'),
('Honda Civic', 'car', '2021', 'DEF-456', 60, 'rented'),
('Yamaha R15', 'bike', '2023', 'GHI-789', 30, 'available'),
('Ford F-150', 'truck', '2020', 'JKL-012', 100, 'maintenance');

INSERT INTO bookings (user_id, vehicle_id, start_date, end_date, status, total_cost) VALUES
(1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
(1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
(3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
(1, 1, '2023-12-10', '2023-12-12', 'pending', 100);


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














