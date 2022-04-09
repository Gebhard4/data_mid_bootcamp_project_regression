#1)Create a database called house_price_regression.

create database house_price_regression;
use house_price_regression;

#2)Create a table house_price_data with the same columns as given in the csv file. 
#Please make sure you use the correct data types for the columns.

CREATE TABLE house_price_data2 (
    id BIGINT UNSIGNED,
    date CHAR(8),
    bedrooms TINYINT UNSIGNED,
    bathrooms DECIMAL(4 , 2 ),
    sqft_living MEDIUMINT UNSIGNED,
    sqft_lot MEDIUMINT UNSIGNED,
    floors DECIMAL(3 , 1 ),
    waterfront TINYINT UNSIGNED,
    view TINYINT UNSIGNED,
    `condition` TINYINT UNSIGNED,
    grade TINYINT UNSIGNED,
    sqft_above INTEGER,
    sqft_basement INTEGER,
    yr_built SMALLINT,
    yr_renovated SMALLINT,
    zipcode MEDIUMINT UNSIGNED,
    lat DECIMAL(6 , 4 ),
    `long` DECIMAL(6 , 3 ),
    sqft_living15 MEDIUMINT UNSIGNED,
    sqft_lot15 MEDIUMINT UNSIGNED,
    price MEDIUMINT UNSIGNED
);

SHOW VARIABLES LIKE 'secure_file_priv';

    
select * from house_price_data2
limit 5;

#3)Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. 
#To not modify the original data, if you want you can create a copy of the csv file as well. 

###MEMO: copy regression_data.csv into MYSQL folder

load data infile 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/regression_data.csv'
INTO TABLE house_price_data2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

#4)Select all the data from table house_price_data to check if the data was imported correctly

select * from house_price_data2
limit 5;

#5)Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. 
#Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE house_price_data2
  DROP COLUMN date;

select * from house_price_data2
limit 10;

#6)Use sql query to find how many rows of data you have.

select count(*) from house_price_data2;

#7)Now we will try to find the unique values in some of the categorical columns:

#unique values bedrooms:
select distinct bedrooms from house_price_data2;

select bedrooms from house_price_data2
group by bedrooms
having count(bedrooms) = 1;

#bathrooms:
select bathrooms from house_price_data2
group by bathrooms
having count(bathrooms) = 1;


#floors:
select floors from house_price_data2
group by floors
having count(floors) = 1;

select distinct floors from house_price_data2;

#condition:
select `condition` from house_price_data2
group by `condition`
having count(`condition`) = 1;

select distinct `condition` from house_price_data2;

#grade:
select grade from house_price_data2
group by grade
having count(grade) = 1;

#8)Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

select * from house_price_data2
group by id
order by price desc
limit 10;

#9)What is the average price of all the properties in your data?
select avg(price) from house_price_data2;

#10) What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. 
#Use an alias to change the name of the second column.

select distinct(bedrooms), avg(price) as 'average price'
from house_price_data2
group by bedrooms
order by bedrooms asc;

#What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. 
#Use an alias to change the name of the second column.

select distinct(bedrooms), avg(sqft_living) as 'average sqft_living'
from house_price_data2
group by bedrooms
order by bedrooms asc;

#What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. 
#Use an alias to change the name of the second column.

select distinct(waterfront), avg(price) as 'average price'
from house_price_data2
group by waterfront
order by waterfront asc;

#Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. 
#Visually check if there is a positive correlation or negative correlation or no correlation between the variables.

SELECT grade, avg(`condition`)
FROM house_price_data2
GROUP BY grade
ORDER BY grade;

SELECT `condition`, avg(grade)
FROM house_price_data2
GROUP BY `condition`
ORDER BY `condition`;


#11)One of the customers is only interested in the following houses:
#Number of bedrooms either 3 or 4
SELECT * FROM house_price_data2
WHERE bedrooms > 2;
#Bathrooms more than 3
SELECT * FROM house_price_data2
WHERE bedrooms < 5;
#One Floor
SELECT * FROM house_price_data2
WHERE floors = 1;
#No waterfront
SELECT * FROM house_price_data2
WHERE waterfront = 0;
#Condition should be 3 at least
SELECT * FROM house_price_data2
WHERE `condition` >= 3;
#Grade should be 5 at least
SELECT * FROM house_price_data2
WHERE grade >= 5;
#Price less than 300000
SELECT * FROM house_price_data2
WHERE price < 300000;

SELECT * FROM house_price_data2
WHERE bedrooms > 2
    AND
    bedrooms < 5
    AND
    bathrooms > 3
    AND
    floors = 1
    AND
    waterfront = 0
    AND
    `condition` >= 3
    AND
    grade >= 5
    AND
    price < 300000;
    
    
#12)Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. 
#Write a query to show them the list of such properties. You might need to use a sub query for this problem.
    
select avg(price)
from house_price_data2
where (SELECT avg(price)*2	
FROM house_price_data2);
    
#13)Since this is something that the senior management is regularly interested in, create a view of the same query.
create view greedy_boss
as
select avg(price)
from house_price_data2
where (SELECT avg(price)*2	
FROM house_price_data2);

#14)Most customers are interested in properties with three or four bedrooms. 
#What is the difference in average prices of the properties with three and four bedrooms?

select avg(price) as 3bed
from house_price_data2
where bedrooms = 3;

select avg(price) as 4bed
from house_price_data2
where bedrooms = 4;

select avg(price) 
from house_price_data2
where (select 4bed 
from house_price_data2) - (select 3bed
from house_price_data2);

#15) What are the different locations where properties are available in your database? (distinct zip codes)

select distinct zipcode from house_price_data2;

#16)Show the list of all the properties that were renovated.
select * from house_price_data2
where yr_renovated != 0;

#17)Provide the details of the property that is the 11th most expensive property in your database.
select price
from house_price_data2
order by price desc
limit 10,1;