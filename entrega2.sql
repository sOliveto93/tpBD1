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
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`linea_montaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`linea_montaje` (
  `id_linea_montaje` INT NOT NULL,
  `fecha_ingreso` DATE NULL DEFAULT NULL,
  `fecha_egreso` DATE NULL DEFAULT NULL,
  `capacidad_productiva` FLOAT NULL DEFAULT NULL,
  PRIMARY KEY (`id_linea_montaje`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`modelo` (
  `id_modelo` INT NOT NULL,
  `anio` DATE NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `puerta` INT NOT NULL,
  `rueda` INT NOT NULL,
  `litro_pintura` FLOAT NOT NULL,
  `metro_cable` FLOAT NOT NULL,
  `lampara` INT NOT NULL,
  PRIMARY KEY (`id_modelo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`concesionaria` (
  `id_concesionaria` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_concesionaria`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido` (
  `id_pedido` INT NOT NULL,
  `concesionaria_id_concesionaria` INT NOT NULL,
  `fecha` DATETIME(3) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_concesionaria1_idx` (`concesionaria_id_concesionaria` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_concesionaria1`
    FOREIGN KEY (`concesionaria_id_concesionaria`)
    REFERENCES `mydb`.`concesionaria` (`id_concesionaria`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`pedido_has_modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pedido_has_modelo` (
  `pedido_id_pedido` INT NOT NULL,
  `modelo_id_modelo` INT NOT NULL,
  PRIMARY KEY (`pedido_id_pedido`, `modelo_id_modelo`),
  INDEX `fk_pedido_has_modelo_modelo1_idx` (`modelo_id_modelo` ASC) VISIBLE,
  INDEX `fk_pedido_has_modelo_pedido1_idx` (`pedido_id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_has_modelo_pedido1`
    FOREIGN KEY (`pedido_id_pedido`)
    REFERENCES `mydb`.`pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_has_modelo_modelo1`
    FOREIGN KEY (`modelo_id_modelo`)
    REFERENCES `mydb`.`modelo` (`id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
    REFERENCES `mydb`.`pedido_has_modelo` (`pedido_id_pedido` , `modelo_id_modelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`estacion_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`estacion_trabajo` (
  `id_estacion_trabajo` INT NOT NULL,
  `linea_montaje_id_linea_montaje` INT NOT NULL,
  `fecha_ingreso` DATE NULL DEFAULT NULL,
  `fecha_egreso` DATE NULL DEFAULT NULL,
  `tarea` VARCHAR(45) NULL DEFAULT NULL,
  `orden` INT NULL,
  PRIMARY KEY (`id_estacion_trabajo`),
  INDEX `fk_estacion_trabajo_linea_montaje1_idx` (`linea_montaje_id_linea_montaje` ASC) VISIBLE,
  CONSTRAINT `fk_estacion_trabajo_linea_montaje1`
    FOREIGN KEY (`linea_montaje_id_linea_montaje`)
    REFERENCES `mydb`.`linea_montaje` (`id_linea_montaje`))
ENGINE = InnoDB
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
-- Table `mydb`.`insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`insumo` (
  `id_insumo` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_insumo`))
ENGINE = InnoDB
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
  `id_proveedor` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `mydb`.`proveedor_has_insumo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proveedor_has_insumo` (
  `proveedor_id_proveedor` INT NOT NULL,
  `insumo_id_insumo` INT NOT NULL,
  `precio` FLOAT NULL,
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
