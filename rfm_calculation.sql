-- STEP 1: append all monthly sales tables together 

CREATE OR REPLACE TABLE `rfmanalysis54274.sales.sales_2025` AS
SELECT * FROM `rfmanalysis54274.sales.202501` 
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202502`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202503`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202504`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202505`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202506`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202507`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202508`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202509`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202510`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202511`
UNION ALL 
SELECT * FROM `rfmanalysis54274.sales.202512`;

-- step 2; rfm scores
-- combine views with CTEs

CREATE OR REPLACE VIEW `rfmanalysis54274.sales.rfm_metrics` AS

WITH current_date AS (
  SELECT DATE '2026-04-18' AS analysis_date
),

rfm AS (
  SELECT 
    CustomerId,
    MAX(OrderDate) AS last_order_date,

    DATE_DIFF(
      (SELECT analysis_date FROM current_date),
      MAX(OrderDate),
      DAY
    ) AS recency,

    COUNT(*) AS frequency,
    SUM(OrderValue) AS monetary

  FROM `rfmanalysis54274.sales.sales_2025`
  GROUP BY CustomerId
)

SELECT 
  rfm.*,

  ROW_NUMBER() OVER (ORDER BY recency ASC) AS r_rank,
  ROW_NUMBER() OVER (ORDER BY frequency DESC) AS f_rank,
  ROW_NUMBER() OVER (ORDER BY monetary DESC) AS m_rank

FROM rfm;


