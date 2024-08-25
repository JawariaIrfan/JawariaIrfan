WITH CustomerPurchases AS (
    SELECT 
        CustomerID,
        FORMAT(InvoiceDate, 'yyyy-MM') AS PurchaseMonth
    FROM SALES$
)
SELECT 
    CustomerID,
    COUNT(DISTINCT PurchaseMonth) AS TotalMonthsWithPurchases,
    MIN(PurchaseMonth) AS FirstPurchaseMonth,
    MAX(PurchaseMonth) AS LastPurchaseMonth
FROM CustomerPurchases
GROUP BY CustomerID;
