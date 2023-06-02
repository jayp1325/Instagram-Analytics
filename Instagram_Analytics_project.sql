
/*Q1.Find the 5 oldest users of Instagram from the database provided.*/

select top 5 username from users
order by created_at asc;

/*Q2.Find the users who have never posted a single photo on Instagram.*/

select u.username 
from users u
LEFT JOIN photos p 
ON u.id = p.user_id
WHERE p.user_id is null
order by u.username;

select count(u.username) NumbersOfUsers
from users u
LEFT JOIN photos p 
ON u.id = p.user_id
WHERE p.user_id is null;


/* Q3.Identify the winner of the contest and provide their details to the team.*/

Select u.username, count(*) as Total_likes 
from likes l
join photos p
on l.user_id=p.user_id
join users u
on u.id = l.user_id
group by u.username
order by Total_likes desc;

/*Q4. Identify and suggest the platform's top 5 most commonly used hashtags*/

Select top 5 t.tag_name, count(pt.tag_id) as NoOfTimesTag 
from photo_tags pt
join tags t
on pt.tag_id = t.id
group by t.tag_name
order by NoOfTimesTag desc;

/*Q5. What day of the week do most users register on? Provide insights on when to schedule an ad campaign.*/

select Day, Total_registered from (
SELECT DATENAME(weekday, created_at) AS Day, COUNT(*) AS Total_registered, 
dense_rank() over(order by COUNT(*) desc) rnk
FROM users 
GROUP BY DATENAME(weekday, created_at) ) as a
where rnk=1;

/* Q6. Are users still as active and post on Instagram or they are making fewer postsYour Task: 
Provide how many times does average user posts on Instagram. 
Also,*/


select category, sum(NoPost) as totalpost from (
select p.user_id, count(*) as NoPost,
CASE 
WHEN count(*)<5 then 'low_active'
when count(*)>5 and count(*)<=9 then 'Average'
else 'Very_Active'
end as Category
from photos p
join users u
on p.user_id=u.id
group by p.user_id) as a
group by Category;

/* Q7.provide the total number of photos on Instagram/the total number of users.*/

with cte as ( 
SELECT U.id AS userid, COUNT(P.id) AS NoPhotoId 
FROM users U
LEFT JOIN photos P
on U.id = P.user_id 
GROUP BY U.id )
SELECT sum(NoPhotoId) AS Total_photos,COUNT(userid) AS Total_Users 
from cte;


/*Q8.The investors want to know if the platform is crowded with fake and dummy accounts
Your Task: Provide data on users (bots) who have liked every single photo on the site
(since any normal user would not be able to do this)*/

Select U.username, Count(*) as Total_Like_By_User 
From users U
join likes L
on U.id = L.user_id
Group by U.username
Order by Total_Like_By_User Desc;


