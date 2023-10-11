CREATE DATABASE [MarginSKU_2]
GO
USE [MarginSKU_2]
GO
CREATE TABLE [dbo].[Customers](
	[customerID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[Name] [nvarchar] (100) NOT NULL Unique
)
CREATE TABLE [dbo].[Projects](
	[ProjectId] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL Unique
) 
GO
CREATE TABLE [dbo].[Goods](
	[GoodID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL Unique
) 
CREATE TABLE [dbo].[Costs](
	[CostId] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[Name] [nchar](100) NOT NULL Unique
)
CREATE TABLE [dbo].[RegisterSales](
	[RegisterSaleID] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CustomerID] [int] FOREIGN KEY REFERENCES Customers(CustomerID) NOT NULL,
	[ProjectId] [int] FOREIGN KEY REFERENCES Projects(ProjectId) NOT NULL,
	[GoodID] [int] FOREIGN KEY REFERENCES Goods(GoodID) NOT NULL,
	[Quantity] [decimal](18, 3) NOT NULL,
	[Summa] [decimal](18, 2) NOT NULL,
	[SummaCostGoods] [decimal](18, 2) NOT NULL
) 

CREATE TABLE [dbo].[RegisterCosts](
	[RegisterCostId] [int] PRIMARY KEY identity(1,1) NOT NULL,
	[CostId] [int] FOREIGN KEY REFERENCES Costs(CostId) NOT NULL,
	[ProjectId] [int] FOREIGN KEY REFERENCES Projects(ProjectId) NOT NULL,
	[Summa] [decimal](18, 2) NOT NULL,
	[Date] [datetime] NOT NULL,
 ) 
GO
Create OR ALTER View MarginSKU AS
WITH TolalSalesProject (ProjectId, QuantityTotal, SummaTotal, Date )
AS
(
SELECT        ProjectId, SUM(Quantity) AS QuantityTotal, SUM(Summa) AS SummaTotal, EOMONTH(Date) AS Date
FROM            dbo.RegisterSales
GROUP BY EOMONTH(Date), ProjectId
)
,
TotalSales (customerID, ProjectId, Quantity, Summa, Date, QuantityTotal, SummaTotal, GoodID )
AS
(
SELECT        RegisterSales.customerID, RegisterSales.ProjectId, RegisterSales.Quantity, RegisterSales.Summa, EOMONTH(RegisterSales.Date) AS Date, TolalSalesProject.QuantityTotal, TolalSalesProject.SummaTotal, 
                         RegisterSales.GoodID
FROM            RegisterSales INNER JOIN
                         TolalSalesProject ON RegisterSales.ProjectId = TolalSalesProject.ProjectId AND EOMONTH(RegisterSales.Date) = TolalSalesProject.Date
)
,
DraftMargin (customerID, ProjectId, Quantity, Summa, Date, QuantityTotal, SummaTotal, GoodID, CostId, SummaCostGoods, Margin)
AS
(
SELECT        TotalSales.customerID AS customerID, TotalSales.ProjectId AS ProjectId, TotalSales.Quantity AS Quantity, TotalSales.Summa AS Summa, EOMONTH(TotalSales.Date) AS Date, TotalSales.QuantityTotal AS QuantityTotal, TotalSales.SummaTotal AS SummaTotal, 
                         TotalSales.GoodID AS GoodID, RegisterCosts.CostId AS CostId, RegisterCosts.Summa AS SummaCostGoods, TotalSales.Summa / TotalSales.SummaTotal * RegisterCosts.Summa AS Margin
FROM            TotalSales INNER JOIN
                         RegisterCosts ON TotalSales.ProjectId = RegisterCosts.ProjectId AND TotalSales.Date = EOMONTH(RegisterCosts.Date)
)
,
MarginCalculate (Date, ProjectId, ProjectName, CustomerId, CustomerName, GoodId, GoodName, Quantity, Revenues, SummaCostGoods, GrossProfit, CostMargin, Profit)
AS
(
SELECT        Date, dbo.Projects.ProjectId, dbo.Projects.Name AS ProjectName, dbo.Customers.customerID, dbo.Customers.Name AS CustomerName, dbo.Goods.GoodID, dbo.Goods.Name AS GoodName, SUM(Derived.Quantity) AS Quantity, SUM(Derived.Summa) AS Revenues, SUM(Derived.SummaCostGoods) AS SummaCostGoods, 
                         SUM(Derived.Summa) - SUM(Derived.SummaCostGoods) AS GrossProfit, SUM(Derived.Margin) AS CostMargin, SUM(Derived.Summa) - SUM(Derived.SummaCostGoods) - SUM(Derived.Margin) AS Profit
FROM            (SELECT        ProjectId AS ProjectId1, customerID AS id_customer1, GoodID AS goodId1, Quantity, Summa, SummaCostGoods, 0 AS Margin, EOMONTH(Date) AS Date
                 FROM            dbo.RegisterSales
                          UNION
                 SELECT        ProjectId AS ProjectId1, customerID AS id_customer1, GoodID AS goodId1, 0 AS Quantity, 0 AS Summa, 0 AS SummaCostGoods, Margin, Date
                 FROM            DraftMargin) AS Derived LEFT OUTER JOIN
                         dbo.Projects ON Derived.ProjectId1 = dbo.Projects.ProjectId LEFT OUTER JOIN
                         dbo.Customers ON Derived.id_customer1 = dbo.Customers.customerID LEFT OUTER JOIN
                         dbo.Goods ON Derived.goodId1 = dbo.Goods.GoodID
GROUP BY dbo.Projects.Name, dbo.Customers.Name, dbo.Goods.Name, dbo.Projects.ProjectId, dbo.Customers.customerID, dbo.Goods.GoodID, Date
)
Select * from MarginCalculate
GO
INSERT [dbo].[Customers] ([Name]) VALUES ( N'Amazon')
GO
INSERT [dbo].[Customers] ([Name]) VALUES ( N'Allegro')
GO
INSERT [dbo].[Customers] ([Name]) VALUES ( N'Olx')
GO
INSERT [dbo].[Projects] ([Name]) VALUES (N'Advertice')
GO
INSERT [dbo].[Projects] ([Name]) VALUES (N'Marketing')
GO
INSERT [dbo].[Projects] ([Name]) VALUES (N'Blogs')
GO
INSERT [dbo].[Goods] ( [Name]) VALUES ( N'Ball')
GO
INSERT [dbo].[Goods] ([Name]) VALUES ( N'Boots')
GO
INSERT [dbo].[Goods] ( [Name]) VALUES ( N'Book')
GO
INSERT [dbo].[Goods] ([Name]) VALUES ( N'Keyboard')
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(10.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 1, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(11.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 2, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(12.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 3, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(13.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 1, CAST(1300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(14.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 2, CAST(1500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(15.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 3, CAST(1600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (2, 1, CAST(16.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 1, CAST(700.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (2, 1, CAST(17.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 2, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (3, 2, CAST(18.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 1, CAST(1300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (3, 2, CAST(19.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-08-02T00:00:00.000' AS DateTime), 2, CAST(1650.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 3, CAST(20.000 AS Decimal(18, 3)), CAST(5000.00 AS Decimal(18, 2)), CAST(N'2022-08-03T00:00:00.000' AS DateTime), 1, CAST(3000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[Costs] ([Name]) VALUES (N'water                                                                                               ')
GO
INSERT [dbo].[Costs] ([Name]) VALUES (N'Salary                                                                                              ')
GO
INSERT [dbo].[Costs] ([Name]) VALUES (N'advert                                                                                              ')
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (1, 1, CAST(100.00 AS Decimal(18, 2)), CAST(N'2022-08-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (1, 2, CAST(200.00 AS Decimal(18, 2)), CAST(N'2022-08-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (2, 1, CAST(50.00 AS Decimal(18, 2)), CAST(N'2022-08-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (2, 2, CAST(50.00 AS Decimal(18, 2)), CAST(N'2022-08-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (3, 1, CAST(300.00 AS Decimal(18, 2)), CAST(N'2022-08-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(10.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 1, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(11.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 2, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 1, CAST(12.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 3, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(13.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 1, CAST(1300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(14.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 2, CAST(1500.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 2, CAST(15.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 3, CAST(1600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (2, 1, CAST(16.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 1, CAST(700.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (2, 1, CAST(17.000 AS Decimal(18, 3)), CAST(1000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 2, CAST(600.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (3, 2, CAST(18.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 1, CAST(1300.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (3, 2, CAST(19.000 AS Decimal(18, 3)), CAST(2000.00 AS Decimal(18, 2)), CAST(N'2022-09-02T00:00:00.000' AS DateTime), 2, CAST(1650.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterSales] ([CustomerId], [ProjectId], [Quantity], [Summa], [Date], [goodId], [SummaCostGoods]) VALUES (1, 3, CAST(20.000 AS Decimal(18, 3)), CAST(5000.00 AS Decimal(18, 2)), CAST(N'2022-09-03T00:00:00.000' AS DateTime), 1, CAST(3000.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (1, 1, CAST(100.00 AS Decimal(18, 2)), CAST(N'2022-09-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (1, 2, CAST(200.00 AS Decimal(18, 2)), CAST(N'2022-09-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (2, 1, CAST(50.00 AS Decimal(18, 2)), CAST(N'2022-09-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (2, 2, CAST(50.00 AS Decimal(18, 2)), CAST(N'2022-09-12T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[RegisterCosts] ([CostId], [ProjectId], [Summa], [Date]) VALUES (3, 1, CAST(300.00 AS Decimal(18, 2)), CAST(N'2022-09-12T00:00:00.000' AS DateTime))
GO
