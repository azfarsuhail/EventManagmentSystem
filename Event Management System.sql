-- DROP DATABASE EVENTS;

CREATE DATABASE IF NOT EXISTS Events;
USE Events;

CREATE TABLE IF NOT EXISTS Location (
    LocationID INT PRIMARY KEY,
    VenueName VARCHAR(150),
    Address VARCHAR(200),
    City VARCHAR(50),
    Country VARCHAR(50),
    Capacity INT
);

CREATE TABLE IF NOT EXISTS Organizer (
    OrganizerID INT PRIMARY KEY,
    OrganizerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    TotalEvent INT
);

CREATE TABLE IF NOT EXISTS Host (
    HostID INT PRIMARY KEY,
    HostName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS Event (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    LocationID INT,
    OrganizerID INT,
    FOREIGN KEY(LocationID) REFERENCES Location(LocationID),
    FOREIGN KEY(OrganizerID) REFERENCES Organizer(OrganizerID)
);

CREATE TABLE IF NOT EXISTS Registration (
    RegistrationID INT auto_increment PRIMARY KEY,
    EventID INT,
    HostID INT,
    RegistrationDate DATE,
    TicketType VARCHAR(100),
    PaymentStatus VARCHAR(100),
    PaymentAmount INT,
    FOREIGN KEY(EventID) REFERENCES Event(EventID),
    FOREIGN KEY(HostID) REFERENCES Host(HostID)
);

INSERT INTO Location (LocationID, VenueName, Address, City, Country, Capacity) VALUES
(1, 'PC hotel', 'II. Chandigarh Road', 'Karachi', 'Pakistan', 150),
(2, 'IN-Door', 'Bahadurabad', 'Karachi', 'Pakistan', 250),
(3, 'Beach luxury', 'Port Grand', 'Karachi', 'Pakistan', 100),
(4, 'Movenpick', 'II. Chandigarh Road', 'Karachi', 'Pakistan', 2000),
(5, 'Turtle Beach', 'Hawkes Bay Road', 'Karachi', 'Pakistan', 1500);

INSERT INTO Organizer (OrganizerID, OrganizerName, Email, Phone, TotalEvent) VALUES
(1, 'Mir Omer', 'mir.omer@gmail.com', '0332-2233452', 1),
(2, 'Raza Ali', 'razaali@gmail.com', '0321-55667789', 1),
(3, 'Aayla', 'aayla@gmail.com', '0343-12741919', 1),
(4, 'Farhan Badshah', 'farhan@gmail.com', '0334-92661514', 1),
(5, 'Hina Ali', 'hina.ali@gmail.com', '0321-33456899', 1);

INSERT INTO Host (HostID, HostName, Email, Phone) VALUES
(1, 'Eisha', 'eisha@gmail.com', '0984-45627812'),
(2, 'Kazim', 'kazim@gmail.com', '0334-67589221'),
(3, 'Hammad', 'hammad@gmail.com', '0321-45632189'),
(4, 'Tajdar', 'tajdar@gmail.com', '0334-447890044'),
(5, 'Alamzab', 'alam@gmail.com', '0943-489003315');

INSERT INTO Event (EventName, StartDate, EndDate, LocationID, OrganizerID) 
VALUES 
    ('Conference', '2024-08-20', '2024-08-22', 1, 1),
    ('Workshop', '2024-09-10', '2024-09-12', 2, 2),
    ('Seminar', '2024-10-15', '2024-10-16', 3, 3),
    ('Exhibition', '2024-11-05', '2024-11-07', 4, 4),
    ('Gala Dinner', '2024-12-20', '2024-12-20', 5, 5);
    
INSERT INTO Registration (EventID, HostID, RegistrationDate, TicketType, PaymentStatus, PaymentAmount)
VALUES 
    (1, 1, '2024-08-15', 'VIP', 'paid', 500),
    (1, 2, '2024-08-16', 'Regular', 'unpaid', 0),
    (2, 3, '2024-09-01', 'General Admission', 'paid', 200),
    (3, 4, '2024-10-10', 'Student', 'unpaid', 0),
    (4, 5, '2024-11-01', 'VIP', 'paid', 1000);


    
-- Trigger to update total event count for an organizer after inserting an event
DELIMITER //
CREATE TRIGGER update_total_event_count
AFTER INSERT ON Event
FOR EACH ROW
BEGIN
    UPDATE Organizer
    SET TotalEvent = TotalEvent + 1
    WHERE OrganizerID = NEW.OrganizerID;
END;
//
DELIMITER ;

-- Procedure to get events by organizer
DELIMITER //
CREATE PROCEDURE get_events_by_organizer(IN organizer_id INT)
BEGIN
    SELECT *
    FROM Event
    WHERE OrganizerID = organizer_id;
END;
//
DELIMITER ;


-- Procedure to register for an event
DELIMITER //
CREATE PROCEDURE register_for_event(
    IN event_id INT, 
    IN host_id INT, 
    IN registration_date DATE, 
    IN ticket_type VARCHAR(100), 
    IN payment_status VARCHAR(100), 
    IN payment_amount INT
)
BEGIN
    INSERT INTO Registration (EventID, HostID, RegistrationDate, TicketType, PaymentStatus, PaymentAmount)
    VALUES (event_id, host_id, registration_date, ticket_type, payment_status, payment_amount);
END;
//
DELIMITER ;

CREATE VIEW Event_Details AS
SELECT
    e.EventID,
    e.EventName,
    e.StartDate,
    e.EndDate,
    l.VenueName,
    o.OrganizerName,
    COUNT(r.RegistrationID) AS TotalRegistrations
FROM
    Event e
    JOIN Location l ON e.LocationID = l.LocationID
    JOIN Organizer o ON e.OrganizerID = o.OrganizerID
    LEFT JOIN Registration r ON e.EventID = r.EventID
GROUP BY
    e.EventID;


CREATE VIEW Registration_Summary AS
SELECT
    e.EventName,
    r.RegistrationDate,
    r.TicketType,
    r.PaymentStatus,
    r.PaymentAmount
FROM
    Registration r
    JOIN Event e ON r.EventID = e.EventID;



