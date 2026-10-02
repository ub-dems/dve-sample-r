-- demo: template project demo/test database

CREATE DATABASE demo;


CREATE USER 'demo'@'localhost' IDENTIFIED BY '<Sec3et!>';


GRANT ALL PRIVILEGES ON demo.* TO 'demo'@'localhost';
