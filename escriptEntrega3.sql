-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`linea_montaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`linea_montaje` (
  `id_linea_montaje` INT NOT NULL AUTO_INCREMENT,
  `fecha_ingreso` DATE NULL DEFAULT NULL,
  `fecha_egreso` DATE NULL DEFAULT NULL,
  `capacidad_productiva` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id_linea_montaje`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`modelo` (
  `id_modelo` INT NOT NULL AUTO_INCREMENT,
  `anio` DATE NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `puerta` INT NOT NULL,
  `rueda` INT NOT NULL,
  `litro_pintura` FLOAT NOT NULL,
  `metro_cable` FLOAT NOT NULL,
  `lampara` INT NOT NULL,
  PRIMARY KEY (`id_modelo`))
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`concesionaria` (
  `id_concesionaria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_concesionaria`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `concesionaria_id_concesionaria` INT NOT NULL,
  `fecha` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_concesionaria1_idx` (`concesionaria_id_concesionaria` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_concesionaria1`
    FOREIGN KEY (`concesionaria_id_concesionaria`)
    REFERENCES `mydb`.`concesionaria` (`id_concesionaria`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pedido_has_modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido_has_modelo` (
  `pedido_id_pedido` INT NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`pedido_id_pedido`, `modelo_id_modelo`),
  INDEX `fk_pedido_has_modelo_modelo1_idx` (`modelo_id_modelo` ASC) VISIBLE,
  INDEX `fk_pedido_has_modelo_pedido1_idx` (`pedido_id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_has_modelo_modelo1`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `mydb`.`modelo` (`id_modelo`),
  CONSTRAINT `fk_pedido_has_modelo_pedido1`
    FOREIGN KEY (`pedido_id_pedido`)
    REFERENCES `mydb`.`pedido` (`id_pedido`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`automovil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`automovil` (
  `chasis` VARCHAR(45) NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  `linea_montaje_id_linea_montaje` INT NOT NULL,
  `automovilcol` VARCHAR(45) NULL DEFAULT NULL,
  `pedido_has_modelo_pedido_id_pedido` INT NOT NULL,
  `pedido_has_modelo_modelo_id_modelo` INT NOT NULL,
  `fecha_finalizacion` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`chasis`, `pedido_has_modelo_pedido_id_pedido`, `pedido_has_modelo_modelo_id_modelo`),
  INDEX `fk_automovil_modelo1_idx` (`modelo_id_modelo` ASC) VISIBLE,
  INDEX `fk_automovil_linea_montaje1_idx` (`linea_montaje_id_linea_montaje` ASC) VISIBLE,
  INDEX `fk_automovil_pedido_has_modelo1_idx` (`pedido_has_modelo_pedido_id_pedido` ASC, `pedido_has_modelo_modelo_id_modelo` ASC) VISIBLE,
  CONSTRAINT `fk_automovil_linea_montaje1`
    FOREIGN KEY (`linea_montaje_id_linea_montaje`)
    REFERENCES `mydb`.`linea_montaje` (`id_linea_montaje`),
  CONSTRAINT `fk_automovil_modelo1`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `mydb`.`modelo` (`id_modelo`),
  CONSTRAINT `fk_automovil_pedido_has_modelo1`
    FOREIGN KEY (`pedido_has_modelo_pedido_id_pedido` , `pedido_has_modelo_modelo_id_modelo`)
    REFERENCES `mydb`.`pedido_has_modelo` (`pedido_id_pedido` , `modelo_id_modelo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`estacion_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estacion_trabajo` (
  `id_estacion_trabajo` INT NOT NULL AUTO_INCREMENT,
  `linea_montaje_id_linea_montaje` INT NOT NULL,
  `fecha_ingreso` DATE NULL DEFAULT NULL,
  `fecha_egreso` DATE NULL DEFAULT NULL,
  `tarea` VARCHAR(45) NULL DEFAULT NULL,
  `orden` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_estacion_trabajo`),
  INDEX `fk_estacion_trabajo_linea_montaje1_idx` (`linea_montaje_id_linea_montaje` ASC) VISIBLE,
  CONSTRAINT `fk_estacion_trabajo_linea_montaje1`
    FOREIGN KEY (`linea_montaje_id_linea_montaje`)
    REFERENCES `mydb`.`linea_montaje` (`id_linea_montaje`))
ENGINE = InnoDB
AUTO_INCREMENT = 31
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`automovil_has_estacion_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`automovil_has_estacion_trabajo` (
  `automovil_chasis` VARCHAR(45) NOT NULL,
  `estacion_trabajo_id_estacion_trabajo` INT NOT NULL,
  `fecha_entrada` DATETIME NULL DEFAULT NULL,
  `fecha_salida` DATETIME NULL DEFAULT NULL,
  `activo` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`automovil_chasis`, `estacion_trabajo_id_estacion_trabajo`),
  INDEX `fk_automovil_has_estacion_trabajo_estacion_trabajo1_idx` (`estacion_trabajo_id_estacion_trabajo` ASC) VISIBLE,
  INDEX `fk_automovil_has_estacion_trabajo_automovil1_idx` (`automovil_chasis` ASC) VISIBLE,
  CONSTRAINT `fk_automovil_has_estacion_trabajo_automovil1`
    FOREIGN KEY (`automovil_chasis`)
    REFERENCES `mydb`.`automovil` (`chasis`),
  CONSTRAINT `fk_automovil_has_estacion_trabajo_estacion_trabajo1`
    FOREIGN KEY (`estacion_trabajo_id_estacion_trabajo`)
    REFERENCES `mydb`.`estacion_trabajo` (`id_estacion_trabajo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`debug_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`debug_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mensaje` VARCHAR(255) NULL DEFAULT NULL,
  `fecha` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mydb`.`insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`insumo` (
  `id_insumo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_insumo`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`insumo_has_estacion_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`insumo_has_estacion_trabajo` (
  `insumo_id_insumo` INT NOT NULL,
  `estacion_trabajo_id_estacion_trabajo` INT NOT NULL,
  PRIMARY KEY (`insumo_id_insumo`, `estacion_trabajo_id_estacion_trabajo`),
  INDEX `fk_insumo_has_estacion_trabajo_estacion_trabajo1_idx` (`estacion_trabajo_id_estacion_trabajo` ASC) VISIBLE,
  INDEX `fk_insumo_has_estacion_trabajo_insumo1_idx` (`insumo_id_insumo` ASC) VISIBLE,
  CONSTRAINT `fk_insumo_has_estacion_trabajo_estacion_trabajo1`
    FOREIGN KEY (`estacion_trabajo_id_estacion_trabajo`)
    REFERENCES `mydb`.`estacion_trabajo` (`id_estacion_trabajo`),
  CONSTRAINT `fk_insumo_has_estacion_trabajo_insumo1`
    FOREIGN KEY (`insumo_id_insumo`)
    REFERENCES `mydb`.`insumo` (`id_insumo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proveedor` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`proveedor_has_insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proveedor_has_insumo` (
  `proveedor_id_proveedor` INT NOT NULL,
  `insumo_id_insumo` INT NOT NULL,
  `precio` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`proveedor_id_proveedor`, `insumo_id_insumo`),
  INDEX `fk_proveedor_has_insumo_insumo1_idx` (`insumo_id_insumo` ASC) VISIBLE,
  INDEX `fk_proveedor_has_insumo_proveedor1_idx` (`proveedor_id_proveedor` ASC) VISIBLE,
  CONSTRAINT `fk_proveedor_has_insumo_insumo1`
    FOREIGN KEY (`insumo_id_insumo`)
    REFERENCES `mydb`.`insumo` (`id_insumo`),
  CONSTRAINT `fk_proveedor_has_insumo_proveedor1`
    FOREIGN KEY (`proveedor_id_proveedor`)
    REFERENCES `mydb`.`proveedor` (`id_proveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure altaConcesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaConcesionaria`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure altaInsumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaInsumo`(
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure altaPedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaPedido`(
    IN p_id_pedido INT,
    IN p_fecha DATETIME,
    IN p_concesionaria_id_concesionaria INT,
    IN p_modelo_id_modelo INT,
    IN p_cantidad INT,
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
        INSERT INTO pedido_has_modelo (modelo_id_modelo, pedido_id_pedido,cantidad) 
        VALUES (p_modelo_id_modelo, p_id_pedido,p_cantidad);
        
        SET nResultado = 0;
        SET cMensaje = 'Alta exitosa';

    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure altaProveedor
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaProveedor`(
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
    END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure altaProveedor_has_insumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `altaProveedor_has_insumo`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure bajaConcesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaConcesionaria`(
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
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure bajaInsumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaInsumo`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure bajaPedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaPedido`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure bajaProveedor
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaProveedor`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure bajaProveedor_has_insumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bajaProveedor_has_insumo`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crearEstacionesTrabajo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crearEstacionesTrabajo`(
	IN lineaMontaje_id INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)

)
pro:begin
	declare cont int default 0;
    
    set nResultado=0;
    set cMensaje="";
-- comprobamos que la linea montaje id existe y 
-- que no tenga estaciones de trabajo creadas
 IF NOT EXISTS (SELECT id_linea_montaje FROM linea_montaje WHERE id_linea_montaje = lineaMontaje_id) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe linea de montaje con ese id';
        LEAVE pro;
 END IF;

SELECT count(*) into cont from estacion_trabajo where linea_montaje_id_linea_montaje = lineaMontaje_id;
 if(cont>0) then
		SET nResultado = -2;
		SET cMensaje = 'Error: ya existen estaciones de trabajo creadas para este linea de montaje';
       
	LEAVE pro;
 END IF;
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"ensamblado de chapa",1);
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"mecanica de motor",2);
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"mecanica de rodaje",3);
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"pintura",4);
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"electricidad",5);
    insert into estacion_trabajo(linea_montaje_id_linea_montaje, fecha_ingreso, fecha_egreso, tarea, orden)
    values(lineaMontaje_id,null,null,"prueba",6);
	
-- Mensaje de éxito
    SET nResultado = 0;  -- Éxito
    SET cMensaje = 'Estaciones de trabajo creadas exitosamente';
END pro$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure crearLineaMontaje
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `crearLineaMontaje`(
    IN modelo_id VARCHAR(45),
    IN capacidad_prod INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
main:begin
	SET nResultado = 0;
    SET cMensaje = '';
if not exists(select id_modelo from modelo where id_modelo=modelo_id) then
		SET nResultado = -1;
        SET cMensaje = 'ERROR: este modelo id no existe actualmente';
leave main;
end if;
if exists(select id_linea_montaje from linea_montaje where id_linea_montaje=modelo_id)then
		SET nResultado = -2;
        SET cMensaje = 'ERROR: linea de montaje ya esta creada para este modelo de vehiculo';
leave main;
else 
	insert into linea_montaje(id_linea_montaje, fecha_ingreso, fecha_egreso, capacidad_productiva) values(modelo_id,null,null,capacidad_prod);
	SET nResultado = 0;  -- Éxito
    SET cMensaje = 'Línea de montaje creada exitosamente';
end if;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure generarAutoPorPedido
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generarAutoPorPedido`(
    IN pedido_id INT, 
    OUT nResultado INT, 
    OUT cMensaje VARCHAR(256)
)
main:BEGIN
    DECLARE modelo_id INT;
    DECLARE cant INT default 0;
    DECLARE cont INT DEFAULT 0;
    DECLARE done INT DEFAULT 0;
    DECLARE nombre VARCHAR(45);
    DECLARE chasisA VARCHAR(20);
    DECLARE chasis_exists INT;
    declare linea_montaje_id int;
   
	SET nResultado = 0;
    SET cMensaje = '';
	
    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT id_pedido FROM pedido WHERE id_pedido = pedido_id) THEN
        SET nResultado = -2;
        SET cMensaje = 'Error: No existe pedido con ese id';
	leave main;
    ELSEIF EXISTS (SELECT pedido_has_modelo_pedido_id_pedido FROM automovil WHERE pedido_has_modelo_pedido_id_pedido = pedido_id) THEN
        SET nResultado = -1;
        SET cMensaje = 'Error: Pedido ya esta en la tabla vehiculo';
	leave main;
    ELSE
		-- obtenemos la cantidad de autos en el pedidoy el id del modelo
        select modelo_id_modelo,cantidad into modelo_id,cant from pedido_has_modelo where pedido_id_pedido=pedido_id;
        -- Obtener el nombre del modelo
            SELECT nombre INTO nombre FROM modelo WHERE id_modelo = modelo_id;
		
        -- verificamos que este creada la estacion de trabajo
		if not exists(SELECT id_linea_montaje FROM linea_montaje WHERE id_linea_montaje=modelo_id)then
			SET nResultado = -3;
			SET cMensaje = 'Error: no existe linea montaje para este modelo de vehiculo';
        leave main;
		end if;
        -- existe por lo tanto la recuperamos
        select id_linea_montaje into linea_montaje_id from linea_montaje where id_linea_montaje=modelo_id;
	while cont < cant do
		 SET chasisA = CONCAT(
                    UPPER(CHAR(FLOOR(65 + RAND() * 26))),  -- letra aleatoria
                    UPPER(CHAR(FLOOR(65 + RAND() * 26))),
                    UPPER(CHAR(FLOOR(65 + RAND() * 26))),
                    FLOOR(1000 + RAND() * 9000)  -- números aleatorios
                );

                -- Verificar si el chasis ya existe
                SELECT COUNT(*) INTO chasis_exists 
                FROM automovil 
                WHERE chasis = chasisA;

                -- Si el chasis no existe, insertar y Y SUMAR CONT
                IF chasis_exists = 0 THEN
                    -- Insertar en la tabla automovil
                    INSERT INTO automovil (chasis, modelo_id_modelo, linea_montaje_id_linea_montaje, automovilcol, pedido_has_modelo_pedido_id_pedido, pedido_has_modelo_modelo_id_modelo,fecha_finalizacion)
                    VALUES (chasisA, modelo_id, linea_montaje_id, nombre, pedido_id, modelo_id,null);
                    -- TODO CORRECTO SETEAMOS EL CONTADOR +1 Y LOS MENSAJES
                    SET cont=cont+1;
                    SET nResultado = 0;  -- Éxito
                    SET cMensaje = 'Alta exitosa';
                END IF;
	END while;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure iniciarMontaje
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciarMontaje`(
	IN n_chasis varchar(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
main:begin
	declare linea_montaje int;
	declare estacionTrabajo_Id int;
    declare ocupante_Chasis varchar(45);
	SET nResultado = 0;
    SET cMensaje = '';
-- existe el vehiculo?
	if not exists(select chasis from automovil where chasis = n_chasis)then
		SET nResultado = -1;
        SET cMensaje = 'ERROR: no existe un vehiculo con ese chasis';
    leave main;
    end if;
    
-- que linea tiene asignada
	select linea_montaje_id_linea_montaje into linea_montaje from  automovil where chasis = n_chasis;
-- asignar la primer estacion de esta linea si esta desocupada
-- obtenemos el id de la primer estacion
	select id_estacion_trabajo into estacionTrabajo_Id from estacion_trabajo where linea_montaje = linea_montaje_id_linea_montaje and orden = 1;
	-- verificamos que no sea null
    if estacionTrabajo_Id is null then
		SET nResultado = -2;
		SET cMensaje = 'ERROR: no existe estacion de trabajo de orden 1 para esta linea de montaje';
		leave main;
	end if;
    
    -- Verificar si la estación de trabajo esta ocupada
    SELECT automovil_chasis INTO ocupante_Chasis 
    FROM automovil_has_estacion_trabajo 
    WHERE estacion_trabajo_id_estacion_trabajo = estacionTrabajo_Id AND activo = 1;

    IF ocupante_Chasis IS NOT NULL THEN
        SET nResultado = -3;
        SET cMensaje = CONCAT('ERROR: la estación de trabajo esta ocupada por el vehículo con chasis: ', ocupante_Chasis);
        LEAVE main;
    END IF;
    insert into automovil_has_estacion_trabajo(automovil_chasis, estacion_trabajo_id_estacion_trabajo, fecha_entrada, fecha_salida, activo)
    values(n_chasis,estacionTrabajo_Id,null,null,1);
    SET nResultado = 0;
    SET cMensaje = 'el auto ha sido asignado a la estacion de trabajo con exito.';
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarConcesionaria
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarConcesionaria`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarInsumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarInsumo`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarPedidoFecha
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarPedidoFecha`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarProveedor
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarProveedor`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure modificarProveedor_has_insumo
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `modificarProveedor_has_insumo`(
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
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure moverEstacion
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `moverEstacion`(
	IN n_chasis varchar(45),
    OUT nResultado INT,
    OUT cMensaje VARCHAR(256)
)
main:begin 
declare lineaMontaje_id int;
declare estacion_id int;
declare cant_estaciones int default 0;
declare ultima_estacion int;
declare current_orden int;
declare next_estacion_id int;
declare ocupante_Chasis int;

DECLARE pedido_id_pedido INT;
DECLARE modelo_id_modelo INT;
	SET nResultado = 0;
    SET cMensaje = '';
    
    -- existe el vehiculo?
	if not exists(select chasis from automovil where chasis = n_chasis)then
		SET nResultado = -1;
        SET cMensaje = 'ERROR: no existe un vehiculo con ese chasis';
    leave main;
    end if;
    -- recuperamos la linea de montaje
    select linea_montaje_id_linea_montaje into lineaMontaje_id from automovil where chasis = n_chasis;
	-- buscamos si esta en alguna estacion
    select estacion_trabajo_id_estacion_trabajo into estacion_id from automovil_has_estacion_trabajo where automovil_chasis = n_chasis;
    
    if estacion_id is null then
    leave main;
			SET nResultado = -2;
			SET cMensaje = 'ERROR: el vehiculo no tiene estacion de trabajo asignada';
    end if;
    -- si lo esta finalizamos la pasamos a la siguiente de ser posible
		-- cuantas de trabajo hay?
		select count(*) into cant_estaciones from estacion_trabajo where linea_montaje_id_linea_montaje = lineaMontaje_id;
        select MAX(orden) into ultima_estacion from estacion_trabajo where linea_montaje_id_linea_montaje = lineaMontaje_id; 
        
        -- sabemos donde esta --> estacion_id queremos el orden actual
        select orden into current_orden from estacion_trabajo where id_estacion_trabajo = estacion_id;
        
    -- si es la ultima modificar la fecha en automovil y marcar como finalizado si no la movemos solamente
		-- si no esta en la ultima
        if (current_orden < ultima_estacion) then
			set current_orden = current_orden + 1;
            
			-- recuperamos el id de la estacion con ese orden
            select id_estacion_trabajo into next_estacion_id from estacion_trabajo where linea_montaje_id_linea_montaje = lineaMontaje_id and orden = current_orden; 
			-- Verificar si la estación de trabajo esta ocupada
            
				SELECT automovil_chasis INTO ocupante_Chasis 
				FROM automovil_has_estacion_trabajo 
				WHERE estacion_trabajo_id_estacion_trabajo = next_estacion_id AND activo = 1;

			IF ocupante_Chasis IS NOT NULL THEN
				SET nResultado = -3;
				SET cMensaje = CONCAT('ERROR: la estación de trabajo esta ocupada por el vehículo con chasis: ', ocupante_Chasis);
				LEAVE main;
			END IF;
           -- no esta ocupada, lo movemos (necesita las 2 pk por el safa mode)
            UPDATE automovil_has_estacion_trabajo
			SET estacion_trabajo_id_estacion_trabajo = next_estacion_id
			WHERE automovil_chasis = n_chasis and estacion_trabajo_id_estacion_trabajo =estacion_id ;
            SET nResultado = 0;
			SET cMensaje = 'movido a la siguiente estacion con exito';
        
        else
        -- estamos al final
		-- quitamos de la linea de la estacion y modificamos la fecha en automovil
		DELETE FROM automovil_has_estacion_trabajo
		WHERE automovil_chasis = n_chasis AND estacion_trabajo_id_estacion_trabajo = estacion_id;
        
		-- modificamos fecha de salida en automovil (necesito todas la pk por el safe mode)
       -- recuperamos las pk
    
        SELECT pedido_has_modelo_pedido_id_pedido, pedido_has_modelo_modelo_id_modelo INTO pedido_id_pedido, modelo_id_modelo
        FROM automovil WHERE chasis = n_chasis;
       
			UPDATE automovil
		    SET fecha_finalizacion = NOW()
			WHERE chasis = n_chasis 
            and pedido_has_modelo_pedido_id_pedido = pedido_id_pedido
            and pedido_has_modelo_modelo_id_modelo = modelo_id_modelo;
		    SET nResultado = 0; 
			SET cMensaje = 'El vehículo ha sido finalizado.';
		end if;
end$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
