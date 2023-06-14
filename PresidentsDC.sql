-- After importing data, check the Table(s) to begin exploring the data
select * from PresidentsData


-- Query to identify duplicate values in Primary Key & president field, validating they are duplicates
Select S_No, president, count(*)
from PresidentsData
Group by S_No, president 
Having count(*) > 1


-- Query that identifies and deletes the duplicated record that we actually want to remove 
delete from PresidentsData
Where S_No in (
    select MAX(S_No)
    from PresidentsData
    GROUP By S_No, president
    Having count(*) > 1 
)

-- Query that visualizes the standardization of the text within the 'President' column
select president, upper(president) as president_fixed
from PresidentsData

-- updating the president column, standardizing the text format, then checking to make sure the update was successful
UPDATE PresidentsData
SET 
    president = UPPER(president)


SELECT president from PresidentsData


-- Identifying the different values withing 'Party' column so that we have ability to 'Group By' the values 
Select distinct party from PresidentsData

-- Identifying that the 'Republicans' value is the outlier and needs to be updated
select party 
from PresidentsData
where party = 'Republican' or party = 'Republicans' 

-- Updating the 'Republicans' value to standardize the 'Republican' values in the column
UPDATE PresidentsData
SET 
    party = 'Republican'
    where party = 'Republicans'

-- Verifying that the 'Republicans' update has been made successfully
select distinct party from PresidentsData

-- identifying outliers and updating the 'Whig' column 
select party from PresidentsData
where party like '%Whig%'

UPDATE PresidentsData
SET 
    party = 'Whig'
    where party like '%Whig%'

select distinct party from PresidentsData

-- Query to view the formatting errors within the 'Vice' column
select vice from PresidentsData

-- Utilizing the 'TRIM' & 'Replace' functions to remove the extra spaces within the 'Vice' column
select vice, TRIM(vice) as Vice_fixed
from PresidentsData 

UPDATE PresidentsData
SET 
    vice = TRIM(vice)
-- 

/* since 'TRIM' only removes leading & trailing spaces, we will need to remove additional spaces within the strings
select vice, replace(vice, '  ','')
from PresidentsData
where vice like '%    %'


select vice, replace(vice, '   ',' ') as vice_Fixed
from PresidentsData
*/

-- We've identified that column 'prior' will not be utilized in our dataset, so we can remove it
ALTER TABLE PresidentsData
DROP COLUMN prior 

select * from PresidentsData

-- Updating 'salary' column to be a 'number' datatype instead of 'money' datatype
ALTER TABLE PresidentsData
ALTER COLUMN salary INT;

select * from PresidentsData

/* This serves at the completion of our Data Cleaning process. At this point we are able to load 
our dataset into our data visualization tool and begin analyzing the data further */