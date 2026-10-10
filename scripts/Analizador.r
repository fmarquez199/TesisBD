resumen_df_tabular <- function(df) {
  # 1. Seleccionar solo columnas numéricas
  df_numerico <- df[sapply(df, is.numeric)]
  
  if (ncol(df_numerico) == 0) {
    stop("No hay columnas numéricas en el data frame proporcionado.")
  }
  
  # 2. Definir las estadísticas a calcular
  estadisticas <- c("Min.", "1st Qu.", "Median", "Mean", "3rd Qu.", "Max.", "Desv.Est")
  
  # 3. Calcular todas las estadísticas para cada columna usando sapply
  resultados_list <- sapply(df_numerico, function(columna) {
    resumen_base <- summary(columna)
    sd_valor <- sd(columna, na.rm = TRUE)
    
    # Combinar y nombrar los resultados como un vector
    todas_stats <- c(resumen_base[1:6], "Desv.Est" = sd_valor)
    return(todas_stats)
  })
  
  # 4. Convertir la matriz resultante en un data frame y formatear
  # R crea una matriz donde las filas son las estadísticas y las columnas son las variables
  df_final <- as.data.frame(resultados_list)
  
  # Opcional: Redondear los números para una mejor presentación visual
  df_final <- round(df_final, 2)
  
  # Devolver el data frame final formateado
  return(df_final)
}

# sin_diseno <- read.csv("consolidado_sin_diseño.csv")
# con_diseno <- read.csv("consolidado_con_diseño.csv")
sin_diseno = g1
tiempos_totales = c()
manager_totales = c()
worker1_totales = c()
worker2_totales = c()
total_totales = c()
for (i in seq(22)) {
  head = 1 + (i - 1) * 30
  last = 30 + (i - 1) * 30
  t  = sin_diseno$Tiempo[head:last] / 1000
  m  = sin_diseno$Manager[head:last]
  w1 = sin_diseno$Worker1[head:last]
  w2 = sin_diseno$Worker2[head:last]
  # w3 = sin_diseno$Worker3[head:last]
  consulta = data.frame(
    Tiempo = t,
    Manager = m ** 2 * t / (m + w1 + w2),
    Worker1 = w1 ** 2 * t / (m + w1 + w2),
    Worker2 = w2 ** 2 * t / (m + w1 + w2),
    Total = t * (m ** 2 + w1 ** 2 + w2 ** 2) / (m + w1 + w2)
  )
  print(paste("Consulta (sin diseño)", toString(i)))
  print(consulta)
  print("Descriptiva - consulta (sin diseño)", toString(i))
  print(resumen_df_tabular(consulta))
  print(shapiro.test(consulta$Tiempo))
  print(shapiro.test(consulta$Manager))
  print(cor.test(consulta$Tiempo, consulta$Manager, method = "kendall"))
  print(cor.test(consulta$Tiempo, consulta$Manager, method = "spearm"))
  print(shapiro.test(consulta$Worker1))
  print(cor.test(consulta$Tiempo, consulta$Worker1, method = "kendall"))
  print(cor.test(consulta$Tiempo, consulta$Worker1, method = "spearm"))
  print(shapiro.test(consulta$Worker2))
  print(cor.test(consulta$Tiempo, consulta$Worker2, method = "kendall"))
  print(cor.test(consulta$Tiempo, consulta$Worker2, method = "spearm"))
  print(shapiro.test(consulta$Total))
  print(cor.test(consulta$Tiempo, consulta$Total, method = "kendall"))
  print(cor.test(consulta$Tiempo, consulta$Total, method = "spearm"))
  png(paste0("~/Documents/TesisCompu/images/Em vs t (SD)-Q", toString(i), ".png"),
  width = 2400, height = 1800, res = 200)
  plot(consulta$Tiempo, consulta$Manager,
       main = "Energía (Manager) vs t",
       sub = paste("Consulta", toString(i), "(sin diseño)"),
       xlab = "Tiempo (s)",
       ylab = "Energía (J)"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Ew1 vs t (SD)-Q", toString(i), ".png"),
  width = 2400, height = 1800, res = 200)
  plot(consulta$Tiempo, consulta$Worker1,
       main = "Energía (Worker 1) vs t",
       sub = paste("Consulta", toString(i), "(sin diseño)"),
       xlab = "Tiempo (s)",
       ylab = "Energía (J)"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Ew2 vs t (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  plot(consulta$Tiempo, consulta$Worker2,
       main = "Energía (Worker 2) vs t",
       sub = paste("Consulta", toString(i), "(sin diseño)"),
       xlab = "Tiempo (s)",
       ylab = "Energía (J)"
  )
  dev.off()
  png(paste0(" ~/Documents/TesisCompu/images/Ew3 vs t (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  plot(consulta$Tiempo, consulta$Total,
       main = "Energía (Total) vs t",
       sub = paste("Consulta", toString(i), "(sin diseño)"),
       xlab = "Tiempo (s)",
       ylab = "Energía (J)"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Hist-tiempo (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 2000)
  hist(consulta$Tiempo,
       main = "Tiempo",
       sub = paste("Consulta", toString(i), "sin diseño"),
       xlab = "Tiempos (s)",
       ylab = "Frecuencia"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Hist-Em (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  hist(consulta$Manager,
       main = "Energía (manager)",
       sub = paste("Consulta", toString(i), "sin diseño"),
       xlab = "Energía (J)",
       ylab = "Frecuencia"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Hist-Ew1 (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  hist(consulta$Worker1,
       main = "Energía (worker 1)",
       sub = paste("Consulta", toString(i), "sin diseño"),
       xlab = "Energía (J)",
       ylab = "Frecuencia"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Hist-Ew2 (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  hist(consulta$Worker2,
       main = "Energía (worker 2)",
       sub = paste("Consulta", toString(i), "sin diseño"),
       xlab = "Energía (J)",
       ylab = "Frecuencia"
  )
  dev.off()
  png(paste0("~/Documents/TesisCompu/images/Hist-Ew3 (SD)-Q", toString(i), ".png"),
      width = 2400, height = 1800, res = 200)
  hist(consulta$Total,
       main = "Energía (total)",
       sub = paste("Consulta", toString(i), "sin diseño"),
       xlab = "Energía (J)",
       ylab = "Frecuencia"
  )
  dev.off()
  tiempos_totales = c(tiempos_totales, sum(consulta$Tiempo))
  manager_totales = c(manager_totales, sum(consulta$Manager))
  worker1_totales = c(worker1_totales, sum(consulta$Worker1))
  worker2_totales = c(worker2_totales, sum(consulta$Worker2))
  total_totales = c(total_totales, sum(consulta$Total))
  readline(prompt = "Pulse Enter para continuar")
}
# png("~/Documents/TesisCompu/images/Tiempo total (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(tiempos_totales,
        names.arg = seq(22),
        main = "Tiempo total",
        xlab = "Consultas",
        ylab = "Tiempo (s)"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Manager total (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(manager_totales),
        names.arg = seq(22),
        main = "log(Energía) (Manager) total",
        xlab = "Consultas",
        ylab = "log(Energía (J))"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 1 total (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(worker1_totales),
        names.arg = seq(22),
        main = "log(Energía) (Worker 1) total",
        xlab = "Consultas",
        ylab = "log(Energía (J))"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 2 total (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(worker2_totales),
        names.arg = seq(22),
        main = "log(Energía) (Worker 2) total",
        xlab = "Consultas",
        ylab = "log(Energía (J))")
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 3 total (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(total_totales),
        names.arg = seq(22),
        main = "log(Energía) (Total) total",
        xlab = "Consultas",
        ylab = "log(Energía (J))"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Tiempo promedio (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(tiempos_totales / 30,
        names.arg = seq(22),
        main = "Tiempo promedio",
        xlab = "Consultas",
        ylab = "Tiempo (s)"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Manager promedio (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(manager_totales / 30),
        names.arg = seq(22),
        main = "log(Energía promedio) (Manager)",
        xlab = "Consultas",
        ylab = "log(Energía (J))"
)
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 1 promedio (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(worker1_totales / 30),
        names.arg = seq(22),
        main = "log(Energía promedio) (Worker 1)",
        xlab = "Consultas",
        ylab = "log(Energía (J))")
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 2 promedio (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(worker2_totales / 30),
        names.arg = seq(22),
        main = "log(Energía promedio) (Worker 2)",
        xlab = "Consultas",
        ylab = "log(Energía (J))")
# dev.off()
# png("~/Documents/TesisCompu/images/Worker 3 promedio (SD).png",
#     width = 2400, height = 1800, res = 200)
barplot(log10(total_totales / 30),
        names.arg = seq(22),
        main = "log(Energía promedio) (Total)",
        xlab = "Consultas",
        ylab = "log(Energía (J))")
# dev.off()
# boxplot(tiempos_totales, main = "Tiempos")
# boxplot(manager_totales)
# boxplot(worker1_totales)
# boxplot(worker2_totales)
# boxplot(worker3_totales)
