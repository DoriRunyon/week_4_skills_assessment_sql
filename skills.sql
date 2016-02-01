-- Note: Please consult the directions for this assignment 
-- for the most explanatory version of each question.

-- 1. Select all columns for all brands in the Brands table.

SELECT * FROM brands;

-- 2. Select all columns for all car models made by Pontiac in the Models table.

SELECT * FROM models WHERE brand_name ='Pontiac';

-- 3. Select the brand name and model 
--    name for all models made in 1964 from the Models table.

SELECT brand_name, name FROM models WHERE year = 1964; 

-- 4. Select the model name, brand name, and headquarters for the Ford Mustang 
--    from the Models and Brands tables.

SELECT models.brand_name, brands.name, brands.headquarters
FROM models
JOIN brands
ON models.brand_name = brands.name
WHERE models.name = 'Mustang';


-- 5. Select all rows for the three oldest brands 
--    from the Brands table (Hint: you can use LIMIT and ORDER BY).

SELECT * FROM brands JOIN models ON models.brand_name = brands.name
ORDER BY models.year ASC LIMIT 3;

-- 6. Count the Ford models in the database (output should be a number).

SELECT COUNT(*) FROM models WHERE brand_name = 'Ford'; 

-- 7. Select the name of any and all car brands that are not discontinued.

SELECT name FROM brands WHERE discontinued IS NOT NULL;

-- 8. Select rows 15-25 of the DB in alphabetical order by model name.

SELECT * FROM models ORDER BY brand_name DESC LIMIT 10 OFFSET 14;

-- 9. Select the brand, name, and year the model's brand was 
--    founded for all of the models from 1960. Include row(s)
--    for model(s) even if its brand is not in the Brands table.
--    (The year the brand was founded should be NULL if 
--    the brand is not in the Brands table.)

SELECT models.brand_name, models.name, brands.founded 
FROM models 
LEFT JOIN brands ON models.brand_name = brands.name;



-- Part 2: Change the following queries according to the specifications. 
-- Include the answers to the follow up questions in a comment below your
-- query.

-- 1. Modify this query so it shows all brands that are not discontinued
-- regardless of whether they have any models in the models table.
-- before:
    -- SELECT b.name,
    --        b.founded,
    --        m.name
    -- FROM Model AS m
    --   LEFT JOIN brands AS b
    --     ON b.name = m.brand_name
    -- WHERE b.discontinued IS NULL;

SELECT brands.name FROM brands WHERE discontinued IS NULL;     

-- 2. Modify this left join so it only selects models that have brands in the Brands table.
-- before: 
    -- SELECT m.name,
    --        m.brand_name,
    --        b.founded
    -- FROM Models AS m
    --   LEFT JOIN Brands AS b
    --     ON b.name = m.brand_name;

SELECT m.name, m.brand_name, b.founded
FROM brands as b
LEFT JOIN models AS m
ON b.name = m.brand_name;     

--An inner join only displays results for related entries that are in both tables. A left join
--displays results for rows that are in the first table and whatever related entries are in 
--both the first and second table. Left join does not include rows in the second table only. 

-- followup question: In your own words, describe the difference between 
-- left joins and inner joins.

-- 3. Modify the query so that it only selects brands that don't have any models in the models table. 
-- (Hint: it should only show Tesla's row.)
-- before: 
    -- SELECT name,
    --        founded
    -- FROM Brands
    --   LEFT JOIN Models
    --     ON brands.name = Models.brand_name
    -- WHERE Models.year > 1940;

SELECT b.name, b.founded
FROM brands AS b
LEFT JOIN models AS m
ON b.name = m.brand_name
WHERE m.brand_name IS NULL;

-- 4. Modify the query to add another column to the results to show 
-- the number of years from the year of the model until the brand becomes discontinued
-- Display this column with the name years_until_brand_discontinued.
-- before: 
    -- SELECT b.name,
    --        m.name,
    --        m.year,
    --        b.discontinued
    -- FROM Models AS m
    --   LEFT JOIN brands AS b
    --     ON m.brand_name = b.name
    -- WHERE b.discontinued NOT NULL;

SELECT b.name, m.name, m.year, b.discontinued, (b.discontinued - m.year) AS years_until_brand_discontinued
FROM models AS m
LEFT JOIN brands AS b
ON m.brand_name = b.name
WHERE b.discontinued IS NOT NULL;


-- Part 3: Further Study

-- 1. Select the name of any brand with more than 5 models in the database.

SELECT brand_name FROM model_count WHERE count >4; 

-- where model_count is: 

CREATE VIEW model_count AS SELECT brand_name, count(name) 
FROM models GROUP BY brand_name;

-- 2. Add the following rows to the Models table.

-- year    name       brand_name
-- ----    ----       ----------
-- 2015    Chevrolet  Malibu
-- 2015    Subaru     Outback

INSERT INTO models (year, name, brand_name) 
VALUES ('2015', 'Chevrolet', 'Malibu');

INSERT INTO models (year, name, brand_name) 
VALUES ('2015', 'Subaru', 'Outback');

-- 3. Write a SQL statement to create a table called `Awards`
--    with columns `name`, `year`, and `winner`. Choose
--    an appropriate datatype and nullability for each column
--   (no need to do subqueries here).

CREATE TABLE Awards (winner_id INTEGER PRIMARY KEY REFERENCES models, 
name VARCHAR(50) NOT NULL, year INTEGER NOT NULL);

-- 4. Write a SQL statement that adds the following rows to the Awards table:

--   name                 year      winner_model_id
--   ----                 ----      ---------------
--   IIHS Safety Award    2015      the id for the 2015 Chevrolet Malibu
--   IIHS Safety Award    2015      the id for the 2015 Subaru Outback

INSERT INTO Awards (name, year, winner_id) VALUES ('IIHS Safety Award', 2015, 49);
INSERT INTO Awards (name, year, winner_id) VALUES ('IIHS Safety Award', 2015, 50);

-- 5. Using a subquery, select only the *name* of any model whose 
-- year is the same year that *any* brand was founded.

SELECT name FROM models WHERE year IN (SELECT founded FROM brands GROUP BY founded);



