CREATE DATABASE punemetrodb;
USE punemetrodb;

-- 1. Lines Table --
CREATE TABLE metrolines (
    lineid INT PRIMARY KEY AUTO_INCREMENT,
    linename VARCHAR(50) NOT NULL UNIQUE,
    colorcode VARCHAR(20) NOT NULL,
    originterminal VARCHAR(50) NOT NULL,
    destinationterminal VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'Operational' CHECK (status IN ('Operational', 'Under Construction', 'Planned'))
);

-- 2. Stations Table --
CREATE TABLE stations (
    stationid INT PRIMARY KEY,
    stationname VARCHAR(100) NOT NULL UNIQUE,
    stationtype VARCHAR(20) NOT NULL CHECK (stationtype IN ('Elevated', 'Underground')),
    isinterchange BOOLEAN DEFAULT FALSE
);

-- 3. Commuters (User profiles) --
CREATE TABLE commuters (
    commuterid INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(100) NOT NULL,
    phonenumber VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    registereddate DATE NOT NULL
);

-- 4. Route Stations (Line stop ordering & distance mapping) --
CREATE TABLE routestations (
    routeid INT PRIMARY KEY AUTO_INCREMENT,
    lineid INT NOT NULL,
    stationid INT NOT NULL,
    stopsequence INT NOT NULL,
    distancefromoriginkm DECIMAL(4,2) NOT NULL CHECK (distancefromoriginkm >= 0.00),
    FOREIGN KEY (lineid) REFERENCES metrolines(lineid) ON DELETE CASCADE,
    FOREIGN KEY (stationid) REFERENCES stations(stationid) ON DELETE CASCADE,
    UNIQUE (lineid, stopsequence),
    UNIQUE (lineid, stationid)
);

-- 5. Metro Cards --
CREATE TABLE metrocards (
    cardid VARCHAR(20) PRIMARY KEY,
    commuterid INT NOT NULL,
    cardtype VARCHAR(30) DEFAULT 'Maha Metro Card' CHECK (cardtype IN ('Maha Metro Card', 'Pune One Card', 'Student Pass Card')),
    balance DECIMAL(7,2) DEFAULT 0.00 CHECK (balance >= 0.00),
    isactive BOOLEAN DEFAULT TRUE,
    issueddate DATE NOT NULL,
    FOREIGN KEY (commuterid) REFERENCES commuters(commuterid) ON DELETE CASCADE
);

-- 6. Trips Table --
CREATE TABLE trips (
    tripid INT PRIMARY KEY AUTO_INCREMENT,
    cardid VARCHAR(20) NOT NULL,
    entrystationid INT NOT NULL,
    exitstationid INT NOT NULL,
    entrytime DATETIME NOT NULL,
    exittime DATETIME NOT NULL,
    fareamount DECIMAL(5,2) NOT NULL CHECK (fareamount >= 0.00),
    FOREIGN KEY (cardid) REFERENCES metrocards(cardid) ON DELETE CASCADE,
    FOREIGN KEY (entrystationid) REFERENCES stations(stationid),
    FOREIGN KEY (exitstationid) REFERENCES stations(stationid),
    CONSTRAINT chk_trip_times CHECK (exittime >= entrytime)
);
-- Populate Lines --
INSERT INTO metrolines (lineid, linename, colorcode, originterminal, destinationterminal, status) VALUES
(1, 'Purple Line', 'Purple', 'PCMC Bhavan', 'Swargate', 'Operational'),
(2, 'Aqua Line', 'Aqua', 'Vanaz', 'Ramwadi', 'Operational');

-- Populate Stations --
INSERT INTO stations (stationid, stationname, stationtype, isinterchange) VALUES
(101, 'PCMC Bhavan', 'Elevated', FALSE),
(108, 'Shivaji Nagar', 'Underground', FALSE),
(109, 'District Court Pune', 'Underground', TRUE),
(112, 'Swargate', 'Underground', FALSE),
(201, 'Vanaz', 'Elevated', FALSE),
(204, 'Nal Stop', 'Elevated', FALSE),
(209, 'Pune Railway Station', 'Elevated', FALSE),
(214, 'Ramwadi', 'Elevated', FALSE);

-- Populate Route Stations --
INSERT INTO routestations (lineid, stationid, stopsequence, distancefromoriginkm) VALUES
(1, 101, 1, 0.00),
(1, 108, 2, 11.60),
(1, 109, 3, 13.10),
(1, 112, 4, 16.80),
(2, 201, 1, 0.00),
(2, 204, 2, 3.20),
(2, 109, 3, 8.50),
(2, 209, 4, 9.70),
(2, 214, 5, 15.70);

-- Populate Commuters --
INSERT INTO commuters (commuterid, fullname, phonenumber, email, registereddate) VALUES
(1, 'Rohan Deshmukh', '9822011111', 'rohan.d@example.com', '2026-01-10'),
(2, 'Priya Kulkarni', '9822022222', 'priya.k@example.com', '2026-02-14'),
(3, 'Kunal Chauhan', '7666241119', 'kunal.k@example.com', '2026-04-20'),
(4, 'Pranav Shinde', '9595959595', 'pranav.k@example.com', '2026-04-29'),
(5, 'Adesh Ghogare', '9526262626', 'adesh.k@example.com', '2026-05-10'),
(6, 'Vinay Joshi', '7666241120', 'vinay.j@example.com', '2026-06-05'),
(7, 'Sanjay Patil', '9822033333', 'sanjay.p@example.com', '2026-06-18'),
(8, 'Ananya Bhosale', '9822044444', 'ananya.b@example.com', '2026-06-25'),
(9, 'Rahul Wagh', '9822055555', 'rahul.w@example.com', '2026-07-02'),
(10, 'Sneha Pawar', '9822066666', 'sneha.p@example.com', '2026-07-09'),
(11, 'Aditya Jadhav', '9822077777', 'aditya.j@example.com', '2026-07-15'),
(12, 'Neha Gaikwad', '9822088888', 'neha.g@example.com', '2026-07-22'),
(13, 'Omkar More', '9822099999', 'omkar.m@example.com', '2026-08-01'),
(14, 'Rutuja Salunkhe', '9822100000', 'rutuja.s@example.com', '2026-08-08'),
(15, 'Vivek Bhagat', '9822111111', 'vivek.b@example.com', '2026-08-14'),
(16, 'Pooja Kadam', '9822122222', 'pooja.k@example.com', '2026-08-20'),
(17, 'Siddharth Naik', '9822133333', 'siddharth.n@example.com', '2026-09-03'),
(18, 'Manasi Thorat', '9822144444', 'manasi.t@example.com', '2026-09-11');

-- Populate Metro Cards --
INSERT INTO metrocards (cardid, commuterid, cardtype, balance, isactive, issueddate) VALUES
('PUN-CARD-001', 1, 'Maha Metro Card', 420.00, TRUE, '2026-01-10'),
('PUN-CARD-002', 2, 'Pune One Card', 95.00, TRUE, '2026-02-14'),
('PUN-CARD-003', 3, 'Maha Metro Card', 185.00, TRUE, '2026-04-20'),
('PUN-CARD-004', 4, 'Student Pass Card', 70.00, TRUE, '2026-04-29'),
('PUN-CARD-005', 5, 'Pune One Card', 350.00, TRUE, '2026-05-10'),
('PUN-CARD-006', 6, 'Maha Metro Card', 45.00, FALSE, '2026-06-05'),
('PUN-CARD-007', 7, 'Pune One Card', 210.00, TRUE, '2026-06-18'),
('PUN-CARD-008', 8, 'Student Pass Card', 55.00, TRUE, '2026-06-25'),
('PUN-CARD-009', 9, 'Maha Metro Card', 300.00, TRUE, '2026-07-02'),
('PUN-CARD-010', 10, 'Pune One Card', 0.00, FALSE, '2026-07-09'),
('PUN-CARD-011', 11, 'Maha Metro Card', 125.00, TRUE, '2026-07-15'),
('PUN-CARD-012', 12, 'Student Pass Card', 80.00, TRUE, '2026-07-22'),
('PUN-CARD-013', 13, 'Pune One Card', 460.00, TRUE, '2026-08-01'),
('PUN-CARD-014', 14, 'Maha Metro Card', 15.00, FALSE, '2026-08-08'),
('PUN-CARD-015', 15, 'Pune One Card', 275.00, TRUE, '2026-08-14'),
('PUN-CARD-016', 16, 'Student Pass Card', 60.00, TRUE, '2026-08-20'),
('PUN-CARD-017', 17, 'Maha Metro Card', 500.00, TRUE, '2026-09-03'),
('PUN-CARD-018', 18, 'Pune One Card', 30.00, FALSE, '2026-09-11');

-- Populate Trips --
INSERT INTO trips (tripid, cardid, entrystationid, exitstationid, entrytime, exittime, fareamount) VALUES
(1001, 'PUN-CARD-001', 101, 109, '2026-03-10 08:30:00', '2026-03-10 08:58:00', 30.00),
(1002, 'PUN-CARD-002', 201, 209, '2026-03-10 09:15:00', '2026-03-10 09:40:00', 25.00),
(1003, 'PUN-CARD-003', 108, 112, '2026-03-11 11:00:00', '2026-03-11 11:18:00', 15.00),
(1004, 'PUN-CARD-001', 109, 101, '2026-03-11 18:30:00', '2026-03-11 18:57:00', 30.00);

-- QUESTIONS ON ABOVE DATABASE -- 
-- 1) Revenue and Rider Counts by Line --
SELECT 
    ml.linename,
    COUNT(t.tripid) AS total_trips,
    COUNT(DISTINCT m.commuterid) AS unique_riders,
    COALESCE(SUM(t.fareamount), 0.00) AS total_line_revenue,
    ROUND(AVG(t.fareamount), 2) AS avg_fare_per_trip
FROM metrolines ml
JOIN routestations rs ON ml.lineid = rs.lineid
JOIN trips t ON rs.stationid = t.entrystationid
JOIN metrocards m ON t.cardid = m.cardid
GROUP BY ml.lineid, ml.linename;


 -- 2) Total Money Spent per Commuter -- 
SELECT 
    c.fullname,
    m.cardid,
    COALESCE(SUM(t.fareamount), 0.00) AS total_spent
FROM commuters c
JOIN metrocards m ON c.commuterid = m.commuterid
LEFT JOIN trips t ON m.cardid = t.cardid
GROUP BY c.commuterid, c.fullname, m.cardid
ORDER BY total_spent DESC;


-- 3) SQL query joining trips, metrocards, and commuters that reports each trip's basic details alongside aggregate stats (AVG, COUNT, MAX, MIN) -- 
SELECT 
    t.tripid,
    t.cardid,
    c.commuterid,
    c.fullname,
    m.cardtype,
    t.fareamount,
    SUM(t.fareamount) OVER (ORDER BY t.fareamount DESC) AS running_fare_total,
    AVG(t.fareamount) AS avg_group_fare,
    COUNT(t.tripid) AS group_trip_count,
    MAX(t.fareamount) AS max_group_fare,
    MIN(t.fareamount) AS min_group_fare,
    SUM(t.fareamount) OVER (PARTITION BY m.cardtype) AS cardtype_total_revenue,
    AVG(t.fareamount) OVER (PARTITION BY c.commuterid) AS commuter_avg_fare,
    ROUND(t.fareamount * 100.0 / SUM(t.fareamount) OVER (), 2) AS pct_of_network_revenue
FROM trips t
JOIN metrocards m ON t.cardid = m.cardid
JOIN commuters c ON m.commuterid = c.commuterid
GROUP BY 
    t.tripid, 
    t.cardid, 
    c.commuterid, 
    c.fullname, 
    m.cardtype, 
    t.fareamount;
    
-- 4)Lines Exceeding Network Average Line Revenue --
SELECT 
    ml.linename,
    COUNT(t.tripid) AS total_trips,
    SUM(t.fareamount) AS total_revenue
FROM metrolines ml
JOIN routestations rs ON ml.lineid = rs.lineid
JOIN trips t ON rs.stationid = t.entrystationid
GROUP BY ml.lineid, ml.linename
HAVING SUM(t.fareamount) > (
    SELECT AVG(line_rev)
    FROM (
        SELECT SUM(t2.fareamount) AS line_rev
        FROM routestations rs2
        JOIN trips t2 ON rs2.stationid = t2.entrystationid
        GROUP BY rs2.lineid
        ) AS sub );  
        
-- 5) Travel Spend Tiers within Card Categories --
WITH CommuterSpend AS (
    SELECT 
        c.fullname,
        m.cardtype,
        COALESCE(SUM(t.fareamount), 0.00) AS total_spent
    FROM commuters c
    JOIN metrocards m ON c.commuterid = m.commuterid
    LEFT JOIN trips t ON m.cardid = t.cardid
    GROUP BY c.fullname, m.cardtype
)
SELECT 
    fullname,
    cardtype,
    total_spent,
    RANK() OVER (
        PARTITION BY cardtype 
        ORDER BY total_spent DESC
    ) AS spend_rank,
    DENSE_RANK() OVER (
        PARTITION BY cardtype 
        ORDER BY total_spent DESC
    ) AS spend_dense_rank
FROM CommuterSpend;

-- 6)Commuter Journey Pacing --
SELECT 
    c.fullname,
    t.cardid,
    t.entrytime,
    t.fareamount,
    SUM(t.fareamount) OVER (
        PARTITION BY t.cardid 
        ORDER BY t.entrytime 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_spent,
    ROUND(
        AVG(t.fareamount) OVER (
            PARTITION BY t.cardid 
            ORDER BY t.entrytime 
            ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
        ), 2
    ) AS two_trip_moving_avg
FROM trips t
JOIN metrocards m ON t.cardid = m.cardid
JOIN commuters c ON m.commuterid = c.commuterid;

-- 7) Card Type Financial Metrics Summary -- 
SELECT 
    cardtype,
    COUNT(cardid) AS total_cards,
    COUNT(CASE WHEN isactive = TRUE THEN 1 END) AS active_cards_count,
    SUM(balance) AS total_vault_balance,
    ROUND(AVG(balance), 2) AS average_balance,
    MIN(balance) AS lowest_balance,
    MAX(balance) AS highest_balance
FROM metrocards
GROUP BY cardtype;
 -- 8) Station Hop Distance on Purple Line --
 SELECT 
    rs.stopsequence,
    s.stationname,
    rs.distancefromoriginkm,
    LEAD(s.stationname) OVER (ORDER BY rs.stopsequence) AS next_station,
    ROUND(
        LEAD(rs.distancefromoriginkm) OVER (ORDER BY rs.stopsequence) - rs.distancefromoriginkm, 
        2
    ) AS hop_distance_km
FROM routestations rs
JOIN stations s ON rs.stationid = s.stationid
WHERE rs.lineid = 1
ORDER BY rs.stopsequence;


SELECT 
    c.commuterid,
    c.fullname,
    trip_summary.total_trips,
    trip_summary.total_spent,
    COALESCE(trip_summary.lines_used, 'None') AS lines_used
FROM commuters c
JOIN (
    -- Subquery: Pre-aggregate trip counts, fare totals, and line names per commuter
    SELECT 
        mc.commuterid,
        COUNT(t.tripid) AS total_trips,
        COALESCE(SUM(t.fareamount), 0.00) AS total_spent,
        GROUP_CONCAT(DISTINCT ml.linename ORDER BY ml.linename SEPARATOR ', ') AS lines_used
    FROM metrocards mc
    LEFT JOIN trips t ON mc.cardid = t.cardid
    LEFT JOIN metrolines ml ON 
        t.entrystationid IN (SELECT rs.stationid FROM routestations rs WHERE rs.lineid = ml.lineid)
        AND 
        t.exitstationid IN (SELECT rs.stationid FROM routestations rs WHERE rs.lineid = ml.lineid)
    GROUP BY mc.commuterid
) AS trip_summary ON c.commuterid = trip_summary.commuterid;