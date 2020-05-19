﻿CREATE TABLE [dbo].[TokenEvents]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [TxHash] VARCHAR(50) NOT NULL,
    [Block] VARCHAR(20) NOT NULL,
    [Operation] VARCHAR(20) NOT NULL,
    [Token] VARCHAR(10) NOT NULL,
    [FromChain] VARCHAR(20) NULL,
    [FromBlock] VARCHAR(20) NULL,
    [FromAddr] VARCHAR(50) NULL, 
    [ToAddr] VARCHAR(50) NULL, 
    [Value] DECIMAL(28,12) NULL, 
    [Memo] VARCHAR(50) NULL , 
    [ClaimBy] VARCHAR(20) NULL,
    [ClaimBlock] VARCHAR(20),
    [Fee] DECIMAL(28,12) NULL ,
    [DestChain] VARCHAR(20) NULL,
    [DestBlock] VARCHAR(20), 
    [DestAddr] VARCHAR(50) NULL, 
    [Created] DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    [Updated] DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
)
