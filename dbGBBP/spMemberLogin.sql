CREATE PROCEDURE [dbo].[spMemberLogin]
	@pGBAId int,
	@pName varchar(50),
	@pEmail varchar(50)
AS
	DECLARE @id int
	SELECT @id = Id FROM Members WHERE GBAId = @pGBAId
	IF @id IS NULL
		INSERT INTO Members (GBAId, Name, Email) VALUES (@pGBAId, @pName, @pEmail);
	ELSE UPDATE Members SET LastLogin = SYSDATETIME() WHERE GBAId = @pGBAId
	SELECT * FROM Members WHERE GBAId = @pGBAId FOR JSON PATH

RETURN 0
