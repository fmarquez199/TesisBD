nodes = dict([("159.90.9.1" + str(i), "a" + str(9 + i)) for i in range(4)])

queries = {
    13: (1758236526.0, 1758236738.0),
    11: (1758236747.0, 1758236935.0),
    18: (1758236936.0, 1758237002.0),
    22: (1758237016.0, 1758237154.0),
    16: (1758237156.0, 1758239935.0),
    6: (1758243247.0, 1758247802.0),
    1: (1758247805.0, 1758251916.0),
    12: (1758251919.0, 1758257161.0),
    4: (1758257164.0, 1758262199.0),
    17: (1758262202.0, 1758265705.0),
    14: (1758265708.0, 1758270572.0),
    19: (1758270574.0, 1758277547.0),
    5: (1758277549.0, 1758284833.0),
    2: (1758284837.0, 1758301385.0),
    3: (1758301398.0, 1758325978.0),
    15: (1758325983.0, 1758345775.0),
    7: (1758345778.0, 1758363340.0),
    20: (1758363341.0, 1758383141.0),
    21: (1758385327.0, 1758417976.0),
    8: (1758417991.0, 0.0),
    9: (0.0, 0.0),
    10: (0.0, 0.0)
}

with open("raw_tpch/postgres/consumo_neto.md", "r") as f:
    consumo = f.readlines()

destination = "Results/postgres-raw-"

for query in queries:
    if not queries[query][1]:
        continue
    begin, end = queries[query]
    columns = dict()
    for line in consumo[2:]:
        data = line.split("#")
        column = float(data[1].strip()) - begin
        if begin <= float(data[1].strip()) <= end:
            try:
                columns[column]
            except:
                columns[column] = {
                    "a9": 0.0,
                    "a10": 0.0,
                    "a11": 0.0,
                    "a12": 0.0
                }
            else:
                cons = float(data[0].split("|")[2].strip())
                columns[column][nodes[data[0].split("|")[0].strip()]] += cons

    lines = ["Tiempo\ta9\ta10\ta11\ta12\n"]
    for column in columns:
        lines.append("%s\t%s\t%s\t%s\t%s\n" % (
            round(column),
            columns[column]["a9"],
            columns[column]["a10"],
            columns[column]["a11"],
            columns[column]["a12"]
        ))

    with open(destination + str(query) + ".txt", "w") as f:
        f.writelines(lines)