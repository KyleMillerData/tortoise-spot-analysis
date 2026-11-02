-- The Tortoise Spot: Search Performance Analysis
-- Database: SQLite
-- GSC reporting period: April 21–October 20, 2026
--
-- Question:
-- Which pages have substantial search visibility but low CTR?
--
-- Review pages with at least 10,000 impressions.
-- Exclude URLs containing # fragments.
-- Calculate CTR from clicks and impressions.
-- Sort using unrounded CTR.


SELECT
    page_url,
    clicks,
    impressions,
    ROUND(100.0 * clicks / impressions, 2) AS ctr_pct,
    position
FROM gsc_pages
WHERE impressions >= 10000
  AND page_url NOT LIKE '%#%'
ORDER BY 100.0 * clicks / impressions ASC,
         impressions DESC
LIMIT 10;

-- Data-quality check: repeated page URLs
-- Found one URL appearing twice, with different metrics.
-- Both records were retained for investigation.
-- A direct join on this URL could repeat GA4 sessions.


SELECT
    page_url,
    COUNT(*) AS source_rows
FROM gsc_pages
GROUP BY page_url
HAVING COUNT(*) > 1;


WITH coverage AS (
    SELECT
        SUM(g.Sessions) AS identified_sessions,
        SUM(
            CASE WHEN EXISTS (
                SELECT 1
                FROM gsc_pages AS s
                WHERE s.page_url NOT LIKE '%#%'
                  AND RTRIM(
                        REPLACE(
                            s.page_url,
                            'https://thetortoisespot.com',
                            ''
                        ),
                        '/'
                      ) = RTRIM(g.landing_page, '/')
            )
            THEN g.Sessions
            ELSE 0
            END
        ) AS matched_sessions
    FROM ga4_landing_pages AS g
    WHERE g.landing_page <> '(not set)'
)
SELECT
    identified_sessions,
    matched_sessions,
    identified_sessions - matched_sessions AS unmatched_sessions,
    ROUND(
        100.0 * matched_sessions / identified_sessions,
        2
    ) AS matched_session_pct
FROM coverage;

--I extended the Excel analysis using SQLite in DBeaver. SQL reproduced the lifespan page finding of 159,832 impressions,
--80 clicks and approximately 0.05% CTR. A data quality check also identified one repeated page URL with differing metrics; both records were retained for investigation.
--I checked matching coverage between GA4 landing page paths and GSC URLs after removing the domain and trailing slashes and excluding GSC URL fragments.
--The query uses EXISTS to avoid repeating GA4 sessions when multiple GSC records match a page. This checks coverage within the supplied exports, rather than indexing status or equivalent traffic,
--because the sources cover different periods and traffic scopes.
