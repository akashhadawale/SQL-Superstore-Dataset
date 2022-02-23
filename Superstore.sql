/*Task 1:- Understanding the Data*/

/*1. Describe the data in hand in your own words*/

/*This database contains sales details of a superstore. 
The structure has 5 tables - cust_dimen, prod_dimen, orders_dimen, shipping_dimen, market_fact*/

/*1. cust_dimen: Details of all the customers
		
        Customer_Name (TEXT): Name of the customer
        Province (TEXT): Province of the customer
        Region (TEXT): Region of the customer
        Customer_Segment (TEXT): Segment of the customer
        Cust_id (TEXT): Unique Customer ID
	
    2. market_fact: Order & product details
		
        Ord_id (TEXT): Order ID
        Prod_id (TEXT): Prod ID
        Ship_id (TEXT): Shipment ID
        Cust_id (TEXT): Customer ID
        Sales (DOUBLE): Sales from the product sold
        Discount (DOUBLE): Discount on the product sold
        Order_Quantity (INT): Order Quantity of the product sold
        Profit (DOUBLE): Profit from the product sold
        Shipping_Cost (DOUBLE): Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE): Product Base Margin on the Item sold
        
    3. orders_dimen: Order details
		
        Order_ID (INT): Order ID
        Order_Date (TEXT): Order Date
        Order_Priority (TEXT): Priority of the Order
        Ord_id (TEXT): Unique Order ID
	
    4. prod_dimen: Product category and sub category details
		
        Product_Category (TEXT): Product Category
        Product_Sub_Category (TEXT): Product Sub Category
        Prod_id (TEXT): Unique Product ID
	
    5. shipping_dimen: Shipping details
		
        Order_ID (INT): Order ID
        Ship_Mode (TEXT): Shipping Mode
        Ship_Date (TEXT): Shipping Date
        Ship_id (TEXT): Unique Shipment ID
        
#2. Identify and list the Primary Keys and Foreign Keys for this dataset provided to you
(In case you don’t find either primary or foreign key, then specially mention this in your answer)

	1. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
	
    2. market_fact
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
    3. orders_dimen
		Primary Key: Ord_id
        Foreign Key: NA
	
    4. prod_dimen
		Primary Key: Prod_id
        Foreign Key: NA
	
    5. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA*/


/*Task 2:- Basic & Advanced Analysis*/

USE superstore;

/*1. Write a query to display the Customer_Name and Customer Segment using alias 
name “Customer Name", "Customer Segment" from table Cust_dimen.*/
SELECT 
    Customer_Name AS 'Customer Name',
    Customer_Segment AS 'Customer Segment'
FROM
    Cust_dimen;

/*2. Write a query to find all the details of the customer from the table cust_dimen 
order by desc.*/
SELECT 
    *
FROM
    cust_dimen
ORDER BY Cust_id DESC;

/*3. Write a query to get the Order ID, Order date from table orders_dimen where 
‘Order Priority’ is high.*/
SELECT 
    order_id, order_date
FROM
    orders_dimen
WHERE
    Order_Priority = 'HIGH';
    
/*4. Find the total and the average sales (display total_sales and avg_sales)*/
SELECT SUM(sales) 'total_sales', AVG(sales) 'avg_sales' FROM market_fact;

/*5. Write a query to get the maximum and minimum sales from maket_fact table*/
SELECT MAX(sales) 'maximum sales', MIN(sales) 'minimum sales' FROM market_fact;

/*6. Display the number of customers in each region in decreasing order of 
no_of_customers. The result should contain columns Region, no_of_customers.*/
SELECT 
    region, COUNT(Cust_id) AS 'no_of_customers'
FROM
    cust_dimen
GROUP BY region
ORDER BY COUNT(Cust_id) DESC;

/*7. Find the region having maximum customers (display the region name and 
max(no_of_customers)*/
SELECT region, COUNT(cust_id) AS 'no_of_customers' FROM cust_dimen GROUP BY region ORDER BY COUNT(cust_id) DESC LIMIT 1;

/*8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
and the number of tables purchased (display the customer name, no_of_tables 
purchased)*/
SELECT 
    c.customer_name AS 'customer name',
    region,
    p.Product_Sub_Category,
    SUM(m.Order_Quantity)
FROM
    cust_dimen c
        INNER JOIN
    market_fact m ON c.Cust_id = m.Cust_id
        INNER JOIN
    prod_dimen p ON p.Prod_id = m.Prod_id
WHERE
    region = 'Atlantic'
        AND p.Product_Sub_Category = 'TABLES'
GROUP BY c.Customer_Name
ORDER BY SUM(m.Order_Quantity) DESC;

/*9. Find all the customers from Ontario province who own Small Business. (display 
the customer name, no of small business owners)*/
SELECT customer_name, province, customer_segment FROM cust_dimen WHERE Customer_Segment='small business'AND Province='ontario';
SELECT Province, COUNT(customer_name) AS 'no of small business owners' FROM cust_dimen WHERE Customer_Segment='small business'AND Province='ontario';

/*10. Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold)*/
SELECT prod_id AS 'product id', SUM(order_quantity) 'no_of_products sold' FROM market_fact GROUP BY Prod_id ORDER BY SUM(Order_Quantity) DESC;

/*11. Display product Id and product sub category whose produt category belongs to 
Furniture and Technlogy. The result should contain columns product id, product 
sub category.*/
SELECT prod_id, product_sub_category FROM prod_dimen WHERE Product_Category IN ('furniture' AND 'technology');

/*12. Display the product categories in descending order of profits (display the product 
category wise profits i.e. product_category, profits)?*/
SELECT p.product_category, SUM(m.profit)
FROM prod_dimen p INNER JOIN market_fact m ON p.Prod_id=m.Prod_id 
GROUP BY Product_Category ORDER BY SUM(m.Profit) DESC;

/*13. Display the product category, product sub-category and the profit within each 
subcategory in three columns.*/
SELECT p.product_category, p.product_sub_category, ROUND(SUM(m.profit))
FROM prod_dimen p INNER JOIN market_fact m ON p.prod_id=m.Prod_id 
GROUP BY p.Product_Sub_Category ORDER BY SUM(m.profit) DESC;

/*14. Display the order date, order quantity and the sales for the order.*/
SELECT o.order_date, m.order_quantity, m.sales FROM orders_dimen o INNER JOIN market_fact m ON o.Ord_id=m.Ord_id ORDER BY o.Order_Date;

/*15. Display the names of the customers whose name contains the 
 i) Second letter as ‘R’
 ii) Fourth letter as ‘D’*/
 SELECT customer_name FROM cust_dimen WHERE customer_name LIKE '_R%' OR '___D%';
 
/*16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and 
their region where sales are between 1000 and 5000.*/
SELECT c.cust_id, m.sales, c.customer_name, c.region 
FROM cust_dimen c INNER JOIN market_fact m ON c.Cust_id=m.Cust_id
WHERE sales BETWEEN 1000 AND 5000;

/*17. Write a SQL query to find the 3rd highest sales.*/
SELECT sales FROM market_fact ORDER BY sales DESC LIMIT 2,1;

/*18. Where is the least profitable product subcategory shipped the most? For the least 
profitable product sub-category, display the region-wise no_of_shipments and the 
profit made in each region in decreasing order of profits (i.e. region, 
no_of_shipments, profit_in_each_region)
 → Note: You can hardcode the name of the least profitable product subcategory*/

SELECT 
    c.region,
    COUNT(m.ship_id) AS 'no_of_shipments',
    SUM(m.profit) AS 'profit_in_each_region'
FROM
    cust_dimen AS c
        INNER JOIN
    market_fact AS m ON c.Cust_id = m.Cust_id
        INNER JOIN
    prod_dimen p ON p.Prod_id = m.Prod_id
WHERE
    p.Product_Sub_Category = (SELECT 
            p.product_sub_category
        FROM
            prod_dimen p
                INNER JOIN
            market_fact m ON p.prod_id = m.prod_id
        GROUP BY p.product_sub_category
        ORDER BY SUM(m.profit)
        LIMIT 1)
GROUP BY c.region
ORDER BY SUM(m.profit)
LIMIT 1;











