#Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
#С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
#с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
#с 18:00 до 00:00  -  "Добрый вечер", 
#с 0:00 до 6:00  -  "Доброй ночи". 

DROP FUNCTION IF EXISTS hello;
DELIMITER //
create function hello()
RETURNS TINYTEXT READS SQL DATA
BEGIN
DECLARE hour INT;
	SET hour = HOUR(NOW());
	CASE
		WHEN hour BETWEEN 0 AND 5 THEN RETURN "Доброй ночи";
		WHEN hour BETWEEN 6 AND 11 THEN RETURN "Доброе утро";
		WHEN hour BETWEEN 12 AND 17 THEN RETURN "Добрый день";
		WHEN hour BETWEEN 18 AND 23 THEN RETURN "Добрый вечер";
	END CASE;

END //

DELIMITER ;

SELECT hello();

