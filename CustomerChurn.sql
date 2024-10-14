                                              /*Complete data analysis*/
                                              
											     /*CHURN DATASET*/
                 
Use BankDB;                 
SELECT*FROM churn;
SELECT COUNT(*) FROM churn;

-------------------------------------------------------------/*KPIs ANALYSIS*/-------------------------------------------------------------------
											
-- 1.Total Churn Rate
SELECT CASE
			WHEN exited=1 THEN "YES"
            WHEN exited=0 THEN "NO"
            END AS churn_cat,
            ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM churn),2) AS churn_rate
FROM churn
GROUP BY 1;

-- 2.Churn by Geography
SELECT 	country,
		COUNT(*) AS cust_geo,
        COUNT(CASE WHEN exited=1 THEN 1 END) AS cust_churn,
		ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)*100/COUNT(*),2) AS Geo_churn_rate
FROM churn
GROUP BY 1;

-- 	3.Churn by Tenure (*longer the tenure less likely to churn form the bank*)
SELECT CASE
			WHEN tenure>=0 AND tenure<=3 THEN "Short Term"
            WHEN tenure>3 AND tenure<=6 THEN "Mid Term"
            WHEN tenure>6 AND tenure<=10 THEN "Long Term"
            END AS Tenure_group,
            COUNT(*) AS customer,
            COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_count,
			ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)*100/COUNT(*),1) AS Tenure_churn_rate
FROM churn
GROUP BY 1
ORDER BY 4 ASC;

-- 4.Churn by Product Holding
SELECT 
	CASE 
	      WHEN products=1 THEN "Product-1"
          WHEN products=2 THEN "Product-2"
          WHEN products=3 THEN "Product-3"
          WHEN products=4 THEN "Product-4"
          END AS Product_group,
          COUNT(*) AS cust_count,
          COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_count,
          ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS product_churn_rate
FROM churn
GROUP BY 1
ORDER BY 4 ASC;

-- 	5.	Churn by Customer Activity
SELECT 	isActiveMember,
		COUNT(*) AS cust_count,
		COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_count,
		ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS churn_percent
FROM churn
GROUP BY 1;

-- 6. Churn rate by gender
SELECT 	gender, 
		COUNT(*)  AS cust,
        COUNT(CASE WHEN exited=1 THEN 1 END) AS c_cust,
		ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/count(*)*100,2) AS per_rate
FROM churn
GROUP BY 1;

-------------------------------------------------------------/*DATA ANALYSIS*/-------------------------------------------------------------------

-- 7. What is the average balance of customers across different geographies?
SELECT country,
	   COUNT(*) AS customers,
       ROUND(AVG(balance),2)  AS avg_balance
FROM churn
GROUP BY 1
ORDER BY 3 ASC;

-- 8. How many customers hold more than 1 product?
SELECT COUNT(*) AS customers_count,
       products
FROM churn
WHERE products>1
GROUP BY 2;

-- 9. What is the distribution of credit scores across all customers? (reference from experian)
SELECT CASE
		   WHEN creditscore>=300 AND creditscore<=579 THEN "Poor"
           WHEN creditscore>579 AND creditscore<=699 THEN "Fair"
           WHEN creditscore>699 AND creditscore<=739 THEN "Good"
           WHEN creditscore>739 AND creditscore<=799 THEN "Best"
           WHEN creditscore>799 AND creditscore<=850 THEN "Excellent"
           END AS CR_scores,
	   COUNT(*) AS customer_count
FROM churn
GROUP BY 1
ORDER BY 2 ASC;

-- 10. What is the average satisfaction score by geography?
SELECT DISTINCT satisfaction_score from churn;

SELECT country, 
	   ROUND(AVG(satisfaction_score),2) AS Avg_satisfactionscore
FROM churn
GROUP BY 1;

-- 11. Which age group (binned in 10-year intervals) has the highest churn rate?

SELECT CASE
			WHEN age>17 AND age<=28 THEN "Young"
			WHEN age>28 AND age<=38 THEN "Adolecent"
			WHEN age>38 AND age<=48 THEN "Mature"
            WHEN age>48 AND age<=58 THEN "Middle_age"
			ELSE "Old" 
		END AS age_group,
        COUNT(*) AS customer_count,
        COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_count,
        ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS Churn_rate
FROM churn
GROUP BY 1
ORDER BY 4 DESC;

-- 12. Which card type (Card Type) has the highest average point earned?
SELECT card_type,
	   ROUND(AVG(point_earned),2) AS Avg_point
FROM CHURN
GROUP BY 1
ORDER BY 2 DESC;

-- 13. How does the credit score influence whether a customer has exited the bank or not?
SELECT CASE
		   WHEN creditscore>=300 AND creditscore<=579 THEN "Poor"
           WHEN creditscore>579 AND creditscore<=699 THEN "Fair"
           WHEN creditscore>699 AND creditscore<=739 THEN "Good"
           WHEN creditscore>739 AND creditscore<=799 THEN "Best"
           WHEN creditscore>799 AND creditscore<=850 THEN "Excellent"
           END AS CR_scores,
           COUNT(*) AS Customer_count,
           COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_cust,
           ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS Churn_rate
FROM churn
GROUP BY 1
ORDER BY 4 DESC;

-- 14. What is the average estimated salary for customers with more than 2 products?
SELECT products,
	   ROUND(AVG(salary),2) as Avg_salary
FROM churn
WHERE products>2
GROUP BY 1;

-- 15. How does the satisfaction score vary for customers who have made complaints? (Customer having bad=2 satisfaction score made maximum complains)
SELECT	CASE
			WHEN satisfaction_score=1 THEN "worst"
            WHEN satisfaction_score=2 THEN "bad"
            WHEN satisfaction_score=3 THEN "good"
            WHEN satisfaction_score=4 THEN "best"
            WHEN satisfaction_score=5 THEN "Excellent"
		END AS Sat_scores,
        COUNT(CASE WHEN complain=1 THEN 1 END) AS complain_count
FROM churn
GROUP BY 1
ORDER BY 2 DESC;

-- 16. What is the average Credit Score of customers who have churned versus those who stayed?
SELECT exited, 
	   ROUND(AVG(creditscore),2) AS avg_crcredit
FROM churn
GROUP BY 1;

-- 17. How many products do churned customers have on average compared to those who stayed?
SELECT exited,
	   AVG(products) AS Avg_prod
FROM churn
GROUP BY 1;

-- 18. Which customer segment (based on geography and product count) shows the highest churn rate?
SELECT country,
	CASE 
	      WHEN products=1 THEN "Product-1"
          WHEN products=2 THEN "Product-2"
          WHEN products=3 THEN "Product-3"
          WHEN products=4 THEN "Product-4"
          END AS Product_group,
          COUNT(*) AS cust_count,
          COUNT(CASE WHEN exited=1 THEN 1 END) AS churn_count,
          ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS product_churn_rate
FROM churn
GROUP BY 1,2
ORDER BY 5 DESC;

-- 19. Do customers with higher estimated salaries churn more often?
SELECT salary_range,
	   COUNT(*) AS total_customer,
       COUNT(CASE WHEN exited=1 THEN 1 END) AS total_churn_customer,
       ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS churn_rate
FROM (SELECT *,
			CASE 
				WHEN salary<30000 THEN "Low"
                WHEN salary>30000 AND salary<70000 THEN "Medium"
                WHEN salary>70000 THEN "High"
			END AS salary_range
	 FROM churn) AS salary_range
GROUP BY 1
ORDER BY 4 DESC;

-- 20. What’s the proportion of active members who churned versus inactive ones?
SELECT isactivemember,
		COUNT(*) AS total_customer,
        SUM(CASE WHEN exited=1 THEN 1 ELSE 0 END) AS churn_customer,
        SUM(CASE WHEN exited=0 THEN 1 ELSE 0 END) AS Not_churn,
        ROUND(SUM(CASE WHEN exited=1 THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS cust_proportion
FROM churn
GROUP BY 1;

/*ALTERNATIVE METHOD*/
SELECT isactivemember,
		COUNT(*) AS total_customer,
        COUNT(CASE WHEN exited=1 THEN 1  END) AS churn_customer,
        COUNT(CASE WHEN exited=0 THEN 1 END) AS Not_churn,
        ROUND(COUNT(CASE WHEN exited=1 THEN 1 END)/COUNT(*)*100,2) AS cust_proportion
FROM churn
GROUP BY 1;
-------------------------------------------------------------/*ADVANCE ANALYSIS*/-------------------------------------------------------------------

-- 21. What are the top 10 customers with the highest balances who churned?
WITH churn_cust AS (
					SELECT customerid,
						   balance,
                           ROW_NUMBER() OVER(ORDER BY balance DESC) AS row_rank
					FROM churn
                    WHERE exited=1)
SELECT customerid, balance
FROM churn_cust
LIMIT 10;

-- 22. Calculate the cumulative sum/running total of churned customers over time based on their tenure.
SELECT tenure,
	   COUNT(*) AS total_customer,
       COUNT(CASE WHEN exited=1 THEN 1 END) AS total_churn_customer,
       SUM(COUNT(CASE WHEN exited=1 THEN 1 END)) OVER(ORDER BY tenure) AS cumulative_churn_cust
FROM churn
GROUP BY 1;

/*ALTERNATIVE METHOD*/
SELECT tenure,
		COUNT(*) AS totalcustomer,
		SUM(COUNT(*)) OVER(ORDER BY tenure) AS cumulative_sum
FROM churn
WHERE exited=1
GROUP BY 1;

-- 23. For each geography, calculate the difference in churn rate between male and female customers.                    
WITH churn_gender AS (
						SELECT country,
							   gender,
                               COUNT(*) AS total_customer,
                               COUNT(CASE WHEN exited=1 THEN 1 END) AS total_churn,
                               ROUND(COUNT(CASE WHEN  exited=1 THEN 1 END)/COUNT(*)*100,2) AS churn_rate
						FROM churn
                        GROUP BY 1,2)
SELECT c1.country,c1.total_customer AS male_churn,
	   c1.churn_rate AS male_churn_rate,
       c2.total_customer AS female_churn,
       c2.churn_rate AS female_churn_rate,
       c1.churn_rate-c2.churn_rate AS churn_rate_difference
FROM churn_gender c1
JOIN churn_gender c2
ON c1.country=c2.country
AND c1.gender="Male"
AND c2.gender="Female";

-- 24. What’s the average tenure of customers whose balance is below the median but who haven’t churned?
WITH median_balance_cte AS(
							SELECT balance AS median_balance
							FROM (
									SELECT balance,
									ROW_NUMBER() OVER(ORDER BY balance) AS row_num,
									COUNT(*) OVER() AS total_rows
									FROM churn) AS ordered_row
							WHERE row_num IN (FLOOR((total_rows+1)/2),CEIL((total_rows+1)/2))
)
SELECT AVG(tenure) AS Avg_tenure
FROM churn
WHERE exited=0 AND balance<(SELECT AVG(median_balance) FROM median_balance_cte);

-- 25. Which customers have the longest tenure but a low number of products, and have they churned?

WITH tenure_table AS (SELECT customerid,tenure,exited,
			   products,
			   ROW_NUMBER() OVER(ORDER BY tenure DESC) AS tenure_Drank,
               ROW_NUMBER() OVER(ORDER BY products ASC) AS prod_rank
		FROM churn)

SELECT customerid,tenure,products
FROM tenure_table
WHERE tenure>6
AND products<2 
AND exited=1
GROUP BY 1,2,3;

-- 26. Calculate the rolling average of churned customers’ estimated salaries.
SELECT customerid,
	   salary,
       ROUND(AVG(salary) OVER(PARTITION BY customerid ROWS BETWEEN 1 PRECEDING AND CURRENT ROW),2) AS Rolling_avg_salary
FROM churn
GROUP BY 1,2;


 
                   
                    
                    
                    
                    
                    
                    
                    