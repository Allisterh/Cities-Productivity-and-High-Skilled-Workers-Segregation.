#Funciones Auxiliares
require(XLConnect)
require(SDMTools)

googEl <- function(locs)  {
  require(RJSONIO)
  locstring <- paste(do.call(paste, list(locs[, 2], locs[, 1], sep=',')),
                     collapse='|')
  u <- sprintf('http://maps.googleapis.com/maps/api/elevation/json?locations=%s&sensor=false',
               locstring)
  res <- fromJSON(u)
  out <- t(sapply(res[[1]], function(x) {
    c(x[['location']]['lat'], x[['location']]['lng'], 
      x['elevation'], x['resolution']) 
  }))    
  rownames(out) <- rownames(locs)
  return(out)
}

pasos <- function(d, h, metros) {
  distanciaPasos <- metros / 111000
  
  minimo <- min(d,h)
  maximo <- max(d,h)
  distancia <- maximo - minimo
  numeroPasos <- distancia / distanciaPasos
  res <- matrix(0,numeroPasos,1)
  
  for (i in 1:numeroPasos){
    res[i] <- minimo + (i - 1) * distanciaPasos    
  }
  return(res)
}


retornaPuntos <- function( ciudad, metros ){
  distanciaPasos <- metros / 111000
  
  wb  <-loadWorkbook("Ciudades.xlsx")
  col <- ciudad * 2 
  numFilas <- readWorksheet(wb,sheet="Coordenadas", startRow=2, startCol=(col-1), endRow=2, endCol=(col-1), header=FALSE)
  coord <- readWorksheet(wb,sheet="Coordenadas", startRow=3, startCol=(col-1), endRow=numFilas, endCol=col , header=FALSE)
  maxy <- max(coord[,1])
  miny <- min(coord[,1])
  maxx <- max(coord[,2])
  minx <- min(coord[,2])
  
  
  #define the points and polygon
  pnts = expand.grid(x=seq(miny,maxy,distanciaPasos),y=seq(minx,maxx,distanciaPasos))
  polypnts <- coord
  names(pnts)<-c("Y","X")
  names(polypnts) <- c("Y","X")
  
  out = pnt.in.poly(pnts,polypnts)
  return(out[which(out$pip==1),1:2])
  
}





