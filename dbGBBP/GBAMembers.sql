CREATE TABLE [dbo].[GBAMembers] (
    [ID]                  NUMERIC (20)   IDENTITY (4600, 1) NOT NULL,
    [user_login]          NVARCHAR (60)  NOT NULL,
    [user_pass]           NVARCHAR (255) NOT NULL,
    [user_nicename]       NVARCHAR (50)  NOT NULL,
    [user_email]          NVARCHAR (100) NOT NULL,
    [user_url]            NVARCHAR (100) NOT NULL,
    [user_registered]     DATETIME2 (0)  NOT NULL,
    [user_activation_key] NVARCHAR (255) NOT NULL,
    [user_status]         NVARCHAR (10)  NOT NULL,
    [display_name]        NVARCHAR (250) NOT NULL
);

