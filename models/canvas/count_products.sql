WITH stg_orders AS (
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_orders') }}
), stg_order_items AS (
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_order_items') }}
), stg_customers AS (
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_customers') }}
), join_1 AS (
  SELECT
    *
  FROM stg_orders
  JOIN stg_order_items
    USING (ORDER_ID)
), formula_1 AS (
  SELECT
    *,
    SPLIT_PART(CUSTOMER_NAME, ' ', 1) AS FIRST_NAME,
    SPLIT_PART(CUSTOMER_NAME, ' ', 2) AS LAST_NAME
  FROM stg_customers
), rename_1 AS (
  SELECT
    ORDER_ID,
    CUSTOMER_ID,
    PRODUCT_ID
  FROM join_1
), join_2 AS (
  SELECT
    *
  FROM rename_1
  LEFT JOIN formula_1
    USING (CUSTOMER_ID)
), rename_2 AS (
  SELECT
    ORDER_ID,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    FIRST_NAME,
    LAST_NAME,
    PRODUCT_ID,
    CUSTOMER_ID AS CUSTOMER_ID_1
  FROM join_2
), aggregate_1 AS (
  SELECT
    CUSTOMER_NAME,
    FIRST_NAME,
    LAST_NAME,
    PRODUCT_ID,
    COUNT(PRODUCT_ID) AS COUNT_PRODUCT_ID
  FROM rename_2
  GROUP BY
    CUSTOMER_NAME,
    FIRST_NAME,
    LAST_NAME,
    PRODUCT_ID
), rename_3 AS (
  SELECT
    CUSTOMER_NAME,
    FIRST_NAME,
    LAST_NAME,
    PRODUCT_ID,
    COUNT_PRODUCT_ID
  FROM aggregate_1
), order_1 AS (
  SELECT
    *
  FROM rename_3
  ORDER BY
    COUNT_PRODUCT_ID DESC
), count_products_sql AS (
  SELECT
    *
  FROM order_1
)
SELECT
  *
FROM count_products_sql