# Instalar el paquete 'readxls' el paquete m�s pr�ctico para leer ficheros Excel
install.packages("readr")
# Leer el paquete
library(readxl)
#Permite tranformar bases de datos 
install.packages("dplyr")
library(dplyr)
#Enrutar
setwd("C:/Users/USUARIO/Dropbox/UJAVERIANA CALI/Programacion")
datos=read_excel("Precios.xlsx")
precios = select(datos, -Fecha)
#Leer datos como serie de tiempo
precios.ts = data.frame(ts(precios, start = c(2014, 1, 2), frequency = 252))
(precios.ts)

##Gr�fica de los precios
plot(precios.ts, main=" ", col="deepskyblue", xlab="Fecha")
title(main="Precios de los Activos")

##############BANCOLOMBIA PF#################
#Correlograma (Funci�n de autocorrelaci�n)
acf(precios.ts$BANCOLOMBIA.PF)
#Valores de las autocorrelaciones
ACFB=acf(precios.ts$BANCOLOMBIA.PF, plot=FALSE)$acf
(ACFB)

###############ECOPETROL#################
#Correlograma (Funci�n de autocorrelaci�n)
acf(precios.ts$ECOPETROL)
#Valores de las autocorrelaciones
ACFE=acf(precios.ts$ECOPETROL, plot=FALSE)$acf
(ACFE)

###############ISA#################
#Correlograma (Funci�n de autocorrelaci�n)
acf(precios.ts$ISA)
#Valores de las autocorrelaciones
ACFE=acf(precios.ts$ISA, plot=FALSE)$acf
(ACFE)

###############COLCAP#################
#Correlograma (Funci�n de autocorrelaci�n)
acf(precios.ts$COLCAP)
#Valores de las autocorrelaciones
ACFE=acf(precios.ts$COLCAP, plot=FALSE)$acf
(ACFE)

#Prueba Dickey Fuller Aumentado: elimina la autocorrelaci�n e indica si una 
#serie es estacionaria o no
install.packages("tseries")
library(tseries)
adf.test(precios.ts$BANCOLOMBIA.PF)
adf.test(precios.ts$ECOPETROL)
adf.test(precios.ts$ISA)
adf.test(precios.ts$COLCAP)

##Rendimientos
precios.ts = ts(precios, start = c(2014, 1, 2), frequency = 252)
Rendimientos=diff(log(precios.ts))

##Gr�fica de los Rendimientos
plot(Rendimientos, main=" ", col="deepskyblue", xlab="Fecha")
title(main="Rendimientos del Portafolio")

#Convertir en data.frame
Rendimientos=data.frame(diff(log(precios.ts)))

#Correlograma (Funci�n de autocorrelaci�n)
acf(Rendimientos$BANCOLOMBIA.PF)
#Valores de las autocorrelaciones
ACFE=acf(Rendimientos$BANCOLOMBIA.PF, plot=FALSE)$acf
(ACFE)

##Prueba Dickey- Fuller de los Rendimientos
adf.test(Rendimientos$BANCOLOMBIA.PF)
adf.test(Rendimientos$ECOPETROL)
adf.test(Rendimientos$ISA)
adf.test(Rendimientos$COLCAP)


##Rendimientos esperados y Volatilidades
Rendesperado=c(mean(Rendimientos$BANCOLOMBIA.PF), mean(Rendimientos$ECOPETROL),
               mean(Rendimientos$ISA), mean(Rendimientos$COLCAP))
                
Volatilidad=c(sd(Rendimientos$BANCOLOMBIA.PF), sd(Rendimientos$ECOPETROL),
              sd(Rendimientos$ISA), sd(Rendimientos$COLCAP))

Resumen = data.frame (rbind(Rendesperado,Volatilidad))
colnames(Resumen)<- c("BANCOLOMBIA.PF","ECOPETROL", "ISA", "COLCAP")
Resumen*100

CV=c(sd(Rendimientos$BANCOLOMBIA.PF)/mean(Rendimientos$BANCOLOMBIA.PF), 
     sd(Rendimientos$ECOPETROL)/mean(Rendimientos$ECOPETROL),
     sd(Rendimientos$ISA)/mean(Rendimientos$ISA),
     sd(Rendimientos$COLCAP)/mean(Rendimientos$COLCAP))

Resumen = data.frame (rbind(CV))
colnames(Resumen)<- c("BANCOLOMBIA.PF","ECOPETROL", "ISA", "COLCAP")
Resumen

#Matriz de Varianza-Covarianza
Cov=cov(Rendimientos)*100
Cov

#Matriz de Correlaciones
corr = cor(Rendimientos)
corr

#�ndices Financieros
install.packages(MASS)
library(MASS)


############################################################################
##########################�NDICES FINANCIEROS###############################
############################################################################

#Betas
BCOLCAP=sd(Rendimientos$COLCAP)/sd(Rendimientos$COLCAP)*cor(Rendimientos$COLCAP,Rendimientos$COLCAP)
BBANCOLOMBIA.PF=sd(Rendimientos$BANCOLOMBIA.PF)/sd(Rendimientos$COLCAP)*cor(Rendimientos$BANCOLOMBIA.PF,Rendimientos$COLCAP)
BECOPETROL=sd(Rendimientos$ECOPETROL)/sd(Rendimientos$COLCAP)*cor(Rendimientos$ECOPETROL,Rendimientos$COLCAP)
BISA=sd(Rendimientos$ISA)/sd(Rendimientos$COLCAP)*cor(Rendimientos$ISA,Rendimientos$COLCAP)

Betas=c(BCOLCAP, BBANCOLOMBIA.PF, BECOPETROL, BISA)

Betas = data.frame (rbind(Betas))
colnames(Betas)= c("COLCAP", "BANCOLOMBIA.PF","ECOPETROL", "ISA")
Betas

##C�lculo de los Betas con Regresi�n Lineal
Regresion1 = lm(BANCOLOMBIA.PF ~ COLCAP, data = Rendimientos)
summary(Regresion1)
Regresion2 = lm(ECOPETROL ~ COLCAP, data = Rendimientos)
summary(Regresion2)
Regresion3 = lm(ISA ~ COLCAP, data = Rendimientos)
summary(Regresion3)

#�ISA ES UN T�TULO RIESGOSO?
t=(1.0020828-1)/0.0295390
gl=1865-2
pt(t, gl, lower.tail = F) 

#Revisemos los otros t�tulos
tB=(1.141669 -1)/0.022905
gl=1865-2
pt(tB, gl, lower.tail = F) 

tE=(1.371 -1)/0.03376
gl=1865-2
pt(tE, gl, lower.tail = F) 


