-- 1. List all weather stations with basic details
SELECT station_id, name, location, elevation, install_date
FROM weather_station;

-- 2. Show all sensors installed at each weather station with associated sensor type
SELECT ws.name AS station_name, s.sensor_id, st.name AS sensor_type, s.model, s.installed_on
FROM sensor s
JOIN weather_station ws ON s.station_id = ws.station_id
JOIN sensor_type st ON s.sensor_type_id = st.sensor_type_id
ORDER BY ws.name, st.name;

-- 3. Get the latest reading timestamp for each sensor
SELECT r.sensor_id, MAX(r.timestamp) AS latest_timestamp
FROM reading r
GROUP BY r.sensor_id;

-- 4. Get all readings for a specific sensor (sensor_id = 1), ordered by time
SELECT timestamp, value
FROM reading
WHERE sensor_id = 1
ORDER BY timestamp;

-- 5. Average temperature by station
SELECT ws.name AS station_name, AVG(r.value) AS avg_temperature
FROM reading r
JOIN sensor s ON r.sensor_id = s.sensor_id
JOIN sensor_type st ON s.sensor_type_id = st.sensor_type_id
JOIN weather_station ws ON s.station_id = ws.station_id
WHERE st.name = 'Temperature Sensor'
GROUP BY ws.station_id;

-- 6. Total number of sensors installed per station
SELECT ws.name AS station_name, COUNT(s.sensor_id) AS sensor_count
FROM weather_station ws
LEFT JOIN sensor s ON s.station_id = ws.station_id
GROUP BY ws.station_id;

-- 7. Find sensors that have not recorded any readings
SELECT s.sensor_id, st.name AS sensor_type, ws.name AS station_name
FROM sensor s
JOIN sensor_type st ON s.sensor_type_id = st.sensor_type_id
JOIN weather_station ws ON s.station_id = ws.station_id
LEFT JOIN reading r ON s.sensor_id = r.sensor_id
WHERE r.reading_id IS NULL;

-- 8. Daily average reading per sensor for temperature sensors
SELECT s.sensor_id, DATE(r.timestamp) AS reading_date, AVG(r.value) AS avg_value
FROM reading r
JOIN sensor s ON r.sensor_id = s.sensor_id
JOIN sensor_type st ON s.sensor_type_id = st.sensor_type_id
WHERE st.name = 'Temperature Sensor'
GROUP BY s.sensor_id, DATE(r.timestamp)
ORDER BY s.sensor_id, reading_date;

-- 9. Find the highest value ever recorded for each sensor type
SELECT st.name AS sensor_type, MAX(r.value) AS max_value
FROM reading r
JOIN sensor s ON r.sensor_id = s.sensor_id
JOIN sensor_type st ON s.sensor_type_id = st.sensor_type_id
GROUP BY st.sensor_type_id;
