CREATE PROCEDURE [dbo].[spMemberUpdate]
	@pId		int, 
	@pName		varchar(50), 
	@pEmail		varchar(50), 
	@pStatusId	int, 
	@pStatusStr	varchar(20),
	@pPoAAddr	varchar(50)
AS

	UPDATE Members SET Name = @pName, Email = @pEmail, StatusId = @pStatusId, StatusStr = @pStatusStr WHERE Id = @pId
	IF (@pPoAAddr != '' AND NOT(EXISTS(SELECT 1 FROM MemberAddrs WHERE MemberId = @pId AND Address = @pPoAAddr)))
		INSERT INTO MemberAddrs (MemberId, BlockchainId, Address) VALUES (@pId, 1, @pPoAAddr)

	SELECT * FROM Members WHERE Id = @pId FOR JSON PATH

RETURN 0
