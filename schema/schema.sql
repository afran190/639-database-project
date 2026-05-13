CREATE DATABASE weatherlog CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE weatherlog;

CREATE TABLE weather_station (
  station_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(100),
  elevation DECIMAL(6,2), -- in meters
  install_date DATE
);

CREATE TABLE sensor_type (
  sensor_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,  
  unit VARCHAR(20)  
);

CREATE TABLE sensor (
  sensor_id INT AUTO_INCREMENT PRIMARY KEY,
  station_id INT NOT NULL,
  sensor_type_id INT NOT NULL,
  model VARCHAR(100),
  installed_on DATE,
  FOREIGN KEY (station_id) REFERENCES weather_station(station_id),
  FOREIGN KEY (sensor_type_id) REFERENCES sensor_type(sensor_type_id)
);

CREATE TABLE reading (
  reading_id INT AUTO_INCREMENT PRIMARY KEY,
  sensor_id INT NOT NULL,
  timestamp DATETIME NOT NULL,
  value DECIMAL(8,2) NOT NULL,
  FOREIGN KEY (sensor_id) REFERENCES sensor(sensor_id)
);

