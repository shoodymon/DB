CREATE DATABASE Hotel;
GO
USE Hotel;
GO

-- Создание таблицы "Типы номеров"
CREATE TABLE RoomTypes (
    TypeCode INT IDENTITY(1,1) PRIMARY KEY,
    Type NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- Создание таблицы "Номера"
CREATE TABLE Rooms (
    RoomCode INT IDENTITY(1,1) PRIMARY KEY,
    Number INTEGER NOT NULL,
    TypeCode INTEGER NOT NULL,
	Floor INTEGER NOT NULL,
	FOREIGN KEY (TypeCode) REFERENCES RoomTypes(TypeCode)
);

-- Создание таблицы "Клиенты"
CREATE TABLE Clients (
    ClientCode INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	PassportNumber NVARCHAR(20) NOT NULL
);

-- Создание таблицы "Состояние"
CREATE TABLE Status (
    EntryCode INT IDENTITY(1,1) PRIMARY KEY,
    ClientCode INTEGER NOT NULL,
    RoomCode INTEGER NOT NULL,
	CheckInDate DATE NOT NULL,
	CheckOutDate DATE,
	FOREIGN KEY (ClientCode) REFERENCES Clients(ClientCode),
	FOREIGN KEY (RoomCode) REFERENCES Rooms(RoomCode)
);