-- Insert sample data into weather_station
INSERT INTO weather_station (name, location, elevation, install_date) VALUES
('Downtown Station', 'New York, NY', 10.50, '2021-01-15'),
('Mountain View Station', 'Denver, CO', 1609.34, '2020-06-10'),
('Lakeside Station', 'Chicago, IL', 180.00, '2022-03-25');

-- Insert sample data into sensor_type
INSERT INTO sensor_type (name, unit) VALUES
('Temperature Sensor', 'Celsius'),
('Humidity Sensor', '%'),
('Pressure Sensor', 'hPa'),
('Wind Speed Sensor', 'km/h');

-- Insert sample data into sensor
INSERT INTO sensor (station_id, sensor_type_id, model, installed_on) VALUES
(1, 1, 'TempX1000', '2021-01-16'), -- Downtown - Temperature
(1, 2, 'HumidY2000', '2021-01-16'), -- Downtown - Humidity
(2, 1, 'TempX1000', '2020-06-11'), -- Mountain - Temperature
(2, 3, 'PressZ3000', '2020-06-11'), -- Mountain - Pressure
(3, 4, 'WindA4000', '2022-03-26'); -- Lakeside - Wind Speed

-- Insert sample data into reading
INSERT INTO reading (sensor_id, timestamp, value) VALUES
-- Readings for Downtown temperature sensor
(1, '2023-06-10 08:00:00', 24.50),
(1, '2023-06-10 12:00:00', 27.20),
(1, '2023-06-10 18:00:00', 25.10),
-- Readings for Downtown humidity sensor
(2, '2023-06-10 08:00:00', 60.00),
(2, '2023-06-10 12:00:00', 55.00),
-- Readings for Mountain View pressure sensor
(4, '2023-06-10 09:00:00', 1012.80),
(4, '2023-06-10 15:00:00', 1010.50),
-- Readings for Lakeside wind speed sensor
(5, '2023-06-10 10:00:00', 15.75),
(5, '2023-06-10 14:00:00', 18.50);
