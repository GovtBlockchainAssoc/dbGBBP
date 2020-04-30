CREATE PROCEDURE [dbo].[spMemberEvent]
	@pBlock int,
	@pEvent varchar(20),
	@pOrigin varchar(50),
	@pId int,
	@pElement varchar(20),
	@pData varchar(MAX),
	@pOldData varchar(MAX)
AS
	IF @pEvent = 'InfoAdd' BEGIN
		INSERT INTO MemberEvents (GBAId, [Block], Operation, Origin, Element, [Data], OldData) 
			VALUES (@pId, @pBlock, @pEvent, @pOrigin, @pElement, @pData, @pOldData)
		SELECT * FROM MemberEvents WHERE Id = @@IDENTITY FOR JSON PATH
	END

	-- TODO Handle InfoDelete & InfoReplace

RETURN 0
