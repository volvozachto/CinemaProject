-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema cinema_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `cinema_db` ;

-- -----------------------------------------------------
-- Schema cinema_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cinema_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cinema_db` ;

-- -----------------------------------------------------
-- Table `cinema_db`.`accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`accounts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(32) NOT NULL,
  `password` VARCHAR(64) NOT NULL,
  `email` VARCHAR(64) NULL DEFAULT NULL,
  `role` ENUM('0', '1') NOT NULL,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  `surname` VARCHAR(45) NULL DEFAULT NULL,
  `birth_date` DATE NULL DEFAULT NULL,
  `create_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`orders` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`account_has_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`account_has_orders` (
  `id_account` INT UNSIGNED NOT NULL,
  `id_order` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_account`, `id_order`),
  INDEX `fk_orders_id_idx` (`id_order` ASC) VISIBLE,
  CONSTRAINT `fk_account_id`
    FOREIGN KEY (`id_account`)
    REFERENCES `cinema_db`.`accounts` (`id`),
  CONSTRAINT `fk_orders_id`
    FOREIGN KEY (`id_order`)
    REFERENCES `cinema_db`.`orders` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`films`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`films` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `genre` ENUM('action', 'adventure', 'comedy', 'drama', 'fantasy', 'horror', 'mystery', 'romance', 'thriller', 'western', 'cartoon') NULL,
  `description` TEXT NULL,
  `release_date` DATE NOT NULL,
  `age_restriction` TINYINT(3) UNSIGNED ZEROFILL NOT NULL,
  `duration` TIME NOT NULL,
  `trailer_link` VARCHAR(2083) NULL,
  `image_path` VARCHAR(2083) NULL,
  `country` VARCHAR(64) NULL,
  `language` VARCHAR(64) NULL,
  `original_name` VARCHAR(64) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`halls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`halls` (
  `number` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `capacity` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `cinema_db`.`places`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`places` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `num` INT UNSIGNED NOT NULL,
  `row` INT UNSIGNED NOT NULL,
  `hall_number` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_hall_number_idx` (`hall_number` ASC) VISIBLE,
  CONSTRAINT `fk_hall_number`
    FOREIGN KEY (`hall_number`)
    REFERENCES `cinema_db`.`halls` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`screenings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`screenings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_film` INT UNSIGNED NOT NULL,
  `screening_time` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_film_id_idx` (`id_film` ASC) VISIBLE,
  CONSTRAINT `fk_film_id`
    FOREIGN KEY (`id_film`)
    REFERENCES `cinema_db`.`films` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`screening_places`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`screening_places` (
  `id_place` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_screening` INT UNSIGNED NOT NULL,
  `price` DECIMAL(10,2) UNSIGNED NOT NULL,
  `is_occupied` TINYINT(1) UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`id_place`, `id_screening`),
  INDEX `fk_place_idx` (`id_place` ASC) VISIBLE,
  INDEX `fk_screening_idx` (`id_screening` ASC) VISIBLE,
  CONSTRAINT `fk_place`
    FOREIGN KEY (`id_place`)
    REFERENCES `cinema_db`.`places` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_screening`
    FOREIGN KEY (`id_screening`)
    REFERENCES `cinema_db`.`screenings` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`tickets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`tickets` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_place` INT UNSIGNED NOT NULL,
  `id_screening` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_screening_places_idx` (`id_place` ASC, `id_screening` ASC) VISIBLE,
  CONSTRAINT `fk_screening_places_ids`
    FOREIGN KEY (`id_place` , `id_screening`)
    REFERENCES `cinema_db`.`screening_places` (`id_place` , `id_screening`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cinema_db`.`order_has_tickets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cinema_db`.`order_has_tickets` (
  `id_order` INT UNSIGNED NOT NULL,
  `id_ticket` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_order`, `id_ticket`),
  INDEX `fk_ticket_id_idx` (`id_ticket` ASC) VISIBLE,
  CONSTRAINT `fk_order_id`
    FOREIGN KEY (`id_order`)
    REFERENCES `cinema_db`.`orders` (`id`),
  CONSTRAINT `fk_ticket_id`
    FOREIGN KEY (`id_ticket`)
    REFERENCES `cinema_db`.`tickets` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `cinema_db`.`accounts`
-- -----------------------------------------------------
START TRANSACTION;
USE `cinema_db`;
INSERT INTO `cinema_db`.`accounts` (`id`, `username`, `password`, `email`, `role`, `name`, `surname`, `birth_date`, `create_date`) VALUES (DEFAULT, 'admin', '562df519b92409259e2a021cf881d58df9588c7fcac5c0530113cbb43ea8c892', NULL, '0', NULL, NULL, NULL, '2020-09-23 16:55:34');
INSERT INTO `cinema_db`.`accounts` (`id`, `username`, `password`, `email`, `role`, `name`, `surname`, `birth_date`, `create_date`) VALUES (DEFAULT, 'user', 'bed92542da740cbe587ac45b7901207a17a2563680b2ceda304195a2733f14be', 'fogmrfog@gmail.com', '1', 'Oleksii', 'Yavtushenko', '30.03.2002', '2020-09-23 16:55:47');
INSERT INTO `cinema_db`.`accounts` (`id`, `username`, `password`, `email`, `role`, `name`, `surname`, `birth_date`, `create_date`) VALUES (DEFAULT, 'pupsik', '5fb1b1d2e07e9e26f4bdad9c9f13e7141b6e5b0d47f5dea57907e9eceda23614', NULL, '1', NULL, NULL, NULL, '2020-09-23 16:55:55');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cinema_db`.`films`
-- -----------------------------------------------------
START TRANSACTION;
USE `cinema_db`;
INSERT INTO `cinema_db`.`films` (`id`, `name`, `genre`, `description`, `release_date`, `age_restriction`, `duration`, `trailer_link`, `image_path`, `country`, `language`, `original_name`) VALUES (DEFAULT, 'Шрек-2', 'cartoon', 'У Шрека та Фіони — медовий місяць. Вони отримують послання від батьків Фіони — короля та королеви королівства «Далеко-далеко». Фіона вмовляє чоловіка поїхати, стверджуючи, що батьки будуть раді їх бачити, і врешті-решт вони залишають будинок на «казкових істот», беруть Осла і виїжджають на своїй кареті-цибулині. Але коли король Гарольд бачить Шрека і Фіону, особливої радості він не відчуває. За ідеєю, Фіону повинен був звільнити і узяти в дружини принц Красивий, але він, очевидно, спізнився. Далі виявляється, що мати принца — фея-Хрещена Фіони, і вони цій весіллям давно вже замишляють прибрати до рук королівство.', '2004-05-19', 0, '01:33:00', 'https://www.youtube.com/watch?v=V6X5ti4YlG8&ab_channel=DreamworksAnimFan', NULL, 'USA', 'Ukrainian', 'Shrek-2');
INSERT INTO `cinema_db`.`films` (`id`, `name`, `genre`, `description`, `release_date`, `age_restriction`, `duration`, `trailer_link`, `image_path`, `country`, `language`, `original_name`) VALUES (DEFAULT, 'Гренландія', 'action', 'Уламки гігантської комети мчать до Землі і загрожують знищити планету. Кінець світу здається неминучим. Єдине безпечне місце – бункер у далекій Гренландії. Джон (Джерард Батлер), його дружина та син вирушають у небезпечну подорож. На їхньому шляху до порятунку – не лише руйнівні уламки комети, але й паніка людей, які збожеволіли від жаху. Під час глобальної катастрофи людські закони вже не діють і кожен – сам за себе...', '2020-09-24', 16, '01:59:00', 'https://www.youtube.com/watch?v=sZBM492Ufco&ab_channel=iVideos', NULL, 'USA', 'Ukrainian', 'Greenland');
INSERT INTO `cinema_db`.`films` (`id`, `name`, `genre`, `description`, `release_date`, `age_restriction`, `duration`, `trailer_link`, `image_path`, `country`, `language`, `original_name`) VALUES (DEFAULT, 'Дулітл', 'adventure', 'Вікторіанська Англія. Доктор Дулітл, у минулому досить відомий по всій країні ветеринар, уже сім років як веде спосіб життя затворника – усе через смерть його дружини, коли життя чоловіка втратило сенс. Весь цей час він проводив у своєму особняку з різними екзотичними тваринами. Думаєте, йому було нудно? Як би не так, адже доктор Дулітл вміє розмовляти із тваринами. Єдине, що змусило чоловіка вийти за межі особняка, це невідома хвороба юної королеви, яка може привести до її смерті. Заради порятунку маленької дівчинки, доктор разом зі своїми вірними друзями відправиться до міфічного острова на пошуки ліків. Він пройде чимало пригод на своєму шляху, де треба бути сміливим і розумним.', '2020-01-09', 0, '01:41:00', 'https://www.youtube.com/watch?v=YEmuuZnWb1s&ab_channel=B%26HFilmDistributionCompany', '', 'USA', 'Ukrainian', 'Dolittle');
INSERT INTO `cinema_db`.`films` (`id`, `name`, `genre`, `description`, `release_date`, `age_restriction`, `duration`, `trailer_link`, `image_path`, `country`, `language`, `original_name`) VALUES (DEFAULT, 'Де ти, Адаме?', 'drama', 'Стрічка занурює глядача у життя братії одного з древніх монастирів Святої Гори Афон. Віддалене від мирської суєти та цивілізації, усамітнене чернече життя вражає насиченістю, адже воно сповнене виняткових реальних персонажів, дійсних «несвятих святих» - ось яким воно постає на екрані з-під нашарувань світських скороминущих пріоритетів. Глядачі прилучаються до абсолютно безпрецедентного способу життя чернечої громади, який виник тисячі років тому і збережений дотепер.', '2020-09-03', 0, '01:18:00', 'https://www.youtube.com/watch?v=-ULSsMrGelQ&ab_channel=%D0%A1%D1%96%D0%BD%D0%B5%D0%BC%D0%B0%D1%82%D0%B8%D0%BA%D0%BE', NULL, 'Greece', 'Greek', 'Where are you, Adam?');

COMMIT;


-- -----------------------------------------------------
-- Data for table `cinema_db`.`halls`
-- -----------------------------------------------------
START TRANSACTION;
USE `cinema_db`;
INSERT INTO `cinema_db`.`halls` (`number`, `capacity`) VALUES (DEFAULT, 60);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cinema_db`.`places`
-- -----------------------------------------------------
START TRANSACTION;
USE `cinema_db`;
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 1, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 2, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 9, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 10, 3, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 9, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 10, 4, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 5, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 6, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 1, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 2, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 3, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 4, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 5, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 6, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 7, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 8, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 9, 7, 1);
INSERT INTO `cinema_db`.`places` (`id`, `num`, `row`, `hall_number`) VALUES (DEFAULT, 10, 7, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `cinema_db`.`screenings`
-- -----------------------------------------------------
START TRANSACTION;
USE `cinema_db`;
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 1, '2020-10-23 09:00:00');
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 1, '2020-10-23 12:00:00');
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 2, '2020-10-24 15:30:00');
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 1, '2020-10-24 10:30:00');
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 3, '2020-10-23 10:45:00');
INSERT INTO `cinema_db`.`screenings` (`id`, `id_film`, `screening_time`) VALUES (DEFAULT, 4, '2020-10-25 16:00:00');

COMMIT;

