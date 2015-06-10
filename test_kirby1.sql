SELECT CASE WHEN created_at < '2015-03-16' THEN '03.01-03.15 march1'
	    WHEN created_at < '2015-04-01' THEN '03.16-03.31 march2'
	    WHEN created_at < '2015-04-16' THEN '04.01-04.15 april1'
  	    WHEN created_at < '2015-05-01' THEN '04.16-04.30 april2'
	    WHEN created_at < '2015-05-15' THEN '05.01-05.14 may1'
	    WHEN created_at < '2015-06-01' THEN '05.14-05.31 may2'
	    ELSE 'other'
	END AS created_month,
	SUM(CASE WHEN yml_id IS NOT NULL THEN 0 ELSE 1 END) as hand_made,
	SUM(CASE WHEN yml_id IS NOT NULL THEN 1 ELSE 0 END) as kyrby_made
FROM products 
WHERE (created_at BETWEEN '2015-03-01' AND '2015-06-01') AND create_user_type = 'ugc'
GROUP BY created_month
ORDER BY created_month