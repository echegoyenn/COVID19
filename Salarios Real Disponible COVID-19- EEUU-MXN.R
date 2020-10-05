library(tidyverse)
library(dplyr)
library(plotly)
library(streamgraph)
install.packages('devtools')
devtools::install_github('bbc/bbplot')
if(!require(pacman))install.packages("pacman")

pacman::p_load('dplyr', 'tidyr', 'gapminder',
               'ggplot2',  'ggalt',
               'forcats', 'R.utils', 'png', 
               'grid', 'ggpubr', 'scales',
               'bbplot')
devtools::install_github("hrbrmstr/streamgraph")
options(scipen=999) 
#------------DATOS ETOE----------
ETOE_INEGI <-read.csv("Empleo/ETOE_mar-juni20.csv", header = TRUE)
ETOE_INEGI <- na.omit(ETOE_INEGI)
#Creamos un salario mínimo mensual con base INEGI (NACIONAL)
smm <- 3746
#Creamos variables de impuestos para hacer ISR semanal.
isr_1 <- 0.0640
isr_2 <- 0.1088
isr_3 <- 0.1792
isr_4 <- 0.30
#Creamos las variables de ingreso mensual disponible a través
#del total de personas empleadas en un nivel de salarios 1-5 entre inflación
ETOE_INEGI <- ETOE_INEGI %>%
        mutate(sal_1 = ((Ysm1 * smm))/2.985) %>%
        mutate(sal_1a2 = (Ysm1a2 * (smm*1.5))/2.985) %>%
        mutate(sal_2a3 = (Ysm2a3 * (smm*2.5))/2.985) %>%
        mutate(sal_3a5 = (Ysm3a5 * (smm*4))/2.985) %>%
        mutate(sal_m5 = (Ysm5 * (smm * 5))/2.985)
#Hacemos los ingresos mensuales de forma disponible a través
#de los taxes
ETOE_INEGI <- ETOE_INEGI %>%
        mutate(SRD_1  = (sal_1 * (1 -  isr_1)/1000000000)) %>%
        mutate(SRD1a2 = (sal_1a2 * (1 - isr_2)/1000000000)) %>%
        mutate(SRD2a3 = (sal_2a3 * (1 -  isr_3)/1000000000)) %>%
        mutate(SRD3a5 =(sal_3a5 * (1 - isr_3)/1000000000)) %>%
        mutate(SRD5 = (sal_m5 * (1 - isr_4)/1000000000))
        
glimpse(ETOE_INEGI)
str(ETOE_INEGI)
#Reordenamos para poner columnas como renglones en a fin
#de tener la base paralela
ETOE_INEGI <- gather(ETOE_INEGI,
                     key = "Salario bracket",
                     value = "Salario mínimo mensual",
                     SRD_1,
                     SRD1a2,
                     SRD2a3,
                     SRD3a5,
                     SRD5)

glimpse(ETOE_INEGI)
#Guardamos cambios en csv original
#fwrite(ETOE_INEGI, 'Empleo/ETOE_mar-juni.csv')
#creamos df
mes <- unique(ETOE_INEGI$Mes)
mes <- factor(mes, levels = c("mar-20","abr-20",
                             "may-20", "jun-20"))
salariobr <- unique(ETOE_INEGI$`Salario bracket`)
salariobr <- as.factor(salariobr)
smm <- unique(ETOE_INEGI$`Salario mínimo mensual`)
ETOE_df <- data.frame(mes,
                      salariobr,
                      smm
                      )
#hacemos media por periodo
str(ETOE_df)
#Filtamos la información de tipos de salario en salario obr 
etoe_pl <- ETOE_df %>%
        filter(salariobr %in% c("Salario_realD_1", "Salario_realD_1a2", "Salario_realD_2a3",
                           "Salario_realD_3a5","Salario_realD_m5"))

#Hacemos gráfica EXCELENTE
etoe_pl <- ggplot(ETOE_df, aes(x = mes, y = smm, group = salariobr, colour = salariobr, sort = FALSE)) +
        geom_line(size = 2) +
        geom_vline(xintercept = 2, size = 1)+
        geom_hline(yintercept = mean(smm), size = 1, colour="#333333", linetype = "dashed") +
        scale_colour_manual(values = c("#FAAB18", 
                                       "#1380A1", 
                                       "#990000", 
                                       "#588300", 
                                       "#A569BD")) +
        bbc_style() +
        labs(title="≈ Salario Real Disponible México",
             subtitle = "Cifras en miles de millones de pesos")
etoe_pl
#Guardamos la gráfica con nuestra info y datos extra.
finalise_plot(plot_name = etoe_pl,
              source = "Fuente: INEGI | Elaboración propia",
              save_filepath = "SM.png",
              width_pixels = 640,
              height_pixels = 450,
              logo_image_path = "90px-Economia_escudo.png")

mesmean <- with(ETOE_df, tapply(smm, mes, mean))
class(mes)

#Comparación con gringolandia-----------------------
etoe_mean <- ETOE_df %>%
        group_by(mes) %>%
        dplyr::summarize(media = mean(smm, na.rm=TRUE))

etoe_mean <- etoe_mean %>%
        mutate( mxfx = (media*0.046))
gringolandia <- c(14949.3,
                  17259.4,
                  16397.9,
                  16070.5
                  )
#PODEMOS copiar esta data y rescribirla en el csv de
#fwrite(comparación, file = "Empleo/gringolandia.csv")
#Cargamos data
comparación <- read_csv("Empleo/MXUS.csv")
#Pasamos los billones usd a miles de millones usd
comparación <- comparación %>%
        mutate(EEUU = (EEUU * 1000))
glimpse(comparación)
glimpse(comparación)
#Reordenamos para poner columnas en renglones y renombramos
#para no confundir variables
comp <- gather(comparación,
                     key = "Nación",
                     value = "Salario Real Disponible",
                     MX,
                     EEUU,
                     )%>%
        rename( Month = mes)
#Guardamos variables para proximo ploteo
intsal <- unique(comp$`Salario Real Disponible`)
month <- unique(comp$Month)
month <- factor(comp$Month, levels = c("mar-20","abr-20",
                              "may-20", "jun-20"))
#Hacemos la gráfica pero en formato de log10 para estandarizar.
comp_pl <- ggplot(comp, aes(x = month, y = intsal, group = Nación, colour = Nación, sort = FALSE)) +
        scale_y_log10()+
        geom_vline(xintercept = "abr-20", size = 1, linetype = "dashed") +
        geom_line(size = 2) +
        geom_hline(yintercept = mean(smm), size = 1, colour="#333333", linetype = "dashed") +
        scale_colour_manual(values = c("#FAAB18", 
                                       "#1380A1" 
                                       )) +
        bbc_style() +
        labs(title="≈ Personal Real Disposable income
between countries EEUU-MX",
             subtitle = "LogScaleThousands of millions USD currency")
#Guardamos la gráfica entre países 
finalise_plot(plot_name = comp_pl,
              source = "Fuente: INEGI & FRED |Elaboración propia",
              save_filepath = "PersonalRealBtw.png",
              width_pixels = 640,
              height_pixels = 450,
              logo_image_path = "90px-Economia_escudo.png")
