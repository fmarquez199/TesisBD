WITH ordenes AS (
SELECT c_custkey, COUNT(o_orderkey) AS c_count
FROM customer LEFT OUTER JOIN orders_by_customer ON c_custkey = o_custkey AND o_comment NOT LIKE '%special%requests%'
GROUP BY c_custkey
)
SELECT c_count, COUNT(*) AS custdist
FROM ordenes
GROUP BY c_count
ORDER BY custdist DESC, c_count DESC;
