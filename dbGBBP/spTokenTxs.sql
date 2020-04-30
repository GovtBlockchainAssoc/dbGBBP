CREATE PROCEDURE [dbo].[spTokenTxs]
	@pMemberId int
AS

DECLARE @Txs TABLE (Token varchar(10), Amount decimal(28, 12), Memo varchar(MAX), [Name] varchar(50), Chain varchar(20), Addr varchar(50),	DTS	datetime2)

INSERT INTO @Txs (Token, Amount, Memo, Chain, Addr, DTS) SELECT Token, -1 * Value, Memo, FromChain, FromAddr, Updated 
	FROM TokenTxs tx INNER JOIN MemberAddrs a ON tx.FromAddr = a.Address WHERE MemberId = @pMemberId

INSERT INTO @Txs (Token, Amount, Memo, Chain, Addr, DTS) SELECT Token, Value, Memo, FromChain, FromAddr, Updated 
	FROM TokenTxs tx INNER JOIN MemberAddrs a ON tx.ToAddr = a.Address WHERE MemberId = @pMemberId

UPDATE @Txs SET Amount = Amount/(POWER(10, Decimals)) FROM @Txs tx INNER JOIN GBATokens t ON t.Symbol = tx.Token
UPDATE @Txs SET [Name] = m.[Name] FROM @Txs tx INNER JOIN MemberAddrs ma ON ma.Address = tx.Addr INNER JOIN Members m ON m.Id = ma.MemberId

SELECT * FROM @Txs ORDER BY DTS DESC FOR JSON PATH

RETURN 0
