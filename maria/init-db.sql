DROP DATABASE IF EXISTS `odbc-trigger`;

CREATE DATABASE `odbc-trigger`;

DROP TABLE IF EXISTS `odbc-trigger`.person;

CREATE TABLE `odbc-trigger`.person (
	id INT PRIMARY KEY auto_increment,
	name varchar(10) NOT NULL,
	ageId INT NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `odbc-trigger`.age;

CREATE TABLE `odbc-trigger`.age (
	id INT PRIMARY KEY auto_increment,
	edad INT NOT NULL
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `odbc-trigger`.person_audit;

CREATE TABLE `odbc-trigger`.person_audit (
	id INT NOT NULL,
	operationId INT NOT NULL,
	columnName TEXT NOT NULL,
	oldValue TEXT,
	newValue TEXT,
	dateModified TIMESTAMP NOT NULL,
	PRIMARY KEY (id, operationId, dateModified)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_general_ci;

INSERT INTO `odbc-trigger`.age (id, edad)
VALUES(default, 21), (default, 26), (default, 31),
(default, 36), (default, 41), (default, 46),
(default, 51), (default, 56), (default, 61),
(default, 66);

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_ins;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_ins AFTER INSERT ON `odbc-trigger`.person
FOR EACH ROW BEGIN
	INSERT INTO `odbc-trigger`.person_audit (
		id,	operationId, columnName,
		oldValue,	newValue, dateModified)
	VALUES( NEW.id, 0, 'name', NULL,
		NEW.name, CURRENT_TIMESTAMP);
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_upd;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_upd AFTER UPDATE ON `odbc-trigger`.person
FOR EACH ROW BEGIN
		INSERT INTO `odbc-trigger`.person_audit (id, operationId, columnName,
		oldValue,	newValue, dateModified)
		VALUES( NEW.id, 1, 'name'
			, OLD.name
			, NEW.name
			, CURRENT_TIMESTAMP);
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS `odbc-trigger`.tr_person_audit_del;

DELIMITER $$

CREATE TRIGGER `odbc-trigger`.tr_person_audit_del AFTER DELETE ON `odbc-trigger`.person
FOR EACH ROW BEGIN
	INSERT INTO `odbc-trigger`.person_audit (id, operationId, columnName,
	oldValue,	newValue, dateModified)
	VALUES( OLD.id, 2, 'name'
		, OLD.name
		, NULL
		, CURRENT_TIMESTAMP);
END$$

DELIMITER ;
