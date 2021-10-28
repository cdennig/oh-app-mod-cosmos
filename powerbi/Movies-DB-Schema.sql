/****** Object:  Database [Movies]    Script Date: 10/28/2021 3:31:00 PM ******/
CREATE DATABASE [Movies]  (EDITION = 'Standard', SERVICE_OBJECTIVE = 'S0', MAXSIZE = 2 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [Movies] SET COMPATIBILITY_LEVEL = 140
GO
ALTER DATABASE [Movies] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Movies] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Movies] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Movies] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Movies] SET ARITHABORT OFF 
GO
ALTER DATABASE [Movies] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Movies] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Movies] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Movies] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Movies] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Movies] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Movies] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Movies] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [Movies] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Movies] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Movies] SET  MULTI_USER 
GO
ALTER DATABASE [Movies] SET ENCRYPTION ON
GO
ALTER DATABASE [Movies] SET QUERY_STORE = ON
GO
ALTER DATABASE [Movies] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Table [dbo].[ItemAggregate]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemAggregate](
	[id] [varchar](100) NOT NULL,
	[ItemId] [int] NOT NULL,
	[BuyCount] [int] NULL,
	[ViewDetailsCount] [int] NULL,
	[AddToCartCount] [int] NULL,
	[VoteCount] [int] NULL,
 CONSTRAINT [PK_ItemAggregate] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwItemAggregate]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[vwItemAggregate]
as
SELECT rtrim(ltrim([id])) id
      ,[ItemId]
      ,[BuyCount]
      ,[ViewDetailsCount]
      ,[AddToCartCount]
      ,[VoteCount]
  FROM [dbo].[ItemAggregate]


GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[FirstName] [varchar](160) NOT NULL,
	[LastName] [varchar](160) NOT NULL,
	[Address] [varchar](70) NOT NULL,
	[City] [varchar](40) NOT NULL,
	[State] [varchar](40) NOT NULL,
	[PostalCode] [varchar](10) NOT NULL,
	[Country] [varchar](40) NOT NULL,
	[Phone] [varchar](24) NOT NULL,
	[SMSOptIn] [bit] NULL,
	[SMSStatus] [varchar](100) NULL,
	[Email] [varchar](100) NOT NULL,
	[ReceiptUrl] [varchar](100) NULL,
	[Total] [decimal](18, 2) NULL,
	[PaymentTransactionId] [varchar](100) NULL,
	[HasBeenShipped] [bit] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetailId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
 CONSTRAINT [PK_OrderDetails_1] PRIMARY KEY CLUSTERED 
(
	[OrderDetailId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwembOrderDetails]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwembOrderDetails]
as
SELECT
 o.[OrderId]
,o.[OrderDate]
,o.[FirstName]
,o.[LastName]
,o.[Address]
,o.[City]
,o.[State]
,o.[PostalCode]
,o.[Country]
,o.[Phone]
,o.[SMSOptIn]
,o.[SMSStatus]
,o.[Email]
,o.[ReceiptUrl]
,o.[Total]
,o.[PaymentTransactionId]
,o.[HasBeenShipped]
  ,(select [OrderDetailId],[Email],[ProductId],[Quantity],[UnitPrice] from OrderDetails od where od.OrderId = o.OrderId for json auto) as OrderDetails
FROM Orders o;
GO
/****** Object:  Table [dbo].[Cartitem]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cartitem](
	[CartItemId] [varchar](100) NOT NULL,
	[CartId] [varchar](100) NULL,
	[ItemId] [int] NULL,
	[Quantity] [int] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_Cartitem] PRIMARY KEY CLUSTERED 
(
	[CartItemId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [varchar](100) NULL,
	[Description] [varchar](200) NULL,
	[Products] [varchar](200) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[id] [varchar](100) NOT NULL,
	[event] [varchar](100) NULL,
	[userId] [int] NULL,
	[itemId] [int] NULL,
	[orderId] [int] NULL,
	[contentId] [int] NULL,
	[sessionId] [varchar](100) NULL,
	[created] [datetime2](7) NULL,
	[region] [varchar](50) NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[ItemId] [int] IDENTITY(1,1) NOT NULL,
	[VoteCount] [int] NULL,
	[ProductName] [varchar](100) NULL,
	[ImdbId] [int] NULL,
	[Description] [varchar](200) NULL,
	[ImagePath] [varchar](200) NULL,
	[ThumbnailPath] [varchar](200) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[CategoryId] [int] NULL,
	[Category] [varchar](200) NULL,
	[Popularity] [decimal](18, 2) NULL,
	[OriginalLanguage] [varchar](10) NULL,
	[ReleaseDate] [date] NULL,
	[VoteAverage] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 10/28/2021 3:31:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[CategoryId] [int] NULL,
	[Personality] [varchar](100) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Cartitem]  WITH CHECK ADD  CONSTRAINT [FK_Cartitem_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([ItemId])
GO
ALTER TABLE [dbo].[Cartitem] CHECK CONSTRAINT [FK_Cartitem_Item]
GO
ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_User] FOREIGN KEY([userId])
REFERENCES [dbo].[User] ([UserId])
GO
ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_User]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([CategoryId])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_Category]
GO
ALTER TABLE [dbo].[ItemAggregate]  WITH CHECK ADD  CONSTRAINT [FK_ItemAggregate_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([ItemId])
GO
ALTER TABLE [dbo].[ItemAggregate] CHECK CONSTRAINT [FK_ItemAggregate_Item]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderDetails_Item] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Item] ([ItemId])
GO
ALTER TABLE [dbo].[OrderDetails] NOCHECK CONSTRAINT [FK_OrderDetails_Item]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[OrderDetails] NOCHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[User]  WITH NOCHECK ADD  CONSTRAINT [FK_User_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([CategoryId])
GO
ALTER TABLE [dbo].[User] NOCHECK CONSTRAINT [FK_User_Category]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Movies added to a user''s cart.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Cartitem'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Movie categories.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Category'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User clickstream events, such as browsing and adding items to a cart.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Event'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Movie items.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Item'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aggregates, such as buy count, view details count, add item to cart count, and vote count. 1:1 relationship with Items. A batch process updates these counts, which is an internal process we cannot share at this time.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ItemAggregate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'All details related to placed orders.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrderDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Placed orders.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Orders'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'All user accounts.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'User'
GO
ALTER DATABASE [Movies] SET  READ_WRITE 
GO
