WITH precalculos AS (
    SELECT
       l_returnflag,
       l_linestatus,
       l_quantity,
       l_extendedprice,
       l_discount,
       l_extendedprice * (1 - l_discount) AS descuento,
       l_extendedprice * (1 - l_discount) * (1 + l_tax) AS cargos
    FROM
        lineitem
    WHERE
        l_shipdate <= '1998-09-01'
)
SELECT
    l_returnflag,
    l_linestatus,
    SUM(l_quantity) AS sum_qty,
    SUM(l_extendedprice) AS sum_base_price,
    SUM(descuento) AS sum_disc_price,
    AVG(l_quantity) AS avg_qty,
    AVG(l_extendedprice) AS avg_price,
    COUNT(*) AS count_order
FROM
    precalculos
GROUP BY
    l_returnflag,
    l_linestatus
ORDER BY
    l_returnflag,
    l_linestatus;
