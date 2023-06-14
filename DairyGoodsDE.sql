/*
Data Exploration of a 'Dairy Item' dataset
*/

-- Creating database & importing our exploratory data
create DATABASE Dairy

-- Query to see an overview of our data
select TOP(100)* from dairy_dataset

-- Query to show the different number of Farm Locations
select DISTINCT Location 
from dairy_dataset

select count(DISTINCT Location) 
from dairy_dataset

-- Calculating the number of cows per Acre of Land (On average, how many cows are on an acre of land across the industry?)
select location, Total_Land_Area_acres, Number_of_Cows, (Total_Land_Area_acres / Number_of_Cows) AS AvgCows_Per_Acre
from dairy_dataset

-- Querying for only the large farms (How many large farms do we have?) & (Where are they located?)
select COUNT(Farm_size)
from dairy_dataset
where Farm_size = 'Large'

select Location, Farm_size
from dairy_dataset
where Farm_size = 'Large'

-- Calculating the total amount of revenue based on farm size (Which farm size generates the most revenue?)
select Farm_size, SUM(Quantity_Sold_liters_kg * Price_per_unit_sold) AS RevenueCalc
from dairy_dataset
GROUP BY Farm_Size 
ORDER BY RevenueCalc DESC

-- Query to see where our customer are located (What are the most profitable customer markets?)
select DISTINCT Customer_Location
from dairy_dataset

select COUNT(DISTINCT Customer_Location)
from dairy_dataset

-- Querying the total revenue generated based on Customer location (Which customer location provides the most revenue?)
select SUM(Total_Land_Area_acres) as RevenueCalc, Customer_Location
from dairy_dataset
group by Customer_Location
Order by RevenueCalc DESC

-- Viewing the types of dairy products available to sell
select DISTINCT Product_Name
from dairy_dataset

select COUNT(DISTINCT Product_Name)
from dairy_dataset

-- Querying the total revenue generated based on type of Product sold (Which products produce the most revenue?)
select SUM(Approx_Total_Revenue_INR) as RevenueCalc, Product_Name
from dairy_dataset
GROUP BY Product_Name
ORDER BY RevenueCalc DESC

-- Calculating the average price of products across the industry. (What are the average prices of our products form competitors?)
select Product_Name, AVG(Price_per_unit_sold) as AveragePrice, AVG(Shelf_Life_days) as AverageShelfLife
from dairy_dataset
GROUP BY Product_Name
ORDER By AveragePrice DESC


