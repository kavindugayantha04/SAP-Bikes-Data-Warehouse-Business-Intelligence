USE SAP_Bikes_DW;
GO


/* =========================================================
   1. PRIMARY KEYS
   ========================================================= */

ALTER TABLE dw.Dim_Date
ADD CONSTRAINT PK_Dim_Date
PRIMARY KEY (DateKey);
GO


ALTER TABLE dw.Dim_Product
ADD CONSTRAINT PK_Dim_Product
PRIMARY KEY (ProductKey);
GO


ALTER TABLE dw.Dim_Customer
ADD CONSTRAINT PK_Dim_Customer
PRIMARY KEY (CustomerKey);
GO


ALTER TABLE dw.Dim_Location
ADD CONSTRAINT PK_Dim_Location
PRIMARY KEY (LocationKey);
GO


ALTER TABLE dw.Dim_Employee
ADD CONSTRAINT PK_Dim_Employee
PRIMARY KEY (EmployeeKey);
GO


ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT PK_Fact_Sales
PRIMARY KEY (SalesKey);
GO


/* =========================================================
   2. UNIQUE BUSINESS KEYS
   ========================================================= */

ALTER TABLE dw.Dim_Product
ADD CONSTRAINT UQ_Dim_Product_ProductID
UNIQUE (ProductID);
GO


ALTER TABLE dw.Dim_Customer
ADD CONSTRAINT UQ_Dim_Customer_PartnerID
UNIQUE (PartnerID);
GO


ALTER TABLE dw.Dim_Location
ADD CONSTRAINT UQ_Dim_Location_AddressID
UNIQUE (AddressID);
GO


ALTER TABLE dw.Dim_Employee
ADD CONSTRAINT UQ_Dim_Employee_EmployeeID
UNIQUE (EmployeeID);
GO


ALTER TABLE dw.Dim_Date
ADD CONSTRAINT UQ_Dim_Date_FullDate
UNIQUE (FullDate);
GO


ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT UQ_Fact_Sales_OrderItem
UNIQUE (SalesOrderID, SalesOrderItem);
GO


/* =========================================================
   3. FACT → DATE RELATIONSHIPS
   ========================================================= */

ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_OrderDate
FOREIGN KEY (OrderDateKey)
REFERENCES dw.Dim_Date(DateKey);
GO


ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_DeliveryDate
FOREIGN KEY (DeliveryDateKey)
REFERENCES dw.Dim_Date(DateKey);
GO


/* =========================================================
   4. FACT → PRODUCT
   ========================================================= */

ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_Product
FOREIGN KEY (ProductKey)
REFERENCES dw.Dim_Product(ProductKey);
GO


/* =========================================================
   5. FACT → CUSTOMER
   ========================================================= */

ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_Customer
FOREIGN KEY (CustomerKey)
REFERENCES dw.Dim_Customer(CustomerKey);
GO


/* =========================================================
   6. FACT → LOCATION
   ========================================================= */

ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_Location
FOREIGN KEY (LocationKey)
REFERENCES dw.Dim_Location(LocationKey);
GO


/* =========================================================
   7. FACT → EMPLOYEE
   ========================================================= */

ALTER TABLE dw.Fact_Sales
ADD CONSTRAINT FK_Fact_Sales_Employee
FOREIGN KEY (EmployeeKey)
REFERENCES dw.Dim_Employee(EmployeeKey);
GO


/* =========================================================
   8. CUSTOMER → LOCATION
   ========================================================= */

ALTER TABLE dw.Dim_Customer
ADD CONSTRAINT FK_Dim_Customer_Location
FOREIGN KEY (AddressID)
REFERENCES dw.Dim_Location(AddressID);
GO


/* =========================================================
   9. EMPLOYEE → LOCATION
   ========================================================= */

ALTER TABLE dw.Dim_Employee
ADD CONSTRAINT FK_Dim_Employee_Location
FOREIGN KEY (AddressID)
REFERENCES dw.Dim_Location(AddressID);
GO


USE SAP_Bikes_DW;
GO

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dw'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;