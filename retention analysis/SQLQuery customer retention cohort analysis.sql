WITH MonthlyCustomers AS (
    SELECT 
        CustomerID,
        FORMAT(InvoiceDate, 'yyyy-MM') AS MonthYear
    FROM SALES$
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID, FORMAT(InvoiceDate, 'yyyy-MM')
),
FirstTimeCustomers AS (
    SELECT 
        CustomerID,
        MIN(MonthYear) AS FirstMonth
    FROM MonthlyCustomers
    GROUP BY CustomerID
),
MonthlyRetention AS (
    SELECT 
        ft.CustomerID,
        ft.FirstMonth AS StartMonth,
        mc.MonthYear AS CurrentMonth
    FROM FirstTimeCustomers ft
    JOIN MonthlyCustomers mc
    ON ft.CustomerID = mc.CustomerID
    AND mc.MonthYear >= ft.FirstMonth
)
SELECT 
    StartMonth AS [Month],
    COUNT(DISTINCT CASE WHEN StartMonth = CurrentMonth THEN CustomerID ELSE NULL END) AS [Unique New Customers In Each Month],
    COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 1 THEN CustomerID ELSE NULL END) AS [Customers Retained 1 month later],
    COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 2 THEN CustomerID ELSE NULL END) AS [Customers Retained 2 month later],
    COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 3 THEN CustomerID ELSE NULL END) AS [Customers Retained 3 month later],
    COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 4 THEN CustomerID ELSE NULL END) AS [Customers Retained 4 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 5 THEN CustomerID ELSE NULL END) AS [Customers Retained 5 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 6 THEN CustomerID ELSE NULL END) AS [Customers Retained 6 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 7 THEN CustomerID ELSE NULL END) AS [Customers Retained 7 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 8 THEN CustomerID ELSE NULL END) AS [Customers Retained 8 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 9 THEN CustomerID ELSE NULL END) AS [Customers Retained 9 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 10 THEN CustomerID ELSE NULL END) AS [Customers Retained 10 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 11 THEN CustomerID ELSE NULL END) AS [Customers Retained 11 month later],
	COUNT(DISTINCT CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 12 THEN CustomerID ELSE NULL END) AS [Customers Retained 12 month later]
FROM MonthlyRetention
GROUP BY StartMonth
ORDER BY StartMonth;
