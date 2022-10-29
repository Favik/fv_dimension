-- Adminer 4.8.1 MySQL 5.5.5-10.3.27-MariaDB-0+deb10u1 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `fv_dimension`;
CREATE TABLE `fv_dimension` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dimension_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `passwd` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `players` int(11) NOT NULL DEFAULT 1,
  `create_time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2022-09-19 22:35:35
