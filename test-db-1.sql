-- MySQL query to get users grouped by mark with individual and combined counts
-- This query shows:
-- 1. Individual marks (A, B, C) with their counts
-- 2. Combined marks (A+B, A+C, B+C) with their counts

SELECT 
    mark,
    COUNT(*) as count
FROM users
GROUP BY mark

UNION ALL
SELECT 
    'A+B' as mark,
    COUNT(*) as count
FROM users
WHERE mark IN ('A', 'B')

UNION ALL
SELECT 
    'A+C' as mark,
    COUNT(*) as count
FROM users
WHERE mark IN ('A', 'C')

UNION ALL
SELECT 
    'B+C' as mark,
    COUNT(*) as count
FROM users
WHERE mark IN ('B', 'C')


UNION ALL
SELECT 
    'A+B+C' as mark,
    COUNT(*) as count
FROM users
WHERE mark IN ('A', 'B', 'C')