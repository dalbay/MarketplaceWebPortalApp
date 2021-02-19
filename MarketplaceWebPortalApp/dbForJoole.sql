USE [master]
GO
/****** Object:  Database [MarketplaceWebPortalData]    Script Date: 2/19/2021 11:27:41 AM ******/
CREATE DATABASE [MarketplaceWebPortalData]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MarketplaceWebPortalData', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MarketplaceWebPortalData.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MarketplaceWebPortalData_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MarketplaceWebPortalData_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MarketplaceWebPortalData] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MarketplaceWebPortalData].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ARITHABORT OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET RECOVERY FULL 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET  MULTI_USER 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MarketplaceWebPortalData] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MarketplaceWebPortalData] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MarketplaceWebPortalData] SET QUERY_STORE = OFF
GO
USE [MarketplaceWebPortalData]
GO
/****** Object:  UserDefinedFunction [dbo].[checkInput]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[checkInput](
	@Input nvarchar(50)
)
RETURNS  int AS    
   BEGIN
	declare @true int; 
        if ((select count(email) from tblConsumer where Email=@Input)>=1)
		Begin
			set @true = 1;
		End
		else if((select count(Email) from tblConsumer where UserName=@Input)>=1)
		Begin
			Return 2;
		End
		else
		Begin
			set @true = 0;
		End
        RETURN @true
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumAirflowFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumAirflowFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumFlow float 
	set @maximumFlow = 	(Select MAX(tsf.Amount) as [maximumAirFlow]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Airflow');

        RETURN @maximumFlow;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumDiameterFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumDiameterFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumDiameter float 
	set @maximumDiameter = (Select MAX(tsf.Amount) as [maximumDiameter]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Diameter');

        RETURN @maximumDiameter;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumHeightFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMaximumHeightFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumHeight float 
	set @maximumHeight = (Select MAX(tsf.Amount) as [maximumHeight]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 9);

        RETURN @maximumHeight;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumLengthSofa]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumLengthSofa](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumLength float 
	set @maximumLength = (Select MAX(tsf.Amount) as [maximumLength]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 28);

        RETURN @maximumLength;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumPowerFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumPowerFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumPower float 
	set @maximumPower = (Select MAX(tsf.Amount) as [maximumPower]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 3);

        RETURN @maximumPower;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumRAM]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumRAM](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumRAM float 
	set @maximumRAM = 	(Select MAX(tsf.Amount) as [maximumRAM]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 11);

        RETURN @maximumRAM;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumScreenSizeTablet]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumScreenSizeTablet](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumScreenSize float 
	set @maximumScreenSize = 	(Select MAX(tsf.Amount) as [maximumScreenSize]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 14);

        RETURN @maximumScreenSize;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumSoundFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumSoundFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumSound float 
	set @maximumSound = (Select MAX(tsf.Amount) as [maximumSound]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Sound');

        RETURN @maximumSound;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumSpeedFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMaximumSpeedFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumSpeed float 
	set @maximumSpeed = (Select MAX(tsf.Amount) as [maximumSpeed]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 5);

        RETURN @maximumSpeed;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumStorageTablet]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMaximumStorageTablet](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumStorage float 
	set @maximumStorage = 	(Select MAX(tsf.Amount) as [maximumStorage]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 16);

        RETURN @maximumStorage;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMaximumVoltageFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMaximumVoltageFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @maximumVoltage float 
	set @maximumVoltage = (Select MAX(tsf.Amount) as [maximumVoltage]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 2 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 4);

        RETURN @maximumVoltage;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumAirflowFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumAirflowFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumFlow float 
	set @minimumFlow = (Select MIN(tsf.Amount) as [minimumAirflow]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Airflow');

        RETURN @minimumFlow;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumDiameterFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumDiameterFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumDiameter float 
	set @minimumDiameter = (Select MIN(tsf.Amount) as [minimumDiameter]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Diameter');

        RETURN @minimumDiameter;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumHeightFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMinimumHeightFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumHeight float 
	set @minimumHeight = (Select MIN(tsf.Amount) as [minimumHeight]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 9);

        RETURN @minimumHeight;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumLengthSofa]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumLengthSofa](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumLength float 
	set @minimumLength = (Select MIN(tsf.Amount) as [minimumLength]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 28);

        RETURN @minimumLength;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumPowerFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumPowerFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumPower float 
	set @minimumPower = (Select MIN(tsf.Amount) as [minimumPower]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 3);
        RETURN @minimumPower;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumRAM]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumRAM](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumRAM float 
	set @minimumRAM = 	(Select MIN(tsf.Amount) as [minimumRAM]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 11);

        RETURN @minimumRAM;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumScreenSizeTablet]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumScreenSizeTablet](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumScreenSize float 
	set @minimumScreenSize = 	(Select MIN(tsf.Amount) as [minimumScreenSize]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 14);

        RETURN @minimumScreenSize;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumSoundFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumSoundFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumSound float 
	set @minimumSound = (Select MIN(tsf.Amount) as [minimumSound]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_Name 
	Having ts.TechSpec_Name = 'Sound');

        RETURN @minimumSound;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumSpeedFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMinimumSpeedFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumSpeed float 
	set @minimumSpeed = (Select MIN(tsf.Amount) as [minimumSpeed]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 5);

        RETURN @minimumSpeed;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumStorageTablet]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getMinimumStorageTablet](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumStorage float 
	set @minimumStorage = 	(Select MIN(tsf.Amount) as [minimumStorage]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 3 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 16);

        RETURN @minimumStorage;
    END
GO
/****** Object:  UserDefinedFunction [dbo].[getMinimumVoltageFan]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[getMinimumVoltageFan](
	@ModelYearMin smallint,
	@ModelYearMax smallint
)
RETURNS  float    
   BEGIN
	declare @minimumVoltage float 
	set @minimumVoltage = (Select MIN(tsf.Amount) as [minimumVoltage]
	from tblProduct p 
	JOIN tblTechSpecFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	WHERE tsf.Filter_ID = 1 AND p.Model_Year >= @ModelYearMin  AND p.Model_Year <= @ModelYearMax
	Group By
	ts.TechSpec_ID 
	Having ts.TechSpec_ID = 4);

        RETURN @minimumVoltage;
    END
GO
/****** Object:  Table [dbo].[tblTechSpecFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTechSpecFilter](
	[Filter_ID] [int] NOT NULL,
	[TechSpec_ID] [int] NOT NULL,
	[Amount] [float] NOT NULL,
	[Product_ID] [int] NOT NULL,
 CONSTRAINT [PK_tblTechSpecFilter] PRIMARY KEY CLUSTERED 
(
	[Filter_ID] ASC,
	[TechSpec_ID] ASC,
	[Product_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechSpec]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTechSpec](
	[TechSpec_ID] [int] IDENTITY(1,1) NOT NULL,
	[TechSpec_Name] [nvarchar](50) NOT NULL,
	[TechSpec_Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblTechSpec] PRIMARY KEY CLUSTERED 
(
	[TechSpec_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechSpecSubCategory]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTechSpecSubCategory](
	[SubCategory_ID] [int] NOT NULL,
	[TechSpec_ID] [int] NOT NULL,
 CONSTRAINT [PK_tblTechSpecSubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCategory_ID] ASC,
	[TechSpec_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFilter](
	[Filter_ID] [int] IDENTITY(1,1) NOT NULL,
	[Filter_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblFilter] PRIMARY KEY CLUSTERED 
(
	[Filter_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSubCategory]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSubCategory](
	[SubCategory_ID] [int] IDENTITY(1,1) NOT NULL,
	[SubCategory_Name] [nvarchar](50) NOT NULL,
	[Category_ID] [int] NOT NULL,
 CONSTRAINT [PK_tblSubCategory] PRIMARY KEY CLUSTERED 
(
	[SubCategory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_FilterTable]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_FilterTable] AS
		SELECT
			ts.TechSpec_Name,
			tsf.Amount,
			f.Filter_Name,
			sc.SubCategory_Name	
	
			FROM tblTechSpec ts
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID;
GO
/****** Object:  Table [dbo].[tblApplication]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblApplication](
	[Application_ID] [int] IDENTITY(1,1) NOT NULL,
	[Application_Name] [varchar](50) NOT NULL,
	[Application_Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[Application_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCategory](
	[Category_ID] [int] IDENTITY(1,1) NOT NULL,
	[Category_Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblCategory] PRIMARY KEY CLUSTERED 
(
	[Category_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblConsumer]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblConsumer](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[Image] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblConsumer] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblManufacturer]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblManufacturer](
	[Manufacturer_ID] [int] IDENTITY(1,1) NOT NULL,
	[Manufacturer_Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblManufacturer] PRIMARY KEY CLUSTERED 
(
	[Manufacturer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMountingLocation]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMountingLocation](
	[Mounting_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location] [nvarchar](50) NOT NULL,
	[Mounting_Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblMountingLocation] PRIMARY KEY CLUSTERED 
(
	[Mounting_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProduct](
	[Product_ID] [int] IDENTITY(1,1) NOT NULL,
	[Product_Name] [nvarchar](50) NOT NULL,
	[Series] [nvarchar](50) NULL,
	[Model] [nvarchar](50) NOT NULL,
	[Model_Year] [smallint] NOT NULL,
	[Series_Info] [nvarchar](50) NULL,
	[Accessories] [nvarchar](50) NULL,
	[Application_ID] [int] NOT NULL,
	[Manufacturer_ID] [int] NOT NULL,
	[Mounting_ID] [int] NOT NULL,
	[Type_ID] [int] NOT NULL,
	[Image] [nvarchar](max) NULL,
	[SubCategory_ID] [int] NOT NULL,
 CONSTRAINT [PK_tblProduct] PRIMARY KEY CLUSTERED 
(
	[Product_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechnicalSpecifiactionNonValue]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTechnicalSpecifiactionNonValue](
	[TechSpech_ID] [int] NOT NULL,
	[Product_ID] [int] NOT NULL,
	[Value] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblTechnicalSpecifiactionNonValue] PRIMARY KEY CLUSTERED 
(
	[TechSpech_ID] ASC,
	[Product_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUseType]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUseType](
	[Type_ID] [int] IDENTITY(1,1) NOT NULL,
	[Type_Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblUseType] PRIMARY KEY CLUSTERED 
(
	[Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblApplication] ON 
GO
INSERT [dbo].[tblApplication] ([Application_ID], [Application_Name], [Application_Description]) VALUES (1, N'Indoor', N'Great for Indoor')
GO
INSERT [dbo].[tblApplication] ([Application_ID], [Application_Name], [Application_Description]) VALUES (2, N'Outdoor', N'Outdoor')
GO
INSERT [dbo].[tblApplication] ([Application_ID], [Application_Name], [Application_Description]) VALUES (3, N'Indoor/Outdoor', N'Convinient for both indoor and outdoor')
GO
INSERT [dbo].[tblApplication] ([Application_ID], [Application_Name], [Application_Description]) VALUES (4, N'N/A', NULL)
GO
SET IDENTITY_INSERT [dbo].[tblApplication] OFF
GO
SET IDENTITY_INSERT [dbo].[tblCategory] ON 
GO
INSERT [dbo].[tblCategory] ([Category_ID], [Category_Name]) VALUES (1, N'Mechanical')
GO
INSERT [dbo].[tblCategory] ([Category_ID], [Category_Name]) VALUES (2, N'Electrical')
GO
INSERT [dbo].[tblCategory] ([Category_ID], [Category_Name]) VALUES (3, N'Stationary')
GO
INSERT [dbo].[tblCategory] ([Category_ID], [Category_Name]) VALUES (4, N'Furniture')
GO
SET IDENTITY_INSERT [dbo].[tblCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[tblConsumer] ON 
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (1, N'tim', N'tim@tim.com', N'123', NULL)
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (2, N'admin', N'admin@admin.com', N'admin', NULL)
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (4, N'test', N'test@test.com', N'123123', N'testImage')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (5, N'TEST', N'TESST@TEST.COM', N'PASSWORD', N'SDFSD')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (6, N'testuser', N'test@test.com', N'123', N'path.here')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (7, N'Me', N'me@me.com', N'me', N'45.curryImage.jpg')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (8, N'shuvham', N'shuvham@shuvham.com', N'123', N'~/ImagesIMG_20200523_151725.jpg')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (9, N'slama', N'slama@s.com', N'123', N'~/Images/IMG-2327.jpg')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (10, N'ssharma', N'shuvham103@gmail.com', N'101', N'~/Images/IMG-5116.JPG')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (11, N'nthapa', N'nthapa@n.com', N'helloworld', N'~/Images/IMG_3323.jpg')
GO
INSERT [dbo].[tblConsumer] ([User_ID], [UserName], [Email], [Password], [Image]) VALUES (12, N'shuvham103', N's@s.com', N'1011', N'~/Images/IMG_20200523_151725.jpg')
GO
SET IDENTITY_INSERT [dbo].[tblConsumer] OFF
GO
SET IDENTITY_INSERT [dbo].[tblFilter] ON 
GO
INSERT [dbo].[tblFilter] ([Filter_ID], [Filter_Name]) VALUES (1, N'Min')
GO
INSERT [dbo].[tblFilter] ([Filter_ID], [Filter_Name]) VALUES (2, N'Max')
GO
INSERT [dbo].[tblFilter] ([Filter_ID], [Filter_Name]) VALUES (3, N'None')
GO
SET IDENTITY_INSERT [dbo].[tblFilter] OFF
GO
SET IDENTITY_INSERT [dbo].[tblManufacturer] ON 
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (1, N'Samsung')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (2, N'Apple')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (3, N'HP')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (4, N'Philips')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (5, N'IKEA')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (6, N'Duracell')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (7, N'Staples')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (8, N'National')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (9, N'Sharpie')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (10, N'iRobot')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (11, N'Cuisinart')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (12, N'RAYMOUR & FLANIGAN')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (13, N'ASHLEY FURNITURE')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (14, N'MADISON PARK')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (15, N'AMAZON')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (16, N'MICROSOFT')
GO
INSERT [dbo].[tblManufacturer] ([Manufacturer_ID], [Manufacturer_Name]) VALUES (17, N'HUNTER')
GO
SET IDENTITY_INSERT [dbo].[tblManufacturer] OFF
GO
SET IDENTITY_INSERT [dbo].[tblMountingLocation] ON 
GO
INSERT [dbo].[tblMountingLocation] ([Mounting_ID], [Location], [Mounting_Description]) VALUES (1, N'Roof', N'Goes nicely the roof')
GO
INSERT [dbo].[tblMountingLocation] ([Mounting_ID], [Location], [Mounting_Description]) VALUES (2, N'Garden', N'For spraying')
GO
INSERT [dbo].[tblMountingLocation] ([Mounting_ID], [Location], [Mounting_Description]) VALUES (3, N'Ground', N'Can stick anywhere')
GO
INSERT [dbo].[tblMountingLocation] ([Mounting_ID], [Location], [Mounting_Description]) VALUES (4, N'N/A', N'No mounting for this item')
GO
SET IDENTITY_INSERT [dbo].[tblMountingLocation] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProduct] ON 
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (4, N'iPad Air', N'Series 9', N'VIPRB-MYFQ2LL/A', 2019, N'Latest Model', N'Chargers, warranty', 4, 2, 4, 3, N'https://cpp-express.com/wp-content/uploads/2019/06/TEMPERED-GLASS-FOR-IPAD-AIR-1-AIR-2-IPAD-PRO-9.7-IPAD-5-CLEAR-SERIES-1.jpg
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (8, N'4-ply sofa', N'SD_32983', N'4 ply Staples', 2012, N'Extra comfort, charger included', N'Charger, Cuisine', 1, 8, 4, 2, N'https://i.pinimg.com/originals/7a/f4/d2/7af4d279869f162cd1b50ec4048e6128.jpg
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (16, N'Haiku H Series', N'Haiku H', N'S3-150-s0BC-04', 2016, N'Most Affordable', N'With Light', 1, 4, 1, 2, N'https://lifeonsummerhill.com/wp-content/uploads/2021/02/5222Szymon3-BladePropellerCeilingFanwithPullChain-1.jpg
', 2)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (39, N'Buxton Loveseat', N'Traditional', N'2044665', 2020, N'Comfort and classic styling', N'Two pillows', 1, 12, 4, 2, N'https://www.ethanallen.com/dw/image/v2/AAKH_PRD/on/demandware.static/-/Sites-main/default/dw9c1bf72b/images/large_gray/65-7882_1032_DI.jpg?sw=800&sh=800&sm=fit
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (40, N'Isabelle Loveseat', N'Isabelle', N'2045589', 2019, N'Sinuous Coil Spring System', N'Reversible pillows', 1, 12, 4, 2, N'https://cdn.cort.com/cort/images/products/P1007058_main_600.jpg
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (44, N'Grasson Lane Outdoor Sofa', N'Summer 2018', N'3339090', 2018, N'All-weather foam cushion core', N'Loose seat cushions', 2, 13, 4, 2, N'https://th.bing.com/th?id=OP.iSROat4T9ZXg%2fw474C474&w=256&h=256&o=5&pid=21.1
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (46, N'Madison Park Brooke Arm Chair', N'Brooke Serie', N'FPF18-0109', 2021, N'Cushioned seat with extra back support.', N'No Assembly required or assembly required.', 1, 14, 4, 2, N'https://cmsmedia.remodelista.com/wp-content/uploads/2011/02/design-within-reach-raleigh-armchair-584x438.jpg
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (48, N'Elick Leather Queen Sleeper Sofa', N'Elick Collection', N'ELK20-1099', 2021, N'Elick features rolled arms, top-grain leather ', N'No Assembly or accessories', 1, 14, 4, 2, N'https://i.pinimg.com/originals/44/17/97/441797a05f807e4154ee01f55b8141bd.jpg
', 10)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (49, N'Fire 7 tablet', N'Fire ', N'Fire 7', 2021, N'Engineered and tested by Amazon', N'With Case & Screen Protector', 4, 15, 4, 2, N'https://th.bing.com/th/id/OIP.RhMmlQ_lyG4DtARnl_ACsAHaHa?pid=ImgDet&rs=1
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (51, N'Fire HD 10 Tablet', N'Fire', N'Fire HD 10', 2021, N'Engineered and tested by Amazon', N'USB-C (2.0) cable, 9W power adapter', 4, 15, 4, 2, N'https://images.latestdeals.co.uk/post-large/p-59f315ecd517871beac87e2e-1.jpg
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (56, N'Samsung Galaxy Tab A7 10.4', N'Galaxy', N'SM-T500 Wif-Fi', 2020, N'The Galaxy A7 SM-T500 is an Android Tablet.', N'Bluetooth Keyboard Case', 4, 1, 4, 2, N'https://www.mytrendyphone.co.uk/images/Samsung-Galaxy-Tab-A7-10-4-2020-WiFi-SM-T500-32GB-Silver-30092020-05-p.jpg
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (60, N'Samsung Galaxy Tab S7', N'Galaxy S7', N'SM-T870 (Wi-Fi only)', 2020, N' 5G-enabled tablet', N'Book Cover Keyboard', 4, 1, 4, 2, N'https://i1.wp.com/technosports.co.in/wp-content/uploads/2020/06/gsmarena_005-2-2.jpg?ssl=1
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (61, N'Microsoft Surface Pro X', N'Surface Pro', N'MJX-00001', 2021, N'Powered by Qualcomm - SQ1 processor', N'Surface Slim Pen', 4, 16, 4, 2, N'https://zolti.pl/pol_pl_ESR-ICE-SHIELD-GALAXY-S20-ULTRA-CLEAR-205035_1.jpg
', 4)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (62, N'42" Low Profile® IV 5', N'Hunter Low Profile', N'HTF2387', 2019, N'Blade Flush Mount Ceiling Fan', N'No additional accessories', 1, 17, 1, 2, N'http://mobileimages.lowes.com/product/converted/049694/049694596246.jpg
', 2)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (63, N'Wynd 5', N'Wynd LED Collection', N'NDNH1213', 2021, N'LED Smart Standard Ceiling', N'
Light Source Included', 2, 17, 1, 2, N'http://mobileimages.lowes.com/product/converted/049694/049694532978.jpg
', 2)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (65, N'42" Brandee 4', N'Pull Chain Series', N'W002489425', 2018, N'Flush Mount Ceiling Fan with Pull Chain', N'Light Source included', 1, 4, 1, 2, N'https://media.bunnings.com.au/Product-800x800/8f490264-a27a-4036-b225-3615b890ed52.jpg
', 2)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (66, N'42" Snediker 3', N'Standard Collection', N'W004459163', 2017, N'Standard Ceiling Fan with Light Kit', N'Remote Control and Light Kit', 1, 4, 1, 2, N'https://www.thelightingsuperstore.co.uk/images/fs/5/antibes-white-ceiling-fan-35014-1174.jpg
', 2)
GO
INSERT [dbo].[tblProduct] ([Product_ID], [Product_Name], [Series], [Model], [Model_Year], [Series_Info], [Accessories], [Application_ID], [Manufacturer_ID], [Mounting_ID], [Type_ID], [Image], [SubCategory_ID]) VALUES (67, N'52" Mirabal 6', N'Blade Standard Ceiling Fan', N'NDNH0572', 2015, N'Fan with Remote Control and Light Kit', N'Remote Control and Light Kit', 1, 17, 1, 2, N'https://images-na.ssl-images-amazon.com/images/I/31O8NA9fjTL._SL500_AC_SS350_.jpg
', 2)
GO
SET IDENTITY_INSERT [dbo].[tblProduct] OFF
GO
SET IDENTITY_INSERT [dbo].[tblSubCategory] ON 
GO
INSERT [dbo].[tblSubCategory] ([SubCategory_ID], [SubCategory_Name], [Category_ID]) VALUES (2, N'Fan', 2)
GO
INSERT [dbo].[tblSubCategory] ([SubCategory_ID], [SubCategory_Name], [Category_ID]) VALUES (4, N'Tablet', 2)
GO
INSERT [dbo].[tblSubCategory] ([SubCategory_ID], [SubCategory_Name], [Category_ID]) VALUES (10, N'Sofa', 4)
GO
SET IDENTITY_INSERT [dbo].[tblSubCategory] OFF
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (19, 49, N'Fire OS')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (19, 51, N'Fire OS 5.0.1 (Android 5.1 Lollipop)')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (19, 56, N'Android 10, One UI 2.5')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (19, 60, N'Android 10, One UI 2.5')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (19, 61, N'Windows 10 Home')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (20, 49, N'Quad-Core 1.3GHz')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (20, 51, N'4x 1.2 GHz ARM Cortex-A')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (20, 56, N'Octa-core (8x2.0 GHz Kryo 260 Gold)')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (20, 60, N'3.09 GHz Kryo 585')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (20, 61, N'Qualcomm')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (21, 49, N'USB 2.0 (micro-B connector)')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (21, 51, N'2.0, Micro USB')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (21, 56, N'USB Type-C 2.0')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (21, 60, N'USB Type-C 3.2')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (21, 61, N'USB Type-C')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 8, N'Loveseat')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 39, N'Loveseat')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 40, N'Loveseat')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 44, N'Sofa 3 seater')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 46, N'Armchair')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (24, 48, N'Sleeper Sofa')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 8, N'Grey')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 39, N'Barley')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 40, N'Green')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 44, N'White/Grey')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 46, N'White')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (25, 48, N'White')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 8, N'Microfiber')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 39, N'100% Polyester')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 40, N'Tatum haze (bouce)')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 44, N'Nuvella® fabric')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 46, N'Polyester')
GO
INSERT [dbo].[tblTechnicalSpecifiactionNonValue] ([TechSpech_ID], [Product_ID], [Value]) VALUES (26, 48, N'Leather')
GO
SET IDENTITY_INSERT [dbo].[tblTechSpec] ON 
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (1, N'Touch Capable', N'Supports touch?')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (2, N'Airflow', N'Airflow')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (3, N'Power(W)', N'Power in Watt')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (4, N'Operating Voltage(VAC)', N'Min and Max voltage to operate')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (5, N'Fan Speed(RPM)', N'Min and Max ')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (6, N'Number of Fan Speeds', N'Total Fan Speed')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (7, N'Sound at Max Speed', N'Sound in DBA')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (8, N'Fan Sweep Diameter', N'Sweep Diameter in Inch')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (9, N'Height(in)', N'Min and Max height')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (10, N'Weights', N'Weights in Lbs')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (11, N'RAM', N'Total RAM')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (12, N'Display', N'Total Display Frequency')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (13, N'Dimension', N'Size')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (14, N'Screen Size', N'Screen Size')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (15, N'Diameter', N'For pens')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (16, N'Storage', N'In GB')
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (18, N'Video', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (19, N'OS', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (20, N'CPU', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (21, N'USB', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (23, N'Camera', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (24, N'Sofa Style', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (25, N'Color', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (26, N'Fabric', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (27, N'Dept', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (28, N'Length', NULL)
GO
INSERT [dbo].[tblTechSpec] ([TechSpec_ID], [TechSpec_Name], [TechSpec_Description]) VALUES (29, N'Width', NULL)
GO
SET IDENTITY_INSERT [dbo].[tblTechSpec] OFF
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 1.95, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 5, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 2.5, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 1.5, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 2.45, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 3, 3.5, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 4, 100, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 35, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 50, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 25, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 25, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 45, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 5, 30, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 12.3, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 15, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 10, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 9, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 13.5, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (1, 9, 15, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 21.14, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 25, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 19, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 15.9, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 20, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 3, 24, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 240, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 120, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 240, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 120, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 240, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 4, 240, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 200, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 250, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 170, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 145, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 210, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 5, 210, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 57, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 40, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 48, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 39, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 50, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (2, 9, 63, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 1600, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 2029, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 1900, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 1590, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 2250, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 2, 2450, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 7, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 5, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 5, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 4, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 3, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 6, 6, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 35, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 30, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 25, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 20, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 22, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 7, 42, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 34, 8)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 60, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 39, 39)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 33.5, 40)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 37, 44)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 19.5, 46)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 9, 36, 48)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 458, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 126, 8)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 13, 16)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 145, 39)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 110, 40)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 90, 44)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 30, 46)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 270, 48)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 10, 49)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 17.8, 51)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 19, 56)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 19.5, 60)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 27.2, 61)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 10, 62)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 12.5, 63)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 9.5, 65)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 11.9, 66)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 10, 16.9, 67)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 8, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 1, 49)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 2, 51)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 3, 56)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 8, 60)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 11, 16, 61)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 10.9, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 7.6, 49)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 10.3, 51)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 10.4, 56)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 11, 60)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 14, 13, 61)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 256, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 16, 49)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 32, 51)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 64, 56)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 512, 60)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 16, 256, 61)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 18, 4, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 23, 12, 4)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 23, 2, 49)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 23, 5, 56)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 23, 13, 60)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 23, 5, 61)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 38, 8)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 40, 39)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 35, 40)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 36, 44)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 30, 46)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 27, 38, 48)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 66, 8)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 70, 39)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 63, 40)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 97, 44)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 29.5, 46)
GO
INSERT [dbo].[tblTechSpecFilter] ([Filter_ID], [TechSpec_ID], [Amount], [Product_ID]) VALUES (3, 28, 86, 48)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 2)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 3)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 4)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 5)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 6)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 7)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 8)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (2, 9)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 10)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 11)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 14)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 16)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 18)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 19)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 20)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 21)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (4, 23)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 9)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 10)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 24)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 25)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 26)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 27)
GO
INSERT [dbo].[tblTechSpecSubCategory] ([SubCategory_ID], [TechSpec_ID]) VALUES (10, 28)
GO
SET IDENTITY_INSERT [dbo].[tblUseType] ON 
GO
INSERT [dbo].[tblUseType] ([Type_ID], [Type_Name]) VALUES (1, N'Commercial')
GO
INSERT [dbo].[tblUseType] ([Type_ID], [Type_Name]) VALUES (2, N'Household')
GO
INSERT [dbo].[tblUseType] ([Type_ID], [Type_Name]) VALUES (3, N'Anywhere')
GO
SET IDENTITY_INSERT [dbo].[tblUseType] OFF
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK_tblProduct_tblApplication] FOREIGN KEY([Application_ID])
REFERENCES [dbo].[tblApplication] ([Application_ID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK_tblProduct_tblApplication]
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK_tblProduct_tblManufacturer] FOREIGN KEY([Manufacturer_ID])
REFERENCES [dbo].[tblManufacturer] ([Manufacturer_ID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK_tblProduct_tblManufacturer]
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK_tblProduct_tblMountingLocation] FOREIGN KEY([Mounting_ID])
REFERENCES [dbo].[tblMountingLocation] ([Mounting_ID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK_tblProduct_tblMountingLocation]
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK_tblProduct_tblSubCategory] FOREIGN KEY([SubCategory_ID])
REFERENCES [dbo].[tblSubCategory] ([SubCategory_ID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK_tblProduct_tblSubCategory]
GO
ALTER TABLE [dbo].[tblProduct]  WITH CHECK ADD  CONSTRAINT [FK_tblProduct_tblUseType] FOREIGN KEY([Type_ID])
REFERENCES [dbo].[tblUseType] ([Type_ID])
GO
ALTER TABLE [dbo].[tblProduct] CHECK CONSTRAINT [FK_tblProduct_tblUseType]
GO
ALTER TABLE [dbo].[tblSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblSubCategory_tblCategory] FOREIGN KEY([Category_ID])
REFERENCES [dbo].[tblCategory] ([Category_ID])
GO
ALTER TABLE [dbo].[tblSubCategory] CHECK CONSTRAINT [FK_tblSubCategory_tblCategory]
GO
ALTER TABLE [dbo].[tblTechnicalSpecifiactionNonValue]  WITH CHECK ADD  CONSTRAINT [FK_tblTechnicalSpecifiactionNonValue_tblProduct] FOREIGN KEY([Product_ID])
REFERENCES [dbo].[tblProduct] ([Product_ID])
GO
ALTER TABLE [dbo].[tblTechnicalSpecifiactionNonValue] CHECK CONSTRAINT [FK_tblTechnicalSpecifiactionNonValue_tblProduct]
GO
ALTER TABLE [dbo].[tblTechnicalSpecifiactionNonValue]  WITH CHECK ADD  CONSTRAINT [FK_tblTechnicalSpecifiactionNonValue_tblTechSpec] FOREIGN KEY([TechSpech_ID])
REFERENCES [dbo].[tblTechSpec] ([TechSpec_ID])
GO
ALTER TABLE [dbo].[tblTechnicalSpecifiactionNonValue] CHECK CONSTRAINT [FK_tblTechnicalSpecifiactionNonValue_tblTechSpec]
GO
ALTER TABLE [dbo].[tblTechSpecFilter]  WITH CHECK ADD  CONSTRAINT [FK_tblTechSpecFilter_tblProduct] FOREIGN KEY([Product_ID])
REFERENCES [dbo].[tblProduct] ([Product_ID])
GO
ALTER TABLE [dbo].[tblTechSpecFilter] CHECK CONSTRAINT [FK_tblTechSpecFilter_tblProduct]
GO
ALTER TABLE [dbo].[tblTechSpecFilter]  WITH CHECK ADD  CONSTRAINT [FK_tblTechSpechFilter_tblFilter] FOREIGN KEY([Filter_ID])
REFERENCES [dbo].[tblFilter] ([Filter_ID])
GO
ALTER TABLE [dbo].[tblTechSpecFilter] CHECK CONSTRAINT [FK_tblTechSpechFilter_tblFilter]
GO
ALTER TABLE [dbo].[tblTechSpecFilter]  WITH CHECK ADD  CONSTRAINT [FK_tblTechSpechFilter_tblTechSpec] FOREIGN KEY([TechSpec_ID])
REFERENCES [dbo].[tblTechSpec] ([TechSpec_ID])
GO
ALTER TABLE [dbo].[tblTechSpecFilter] CHECK CONSTRAINT [FK_tblTechSpechFilter_tblTechSpec]
GO
ALTER TABLE [dbo].[tblTechSpecSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblTechSpecSubCategory_tblSubCategory] FOREIGN KEY([SubCategory_ID])
REFERENCES [dbo].[tblSubCategory] ([SubCategory_ID])
GO
ALTER TABLE [dbo].[tblTechSpecSubCategory] CHECK CONSTRAINT [FK_tblTechSpecSubCategory_tblSubCategory]
GO
ALTER TABLE [dbo].[tblTechSpecSubCategory]  WITH CHECK ADD  CONSTRAINT [FK_tblTechSpecSubCategory_tblTechSpec] FOREIGN KEY([TechSpec_ID])
REFERENCES [dbo].[tblTechSpec] ([TechSpec_ID])
GO
ALTER TABLE [dbo].[tblTechSpecSubCategory] CHECK CONSTRAINT [FK_tblTechSpecSubCategory_tblTechSpec]
GO
/****** Object:  StoredProcedure [dbo].[sp_FanFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanFilter]
@SubCategoryName nvarchar(50),
	--@ModelYearMin smallint,
	--@ModelYearMax smallint,
	--@minAirflow float,
	--@maxAirflow float,
	@minPower float,
	@maxPower float
	--@minSound float,
	--@maxSound float,
	--@minDiameter float,
	--@maxDiameter float

AS 		
BEGIN			
	--DECLARE @minAirflow float
	--DECLARE @maxAirflow float
	DECLARE @minPow float
	DECLARE @maxPow float
	--DECLARE @minSound float
	--DECLARE @maxSound float
	--DECLARE @minDiameter float
	--DECLARE @maxDiameter float
	SET NOCOUNT ON
		--SET @minAirflow = [dbo].[getMinimumAirflowFan](@ModelYearMin,@ModelYearMax);
		--SET @maxAirflow = [dbo].[getMaximumAirflowFan](@ModelYearMin,@ModelYearMax);
		SET @minPow = (SELECT
			tsf.Amount	
			FROM tblTechSpec ts
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where
				sc.SubCategory_Name = @SubCategoryName 
				AND	ts.TechSpec_Name = 'Power(W)' AND f.Filter_ID = 1 AND tsf.Amount >= @minPower )
				--AND	ts.TechSpec_Name = 'Power(W)' AND f.Filter_ID = 2 AND tsf.Amount >= @maxPower)
		SET @maxPow = (SELECT
			tsf.Amount	
			FROM tblTechSpec ts
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where
				sc.SubCategory_Name = @SubCategoryName 
				AND	ts.TechSpec_Name = 'Power(W)' AND f.Filter_ID = 2 AND tsf.Amount <= @maxPower )
		--SET @minSound = [dbo].[getMinimumSoundFan](@ModelYearMin,@ModelYearMax);
		--SET @maxSound = [dbo].[getMaximumSoundFan](@ModelYearMin,@ModelYearMax);
		--SET @minDiameter = [dbo].[getMinimumDiameterFan](@ModelYearMin,@ModelYearMax);
		--SET @maxDiameter = [dbo].[getMaximumDiameterFan](@ModelYearMin,@ModelYearMax);

		select  @minPow, @maxPow
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FanHeightFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanHeightFilter]
@SubCategoryName nvarchar(50),
	@minHeight float,
	@maxHeight float,
	@minDate smallint,
	@maxDate smallint
	
AS 		
BEGIN			
	DECLARE @minHi float
	DECLARE @maxHi float
	SET NOCOUNT ON
		SET @minHi = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 9 AND f.Filter_ID = 1 AND tsf.Amount >= @minHeight  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxHi = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 9 AND f.Filter_ID = 2 AND tsf.Amount >= @maxHeight 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minHi as [minHeight] , @maxHi as [maxheight] 		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FanPoweFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanPoweFilter]
@SubCategoryName nvarchar(50),
	@minPower float,
	@maxPower float,
	@minDate smallint,
	@maxDate smallint
AS 		
BEGIN			
	DECLARE @minPow float
	DECLARE @maxPow float
	SET NOCOUNT ON
		SET @minPow = (SELECT
			p.Product_ID	
			FROM tblTechSpec ts
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where
				sc.SubCategory_Name = @SubCategoryName 
				AND	ts.TechSpec_Name = 'Power(W)' AND f.Filter_ID = 1 AND tsf.Amount >= @minPower 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxPow = (SELECT
			p.Product_ID	
			FROM tblTechSpec ts
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where
				sc.SubCategory_Name = @SubCategoryName 
				AND	ts.TechSpec_Name = 'Power(W)' AND f.Filter_ID = 2 AND tsf.Amount <= @maxPower 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minPow as [minPower], @maxPow as [maxPower]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FanSpeedFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanSpeedFilter]
@SubCategoryName nvarchar(50),
	@minSpeed float,
	@maxSpeed float,
	@minDate smallint,
	@maxDate smallint
AS 		
BEGIN			
	DECLARE @minSp float
	DECLARE @maxSp float
	SET NOCOUNT ON
		SET @minSp = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 5 AND f.Filter_ID = 1 AND tsf.Amount >= @minSpeed  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxSp = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 5 AND f.Filter_ID = 2 AND tsf.Amount >= @maxSpeed  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minSp as [minSpeed]  , @maxSp as [maxSpeed]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FanSubCategorySetFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanSubCategorySetFilter]
	@ModelYearMin smallint,
	@ModelYearMax smallint
AS
BEGIN
	DECLARE @minVoltage float
	DECLARE @maxVoltage float
	DECLARE @minPower float
	DECLARE @maxPower float
	DECLARE @minSpeed float
	DECLARE @maxSpeed float
	DECLARE @minHeight float
	DECLARE @maxHeight float
	SET NOCOUNT ON
		SET @minPower = [dbo].[getMinimumPowerFan](@ModelYearMin,@ModelYearMax);
		SET @maxPower = [dbo].[getMaximumPowerFan](@ModelYearMin,@ModelYearMax);
		SET @maxVoltage = [dbo].[getMaximumVoltageFan](@ModelYearMin,@ModelYearMax);
		SET @minVoltage = [dbo].[getMinimumVoltageFan](@ModelYearMin,@ModelYearMax);
		SET @minSpeed = [dbo].[getMinimumSpeedFan](@ModelYearMin,@ModelYearMax);
		SET @maxSpeed = [dbo].[getMaximumSpeedFan](@ModelYearMin,@ModelYearMax);
		SET @minHeight = [dbo].[getMinimumHeightFan](@ModelYearMin,@ModelYearMax);
		SET @maxHeight = [dbo].[getMaximumHeightFan](@ModelYearMin,@ModelYearMax);
		select @minVoltage as [minVoltage] , @maxVoltage as [maxVoltage], @minPower as [minPower] , @maxPower as [maxPower] ,
		 @minSpeed as [minSpeed] , @maxSpeed as [maxSpeed], @minHeight as [minHeight], @maxHeight as [maxHeight]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FanVoltageFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FanVoltageFilter]
@SubCategoryName nvarchar(50),
	@minVoltage float,
	@maxVoltage float,
	@minDate smallint,
	@maxDate smallint
AS 		
BEGIN			
	DECLARE @minVolt float
	DECLARE @maxVolt float
	SET NOCOUNT ON
		SET @minVolt = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 4 AND f.Filter_ID = 1 AND tsf.Amount >= @minVoltage 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate  );
		SET @maxVolt = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 4 AND f.Filter_ID = 2 AND tsf.Amount >= @maxVoltage 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minVolt as [minVoltage]  , @maxVolt as [maxVoltage]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllCategories]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllCategories]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblCategory;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllCategoryNames]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllCategoryNames]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT Category_Name from tblCategory;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSubCategories]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetAllSubCategories]
@CategoryName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  -- Insert statements for procedure here
	SELECT SubCategory_ID, SubCategory_Name From tblSubCategory sc	
	JOIN tblCategory c ON c.Category_ID = sc.Category_ID
	where c.Category_Name = @CategoryName	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductCompare]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProductCompare]
	@Product_ID int
AS
BEGIN
	SET NOCOUNT ON;
		SELECT
		p.Series, p.Model, p.Accessories, p.Model_Year,
		m.Manufacturer_Name,
		ut.Type_Name,
		ap.Application_Name,
		mo.Location,
		ts.TechSpec_Name,
		tsf.Amount
	FROM tblProduct p
	JOIN tblManufacturer m ON m.Manufacturer_ID = p.Manufacturer_ID
	JOIN tblUseType ut ON ut.Type_ID = p.Type_ID
	JOIN tblApplication ap ON ap.Application_ID = p.Application_ID
	JOIN tblMountingLocation mo ON mo.Mounting_ID = p.Mounting_ID
	JOIN tblTechSpechFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID	 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductSummaryDescription]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProductSummaryDescription]
	@Product_ID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		p.Series, p.Model, p.Accessories, p.Model_Year,
		m.Manufacturer_Name,
		ut.Type_Name,
		ap.Application_Name,
		mo.Location
	FROM tblProduct p
	JOIN tblManufacturer m ON m.Manufacturer_ID = p.Manufacturer_ID
	JOIN tblUseType ut ON ut.Type_ID = p.Type_ID
	JOIN tblApplication ap ON ap.Application_ID = p.Application_ID
	JOIN tblMountingLocation mo ON mo.Mounting_ID = p.Mounting_ID
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductSummaryTechSpec]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetProductSummaryTechSpec]
	@Product_ID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		ts.TechSpec_Name,
		tsf.Amount
	FROM tblProduct p
	JOIN tblTechSpechFilter tsf ON tsf.Product_ID = p.Product_ID
	JOIN tblTechSpec ts ON ts.TechSpec_ID = tsf.TechSpec_ID
	JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID	 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RegisterUser]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RegisterUser]
	@UserName nvarchar(50),
	@Email nvarchar(50),
	@Password nvarchar(50),
	@Image nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
    INSERT into tblConsumer (UserName, Email, Password, Image)values (@UserName, @Email,@Password,@Image)
	Select * from tblConsumer where UserName = @UserName;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SofaLengthFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SofaLengthFilter]
@SubCategoryName nvarchar(50),
	@minLength float,
	@maxLength float,
	@minDate smallint,
	@maxDate smallint
AS 		
BEGIN			
	DECLARE @minLe float
	DECLARE @maxLe float
	SET NOCOUNT ON
		SET @minLe = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 28 AND f.Filter_ID = 3 AND tsf.Amount >= @minLength  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxLe = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 28 AND f.Filter_ID = 3 AND tsf.Amount >= @maxLength  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minLe as [minLength]  , @maxLe as [maxLength]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_SofaSubCategorySetFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SofaSubCategorySetFilter]
	@ModelYearMin smallint,
	@ModelYearMax smallint
AS
BEGIN
	DECLARE @minLength float
	DECLARE @maxLength float

	SET NOCOUNT ON
		SET @minLength = [dbo].[getMinimumLengthSofa](@ModelYearMin,@ModelYearMax);
		SET @maxLength = [dbo].[getMaximumLengthSofa](@ModelYearMin,@ModelYearMax);
		select @minLength as [minLength] , @maxLength as [maxLength]		 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TabletRAMFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TabletRAMFilter]
@SubCategoryName nvarchar(50),
	@minRAM float,
	@maxRAM float,
	@minDate smallint,
	@maxDate smallint
	
AS 		
BEGIN			
	DECLARE @minRa float
	DECLARE @maxRa float
	SET NOCOUNT ON
		SET @minRa = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 11 AND f.Filter_ID = 3 AND tsf.Amount >= @minRAM  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxRa = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 11 AND f.Filter_ID = 3 AND tsf.Amount >= @maxRAM 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minRa as [minStorage] , @maxRa as [maxStorage] 		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TabletScreenFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TabletScreenFilter]
@SubCategoryName nvarchar(50),
	@minScreen float,
	@maxScreen float,
	@minDate smallint,
	@maxDate smallint
	
AS 		
BEGIN			
	DECLARE @minSc float
	DECLARE @maxSC float
	SET NOCOUNT ON
		SET @minSc = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 14 AND f.Filter_ID = 3 AND tsf.Amount >= @minScreen  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxSC = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 14 AND f.Filter_ID = 3 AND tsf.Amount >= @maxScreen 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minSc as [minScreen] , @maxSc as [maxScreen] 		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TabletStorageFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TabletStorageFilter]
@SubCategoryName nvarchar(50),
	@minStorage float,
	@maxStorage float,
	@minDate smallint,
	@maxDate smallint
	
AS 		
BEGIN			
	DECLARE @minSt float
	DECLARE @maxSt float
	SET NOCOUNT ON
		SET @minSt = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 16 AND f.Filter_ID = 3 AND tsf.Amount >= @minStorage  
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		SET @maxSt = (SELECT	
			p.Product_ID
			FROM tblTechSpec ts			
			JOIN tblTechSpecFilter tsf ON tsf.TechSpec_ID = ts.TechSpec_ID
			JOIN tblProduct p ON p.Product_ID = tsf.Product_ID
			JOIN tblFilter f ON f.Filter_ID = tsf.Filter_ID
			JOIN tblTechSpecSubCategory tssc ON  tssc.TechSpec_ID = ts.TechSpec_ID
			JOIN tblSubCategory sc ON sc.SubCategory_ID = tssc.SubCategory_ID
			Where sc.SubCategory_Name = @SubCategoryName AND
				ts.TechSpec_ID = 16 AND f.Filter_ID = 3 AND tsf.Amount >= @maxStorage 
				AND p.Model_Year >= @minDate AND p.Model_Year <= @maxDate );
		select  @minSt as [minStorage] , @maxSt as [maxStorage] 		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TabletSubCategorySetFilter]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_TabletSubCategorySetFilter]
	@ModelYearMin smallint,
	@ModelYearMax smallint
AS
BEGIN
	DECLARE @minScreen float
	DECLARE @maxScreen float
	DECLARE @minStorage float
	DECLARE @maxStorage float
	DECLARE @minRAM float
	DECLARE @maxRAM float
	SET NOCOUNT ON
		SET @minScreen = [dbo].[getMinimumScreenSizeTablet](@ModelYearMin,@ModelYearMax);
		SET @maxScreen = [dbo].[getMaximumScreenSizeTablet](@ModelYearMin,@ModelYearMax);
		SET @minStorage = [dbo].[getMinimumStorageTablet](@ModelYearMin,@ModelYearMax);
		SET @maxStorage = [dbo].[getMaximumStorageTablet](@ModelYearMin,@ModelYearMax);
		SET @minRAM = [dbo].[getMinimumRAM](@ModelYearMin,@ModelYearMax);
		SET @maxRAM = [dbo].[getMaximumRAM](@ModelYearMin,@ModelYearMax);		
		select @minScreen as [minScreen] , @maxScreen as [maxScreen], @minStorage as [minStorage] , @maxStorage as [maxStorage] ,
		 @minRAM as [minRAM] , @maxRAM as [maxRAM]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UserValidation]    Script Date: 2/19/2021 11:27:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserValidation]
	--@UserName nvarchar(50),
	@Input nvarchar(50),
	@Password nvarchar(50)
	--@Image varbinary(max)
AS
BEGIN
	SET NOCOUNT ON;
	if([dbo].[checkInput](@Input)=1)
		----INSERT into tblConsumer (UserName, Email, Password, Image)values (@UserName, @Email,@Password,@Image)
		--UPDATE tblConsumer
		--SET Email = 'tim@timmm.com'
		--WHERE User_ID = 1; 
		begin
		if((Select Password from tblConsumer where Email = @Input)=@Password) 
		Select * from tblConsumer where Password = @Password
		else
		Select * from tblConsumer where UserName = 'test'
		end
	else if([dbo].[checkInput](@Input)=2)
		begin
		if((Select Password from tblConsumer where UserName = @Input)=@Password) 
		Select * from tblConsumer where Password = @Password
		else
		Select * from tblConsumer where UserName = 'test'
		end
		else
		Select * from tblConsumer where UserName = 'test'
END
GO
USE [master]
GO
ALTER DATABASE [MarketplaceWebPortalData] SET  READ_WRITE 
GO
