-- Use the database
USE baraa_projects;

-- Drop existing table if needed
DROP TABLE IF EXISTS hotel_bookings;

-- Create main hotel_bookings table
CREATE TABLE hotel_bookings (
  hotel VARCHAR(50),
  is_canceled INT,
  lead_time INT,
  arrival_date_year INT,
  arrival_date_month VARCHAR(20),
  arrival_date_week_number INT,
  arrival_date_day_of_month INT,
  stays_in_weekend_nights INT,
  stays_in_week_nights INT,
  adults INT,
  children INT,
  babies INT,
  meal VARCHAR(50),
  country VARCHAR(10),
  market_segment VARCHAR(50),
  distribution_channel VARCHAR(50),
  is_repeated_guest INT,
  previous_cancellations INT,
  previous_bookings_not_canceled INT,
  reserved_room_type VARCHAR(5),
  assigned_room_type VARCHAR(5),
  booking_changes INT,
  deposit_type VARCHAR(20),
  agent VARCHAR(20),
  company VARCHAR(20),
  days_in_waiting_list INT,
  customer_type VARCHAR(50),
  adr FLOAT,
  required_car_parking_spaces INT,
  total_of_special_requests INT,
  reservation_status VARCHAR(20),
  reservation_status_date VARCHAR(20) -- to be converted to DATE
);

-- Load data from CSV file
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hotel_bookings.csv'
INTO TABLE hotel_bookings
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
IGNORE 1 ROWS
(hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month,
 arrival_date_week_number, arrival_date_day_of_month, stays_in_weekend_nights,
 stays_in_week_nights, adults, @children, @babies, meal, country, market_segment,
 distribution_channel, is_repeated_guest, previous_cancellations,
 previous_bookings_not_canceled, reserved_room_type, assigned_room_type,
 booking_changes, deposit_type, agent, company, days_in_waiting_list,
 customer_type, adr, required_car_parking_spaces, total_of_special_requests,
 reservation_status, reservation_status_date)
SET children = NULLIF(@children, 'NA'),
    babies = NULLIF(@babies, 'BB');

-- Data quality checks and cleaning
DELETE FROM hotel_bookings WHERE adr > 1000 OR adr < 0;
DELETE FROM hotel_bookings WHERE babies = 10 OR children = 10;

UPDATE hotel_bookings SET children = 0 WHERE children IS NULL;
UPDATE hotel_bookings SET country = 'Unknown' WHERE country IS NULL;
UPDATE hotel_bookings SET agent = 'Unknown' WHERE agent IS NULL;

-- Drop 'company' column if not needed
ALTER TABLE hotel_bookings DROP COLUMN company;

-- Convert reservation_status_date to proper DATE format
ALTER TABLE hotel_bookings ADD COLUMN reservation_status_dt DATE;
UPDATE hotel_bookings SET reservation_status_dt = STR_TO_DATE(reservation_status_date, '%c/%e/%Y');
ALTER TABLE hotel_bookings DROP COLUMN reservation_status_date;
ALTER TABLE hotel_bookings CHANGE COLUMN reservation_status_dt reservation_status_date DATE;

-- Create 'arrival_date' column from year, month, and day
ALTER TABLE hotel_bookings ADD arrival_date DATE;
UPDATE hotel_bookings
SET arrival_date = STR_TO_DATE(CONCAT(arrival_date_year, '-', arrival_date_month, '-', arrival_date_day_of_month), '%Y-%M-%d');
ALTER TABLE hotel_bookings 
DROP COLUMN arrival_date_year,
DROP COLUMN arrival_date_month,
DROP COLUMN arrival_date_day_of_month;

-- Normalization for hotel
CREATE TABLE hotel (
  hotel_id INT AUTO_INCREMENT PRIMARY KEY,
  hotel_name VARCHAR(40)
);
INSERT INTO hotel(hotel_name) SELECT DISTINCT hotel FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD hotel_id INT;
UPDATE hotel_bookings SET hotel_id = 1 WHERE hotel = 'Resort Hotel';
UPDATE hotel_bookings SET hotel_id = 2 WHERE hotel = 'City Hotel';
ALTER TABLE hotel_bookings DROP COLUMN hotel;

-- Normalize meal
CREATE TABLE meal_table (
  meal_id_meal_table INT AUTO_INCREMENT PRIMARY KEY,
  meal_name VARCHAR(20)
);
INSERT INTO meal_table(meal_name) SELECT DISTINCT meal FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD meal_id INT;
UPDATE hotel_bookings hb
JOIN meal_table m ON hb.meal = m.meal_name
SET meal_id = meal_id_meal_table;
ALTER TABLE hotel_bookings DROP COLUMN meal;

-- Normalize market_segment
CREATE TABLE market (
  market_id INT AUTO_INCREMENT PRIMARY KEY,
  market_name VARCHAR(40)
);
INSERT INTO market(market_name) SELECT DISTINCT market_segment FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD market_id INT;
UPDATE hotel_bookings h
JOIN market m ON h.market_segment = m.market_name
SET h.market_id = m.market_id;
ALTER TABLE hotel_bookings DROP COLUMN market_segment;

-- Normalize country
CREATE TABLE country_name (
  country_id INT AUTO_INCREMENT PRIMARY KEY,
  country_names VARCHAR(40)
);
INSERT INTO country_name(country_names) SELECT DISTINCT country FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD country_id INT;
UPDATE hotel_bookings h
JOIN country_name c ON h.country = c.country_names
SET h.country_id = c.country_id;
ALTER TABLE hotel_bookings DROP COLUMN country;

-- Normalize customer_type
CREATE TABLE type_of_customers (
  customer_type_id INT AUTO_INCREMENT PRIMARY KEY,
  types_of_customers VARCHAR(40)
);
INSERT INTO type_of_customers(types_of_customers) SELECT DISTINCT customer_type FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD customer_type_id INT;
UPDATE hotel_bookings h
JOIN type_of_customers t ON h.customer_type = t.types_of_customers
SET h.customer_type_id = t.customer_type_id;
ALTER TABLE hotel_bookings DROP COLUMN customer_type;

-- Normalize distribution_channel
CREATE TABLE distribution_channels (
  distribution_channel_id INT AUTO_INCREMENT PRIMARY KEY,
  distribution_channel_name VARCHAR(40)
);
INSERT INTO distribution_channels(distribution_channel_name) SELECT DISTINCT distribution_channel FROM hotel_bookings;
ALTER TABLE hotel_bookings ADD distribution_channel_id INT;
UPDATE hotel_bookings h
JOIN distribution_channels t ON h.distribution_channel = t.distribution_channel_name
SET h.distribution_channel_id = t.distribution_channel_id;
ALTER TABLE hotel_bookings DROP COLUMN distribution_channel;
