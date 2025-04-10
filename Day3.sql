-- STEP 1: CREATE TABLES

-- 1. CUSTOMERS
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    SignupDate DATE
);

-- 2. CATEGORIES
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- 3. PRODUCTS
CREATE TABLE IF NOT EXISTS Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10,2),
    Stock INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 4. ORDERS
CREATE TABLE IF NOT EXISTS Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 5. ORDER_DETAILS
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    LineTotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- STEP 2: INSERT DATA

-- 1. Insert Customers
INSERT INTO Customers (FirstName, LastName, Email, SignupDate)
VALUES 
('John', 'Doe', 'john.doe@example.com', '2023-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-02-20'),
('Mike', 'Patel', 'mike.patel@example.com', '2023-03-10');

-- 2. Insert Categories
INSERT INTO Categories (CategoryName)
VALUES
('Electronics'),
('Clothing'),
('Accessories');

-- 3. Insert Products
INSERT INTO Products (ProductName, CategoryID, Price, Stock)
VALUES
('Smartphone', 1, 699.99, 50),
('Laptop', 1, 999.99, 25),
('T-Shirt', 2, 19.99, 100),
('Baseball Cap', 3, 12.99, 70);

-- 4. Insert Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2023-04-01', 712.98),
(2, '2023-04-02', 19.99),
(3, '2023-04-04', 1012.98);

-- 5. Insert OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, LineTotal)
VALUES
(1, 1, 1, 699.99),   -- 1 Smartphone
(1, 4, 1, 12.99),    -- 1 Baseball Cap
(2, 3, 1, 19.99),    -- 1 T-Shirt
(3, 2, 1, 999.99),   -- 1 Laptop
(3, 4, 1, 12.99);    -- 1 Baseball Cap

-- STEP 3: REPORT QUERIES

-- Total Sold & Revenue per Product
SELECT 
    P.ProductName,
    SUM(OD.Quantity) AS TotalSold,
    SUM(OD.LineTotal) AS TotalRevenue
FROM 
    OrderDetails OD
JOIN 
    Products P ON OD.ProductID = P.ProductID
GROUP BY 
    P.ProductName
ORDER BY 
    TotalSold DESC;

-- Revenue per Category
SELECT 
    C.CategoryName,
    SUM(OD.LineTotal) AS TotalRevenue
FROM 
    OrderDetails OD
JOIN 
    Products P ON OD.ProductID = P.ProductID
JOIN 
    Categories C ON P.CategoryID = C.CategoryID
GROUP BY 
    C.CategoryName
ORDER BY 
    TotalRevenue DESC;
