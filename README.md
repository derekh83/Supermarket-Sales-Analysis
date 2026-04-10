# Supermarket Sales Analysis

A SQL and Tableau project analyzing 1,000 transactions across 3 supermarket branches over a 3-month period. Built to practice data cleaning, exploratory analysis, and translating raw transactional data into actionable operational insights through interactive visualization.

---

## Key Findings

- Peak sales occur between 6-8 PM, with a notable foot traffic slump from 4-6 PM suggesting staffing and promotional opportunities during that window.
- Females outspend males across all product categories except Health & Beauty, with implications for targeted merchandising strategy.
- Members outspend non-members by approximately $56K over the period, supporting the value of loyalty program investment.
- Saturdays and Tuesdays drive the highest sales volume while Mondays consistently underperform - informing weekly staffing and inventory decisions.
- The Cairo branch shows significantly higher hourly sales volatility compared to the other two locations.

---

## Methodology

- Designed a full SQL cleaning pipeline validating all 1,000 records for duplicates, null values, and inconsistent formatting.
- Standardized categorical fields across branch, product line, gender, and customer type.
- Queried and aggregated transaction data across time of day, day of week, branch, product line, gender, and customer type.
- Built an interactive Tableau story across 4 dashboards translating findings into visualizations.

---

## Tableau Visualizations

[View Tableau Dashboard](https://public.tableau.com/app/profile/derek.hanna/viz/grocery-proj-visualizations/Story1)

---

## Data Source

[Supermarket Sales Data- Kaggle](https://www.kaggle.com/datasets/faresashraf1001/supermarket-sales)

---

## Tools Used

- SQL- data cleaning and exploratory analysis
- Tableau- interactive dashboard and story creation

---

## Limitations & Future Work

- Data only covers 3 months, so seasonal trends and longer-term patterns aren't captured.
- No external data, like weather, local foot traffic, or promotions.
- Customer demographic data is limited. Age and income of shoppers would strengthen the analysis.
