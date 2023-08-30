# Создайте таблицу users_old, аналогичную таблице users.
# Создайте процедуру, с помощью которой можно переместить любого (одного) пользователя из таблицы users в таблицу users_old.
# (использование транзакции с выбором commit или rollback - обязательно) 

create table users_old as select * from users where 1 = 0;
select * from users_old;

DROP PROCEDURE IF EXISTS moving;
DELIMITER //
CREATE PROCEDURE moving (user_id INT)
begin

insert into users_old (id,  firstname, lastname, email)
values (user_id,
	(select firstname from users where id = user_id), 
    (select lastname from users where id = user_id), 
    (select email from users where id = user_id));

delete from users  where id = user_id;
commit;
end//

DELIMITER ;

CALL moving(1);