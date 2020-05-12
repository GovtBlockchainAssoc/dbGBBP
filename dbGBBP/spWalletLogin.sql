CREATE PROCEDURE [dbo].[spWalletLogin]
	@pAddress varchar(50)
AS
	DECLARE @id int

	SELECT @id = MemberId FROM MemberAddrs WHERE Address = @pAddress
	UPDATE Members SET LastLogin = SYSDATETIME() WHERE Id = @id
	SELECT * FROM Members WHERE Id = @id FOR JSON PATH

RETURN 0
