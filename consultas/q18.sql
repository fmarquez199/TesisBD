/* TPC-H Q18 */
SELECT
    c_name,
    c_custkey,
    o.o_orderkey,
    o.o_orderdate,
    o.o_totalprice,
    SUM(l_quantity)
FROM
    customer,
    orders o,
    orders_by_customer oc,
    lineitem
WHERE
    o.o_orderkey IN (
        SELECT
            l_orderkey
        FROM
            lineitem
        GROUP BY
            l_orderkey HAVING SUM(l_quantity) > 300
    )
    AND c_custkey = oc.o_custkey
    AND o.o_orderkey = l_orderkey
    AND o.o_orderkey = oc.o_custkey  -- mine
GROUP BY
    c_name,
    c_custkey,
    o.o_orderkey,
    o.o_orderdate,
    o.o_totalprice
ORDER BY
    o.o_totalprice DESC,
    o.o_orderdate
LIMIT 100;
