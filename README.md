# Hotel-Reservation-Database-Design

## Project Overview

This is the Group No.7 project assignment for the **CDS522 - Business Data Management** course, aiming to design and implement a hotel reservation database system similar to Booking.com. The system supports user registration, accommodation search, booking management, review feedback, and promotional activities. The goal is to build an efficient, secure, and user-friendly database architecture capable of handling high concurrency while maintaining data consistency and integrity.

**Keywords**: ER Diagram, Database Model, SQL, Data Management, Hotel Reservation

---

## Project Background and Motivation

With the booming global tourism industry, the demand for online hotel reservations is increasing. Booking.com, as a leading global accommodation booking platform, is an ideal case study due to its user-friendly interface and rich features. This project analyzes its business requirements to design a database system that supports the following target users:

- **Leisure Travelers**: Individuals or families seeking vacation accommodations.
- **Business Travelers**: Professionals needing convenient accommodations.
- **Budget Travelers**: People looking for economical accommodations such as hostels or budget hotels.

---

## System Features

The hotel reservation database system provides the following core features:

1. **User Registration and Management**: Users can create accounts and manage personal information.
2. **Accommodation Search**: Search for available accommodations based on destination, check-in date, and preferences.
3. **Booking Process**: Users select accommodations, complete bookings, and make payments.
4. **User Reviews**: Users can rate and comment on hotels after their stay.
5. **Promotion Management**: Offer discounts and promotional activities to enhance user experience.
6. **Permission Control**: Role-Based Access Control (RBAC) to manage permissions for different user roles.
7. **Data Query and Analysis**: Support administrators in data querying and visual analysis.

---

## Database Design

### Conceptual Model (ER Diagram)

The ER diagram of the system includes the following main entities and their relationships:

- **Users**: User information (`Users_id`, `Users_name`, `Passwords`, `Mailbox`, `PhoneNum`, `Payment_info`, `Addr`).  
  - Relationship: Many-to-one with `Permission`.
- **Hotel**: Hotel information (`Hotel_id`, `Hotel_name`, `Hotel_star`, `Hotel_Addr`, `Facilities`).  
  - Relationships: Many-to-one with `City`, one-to-many with `Pictures` and `Room`.
- **Room**: Room information (`Room_id`, `Hotel_id`, `Room_name`, `Bedtype`, `Capacity`, `Price`, `Area`, `Descriptions`, `Total_count`).  
  - Relationship: Many-to-one with `Hotel`.
- **Orders**: Order information (`Orders_id`, `Create_day`, `Payment_day`, `Hotel_id`, `Users_id`, `Progress`, `Discount_id`).  
  - Relationships: One-to-many with `Users`, many-to-one with `Hotel` and `Promotion`.
- **OrderDetail**: Order details (`Checkindate`, `Checkoutdate`, `Orders_id`, `Room_id`, `Counts`).  
  - Relationships: Many-to-one with `Orders` and `Room`.
- **Review**: User reviews (`Review_id`, `Rating`, `Comment_content`, `Users_id`, `Hotel_id`).  
  - Relationships: One-to-many with `Users`, many-to-one with `Hotel`.
- **Promotion**: Promotion information (`Discount_ID`, `Descriptions`, `Start_time`, `End_time`, `DisPercent`).  
  - Relationship: One-to-many with `Orders`.
- **City**: City information (`City_id`, `City_name`).
- **Pictures**: Hotel pictures (`Image_id`, `Hotel_id`, `Image_address`, `Image_desc`).

### Database Table Structure

Below are the DDL definitions for the main tables:

```sql
CREATE TABLE City (
    City_id INT NOT NULL,
    City_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (City_id)
);

CREATE TABLE Hotel (
    Hotel_id INT NOT NULL,
    Hotel_name VARCHAR(100) NOT NULL,
    Hotel_star INT NOT NULL,
    Hotel_Addr VARCHAR(100) NOT NULL,
    Facilities VARCHAR(50),
    City_id INT NOT NULL,
    PRIMARY KEY (Hotel_id),
    FOREIGN KEY (City_id) REFERENCES City(City_id)
);

CREATE TABLE Room (
    Room_id INT NOT NULL,
    Hotel_id INT NOT NULL,
    Room_name VARCHAR(50) NOT NULL,
    Bedtype VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    Price INT NOT NULL,
    Area DECIMAL(10,2) NOT NULL,
    Descriptions VARCHAR(255),
    Total_count INT NOT NULL,
    PRIMARY KEY (Room_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id)
);

CREATE TABLE Orders (
    Orders_id INT NOT NULL,
    Create_day DATETIME NOT NULL,
    Payment_day DATETIME NOT NULL,
    Hotel_id INT NOT NULL,
    Users_id INT NOT NULL,
    Progress VARCHAR(50) NOT NULL,
    Discount_id INT,
    PRIMARY KEY (Orders_id),
    FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id),
    FOREIGN KEY (Users_id) REFERENCES Users(Users_id),
    FOREIGN KEY (Discount_id) REFERENCES Promotion(Discount_id)
);
```

(For the complete table structure, please refer to the project documentation)

### Data Consistency and Integrity

- **Primary and Foreign Keys**: Ensure clear relationships between entities and avoid data redundancy.
- **3NF Normalization**: Eliminate partial dependencies of non-key attributes on the primary key to enhance data consistency.
- **Transaction Management**: Ensure data reliability under high concurrency through the ACID properties of the DBMS.

---

## Data Operations and Queries

### Sample Data Insertion

```sql
INSERT INTO City (City_id, City_name) VALUES (1, 'Beijing');
INSERT INTO Hotel (Hotel_id, Hotel_name, Hotel_star, Hotel_Addr, Facilities, City_id) 
VALUES (1, 'Beijing International', 5, 'No.1 Chaoyangmen Outer Street, Beijing', 'Pool, Gym, Spa', 1);
INSERT INTO Room (Room_id, Hotel_id, Room_name, Bedtype, Capacity, Price, Area, Descriptions, Total_count) 
VALUES (1, 1, 'Deluxe King', 'King', 2, 1500, 35, 'Deluxe room with king bed', 22);
```

### Sample Queries

1. **Query all five-star hotels**:
   ```sql
   SELECT Hotel_name
   FROM Hotel
   WHERE Hotel_star = 5;
   ```
   **Result** (partial):
   - Beijing International
   - Shanghai Peninsula
   - Shenzhen View Hotel

2. **Query canceled orders**:
   ```sql
   SELECT Orders_id, Hotel_id, Users_id
   FROM Orders
   WHERE Progress = 'canceled';
   ```

3. **Query the top three most expensive rooms in each hotel**:
   ```sql
   SELECT hotel_name, room_name, bedtype, price
   FROM (
       SELECT h.hotel_name, r.room_name, r.bedtype, r.price,
              RANK() OVER (PARTITION BY h.hotel_name ORDER BY r.price DESC) posn
       FROM Hotel h JOIN Room r ON h.hotel_id = r.hotel_id
   ) AS rk
   WHERE rk.posn <= 3;
   ```

---

## Data Visualization

Using **Tableau** for data visualization analysis, examples include:

- **Hotel Order Completion Rate**: Displays the order completion status of each hotel.
- **User Order Ranking**: Identifies loyal customers.
- **Total Consumption Analysis**: Analyzes user spending behavior.

**Example - Hotel Order Completion Rate**:
| Hotel_name            | Finished Orders | Total Orders | Finished Rate |
|-----------------------|-----------------|--------------|---------------|
| Wuhan Riverside       | 6               | 6            | 100.00%       |
| Shanghai Peninsula    | 6               | 6            | 100.00%       |
| Xi'an Ancient         | 19              | 21           | 90.48%        |

---

## Technology Stack

- **DBMS**: Not specified, but the design supports MySQL, PostgreSQL, etc.
- **SQL**: Used for DDL, DML, and query implementation.
- **Visualization Tool**: Tableau.

---

## Project File Structure

```
Hotel-Reservation-Database/
├── docs/
│   ├── Hotel_ER_Diagram.png      # ER Diagram
│   └── Project_Report.pdf        # Full Project Report
├── sql/
│   ├── create_tables.sql         # DDL Script
│   ├── insert_data.sql           # DML Data Insertion Script
│   └── queries.sql               # Sample Query Script
├── visualization/
│   └── tableau_dashboards/       # Tableau Visualization Files
└── README.md                     # This File
```

---

## Future Prospects

- **Enhanced Data Analysis**: Integrate machine learning to provide personalized recommendations.
- **Data Security**: Adopt advanced encryption technologies and comply with data protection regulations.
- **Permission Control**: Implement more complex Attribute-Based Access Control (ABAC) and real-time auditing.

---
