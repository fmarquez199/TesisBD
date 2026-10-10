unzip ~/Downloads/<archivo>.zip -d ~ && mv ~/TPC-H\ V3.0.1 ~/TPC-H
cd ~/TPC-H/dbgen
nano makefile.suite
# En este paso se debe navegar por el archivo para encontrar las lineas:
# CC = gcc
# DATABASE = SQLSERVER
# MACHINE = LINUX
# WORKLOAD = TPCH
make -f makefile.suite