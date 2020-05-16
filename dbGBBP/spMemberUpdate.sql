CREATE PROCEDURE [dbo].[spMemberUpdate]
	@pId		int, 
	@pName		varchar(50), 
	@pEmail		varchar(50), 
	@pStatusId	int, 
	@pStatusStr	varchar(20),
	@pBChain	int,
	@pAddress	varchar(50)
AS

	UPDATE Members SET Name = @pName, Email = @pEmail, StatusId = @pStatusId, StatusStr = @pStatusStr WHERE Id = @pId
	IF (ISNULL(@pAddress, '') != '' AND ISNULL(@pBChain, 0) != 0 AND
		NOT(EXISTS(SELECT 1 FROM MemberAddrs WHERE MemberId = @pId AND BlockchainId = @pBChain AND Address = @pAddress)))
			INSERT INTO MemberAddrs (MemberId, BlockchainId, Address) VALUES (@pId, @pBChain, @pAddress)

	SELECT * FROM Members WHERE Id = @pId FOR JSON PATH

RETURN 0
