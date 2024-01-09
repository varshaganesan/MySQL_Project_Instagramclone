-- Instagram clone Project
-- Q1: We want to reward our users who have been around the longest. Find the 5 oldest users.
DESC users;
SELECT * 
FROM users
ORDER BY created_at ASC
LIMIT 5;

-- Q2: What day of the week do most users register on? To figure out when to schedule an ad campaign.
SELECT DAYNAME(created_at) AS day , COUNT(DAYNAME(created_at)) AS day_count
FROM users
GROUP BY day
ORDER BY day_count DESC;

-- Q3: We want to target our inactive users with an email campaign. Find the users who have never posted a photo.
SELECT users.id, username, COUNT(Photos.id) AS photo_count
FROM users
LEFT JOIN photos ON users.id = photos.user_id
GROUP BY username
HAVING photo_count = 0;

-- Alternate Solution:
SELECT users.id, username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;

-- Q4: We're running a new contest to see who can get the most likes on a single photo. Who won?
SELECT photos.user_id, username , image_url, COUNT(photo_id) AS total_likes
FROM photos
INNER JOIN likes ON photos.id = likes.photo_id
INNER JOIN users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total_likes DESC
LIMIT 1;

-- Q5: Our investors want to know how many times does the avergae user post?
 -- Average = total posts / total user
 SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg_post;
 
 -- Q6: A brand wants to know which hashtags to use in a post. What are the top 5 commonly used hastag?
SELECT tags.id, tag_name , COUNT(photo_id) AS total_photos
FROM tags
INNER JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total_photos DESC
LIMIT 5;

-- Q7: We have a small problem with bots on our site. Find users who have liked every single photo on the site.
SELECT user_id, username, COUNT(*) AS total_likes
FROM likes
INNER JOIN users ON likes.user_id = users.id
GROUP BY user_id
HAVING total_likes = (SELECT COUNT(*) FROM photos)
ORDER BY total_likes DESC;