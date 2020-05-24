
source('~/Dropbox/Segregación/FuncionesAuxiliares.R')

Calcula <- function( datos ){
  serie <- datos[,3] - min(datos[,3])
  return (sd(serie))
}


metros <- 500 #Recordar que un grado son 111kms aprox()
ciudades <- 50

#load("VariacionTopograficas.dat")
#datosVariaciones <- rbind(datosVariaciones, matrix(0,10,1)) #Se agregan filas

for (ciudad in 40:ciudades ){
  
  
  ptos <- retornaPuntos(ciudad, metros) ##Esta funciÃ³n retorna los puntos necesarios para calcular
  nroPuntos <- nrow(ptos)
  datos <- matrix(0, nroPuntos, 3)
  veces <- ceiling(nroPuntos / 50)
  
  for (i in 1:veces){
    de <- (i - 1) * 50 + 1
    ha <- 50 * i
    if (ha > nroPuntos){
      ha <- nroPuntos
    }
    maux <- ptos[de:ha,]
    res <- googEl(maux)
    datos[de:ha,1] <- unlist(res[,1])
    datos[de:ha,2] <- unlist(res[,2])
    datos[de:ha,3] <- unlist(res[,3])
  }
  
  datosVariaciones[ciudad] <- Calcula(datos)
}
#res <- googEl(m)

save(datosVariaciones, file="VariacionTopograficas.dat")
