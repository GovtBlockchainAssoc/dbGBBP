CREATE TABLE [dbo].[GBATokens]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [Symbol] VARCHAR(10) NOT NULL, 
    [Name] VARCHAR(20) NOT NULL, 
    [Decimals] INT NOT NULL, 
    [HubAddr] VARCHAR(50) NOT NULL
)
