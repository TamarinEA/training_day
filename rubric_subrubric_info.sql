CREATE OR REPLACE FUNCTION uniq_array_count_from_string(text)
RETURNS INTEGER AS $$
DECLARE uniq_array_count integer;
BEGIN
	SELECT count(k.*) INTO uniq_array_count
	FROM (SELECT DISTINCT * FROM unnest(string_to_array($1, ',')) order by 1) k;
	RETURN uniq_array_count;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_rubric_info(int) 
RETURNS TABLE (
	id_rubric int,
	rubric_title varchar,
	rubric_level int,
	subrubric_sum int,
	rubric_trait int,
	product_count numeric,
	product_with_trait numeric
) AS $$
BEGIN
	SET enable_seqscan = off;
	SET enable_bitmapscan = off;
	RETURN QUERY
	WITH 
	_rubrics AS (
	SELECT id, title, cached_level, (rgt - lft - 1)/2 AS rubric_sum, lft, rgt
	FROM rubrics
	WHERE lft >= (SELECT lft FROM rubrics WHERE id = $1)
	AND rgt <= (SELECT rgt FROM rubrics WHERE id = $1)
	),
	_rubric_with_trait AS (
	SELECT rubric_id, ARRAY_AGG(trait_id) AS rubric_trait
	FROM trait_rubrics
	WHERE rubric_id IN (SELECT id FROM _rubrics)
	GROUP BY rubric_id
	),
	_trait_subrubric_count AS (
	SELECT r.id, CASE WHEN r.rubric_sum = 0 THEN uniq_array_count_from_string(array_to_string(t.rubric_trait, ','))
			  WHEN r.id = $1 THEN (SELECT uniq_array_count_from_string(STRING_AGG(array_to_string(rt.rubric_trait, ','), ',')) 
					      FROM  _rubric_with_trait rt)
			  ELSE (SELECT  uniq_array_count_from_string(STRING_AGG(array_to_string(rt.rubric_trait, ','), ',')) 
				FROM  _rubric_with_trait rt
				WHERE rubric_id IN (SELECT id FROM _rubrics WHERE lft >= (SELECT lft FROM rubrics WHERE id = r.id) 
									    AND rgt <= (SELECT rgt FROM rubrics WHERE id = r.id)))
		     END as trait_count
	FROM _rubrics r
	LEFT JOIN _rubric_with_trait t ON r.id = t.rubric_id
	),
	_products AS (
	SELECT rubric_id, id
	FROM products 
	WHERE rubric_id IN (SELECT id FROM _rubrics)
	),
	_product_with_trait AS (
	SELECT DISTINCT product_id, 1 as prod_trait
	FROM trait_products
	WHERE product_id IN (SELECT id FROM _products)
	AND trait_id IN (SELECT id FROM traits WHERE inside = false)
	),
	_product_count AS (
	SELECT p.rubric_id, COUNT(p.id) AS prod_count,  SUM(pt.prod_trait) AS prod_trait_count
	FROM _products p
	LEFT JOIN _product_with_trait pt ON p.id = pt.product_id
	GROUP BY p.rubric_id
	),
	_product_subrubric_count AS (
	SELECT r.id,
	       CASE WHEN r.id = $1 THEN (SELECT SUM(pc.prod_count) FROM _product_count pc)
		    WHEN r.rubric_sum = 0 THEN p.prod_count
		    ELSE (SELECT SUM(pc.prod_count) FROM _product_count pc
			  WHERE pc.rubric_id IN (SELECT id FROM _rubrics WHERE lft >= (SELECT lft FROM rubrics WHERE id = r.id) 
								      AND rgt <= (SELECT rgt FROM rubrics WHERE id = r.id)))
	       END AS product_count,
	       CASE WHEN r.id = $1 THEN (SELECT SUM(pc.prod_trait_count) FROM _product_count pc)
		    WHEN r.rubric_sum = 0 THEN p.prod_trait_count
		    ELSE (SELECT SUM(pc.prod_trait_count) FROM _product_count pc 
			  WHERE pc.rubric_id IN (SELECT id FROM _rubrics WHERE lft >= (SELECT lft FROM rubrics WHERE id = r.id) 
								      AND rgt <= (SELECT rgt FROM rubrics WHERE id = r.id)))
	       END AS prod_trait_count
	FROM (SELECT id, rubric_sum FROM _rubrics) r
	LEFT JOIN _product_count p ON r.id = p.rubric_id
	)
	SELECT r.id, r.title, r.cached_level, r.rubric_sum, t.trait_count, p.product_count, p.prod_trait_count
	FROM _rubrics r, _product_subrubric_count p, _trait_subrubric_count t
	WHERE r.id = p.id
	AND r.id = t.id;
END
$$ LANGUAGE plpgsql;

SELECT id_rubric, rubric_title, rubric_level, subrubric_sum,
       COALESCE(rubric_trait, 0) as trait_count,
       COALESCE(product_count, 0) as product_count,
       COALESCE(product_with_trait, 0) as product_with_trait_count 
FROM get_rubric_info(133963)
ORDER BY rubric_level