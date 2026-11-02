# The Tortoise Spot: Traffic and Search Performance Analysis

An Excel and SQL analysis of my website, investigating which pages attract visitors and which receive substantial Google Search visibility but few clicks.

## Project question

Which pages receive high numbers of Google Search impressions but have low click-through rates, and deserve further investigation?

## Key findings

- The lifespan page received **159,832 impressions and 80 clicks**, approximately **0.05% CTR**.
- Its query “tortoise lifespan” generated **29,161 impressions and 12 clicks**, approximately **0.04% CTR**.
- The top 10 identified GA4 landing pages accounted for **4,603 sessions**, or **38.83% of all sessions**.
- SQL matching checks found that **99.89% of identified GA4 sessions** had at least one matching page key in the supplied GSC export. This measures export coverage, not indexing status.

## Explore the project

- [Read the case study](TortoiseSpot_Portfolio_Casestudy_Final.pdf)
- [View the Excel workbook](TortoiseSpot_project1.xlsx)
- [Read the SQL analysis](TortoiseSpot_portfolio_analysis.sql)

## Tools and methods

**Excel and Power Query:** cleaned the GA4 import, assigned data types, calculated metrics, and built PivotTables and a chart.

**SQLite and DBeaver:** reproduced the search opportunity finding, checked repeated URLs, and measured matching coverage using a CTE and EXISTS to avoid repeating GA4 sessions.

Original exports were preserved. CTR was calculated from total clicks divided by total impressions.

## Data scope

| Source | Reporting period |
|---|---|
| Google Search Console | April 21–October 20, 2026 |
| Google Analytics 4 | September 24–October 21, 2026 |

The sources were analysed separately because their periods and traffic coverage differ. The search-opportunity review required at least 10,000 impressions and excluded URLs containing `#` fragments.

## Using the files

The SQL script expects imported SQLite tables named `ga4_landing_pages` and `gsc_pages`; it does not create or populate them. Source data is available in the workbook’s `GA4_Work` and `Pages` sheets. The queries use `landing_page` and `Sessions` from GA4, and `page_url`, `clicks`, `impressions`, and `position` from GSC.

The workbook contains saved results. Refreshing its Power Query connection requires the original CSV at its configured location.

## Recommendations and status

The review recommended verifying lifespan claims, making the article and meta description consistent, and placing a concise, sourced answer near the beginning.

Changes have been implemented, but their effects have not yet been evaluated. The planned review compares equal 28-day periods before and after implementation.

## Limitations

Search Console exports do not include every query. URL matching uses a defined normalisation rule and a limited export. Low CTR alone does not establish its cause, and any later improvement would not prove the changes caused it.
