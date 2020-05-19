CREATE PROCEDURE [dbo].[spTokenEvent]
	@pTxHash varchar(20), @pEvent varchar(20), @pToken VARCHAR(10) = '', @pFromChain VARCHAR(20) = '', @pFromBlock varchar(20) = '', @pFromAddr VARCHAR(50) = '', 
    @pToAddr VARCHAR(50) = '', @pValue DECIMAL(28,12) = 0, @pMemo VARCHAR(50) = '', 
    @pClaimBy VARCHAR(50) = '', @pClaimBlock varchar(20) = '', @pFee DECIMAL(28,12) = 0,
    @pDestChain VARCHAR(20) = '', @pDestBlock VARCHAR(20) = '', @pDestAddr VARCHAR(50) = ''
AS
	-- A MemoTransfer will always generate a Transfer but either can come first and we don't want duplicates

	IF @pEvent = 'Transfer' BEGIN
		IF EXISTS(SELECT 1 FROM TokenEvents WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr) BEGIN
			SELECT * FROM TokenEvents WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr FOR JSON PATH
			RETURN 0
		END

		INSERT INTO TokenEvents (TxHash, [Block], Operation, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
			VALUES (@pTxHash, @pFromBlock, @pEvent, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)

		SELECT @pDestChain = @pFromChain, @pDestBlock = @pFromBlock, @pDestAddr = @pToAddr
		INSERT INTO TokenTxs (TxHash, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
			VALUES (@pTxHash, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)
	END

	IF (@pEvent = 'MemoTransfer' OR @pEvent = 'CBTransfer') BEGIN
		IF (@pDestChain = '') SELECT @pDestChain = @pFromChain, @pDestBlock = @pFromBlock, @pDestAddr = @pToAddr
		IF EXISTS(SELECT 1 FROM TokenEvents WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr) BEGIN
			UPDATE TokenEvents SET Operation = @pEvent, Memo = @pMemo, DestChain = @pDestChain, DestBlock = @pDestBlock, DestAddr = @pDestAddr 
				WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr
			UPDATE TokenTxs SET Memo = @pMemo, DestChain = @pDestChain, DestBlock = @pDestBlock, DestAddr = @pDestAddr 
				WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr
		END ELSE BEGIN
			INSERT INTO TokenEvents (TxHash, [Block], Operation, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
				VALUES (@pTxHash, @pFromBlock, @pEvent, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)
			INSERT INTO TokenTxs (TxHash, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
				VALUES (@pTxHash, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)
		END
	END

	SELECT * FROM TokenEvents WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr FOR JSON PATH





	--IF @pEvent = 'CBDone' BEGIN
	--	UPDATE TokenTxs SET destBlock = @pdestBlock WHERE Id = @pID
	--	-- TODO Change pID to TxHash
	--END

RETURN 0



