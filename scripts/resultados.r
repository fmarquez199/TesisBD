mapa_calor = function(datos, color) {
  levelplot(datos,
    col.regions = colorRampPalette(c("white", color))(100),
    aspect = "fill", 
    xlab = NULL, ylab = NULL, main = NULL,
    scales = list(x = list(rot = 0, cex = 0.7), y = list(cex = 0.8)),
    panel = function(x, y, z, ...) {
       panel.levelplot(x, y, z, ...)
       panel.text(x, y, round(z, 2), cex = 0.6, font = 2, col = "black")
    },
    par.settings = c(
      layout.heights = list(top.padding = 0, bottom.padding = 0),
      layout.widths = list(left.padding = 0, right.padding = 0)
    )
  )
}

raiz = "~/Documents/TesisCompu/"
raiz_csv = paste0(raiz, "resultados")
raiz_png = paste0(raiz, "images/")
carga = "10G"
campo = paste0("G", strsplit(carga, "G")[[1]])
csv = "integrales.csv"
sinDiseño = read.csv(paste0(raiz_csv,carga,"-SD/",csv), sep = ",")
conDiseño = read.csv(paste0(raiz_csv,carga,"-CD/",csv), sep = ",")

limits = data.frame(
  G1 = data.frame(
    t  = c(-0.7, 1.9),
    m  = c(-3.1, 0.7),
    w1 = c(-2.3, 1.5),
    w2 = c(-2.3, 1.5),
    n  = c(-1.1, 1.8)
  ),
  G2 = data.frame(
    t  = c(-0.8, 2),
    m  = c(-3.1, 1),
    w1 = c(-2.3, 2.4),
    w2 = c(-2.3, 2.4),
    n  = c(-1.1, 2.7)
  ),
  G5 = data.frame(
    t  = c(-0.7, 2.5),
    m  = c(-3.1, 1.5),
    w1 = c(-2.4, 3.3),
    w2 = c(-2.2, 3.3),
    n  = c(-1.1, 3.6)
  ),
  G10 = data.frame(
    t  = c(-0.6, 2.7),
    m  = c(-3.3, 2.1),
    w1 = c(-2.4, 3.6),
    w2 = c(-2.3, 3.3),
    n  = c(-1.1, 3.8)
  ),
  G20 = data.frame(
    t  = c(-0.6, 3.1),
    m  = c(-2.8, 4.3),
    w1 = c(-2.1, 2.7),
    w2 = c(-2.7, 2.7),
    n  = c(-1.1, 4.4)
  ),
  G50 = data.frame(
    t  = c(-0.4, 3.8),
    m  = c(-2.9, 2.6),
    w1 = c(-1.8, 3.1),
    w2 = c(-1.8, 3.1),
    n  = c(-1.6, 3.4)
  )
)

medias_tiempo = c()
sd_tiempo = c()
medias_coord = c()
medias_w1 = c()
medias_w2 = c()
sd_coord = c()
sd_w1 = c()
sd_w2 = c()

for (q in 1:22) {
  final = 30 * q
  inicio = final - 29
  medias_sd = lapply(sinDiseño[inicio:final, 3:6], mean)
  desves_sd = lapply(sinDiseño[inicio:final, 3:6], sd)
  medias_cd = lapply(conDiseño[inicio:final, 3:6], mean)
  desves_cd = lapply(conDiseño[inicio:final, 3:6], sd)
  medias_tiempo = c(medias_tiempo, medias_sd$Tiempo, medias_cd$Tiempo)
  sd_tiempo = c(sd_tiempo, desves_sd$Tiempo, desves_cd$Tiempo)
  medias_coord = c(medias_coord, medias_sd$Manager, medias_cd$Manager)
  sd_coord = c(sd_w1, desves_sd$Manager, desves_cd$Manager)
  medias_w1 = c(medias_w1, medias_sd$Worker1, medias_cd$Worker1)
  sd_w1 = c(sd_w1, desves_sd$Worker1, desves_cd$Worker1)
  medias_w2 = c(medias_w2, medias_sd$Worker2, medias_cd$Worker2)
  sd_w2 = c(sd_w2, desves_sd$Worker2, desves_cd$Worker2)
}

medias_tiempo[44] = mean(conDiseño$Tiempo[630:659])
sd_tiempo[44] = sd(conDiseño$Tiempo[630:659])
medias_coord[44] = mean(conDiseño$Manager[630:659])
sd_coord[44] = sd(conDiseño$Manager[630:659])
medias_w1[44] = mean(conDiseño$Worker1[630:659])
sd_w1[44] = sd(conDiseño$Worker1[630:659])
medias_w2[44] = mean(conDiseño$Worker2[630:659])
sd_w2[44] = sd(conDiseño$Worker2[630:659])
medias_tiempo = medias_tiempo / 1000
sd_tiempo = sd_tiempo / 1000
medias_neto = medias_coord + medias_w1 + medias_w2
sd_neto = sqrt(sd_coord ** 2 + sd_w1 ** 2 + sd_w2 ** 2)

{ # Gráfico logarítmico de tiempos
  grafico = paste0(raiz_png, "Tiempo-", carga, ".png")
  png(grafico, width = 2400, height = 1800, res = 200)
  par(mar = c(0, 4, 4, 0))
  xcoords = barplot(
    log10(medias_tiempo), ylim = limits[[paste0(campo, ".t")]], col = color,
    xlab = "Consulta", ylab = "log (Tiempo (s))", space = c(1, 0.1), las = 2,
    legend.text = c("Sin diseño", "Con diseño")#, args.legend = c(x = "topleft")
  )
  axis(3, at=xcoords, labels = n)
  mtext("Consulta", side=3, line=2)
  "prop_tiempo = log10(medias_tiempo - sd_tiempo)
  prop_tiempo = ifelse(is.na(prop_tiempo), log10(medias_tiempo), prop_tiempo)
  arrows(
    x0 = xcoords, y0 = prop_tiempo,
    x1 = xcoords, y1 = log10(medias_tiempo + sd_tiempo),
    code = 3, angle = 90, length = 0.05
  )"
  dev.off()
}

{ # Gráfico logarítmico de consumo del coordinador
  grafico = paste0(raiz_png, "Coordinador-", carga, ".png")
  png(grafico, width = 2400, height = 1800, res = 200)
  par(mar = c(0, 4, 4, 0))
  xcoords = barplot(
    log10(medias_coord), ylim = limits[[paste0(campo, ".m")]], col = color,
    xlab = "Consulta", ylab = "log (Energía (J))", space = c(1, 0.1), las = 2,
    legend.text = c("Sin diseño", "Con diseño")
  )
  axis(3, at=xcoords, labels = n)
  mtext("Consulta", side=3, line=2)
  "prop_coord = log10(medias_coord - sd_coord)
  prop_coord = ifelse(is.na(prop_coord), log10(medias_coord), prop_coord)
  arrows(
    x0 = xcoords, y0 = prop_coord,
    x1 = xcoords, y1 = log10(medias_coord + sd_coord),
    code = 3, angle = 90, length = 0.05
  )"
  dev.off()
}

{ # Gráfico logarítmico de consumo energético neto
  grafico = paste0(raiz_png, "Neto-", carga, ".png")
  png(grafico, width = 2400, height = 1800, res = 200)
  par(mar = c(0, 4, 4, 0))
  xcoords = barplot(
    log10(0.1 + medias_neto), ylim = limits[[paste0(campo, ".n")]], col = color,
    xlab = "Consulta", ylab = "log (Energía (J))", space = c(1, 0.1), las = 2,
    legend.text = c("Sin diseño", "Con diseño")#, args.legend = c(x = "topleft") 
  )
  axis(3, at=xcoords, labels = n)
  mtext("Consulta", side=3, line=2)
  "prop_neto = log10(medias_neto - sd_neto)
  prop_neto = ifelse(is.na(prop_neto), log10(medias_neto), prop_neto)
  arrows(
    x0 = xcoords, y0 = prop_neto,
    x1 = xcoords, y1 = log10(0.1 + medias_neto + sd_neto),
    code = 3, angle = 90, length = 0.05
  )"
  dev.off()
}

{ # Gráfico logarítmico de consumo energético del worker 1
  grafico = paste0(raiz_png, "Worker1-", carga, ".png")
  png(grafico, width = 2400, height = 1800, res = 200)
  par(mar = c(0, 4, 4, 0))
  xcoords = barplot(
    log10(medias_w1), ylim = limits[[paste0(campo, ".w1")]], col = color,
    xlab = "Consulta", ylab = "log (Energía (J))", space = c(1, 0.1), las = 2,
    legend.text = c("Sin diseño", "Con diseño")#, args.legend = c(x = "topleft")
  )
  axis(3, at=xcoords, labels = n)
  mtext("Consulta", side=3, line=2)
  "prop_w1 = log10(medias_w1 - sd_w1)
  prop_w1 = ifelse(is.na(prop_w1), log10(medias_w1), prop_w1)
  arrows(
    x0 = xcoords, y0 = prop_w1,
    x1 = xcoords, y1 = log10(medias_w1 + sd_w1),
    code = 3, angle = 90, length = 0.05
  )"
  dev.off()
}

{ # Gráfico logarítmico de consumo energético del worker 2
  grafico = paste0(raiz_png, "Worker2-", carga, ".png")
  png(grafico, width = 2400, height = 1800, res = 200)
  par(mar = c(0, 4, 4, 0))
  xcoords = barplot(
    log10(medias_w2), ylim = limits[[paste0(campo, ".w2")]], col = color,
    xlab = "Consulta", ylab = "log (Energía (J))", space = c(1, 0.1), las = 2,
    legend.text = c("Sin diseño", "Con diseño")#, args.legend = c(x = "topleft")
  )
  axis(3, at=xcoords, labels = n)
  mtext("Consulta", side=3, line=2)
  "prop_w2 = log10(medias_w2 - sd_w2)
  prop_w2 = ifelse(is.na(prop_w2), log10(medias_w2), prop_w2)
  arrows(
    x0 = xcoords, y0 = prop_w2,
    x1 = xcoords, y1 = log10(medias_w2 + sd_w2),
    code = 3, angle = 90, length = 0.05
  )"
  dev.off()
}

{ # Porcentajes de "mejora"
  CD = 2 * 1:22
  SD = CD - 1
  mejoras_t = read.csv(paste0(raiz, "mejorasT.csv"), header = TRUE, sep = ",")
  mejoras_n = read.csv(paste0(raiz, "mejorasN.csv"), header = TRUE, sep = ",")
  mejoras_m = read.csv(paste0(raiz, "mejorasC.csv"), header = TRUE, sep = ",")
  mejoras_1 = read.csv(paste0(raiz, "mejoras1.csv"), header = TRUE, sep = ",")
  mejoras_2 = read.csv(paste0(raiz, "mejoras2.csv"), header = TRUE, sep = ",")
  mejora_t = (medias_tiempo[SD] - medias_tiempo[CD]) / medias_tiempo[SD] * 100
  mejoras_t[[campo]] = round(mejora_t, 2)
  mejora_m = (medias_coord[SD] - medias_coord[CD]) / medias_coord[CD]
  mejoras_m[[campo]] = round(mejora_m, 2)
  mejora_n = (medias_neto[SD] - medias_neto[CD]) / medias_neto[CD] * 100
  mejoras_n[[campo]] = round(mejora_n, 2)
  mejora_1 = (medias_w1[SD] - medias_w1[CD]) / medias_w1[CD] * 100
  mejoras_1[[campo]] = round(mejora_1, 2)
  mejora_2 = (medias_w2[SD] - medias_w2[CD]) / medias_w2[CD] * 100
  mejoras_2[[campo]] = round(mejora_2, 2)
  write.csv(mejoras_t, paste0(raiz, "mejorasT.csv"), sep = ",", row.names=FALSE)
  write.csv(mejoras_n, paste0(raiz, "mejorasN.csv"), sep = ",", row.names=FALSE)
  write.csv(mejoras_m, paste0(raiz, "mejorasC.csv"), sep = ",", row.names=FALSE)
  write.csv(mejoras_1, paste0(raiz, "mejoras1.csv"), sep = ",", row.names=FALSE)
  write.csv(mejoras_2, paste0(raiz, "mejoras2.csv"), sep = ",", row.names=FALSE)
  png(paste0(raiz_png, "mejorasT.png"), width = 2400, height = 1800, res = 200)
  matriz = as.matrix(mejoras_t)
  cargas = c(1, 2, 5, 10, 20, 50)
  colnames(matriz) = cargas
  rownames(matriz) = 1:22
  mapa_calor(matriz, "darkgreen")
  dev.off()
  png(paste0(raiz_png, "mejorasN.png"), width = 2400, height = 1800, res = 200)
  matriz = as.matrix(mejoras_n)
  cargas = c(1, 2, 5, 10, 20, 50)
  colnames(matriz) = cargas
  rownames(matriz) = 1:22
  mapa_calor(matriz, "darkorange")
  dev.off()
  png(paste0(raiz_png, "mejorasM.png"), width = 2400, height = 1800, res = 200)
  matriz = as.matrix(mejoras_m)
  cargas = c(1, 2, 5, 10, 20, 50)
  colnames(matriz) = cargas
  rownames(matriz) = 1:22
  mapa_calor(matriz, "orange")
  dev.off()
  png(paste0(raiz_png, "mejoras1.png"), width = 2400, height = 1800, res = 200)
  matriz = as.matrix(mejoras_1)
  cargas = c(1, 2, 5, 10, 20, 50)
  colnames(matriz) = cargas
  rownames(matriz) = 1:22
  mapa_calor(matriz, "orange2")
  dev.off()
  png(paste0(raiz_png, "mejoras2.png"), width = 2400, height = 1800, res = 200)
  matriz = as.matrix(mejoras_2)
  cargas = c(1, 2, 5, 10, 20, 50)
  colnames(matriz) = cargas
  rownames(matriz) = 1:22
  mapa_calor(matriz, "orange3")
  dev.off()
}

{ # Pruebas estadísticas
  print("Shapiro")
  signif(sapply(sinDiseño[,3:6], function(x) shapiro.test(x)$p.value), 1)
  signif(sapply(conDiseño[,3:6], function(x) shapiro.test(x)$p.value), 1)
  print("Kendall")
  sapply(sinDiseño[,4:6], function(x)
    cor.test(sinDiseño$Tiempo, x, method = "kendall")[3:4]
  )
  cor.test(sinDiseño$Tiempo, apply(sinDiseño[,4:6], 1, sum),
    method = "kendall")[3:4]
  sapply(sinDiseño[,4:6], function(x)
    cor.test(conDiseño$Tiempo, x, method = "kendall")[3:4]
  )
  cor.test(conDiseño$Tiempo, apply(conDiseño[,4:6], 1, sum),
    method = "kendall")[3:4]
  print("Spearman")
  sapply(sinDiseño[,4:6], function(x)
    cor.test(sinDiseño$Tiempo, x, method = "spearman")[3:4]
  )
  cor.test(sinDiseño$Tiempo, apply(sinDiseño[,4:6], 1, sum),
    method = "spearman")[3:4]
  sapply(conDiseño[,4:6], function(x)
    cor.test(conDiseño$Tiempo, x, method = "spearman")[3:4]
  )
  cor.test(conDiseño$Tiempo, apply(conDiseño[,4:6], 1, sum),
    method = "spearman")[3:4]
}

{ # Gráfico de dispersión
  mainSD = "Consumo vs Tiempo (SD)"
  mainCD = "Consumo vs Tiempo (CD)"
  sub = paste(strsplit(carga, "G"), "GB")
  xlab = "Log(Tiempo (s))"
  ylab = "Log(Energía (J))"
  tSD = sinDiseño$Tiempo / 1000
  tCD = conDiseño$Tiempo / 1000
  ESD = apply(sinDiseño[,4:6], 1, sum)
  ECD = apply(conDiseño[,4:6], 1, sum)
  png(paste0(raiz_png, "Dispersión-Coordinador-", strsplit(carga, "G"), "G-SD.png"))
  plot(log10(tSD), log10(sinDiseño$Manager),
    main = mainSD, sub = paste(sub, "Coordinador"), xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Worker1-", strsplit(carga, "G"), "G-SD.png"))
  plot(log10(tSD), log10(sinDiseño$Worker1),
    main = mainSD, sub = paste(sub, "Worker 1"),
    xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Worker2-", strsplit(carga, "G"), "G-SD.png"))
  plot(log10(tSD), log10(sinDiseño$Worker2),
    main = mainSD, sub = paste(sub, "Worker 2"),
    xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Neto-", strsplit(carga, "G"), "G-SD.png"))
  plot(log10(tSD), log10(ESD),
    main = mainSD, sub = paste(sub, "Neto"),
    xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Coordinador-", strsplit(carga, "G"), "G-CD.png"))
  plot(log10(tCD), log10(conDiseño$Manager),
       main = mainCD, sub = paste(sub, "Coordinador"), xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Worker1-", strsplit(carga, "G"), "G-CD.png"))
  plot(log10(tCD), log10(conDiseño$Worker1),
       main = mainCD, sub = paste(sub, "Worker 1"),
       xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Worker2-", strsplit(carga, "G"), "G-CD.png"))
  plot(log10(tCD), log10(conDiseño$Worker2),
       main = mainCD, sub = paste(sub, "Worker 2"),
       xlab = xlab, ylab = ylab
  )
  dev.off()
  png(paste0(raiz_png, "Dispersión-Neto-", strsplit(carga, "G"), "G-CD.png"))
  plot(log10(tCD), log10(ECD),
       main = mainCD, sub = paste(sub, "Neto"),
       xlab = xlab, ylab = ylab
  )
  dev.off()
}
