CREATE DATABASE KINDER;
USE KINDER;
CREATE TABLE student_info
(name varchar(50) NOT NULL,
date_of_birth  date NOT NULL,
primary_lang varchar(20) NOT NULL,
secondary_lang varchar(20) NOT NULL,
student_id char(4) NOT NULL,
PRIMARY KEY (student_id) );

CREATE TABLE attendance
( student_id char(4) NOT NULL,
date date NOT NULL,
absent_type boolean NOT NULL);

CREATE TABLE health 
( student_id CHAR (4)  NOT NULL,
gender CHAR(1) NOT NULL,
height INT NOT NULL,
weight INT NOT NULL,
immunizations CHAR(1) NOT NULL,
allergies VARCHAR(50) NOT NULL,
FOREIGN KEY (student_id) REFERENCES student_info(student_id));
DROP TABLE health;

INSERT INTO emergency_contacts
(student_id,name,relationship,primary_phone,secondary_phone,email)
VALUES
('1165','Morgan Shanks','Mom','(214)370-6516','(214)399-0326','MShanks@gmail.com'),
('1857','Louse Lane','Mom','(972)936-1998','' ,'LLane@gmail.com');


SELECT * FROM emergency_contacts;
DROP TABLE emergency_contacts;

CREATE TABLE emergency_contacts
( student_id CHAR(4) NOT NULL,
name VARCHAR(30) NOT NULL,
relationship VARCHAR(30) NOT NULL,
primary_phone CHAR(14) NOT NULL,
secondary_phone CHAR(14) NOT NULL,
Email VARCHAR(50) NOT NULL,
FOREIGN KEY (student_id) REFERENCES student_info(student_id));

DROP TABLE health;

CREATE TABLE health 
( student_id CHAR (4) NOT NULL,
gender CHAR(1) NOT NULL,
height INT NOT NULL,
weight INT NOT NULL,
immunizations CHAR(1) NOT NULL,
allergies VARCHAR(50) NULL,
FOREIGN KEY (student_id) REFERENCES student_info(student_id));


SELECT *
FROM attendance
ORDER BY absent_type DESC;


SELECT COUNT(*)
FROM after_care
WHERE transportation = "Bus" AND type_of_care = "Home"; 

SELECT AVG(weight)
FROM health
WHERE gender = 'M';

SELECT student_id, transportation, type_of_care
FROM after_care
WHERE student_id in ( 
	SELECT student_id
	FROM health
	WHERE gender = 'F');

SELECT s.student_id, s.name, a.absent_date, a.absent_type 
FROM student_info AS s
INNER JOIN attendance AS a
ON s.student_id = a.student_id;

SELECT s.student_id, s.secondary_lang, a.absent_date, a.absent_type
FROM student_info AS s
RIGHT JOIN attendance AS a
ON s.student_id = a.student_id;

CREATE VIEW absent_stu_name	AS 												
SELECT s.student_id, s.name, a.absent_date, a.absent_type 
FROM student_info AS s
INNER JOIN attendance AS a
ON s.student_id = a.student_id;


SELECT name 
FROM student_info
UNION
SELECT name 
FROM emergency_contacts;


DELIMITER $$

CREATE FUNCTION Absence (
	Absence_level INT
) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Absence VARCHAR(20);

    IF Absence_level > 0 AND 
		Absence_level < 5 THEN
		SET Absence = 'Send Note Home';
    ELSEIF (Absence_level >= 5 AND 
			Absence_level <= 10 ) THEN
        SET Absence = 'Warning';
    ELSEIF Absence_level < 10 THEN
        SET Absence = 'Truancy Notification';
    END IF;
	RETURN (Absence);
END$$
DELIMITER ;

SELECT student_id, COUNT(*) AS Number_Absence, 
Absence(COUNT(*)) as level
FROM attendance
GROUP BY student_id;

DELIMITER //

CREATE PROCEDURE Count_Absence ()
BEGIN
	SELECT COUNT(*), student_id
FROM attendance
GROUP BY student_id;
END //
DELIMITER ;

CALL Count_Absence();

