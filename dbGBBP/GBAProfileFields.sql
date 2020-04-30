CREATE TABLE [dbo].[GBAProfileFields] (
    [id]                NUMERIC (20)   IDENTITY (519, 1) NOT NULL,
    [group_id]          NUMERIC (20)   NOT NULL,
    [parent_id]         NUMERIC (20)   NOT NULL,
    [type]              NVARCHAR (150) NOT NULL,
    [name]              NVARCHAR (150) NOT NULL,
    [description]       NVARCHAR (MAX) NOT NULL,
    [is_required]       SMALLINT       NOT NULL,
    [is_default_option] SMALLINT       NOT NULL,
    [field_order]       BIGINT         NOT NULL,
    [option_order]      BIGINT         NOT NULL,
    [order_by]          NVARCHAR (15)  NOT NULL,
    [can_delete]        SMALLINT       NOT NULL
);

