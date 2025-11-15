-- Create books table
CREATE TABLE IF NOT EXISTS books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    user_id INT NOT NULL
);

-- Insert data into books table
INSERT INTO books (id, name, date, user_id) VALUES
(1, 'Bachelor of Information Systems', '2019-01-01', 1),
(2, 'Bachelor of Design', '2019-02-02', 2),
(3, 'Bachelor of Commerce', '2019-03-03', 3),
(4, 'Associate Degree in Health Science', '2019-04-04', 3),
(5, 'Master of Architectural Technology', '2019-05-05', 2),
(6, 'Bachelor of Psychology', '2019-06-06', 2),
(7, 'Associate Degree in Information Systems', '2019-07-07', 1);

-- Verify the data
SELECT * FROM books ORDER BY id;

-- Query to get the latest book (based on date) for each user
-- Method 1: Using window function (MySQL 8.0+)
SELECT 
    u.name,
    b.name AS book_name,
    DATE_FORMAT(b.date, '%d-%m-%Y') AS date
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date DESC) AS rn
    FROM books
) b
INNER JOIN users u ON b.user_id = u.id
WHERE b.rn = 1
ORDER BY u.name;

-- Method 2: Using correlated subquery (works in all MySQL versions)
SELECT 
    u.name,
    b.name AS book_name,
    DATE_FORMAT(b.date, '%d-%m-%Y') AS date
FROM books b
INNER JOIN users u ON b.user_id = u.id
WHERE b.date = (
    SELECT MAX(b2.date)
    FROM books b2
    WHERE b2.user_id = b.user_id
)
ORDER BY u.name;

-- Method 3: Using self-join (works in all MySQL versions)
SELECT 
    u.name,
    b.name AS book_name,
    DATE_FORMAT(b.date, '%d-%m-%Y') AS date
FROM books b
INNER JOIN users u ON b.user_id = u.id
INNER JOIN (
    SELECT user_id, MAX(date) AS max_date
    FROM books
    GROUP BY user_id
) latest ON b.user_id = latest.user_id AND b.date = latest.max_date
ORDER BY u.name;

