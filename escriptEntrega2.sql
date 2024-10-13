USE mydb;

-- DROP SCHEMA IF exists tp_basededatos1;
/*
-- Ejemplo de stored procedure para un ALTA
DELIMITER //
CREATE PROCEDURE altaConcesionaria(
    IN p_id_concesionaria INT,
    IN p_nombre VARCHAR(100),
    IN p_terminal_automotriz_Id_terminal INT,  -- Cambiado a INT
    IN p_direccion VARCHAR(150),

    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    -- Inicializar el resultado y mensaje
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el concesionario ya existe
    IF EXISTS (SELECT * FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
        SET nResultado = -1;
        SET cMensaje = 'El concesionario ya existe con esa clave primaria.';
    ELSE
        -- Insertar nuevo concesionario
        INSERT INTO concesionaria (id_concesionaria, nombre, terminal_automotriz_Id_terminal, direccion)
        VALUES (p_id_concesionaria, p_nombre, p_terminal_automotriz_Id_terminal, p_direccion);
        
        -- Confirmar la inserción exitosa
        SET nResultado = 0;
        SET cMensaje = 'Concesionario insertado con éxito.';
    END IF;

END//

-- Ejemplo de invocacion
CALL altaConcesionaria(10, 'AutoMovil S.A', 1, 'Av. Siempre Viva 123, Ciudad A', @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;

*/


-- *******************************
-- Creacion de prodecimientos ABM
-- *******************************
/*
- ERRORES: 
0 = Ejectuado correctamente
-1 = PK Actualmente en uso
-2 = PK NO encontrada (Tabla no existe?)
-3 = Una entidad depende de la entidad que queres borrar
*/
-- *******************************
-- ALTAS:
-- *******************************

-- CONCESIONARIA
DROP PROCEDURE IF EXISTS altaConcesionaria;

DELIMITER //
CREATE PROCEDURE altaConcesionaria(
    IN p_id_concesionaria INT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN 
    SET nResultado = 0;
    SET cMensaje = '';
    
    -- Verificar si existe un concesionario con esa PK
    IF EXISTS (SELECT id_concesionaria FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
        SET nResultado = -1;
        SET cMensaje = 'ERROR: PK actualmente en uso';
    ELSE
        INSERT INTO concesionaria (id_concesionaria, nombre) 
        VALUES (p_id_concesionaria, p_nombre);
        SET nResultado = 0;
        SET cMensaje = 'Alta exitosa';
    END IF;
END 
// DELIMITER ;


-- PEDIDO
DROP PROCEDURE IF EXISTS altaPedido;
DELIMITER //
CREATE PROCEDURE altaPedido(
    IN p_id_pedido INT,
    IN p_fecha DATETIME,
    IN p_concesionaria_id_concesionaria INT,
    IN p_modelo_id_modelo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si ya existe el pedido con esa PK
    IF EXISTS (SELECT id_pedido FROM pedido WHERE id_pedido = p_id_pedido) THEN
        SET nResultado = -1;
        SET cMensaje = 'Error: PK actualmente en uso';
    -- Verificar si la concesionaria referenciada existe
    ELSEIF NOT EXISTS (SELECT id_concesionaria FROM concesionaria WHERE id_concesionaria = p_concesionaria_id_concesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe concesionaria con ese id';

    -- Verificar si el modelo referenciado existe
    ELSEIF NOT EXISTS (SELECT id_modelo FROM modelo WHERE id_modelo = p_modelo_id_modelo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe modelo con ese id';


    ELSE
        INSERT INTO pedido (id_pedido, fecha, concesionaria_id_concesionaria) 
        VALUES (p_id_pedido, p_fecha, p_concesionaria_id_concesionaria);
		-- Insertar en el detalle (pedido_has_modelo)
        INSERT INTO pedido_has_modelo (modelo_id_modelo, pedido_id_pedido) 
        VALUES (p_modelo_id_modelo, p_id_pedido);
        
        SET nResultado = 0;
        SET cMensaje = 'Alta exitosa';

    END IF;
END 
// DELIMITER ;


-- INSUMO

DROP PROCEDURE IF EXISTS altaInsumo;
 DELIMITER //
CREATE PROCEDURE altaInsumo(
	IN p_id_insumo int,
    IN p_nombre varchar(45),
     OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
	BEGIN
    
		SET nResultado=0;
		SET cMensaje='';
    
      -- Verificar si ya existe el pedido con esa PK
		IF EXISTS (SELECT id_insumo FROM insumo WHERE id_insumo = p_id_insumo) THEN
			SET nResultado = -1;
			SET cMensaje = 'Error: PK actualmente en uso';
		ELSE
			INSERT INTO insumo (id_insumo, nombre) 
			VALUES (p_id_insumo,p_nombre);
			SET nResultado = 0;
			SET cMensaje = 'Alta exitosa';
    
		END IF;
    END

// DELIMITER ;

-- proveedor

DROP PROCEDURE IF EXISTS altaProveedor;
 DELIMITER //
CREATE PROCEDURE altaProveedor(
	IN p_id_proveedor int,
    IN p_nombre varchar(45),
     OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
	BEGIN
    
		SET nResultado=0;
		SET cMensaje='';
    
      -- Verificar si ya existe el pedido con esa PK
		IF EXISTS (SELECT id_proveedor FROM proveedor WHERE id_proveedor = p_id_proveedor) THEN
			SET nResultado = -1;
			SET cMensaje = 'Error: PK actualmente en uso';
		ELSE
			INSERT INTO proveedor (id_proveedor, nombre) 
			VALUES (p_id_proveedor,p_nombre);
			SET nResultado = 0;
			SET cMensaje = 'Alta exitosa';
    
		END IF;
    END

// DELIMITER ;

-- PROVEEDOR_HAS_INSUMO
DROP PROCEDURE IF EXISTS altaProveedor_has_insumo;
DELIMITER //
CREATE PROCEDURE altaProveedor_has_insumo(
    IN p_proveedor_id_proveedor INT,
    IN p_insumo_id_insumo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el proveedor referenciada existe
    IF NOT EXISTS (SELECT id_proveedor FROM proveedor WHERE id_proveedor = p_proveedor_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe proveedor con ese id';
        -- Verificar si el insumo referenciado existe
    ELSEIF NOT EXISTS (SELECT id_insumo FROM insumo WHERE id_insumo = p_insumo_id_insumo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe insumo con ese id';

    ELSE
        INSERT INTO proveedor_has_insumo (proveedor_id_proveedor, insumo_id_insumo) 
        VALUES (p_proveedor_id_proveedor, p_insumo_id_insumo);
        SET nResultado = 0;
        SET cMensaje = 'Alta exitosa';
    END IF;
END 
// DELIMITER ;



-- *******************************
-- BAJAS:
-- *******************************

-- CONCESIONARIA

DROP PROCEDURE IF EXISTS bajaConcesionaria;
DELIMITER //
CREATE PROCEDURE bajaConcesionaria (
	IN p_id_concesionaria INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';
    
	IF NOT EXISTS (SELECT id_concesionaria FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'ERROR: No existe una concesionaria con esa PK';
	ELSEIF EXISTS (SELECT * FROM pedido WHERE concesionaria_id_concesionaria = p_id_concesionaria) THEN
		SET nResultado = -3;
        SET cMensaje = 'ERROR: Una tabla de la PK de la tabla que tratas de eliminar';
	ELSE
		DELETE FROM concesionaria WHERE id_concesionaria = p_id_concesionaria;
        SET nResultado = 0;
        SET cMensaje = 'Baja exitosa';
	END IF;
    
END
// DELIMITER ;


-- PEDIDO
DROP PROCEDURE IF EXISTS bajaPedido;

DELIMITER //
CREATE PROCEDURE bajaPedido(
    IN p_id_pedido INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_pedido FROM pedido WHERE id_pedido = p_id_pedido) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un pedido con esa PK';
    ELSE
		DELETE FROM pedido_has_modelo WHERE pedido_id_pedido = p_id_pedido;
        DELETE FROM pedido WHERE id_pedido = p_id_pedido;
        SET nResultado = 0;
        SET cMensaje = 'Baja exitosa';
    END IF;
END 
// DELIMITER ;

-- insumo
DROP PROCEDURE IF EXISTS bajaInsumo;
DELIMITER //

CREATE PROCEDURE bajaInsumo(
  IN p_id_insumo INT,
  OUT nResultado INT,
  OUT cMensaje VARCHAR(256)
)
BEGIN
	SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_insumo FROM insumo WHERE id_insumo = p_id_insumo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un insumo con esa PK';
    ELSE
        DELETE FROM insumo WHERE id_insumo = p_id_insumo;
        SET nResultado = 0;
        SET cMensaje = 'Baja exitosa';
    END IF;
END
// DELIMITER ;

-- insumo
DROP PROCEDURE IF EXISTS bajaProveedor;
DELIMITER //

CREATE PROCEDURE bajaProveedor(
  IN p_id_proveedor INT,
  OUT nResultado INT,
  OUT cMensaje VARCHAR(256)
)
BEGIN
	SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_proveedor FROM proveedor WHERE id_proveedor = p_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un proveedor con esa PK';
    ELSE
        DELETE FROM proveedor WHERE id_proveedor = p_id_proveedor;
        SET nResultado = 0;
        SET cMensaje = 'Baja exitosa';
    END IF;
END
// DELIMITER ;


-- PROVEEDOR_HAS_INSUMO
DROP PROCEDURE IF EXISTS bajaProveedor_has_insumo;

DELIMITER //
CREATE PROCEDURE bajaProveedor_has_insumo(
    IN p_proveedor_id_proveedor INT,
    IN p_insumo_id_insumo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT proveedor_id_proveedor FROM proveedor_has_insumo WHERE proveedor_id_proveedor = p_proveedor_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe ese id proveedor';
        
ELSEIF NOT EXISTS (SELECT insumo_id_insumo FROM proveedor_has_insumo WHERE insumo_id_insumo = p_insumo_id_insumo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe ese id insumo';
        
    ELSE
        DELETE FROM proveedor_has_insumo WHERE id_proveedor_insumo = p_id_proveedor_insumo and insumo_id_insumo = p_insumo_id_insumo;
        SET nResultado = 0;
        SET cMensaje = 'Baja exitosa';
    END IF;
END 
// DELIMITER ;


-- *******************************
-- MODIFICACIONES:
-- *******************************

DROP PROCEDURE IF EXISTS modificarConcesionaria;
-- CONCESIONARIA
DELIMITER //
CREATE PROCEDURE modificarConcesionaria (
	IN p_id_concesionaria INT,
    IN p_nombre VARCHAR(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';
    
	IF NOT EXISTS (SELECT id_concesionaria FROM concesionaria WHERE id_concesionaria = p_id_concesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'ERROR: No existe una concesionaria con esa PK';
	ELSE
		UPDATE concesionaria SET nombre = p_nombre WHERE id_concesionaria =  p_id_concesionaria;
		SET nResultado = 0;
        SET cMensaje = 'Modificacion exitosa';
	END IF;
END 
// DELIMITER ;


-- PEDIDO
-- CON FECHA + CONCESIONARIA
DROP PROCEDURE IF EXISTS modificarPedidoFecha;
DELIMITER //
CREATE PROCEDURE modificarPedidoFecha(
    IN p_id_pedido INT,
    IN p_nueva_fecha_de_orden DATETIME,
    IN p_nueva_concesionaria_id_concesionaria INT,
    IN p_nueva_modelo_id_modelo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_pedido FROM pedido WHERE id_pedido = p_id_pedido) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un pedido con esa PK';
    -- Verificar si la nueva concesionaria referenciada existe
    ELSEIF NOT EXISTS (SELECT id_concesionaria FROM concesionaria WHERE id_concesionaria = p_nueva_concesionaria_id_concesionaria) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: La concesionaria nueva no existe';

    -- Verificar si el modelo nuevo referenciado existe
    ELSEIF NOT EXISTS (SELECT id_modelo FROM modelo WHERE id_modelo = p_nueva_modelo_id_modelo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: El modelo nuevo no existe';

    ELSE
        UPDATE pedido SET fecha = p_nueva_fecha_de_orden, concesionaria_id_concesionaria = p_nueva_concesionaria_id_concesionaria
        WHERE id_pedido = p_id_pedido;
		-- Insertar en el detalle (pedido_has_modelo)
        UPDATE pedido_has_modelo SET modelo_id_modelo = p_nueva_modelo_id_modelo, pedido_id_pedido = p_id_pedido
        WHERE pedido_id_pedido = p_id_pedido;
        SET nResultado = 0;
        SET cMensaje = 'Modificacion exitosa';
    END IF;
END 
// DELIMITER ;


-- insumo
DROP PROCEDURE IF EXISTS modificarInsumo;
DELIMITER //
CREATE PROCEDURE modificarInsumo(
    IN p_id_insumo INT,
    IN p_nombre varchar(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_insumo FROM insumo WHERE id_insumo = p_id_insumo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un insumo con esa PK';
    ELSE
        UPDATE insumo SET nombre = p_nombre
        WHERE id_insumo = p_id_insumo;
        SET nResultado = 0;
        SET cMensaje = 'Modificacion exitosa';
    END IF;
END 
// DELIMITER ;

-- PROVEEDOR
DROP PROCEDURE IF EXISTS modificarProveedor;
DELIMITER //
CREATE PROCEDURE modificarProveedor(
    IN p_id_proveedor INT,
    IN p_nombre varchar(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_proveedor FROM proveedor WHERE id_proveedor = p_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe un proveedor con esa PK';
    ELSE
        UPDATE proveedor SET nombre = p_nombre
        WHERE id_proveedor = p_id_proveedor;
        SET nResultado = 0;
        SET cMensaje = 'Modificacion exitosa';
    END IF;
END 
// DELIMITER ;


-- PROVEEDOR_HAS_INSUMO
DROP PROCEDURE IF EXISTS modificarProveedor_has_insumo;
DELIMITER //
CREATE PROCEDURE modificarProveedor_has_insumo(
    IN p_old_proveedor_id_proveedor INT,
	IN p_old_insumo_id_insumo INT,
    IN p_nueva_proveedor_id_proveedor INT,
	IN p_nueva_insumo_id_insumo INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
BEGIN
    SET nResultado = 0;
    SET cMensaje = '';
        
        
    IF NOT EXISTS(SELECT proveedor_id_proveedor from proveedor_has_insumo where proveedor_id_proveedor = p_old_proveedor_id_proveedor and 
    insumo_id_insumo = p_old_insumo_id_insumo) THEN
		SET nResultado = -1;
        SET cMensaje = 'Error: No existe registro con esos id';
    
    -- Verificar si el nuevo proveedor referenciado existe
    ELSEIF NOT EXISTS (SELECT id_proveedor FROM proveedor WHERE id_proveedor = p_nueva_proveedor_id_proveedor) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: El proveedor nuevo no existe';
        
    -- Verificar si el nuevo insumo referenciado existe
    ELSEIF NOT EXISTS (SELECT id_insumo FROM insumo WHERE id_insumo = p_nueva_insumo_id_insumo) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: El insumo nuevo no existe';
        
    ELSE
        UPDATE proveedor_has_insumo SET proveedor_id_proveedor = p_nueva_proveedor_id_proveedor, insumo_id_insumo = p_nueva_insumo_id_insumo
        WHERE proveedor_id_proveedor = p_old_proveedor_id_proveedor and insumo_id_insumo = p_old_insumo_id_insumo;
        SET nResultado = 0;
        SET cMensaje = 'Modificacion exitosa';
    END IF;
END 
// DELIMITER ;


-- *******************************
-- LLAMADAS:
-- *******************************

-- CONCESIONARIA:
SELECT * FROM concesionaria;
-- ALTA
CALL altaConcesionaria (1, 'Concesionaria Juan', @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- BAJAS
 CALL bajaConcesionaria (1, @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;
-- MODIFICACIONES
 CALL modificarConcesionaria (1, 'Concesionaria Juan 2', @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;

-- PEDIDO
SELECT * FROM pedido;
SELECT * FROM pedido_has_modelo;
-- ALTA
CALL altaPedido (1, '2024-09-19 00:30:00', 1, 1, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- BAJAS
CALL bajaPedido(1, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- MODIFICACIONES 
CALL modificarPedidoFecha(1, '2024-09-21 10:00:00', 1, 1, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;

-- INSUMO:
SELECT * FROM insumo;
-- ALTA
CALL altaInsumo (1, 'pintura rosa', @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- BAJAS
 CALL bajaInsumo (1, @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;
 -- MODIFICACIONES
 CALL modificarInsumo (1, 'pintura verde', @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;


-- PROVEEDOR 
SELECT * FROM proveedor;
-- ALTA 
CALL altaProveedor(1,'jose muebles',@nResultado,@cMensaje);
SELECT @nResultado,@cMensaje;
-- BAJA 
 CALL bajaProveedor (1, @nResultado, @cMensaje);
  SELECT @nResultado, @cMensaje;
-- MODIFICACIONES
 CALL modificarProveedor (1, 'mercado Libre', @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;
  
  
  -- PROVEEDOR_HAS_INSUMO:
SELECT * FROM proveedor_has_insumo;
select * from insumo;
select * from proveedor;
-- ALTA
CALL altaProveedor_has_insumo (1, 1, @nResultado, @cMensaje);
SELECT @nResultado, @cMensaje;
-- BAJAS
 CALL bajaProveedor_has_insumo (1, 1, @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;
-- MODIFICACIONES
 CALL modificarProveedor_has_insumo (1, 2, 3, 4, @nResultado, @cMensaje);
 SELECT @nResultado, @cMensaje;
 