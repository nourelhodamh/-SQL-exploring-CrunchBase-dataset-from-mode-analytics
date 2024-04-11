/*Question #1
						
Using tutorial.crunchbase_investments and tutorial.crunchbase_companies						
Write a query that shows a company's name, "status" (found in the Companies table), and the number of unique investors in that company. Order by the number of investors from most to fewest. Limit to only companies in the state of New York.*/


Answer*/		

SELECT co.name AS "Company Name", 
co.status AS "Status",
COUNT(DISTINCT inv.investor_name) AS "Investors Count",
co.region AS "Region"

FROM tutorial.crunchbase_companies AS co
FULL OUTER JOIN tutorial.crunchbase_investments AS inv
ON co.permalink=inv.company_permalink
 
WHERE co.region='New York'
GROUP BY "Company Name","Status","Region"
ORDER BY "Investors Count" DESC
LIMIT 10;



/*Question #2
					
Using tutorial.crunchbase_acquisitions and tutorial.crunchbase_companies						
Find what were the top 10 years to found a company if you wanted acquirers from New York to buy your company without joining tables. 


Answer*/				
						 			
SELECT acq.founded_year,
COUNT(acq.name) AS companies_count

FROM tutorial.crunchbase_companies  AS acq
Where acq.permalink IN(
SELECT company_permalink
FROM tutorial.crunchbase_acquisitions
WHERE acquirer_region='New York')
 
GROUP BY acq.founded_year
ORDER BY companies_count DESC
LIMIT 10;
	


/*Question #3
						
Write a query that joins benn.college_football_players and benn.college_football_teams to then display player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division. 


Answer*/		
				 					
SELECT players.player_name AS "Players Name",
teams.school_name AS "School Name",
teams.conference AS "Conference",
teams.division AS "Division"

FROM benn.college_football_players AS players
FULL JOIN benn.college_football_teams AS teams
ON players.id = teams.id
 
Where teams.division='FBS (Division I-A Teams)';



/*Question #4
						
Let’s go back into The Office.
Check the tutorial.dunder_mifflin_paper_sales table. Now that you know the GROUP BY clause, write a query for the performance numbers of all account managers.
Using a comment block argue a case on who’s the best and who’s the worst performing one based on attributes of your own choosing 
					
				
Answer*/	
		
SELECT
Account_manager,
COUNT(order_id) AS total_number_of_orders,
SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_order,
SUM(CASE WHEN status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_order,
SUM(CASE WHEN status = 'RETURNED' THEN 1 ELSE 0 END) AS returned_order,
ROUND(AVG(CASE WHEN status = 'COMPLETED' THEN rating ELSE NULL END)) AS avg_products_rating,
SUM(rating) AS rate_count
  
FROM tutorial.dunder_mifflin_paper_sales 
WHERE status IS NOT NULL 
GROUP BY account_manager
ORDER BY completed_order DESC,avg_products_rating DESC, rate_count DESC
LIMIT 100;



/*Explanation: 
 
Approach: 
Find the total number of completed orders per each manager
Calculate the avg rating and consider the rates
Calculate how many ratings were provided, this is important 
to understand the sampling ratio behind the rates for example a manager might get 5 starts 
while he has only one review with 5 stars in this case considering the manager rate to be 5 is not accurate.

Conclusion:
From the results of my approach, I found that 
Best account manager : 
“Dwight Schrute” 
Completed orders: 164
Avg rating: 3
Number of reviews: 374


Worst account manager :
“Oscar Martinez” 
Completed orders: 43
Avg rating: 4
Number of reviews: 154*/
