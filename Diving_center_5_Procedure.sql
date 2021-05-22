-- ПРОЕКТ: Дайвинг-центр.
-- Максим Сапунов Jenny6199@yandex.ru
-- Файл №5
-- СОЗДАНИЕ ХРАНИМЫХ ПРОЦЕДУР И ТРИГГЕРОВ

DELIMITER //

-- ПРОЦЕДУРА №1. Персональный лог-бук. В качестве переменной используется id
-- члена клуба. 
CREATE PROCEDURE IF NOT EXISTS personal_log_book(IN m_id INT)
BEGIN
	SET @i = m_id;
	SELECT 
		(SELECT CONCAT(m.last_name, ' ', m.first_name) 
			FROM members AS m 
			WHERE m.id = log_book.user_id) AS Diver,
		(SELECT CONCAT(m.last_name, ' ', m.first_name) 
			FROM members AS m 
			WHERE m.id = log_book.partner_id) AS Buddy,
		site_id,
		DATE(dive_date) AS dive_date,
		dive_deep,
		dive_time
	FROM log_book
	WHERE user_id = @i OR partner_id = @i;
END//


-- ПРОЦЕДУРА №2. История поездок члена клуба.
CREATE PROCEDURE personal_travel_log (IN m_id INT)
BEGIN
	SET @i = m_id;
	SELECT 
		(SELECT CONCAT(m.last_name, ' ', m.first_name) 
			FROM members AS m WHERE tl.user_id = m.id) AS 'Member',
		travel_date,
		country
	FROM travel_log AS tl
	WHERE user_id = @i;
END//


-- ТРИГГЕР №1. Проверка имени пользователя перед внесением в таблицу members.
CREATE TRIGGER check_members_unique_name BEFORE INSERT ON members
FOR EACH ROW
BEGIN
	DECLARE chek_first_name INT;
	DECLARE chek_last_name INT;
	SET @check_first_name = (SELECT NEW.first_name IN(SELECT members.first_name FROM members));
	SET	@check_last_name = (SELECT NEW.last_name IN(SELECT members.last_name FROM members));
	IF @check_first_name = 1 AND
		@check_last_name = 1 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Пользователь уже есть в списке.';
	END IF;
END//


-- ТРИГГЕР №2. Проверяет уровень квалификации пользователя перед обновлением
-- запрещает устанавливать другой уровень, кроме следующего.
CREATE TRIGGER check_qualification BEFORE UPDATE ON qualification_of_members 
	FOR EACH ROW
	BEGIN
		DECLARE current_step INT;
		SET @current_step = (SELECT DISTINCT 
					MAX(OLD.step_of_qualification) OVER(PARTITION BY OLD.user_id)
					FROM qualification_of_members AS qom
					WHERE user_id = NEW.user_id);
		IF NEW.step_of_qualification != (@current_step + 1)
		THEN 
			SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Необходимо освоить предыдущие уровни квалификации';
		END IF;
	END//

DELIMITER ;
