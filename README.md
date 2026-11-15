# Olist Executive Dashboard (Power BI)

A four-page Power BI report on the Olist Brazilian e-commerce dataset, built for an executive who needs to know, in a few minutes, whether the business is growing, how reliable delivery is, whether customers come back, and how dependent sales are on a few sellers.

The report sits on the star-schema mart built in SQL in [olist-ecommerce-analysis](https://github.com/EzzEldienMohsen/olist-ecommerce-analysis). Every headline number was checked against a SQL query written to the same definition.

![Overview](images/01-overview.png)

## Key findings (January–August 2018 vs the same months of 2017)

- **Sales grew 140.4%**: 7.33M against 3.05M.
- **Late delivery costs about 1.7 review stars.** Orders delivered on time average **4.30**, late orders **2.58**, and orders never delivered **1.74**.
- **9.37% of orders arrived late**, and lateness peaked in **March 2018** at around 20% before falling again.
- **States differ in two different ways.** AL has the highest late share, while RR has the longest deliveries but is not among the latest. In RR the delivery estimates allow for the distance; in AL they are too optimistic.
- **Only 2.12% of customers bought more than once** in the period (3.04% over the whole dataset). Growth comes almost entirely from new customers.
- **Sales are not concentrated in a few sellers.** The top 10 sellers make **12.99%** of revenue, out of about 2,380 active sellers. Seller revenue is heavily concentrated in **SP** state.

## Pages

| Page | Question it answers | Content |
|---|---|---|
| **Overview** | How big is the business, and is it growing? | KPI cards (revenue, YoY growth, orders, average order value, late %), monthly sales against last year, top 10 categories |
| **Customer & delivery** | How reliable is delivery, and do customers come back? | Late % and average delivery days, both by customer state (top 10), monthly late % trend, repeat-customer rate, average review, review score by on-time / late / not delivered |
| **Sellers** | How dependent are we on a few sellers? | Top-10 seller share, active seller count, revenue by seller state, seller ranking table (top 20) |
| **Seller detail** (drillthrough) | What does one seller look like? | Right-click a seller in the ranking table: revenue, orders, average order value, rank, monthly revenue, revenue by category |

A year and date slicer is synced across all pages. The report opens on **January–August 2018**, the latest complete months.

| Customer & delivery | Sellers | Seller detail |
|---|---|---|
| ![](images/02-customer-delivery.png) | ![](images/03-sellers.png) | ![](images/04-seller-detail.png) |

## Data model

| Table | Grain | Role |
|---|---|---|
| `fact_order_items` | one item in one order | revenue, sellers, products |
| `fact_orders` | one order | status, lateness, delivery days |
| `review_table` | one order (reviews averaged per order) | review score; one-to-one with `fact_orders` |
| `dim_customers`, `dim_products`, `dim_sellers` | one customer snapshot / product / seller | |
| `dim_date` | one day | marked date table; a second copy plays the delivery-date role |

`review_table` is a view added for this report: see [`sql/review_table.sql`](sql/review_table.sql).

## Definitions

| Measure | Definition |
|---|---|
| **Revenue** | item price, sale statuses only (delivered, invoiced, approved, shipped); freight excluded |
| **Orders / average order value** | every order **placed**, any status |
| **Late %** | late orders ÷ delivered orders with a delivery date |
| **Repeat-customer rate** | people (`customer_unique_id`) with 2+ sale orders in the period ÷ people with 1+ |
| **Top-10 seller share** | revenue of the 10 highest-revenue sellers ÷ all revenue |
| **YoY %** | (period − same period last year) ÷ same period last year |

**Why revenue and average order value use different statuses:** revenue counts money actually earned, so canceled and unavailable orders are left out. Average order value describes ordering behaviour, and every order placed in the system is part of that, completed or not.

## Limitations

- **Delivery cannot be broken down by category or seller.** Lateness lives on `fact_orders`, which has no product or seller key, so a category or seller filter does not reach it. This is why delivery is analysed by state and time only, and why the seller page shows no late %.
- **2018 data stops in August.** September and October 2018 hold almost no sales, so growth is compared on January–August of each year.
- **Small states.** Some states have few orders, so their late % and delivery days move a lot; the bar tooltips show the order count behind each bar.
- **Never-delivered orders** appear as *(Blank)* in the review chart, since lateness does not apply to them.

## Tools

Power BI Desktop (Power Query, DAX: CALCULATE, time intelligence, RANKX, FILTER over VALUES, drillthrough, synced slicers) · PostgreSQL (mart views, verification queries)

## Files

```
power_bi_olist_project.pbix   the report
power_bi_olist_project.pdf    PDF export of all pages
images/                       page screenshots
sql/review_table.sql          view added to the mart for this report
```

Data: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).
