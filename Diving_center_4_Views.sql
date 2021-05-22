-- ПРОЕКТ: Дайвинг-центр.
-- Максим Сапунов Jenny6199@yandex.ru
-- Файл №4
-- Создание представлений

-- ПРЕДСТАВЛЕНИЕ №1. Top-10 квалифицированных дайверов в клубе.
CREATE VIEW top_10_qual_divers AS
SELECT 
	m.id, CONCAT(m.last_name, ' ', m.first_name) AS Diver,
	aom.country AS 'From', 
	qom.step_of_qualification AS Rang
FROM members AS m
	LEFT JOIN adress_of_members AS aom
		ON m.id = aom.user_id
	LEFT JOIN qualification_of_members AS qom 
		ON m.id = qom.user_id
ORDER BY qom.step_of_qualification DESC 
LIMIT 10; 


-- ПРЕДСТАВЛЕНИЕ №2 Обобщенные контактные данные членов клуба.
CREATE VIEW members_contact_info AS
SELECT 
	m.id, CONCAT(m.last_name, m.first_name) AS diver,
	CONCAT(aom.po_index, ' ', aom.country, ' ', aom.city, ' ', aom.street, ' ', aom.house_number) AS adress,
	m.email, m.phone
FROM members AS m 
	LEFT JOIN adress_of_members AS aom 
		ON m.id = aom.user_id;

	
-- ПРЕДСТАВЛЕНИЕ №3. Планируемые клубные поездки
CREATE VIEW active_club_travels AS
SELECT 
	start_date, duration, specification, cost 
FROM club_travels_list AS ctl 
WHERE travel_status = 3 
ORDER BY start_date DESC;


-- ПРЕДСТАВЛЕНИЕ №4. Лог-бук пользовательский просмотр.
CREATE VIEW log_book_user AS
SELECT DISTINCT
	DATE(lb.dive_date) AS 'Дата погружения', 
	(SELECT CONCAT(last_name, ' ', first_name) FROM members WHERE id = lb.user_id) AS 'Дайвер',
	(SELECT CONCAT(last_name, ' ', first_name) FROM members WHERE id = lb.partner_id) AS 'Напарник',
	lb.site_id AS 'Дайв-сайт',
	lb.dive_deep AS 'Глубина погружения', 
	lb.dive_time AS 'Длительность погружения'
FROM log_book AS lb
	LEFT JOIN members AS m
	ON lb.user_id = m.id OR lb.partner_id = m.id; 


-- Представление №5. Распределение клубных поездок по количеству заявок.
CREATE VIEW most_popular_travel AS
SELECT DISTINCT 
	request_to AS travel_id,
	COUNT(user_id) OVER(PARTITION BY request_to) AS Number_of_requests,
	ctl.specification
FROM travel_requests tr
LEFT JOIN club_travels_list AS ctl
ON tr.request_to = ctl.id
ORDER BY Number_of_requests DESC;
