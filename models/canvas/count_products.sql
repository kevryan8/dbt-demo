WITH stg_orders AS (
  /* Order data with basic cleaning and transformation applied, one row per order. */
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_orders') }}
), stg_order_items AS (
  /* Individual food and drink items that make up our orders, one row per item. */
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_order_items') }}
), join_1 AS (
  SELECT
    stg_orders.ORDER_ID,
    stg_orders.CUSTOMER_ID,
    stg_order_items.PRODUCT_ID
  FROM stg_orders
  JOIN stg_order_items
    USING (ORDER_ID)
), aggregate_1 AS (
  SELECT
    CUSTOMER_ID,
    PRODUCT_ID,
    COUNT(PRODUCT_ID) AS count_PRODUCT_ID
  FROM join_1
  GROUP BY
    CUSTOMER_ID,
    PRODUCT_ID
), order_1 AS (
  SELECT
    *
  FROM aggregate_1
  ORDER BY
    CUSTOMER_ID ASC,
    count_PRODUCT_ID DESC
), count_products_sql AS (
  SELECT
    *
  FROM order_1
)
SELECT
  *
FROM count_products_sql