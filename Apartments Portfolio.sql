-- List of every city with apartments 

SELECT 
	DISTINCT(city)
FROM Portfoliov2.dbo.basic$
ORDER BY city

-- Number of apartments in city with average price

SELECT 
	b.city
	,COUNT(*) AS TotalApartments
	,ROUND(AVG(p.price),0) AS AvgPrice
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.price$ p 
		ON b.id = p.id
GROUP BY b.city

-- List of the bigest apartments in every city

SELECT 
	city
	,MAX(squareMeters) MaxSquareM
FROM Portfoliov2.dbo.basic$
GROUP BY city

-- Date of first and last apartment build

SELECT 
	city
	,ROUND(MIN(buildYear),0) FirstBuilding
	,ROUND(MAX(buildYear),0) LastBuilding
FROM Portfoliov2.dbo.basic$
GROUP BY city

-- Min, Max and % Difference price between them based on city

SELECT 
	b.city
	,MIN(p.price) MinPrice
	,MAX(p.price) MaxPrice
	,ROUND((MAX(p.price) / MIN(p.price) -1) *100,2) DiffPrice
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.price$ p
		ON b.id = p.id
GROUP BY b.city
ORDER BY MinPrice

-- Top 5 most expensive apartments in Wroclaw

SELECT TOP (5)
	b.city
	,b.id
	,b.squareMeters
	,p.price
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.price$ p
		ON b.id = p.id
WHERE b.city = 'wroclaw'
ORDER BY p.price DESC

-- Number of apartments with security and parking space above 600k

SELECT 
	b.city
	,COUNT(b.id) CountApartments
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.price$ p
		ON b.id = p.id
			JOIN Portfoliov2.dbo.facilities$ f
			ON b.id = f.id
WHERE f.hasParkingSpace = 'yes' 
		and f.hasSecurity = 'yes'
		and p.price > 600000
GROUP BY b.city
ORDER BY CountApartments DESC

-- Apartments in Szczecin and Gdynia with an elevator in the range of 500k-700k and case( distance to the center)

SELECT 
	b.city
	,b.id
		,CASE
			WHEN d.centreDistance > 4.5 THEN 'Far away'
			WHEN d.centreDistance > 2.5 THEN 'Average distance'
			ELSE 'Close'
		END DistanceToCentre
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.distance$ d
		ON b.id = d.id
			JOIN Portfoliov2.dbo.price$ p
			ON b.id = p.id
				JOIN Portfoliov2.dbo.facilities$ f
				ON b.id = f.id
WHERE b.city IN ('szczecin', 'gdynia')
	AND p.price between 500000 and 700000
	AND f.hasElevator = 'yes'


-- Subquery with biggest apartment, city and type

SELECT 
	id
	,city
	,type
	,squareMeters
FROM Portfoliov2.dbo.basic$
WHERE squareMeters = (
					SELECT MAX(squareMeters)
					FROM Portfoliov2.dbo.basic$
					)

-- View with several tables

CREATE VIEW apartments_view AS
SELECT 
	b.id
	,b.city
	,b.type
	,b.squareMeters
	,b.buildYear
	,p.price
	,m.buildingMaterial
	,f.hasBalcony
	,f.hasElevator
	,f.hasParkingSpace
	,f.hasSecurity
	,f.hasStorageRoom
	,d.centreDistance
	,d.schoolDistance
FROM Portfoliov2.dbo.basic$ b
		JOIN Portfoliov2.dbo.price$ p
		ON b.id = p.id
			JOIN Portfoliov2.dbo.material$ m
			ON b.id = m.id
				JOIN Portfoliov2.dbo.facilities$ f
				ON b.id = f.id
					JOIN Portfoliov2.dbo.distance$ d
					ON b.id = d.id
WHERE b.type IS NOT NULL

SELECT *
FROM apartments_view

-- Subquery with max price and city

SELECT 
	id
	,city
	,price
FROM apartments_view
WHERE price = (
				SELECT MAX(price)
				FROM apartments_view
				)

