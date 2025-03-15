CREATE TABLE City (
  City_id INT NOT NULL,
  City_name VARCHAR(50) NOT NULL,
  PRIMARY KEY  (City_id),
);


CREATE TABLE Hotel (
  Hotel_id int NOT NULL ,
  Hotel_name VARCHAR(100) NOT NULL,
  Hotel_star int NOT NULL,
  Hotel_Addr varchar(100) NOT NULL,
  Facilities varchar(50),
  City_id int not null,
  PRIMARY KEY (hotel_id),
  FOREIGN KEY (City_id) REFERENCES City(City_id),
  );


CREATE TABLE Pictures(
	Image_id int not null,
	Hotel_id int not null,
	Image_address varchar(50) not null,
	Image_desc varchar(255),
	PRIMARY KEY (Image_id),
	FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id),
	);


CREATE TABLE Room (
  Room_id int NOT NULL,
  Hotel_id int not null,
  Room_name VARCHAR(50) NOT NULL,
  Bedtype VARCHAR(50) not NULL,
  Capacity int NOT NULL,
  Price int not null,
  Area decimal(10,2)  NOT NULL,
  Descriptions varchar(255),
  Total_count int not null,
  PRIMARY KEY  (Room_id),
  FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id),
);


Create Table Permission (
	Permission_id int not null,
	Permission_desc varchar(100) not null,
	Primary key (Permission_id),);

CREATE TABLE Users (
	Users_id int not null,
	Users_name varchar(50) not null,
	Passwords varchar(50) not null,
	Mailbox varchar(50) not null,
	PhoneNum bigint not null,
	Payment_info bigint not null,
	Permission_id int not null,
	Addr varchar(255) not null,
	primary key (Users_id),
	FOREIGN KEY (Permission_id) REFERENCES Permission(Permission_id),
	);


CREATE TABLE Promotion (
  Discount_ID int not null,
  Descriptions varchar(255) not null,
  Start_time datetime not null,
  End_time datetime not null,
  DisPercent decimal(10,2) not null,
  primary key (Discount_ID),
);

CREATE TABLE Orders (
  Orders_id INT NOT NULL ,
  Create_day datetime NOT NULL,
  Payment_day datetime NOT NULL,
  Hotel_id int not null,
  Users_id int not null,
  Progress varchar(50) not null,
  Discount_id int,
  PRIMARY KEY (Orders_id),
  FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id),
  FOREIGN KEY (Users_id) REFERENCES Users(Users_id),
  FOREIGN KEY (Discount_id) REFERENCES Promotion(Discount_id),
  );



CREATE TABLE OrderDetail(
	Checkindate datetime not null,
	Checkoutdate datetime not null,
	Orders_id int not null,
	Room_id int not null,
	Counts int not null,
	FOREIGN KEY (Room_id) REFERENCES Room(Room_id),
	FOREIGN KEY (Orders_id) REFERENCES Orders(Orders_id),);



CREATE TABLE Review(
	Review_id int not null,
	Rating int not null,
	Comment_content varchar(255) not null,
	Users_id int not null,
	Hotel_id int not null,
	primary key (review_id),
	FOREIGN KEY (Users_id) REFERENCES Users(Users_id),
	FOREIGN KEY (Hotel_id) REFERENCES Hotel(Hotel_id),
	);






