-- ПРОЕКТ: Дайвинг-центр
-- Максим Сапунов Jenny6199@yandex.ru
-- Файл №1
-- СОЗДАНИЕ ТАБЛИЦ.

CREATE DATABASE IF NOT EXISTS diving_center;
USE diving_center;


-- ТАБЛИЦА №1 Члены клуба.
DROP TABLE IF EXISTS members;
CREATE TABLE IF NOT EXISTS members (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Идентификатор члена клуба',
	first_name VARCHAR(255) NOT NULL COMMENT 'Имя члена клуба',
	last_name VARCHAR(255) NOT NULL COMMENT 'Фамилия члена клуба',
	email VARCHAR(255) UNIQUE NOT NULL COMMENT 'E-mail адресс',
	phone VARCHAR(255) UNIQUE NOT NULL COMMENT 'Телефон пользователя',
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания учетной записи',
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления учетной записи'
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Члены клуба';


-- ТАБЛИЦА № 2 Адресные данные членов клуба
DROP TABLE IF EXISTS adress_of_members;
CREATE TABLE adress_of_members (
	user_id INT UNSIGNED PRIMARY KEY NOT NULL COMMENT 'Ссылка на идентификатор члена клуба',
	country VARCHAR(255) DEFAULT 'Hidden' COMMENT 'Страна',
	city VARCHAR(255) DEFAULT 'Hidden' COMMENT 'Город',
	street VARCHAR(255) DEFAULT 'Hidden' COMMENT 'Улица',
	house_number INT UNSIGNED DEFAULT NULL COMMENT 'Номер дома',
	apart INT UNSIGNED DEFAULT NULL COMMENT 'Номер квартиры',
	po_index INT UNSIGNED DEFAULT NULL COMMENT 'Почтовый индекс',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления сведений'
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Адреса членов клуба';


-- ТАБЛИЦА № 3 Квалификация членов клуба 
DROP TABLE IF EXISTS qualification_of_members;
CREATE TABLE IF NOT EXISTS qualification_of_members (
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
	user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя',
	step_of_qualification INT UNSIGNED DEFAULT NULL COMMENT 'Идентификатор уровня квалификации',
	instructor_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор инструктора выдавшего сертификат',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата присвоения квалификации',
	site_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор филиала, где была присвоена квалификация'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Сведения о квалификации членов клуба';


-- ТАБЛИЦА № 4 Таблица квалификации (id, разряды квалификации)
CREATE TABLE IF NOT EXISTS levels_of_qualification (
	qualification_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор уровня квалификации',
	type_of_qualification VARCHAR(255) NOT NULL COMMENT 'Тип квалификации',
	name_of_qualification VARCHAR(255) NOT NULL COMMENT 'Название квалификации',
	level_of_qualification INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Уровень квалификации',  
	count_of_dives INT UNSIGNED NOT NULL DEFAULT 10 COMMENT 'Минимальное количество погружений для достижения следующего уровня квалификации'
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Таблица квалификаций';
	

-- ТАБЛИЦА № 5 Логбук погружений
DROP TABLE IF EXISTS log_book;
CREATE TABLE log_book (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор записи погружения',
	user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор дайвера',
	partner_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор напарника',
	site_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор дайв-сайта',
	dive_date DATETIME COMMENT 'Дата погружения',
	dive_deep INT COMMENT 'Глубина погружения',
	dive_time TIME NOT NULL DEFAULT 0 COMMENT 'Длительность погружения', 
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'дата создания и/или обновления записи'
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Логбук погружений';


-- ТАБЛИЦА № 6 Участие в клубных поездках
DROP TABLE IF EXISTS travel_log;
CREATE TABLE travel_log (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор записи',
	user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя',
	travel_date DATE NOT NULL COMMENT 'Год поездки',
	country VARCHAR(255) DEFAULT 'Not indicated' COMMENT 'Направление',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
	COMMENT='Таблица участия в клубных поездках';	


-- ТАБЛИЦА № 7 Отзывы участников клуба
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT UNSIGNED NOT NULL,
	body VARCHAR(255) DEFAULT '---',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Таблица отзывов';


-- ТАБЛИЦА № 8 Клубные поездки
DROP TABLE IF EXISTS club_travels_list;
CREATE TABLE IF NOT EXISTS club_travels_list (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор записи',
	start_date DATETIME DEFAULT NULL COMMENT 'Дата начала поездки',
	duration INT UNSIGNED COMMENT 'Продолжительность поездки',
	specification VARCHAR(255) COMMENT 'Спецификация поездки',
	cost INT UNSIGNED DEFAULT NULL COMMENT 'Стоимость поездки',
	travel_status INT UNSIGNED DEFAULT NULL COMMENT 'Статус поездки',
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления'
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
	COMMENT='Таблица клубных поездок';


-- ТАБЛИЦА № 9 Таблица статусов клубных поездок.
DROP TABLE IF EXISTS status_of_travel;
CREATE TABLE IF NOT EXISTS status_of_travel (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор статуса поездки',
	status ENUM ('завершено', 'проводится', 'ожидается', 'отменено')
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
	COMMENT='Таблица статусов клубных поездок';
	

-- ТАБЛИЦА № 10 Заявки пользователей на участие в поездках.
DROP TABLE IF EXISTS travel_requests;
CREATE TABLE IF NOT EXISTS travel_requests (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор заявки',
	user_id INT UNSIGNED NOT NULL COMMENT 'Идентификатор пользователя',
	payment INT UNSIGNED DEFAULT 0 COMMENT 'Статус оплаты',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
	COMMENT='Таблица заявок';	


-- ТАБЛИЦА № 11 Координаты дайв-сайтов
DROP TABLE IF EXISTS dive_sites;
CREATE TABLE dive_sites (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор сайта',
	latitude FLOAT COMMENT 'Координаты - широта',
	longitude FLOAT COMMENT 'Координаты - долгота',
	path_remoteness INT DEFAULT NULL COMMENT 'Удаленность от транспортных путей' 
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Координаты дайв-сайтов';


-- Таблица № 12 Прокатное снаряжение.
-- в разработке.


-- Таблица № 13 Адреса филиалов.
-- в разработке.


-- Таблица № 14 Staff.
-- в разработке.

	