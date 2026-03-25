/*EXPLAIN ANALYZE*/ WITH profit_cte AS (
    SELECT
        n.n_name AS nation,
        EXTRACT(YEAR FROM o.o_orderdate) AS o_year,
        (l.l_extendedprice * (1 - l.l_discount)) - (ps.ps_supplycost * l.l_quantity) AS amount
    FROM
        part p
        JOIN lineitem l ON p.p_partkey = l.l_partkey
        JOIN supplier s ON s.s_suppkey = l.l_suppkey
        JOIN partsupp ps ON ps.ps_suppkey = l.l_suppkey AND ps.ps_partkey = l.l_partkey
        JOIN orders o ON o.o_orderkey = l.l_orderkey
        JOIN nation n ON s.s_nationkey = n.n_nationkey
    WHERE
        p.p_name LIKE 'green' -- Aquí va el color que el benchmark decida buscar
)
SELECT
    nation,
    o_year,
    SUM(amount) AS sum_profit
FROM
    profit_cte
GROUP BY
    nation,
    o_year
ORDER BY
    nation,
    o_year DESC;

