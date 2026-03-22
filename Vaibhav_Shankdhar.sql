Use orders;


/* 1. Write a query to display the product details (product_class_code, product_id, product_desc, 
product_price) as per the following criteria and sort them descending order of category: 
i) If the category is 2050, increase the price by 2000 
ii) If the category is 2051, increase the price by 500 
iii) If the category is 2052, increase the price by 600  */

SELECT 
    product_class_code AS Category,
    product_id AS ID,
    product_desc AS Description,												-- Selecting necessary columns
    CASE
        WHEN product_class_code = 2050 THEN product_price + 2000				-- if product_class_code = 2050, price increased by 2000
        WHEN product_class_code = 2051 THEN product_price + 500					-- if product_class_code = 2051, price increased by 500
        WHEN product_class_code = 2052 THEN product_price + 600					-- if product_class_code = 2052, price increased by 600
        ELSE product_price														-- For all other codes, price remains the same
    END AS Price
FROM
    product
ORDER BY product_class_code DESC;   											-- Sort in descreasing order of category


-----------------------------------------------------------------------------------

/* 2. Write a query to display (product_class_desc, product_id, 
product_desc, product_quantity_avail ) and Show inventory status of products as below 
as per their available quantity: 
a. For Electronics and Computer categories, if available quantity is <= 10, show 
'Low stock', 11 <= qty <= 30, show 'In stock', >= 31, show 'Enough stock' 
b. For Stationery and Clothes categories, if qty <= 20, show 'Low stock', 21 <= qty <= 
80, show 'In stock', >=81, show 'Enough stock' 
c. Rest of the categories, if qty <= 15 – 'Low Stock', 16 <= qty <= 50 – 'In Stock', >= 
51 – 'Enough stock' 
For all categories, if available quantity is 0, show 'Out of stock'. */

SELECT 
    pc.product_class_desc,
    p.product_id,
    p.product_desc,
    p.product_quantity_avail, 													-- Select mentioned columns
    CASE
        WHEN p.product_quantity_avail = 0 THEN 'Out of stock'					-- If Quantity available = 0, then out of stock
        WHEN
            pc.product_class_desc IN ('Electronics' , 'Computer')				-- For categories Electronics and Computer
        THEN
            CASE
                WHEN p.product_quantity_avail <= 10 THEN 'Low stock'			-- if available quantity <=10, low stock
                WHEN
                    p.product_quantity_avail >= 11
                        AND p.product_quantity_avail <= 30						-- if available quantity is between 11 and 30, In stock
                THEN
                    'In stock'
                WHEN p.product_quantity_avail >= 31 THEN 'Enough stock'			-- if available quantity >=31, Enough stock
            END
        WHEN
            pc.product_class_desc IN ('Stationery' , 'Computer')				-- For categories Stationery and Computer
        THEN
            CASE
                WHEN p.product_quantity_avail <= 20 THEN 'Low stock'			-- if available quantity <=20, low stock
                WHEN
                    p.product_quantity_avail >= 21
                        AND p.product_quantity_avail <= 80						-- if available quantity is between 21 and 80, In stock
                THEN
                    'In stock'
                WHEN p.product_quantity_avail >= 81 THEN 'Enough stock'			-- if available quantity >=81, Enough stock
            END
        WHEN p.product_quantity_avail <= 15 THEN 'Low stock'					-- For rest of categories, if available quantity <=15, low stock
        WHEN
            p.product_quantity_avail >= 16
                AND p.product_quantity_avail <= 50								-- if available quantity is between 16 and 50, In stock
        THEN
            'In stock'
        WHEN p.product_quantity_avail >= 51 THEN 'Enough stock'					-- if available quantity >=51, Enough stock
    END AS Inventory_status
FROM
    product p
        JOIN
    product_class pc ON p.product_class_code = pc.product_Class_code;   		-- Joining products and product_class tables to get output


-------------------------------------------------------------------

/* 3. Write a query to Show the count of cities in all countries other than USA & MALAYSIA, with 
more than 1 city, in the descending order of CITIES. */

SELECT 
    country, COUNT(city) AS count_of_cities					-- Selecting country and count of cities
FROM
    address
WHERE
    country NOT IN ('USA' , 'MALAYSIA')						-- Taking countries other than USA and Malaysia
GROUP BY country											-- Grouping of selected data by country column
HAVING count_of_cities > 1									-- Considering the countries with more than 1 city only
ORDER BY count_of_cities DESC;								-- Sorting the final table by count of cities in descending order

--------------------------------------------------------------------

/* 4. Write a query to display the customer_id,customer full name ,city,pincode,and 
order details (order id, product class desc, product desc, subtotal(product_quantity * product_price)) 
for orders shipped to cities whose pin codes do not have any 0s in them. 
Sort the output on customer name and subtotal. */


SELECT 																					-- Selecting columns
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) AS customer_full_name,									-- Concatenating first name and last name to get full name
    a.city,
    a.pincode,
    oh.order_id,
    pc.product_class_desc,
    p.product_desc,
    (oi.product_quantity * p.product_price) AS subtotal									-- Taking quantity * price as subtotal
FROM
    address a
        JOIN
    online_customer oc ON a.address_id = oc.address_id									-- First join address table with online_customer on address_id
        JOIN
    order_header oh ON oc.customer_id = oh.customer_id									-- Then join online_customer with order_header on customer_id
        JOIN
    order_items oi ON oh.order_id = oi.order_id											-- Then join order_header on order_items on order_id
        JOIN
    product p ON oi.product_id = p.product_id											-- Then join order_items on product on product_id
        JOIN
    product_class pc ON p.product_class_code = pc.product_class_code					-- Finally join product on product_class on product_class_code
WHERE
    a.pincode NOT LIKE '%0%'		
        AND order_status = 'shipped'													-- Put conditions where pincode doesn't contain 0 and status is shipped
ORDER BY customer_full_name , subtotal;													-- Finally sort by customer name and then subtotal

--------------------------------------------------------------------

/* 5. Write a Query to display product id,product description,totalquantity(sum(product quantity) 
for a given item whose product id is 201 and which item has been bought along with it maximum no. of times. 
Display only one record which has the maximum value for total quantity in this scenario. */

SELECT 														-- Selecting columns
    p.product_id,
    p.product_desc,
    SUM(oi.product_quantity) AS total_quantity				-- Taking sum of product_quantity as total_quantity
FROM
    order_items oi
        JOIN
    product p ON oi.product_id = p.product_id				-- Joining order_items with product on product_id
WHERE
    oi.order_id IN (SELECT DISTINCT							-- Condition1: Find out all order IDs using a subquery where product_id is 201
            order_id
        FROM
            order_items
        WHERE
            product_id = '201')
        AND oi.product_id != '201'							-- Condition2: Select orders for the ones where product 201 is not considered, all others are
GROUP BY oi.product_id										-- Group by product_id
ORDER BY total_quantity DESC								-- Sort by decreasing order of total_quantity
LIMIT 1;													-- Consider only the the one with highest total_quantity
															-- Finally you get the product which is bought most frequently along with product 201
																
-----------------------------------------------------------

/* 6. Write a query to display the customer_id,customer name, email and 
order details (order id, product desc,product qty, subtotal(product_quantity * product_price)) 
for all customers even if they have not ordered any item */


SELECT 																	-- Selecting columns
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) AS customer_name,						-- Concatenating first name and last name to get full name
    oc.customer_email,
    oi.order_id,
    p.product_desc,
    oi.product_quantity,
    (oi.product_quantity * p.product_price) AS subtotal					-- Taking quantity * price as subtotal
FROM
    online_customer oc
        LEFT JOIN
    order_header oh ON oc.customer_id = oh.customer_id					-- Joining online_customer with order_header using a left join to take all customers
        LEFT JOIN														-- even if the customer has no ordered items
    order_items oi ON oh.order_id = oi.order_id							-- Then left joining order_header with order_items on order_id
        LEFT JOIN
    product p ON oi.product_id = p.product_id;							-- Finally joining order_items with product to get the desired output.

--------------------------------------------------------------

/* 7. Write a query to display carton id, (len*width*height) as carton_vol 
and identify the optimum carton 
(carton with the least volume whose volume is greater than the total volume of all items (len * width * height * product_quantity)) 
for a given order whose order id is 10006, Assume all items of an order are packed into one single carton (box). */


SELECT 
    carton_id, (len * width * height) AS carton_vol									-- Selecting carton_id and carton_vol by len*width*height
FROM
    carton
HAVING carton_vol > (SELECT 
        SUM(p.len * p.width * p.height * oi.product_quantity) AS product_vol		-- Subquery to find volume of all products with order id = 10006
    FROM
        product p
            JOIN
        order_items oi ON p.product_id = oi.product_id								-- Joining required tables
    WHERE
        oi.order_id = '10006')														
ORDER BY carton_vol ASC																-- Sorting by carton_vol in ascending order
LIMIT 1;																			-- Only considering the least volume carton

---------------------------------------------------------------------------

/* 8. Write a query to display details (customer id,customer fullname,order id,product quantity) of customers 
who bought more than ten (i.e. total order qty) products with credit card or Net banking as the mode of payment per shipped order. */


SELECT 																-- Selecting Columns
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) AS customer_name,					-- Concatenating first name and last name to get full name
    oh.order_id,
    SUM(oi.product_quantity) AS total_order_quantity				-- Sum of product quantity as total order quantity
FROM
    online_customer oc
        JOIN
    order_header oh ON oc.customer_id = oh.customer_id				-- Firstly joining online_customer with order_header on customer_id
        JOIN
    order_items oi ON oh.order_id = oi.order_id						-- Then joining order_header with order_items on order_id
WHERE
    oh.payment_mode IN ('Credit Card' , 'Net Banking')
        AND oh.order_status = 'Shipped'								-- Conditions that payment mode is either credit card ot net banking & status is shipped
GROUP BY oh.order_id												-- Grouping data by order_id
HAVING total_order_quantity > 10;									-- Total order quantity for any order_id should be greater than 10

----------------------------------------------------------------

/* 9. Write a query to display the order_id, customer id and cutomer full name of customers 
starting with the alphabet "A" along with (product_quantity) as total quantity of products shipped for order ids > 10030. */


SELECT 															-- Selecting columns
    oh.order_id,
    oc.customer_id,
    CONCAT(oc.customer_fname,
            ' ',
            oc.customer_lname) AS customer_name,				-- Concatenating first name and last name to get full name
    SUM(oi.product_quantity) AS total_product_quantity			-- Sum of product quantity as total order quantity
FROM
    online_customer oc
        JOIN
    order_header oh ON oc.customer_id = oh.customer_id			-- joining online_customer with order_header on customer_id
        JOIN
    order_items oi ON oh.order_id = oi.order_id					-- Then joining order_header on order_items on order_id
WHERE
    oh.order_status = 'shipped'
        AND oh.order_id > '10030'								-- Keeping conditions status as shipped and order_id = 10030
GROUP BY order_id												-- Grouping the data by order_id
HAVING customer_name LIKE 'A%';									-- With customers starting with A only

-----------------------------------------------------------------

/* 10. Write a query to display product class description ,total quantity (sum(product_quantity),Total value (product_quantity * product price) 
and show which class of products have been shipped highest(Quantity) to countries outside India other than USA? 
Also show the total value of those items. */


SELECT 																			-- Selecting columns
    pc.product_class_desc,
    SUM(oi.product_quantity) AS total_quantity,									-- Sum of product quantity as total_quantity
    SUM(oi.product_quantity * p.product_price) AS total_value					-- sum of quantity * price as total_Value
FROM
    address a		
        JOIN
    online_customer oc ON a.address_id = oc.address_id							-- First join address with online_customer on address_id
        JOIN
    order_header oh ON oc.customer_id = oh.customer_id							-- Then join online_customer with order_header on customer_id
        JOIN
    order_items oi ON oh.order_id = oi.order_id									-- Then join order_header with order_items on order_id
        JOIN
    product p ON oi.product_id = p.product_id									-- Next joining order_items with product on product_id		
        JOIN
    product_class pc ON p.product_class_code = pc.product_class_code			-- Lastly joining product with product_class on product_class_code
WHERE
    a.country NOT IN ('India' , 'USA')											-- Condition1: Country other than India and USA
        AND oh.order_status = 'Shipped'											-- Condition2: Order status is shipped
GROUP BY pc.product_class_desc													-- Grouping the table by product_Class_desc
ORDER BY total_quantity DESC													-- Sorting the table by total_quantity in descending order
LIMIT 1;																		-- Only keeping the highest total_quantity value.

----------------------------------------------------------------------
