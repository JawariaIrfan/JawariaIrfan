WITH MonthlyCustomers AS (
    SELECT 
        CustomerID,
        FORMAT(InvoiceDate, 'yyyy-MM') AS MonthYear,
        SUM(UnitPrice * Quantity) AS Revenue
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
MonthlyRetentionRevenue AS (
    SELECT 
        ft.CustomerID,
        ft.FirstMonth AS StartMonth,
        mc.MonthYear AS CurrentMonth,
        mc.Revenue
    FROM FirstTimeCustomers ft
    JOIN MonthlyCustomers mc
    ON ft.CustomerID = mc.CustomerID
    AND mc.MonthYear >= ft.FirstMonth
)
SELECT 
    StartMonth AS [Month],
    SUM(CASE WHEN StartMonth = CurrentMonth THEN Revenue ELSE 0 END) AS [Revenue from Unique New Customers In Each Month],
    SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 1 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained in Next Month],
    SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 2 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 2 Months Later],
    SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 3 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 3 Months Later],
    SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 4 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 4 Months Later],
    SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 5 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 5 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 6 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 6 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 7 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 7 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 8 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 8 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 9 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 9 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 10 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 10 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 11 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 11 Months Later],
	SUM(CASE WHEN DATEDIFF(MONTH, CAST(StartMonth + '-01' AS DATE), CAST(CurrentMonth + '-01' AS DATE)) = 12 THEN Revenue ELSE 0 END) AS [Revenue from Customers Retained 12 Months Later]
FROM MonthlyRetentionRevenue
GROUP BY StartMonth
ORDER BY StartMonth;
