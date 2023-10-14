CREATE DATABASE EJEMPLO2_Prueba
 
GO
USE EJEMPLO2_Prueba
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE CLIENTES (
    ID_CLIENTE int IDENTITY(1,1) NOT NULL,
    NOMBRE varchar(50) NULL,
    TELEFONO varchar(10) NULL,
    DIRECCION varchar(80) NULL,
    PRIMARY KEY CLUSTERED 
    (
        ID_CLIENTE ASC
    )
) ON [PRIMARY];

CREATE TABLE [dbo].[DETALLE_FACTURA](
    [NUM_FACTURA] [int] NOT NULL,
    [ID_PRODUCTO] [int] NOT NULL,
    [CANTIDAD] [int] NOT NULL,
    [PRECIO_VENTA] [decimal](10, 2) NOT NULL,
    CONSTRAINT [PK_DETALLE] PRIMARY KEY CLUSTERED 
    (
        [NUM_FACTURA] ASC,
        [ID_PRODUCTO] ASC
    )
) ON [PRIMARY];

CREATE TABLE [dbo].[FACTURA](
    [NUM_FACTURA] [int] IDENTITY(1,1) NOT NULL,
    [ID_CLIENTE] [int] NOT NULL,
    [FECHA] [date] NULL,
    [ESTADO] [varchar](20) NULL,
    PRIMARY KEY CLUSTERED 
    (
        [NUM_FACTURA] ASC
    )
) ON [PRIMARY];

CREATE TABLE PRODUCTOS (
    ID_PRODUCTO int IDENTITY(1,1) NOT NULL,
    DESCRIPCION varchar(80) NOT NULL,
    PRECIO decimal(10, 2) NOT NULL,
    EXISTENCIA decimal(10, 2) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        ID_PRODUCTO ASC
    )
) ON [PRIMARY];
GO
ALTER TABLE [dbo].[FACTURA] ADD  DEFAULT (getdate()) FOR [FECHA]
GO
ALTER TABLE [dbo].[FACTURA] ADD  DEFAULT ('PENDIENTE') FOR [ESTADO]
GO
ALTER TABLE [dbo].[DETALLE_FACTURA]  WITH CHECK ADD FOREIGN KEY([ID_PRODUCTO])
REFERENCES [dbo].[PRODUCTOS] ([ID_PRODUCTO])
GO
ALTER TABLE [dbo].[DETALLE_FACTURA]  WITH CHECK ADD FOREIGN KEY([NUM_FACTURA])
REFERENCES [dbo].[FACTURA] ([NUM_FACTURA])
GO
ALTER TABLE [dbo].[FACTURA]  WITH CHECK ADD FOREIGN KEY([ID_CLIENTE])
REFERENCES [dbo].[CLIENTES] ([ID_CLIENTE])
GO
/****** Object:  StoredProcedure [dbo].[ANULAR_FACTURA]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ANULAR_FACTURA](@NUMFACTURA INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA) 
			SET @MSJ='LA FACTURA NO EXISTE'
		ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ESTADO='CANCELADA') 
					BEGIN
						UPDATE FACTURA SET ESTADO='ANULADA' 
						WHERE NUM_FACTURA=@NUMFACTURA
						SET @MSJ='FACTURA ANULADA'
					END
				ELSE
					SET @MSJ='LA FACTURA NO SE HA CANCELADO POR LO TANTO NO SE PUEDE ANULAR'
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[BUSCAR]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BUSCAR](@IDCLIENTE INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM CLIENTES WHERE ID_CLIENTE=@IDCLIENTE) 
			SET @MSJ='EL CLIENTE NO SE ENCUENTRA'
		ELSE
			BEGIN
				SELECT ID_CLIENTE,NOMBRE,TELEFONO,DIRECCION FROM CLIENTES
				WHERE ID_CLIENTE=@IDCLIENTE
				SET @MSJ='CLIENTE ENCONTRADO'
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[ELIMINAR]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[ELIMINAR](@IDCLIENTE INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM CLIENTES WHERE ID_CLIENTE=@IDCLIENTE) 
			SET @MSJ='EL CLIENTE NO EXISTE'
		ELSE
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE ID_CLIENTE=@IDCLIENTE) 
					BEGIN
						DELETE FROM CLIENTES WHERE ID_CLIENTE=@IDCLIENTE
						SET @MSJ='CLIENTE ELIMINADO'
					END
				ELSE
					SET @MSJ='EL CLIENTE NO SE PUEDE ELIMINAR YA QUE TIENE FACTURAS ASOCIADOS'
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[ELIMINAR_DETALLE]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO


CREATE OR ALTER PROCEDURE [dbo].[ELIMINAR_DETALLE] (@NUMFACTURA INT, @IDPRODUCTO INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA) 
				SET @MSJ='LA FACTURA NO EXISTE'
			ELSE
				BEGIN
					IF EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ESTADO='PENDIENTE') 
						BEGIN
							BEGIN TRAN
								DELETE DETALLE_FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO
								IF ((SELECT COUNT(ID_PRODUCTO) FROM DETALLE_FACTURA WHERE NUM_FACTURA=@NUMFACTURA)=0)
									BEGIN
										DELETE FACTURA WHERE NUM_FACTURA=@NUMFACTURA
										SET @MSJ='EL DETALLE Y LA FACTURA FUERON ELIMINADOS'
									END
								ELSE
									SET @MSJ='DETALLE ELIMINAD0'
							COMMIT
						END
					ELSE
						SET @MSJ='LA FACTURA NO SE PUEDE MODIFICAR YA QUE SE ENCUENTRA CANCELADA O ANULADA'
				END
		END TRY
		BEGIN CATCH
			SET @MSJ=ERROR_MESSAGE()
			ROLLBACK TRAN
		END CATCH
	END

GO
/****** Object:  StoredProcedure [dbo].[ELIMINAR_FACTURA]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[ELIMINAR_FACTURA] (@NUMFACTURA INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		BEGIN TRY
			IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA) 
				SET @MSJ='LA FACTURA NO EXISTE'
			ELSE
				BEGIN
					IF EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ESTADO='PENDIENTE') 
						BEGIN
							BEGIN TRAN
								DELETE DETALLE_FACTURA WHERE NUM_FACTURA=@NUMFACTURA
								DELETE FACTURA WHERE NUM_FACTURA=@NUMFACTURA
								SET @MSJ='FACTURA ELIMINADA'
							COMMIT
						END
					ELSE
						SET @MSJ='LA FACTURA NO SE PUEDE ELIMINAR YA QUE SE ENCUENTRA CANCELADA O ANULADA'
				END
		END TRY
		BEGIN CATCH
			SET @MSJ=ERROR_MESSAGE()
			ROLLBACK TRAN
		END CATCH
	END

GO
/****** Object:  StoredProcedure [dbo].[ELIMINAR_PRODUCTO]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************************************************************************************
CREATE OR ALTER PROCEDURE [dbo].[ELIMINAR_PRODUCTO](@IDPRODUCTO INT, @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM PRODUCTOS WHERE ID_PRODUCTO=@IDPRODUCTO) 
			SET @MSJ='EL PRODUCTO NO EXISTE'
		ELSE
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM DETALLE_FACTURA WHERE ID_PRODUCTO=@IDPRODUCTO) 
					BEGIN
						DELETE FROM PRODUCTOS WHERE ID_PRODUCTO=@IDPRODUCTO
						SET @MSJ='PRODUCTO ELIMINADO'
					END
				ELSE
					SET @MSJ='EL PRODUCTO NO SE PUEDE ELIMINAR YA QUE TIENE FACTURAS ASOCIADAS'
			END
	END
GO
/****** Object:  StoredProcedure [dbo].[GUARDAR]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[GUARDAR](@IDCLIENTE INT OUT,
							@NOMBRE VARCHAR(50),
							@TELEFONO VARCHAR(10),
							@DIRECCION VARCHAR(80),
							@MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM CLIENTES WHERE ID_CLIENTE=@IDCLIENTE) 
			BEGIN
				INSERT INTO CLIENTES(NOMBRE,TELEFONO,DIRECCION) 
				VALUES (@NOMBRE,@TELEFONO,@DIRECCION)
				SET @MSJ='CLIENTE INGRESADO'
				SET @IDCLIENTE=IDENT_CURRENT('CLIENTES')
			END
		ELSE
			BEGIN
				UPDATE CLIENTES SET NOMBRE=@NOMBRE, 
				TELEFONO=@TELEFONO,DIRECCION=@DIRECCION
				WHERE ID_CLIENTE=@IDCLIENTE
				SET @MSJ='CLIENTE MODIFICADO'
			END
	END

GO
/****** Object:  StoredProcedure [dbo].[GUARDAR_DETALLE]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
CREATE OR ALTER PROCEDURE GUARDAR_DETALLE(@NUMFACTURA INT OUT,
								 @IDPRODUCTO INT,
								 @CANTIDAD INT,
								 @PRECIOV INT,
								 @MSJ VARCHAR(200) OUT)
	AS BEGIN
		DECLARE @CANT INT
		DECLARE @EXT INT
		DECLARE @DESCRIPCION VARCHAR(200)
		SET @EXT = (SELECT EXISTENCIA FROM PRODUCTOS WHERE ID_PRODUCTO=@IDPRODUCTO)

		IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA = @NUMFACTURA) 
			BEGIN
				SET @MSJ='NO SE PUEDE AGREGAR EL DETALLE YA QUE LA FACTURA NO EXISTE'
			END
		ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA = @NUMFACTURA AND ESTADO='PENDIENTE') 
					BEGIN
						IF (@EXT < @CANTIDAD )
							BEGIN
								SET @MSJ='CANTIDAD INSUFICIENTE'
							END
						ELSE
							BEGIN 
							IF NOT EXISTS(SELECT 1 FROM DETALLE_FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO) 
								IF @CANTIDAD <= 0
									SET @MSJ='LA CANTIDAD DE PRODUCTOS DEBE SER MAYOR A 0'
								ELSE
									BEGIN
										INSERT INTO DETALLE_FACTURA(NUM_FACTURA,ID_PRODUCTO,CANTIDAD,PRECIO_VENTA) 
										VALUES (@NUMFACTURA,@IDPRODUCTO,@CANTIDAD,@PRECIOV) 
										SET @MSJ='DETALLE DE FACTURA INGRESADO'
									END
							ELSE
								BEGIN
									SET @CANT = (SELECT CANTIDAD FROM DETALLE_FACTURA WHERE NUM_FACTURA = @NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO)
									IF ((@CANT + @CANTIDAD) <= 0)
										BEGIN
											DELETE DETALLE_FACTURA WHERE NUM_FACTURA = @NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO
											IF ((SELECT COUNT(ID_PRODUCTO) FROM DETALLE_FACTURA WHERE NUM_FACTURA=@NUMFACTURA)=0)
												BEGIN
													DELETE FACTURA WHERE NUM_FACTURA=@NUMFACTURA SET 
													@MSJ='SE ELIMINO DETALLE Y LA FACTURA'
												END
										END											
									ELSE
										IF ((@CANTIDAD) < 0)
											BEGIN
												SET @DESCRIPCION = (SELECT DESCRIPCION FROM PRODUCTOS WHERE ID_PRODUCTO = @IDPRODUCTO)
												SET @MSJ='SE DEVOLVIERON '+ CAST(@CANT AS varchar) + ' PRODUCTOS DE ' + CAST(@DESCRIPCION AS varchar)
												UPDATE DETALLE_FACTURA SET CANTIDAD=@CANTIDAD + @CANT WHERE NUM_FACTURA = @NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO
											END
										ELSE
											BEGIN
												UPDATE DETALLE_FACTURA SET CANTIDAD= @CANTIDAD + @CANT WHERE NUM_FACTURA = @NUMFACTURA AND ID_PRODUCTO=@IDPRODUCTO
												SET @DESCRIPCION = (SELECT DESCRIPCION FROM PRODUCTOS WHERE ID_PRODUCTO = @IDPRODUCTO)
												SET @MSJ= 'SE AGREGARON '+ CAST(@CANTIDAD AS varchar) + ' PRODUCTOS DE ' + CAST(@DESCRIPCION AS varchar)
										END
								END--
						END -- CANTIDAD SUFICIENTE
					END --ESTADO='PENDIENTE'
				ELSE 
					SET @MSJ='NO SE PUEDE MODIFICAR LA FACTURA YA QUE NO ESTA PENDIENTE'
			END
	END

GO
/****** Object:  StoredProcedure [dbo].[GUARDAR_FACTURA]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[GUARDAR_FACTURA](@NUMFACTURA INT OUT,
								 @IDCLIENTE INT,
								 @FECHA DATE,
								 @ESTADO VARCHAR(15),
								 @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA) 
			BEGIN
				INSERT INTO FACTURA(ID_CLIENTE,FECHA,ESTADO) 
				VALUES (@IDCLIENTE,@FECHA,@ESTADO)
				SET @MSJ='FACTURA INGRESADA'
				SET @NUMFACTURA=IDENT_CURRENT('FACTURA')
			END
		ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM FACTURA WHERE NUM_FACTURA=@NUMFACTURA AND ESTADO='PENDIENTE') 
					BEGIN
						UPDATE FACTURA SET ID_CLIENTE=@IDCLIENTE, 
						FECHA=@FECHA WHERE NUM_FACTURA=@NUMFACTURA
						SET @MSJ='FACTURA MODIFICADA'
					END
				ELSE
					SET @MSJ='NO SE PUEDE MODIFICAR LA FACTURA YA QUE NO ESTA PENDIENTE'
			END
	END

GO
/****** Object:  StoredProcedure [dbo].[GUARDAR_PRODUCTO]    Script Date: 21/1/2022 17:47:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[GUARDAR_PRODUCTO](@IDPRODUCTO INT OUT,
										  @DESCRIPCION VARCHAR(30),
										  @PRECIO DECIMAL(10,2),
										  @EXISTENCIA DECIMAL(10,2),
										  @MSJ VARCHAR(200) OUT)
	AS BEGIN
		IF NOT EXISTS(SELECT 1 FROM PRODUCTOS WHERE ID_PRODUCTO=@IDPRODUCTO) 
			BEGIN
				INSERT INTO PRODUCTOS(DESCRIPCION,PRECIO,EXISTENCIA) 
				VALUES (@DESCRIPCION,@PRECIO,@EXISTENCIA)
				SET @MSJ='PRODUCTO INGRESADO'
				SET @IDPRODUCTO=IDENT_CURRENT('PRODUCTOS')
			END
		ELSE
			BEGIN
				UPDATE PRODUCTOS SET DESCRIPCION=@DESCRIPCION, 
				PRECIO=@PRECIO, EXISTENCIA=@EXISTENCIA WHERE ID_PRODUCTO=@IDPRODUCTO
				SET @MSJ='PRODUCTO MODIFICADO'
			END 
	END
GO


/**********************************************************************/

GO
CREATE OR ALTER TRIGGER TR_ACTUALIZA_INVENTARIO
ON DETALLE_FACTURA 
INSTEAD OF INSERT, UPDATE
AS
	DECLARE @NUM_FACTURA INT, @CODIGO_PRODUCTO INT,  @CANTIDAD_VENDIDA INT,
			@EXISTENCIA INT, @PRECIOVENTA INT, @CANTIDADANTERIOR INT

	SELECT @NUM_FACTURA = NUM_FACTURA FROM inserted
	SELECT @CODIGO_PRODUCTO = ID_PRODUCTO FROM inserted
	SELECT @CANTIDAD_VENDIDA = CANTIDAD FROM inserted
	SELECT @PRECIOVENTA = PRECIO_VENTA FROM inserted
	
	SELECT @EXISTENCIA = (SELECT EXISTENCIA FROM PRODUCTOS P INNER JOIN inserted
								           ON P.ID_PRODUCTO = inserted.ID_PRODUCTO)
	--IF (@CANTIDAD_VENDIDA <= @EXISTENCIA)
	--	BEGIN
			IF NOT EXISTS(SELECT 1 FROM DETALLE_FACTURA WHERE NUM_FACTURA=@NUM_FACTURA AND ID_PRODUCTO = @CODIGO_PRODUCTO) 
					BEGIN
						UPDATE PRODUCTOS SET EXISTENCIA = @EXISTENCIA - @CANTIDAD_VENDIDA WHERE ID_PRODUCTO = @CODIGO_PRODUCTO
						INSERT INTO DETALLE_FACTURA(NUM_FACTURA,ID_PRODUCTO,CANTIDAD,PRECIO_VENTA)
							VALUES( @NUM_FACTURA,@CODIGO_PRODUCTO,@CANTIDAD_VENDIDA,@PRECIOVENTA)
					END
				ELSE
					BEGIN
						SET @CANTIDADANTERIOR = (SELECT CANTIDAD FROM DETALLE_FACTURA 
													WHERE NUM_FACTURA=@NUM_FACTURA AND ID_PRODUCTO = @CODIGO_PRODUCTO)
						UPDATE PRODUCTOS SET EXISTENCIA = @EXISTENCIA - (@CANTIDAD_VENDIDA-@CANTIDADANTERIOR) 
											WHERE ID_PRODUCTO = @CODIGO_PRODUCTO
						UPDATE DETALLE_FACTURA SET CANTIDAD = @CANTIDAD_VENDIDA 
												WHERE NUM_FACTURA=@NUM_FACTURA AND ID_PRODUCTO = @CODIGO_PRODUCTO
					END
		--END
GO
/*************************************/


GO
CREATE OR ALTER TRIGGER TR_ACTUALIZA_INVENTARIO_BORRAR
ON DETALLE_FACTURA 
INSTEAD OF DELETE
AS
	DECLARE @NUM_FACTURA INT,
			@CODIGO_PRODUCTO INT, 
	        @CANTIDAD_VENDIDA INT,
			@EXISTENCIA INT

	SELECT @NUM_FACTURA = NUM_FACTURA FROM deleted
	SELECT @CODIGO_PRODUCTO = ID_PRODUCTO FROM deleted
	SELECT @CANTIDAD_VENDIDA = CANTIDAD FROM deleted
	
	SELECT @EXISTENCIA = (SELECT EXISTENCIA 
								   FROM PRODUCTOS P INNER JOIN deleted
								   ON P.ID_PRODUCTO = deleted.ID_PRODUCTO)
	UPDATE PRODUCTOS SET EXISTENCIA = @EXISTENCIA + @CANTIDAD_VENDIDA WHERE ID_PRODUCTO = @CODIGO_PRODUCTO  
	DELETE DETALLE_FACTURA WHERE ID_PRODUCTO = @CODIGO_PRODUCTO AND NUM_FACTURA =  @NUM_FACTURA

GO

SELECT * FROM CLIENTES
SELECT * FROM PRODUCTOS
SELECT * FROM DETALLE_FACTURA
SELECT * FROM FACTURA

SELECT NUM_FACTURA,
F.ID_CLIENTE, NOMBRE, FECHA, ESTADO 
FROM FACTURA F INNER JOIN CLIENTES 
ON CLIENTES.ID_CLIENTE = F.ID_CLIENTE


-- Inserciones para la tabla CLIENTES
INSERT INTO CLIENTES (NOMBRE, TELEFONO, DIRECCION) VALUES ('Cliente1', '1234567890', 'Direcci�n1');
INSERT INTO CLIENTES (NOMBRE, TELEFONO, DIRECCION) VALUES ('Cliente2', '9876543210', 'Direcci�n2');

-- Inserciones para la tabla PRODUCTOS
INSERT INTO PRODUCTOS (DESCRIPCION, PRECIO, EXISTENCIA) VALUES ('Producto1', 20.00, 100);
INSERT INTO PRODUCTOS (DESCRIPCION, PRECIO, EXISTENCIA) VALUES ('Producto2', 15.50, 75);

-- Inserciones para la tabla FACTURA
INSERT INTO FACTURA (ID_CLIENTE, FECHA, ESTADO) VALUES (1, '2023-10-11', 'Pendiente');
INSERT INTO FACTURA (ID_CLIENTE, FECHA, ESTADO) VALUES (2, '2023-10-12', 'Pagada');

-- Inserciones para la tabla DETALLE_FACTURA
INSERT INTO DETALLE_FACTURA (NUM_FACTURA, ID_PRODUCTO, CANTIDAD, PRECIO_VENTA) VALUES (1, 1, 5, 10.00);
INSERT INTO DETALLE_FACTURA (NUM_FACTURA, ID_PRODUCTO, CANTIDAD, PRECIO_VENTA) VALUES (1,�2,�3,�15.50);

