create table dspro.swiggy (id int, cust_id varchar(10), order_id int, partner_code int,outlet varchar(20), bill_amount int, order_date date, comments varchar(20));
insert into dspro.swiggy values
(1,"SW1005",700,50,"KFC",753, "2021-10-10","Door locked"),
(2,"SW1006",710,59,"Pizza hut",1496,"2021-09-01","In-time delivery"),
(3,"SW1005",720,59,"Dominos",990,"2021-12-10",""),
(4,"SW1005",707,50,"Pizza hut",2475,"2021-12-11",""),
(5,"SW1006",770,59,"KFC",1250,"2021-11-17","No response"),
(6,"SW1020",1000,119,"Pizza hut",1400,"2021-11-18","In-time delivery"),
(7, "SW2035",1079,135,"Dominos",1750,"2021-11-19",""),
(8,"SW1020",1083,59,"KFC",1250,"2021-11-20",""),
(11,"SW1020",1100,150,"Pizza hut",1950,"2021-12-24","Late delivery"),
(9,"SW2035",1095,119,"Pizza hut",1270,"2021-11-21","Late delivery"),
(10,"SW1005",729,135,"KFC",1000,"2021-09-10","Delivered"),
(1,"SW1005",700,50,"KFC",753, "2021-10-10","Door locked"),
(2,"SW1006",710,59,"Pizza hut",1496,"2021-09-01","In-time delivery"),
(3, "SW1005",720,59,"Dominos",990,"2021-12-10",""),
(4,"SW1005",707,50,"Pizza hut",2475,"2021-12-11","");
select * from dspro.swiggy;

#--Q1 find the count of duplicate rows in the swiggy table
SELECT id, cust_id,COUNT(*) AS duplicate_count
FROM dspro.swiggy
GROUP BY id, cust_id
HAVING COUNT(*) > 1;

set sql_safe_updates=0;
#-- Q2: Remove Duplicate records from the table
DELETE FROM dspro.swiggy
WHERE id NOT IN (
    SELECT id FROM (
        SELECT MIN(id) AS id
        FROM dspro.swiggy
        GROUP BY cust_id, order_id, partner_code, outlet, bill_amount, order_date, comments
    ) AS subquery
);

#-- Q3: Print records from row number 4 to 9
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (ORDER BY id) AS row_num
    FROM dspro.swiggy
) AS numbered_rows
WHERE row_num BETWEEN 4 AND 9;

#-- Q4: Find the latest order placed by customers
SELECT cust_id, MAX(order_date) AS latest_order_date
FROM dspro.swiggy
GROUP BY cust_id;

#-- Q5: Print order_id, partner_code, order_date, comment (No issues in place of null else comment)
SELECT order_id, partner_code, order_date, COALESCE(Comments, 'No issues') AS comment
FROM dspro.swiggy;

#-- Q6: Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount
SELECT outlet,
       COUNT(*) AS order_count,
       SUM(COUNT(*)) OVER (ORDER BY outlet) AS cumulative_order_count,
       SUM(bill_amount) AS total_bill_amount,
       SUM(SUM(bill_amount)) OVER (ORDER BY outlet) AS cumulative_bill_amount
FROM dspro.swiggy
GROUP BY outlet;

#-- Q7: Print cust_id wise, Outlet wise 'total number of orders'
SELECT cust_id, outlet, COUNT(*) AS total_orders
FROM dspro.swiggy
GROUP BY cust_id, outlet;

#-- Q8: Print cust_id wise, Outlet wise 'total sales'
SELECT cust_id, outlet, SUM(bill_amount) AS total_sales
FROM dspro.swiggy
GROUP BY cust_id, outlet;