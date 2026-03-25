/* TPC-H Q22 */
SELECT
    cntrycode,
    COUNT(*) AS numcust,
    SUM(c_acctbal) AS totacctbal
FROM (
    SELECT
        SUBSTRING(c_phone FROM 1 fOR 2) AS cntrycode,
        c_acctbal
    FROM
        customer
    WHERE
        SUBSTRING(c_phone FROM 1 fOR 2) IN
        ('13','31','23','29','30','18','17')
        AND c_acctbal > (
            SELECT
                AVG(c_acctbal)
            FROM
                customer
            WHERE
                c_acctbal > 0.00
                AND SUBSTRING (c_phone FROM 1 fOR 2) IN
                ('13','31','23','29','30','18','17')
        )
        AND NOT EXISTS (
            SELECT
                *
            FROM
                orders_by_customer
            WHERE
                o_custkey = c_custkey
        )
) AS custsale
GROUP BY
    cntrycode
ORDER BY
    cntrycode
