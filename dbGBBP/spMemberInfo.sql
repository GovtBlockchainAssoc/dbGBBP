CREATE PROCEDURE [dbo].[spMemberInfo]
	@pEvent varchar(20),
	@pOrigin varchar(50),
	@pId int, 
	@pElement varchar(20),
	@pData varchar(MAX),
	@pOldData varchar(MAX) = ''
AS
	IF (@pElement NOT IN ('GBAId', 'Name', 'Email')) BEGIN
		SELECT 'Not handled yet!'
		RETURN -1
	END

	DECLARE @Id int, @GBAId int, @Name varchar(50), @Email varchar(50)
	SELECT @Id = Id, @GBAId = GBAId, @Name = Name, @Email = Email from Members WHERE GBAId = @pId

	IF (@pEvent = 'InfoAdd') BEGIN
		SELECT 'We''re not deleting yet!'
	END ELSE IF (@pEvent = 'InfoDelete') BEGIN
		SELECT 'We''re not deleting yet!'
	END ELSE IF (@pEvent = 'InfoReplace') BEGIN
		SELECT 'We''re not replacing yet!'
	END

RETURN 0
