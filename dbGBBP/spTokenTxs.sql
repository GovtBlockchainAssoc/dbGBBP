﻿CREATE PROCEDURE [dbo].[spTokenTxs]
	@pMemberId int
AS

DECLARE @Txs TABLE (Id int IDENTITY(1,1), TxId int, My_Chain varchar(20), My_Addr varchar(50), Token varchar(10), Amount decimal(28, 12), Memo varchar(MAX), 
	Their_Name varchar(50), Their_Chain varchar(20), Their_Addr varchar(50), Addr varchar(50), Date_Time varchar(50), Updated datetime2, FromBlock varchar(20), Balance decimal(28, 12))

INSERT INTO @Txs (TxId, My_Chain, My_Addr, Token, Amount, Memo, Their_Chain, Their_Addr, Addr, Date_Time, Updated, FromBlock) 
	(SELECT tx.Id, FromChain, FromAddr, Token, -1 * Value, Memo, DestChain, DestAddr, DestAddr, FORMAT(Updated, 'M/d/yy h:mm:ss tt'), DATEADD(minute, DATEDIFF(minute, 0, Updated), 0) AS Updated, FromBlock 
	FROM TokenTxs tx INNER JOIN MemberAddrs a ON tx.FromAddr = a.Address WHERE MemberId = @pMemberId
	UNION
	SELECT tx.Id, DestChain, DestAddr, Token, Value, Memo, FromChain, FromAddr, FromAddr, FORMAT(Updated, 'M/d/yy h:mm:ss tt'), DATEADD(minute, DATEDIFF(minute, 0, Updated), 0) AS Updated, FromBlock 
	FROM TokenTxs tx INNER JOIN MemberAddrs a ON tx.DestAddr = a.Address WHERE MemberId = @pMemberId)
	ORDER BY Updated, FromBlock

UPDATE @Txs SET Amount = Amount/(POWER(10, Decimals)) FROM @Txs tx INNER JOIN GBATokens t ON t.Symbol = tx.Token
UPDATE @Txs SET Their_Name = m.[Name] FROM @Txs tx INNER JOIN MemberAddrs ma ON ma.Address = tx.Addr INNER JOIN Members m ON m.Id = ma.MemberId

DECLARE @Tokens TABLE (PocketId int identity(1,1), Chain varchar(20), Addr varchar(50), Token varchar(10), Balance decimal(28, 12), Actions varchar(100))
DECLARE @TokenTxs TABLE (Id int identity(1,1), PocketId int, TxId int, Amount decimal(28, 12), Balance decimal(28, 12))

INSERT INTO @Tokens (Token, Chain, Addr) 
	SELECT DISTINCT Token, My_Chain, My_Addr FROM @Txs
INSERT INTO @TokenTxs (PocketId, TxId, Amount) SELECT PocketId, Id, Amount
	FROM @Txs x INNER JOIN @Tokens t ON x.My_Chain = t.Chain AND x.My_Addr = t.Addr AND x.Token = t.Token
	ORDER BY PocketId, Updated, FromBlock

DECLARE @id int, @pocketId int, @amount decimal(28, 12), @oldPocketId int, @balance decimal(28, 12)
SET @oldPocketId = 0
DECLARE cursor_txs CURSOR FOR SELECT Id, PocketId, Amount FROM @TokenTxs
OPEN cursor_txs
FETCH NEXT FROM cursor_txs INTO @id, @pocketId, @amount
WHILE @@FETCH_STATUS = 0 BEGIN
	IF @pocketId = @oldPocketId SET @balance = @balance + @amount ELSE SET @balance = @amount
	SET @oldPocketId = @pocketId
	UPDATE @TokenTxs SET Balance = @balance WHERE Id = @id
	UPDATE @Tokens SET Balance = @balance WHERE PocketId = @pocketId
	FETCH NEXT FROM cursor_txs INTO @id,  @pocketId, @amount
END;
CLOSE cursor_txs
UPDATE @Txs SET Balance = tt.Balance FROM @Txs t INNER JOIN @TokenTxs tt ON tt.TxId = t.Id

-- SELECT * FROM @Tokens
-- SELECT * FROM @Txs ORDER BY DTS Desc, Id Desc
SELECT (SELECT * FROM @Tokens FOR JSON PATH) AS table1, (SELECT * FROM @Txs ORDER BY Updated Desc, FromBlock Desc, Id Desc FOR JSON PATH) AS table2 FOR JSON PATH

RETURN 0
