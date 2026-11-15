-- One row per order: an order can have more than one review, so scores are averaged per order.
-- Grain matches mart.fact_orders, so the two relate one-to-one in Power BI.
CREATE OR REPLACE VIEW mart.review_table AS (
    SELECT order_id,
           AVG(review_score) AS average_review
    FROM reviews
    GROUP BY order_id
);
