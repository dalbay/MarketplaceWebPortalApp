USE [master]
GO
/****** Object:  Database [MarketplaceWebPortalData]    Script Date: 2/19/2021 1:19:51 PM ******/
CREATE DATABASE [MarketplaceWebPortalData]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MarketplaceWebPortalData', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MarketplaceWebPortalData.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MarketplaceWebPortalData_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MarketplaceWebPortalData_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
EXEC sys.sp_db_vardecimal_storage_format N'MarketplaceWebPortalData', N'ON'
GO
ALTER DATABASE [MarketplaceWebPortalData] SET QUERY_STORE = OFF
GO
USE [MarketplaceWebPortalData]
GO
/****** Object:  UserDefinedFunction [dbo].[checkInput]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumAirflowFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumDiameterFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumHeightFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumLengthSofa]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumPowerFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumRAM]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumScreenSizeTablet]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumSoundFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumSpeedFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumStorageTablet]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMaximumVoltageFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumAirflowFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumDiameterFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumHeightFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumLengthSofa]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumPowerFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumRAM]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumScreenSizeTablet]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumSoundFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumSpeedFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumStorageTablet]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[getMinimumVoltageFan]    Script Date: 2/19/2021 1:19:51 PM ******/
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
/****** Object:  Table [dbo].[tblTechSpecSubCategory]    Script Date: 2/19/2021 1:19:51 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechSpecFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechSpec]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSubCategory]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_FilterTable]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  Table [dbo].[tblApplication]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCategory]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblConsumer]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblManufacturer]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMountingLocation]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTechnicalSpecifiactionNonValue]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUseType]    Script Date: 2/19/2021 1:19:52 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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
/****** Object:  StoredProcedure [dbo].[sp_FanFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FanHeightFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FanPoweFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FanSpeedFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FanSubCategorySetFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_FanVoltageFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetAllCategories]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetAllCategoryNames]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetAllSubCategories]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetProductCompare]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetProductSummaryDescription]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_GetProductSummaryTechSpec]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_RegisterUser]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_SofaLengthFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_SofaSubCategorySetFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_TabletRAMFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_TabletScreenFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_TabletStorageFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_TabletSubCategorySetFilter]    Script Date: 2/19/2021 1:19:52 PM ******/
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
/****** Object:  StoredProcedure [dbo].[sp_UserValidation]    Script Date: 2/19/2021 1:19:52 PM ******/
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
