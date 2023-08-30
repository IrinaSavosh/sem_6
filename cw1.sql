use semimar_4;
# Задача 1.  Создайте процедуру, которая выберет для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
# 1) из одного города 
INSERT INTO users (firstname, lastname, email) VALUES 
('Ilia', 'Nienow', 'arlo50@gmail');
INSERT INTO profiles(user_id, gender, photo_id, hometown)
VALUES (12, 'm', NULL, 'Adriannaport');
SET @user = 1;
SELECT users.* 
FROM users
JOIN profiles as p on p.user_id = users.id
WHERE p.hometown = 
	(SELECT p.hometown FROM profiles as p WHERE user_id = @user)
    AND p.user_id != @user;

# 2) состоят в одной группе
SELECT distinct users.id
FROM users
JOIN users_communities AS uc on users.id = uc.user_id
WHERE users.id != @user AND uc.community_id IN 
	(SELECT community_id FROM users_communities WHERE user_id = @user)
ORDER BY RAND()
LIMIT 5;

# 3) друзья друзей
WITH msg_veiw AS
	(SELECT initiator_user_id AS friend
	FROM friend_requests
	WHERE 
		target_user_id = @user AND 
		status = 'approved'
	union
    SELECT target_user_id
	FROM friend_requests
	WHERE 
		initiator_user_id = @user AND 
		status = 'approved')
SELECT fr.target_user_id FROM friend_requests as fr
JOIN msg_veiw on msg_veiw.friend = fr.initiator_user_id
WHERE target_user_id != @user AND fr.status = 'approved'
UNION
SELECT fr.initiator_user_id FROM friend_requests as fr
JOIN msg_veiw on msg_veiw.friend = fr.target_user_id
WHERE initiator_user_id != @user AND fr.status = 'approved';

DROP PROCEDURE IF EXISTS user_friends;
DELIMITER //
CREATE PROCEDURE user_friends(user INT)
BEGIN

WITH msg_veiw AS
	(SELECT initiator_user_id AS friend
	FROM friend_requests
	WHERE 
		target_user_id = @user AND 
		status = 'approved'
	union
    SELECT target_user_id
	FROM friend_requests
	WHERE 
		initiator_user_id = @user AND 
		status = 'approved')
SELECT fr.target_user_id FROM friend_requests as fr
JOIN msg_veiw on msg_veiw.friend = fr.initiator_user_id
WHERE target_user_id != @user AND fr.status = 'approved'
UNION
SELECT fr.initiator_user_id FROM friend_requests as fr
JOIN msg_veiw on msg_veiw.friend = fr.target_user_id
WHERE initiator_user_id != @user AND fr.status = 'approved'

UNION

SELECT distinct users.id
FROM users
JOIN users_communities AS uc on users.id = uc.user_id
WHERE users.id != @user AND uc.community_id IN 
	(SELECT community_id FROM users_communities WHERE user_id = @user)
    
UNION

SELECT users.id 
FROM users
JOIN profiles as p on p.user_id = users.id
WHERE p.hometown = 
	(SELECT p.hometown FROM profiles as p WHERE user_id = @user)
    AND p.user_id != @user
ORDER BY RAND()
LIMIT 5;


END //

DELIMITER ;

CALL user_friends(2);