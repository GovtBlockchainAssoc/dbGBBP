CREATE PROCEDURE [dbo].spLogAdd
	@pApp varchar(20),
	@pSeverity int,
	@pMessage varchar(MAX)
AS
	INSERT INTO Logs (Application, Severity, Message) VALUES (@pApp, @pSeverity, @pMessage)
RETURN 0
