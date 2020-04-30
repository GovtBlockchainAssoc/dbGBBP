CREATE TABLE [dbo].[MemberAddrs]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [MemberId] INT NOT NULL, 
    [BlockchainId] INT NOT NULL, 
    [Address] VARCHAR(50) NOT NULL, 
    [Primary] INT NOT NULL DEFAULT 1, 
    CONSTRAINT [FK_MemberAddrs_Blockchains] FOREIGN KEY ([BlockchainId]) REFERENCES [Blockchains]([Id])
)
