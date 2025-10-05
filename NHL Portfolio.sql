-- Project based on NHL history data 

-- Top 10 players based on team and average points per game

SELECT 
	TOP (10) Player
	,Team
	,G
	,A
	,G + A AS Points
	,ROUND(Pts / GP,2) AS PAvg
FROM IceHockey2022VsSalaryVsPlayer$
ORDER BY Points DESC

-- Average weight and height by team

SELECT
	Team
	,ROUND(AVG(weight),2) AvgWeight
	,ROUND(AVG(height),2) AvgHeight
FROM IceHockey2022VsSalaryVsPlayer$
WHERE Height IS NOT NULL
GROUP BY Team
ORDER BY 2

-- Forward players from Edmonton who played more than 10 games based on points

SELECT
	Player
	,Pts
FROM IceHockey2022VsSalaryVsPlayer$
WHERE Pos IN ('LW', 'C', 'RW')
	AND GP > 10
	AND Team = 'EDM'
ORDER BY Pts DESC

-- Players with Salary more than 1,5 milion $ per season

SELECT 
	COUNT(salary) TopSalary
FROM IceHockey2022VsSalaryVsPlayer$
WHERE Salary > 1500000

-- Salary difference between 22 and 23 season by team

SELECT
	y22.Team
	,SUM(y22.salary) Salary22
	,SUM(y23.salary) Salary23
	,ROUND((SUM(y23.salary) / SUM(y22.salary) -1) * 100, 2) SalaryDiff
FROM IceHockey2022VsSalaryVsPlayer$ y22
		JOIN IceHockey2023VsSalaryVsPlayer$ y23
		ON y22.Team = y23.Team
GROUP BY y22.Team
ORDER BY SalaryDiff DESC

-- Players who started play from season 23

SELECT 
	Player
FROM IceHockey2023VsSalaryVsPlayer$ 
		EXCEPT 
SELECT Player
FROM IceHockey2022VsSalaryVsPlayer$ 

-- Case statement with salary 

SELECT	
	Team
	,SUM(Salary) TotalSalary,
		CASE 
			WHEN SUM(Salary) > 25000000 THEN 'More than 25kk'
			WHEN SUM(Salary) > 20000000 THEN 'More than 20kk'
			WHEN SUM(Salary) > 15000000 THEN 'More than 15kk'
			ELSE 'Less than 15kk'
		END Case_statement
FROM IceHockey2022VsSalaryVsPlayer$
GROUP BY Team
ORDER BY TotalSalary DESC

-- Number of players in a position above 30

SELECT 
	Pos
	,COUNT(pos) PosCount
FROM IceHockey2022VsSalaryVsPlayer$
GROUP BY Pos
HAVING COUNT(pos) > 30

-- Some replace

SELECT DISTINCT REPLACE (REPLACE (REPLACE (Team, 'ana', 'Anaheim'), 'bos', 'Boston'), 'wsh', 'Washington') FullTeamName
FROM IceHockey2022VsSalaryVsPlayer$
WHERE Team IN ('ana', 'bos', 'wsh')



