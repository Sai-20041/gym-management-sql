CREATE DATABASE gym_db;
USE gym_db;
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    phone VARCHAR(15),
    join_date DATE
);
CREATE TABLE trainers (
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    specialty VARCHAR(100)
);
CREATE TABLE plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50),
    price DECIMAL(10,2),
    duration_months INT
);
CREATE TABLE subscriptions (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    plan_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);
INSERT INTO members (name, age, phone, join_date)
VALUES ('Sai', 22, '9876543210', CURDATE());

INSERT INTO trainers (name, specialty)
VALUES ('Ravi', 'Weight Training');

INSERT INTO plans (plan_name, price, duration_months)
VALUES ('Monthly', 2000, 1);
SELECT * FROM members WHERE age > 20;
SELECT m.name, t.name AS trainer, p.plan_name
FROM subscriptions s
JOIN members m ON s.member_id = m.member_id
JOIN trainers t ON s.trainer_id = t.trainer_id
JOIN plans p ON s.plan_id = p.plan_id;
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
SELECT member_id, SUM(amount) AS total_paid
FROM payments
GROUP BY member_id;
SELECT name FROM members
WHERE member_id IN (
    SELECT member_id FROM subscriptions
    WHERE end_date > CURDATE()
);
CREATE VIEW active_members_view AS
SELECT m.name, s.end_date
FROM members m
JOIN subscriptions s ON m.member_id = s.member_id
WHERE s.end_date > CURDATE();
SELECT * FROM active_members_view;
CREATE INDEX idx_member_name ON members(name);
DELIMITER //

CREATE PROCEDURE add_member(
    IN m_name VARCHAR(100),
    IN m_age INT,
    IN m_phone VARCHAR(15)
)
BEGIN
    INSERT INTO members(name, age, phone, join_date)
    VALUES (m_name, m_age, m_phone, CURDATE());
END //

DELIMITER ;
CALL add_member('Rahul', 25, '9999999999');
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
DELIMITER //

CREATE TRIGGER after_member_insert
AFTER INSERT ON members
FOR EACH ROW
BEGIN
    INSERT INTO attendance(member_id, date)
    VALUES (NEW.member_id, CURDATE());
END //

DELIMITER ;
START TRANSACTION;

INSERT INTO payments(member_id, amount, payment_date)
VALUES (1, 2000, CURDATE());

-- If success
COMMIT;

-- If error
ROLLBACK;

INSERT INTO members (name, age, phone, join_date)
VALUES 
('Sai', 22, '9876543210', CURDATE()),
('Ravi', 24, '9876543211', CURDATE()),
('Amit', 28, '9876543212', CURDATE());
SELECT * FROM members;
SELECT * FROM trainers;
SELECT * FROM plans;
SELECT m.name, t.name, p.plan_name
FROM subscriptions s
JOIN members m ON s.member_id = m.member_id
JOIN trainers t ON s.trainer_id = t.trainer_id
JOIN plans p ON s.plan_id = p.plan_id;
-- Active members
SELECT * FROM active_members_view;

-- Total payments
SELECT member_id, SUM(amount)
FROM payments
GROUP BY member_id;CALL add_member('Kiran', 23, '9999999999');

