CREATE PROCEDURE [dbo].[spTokenEvent]
	@pTxHash varchar(50), @pEvent varchar(20), @pToken VARCHAR(10) = '', @pFromChain VARCHAR(50) = '', @pFromBlock INT = 0, @pFromAddr VARCHAR(50) = '', 
    @pToAddr VARCHAR(50) = '', @pValue DECIMAL(28,12) = 0, @pMemo VARCHAR(50) = '', 
    @pClaimBy VARCHAR(50) = '', @pClaimBlock INT = 0, @pFee DECIMAL(28,12) = 0,
    @pDestChain VARCHAR(50) = '', @pDestBlock VARCHAR(50) = '', @pDestAddr VARCHAR(50) = ''
AS
	-- A MemoTransfer will always generate a Transfer but either can come first and we don't want duplicates

	IF @pEvent = 'Transfer' BEGIN
		IF EXISTS(SELECT 1 FROM TokenEvents WHERE TxHash = @pTxHash AND FromAddr = @pFromAddr AND ToAddr = @pToAddr) RETURN 0

		INSERT INTO TokenEvents (TxHash, [Block], Operation, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
			VALUES (@pTxHash, @pFromBlock, @pEvent, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)

		IF (@pDestChain = '') SELECT @pDestChain = @pFromChain, @pDestBlock = @pFromBlock, @pDestAddr = @pToAddr
		INSERT INTO TokenTxs (TxHash, Token, FromChain, FromBlock, FromAddr, ToAddr, Value, Memo, DestChain, DestBlock, DestAddr) 
			VALUES (@pTxHash, @pToken, @pFromChain, @pFromBlock, @pFromAddr, @pToAddr, @pValue, @pMemo, @pDestChain, @pDestBlock, @pDestAddr)
	END

	IF @pEvent = 'MemoTransfer' BEGIN
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





	--IF @pEvent = 'CBDone' BEGIN
	--	UPDATE TokenTxs SET destBlock = @pdestBlock WHERE Id = @pID
	--	-- TODO Change pID to TxHash
	--END

RETURN 0



