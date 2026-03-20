use Education;

/* Repeat Purchase Rate by Age Group */

SELECT age_bracket,
  ROUND(100.0*
  SUM(CASE WHEN
  repeat_purchase='Old_Customer'
  THEN 1 ELSE 0 END)
  /COUNT(*),2)
  AS repeat_rate
FROM Skincare$
GROUP BY age_bracket
ORDER BY repeat_rate DESC;

/*Revenue by Sales Channel */

SELECT channel,
  SUM(price_inr * units_sold)
  AS revenue
FROM Skincare$
GROUP BY channel
ORDER BY revenue DESC;

/*Top Hero Ingredients by Gross Margin% */

SELECT hero_ingredient,
  ROUND(AVG(gross_margin_pct),2)
  AS avg_margin
FROM Skincare$
GROUP BY hero_ingredient
ORDER BY avg_margin DESC;

/*Return Rate by Product Category */

SELECT category,
  ROUND(100.0*
  SUM(CASE WHEN
  return_flag='Returned'
  THEN 1 ELSE 0 END)
  /COUNT(*),2)
  AS return_rate
FROM Skincare$
GROUP BY category
ORDER BY return_rate DESC;

/*Revenue by Skin Concern */

SELECT concern_addressed,
  SUM(price_inr*units_sold)
  AS revenue
FROM skincare$
GROUP BY concern_addressed
ORDER BY revenue DESC

/*Best Product per Category (Window Function — RANK)*/

SELECT category, product_name, total_rev, cat
FROM (
  SELECT category, product_name, total_rev,
    RANK() OVER (
      PARTITION BY category
      ORDER BY total_rev DESC
    ) AS cat
  FROM (
    SELECT category, product_name,
      SUM(price_inr * units_sold) AS total_rev
    FROM skincare$
    GROUP BY category, product_name
  ) sub
) ranked
WHERE cat = 1
ORDER BY total_rev DESC;