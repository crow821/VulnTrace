CREATE DATABASE IF NOT EXISTS vulntarce;
USE vulntarce;

CREATE TABLE IF NOT EXISTS users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50),
  email VARCHAR(100)
);

INSERT INTO users (username, email) VALUES
('admin', 'admin@example.com'),
('vulntrace', 'vulntrace@example.com'),
('vuln', 'vuln@example.com');
