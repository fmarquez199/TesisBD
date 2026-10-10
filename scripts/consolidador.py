def sumar_medidas(medida_1, medida_2):
    return {
        '159.90.9.10': medida_1['159.90.9.10'] + medida_2['159.90.9.10'],
        '159.90.9.11': medida_1['159.90.9.11'] + medida_2['159.90.9.11'],
        '159.90.9.16': medida_1['159.90.9.16'] + medida_2['159.90.9.16'],
        '159.90.9.13': medida_1['159.90.9.13'] + medida_2['159.90.9.13']
    }

consumo = "../raw_tpch/postgres/consumo_neto.md"
tiempo = "../raw_tpch/postgres/timestamps-pd.txt"
medidas = dict()
medida = {
    '159.90.9.10': 0.0,
    '159.90.9.11': 0.0,
    '159.90.9.16': 0.0,
    '159.90.9.13': 0.0
}
consulta = dict([(i + 1, medida) for i in range(10)])
consultas = dict([(i + 1, consulta) for i in range(22)])

with open(consumo, "r") as f:
    consumos = f.readlines()

with open(tiempo, "r") as f:
    tiempos = f.readlines()

for consumo in consumos:
    info = consumo.split("|")
    node, values = info[0].strip(), info[2].split("#")
    power, timestamp = float(values[0].strip()), float(values[1].strip())
    try:
        medidas[timestamp]
    except KeyError:
        medidas[timestamp] = medida
    finally:
        medidas[timestamp][node] += power

for tiempo in tiempos:
    query, step, start, end = tuple(tiempo.split(";"))
    for item in medidas.items():
        if float(start) <= item[0] <= float(end):
            consultas[int(query)][int(step)] = sumar_medidas(
                consultas[int(query)][int(step)],
                item[1]
            )

with open("../raw_tpch/postgres/100G/consumo_consolidado-pd.csv", "w") as f:
    f.write("Consulta\tIteracion\tManager\tWorker1\tWorker2\tWorker3\n")
    for item in consultas.items():
        for iteracion in item[1].items():
            f.write("%s\t%s\t%s\t%s\t%s\t%s\n" % (
                    item[0],
                    iteracion[0],
                    iteracion[1]['159.90.9.10'] / 1e6,
                    iteracion[1]['159.90.9.11'] / 1e6,
                    iteracion[1]['159.90.9.16'] / 1e6,
                    iteracion[1]['159.90.9.13'] / 1e6
                )
            )