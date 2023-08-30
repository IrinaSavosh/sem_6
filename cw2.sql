# Задача 2.  Создание функции, вычисляющей коэффициент популярности пользователя 
# (по заявкам на дружбу – таблица friend_requests)
#@count_friends
# SET @user = 1;
DROP FUNCTION IF EXISTS coef_friends;
DELIMITER //

CREATE FUNCTION coef_friends(user INT)
RETURNS FLOAT READS SQL DATA
BEGIN
	SET @friends =  (SELECT COUNT(*)
	FROM semimar_4.friend_requests
	WHERE status = 'approved' AND (initiator_user_id = @user OR target_user_id = @user));

	SET @count_users = (SELECT COUNT(*) FROM users);
	RETURN ROUND(@friends * 100 / @count_users, 2);
END //

DELIMITER ;
SELECT coef_friends(1);