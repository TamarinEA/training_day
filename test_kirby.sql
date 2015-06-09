WITH _products AS (
  SELECT CASE WHEN created_at < '2015-04-01' THEN '03.01-03.14 march'
  	      WHEN created_at < '2015-05-01' THEN '04.17-04.30 april'
	      WHEN created_at < '2015-05-14' THEN '05.01-05.13 may1'
	      WHEN created_at < '2015-06-01' THEN '05.15-05.31 may2'
	      ELSE 'other'
	  END AS created_month, yml_id 
  FROM products 
  WHERE (created_at BETWEEN '2015-04-17' AND '2015-06-01') OR (created_at BETWEEN '2015-03-01' AND '2015-03-15')
),
_hand AS (
  SELECT created_month, count(*) AS hand_made 
  FROM _products where yml_id IS NULL 
  GROUP BY created_month
),
_kirby AS (
  SELECT created_month, count(*) AS kirby_made 
  FROM _products 
  WHERE yml_id IS NOT NULL
  GROUP BY created_month
)
SELECT h.created_month, h.hand_made, k.kirby_made 
FROM _hand h, _kirby k
WHERE h.created_month = k.created_month
ORDER BY h.created_month