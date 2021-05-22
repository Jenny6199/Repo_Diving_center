-- ПРОЕКТ: Дайвинг-центр.
-- Максим Сапунов Jenny6199@yandex.ru
-- Файл №2
-- СОЗДАНИЕ ВНЕШНИХ КЛЮЧЕЙ

SHOW TABLES;

-- Создание внешнего ключа для таблицы адресов пользователей по user_id.
ALTER TABLE adress_of_members 
	ADD CONSTRAINT addr_of_memb_fk 
	FOREIGN KEY(user_id) 
	REFERENCES members(id) 
	ON DELETE CASCADE;

-- Cоздание внешнего ключа для таблицы логбук погружений по user_id
ALTER TABLE log_book 
	ADD CONSTRAINT lb_user_id_fk
	FOREIGN KEY(user_id)
	REFERENCES members(id)
	ON DELETE CASCADE;

-- Cоздание внешнего ключа для таблицы логбук погружений по partner_id
ALTER TABLE log_book 
	ADD CONSTRAINT lb_partner_id_fk
	FOREIGN KEY(partner_id)
	REFERENCES members(id)
	ON DELETE CASCADE;
	
-- Cоздание внешнего ключа для таблицы лог-бук site_id
ALTER TABLE log_book 
	ADD CONSTRAINT lb_site_id_fk
	FOREIGN KEY(site_id)
	REFERENCES dive_sites(id);

-- Cоздание внешнего ключа для таблицы квалификации членов клуба по user_id
ALTER TABLE qualification_of_members 
	ADD CONSTRAINT qual_of_memb_fk
	FOREIGN KEY(user_id)
	REFERENCES members(id)
	ON DELETE CASCADE;

-- Создание внешнего ключа для таблицы квалификации instructor_id
ALTER TABLE qualification_of_members 
	ADD CONSTRAINT qual_inst_fk
	FOREIGN KEY(instructor_id)
	REFERENCES members(id);

-- Cоздание внешнего ключа для таблицы квалификации уровни квалификации
ALTER TABLE qualification_of_members 
	ADD CONSTRAINT qual_lvl_fk
	FOREIGN KEY(step_of_qualification)
	REFERENCES levels_of_qualification(qualification_id);

-- Cоздание внешнего ключа для таблицы квалификации членов клуба по user_id
ALTER TABLE qualification_of_members 
	ADD CONSTRAINT qual_site_id_fk
	FOREIGN KEY(site_id)
	REFERENCES dive_sites(id);

-- Создание внешнего ключа для таблицы сообщений user_id
ALTER TABLE messages
	ADD CONSTRAINT mess_user_fk
	FOREIGN KEY(from_user_id)
	REFERENCES members(id);
	
-- Cоздание внешнего ключа для таблицы сообщений travel_id
ALTER TABLE messages 
	ADD CONSTRAINT mess_trvl_fk
	FOREIGN KEY(travel_id)
	REFERENCES travel_log(id);

-- Cоздание внешнего ключа для таблицы travel_log по user_id
ALTER TABLE travel_log 
	ADD CONSTRAINT trll_user_fk
	FOREIGN KEY(user_id)
	REFERENCES members(id);

-- Создание внешнего ключа для таблице club_travel_list
ALTER TABLE club_travels_list
	ADD CONSTRAINT ctl_stat_fk
	FOREIGN KEY(travel_status)
	REFERENCES status_of_travel(id);


-- Создание внешнего ключа для таблицы travel_requests по user_id.
ALTER TABLE travel_requests 
	ADD CONSTRAINT rqst_user_id_fk 
	FOREIGN KEY(user_id) 
	REFERENCES members(id) 
	ON DELETE CASCADE;

-- Создание внешнего ключа для таблицы travel_requests по requests_to.
ALTER TABLE travel_requests 
	ADD CONSTRAINT rqst_rqst_to_fk 
	FOREIGN KEY(request_to) 
	REFERENCES club_travels_list(id);