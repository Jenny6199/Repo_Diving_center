-- ПРОЕКТ: Дайвинг-центр.
-- Максим Сапунов Jenny6199@yandex.ru
-- Файл №6
-- ЧАСТО ИСПОЛЬЗУЕМЫЕ ЗАПРОСЫ


-- Запрос №1: получить контактные данные члена клуба по id.
-- Используется представление.
SELECT 
	mci.diver, mci.adress, mci.email, mci.phone 
FROM members_contact_info AS mci WHERE id = 201;


-- Запрос №2: просмотр личного журнала погружений члена клуба
-- Используется встроенная процедура
CALL personal_log_book(2); 


-- Запрос №3: распределение членов клуба по уровням квалификации.
-- Используется оконная функция.
SELECT DISTINCT
	qom.step_of_qualification AS 'Уровень квалификации',
	COUNT(user_id) OVER(PARTITION BY step_of_qualification) AS 'Количество членов клуба'
FROM qualification_of_members AS qom
ORDER BY step_of_qualification;


-- Запрос №4: получить распределение минимальной стоимости активных клубных поездок,
-- в зависимости от специализации.
-- Используется представление и оконная функция.
SELECT DISTINCT 
	act.specification AS 'Специализация', 
	MIN(act.cost) OVER(PARTITION BY act.specification ORDER BY act.cost) AS 'Наименьшая стоимость'
FROM active_club_travels AS act;


-- Запрос №5. получить список направлений заказов авиабилетов
-- для клубных поездок (идентификатор члена клуба, страна отправления,
-- страна прибытия). (Нужно доделать по уму, чтобы летать из города в город)
-- Используется объединение таблиц с вложенными запросами в FROM и в JOIN.
SELECT 
	tl.user_id, 
	tl.country AS Departure,
	fly_to.country AS Arrival 
FROM (SELECT travel_log.user_id, travel_log.country FROM travel_log) AS tl
LEFT JOIN
(SELECT user_id,country FROM adress_of_members) AS fly_to
ON tl.user_id = fly_to.user_id;
 

-- Запрос №6. Получить список 10 наиболее популярных направлений в клубных 
-- поездках (по количеству заявок).
-- Используется чистая оконная функция
SELECT DISTINCT
	tr.request_to,
	COUNT(id) OVER(PARTITION BY request_to) AS Requests
FROM travel_requests AS tr
ORDER BY Requests DESC LIMIT 10; 


-- Запрос №7. Распределение клубных поезок по количеству отзывов пользователей.
-- Использована группировка и агрегационная функция.
SELECT 
	travel_id, 
	COUNT(travel_id) AS Number_of_messages  
FROM messages AS m 
GROUP BY travel_id
ORDER BY Number_of_messages DESC; 



-- Запрос №8. Какие члены клуба учавствовали в клубных поездках на Мальдивы.
-- Простой запрос, используется фильтрация Where.
SELECT 
	tl.country, tl.travel_date, 
	tl.user_id
FROM travel_log AS tl
WHERE country = 'Maldives';


-- Запрос №9. Получить список доступных квалификационных курсов в
-- активных клубных поездках и их стоимость.
-- Использовано объединение таблиц.
SELECT
	ctl.start_date, ctl.cost, loq.name_of_qualification 
FROM club_travels_list AS ctl
	LEFT JOIN levels_of_qualification AS loq 
ON loq.type_of_qualification = ctl.specification
WHERE travel_status = 3
ORDER BY loq.name_of_qualification;


-- Запрос №10. Получить список 10 самых активных членов клуба.
-- Критерии активности - количество погружений, количество поездок и количество
-- заявок. 
-- Использовано объединение результирующих таблиц, агрегация, вложенные запросы.

SELECT 
	Dives.user_id,
	total_dives,
	total_travel, 
	total_requests,
	(total_dives + IFNULL(total_travel, 0) + IFNULL(total_requests,0)) AS Activity
FROM 
	(SELECT lb.user_id, COUNT(lb.id) AS total_dives FROM log_book AS lb GROUP BY lb.user_id) AS Dives
LEFT JOIN 
	(SELECT tl.user_id, COUNT(tl.id) AS total_travel FROM travel_log AS tl GROUP BY tl.user_id) AS Travel
	ON Dives.user_id = Travel.user_id
LEFT JOIN
	(SELECT tr.user_id, COUNT(tr.id) AS total_requests FROM travel_requests AS tr GROUP BY tr.user_id) AS Requests
	ON Dives.user_id = Requests.user_id
GROUP BY Dives.user_id
ORDER BY Activity DESC LIMIT 10; 

;