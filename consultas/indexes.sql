CREATE INDEX q01i1 ON lineitem (l_shipdate, l_returnflag, l_linestatus);
CREATE INDEX q02i1 ON part     (p_type, p_size, p_partkey);
CREATE INDEX q02i2 ON region   (r_name, r_regionkey);
CREATE INDEX q02i3 ON nation   (n_regionkey, n_nationkey);
CREATE INDEX q02i4 ON supplier (s_nationkey, s_suppkey);
CREATE INDEX q02i5 ON partsupp (ps_partkey, ps_supplycost, ps_suppkey);
CREATE INDEX q03i1 ON lineitem (l_shipdate, l_orderkey);
CREATE INDEX q03i2 ON orders   (o_orderdate, o_custkey, o_orderkey) INCLUDE (o_shippriority);
CREATE INDEX q03i3 ON customer (c_mktsegment, c_custkey);
CREATE INDEX q04i1 ON orders   (o_orderdate, o_orderkey, o_orderpriority);
CREATE INDEX q04i2 ON lineitem (l_orderkey, l_commitdate, l_receiptdate);
CREATE INDEX q05i1 ON orders   (o_orderdate, o_orderkey, o_custkey);
CREATE INDEX q05i2 ON lineitem (l_orderkey, l_suppkey, l_extendedprice, l_discount);
CREATE INDEX q05i3 ON customer (c_custkey, c_nationkey);
CREATE INDEX q05i4 ON supplier (s_suppkey, s_nationkey);
CREATE INDEX q05i5 ON nation   (n_nationkey, n_regionkey, n_name);
CREATE INDEX q05i6 ON region   (r_regionkey, r_name);
-- CREATE INDEX q05i7 ON orders   (o_orderdate, o_custkey, o_orderkey) -- Repetido q03i2
CREATE INDEX q05i7 ON customer (c_nationkey, c_custkey);
-- CREATE INDEX q05i8 ON supplier (s_nationkey, s_suppkey) -- Repetido q02i4
CREATE INDEX q06i1 ON lineitem (l_shipdate, l_discount, l_quantity) INCLUDE (l_extendedprice);
CREATE INDEX q07i1 ON lineitem (l_shipdate, l_suppkey, l_orderkey) INCLUDE (l_extendedprice, l_discount);
CREATE INDEX q07i2 ON orders   (o_orderkey, o_custkey);
-- CREATE INDEX q07i3 ON customer (c_custkey, c_nationkey) -- Repetido q05i3
-- CREATE INDEX q07i3 ON supplier (s_suppkey, s_nationkey) -- Repetido q05i4
CREATE INDEX q08i1 ON lineitem (l_shipdate, l_orderkey, l_suppkey);
CREATE INDEX q08i2 ON lineitem (l_partkey, l_orderkey, l_suppkey);
-- CREATE INDEX q08i3 ON orders   (o_orderdate, o_orderkey, o_custkey) -- Repetido q05i1
-- CREATE INDEX q08i3 ON part     (p_type, p_partkey) -- Innecesario por q02i1
-- CREATE INDEX q08i3 ON customer (c_custkey, c_nationkey) -- Repetido q05i3
-- CREATE INDEX q08i3 ON supplier (s_suppkey, s_nationkey) -- Repetido q05i4
CREATE INDEX q09i1 ON part     (p_name, p_partkey);
CREATE INDEX q09i2 ON lineitem (l_partkey, l_suppkey, l_orderkey);
CREATE INDEX q09i3 ON partsupp (ps_partkey, ps_suppkey, ps_supplycost);
-- CREATE INDEX q09i4 ON orders   (o_orderdate, o_orderkey, o_custkey) -- Repetido q05i1
-- CREATE INDEX q09i4 ON supplier (s_suppkey, s_nationkey) -- Repetido q05i4
-- CREATE INDEX q10i1 ON orders   (o_orderdate, o_custkey, o_orderkey) -- Repetido q03i2
CREATE INDEX q10i1 ON lineitem (l_returnflag, l_orderkey, l_extendedprice, l_discount);
-- CREATE INDEX q10i2 ON customer (c_custkey, c_nationkey) -- Repetido q05i3
-- CREATE INDEX q11i1 ON supplier (s_suppkey, s_nationkey) -- Repetido q05i4
CREATE INDEX q11i1 ON partsupp (ps_suppkey, ps_partkey, ps_supplycost, ps_availqty);
CREATE INDEX q11i2 ON nation   (n_name, n_nationkey);
CREATE INDEX q12i1 ON orders   (o_orderkey, o_orderpriority);
CREATE INDEX q12i2 ON lineitem (l_receiptdate, l_orderkey) INCLUDE (l_shipmode, l_commitdate, l_shipdate);
CREATE INDEX q13i1 ON orders_by_customer USING GIN (o_comment gin_trgm_ops);
CREATE INDEX q14i1 ON lineitem (l_shipdate, l_partkey) INCLUDE (l_extendedprice, l_discount);
-- CREATE INDEX q14i2 ON part     (p_type) -- Innecesario por q02i1
-- CREATE INDEX q15i1 ON lineitem (l_shipdate, l_suppkey, l_extendedprice, l_discount) -- Repetido q07i1
CREATE INDEX q16i1 ON part     (p_partkey, p_brand, p_type, p_size);
-- CREATE INDEX q16i2 ON partsupp (ps_partkey, ps_suppkey) -- Innecesario q09i3
CREATE INDEX q16i2 ON supplier (s_suppkey, s_comment);
CREATE INDEX q16i3 ON supplier USING GIN (s_comment gin_trgm_ops);
CREATE INDEX q17i1 ON part     (p_partkey, p_brand, p_container);
CREATE INDEX q17i2 ON lineitem_by_part (l_partkey, l_quantity, l_extendedprice);
CREATE INDEX q18i1 ON lineitem (l_orderkey, l_quantity);
CREATE INDEX q18i2 ON orders_by_customer (o_orderkey, o_custkey, o_totalprice, o_orderdate);
CREATE INDEX q18i3 ON customer (c_custkey, c_name);
CREATE INDEX q19i1 ON part     (p_brand, p_container, p_size, p_partkey);
CREATE INDEX q19i2 ON lineitem_by_part (l_partkey, l_quantity, l_shipmode, l_shipinstruct);
-- CREATE INDEX q20i1 ON part     (p_name, p_partkey) -- Repetido q09i1
CREATE INDEX q20i1 ON lineitem_by_part (l_partkey, l_suppkey, l_shipdate, l_quantity);
CREATE INDEX q20i2 ON partsupp (ps_partkey, ps_suppkey, ps_availqty);
-- CREATE INDEX q20i3 ON supplier (s_nationkey, s_suppkey) -- Repetido q02i4
-- CREATE INDEX q20i3 ON nation   (n_name, n_nationkey) -- Repetido q11i2
CREATE INDEX q20i3 ON part     (p_name text_pattern_ops);
-- CREATE INDEX q20i4 ON lineitem_by_part (l_partkey, l_suppkey, l_shipdate) -- Repetido q20i1
-- CREATE INDEX q20i4 ON partsupp (ps_partkey, ps_suppkey) -- Innecesario q09i3
CREATE INDEX q21i1 ON lineitem (l_orderkey, l_suppkey, l_receiptdate, l_commitdate);
CREATE INDEX q21i2 ON orders   (o_orderkey, o_orderstatus);
-- CREATE INDEX q21i3 ON supplier (s_suppkey, s_nationkey) -- Repetido q05i4
-- CREATE INDEX q21i3 ON nation   (n_nationkey, n_name) -- Innecesario q05i5
CREATE INDEX q22i1 ON customer (c_phone)
