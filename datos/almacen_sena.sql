-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-08-2022 a las 01:41:48
-- Versión del servidor: 10.4.22-MariaDB
-- Versión de PHP: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `almacen_sena`
--
CREATE DATABASE IF NOT EXISTS `almacen_sena` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `almacen_sena`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `S`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `S` (IN `NOMBRE_CATEGORIA_` VARCHAR(11), IN `ID_PRODUCTO_` INT(11))  NO SQL
BEGIN
	SET @VAR = (SELECT categorias.id_categoria FROM categorias WHERE nombreCategoria = NOMBRE_CATEGORIA_);
	SET @VAR1 = (SELECT categoria_producto.id FROM categoria_producto WHERE id_producto = ID_PRODUCTO_); 
    SELECT @VAR1;
	IF (@VAR1 IS NULL) THEN
    	SELECT "HOLA";
    ELSEIF (@VAR1 IS NOT NULL) THEN 
        SELECT "HOLA";
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpAceptarSolicitudes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpAceptarSolicitudes` (IN `ID_` INT(11), IN `ESTADO_` VARCHAR(10), IN `CANTIDAD_` INT(11), IN `PRODUCTO_` INT(11))  NO SQL
BEGIN
 SET @CANTIDAD_ACTUAL = (SELECT productos.cantidad FROM productos WHERE id_producto = PRODUCTO_);
SET @CANTIDAD_TOTAL = @CANTIDAD_ACTUAL - CANTIDAD_;
IF (@CANTIDAD_TOTAL >= 0 ) THEN
	IF (ESTADO_ = "APROBADA" || ESTADO_ = "RECHAZADA") THEN
        UPDATE solicitudes SET
            estado	=	ESTADO_
            WHERE	id	=	ID_;
    ELSEIF (ESTADO_ = "ENTREGADO") THEN
            UPDATE solicitudes SET
            estado	=	ESTADO_
            WHERE	id	=	ID_;
           UPDATE productos SET cantidad = @CANTIDAD_TOTAL WHERE 		id_producto = PRODUCTO_;
           END IF;
   ELSE
   		SELECT "No hay suficiente producto" AS error;
   END IF;
END$$

DROP PROCEDURE IF EXISTS `spConsultarProductosPorCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spConsultarProductosPorCategoria` (IN `_categoria` VARCHAR(150))  BEGIN

SELECT * FROM categoria_producto as cp JOIN productos as p ON (cp.id_producto = p.id_producto) JOIN categorias as c ON (cp.id_categoria = c.id_categoria) WHERE c.nombreCategoria = _categoria;

END$$

DROP PROCEDURE IF EXISTS `spConsultarProductosPorNombre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spConsultarProductosPorNombre` (IN `_nombre` VARCHAR(150))  BEGIN

SELECT * FROM categoria_producto as cp JOIN productos as p ON (cp.id_producto = p.id_producto) WHERE p.nombreProducto = _nombre;

END$$

DROP PROCEDURE IF EXISTS `SpConsultarSolicitudesAprovadas`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultarSolicitudesAprovadas` ()  NO SQL
BEGIN
SELECT s.id, p.nombreProducto, p.id_producto, i.nombre, i.apellido, s.cantidad FROM solicitudes s INNER JOIN productos p ON (s.id_producto = p.id_producto) INNER JOIN instructores i ON (s.id_usuario = i.id_usuario) WHERE s.estado = "APROBADA";
END$$

DROP PROCEDURE IF EXISTS `SpConsultarSolicitudesPendientes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultarSolicitudesPendientes` ()  NO SQL
BEGIN
SELECT s.id, p.nombreProducto, p.id_producto, i.nombre, i.apellido, s.cantidad FROM solicitudes s INNER JOIN productos p ON (s.id_producto = p.id_producto) INNER JOIN instructores i ON (s.id_usuario = i.id_usuario) WHERE s.estado = "PENDIENTE";
END$$

DROP PROCEDURE IF EXISTS `SpConsultarTodasLasCategorias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultarTodasLasCategorias` ()  NO SQL
BEGIN
	SELECT * FROM categorias;
END$$

DROP PROCEDURE IF EXISTS `SpConsultCategorias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultCategorias` (IN `ID_PRODUCTO_` INT(11))  NO SQL
BEGIN
	SELECT * FROM categorias C INNER JOIN categoria_producto CP ON(C.id_categoria = CP.id_categoria) WHERE CP.id_producto = ID_PRODUCTO_;
END$$

DROP PROCEDURE IF EXISTS `SpConsultInstructor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultInstructor` (IN `ID_USUARIO_` INT(11))  NO SQL
SELECT * FROM instructores WHERE id_usuario = ID_USUARIO_$$

DROP PROCEDURE IF EXISTS `SpConsultInstructors`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultInstructors` ()  NO SQL
BEGIN
SELECT * FROM usuarios U INNER JOIN instructores I ON (U.id_usuario = I.id_usuario);
END$$

DROP PROCEDURE IF EXISTS `spConsultProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spConsultProducto` (IN `ID_PRODUCTO` INT(11))  NO SQL
BEGIN
SELECT * FROM productos P INNER JOIN usuarios U ON(P.usuario_id = U.id_usuario) WHERE P.id_producto = ID_PRODUCTO;
END$$

DROP PROCEDURE IF EXISTS `SpConsultProductos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultProductos` ()  NO SQL
BEGIN
SELECT * FROM productos P INNER JOIN usuarios U ON(P.usuario_id = U.id_usuario) LIMIT 10;
END$$

DROP PROCEDURE IF EXISTS `SpConsultProductosProveedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultProductosProveedor` (IN `ID_USUARIO_` INT(11))  NO SQL
BEGIN
SELECT * FROM usuarios U INNER JOIN productos P ON(U.id_usuario = P.usuario_id)  WHERE id_usuario = ID_USUARIO_;
END$$

DROP PROCEDURE IF EXISTS `SpConsultProveedores`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultProveedores` ()  NO SQL
BEGIN
SELECT * FROM usuarios U INNER JOIN proveedores I ON (U.id_usuario = I.id_usuario);
END$$

DROP PROCEDURE IF EXISTS `SpConsultSubCategorias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultSubCategorias` (IN `NOMBRE_CATEGORIA_` VARCHAR(11))  NO SQL
BEGIN
SET @VAR = (SELECT id_categoria FROM categorias WHERE categorias.nombreCategoria = NOMBRE_CATEGORIA_);
	SELECT * FROM sub_categoria WHERE sub_categoria.id_categoria = @VAR;
END$$

DROP PROCEDURE IF EXISTS `SpConsultSubCategoriasProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultSubCategoriasProducto` (IN `ID_PRODUCTO_` VARCHAR(11))  NO SQL
BEGIN
	SELECT * FROM sub_categoria_producto SCP INNER JOIN sub_categoria SC ON(SCP.id_sub_categoria = SC.id) WHERE SCP.id_producto = ID_PRODUCTO_;
END$$

DROP PROCEDURE IF EXISTS `SpConsultUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpConsultUser` (IN `EMAIL_` VARCHAR(256), IN `CLAVE_` VARCHAR(256))  NO SQL
BEGIN
SELECT id_usuario AS id, Rol AS Rol_user FROM usuarios WHERE UserName = EMAIL_ AND Password = CLAVE_;
END$$

DROP PROCEDURE IF EXISTS `spConsultUsers`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spConsultUsers` ()  NO SQL
BEGIN
SELECT id_usuario AS id, UserName AS Usuario, Password AS Contraseña, Rol AS Rol_user FROM usuarios;
END$$

DROP PROCEDURE IF EXISTS `spCountCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spCountCategoria` (IN `_categoria` VARCHAR(150))  BEGIN

SELECT COUNT(p.id_producto) FROM categoria_producto as cp JOIN productos as p ON (cp.id_producto = p.id_producto) JOIN categorias as c ON (cp.id_categoria = c.id_categoria) WHERE c.nombreCategoria = _categoria;

END$$

DROP PROCEDURE IF EXISTS `spCountNombre`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spCountNombre` (IN `_nombre` VARCHAR(150))  BEGIN

SELECT COUNT(p.id_producto) FROM categoria_producto as cp JOIN productos as p ON (cp.id_producto = p.id_producto) WHERE p.nombreProducto = _nombre;

END$$

DROP PROCEDURE IF EXISTS `SpCreateCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateCategoria` (IN `NOMBRE_` VARCHAR(50))  NO SQL
BEGIN
	INSERT INTO categorias (nombreCategoria) VALUES(NOMBRE_);
END$$

DROP PROCEDURE IF EXISTS `SpCreateInstructor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateInstructor` (IN `ID_USUARIO_` INT(11), IN `NUMERO_DOCUMENTO_` INT(12), IN `NOMBRE_` VARCHAR(50), IN `APELLIDO_` VARCHAR(50), IN `TELEFONO_` INT(10), IN `GMAIL_` VARCHAR(256))  NO SQL
BEGIN
	INSERT INTO instructores (
							numero_documento,
    						nombre,
    						apellido,
    						telefono,
    						gmail,
    						id_usuario)
                            VALUES(
                            NUMERO_DOCUMENTO_,
                            NOMBRE_,
                            APELLIDO_,
                            TELEFONO_,
                            GMAIL_,
                            ID_USUARIO_);
END$$

DROP PROCEDURE IF EXISTS `SpCreateProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateProducto` (IN `UNIDAD_MEDIDA_` VARCHAR(12), IN `NOMBRE_PRODUCTO_` VARCHAR(100), IN `CANTIDAD_` INT(5), IN `FOTO_` VARCHAR(100), IN `CONTROL_INVENTARIO_` BOOLEAN, IN `PARA_CONSUMO_` BOOLEAN, IN `PARA_VENTA_` BOOLEAN, IN `PRODUCCION_INTERNA_` BOOLEAN, IN `MANEJA_LOTES_` BOOLEAN, IN `SERVICIO_` BOOLEAN, IN `CONTEO_FISICAS_` BOOLEAN, IN `PRODUCTO_ACTIVO_` BOOLEAN, IN `DATOS_FABRICANTE_` VARCHAR(100), IN `REFERENCIA_` VARCHAR(100), IN `MEDIDAS_` VARCHAR(100), IN `PRESENTACION_` VARCHAR(100), IN `UBICACION_FISICA_` VARCHAR(100), IN `PRODUCTO_EQUIVALENTE_` VARCHAR(50), IN `UNITARIO_PROMEDIO_` DOUBLE, IN `TOTAL_PROMEDIO_` INT, IN `STOCK_MINIMO_` INT(50), IN `STOCK_MAXIMO_` INT(50), IN `TIEMPO_REPOSICION_` INT(11), IN `CUENTA_INVENTARIO_` INT(100), IN `CONTABLE_DE_INGRESOS_` VARCHAR(100), IN `CONTABLE_INGRESO_AJUSTE_` VARCHAR(100), IN `CONTABLE_DEVOLUCION_VENTAS_` VARCHAR(100), IN `CONTABLE_COSTOS_` VARCHAR(100), IN `DEVOLUCION_COMPRAS_` VARCHAR(100), IN `CONTABLE_GASTOS` VARCHAR(100), IN `CONTABLE_GASTOS_POR_AJUSTE_` VARCHAR(100), IN `IMPUESTO_COMPRAS_` VARCHAR(100), IN `IMPUESTO_VENTAS_` VARCHAR(100), IN `USUARIO_ID_` INT(11))  NO SQL
BEGIN
	INSERT INTO productos  (unidadMedida, nombreProducto, cantidad, foto, controlInventario, paraConsumo, paraVenta, produccionInterna, manejaLotes, servicio, conteoFisicas, productoActivo, datosFabricante, refetencia, medidas, presentacion, ubicacionFisica, productoEquivalente, unitarioPromedio, totalPromedio, stockMinimo, stockMaximo, tiempoReposicion, cuentaInventario, contableDeIngresos, contableIngresoAjuste, contableDevolucionVentas, contableCostos, devolucionCompras, contableGastos, contableGastosPorAjuste, impuestoCompras, impuestoVentas, usuario_id)VALUES(UNIDAD_MEDIDA_,NOMBRE_PRODUCTO_,CANTIDAD_,FOTO_,CONTROL_INVENTARIO_,PARA_CONSUMO_,PARA_VENTA_,PRODUCCION_INTERNA_,MANEJA_LOTES_,SERVICIO_,CONTEO_FISICAS_,PRODUCTO_ACTIVO_,DATOS_FABRICANTE_,REFERENCIA_,MEDIDAS_,PRESENTACION_,UBICACION_FISICA_,PRODUCTO_EQUIVALENTE_,UNITARIO_PROMEDIO_,TOTAL_PROMEDIO_,STOCK_MINIMO_,STOCK_MAXIMO_,TIEMPO_REPOSICION_,CUENTA_INVENTARIO_,CONTABLE_DE_INGRESOS_,CONTABLE_INGRESO_AJUSTE_,CONTABLE_DEVOLUCION_VENTAS_,CONTABLE_COSTOS_,DEVOLUCION_COMPRAS_,	
CONTABLE_GASTOS
,CONTABLE_GASTOS_POR_AJUSTE_, IMPUESTO_COMPRAS_, IMPUESTO_VENTAS_, USUARIO_ID_);
 END$$

DROP PROCEDURE IF EXISTS `SpCreateProveedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateProveedor` (IN `ID_USUARIO_` VARCHAR(11), IN `TIPO_PERSONA_` VARCHAR(50), IN `NUMERO_DOCUMENTO_` INT(12), IN `NIT_` VARCHAR(12), IN `RUT_` VARCHAR(11), IN `NOMBRE_` VARCHAR(18), IN `APELLIDO_` VARCHAR(50), IN `RAZON_SOCIAL` VARCHAR(500), IN `CODIGO_PAIS_` VARCHAR(11), IN `NOMBRE_PAIS_` VARCHAR(75), IN `CODIGO_CIUDAD_` VARCHAR(11), IN `NOMBRE_CIUDAD` INT(75), IN `DIRECION_` VARCHAR(150), IN `TELEFONO_` INT(10), IN `GMAIL_` VARCHAR(256), IN `AUTORIZACION_GMAIL_` BOOLEAN, IN `CODIGO_DEPARTAMENTO_` VARCHAR(11), IN `NOMBRE_DEPARTAMENTO` VARCHAR(11))  NO SQL
BEGIN
INSERT INTO proveedores (
    					Tipo_persona,
    					Numero_documento,
    					NIT,
    					RUT,
    					Nombre,
    					Apellido,
    					Razon_social,
    					Codigo_pais,
    					Nombre_Pais,
    					Codigo_departamento,
    					Nombre_departamento,
    					Codigo_ciudad,
    					Nombre_ciudad,
    					Direccion,
    					Telefono,
    					Gmail,
    					Autorizacion_Gmail,
    					id_usuario
						)VALUES(
                            TIPO_PERSONA_,
                            NUMERO_DOCUMENTO_,
                            NIT_,
                            RUT_,
                            NOMBRE_,
                            APELLIDO_,
                            RAZON_SOCIAL,
                            CODIGO_PAIS_,
                            NOMBRE_PAIS_,                        						        CODIGO_DEPARTAMENTO_,
                            NOMBRE_DEPARTAMENTO,
                            CODIGO_CIUDAD_,
                            NOMBRE_CIUDAD,
                            DIRECION_,
                            TELEFONO_,
                            GMAIL_,
                            AUTORIZACION_GMAIL_,
                            ID_USUARIO_
                        );
END$$

DROP PROCEDURE IF EXISTS `SpCreateSolicitud`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateSolicitud` (IN `ID_USUARIO_` INT(11), IN `ID_PRODUCTO_` INT(11), IN `CANTIDAD_` INT(11))  NO SQL
BEGIN
INSERT INTO solicitudes ( solicitudes.id_producto,  solicitudes.id_usuario, solicitudes.cantidad, solicitudes.estado) VALUES (ID_PRODUCTO_, ID_USUARIO_, CANTIDAD_, "PENDIENTE");
END$$

DROP PROCEDURE IF EXISTS `SpCreateSubCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateSubCategoria` (IN `NOMBRE_CATEGORIA_` VARCHAR(11), IN `NOMBRE_SUB_CATEGORIA_` VARCHAR(11))  NO SQL
BEGIN
	SET @VAR = (SELECT id_categoria FROM categorias WHERE categorias.nombreCategoria = NOMBRE_CATEGORIA_);
	INSERT INTO sub_categoria (id_categoria, nombreCategoria) VALUES(@VAR, NOMBRE_SUB_CATEGORIA_);
END$$

DROP PROCEDURE IF EXISTS `SpCreateUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpCreateUser` (IN `EMAIL_` VARCHAR(256), IN `CLAVE_` VARCHAR(250), IN `ROL_` VARCHAR(11))  NO SQL
BEGIN
    INSERT INTO usuarios (UserName, Password, Rol)VALUES (EMAIL_, CLAVE_, ROL_);
    IF (ROL_ = "INSTRUCTOR") THEN
    	CALL SpCreateInstructor(@@IDENTITY, 0, 0, 0, 0, 0);
	ELSEIF (ROL_ = "PROVEEDOR") THEN
    	CALL SpCreateProveedor(@@IDENTITY, "JURIDICA", 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpDeleteInstructor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDeleteInstructor` (IN `ID_INSTRUCTOR_` INT(11))  NO SQL
BEGIN
	 SELECT @VAR:= id_usuario FROM instructores WHERE Id_instructor = 	ID_INSTRUCTOR_;
	DELETE FROM instructores WHERE id_instructor = ID_INSTRUCTOR_;
    DELETE FROM usuarios WHERE id_usuario = @VAR;
END$$

DROP PROCEDURE IF EXISTS `SpDeleteProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDeleteProducto` (IN `ID_` INT(11))  NO SQL
BEGIN
	DELETE FROM productos WHERE id_producto = ID_;
END$$

DROP PROCEDURE IF EXISTS `SpDeleteUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpDeleteUser` (IN `ID_USUARIO_` INT(11))  NO SQL
BEGIN
	SET @ROL = (SELECT Rol FROM usuarios WHERE id_usuario = ID_USUARIO_);
	DELETE FROM usuarios WHERE id_usuario = ID_USUARIO_;
    IF @ROL = "INSTRUCTOR" THEN
    	DELETE FROM instructores WHERE id_usuario = ID_USUARIO_;
    ELSEIF @ROL = "PROVEEDOR" THEN
    	DELETE FROM proveedores WHERE id_usuario  = ID_USUARIO_;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpInsertCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpInsertCategoria` (IN `NOMBRE_CATEGORIA_` VARCHAR(11), IN `ID_PRODUCTO_` INT(11))  NO SQL
BEGIN
	SET @VAR = (SELECT categorias.id_categoria FROM categorias WHERE nombreCategoria = NOMBRE_CATEGORIA_);
	SET @VAR1 = (SELECT categoria_producto.id FROM categoria_producto WHERE id_producto = ID_PRODUCTO_); 
	IF (@VAR1 IS NULL) THEN
    	INSERT INTO 
        	categoria_producto 
            (id_categoria, id_producto) 
            VALUES
            (@VAR, ID_PRODUCTO_);
    ELSEIF (@VAR1 IS NOT NULL) THEN 
        UPDATE categoria_producto SET
        	id_categoria	=	@VAR
            WHERE id_producto = ID_PRODUCTO_;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpInsertSubCategoria`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpInsertSubCategoria` (IN `ID_` INT(11), IN `ID_PRODUCTO_` INT(11))  NO SQL
BEGIN
	SET @VAR1 = (SELECT id FROM sub_categoria_producto WHERE id_sub_categoria = ID_ AND id_producto = ID_PRODUCTO_);
	IF (@VAR1 IS NULL) THEN
    	INSERT INTO 
        	sub_categoria_producto 
            (id_sub_categoria, id_producto) 
            VALUES
            (ID_, ID_PRODUCTO_);
    ELSEIF (@VAR1 IS NOT NULL) THEN 
        DELETE FROM 
        	sub_categoria_producto
            WHERE id_producto = ID_PRODUCTO_ AND id_sub_categoria = ID_;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpIsertSupplier`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpIsertSupplier` (IN `TIPO_PERSONA_` VARCHAR(50), IN `NUMERO_DOCUMENTO_` INT(12))  NO SQL
BEGIN
    INSERT INTO prueba (1N) VALUES (TIPO_PERSONA_);
END$$

DROP PROCEDURE IF EXISTS `SpListarUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpListarUser` (IN `ID_USUARIO_` INT(11))  NO SQL
BEGIN
	SET @ROL = (SELECT Rol FROM usuarios WHERE id_usuario = ID_USUARIO_);
   IF @ROL = "INSTRUCTOR" THEN
    SELECT * FROM usuarios U INNER JOIN instructores I ON (U.id_usuario = I.id_usuario) WHERE U.id_usuario = ID_USUARIO_;
ELSEIF @ROL = "PROVEEDOR" THEN
    SELECT * FROM usuarios U INNER JOIN proveedores I ON (U.id_usuario = I.id_usuario) WHERE U.id_usuario = ID_USUARIO_;
END IF;
END$$

DROP PROCEDURE IF EXISTS `SpProductoDisponibleEntrega`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpProductoDisponibleEntrega` (IN `ID_` INT(11))  NO SQL
BEGIN
	SET @cantidad = (SELECT cantidad FROM productos WHERE id_producto = ID_);
    SET @solicitudes = (SELECT SUM(cantidad) FROM solicitudes WHERE id_producto = ID_  AND estado = "APROBADA");
    IF @solicitudes IS null THEN
    	SET @disponible = @cantidad;
		SELECT @disponible AS disponible , ID_ AS id_producto;
    ELSEIF @solicitudes IS NOT null THEN
        SET @disponible = @cantidad - @solicitudes;
    	SELECT @disponible AS disponible , ID_ AS id_producto;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `SpUpdateInstructor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpdateInstructor` (IN `ID_INSTRUCTOR_` INT(11), IN `NUMERO_DOCUMENTO_` INT(12), IN `NOMBRE_` VARCHAR(50), IN `APELLIDO_` VARCHAR(50), IN `TELEFONO_` INT(10), IN `GMAIL_` VARCHAR(256))  NO SQL
BEGIN
	UPDATE instructores SET
    	numero_documento	= NUMERO_DOCUMENTO_,
    	nombre				= NOMBRE_,
    	apellido			= APELLIDO_,
    	telefono			= TELEFONO_,
    	gmail				= GMAIL_
    WHERE id_instructor		= ID_INSTRUCTOR_;
    
END$$

DROP PROCEDURE IF EXISTS `SpUpdateProducto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpdateProducto` (IN `ID_PRODUCTO_` INT(11), IN `UNIDAD_MEDIDA_` VARCHAR(12), IN `NOMBRE_PRODUCTO_` VARCHAR(100), IN `CANTIDAD_` INT(5), IN `FOTO_` VARCHAR(100), IN `CONTROL_INVENTARIO_` BOOLEAN, IN `PARA_CONSUMO_` BOOLEAN, IN `PARA_VENTA_` BOOLEAN, IN `PRODUCCION_INTERNA_` BOOLEAN, IN `MANEJA_LOTES_` BOOLEAN, IN `SERVICIO_` BOOLEAN, IN `CONTEO_FISICAS_` BOOLEAN, IN `PRODUCTO_ACTIVO_` BOOLEAN, IN `DATOS_FABRICANTE_` VARCHAR(100), IN `REFERENCIA_` VARCHAR(100), IN `MEDIDAS_` VARCHAR(100), IN `PRESENTACION_` VARCHAR(100), IN `UBICACION_FISICA_` VARCHAR(100), IN `PRODUCTO_EQUIVALENTE_` VARCHAR(50), IN `UNITARIO_PROMEDIO_` DOUBLE, IN `TOTAL_PROMEDIO_` INT, IN `STOCK_MINIMO_` INT(50), IN `STOCK_MAXIMO_` INT(50), IN `TIEMPO_REPOSICION_` INT(11), IN `CUENTA_INVENTARIO_` INT(100), IN `CONTABLE_DE_INGRESOS_` VARCHAR(100), IN `CONTABLE_INGRESO_AJUSTE_` VARCHAR(100), IN `CONTABLE_DEVOLUCION_VENTAS_` VARCHAR(100), IN `CONTABLE_COSTOS_` VARCHAR(100), IN `DEVOLUCION_COMPRAS_` VARCHAR(100), IN `CONTABLE_GASTOS` VARCHAR(100), IN `CONTABLE_GASTOS_POR_AJUSTE_` VARCHAR(100), IN `IMPUESTO_COMPRAS_` VARCHAR(100), IN `IMPUESTO_VENTAS_` VARCHAR(100), IN `USUARIO_ID_` INT(11))  NO SQL
BEGIN
UPDATE productos SET  unidadMedida			=	UNIDAD_MEDIDA_,
                       nombreProducto		=	NOMBRE_PRODUCTO_,
                       cantidad				=	CANTIDAD_,
                       controlInventario	=	CONTROL_INVENTARIO_,
                       paraConsumo			=	PARA_CONSUMO_,
                       paraVenta			=	PARA_VENTA_,
                       produccionInterna	=	PRODUCCION_INTERNA_,
                       manejaLotes			=	MANEJA_LOTES_,
                       servicio				=	SERVICIO_,
                       conteoFisicas		=	CONTEO_FISICAS_,
                       productoActivo		=	PRODUCTO_ACTIVO_,
                       datosFabricante		=	DATOS_FABRICANTE_,
                       refetencia			=	REFERENCIA_,
                       medidas				=	MEDIDAS_,
                       presentacion			=	PRESENTACION_,
                       ubicacionFisica		=	UBICACION_FISICA_,
                       productoEquivalente	=	PRODUCTO_EQUIVALENTE_,
                       unitarioPromedio		=	UNITARIO_PROMEDIO_,
                       totalPromedio		=	TOTAL_PROMEDIO_,
                       stockMinimo			=	STOCK_MINIMO_,
                       stockMaximo			=	STOCK_MAXIMO_,
                       tiempoReposicion		=	TIEMPO_REPOSICION_,
                       cuentaInventario		=	CUENTA_INVENTARIO_,
                       contableDeIngresos	=	CONTABLE_DE_INGRESOS_,
                       contableIngresoAjuste	=	CONTABLE_INGRESO_AJUSTE_,
                       contableDevolucionVentas	=	CONTABLE_DEVOLUCION_VENTAS_,
                       contableCostos		=	CONTABLE_COSTOS_,
                       devolucionCompras	=	DEVOLUCION_COMPRAS_,
                       contableGastos		=	CONTABLE_GASTOS,
                       contableGastosPorAjuste=	CONTABLE_GASTOS_POR_AJUSTE_,
                       impuestoCompras		=	IMPUESTO_COMPRAS_,
                       impuestoVentas		=	IMPUESTO_VENTAS_
                       WHERE	id_producto	=	ID_PRODUCTO_;
 IF	(FOTO_ IS NOT NULL AND FOTO_ != "") THEN
UPDATE productos SET foto	=	FOTO_ WHERE id_producto	=	ID_PRODUCTO_;
END IF;
 END$$

DROP PROCEDURE IF EXISTS `SpUpdateProveedor`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpdateProveedor` (IN `ID_PROVEEDOR_` INT(11), IN `TIPO_PERSONA_` VARCHAR(50), IN `NUMERO_DOCUMENTO_` INT(12), IN `NIT_` VARCHAR(12), IN `RUT_` VARCHAR(11), IN `NOMBRE_` VARCHAR(50), IN `APELLIDO_` VARCHAR(50), IN `RAZON_SOCIAL_` VARCHAR(500), IN `CODIGO_PAIS_` VARCHAR(11), IN `NOMBRE_PAIS_` VARCHAR(75), IN `CODIGO_DEPARTAMENTO_` VARCHAR(11), IN `NOMBRE_DEPARTAMENTO_` VARCHAR(75), IN `CODIGO_CIUDAD_` VARCHAR(11), IN `NOMBRE_CIUDAD_` VARCHAR(75), IN `DIRECCION_` VARCHAR(150), IN `TELEFONO_` INT(10), IN `GMAIL_` VARCHAR(256), IN `AUTORIZACION_GMAIL_` BOOLEAN, IN `ID_USUARIO_` INT(11))  NO SQL
BEGIN
	UPDATE proveedores SET
    Tipo_persona	 	=	TIPO_PERSONA_,
    Numero_documento	=	NUMERO_DOCUMENTO_,
    RUT					=	RUT_,
    NIT					=	NIT_,
    Nombre				=	NOMBRE_,
    Apellido			=	APELLIDO_,
    Razon_social		=	RAZON_SOCIAL_,
    Codigo_pais			=	CODIGO_PAIS_,
    Nombre_pais			=	NOMBRE_PAIS_,
    Codigo_departamento =	CODIGO_DEPARTAMENTO_,
    Nombre_departamento =	NOMBRE_DEPARTAMENTO_,
    Codigo_ciudad		=	CODIGO_CIUDAD_,
    Nombre_ciudad		=	NOMBRE_CIUDAD_,
    Direccion			=	DIRECCION_,
    Telefono			=	TELEFONO_,
    Gmail				=	GMAIL_,
    Autorizacion_Gmail	=	AUTORIZACION_GMAIL_
    WHERE id_proveedor	=	ID_PROVEEDOR_;
END$$

DROP PROCEDURE IF EXISTS `SpUpdateUser`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SpUpdateUser` (IN `ID_` INT(11), IN `EMAIL_` VARCHAR(256), IN `CLAVE_` VARCHAR(250))  NO SQL
BEGIN
UPDATE usuarios SET
	UserName 		=	EMAIL_ ,
    Password 	= 	CLAVE_
    WHERE id_usuario = ID_;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `nombreCategoria` varchar(50) NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombreCategoria` (`nombreCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id_categoria`, `nombreCategoria`) VALUES
(6, 'Cuerina'),
(1, 'CUERO'),
(4, 'ENCERADO'),
(2, 'HILO'),
(5, 'suela'),
(3, 'VERDE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria_producto`
--

DROP TABLE IF EXISTS `categoria_producto`;
CREATE TABLE IF NOT EXISTS `categoria_producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_categoria` int(11) NOT NULL,
  `id_producto` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `categoria_producto`
--

INSERT INTO `categoria_producto` (`id`, `id_categoria`, `id_producto`) VALUES
(1, 5, 1),
(2, 5, 2),
(3, 6, 3),
(4, 5, 4),
(5, 5, 5),
(6, 5, 6),
(7, 5, 7),
(8, 5, 8),
(9, 5, 9),
(10, 5, 10),
(11, 5, 11),
(12, 5, 12),
(13, 5, 13),
(14, 5, 14),
(15, 5, 15),
(16, 5, 16),
(17, 5, 17),
(18, 5, 18),
(19, 5, 19),
(20, 5, 20),
(21, 5, 21),
(22, 5, 22),
(23, 5, 23),
(24, 5, 24),
(25, 5, 25),
(26, 5, 26),
(27, 5, 27),
(28, 5, 28),
(29, 5, 29),
(30, 5, 30),
(31, 5, 31),
(32, 5, 32),
(33, 5, 33),
(34, 5, 34),
(35, 5, 35),
(36, 5, 36),
(37, 5, 37),
(38, 5, 38),
(39, 5, 39),
(40, 5, 40),
(41, 5, 41),
(42, 5, 42),
(43, 5, 43),
(44, 5, 44),
(45, 5, 45),
(46, 5, 46),
(47, 5, 47),
(48, 5, 48),
(49, 5, 49),
(50, 5, 50),
(51, 5, 51),
(52, 5, 52),
(53, 5, 53),
(54, 5, 54),
(55, 5, 55),
(56, 5, 56),
(57, 5, 57),
(58, 5, 58),
(59, 5, 59),
(60, 5, 60),
(61, 5, 61),
(62, 5, 62),
(63, 5, 63),
(64, 5, 64),
(65, 5, 65),
(66, 5, 66),
(67, 5, 67),
(68, 5, 68),
(69, 5, 69),
(70, 5, 70),
(71, 5, 71),
(72, 5, 72),
(73, 5, 73),
(74, 5, 74),
(75, 5, 75),
(76, 5, 76),
(77, 5, 77),
(78, 5, 78),
(79, 5, 79),
(80, 5, 80),
(81, 5, 81),
(82, 5, 82),
(83, 5, 83),
(84, 5, 84),
(85, 5, 85),
(86, 5, 86),
(87, 5, 87),
(88, 5, 88),
(89, 5, 89),
(90, 5, 90),
(91, 5, 91),
(92, 5, 92),
(93, 5, 93),
(94, 5, 94),
(95, 5, 95),
(96, 5, 96),
(97, 5, 97),
(98, 5, 98),
(99, 5, 99),
(100, 5, 100),
(101, 5, 101),
(102, 5, 102),
(103, 5, 103),
(104, 5, 104),
(105, 5, 105),
(106, 5, 106),
(107, 5, 107),
(108, 5, 108),
(109, 5, 109),
(110, 5, 110),
(111, 5, 111),
(112, 5, 112),
(113, 5, 113),
(114, 5, 114),
(115, 5, 115),
(116, 5, 116),
(117, 5, 117),
(118, 5, 118),
(119, 5, 119),
(120, 5, 120),
(121, 5, 121),
(122, 5, 122),
(123, 6, 123);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_entrada`
--

DROP TABLE IF EXISTS `detalle_entrada`;
CREATE TABLE IF NOT EXISTS `detalle_entrada` (
  `producto_id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL,
  `entradaProducto_id` int(11) NOT NULL,
  PRIMARY KEY (`producto_id`),
  KEY `entradaProducto_id` (`entradaProducto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_salida`
--

DROP TABLE IF EXISTS `detalle_salida`;
CREATE TABLE IF NOT EXISTS `detalle_salida` (
  `salidaProducto_id` int(11) NOT NULL AUTO_INCREMENT,
  `cantidad` int(11) NOT NULL,
  `costoProducto` double NOT NULL,
  `producto_id` int(11) NOT NULL,
  PRIMARY KEY (`salidaProducto_id`),
  KEY `producto_id` (`producto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrada_producto`
--

DROP TABLE IF EXISTS `entrada_producto`;
CREATE TABLE IF NOT EXISTS `entrada_producto` (
  `id_proveedor` int(11) NOT NULL AUTO_INCREMENT,
  `NumeroFactura` int(11) NOT NULL,
  `DetalleGeneral` int(100) NOT NULL,
  `FechaCompra` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `unidadesDisponibles` int(5) NOT NULL,
  `costoUnitario` double NOT NULL,
  `costoTotal` double NOT NULL,
  `impuestos` double NOT NULL,
  `porcentajeImpuestos` double NOT NULL,
  `totalImpuestos` double NOT NULL,
  `retencionFuente` double NOT NULL,
  `porcentajeRetefte` double NOT NULL,
  `totalRetencion` double NOT NULL,
  `proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `instructores`
--

DROP TABLE IF EXISTS `instructores`;
CREATE TABLE IF NOT EXISTS `instructores` (
  `Id_instructor` int(11) NOT NULL AUTO_INCREMENT,
  `numero_documento` int(12) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `telefono` int(10) NOT NULL,
  `gmail` varchar(256) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`Id_instructor`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_usuario_2` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `instructores`
--

INSERT INTO `instructores` (`Id_instructor`, `numero_documento`, `nombre`, `apellido`, `telefono`, `gmail`, `id_usuario`) VALUES
(1, 0, 'Efer', 'Castaño', 0, '0', 2),
(2, 0, '0', '0', 0, '0', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

DROP TABLE IF EXISTS `productos`;
CREATE TABLE IF NOT EXISTS `productos` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `unidadMedida` varchar(12) NOT NULL,
  `nombreProducto` varchar(100) NOT NULL,
  `cantidad` int(5) NOT NULL,
  `foto` varchar(100) NOT NULL,
  `controlInventario` tinyint(1) NOT NULL,
  `paraConsumo` tinyint(1) NOT NULL,
  `paraVenta` tinyint(1) NOT NULL,
  `produccionInterna` tinyint(1) NOT NULL,
  `manejaLotes` tinyint(1) NOT NULL,
  `servicio` tinyint(1) NOT NULL,
  `conteoFisicas` tinyint(1) NOT NULL,
  `productoActivo` tinyint(1) NOT NULL,
  `datosFabricante` varchar(100) NOT NULL,
  `refetencia` varchar(100) NOT NULL,
  `medidas` varchar(100) NOT NULL,
  `presentacion` varchar(100) NOT NULL,
  `ubicacionFisica` varchar(100) NOT NULL,
  `productoEquivalente` varchar(50) NOT NULL,
  `unitarioPromedio` double NOT NULL,
  `totalPromedio` double NOT NULL,
  `stockMinimo` int(50) NOT NULL,
  `stockMaximo` int(50) NOT NULL,
  `tiempoReposicion` varchar(11) NOT NULL,
  `cuentaInventario` int(100) NOT NULL,
  `contableDeIngresos` varchar(100) NOT NULL,
  `contableIngresoAjuste` varchar(100) NOT NULL,
  `contableDevolucionVentas` varchar(100) NOT NULL,
  `contableCostos` varchar(100) NOT NULL,
  `devolucionCompras` varchar(100) NOT NULL,
  `contableGastos` varchar(100) NOT NULL,
  `contableGastosPorAjuste` varchar(100) NOT NULL,
  `impuestoCompras` varchar(100) NOT NULL,
  `impuestoVentas` varchar(100) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  PRIMARY KEY (`id_producto`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `unidadMedida`, `nombreProducto`, `cantidad`, `foto`, `controlInventario`, `paraConsumo`, `paraVenta`, `produccionInterna`, `manejaLotes`, `servicio`, `conteoFisicas`, `productoActivo`, `datosFabricante`, `refetencia`, `medidas`, `presentacion`, `ubicacionFisica`, `productoEquivalente`, `unitarioPromedio`, `totalPromedio`, `stockMinimo`, `stockMaximo`, `tiempoReposicion`, `cuentaInventario`, `contableDeIngresos`, `contableIngresoAjuste`, `contableDevolucionVentas`, `contableCostos`, `devolucionCompras`, `contableGastos`, `contableGastosPorAjuste`, `impuestoCompras`, `impuestoVentas`, `usuario_id`) VALUES
(3, '34', 'Zapato', 5, '21-12-2021-10-30-46-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '34', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(4, '35', 'Zapato', 4, '21-12-2021-10-32-14-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '35', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(5, '36', 'Zapato', 8, '21-12-2021-10-33-33-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '36', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(6, '37', 'Zapato', 7, '21-12-2021-10-34-30-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '37', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(7, '38', 'Zapato', 8, '21-12-2021-10-35-18-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '38', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(8, '39', 'Zapato', 11, '21-12-2021-10-36-08-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '39', '', '', '', 0, 0, 0, 0, '0', 11, '', '', '', '', '', '', '', '', '', 2),
(9, '40', 'Zapato', 14, '21-12-2021-10-36-56-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-W/M8018Y', '40', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(10, '34', 'Zapato', 4, '21-12-2021-10-41-25-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '34', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(11, '35', 'Zapato', 6, '21-12-2021-10-42-41-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '35', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(12, '36', 'Zapato', 7, '21-12-2021-10-43-46-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '36', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(13, '37', 'Zapato', 18, '21-12-2021-10-44-25-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '37', '', '', '', 0, 0, 0, 0, '0', 18, '', '', '', '', '', '', '', '', '', 2),
(14, '38', 'SUELA', 18, '21-12-2021-10-45-28-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '38', '', '', '', 0, 0, 0, 0, '0', 18, '', '', '', '', '', '', '', '', '', 2),
(15, '39', 'SUELA', 23, '21-12-2021-10-46-16-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '39', '', '', '', 0, 0, 0, 0, '0', 23, '', '', '', '', '', '', '', '', '', 2),
(16, '40', 'SUELA', 30, '21-12-2021-10-46-58-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '40', '', '', '', 0, 0, 0, 0, '0', 30, '', '', '', '', '', '', '', '', '', 2),
(17, '41', 'SUELA', 18, '21-12-2021-10-47-51-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '41', '', '', '', 0, 0, 0, 0, '0', 18, '', '', '', '', '', '', '', '', '', 2),
(18, '42', 'SUELA', 19, '21-12-2021-10-48-34-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '42', '', '', '', 0, 0, 0, 0, '0', 19, '', '', '', '', '', '', '', '', '', 2),
(19, '43', 'SUELA', 7, '21-12-2021-10-49-34-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8012-C', '43', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(20, '34', 'SUELA', 6, '21-12-2021-10-51-11-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '34', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(21, '35', 'SUELA', 4, '21-12-2021-10-53-00-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '35', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(22, '36', 'SUELA', 8, '21-12-2021-10-53-50-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '36', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(23, '37', 'SUELA', 8, '21-12-2021-10-54-27-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '36', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(24, '38', 'SUELA', 8, '21-12-2021-10-55-51-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '38', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(25, '39', 'SUELA', 10, '21-12-2021-10-56-56-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '39', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(26, '40', 'SUELA', 8, '21-12-2021-10-57-40-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '40', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(27, '41', 'SUELA', 2, '21-12-2021-10-58-25-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '41', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(28, '42', 'SUELA', 14, '21-12-2021-10-59-04-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '42', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(29, '43', 'SUELA', 4, '21-12-2021-10-59-48-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8001Y', '43', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(30, '34', 'SUELA', 5, '21-12-2021-11-01-31-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '34', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(31, '35', 'SUELA', 1, '21-12-2021-11-02-02-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '35', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(32, '36', 'SUELA', 0, '21-12-2021-11-03-43-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '36', '', '', '', 0, 0, 0, 0, '0', 0, '', '', '', '', '', '', '', '', '', 2),
(33, '37', 'SUELA', 0, '21-12-2021-11-04-23-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '37', '', '', '', 0, 0, 0, 0, '0', 0, '', '', '', '', '', '', '', '', '', 2),
(34, '38', 'SUELA', 2, '21-12-2021-11-04-52-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '38', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(35, '39', 'SUELA', 10, '21-12-2021-11-05-21-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '39', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(36, '40', 'SUELA', 15, '21-12-2021-11-05-45-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '40', '', '', '', 0, 0, 0, 0, '0', 15, '', '', '', '', '', '', '', '', '', 2),
(37, '41', 'SUELA', 10, '21-12-2021-11-06-14-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '41', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(38, '42', 'SUELA', 14, '21-12-2021-11-06-39-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '42', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(39, '43', 'SUELA', 14, '21-12-2021-11-07-04-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M8002 Y', '43', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(40, '34', 'SUELA', 4, '21-12-2021-11-11-47-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '34', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(41, '35', 'SUELA', 5, '21-12-2021-11-12-34-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '35', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(42, '36', 'SUELA', 3, '21-12-2021-11-13-14-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '36', '', '', '', 0, 0, 0, 0, '0', 3, '', '', '', '', '', '', '', '', '', 2),
(43, '37', 'SUELA', 1, '21-12-2021-11-13-56-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '37', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(44, '38', 'SUELA', 8, '21-12-2021-11-14-35-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '38', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(45, '39', 'SUELA', 6, '21-12-2021-11-15-59-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '39', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(46, '40', 'SUELA', 8, '21-12-2021-11-16-45-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '40', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(47, '41', 'SUELA', 6, '21-12-2021-11-17-30-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '41', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(48, '42', 'SUELA', 15, '21-12-2021-11-18-04-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '42', '', '', '', 0, 0, 0, 0, '0', 15, '', '', '', '', '', '', '', '', '', 2),
(49, '43', 'SUELA', 3, '21-12-2021-11-18-43-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8006', '43', '', '', '', 0, 0, 0, 0, '0', 3, '', '', '', '', '', '', '', '', '', 2),
(50, '34', 'SUELA', 4, '21-12-2021-11-21-06-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '34', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(51, '35', 'SUELA', 6, '21-12-2021-11-21-46-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '35', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(52, '36', 'SUELA', 9, '21-12-2021-11-22-27-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '36', '', '', '', 0, 0, 0, 0, '0', 9, '', '', '', '', '', '', '', '', '', 2),
(53, '37', 'SUELA', 5, '21-12-2021-11-23-06-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '37', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(54, '38', 'SUELA', 13, '21-12-2021-11-24-11-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '38', '', '', '', 0, 0, 0, 0, '0', 13, '', '', '', '', '', '', '', '', '', 2),
(55, '39', 'SUELA', 16, '21-12-2021-12-03-27-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '39', '', '', '', 0, 0, 0, 0, '0', 16, '', '', '', '', '', '', '', '', '', 2),
(56, '40', 'SUELA', 28, '21-12-2021-12-04-41-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '40', '', '', '', 0, 0, 0, 0, '0', 28, '', '', '', '', '', '', '', '', '', 2),
(57, '41', 'SUELA', 16, '21-12-2021-12-05-19-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '41', '', '', '', 0, 0, 0, 0, '0', 16, '', '', '', '', '', '', '', '', '', 2),
(58, '42', 'SUELA', 20, '21-12-2021-12-06-03-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '42', '', '', '', 0, 0, 0, 0, '0', 20, '', '', '', '', '', '', '', '', '', 2),
(59, '43', 'SUELA', 7, '21-12-2021-12-06-39-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- 8005', '43', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(60, '34', 'SUELA', 2, '21-12-2021-12-08-14-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '34', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(61, '35', 'SUELA', 4, '21-12-2021-12-09-09-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '35', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(62, '36', 'SUELA', 4, '21-12-2021-12-09-54-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '36', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(63, '37', 'SUELA', 8, '21-12-2021-12-10-47-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '37', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(64, '38', 'SUELA', 6, '21-12-2021-12-13-32-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '38', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(65, '39', 'SUELA', 12, '21-12-2021-12-14-19-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '39', '', '', '', 0, 0, 0, 0, '0', 12, '', '', '', '', '', '', '', '', '', 2),
(66, '40', 'SUELA', 14, '21-12-2021-12-15-00-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '40', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(67, '41', 'SUELA', 9, '21-12-2021-12-15-36-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '41', '', '', '', 0, 0, 0, 0, '0', 9, '', '', '', '', '', '', '', '', '', 2),
(68, '42', 'SUELA', 8, '21-12-2021-12-16-19-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '42', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(69, '43', 'SUELA', 4, '21-12-2021-12-17-12-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD- M8008Y', '43', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(70, '34', 'SUELA', 6, '21-12-2021-12-18-39-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '34', '', '', '', 0, 0, 0, 0, '0', 6, '', '', '', '', '', '', '', '', '', 2),
(71, '35', 'SUELA', 4, '21-12-2021-12-19-23-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '35', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(72, '36', 'SUELA', 8, '21-12-2021-12-20-07-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '36', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(73, '37', 'SUELA', 8, '21-12-2021-12-20-45-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '37', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(74, '38', 'SUELA', 8, '21-12-2021-12-21-27-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '38', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(75, '39', 'SUELA', 10, '21-12-2021-12-22-18-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '39', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(76, '40', 'SUELA', 8, '21-12-2021-12-23-02-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '40', '', '', '', 0, 0, 0, 0, '0', 8, '', '', '', '', '', '', '', '', '', 2),
(77, '41', 'SUELA', 2, '21-12-2021-12-23-42-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '41', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(78, '42', 'SUELA', 14, '21-12-2021-12-24-21-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '42', '', '', '', 0, 0, 0, 0, '0', 14, '', '', '', '', '', '', '', '', '', 2),
(79, '43', 'SUELA', 4, '21-12-2021-12-25-01-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'JD-M-8011-C', '43', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(80, '23', 'SUELA', 2, '21-12-2021-12-27-35-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '23', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(81, '24', 'SUELA', 2, '21-12-2021-12-28-18-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '24', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(82, '25', 'SUELA', 4, '21-12-2021-12-29-05-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '25', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(83, '26', 'SUELA', 4, '21-12-2021-12-29-41-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '26', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(84, '27', 'SUELA', 4, '21-12-2021-12-30-53-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '27', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(85, '28', 'SUELA', 4, '21-12-2021-12-31-30-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '28', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(86, '29', 'SUELA', 7, '21-12-2021-12-32-15-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '29', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(87, '30', 'SUELA', 7, '21-12-2021-12-32-53-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '30', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(88, '31', 'SUELA', 10, '21-12-2021-12-33-32-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '31', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(89, '32', 'SUELA', 10, '21-12-2021-12-34-16-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO B', '32', '', '', '', 0, 0, 0, 0, '0', 10, '', '', '', '', '', '', '', '', '', 2),
(90, '24', 'SUELA', 2, '21-12-2021-12-35-44-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '24', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(91, '25', 'SUELA', 2, '21-12-2021-12-36-31-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '25', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(92, '26', 'SUELA', 2, '21-12-2021-12-37-07-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '26', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(93, '27', 'SUELA', 2, '21-12-2021-12-37-48-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '27', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(94, '28', 'SUELA', 2, '21-12-2021-01-36-19-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '28', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(95, '29', 'SUELA', 2, '21-12-2021-01-37-35-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '29', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(96, '30', 'SUELA', 2, '21-12-2021-01-38-24-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '30', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(97, '31', 'SUELA', 2, '21-12-2021-01-39-11-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '31', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(98, '32', 'SUELA', 5, '21-12-2021-01-39-54-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '32', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(99, '33', 'SUELA', 5, '21-12-2021-01-43-09-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO  C', '33', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(100, '24', 'SUELA', 2, '21-12-2021-01-45-38-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '24', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(101, '25', 'SUELA', 2, '21-12-2021-01-46-30-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '25', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(102, '26', 'SUELA', 2, '21-12-2021-01-47-08-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '26', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(103, '27', 'SUELA', 2, '21-12-2021-01-47-51-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '27', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(104, '28', 'SUELA', 2, '21-12-2021-01-48-28-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '28', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(105, '29', 'SUELA', 2, '21-12-2021-01-49-01-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '29', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(106, '30', 'SUELA', 5, '21-12-2021-01-49-47-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '30', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(107, '31', 'SUELA', 4, '21-12-2021-01-50-28-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '31', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(108, '32', 'SUELA', 5, '21-12-2021-01-51-09-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '32', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(109, '33', 'SUELA', 4, '21-12-2021-01-51-48-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '33', '', '', '', 0, 0, 0, 0, '0', 4, '', '', '', '', '', '', '', '', '', 2),
(110, '34', 'SUELA', 7, '21-12-2021-01-52-32-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'GRUPO A', '34', '', '', '', 0, 0, 0, 0, '0', 7, '', '', '', '', '', '', '', '', '', 2),
(111, '24', 'SUELA', 1, '21-12-2021-01-55-24-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '24', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(112, '25', 'SUELA', 5, '21-12-2021-01-56-03-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '25', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(113, '26', 'SUELA', 1, '21-12-2021-01-56-39-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '26', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(114, '27', 'SUELA', 1, '21-12-2021-01-57-24-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '27', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(115, '28', 'SUELA', 1, '21-12-2021-01-58-08-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '28', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(116, '29', 'SUELA', 2, '21-12-2021-01-58-52-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '29', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(117, '30', 'SUELA', 5, '21-12-2021-01-59-44-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '30', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(118, '31', 'SUELA', 5, '21-12-2021-02-00-44-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '31', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(119, '32', 'SUELA', 5, '21-12-2021-02-01-43-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', ' NB 247  ', '32', '', '', '', 0, 0, 0, 0, '0', 5, '', '', '', '', '', '', '', '', '', 2),
(120, '24', 'SUELA', 2, '21-12-2021-02-04-01-000000.png', 0, 0, 0, 0, 0, 0, 0, 0, '', 'PAUL G2.5', '24', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(121, '25', 'SUELA', 2, '21-12-2021-02-05-04-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'PAUL G2.5', '25', '', '', '', 0, 0, 0, 0, '0', 2, '', '', '', '', '', '', '', '', '', 2),
(122, '26', 'SUELA', 1, '21-12-2021-02-05-52-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'PAUL G2.5', '26', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2),
(123, '27', 'Plantilla', 1, '21-12-2021-02-06-34-000000.png', 0, 0, 1, 0, 0, 0, 0, 0, '', 'PAUL G2.5', '27', '', '', '', 0, 0, 0, 0, '0', 1, '', '', '', '', '', '', '', '', '', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

DROP TABLE IF EXISTS `proveedores`;
CREATE TABLE IF NOT EXISTS `proveedores` (
  `id_proveedor` int(11) NOT NULL AUTO_INCREMENT,
  `Tipo_persona` varchar(50) NOT NULL DEFAULT 'JURIDICA',
  `Numero_documento` int(12) DEFAULT NULL,
  `NIT` varchar(12) DEFAULT NULL,
  `RUT` varchar(11) DEFAULT NULL,
  `Nombre` varchar(50) DEFAULT NULL,
  `Apellido` varchar(50) DEFAULT NULL,
  `Razon_social` varchar(500) DEFAULT NULL,
  `Codigo_pais` varchar(11) NOT NULL,
  `Nombre_pais` varchar(75) NOT NULL,
  `Codigo_departamento` varchar(11) NOT NULL,
  `Nombre_departamento` varchar(75) NOT NULL,
  `Codigo_ciudad` varchar(11) NOT NULL,
  `Nombre_ciudad` varchar(75) NOT NULL,
  `Direccion` varchar(150) NOT NULL,
  `Telefono` int(10) NOT NULL,
  `Gmail` varchar(256) NOT NULL,
  `Autorizacion_Gmail` tinyint(1) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  PRIMARY KEY (`id_proveedor`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `Tipo_persona`, `Numero_documento`, `NIT`, `RUT`, `Nombre`, `Apellido`, `Razon_social`, `Codigo_pais`, `Nombre_pais`, `Codigo_departamento`, `Nombre_departamento`, `Codigo_ciudad`, `Nombre_ciudad`, `Direccion`, `Telefono`, `Gmail`, `Autorizacion_Gmail`, `id_usuario`) VALUES
(1, 'JURIDICA', NULL, '0', NULL, '0', NULL, '0', '0', '0', '0', '0', '0', '0', '0', 0, '0', 0, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salida_producto`
--

DROP TABLE IF EXISTS `salida_producto`;
CREATE TABLE IF NOT EXISTS `salida_producto` (
  `id_salidaProducto` int(11) NOT NULL AUTO_INCREMENT,
  `numeroFactura` int(11) NOT NULL,
  `detalleGeneral` text NOT NULL,
  `fechaSalida` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `costoUnitario` double NOT NULL,
  `costoTotal` double NOT NULL,
  `instructor_id` int(11) NOT NULL,
  PRIMARY KEY (`id_salidaProducto`),
  KEY `instructor_id` (`instructor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

DROP TABLE IF EXISTS `solicitudes`;
CREATE TABLE IF NOT EXISTS `solicitudes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `estado` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`id`, `id_producto`, `cantidad`, `id_usuario`, `estado`) VALUES
(1, 1, 2, 4, 'ENTREGADO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sub_categoria`
--

DROP TABLE IF EXISTS `sub_categoria`;
CREATE TABLE IF NOT EXISTS `sub_categoria` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_categoria` int(11) NOT NULL,
  `nombreCategoria` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sub_categoria`
--

INSERT INTO `sub_categoria` (`id`, `id_categoria`, `nombreCategoria`) VALUES
(1, 1, 'NEGRO'),
(4, 2, 'NEGRO'),
(5, 2, 'VERDE'),
(6, 2, 'ENCERADO'),
(7, 2, '#20'),
(8, 5, 'suela'),
(9, 5, 'BLANCO'),
(10, 5, 'GRIS'),
(11, 6, 'Cuerina sim'),
(12, 6, 'Cuerina sim');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sub_categoria_producto`
--

DROP TABLE IF EXISTS `sub_categoria_producto`;
CREATE TABLE IF NOT EXISTS `sub_categoria_producto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_sub_categoria` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sub_categoria_producto`
--

INSERT INTO `sub_categoria_producto` (`id`, `id_sub_categoria`, `id_producto`) VALUES
(1, 1, 1),
(2, 4, 1),
(6, 7, 1),
(10, 8, 1),
(15, 9, 4),
(17, 9, 5),
(18, 9, 6),
(19, 9, 7),
(20, 9, 8),
(21, 9, 9),
(22, 10, 10),
(23, 10, 11),
(24, 10, 12),
(25, 10, 13),
(26, 10, 14),
(27, 10, 15),
(28, 10, 16),
(29, 10, 17),
(30, 10, 18),
(31, 10, 19),
(32, 9, 20),
(33, 9, 21),
(34, 9, 22),
(35, 9, 23),
(36, 9, 24),
(37, 9, 25),
(38, 9, 26),
(39, 9, 27),
(40, 9, 28),
(41, 9, 29),
(42, 9, 30),
(43, 9, 31),
(44, 9, 32),
(45, 9, 33),
(46, 9, 34),
(47, 9, 35),
(48, 9, 36),
(49, 9, 37),
(50, 9, 38),
(51, 9, 39),
(52, 9, 40),
(53, 9, 41),
(54, 9, 42),
(55, 9, 43),
(56, 9, 44),
(57, 9, 45),
(58, 9, 46),
(59, 9, 47),
(60, 9, 48),
(61, 9, 49),
(62, 9, 50),
(63, 9, 51),
(64, 9, 52),
(65, 9, 53),
(66, 9, 54),
(67, 9, 55),
(68, 9, 56),
(69, 9, 57),
(71, 9, 58),
(72, 9, 59),
(73, 9, 60),
(74, 9, 61),
(75, 9, 62),
(77, 9, 63),
(82, 9, 64),
(83, 9, 65),
(84, 9, 66),
(85, 9, 67),
(86, 9, 68),
(87, 9, 69),
(88, 9, 70),
(89, 9, 71),
(90, 9, 72),
(91, 9, 73),
(92, 9, 74),
(93, 9, 75),
(94, 9, 76),
(95, 9, 77),
(96, 9, 78),
(97, 9, 79),
(98, 9, 80),
(99, 9, 81),
(100, 9, 82),
(101, 9, 83),
(102, 9, 84),
(103, 9, 85),
(104, 9, 86),
(105, 9, 87),
(106, 9, 88),
(107, 9, 89),
(108, 9, 90),
(109, 9, 91),
(110, 9, 92),
(111, 9, 93),
(112, 9, 94),
(113, 9, 95),
(114, 9, 96),
(115, 9, 97),
(116, 9, 98),
(117, 9, 99),
(118, 9, 100),
(119, 9, 101),
(120, 9, 102),
(121, 9, 103),
(122, 9, 104),
(123, 9, 105),
(124, 9, 106),
(125, 9, 107),
(126, 9, 108),
(127, 9, 109),
(128, 9, 110),
(129, 9, 111),
(130, 9, 112),
(131, 9, 113),
(132, 9, 114),
(133, 9, 115),
(134, 9, 116),
(135, 9, 117),
(136, 9, 118),
(137, 9, 119),
(138, 9, 120),
(139, 9, 121),
(140, 9, 122),
(141, 9, 123),
(146, 11, 123),
(147, 12, 123);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(256) NOT NULL,
  `Password` varchar(250) NOT NULL,
  `Rol` varchar(50) NOT NULL,
  PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `UserName`, `Password`, `Rol`) VALUES
(1, 'canoalvaro87@gmail.com', 'clover', 'ADMIN'),
(2, 'jperez@sena.edu.co', 'Sena123', 'PROVEEDOR'),
(3, 'jsanchezac@sena.edu.co', 'Sena2021*', 'ADMIN'),
(4, 'efer@gmail.com', '123', 'INSTRUCTOR'),
(5, 'a', 'a', 'ADMIN');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
