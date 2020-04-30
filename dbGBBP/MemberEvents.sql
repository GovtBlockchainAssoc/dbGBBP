CREATE TABLE [dbo].[MemberEvents]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1), 
    [GBAId] INT NOT NULL, 
    [Block] INT NOT NULL DEFAULT 0,
    [Operation] VARCHAR(20) NOT NULL,
    [Origin] VARCHAR(50) NOT NULL, 
    [Element] VARCHAR(20) NOT NULL, 
    [Data] VARCHAR(MAX) NOT NULL, 
    [OldData] VARCHAR(MAX) NOT NULL DEFAULT '', 
    [Created] DATETIME2 NOT NULL DEFAULT SYSDATETIME()
)
GO
CREATE INDEX [IX_MemberEvents_GBAId_Block] ON [dbo].[MemberEvents] (GBAId, [Block])
GO
