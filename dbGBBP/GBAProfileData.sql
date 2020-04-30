CREATE TABLE [dbo].[GBAProfileData] (
    [id]           NUMERIC (20)   IDENTITY (18293, 1) NOT NULL,
    [field_id]     NUMERIC (20)   NOT NULL,
    [user_id]      NUMERIC (20)   NOT NULL,
    [value]        NVARCHAR (MAX) NOT NULL,
    [last_updated] DATETIME2 (0)  NOT NULL
);

