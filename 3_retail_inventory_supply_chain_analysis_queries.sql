SELECT * FROM retail_inventory;

--Q1. What are the overall sales, revenue, estimated gross profit, and average selling price for the business in 2025?

SELECT
    COUNT(*) AS total_records,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * unit_price_inr), 2) AS total_revenue_inr,
    ROUND(
        SUM(units_sold * (unit_price_inr - unit_cost_inr)), 2
    ) AS estimated_gross_profit_inr,
    ROUND(AVG(unit_price_inr), 2) AS avg_unit_selling_price_inr
FROM retail_inventory;


--Q2. How do total units sold and sales revenue vary month by month in 2025? Which month generates the highest revenue?

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * unit_price_inr), 2) AS total_revenue_inr
FROM retail_inventory
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY sales_month;


--Q3. Which product categories generate the highest sales revenue and estimated gross profit, and how many units are sold in each category?

SELECT
    category,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * unit_price_inr), 2) AS total_revenue_inr,
    ROUND(
        SUM(units_sold * (unit_price_inr - unit_cost_inr)), 2
    ) AS estimated_gross_profit_inr
FROM retail_inventory
GROUP BY category
ORDER BY total_revenue_inr DESC;


--Q4. How do suppliers compare in terms of units sold, sales revenue, average lead time, and total shipping cost?

SELECT
    supplier_name,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * unit_price_inr), 2) AS total_revenue_inr,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    ROUND(SUM(shipping_cost_inr), 2) AS total_shipping_cost_inr
FROM retail_inventory
GROUP BY supplier_name
ORDER BY total_revenue_inr DESC;


--Q5. How many inventory records are below their reorder level, and how much stock is available compared with the required reorder level?

SELECT
    CASE
        WHEN stock_on_hand < reorder_level THEN 'Reorder Required'
        WHEN stock_on_hand >= reorder_level THEN 'Stock Sufficient'
        ELSE 'Data Missing'
    END AS stock_status,
    COUNT(*) AS record_count,
    SUM(stock_on_hand) AS total_stock_on_hand,
    SUM(reorder_level) AS total_reorder_level
FROM retail_inventory
GROUP BY
    CASE
        WHEN stock_on_hand < reorder_level THEN 'Reorder Required'
        WHEN stock_on_hand >= reorder_level THEN 'Stock Sufficient'
        ELSE 'Data Missing'
    END
ORDER BY record_count DESC;


--Q6. What percentage of orders are delivered on time, delayed, in transit, or cancelled?

SELECT
    delivery_status,
    COUNT(*) AS record_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM retail_inventory
GROUP BY delivery_status
ORDER BY record_count DESC;


--Q7. Which product categories have the highest number of returned units, and what is their return rate compared with units sold?

SELECT
    category,
    SUM(units_sold) AS total_units_sold,
    SUM(returned_units) AS total_returned_units,
    ROUND(
        SUM(returned_units) * 100.0
        / NULLIF(SUM(units_sold), 0),
        2
    ) AS return_rate_percentage
FROM retail_inventory
GROUP BY category
ORDER BY return_rate_percentage DESC;


--Q8. How often are actual units sold above, below, or equal to demand forecasts?

SELECT
    CASE
        WHEN units_sold > demand_forecast_units
            THEN 'Above Forecast'
        WHEN units_sold < demand_forecast_units
            THEN 'Below Forecast'
        WHEN units_sold = demand_forecast_units
            THEN 'Matched Forecast'
        ELSE 'Forecast Missing'
    END AS forecast_status,
    COUNT(*) AS record_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM retail_inventory
GROUP BY
    CASE
        WHEN units_sold > demand_forecast_units
            THEN 'Above Forecast'
        WHEN units_sold < demand_forecast_units
            THEN 'Below Forecast'
        WHEN units_sold = demand_forecast_units
            THEN 'Matched Forecast'
        ELSE 'Forecast Missing'
    END
ORDER BY record_count DESC;


--Q9. Which sales channels generate the highest revenue and sales volume, and what is their average selling price?

SELECT
    sales_channel,
    COUNT(*) AS total_records,
    SUM(units_sold) AS total_units_sold,
    ROUND(
        SUM(units_sold * unit_price_inr), 2
    ) AS total_revenue_inr,
    ROUND(
        SUM(units_sold * unit_price_inr)
        / NULLIF(SUM(units_sold), 0), 2
    ) AS revenue_per_unit_sold
FROM retail_inventory
GROUP BY sales_channel
ORDER BY total_revenue_inr DESC;


--Q10. How do warehouses compare in terms of stock available, inventory value, units sold, and records requiring reorder?

SELECT
    warehouse_location,
    COUNT(*) AS total_records,
    SUM(stock_on_hand) AS total_stock_on_hand,
    ROUND(SUM(inventory_value_inr), 2) AS total_inventory_value_inr,
    SUM(units_sold) AS total_units_sold,
    COUNT(*) FILTER (
        WHERE stock_on_hand < reorder_level
    ) AS records_requiring_reorder
FROM retail_inventory
GROUP BY warehouse_location
ORDER BY total_inventory_value_inr DESC;












