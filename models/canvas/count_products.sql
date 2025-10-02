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
), stg_customers AS (
  /* Customer data with basic cleaning and transformation applied, one row per customer. */
  SELECT
    *
  FROM {{ ref('jaffle_shop', 'stg_customers') }}
), join_on_order_id AS (
  SELECT
    stg_orders.ORDER_ID,
    stg_orders.CUSTOMER_ID,
    stg_order_items.PRODUCT_ID
  FROM stg_orders
  JOIN stg_order_items
    USING (ORDER_ID)
), join_customer_name AS (
  SELECT
    join_on_order_id.ORDER_ID,
    join_on_order_id.CUSTOMER_ID,
    stg_customers.CUSTOMER_NAME,
    join_on_order_id.PRODUCT_ID,
    stg_customers.CUSTOMER_ID AS CUSTOMER_ID_1
  FROM join_on_order_id
  LEFT JOIN stg_customers
    USING (CUSTOMER_ID)
), count_product_ids_by_customer AS (
  SELECT
    CUSTOMER_NAME,
    PRODUCT_ID,
    COUNT(PRODUCT_ID) AS count_PRODUCT_ID
  FROM join_customer_name
  GROUP BY
    CUSTOMER_NAME,
    PRODUCT_ID
), order_products_in_decending_order AS (
  SELECT
    *
  FROM count_product_ids_by_customer
  ORDER BY
    CUSTOMER_NAME ASC,
    count_PRODUCT_ID DESC
), count_products_sql AS (
  SELECT
    *
  FROM order_products_in_decending_order
)
SELECT
  *
FROM count_products_sql