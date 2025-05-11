# 3. Analisis exploratorio de datos

# --------- a. Carga de datos ---------
# Limpiar la memoria
rm(list = ls(all=TRUE))
graphics.off()
cat("\014")

# Instalacion de los paquetes (necesario si no tienes las librerias)
#install.packages("dplyr")
#install.packages("lubridate")
#install.packages("readr")

# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(ggthemes)
library(hrbrthemes)
library(VIM)
library(cowplot)
library(patchwork)

# Configurar directorio raiz
setwd("C:/Users/papit/OneDrive/Desktop/DATASCIENT")
#setwd("~/Documents/datascience.temp/")

# Abrir dataset
hotel_data<-read.csv("hotel_bookings.csv",header = TRUE, stringsAsFactors = FALSE)

# --------- b. Inspeccionar los datos ---------
#visualizar las primeras filas del dataset
head(hotel_data) #visualizar primeras filas
str(hotel_data) #visualiazar la estructura y tipos de datos
summary(hotel_data) #resumen de variable numericas

dim(hotel_data) #numero de filas y columnas
names(hotel_data) #nombres de las columnas
# view(hotel_data) (ERROR POR AHORA LO QUITO)
#ordenar meses

meses_ordenados<- c("January", "February", "March", "April", "May", "June", 
                    "July", "August", "September", "October", "November", "December")

#convertir variables categoricas a factor
hotel_data$hotel<- as.factor(hotel_data$hotel)
hotel_data$reservation_status_date<-as.factor(hotel_data$reservation_status_date)
hotel_data$reservation_status<-as.factor(hotel_data$reservation_status)
hotel_data$company<-as.factor(hotel_data$company)
hotel_data$deposit_type<-as.factor(hotel_data$deposit_type)
hotel_data$assigned_room_type<-as.factor(hotel_data$assigned_room_type)
hotel_data$reserved_room_type<-as.factor(hotel_data$reserved_room_type)
hotel_data$customer_type<-as.factor(hotel_data$customer_type)
hotel_data$agent<-as.factor(hotel_data$agent)
hotel_data$country<-as.factor(hotel_data$country)
hotel_data$meal<-as.factor(hotel_data$meal)
hotel_data$market_segment<-as.factor(hotel_data$market_segment)
hotel_data$distribution_channel<-as.factor(hotel_data$distribution_channel)
hotel_data$arrival_date_month<-factor(hotel_data$arrival_date_month,
                                         levels= meses_ordenados,
                                         ordered = TRUE)

levels(hotel_data$arrival_date_month)

summary(hotel_data)

# --------- c. Pre-Procesar los datos ---------

## o Resumir Estadísticas Básicas:
# Resumen inicial del dataset (solo si se omite la anterior)
# summary(hotel_data)

## o Identificación de Datos Faltantes:
# Convertir los datos NULL a NA
hotel_data$company[hotel_data$company=="NULL"] <- NA
hotel_data$agent[hotel_data$agent=="NULL"] <- NA

# Conteo de valores NA por columna
colSums(is.na(hotel_data))
colSums(is.na(hotel_data))[colSums(is.na(hotel_data)) > 0]

## o Tratamiento de Datos Faltantes:
# Asignar categoría "Desconocido" a NA en agent y company
hotel_data$agent <- ifelse(is.na(hotel_data$agent), "Desconocido", hotel_data$agent)
hotel_data$company <- ifelse(is.na(hotel_data$company), "Desconocido", hotel_data$company)

# Convertir a factores
hotel_data$agent <- as.factor(hotel_data$agent)
hotel_data$company <- as.factor(hotel_data$company)

# Imputar NA en children con la mediana
mediana_children <- median(hotel_data$children, na.rm = TRUE)
hotel_data$children[is.na(hotel_data$children)] <- mediana_children
sum(is.na(hotel_data$children))

# Eliminar datos duplicados
sum(duplicated(hotel_data)) # Cantidad de valores duplicados
hotel_data[duplicated(hotel_data) | duplicated(hotel_data, fromLast = TRUE), ] # Visualizar
hotel_data <- hotel_data[!duplicated(hotel_data), ] # Eliminar

# Verificar resumen después de los cambios
summary(hotel_data)

## o Detectar Outliers:
# Visualización y detección de outliers para variables numéricas clave

# CHILDREN
p2 <- ggplot(hotel_data, aes(x = "", y = children)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 16, outlier.size = 3, fill = "steelblue") +   
  labs(title = "Distribución de 'Children' con Puntos Atípicos", x = "", y = "Número de niños") +
  theme_economist() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())   
p2
outliers <- boxplot(hotel_data$children, plot = FALSE)$out
length(outliers)

# BABIES
p2 <- ggplot(hotel_data, aes(x = "", y = babies)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 16, outlier.size = 3, fill = "steelblue") +   
  labs(title = "Distribución de 'Babies' con Puntos Atípicos", x = "", y = "Número de bebes") +
  theme_economist() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())   
p2
outliers <- boxplot(hotel_data$babies, plot = FALSE)$out
length(outliers)

# ADULTS
p3 <- ggplot(hotel_data, aes(x = "", y = adults)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 16, outlier.size = 3, fill = "steelblue") + 
  labs(title = "Distribución de 'Adults' con Puntos Atípicos", x = "", y = "Número de Adultos") +
  theme_economist() + theme(axis.title.x = element_blank(), axis.text.x = element_blank())   
p3
outliers <- boxplot(hotel_data$adults, plot = FALSE)$out
length(outliers)

## o Tratamiento de Outliers:
# Guardar copia original para comparación
hotel_data_original <- hotel_data

# Función para winsorizar
winsorize <- function(x, probs = c(0.05, 0.95)) {
  quantiles <- quantile(x, probs = probs, na.rm = TRUE)
  x[x < quantiles[1]] <- quantiles[1]
  x[x > quantiles[2]] <- quantiles[2]
  return(x)
}

# Detectar variables numéricas
numeric_vars <- sapply(hotel_data, is.numeric)

# Calcular outliers por variable
outliers_count <- sapply(hotel_data[, numeric_vars], function(x) {
  length(boxplot(x, plot = FALSE)$out)
})
print(outliers_count)

# Aplicar winsorización a variables con outliers
vars_to_winsorize <- names(outliers_count[outliers_count > 0])
hotel_data[vars_to_winsorize] <- lapply(hotel_data[vars_to_winsorize], winsorize)

# Visualización comparativa (antes/después) para lead_time
comparacion <- data.frame(
  Valor = c(hotel_data_original$lead_time, hotel_data$lead_time),
  Estado = rep(c("Antes", "Después"), each = nrow(hotel_data))
)

ggplot(comparacion, aes(x = Estado, y = Valor, fill = Estado)) +
  geom_boxplot(outlier.colour = "red") +
  labs(title = "Lead Time: Antes vs Después de Winsorización", y = "Lead Time", x = "") +
  theme_dark() +
  scale_fill_manual(values = c("salmon", "steelblue"))
# adults
comparacion <- data.frame(
  Valor = c(hotel_data_original$adults, hotel_data$adults),
  Estado = rep(c("Antes", "Después"), each = nrow(hotel_data))
)

ggplot(comparacion, aes(x = Estado, y = Valor, fill = Estado)) +
  geom_boxplot(outlier.colour = "red") +
  labs(title = "Adults: Antes vs Después de Winsorización", y = "Adultos", x = "") +
  theme_dark() +
  scale_fill_manual(values = c("salmon", "steelblue"))
# children
comparacion <- data.frame(
  Valor = c(hotel_data_original$children, hotel_data$children),
  Estado = rep(c("Antes", "Después"), each = nrow(hotel_data))
)

ggplot(comparacion, aes(x = Estado, y = Valor, fill = Estado)) +
  geom_boxplot(outlier.colour = "red") +
  labs(title = "Children: Antes vs Después de Winsorización", y = "Niños", x = "") +
  theme_dark() +
  scale_fill_manual(values = c("salmon", "steelblue"))
# babies
comparacion <- data.frame(
  Valor = c(hotel_data_original$babies, hotel_data$babies),
  Estado = rep(c("Antes", "Después"), each = nrow(hotel_data))
)

ggplot(comparacion, aes(x = Estado, y = Valor, fill = Estado)) +
  geom_boxplot(outlier.colour = "red") +
  labs(title = "Babies: Antes vs Después de Winsorización", y = "Bebes", x = "") +
  theme_dark() +
  scale_fill_manual(values = c("salmon", "steelblue"))
## Guardar el archivo para realizar el siguiente paso
write.csv(hotel_data, "hotel_data_limpio.csv", row.names = FALSE)

#VISUALIZACION DE DATOS [PREGUNTAS]

#Limpiamos entorno
rm(list = ls(all=TRUE))
graphics.off()
cat("\014")

# Cargar librerías necesarias
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)

# 1. Cargar y explorar los datos
hotel_data <- read.csv('hotel_data_limpio.csv',header = TRUE, stringsAsFactors = FALSE)

# Convertir 'hotel' a factor
hotel_data$hotel <- factor(hotel_data$hotel, levels = c('City Hotel', 'Resort Hotel'))

# Ver las primeras filas y estructura
head(hotel_data)
str(hotel_data)
summary(hotel_data)

# 2. Reservas por tipo de hotel
reservas_por_hotel <- hotel_data %>%
  group_by(hotel) %>%
  summarise(reservas = n()) %>%
  mutate(porcentaje = (reservas / sum(reservas)) * 100)

print(reservas_por_hotel)

# Usando 'table()' para contar reservas por tipo de hotel
reservas_por_hotel <- table(hotel_data$hotel)
print(reservas_por_hotel)

# Convertir a data frame para el gráfico
reservas_por_hotel_df <- as.data.frame(reservas_por_hotel)
colnames(reservas_por_hotel_df) <- c('Hotel', 'Reservas')

# Graficar la preferencia de tipo de hotel
ggplot(reservas_por_hotel_df, aes(x = Hotel, y = Reservas, fill = Hotel)) +
  geom_bar(stat = 'identity') +
  labs(title = 'Reservas por Tipo de Hotel', x = 'Tipo de Hotel', y = 'Número de Reservas') +
  theme_minimal()

# 3. Evolución de la demanda

# Crear una columna combinada de año y mes
hotel_data <- hotel_data %>%
  mutate(year_month = paste(arrival_date_year, arrival_date_month, sep = '-')) %>%
  mutate(year_month = ym(year_month))

# Contar reservas por mes
reservas_mensuales <- hotel_data %>%
  group_by(year_month) %>%
  summarise(reservas = n())
print(reservas_mensuales, n = 100)

# Graficar la evolución de la demanda
ggplot(reservas_mensuales, aes(x = year_month, y = reservas)) +
  geom_line(color = 'blue') +
  labs(title = 'Evolución de la Demanda de Reservas',
       x = 'Fecha',
       y = 'Número de Reservas') +
  theme_minimal()

# 4. Temporadas de reservas
# Definir los rangos de temporada
temporadas <- hotel_data %>%
  group_by(arrival_date_month) %>%
  summarise(reservas = n()) %>%
  arrange(desc(reservas))

print(temporadas)
mean(temporadas$reservas)
summary(temporadas$reservas)

# Graficar las temporadas de reservas
ggplot(temporadas, aes(x = arrival_date_month, y = reservas, fill = arrival_date_month)) +
  geom_bar(stat = 'identity') + 
  labs(title = 'Temporadas de Reservas por Mes',
       x = 'Mes de Llegada',
       y = 'Número de Reservas') +
  scale_x_discrete(limits = c('January', 'February', 'March', 'April', 'May', 'June', 
                              'July', 'August', 'September', 'October', 'November', 'December')) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Definir las temporadas
temporadas <- temporadas %>%
  mutate(temporada = case_when(
    arrival_date_month %in% c('July', 'August') ~ "Alta",
    arrival_date_month %in% c('March', 'April', 'May', 'September', 'October', 'June') ~ "Media",
    TRUE ~ "Baja"
  ))

# Graficar las temporadas de reservas con las temporadas diferenciadas
ggplot(temporadas, aes(x = arrival_date_month, y = reservas, fill = temporada)) +
  geom_bar(stat = 'identity') + 
  labs(title = 'Reservas por Mes con Temporadas',
       x = 'Mes de Llegada',
       y = 'Número de Reservas',
       fill = 'Temporada') +
  scale_x_discrete(limits = c('January', 'February', 'March', 'April', 'May', 'June', 
                              'July', 'August', 'September', 'October', 'November', 'December')) +
  scale_fill_manual(values = c("Baja" = "#87CEEB",   # Azul claro
                               "Media" = "#FFD700",   # Dorado
                               "Alta" = "#FF6347")) + # Rojo tomate
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# 5. Duración promedio de estancias
duracion_estancias <- hotel_data %>%
  mutate(total_nights = stays_in_weekend_nights + stays_in_week_nights) %>%
  group_by(hotel) %>%
  summarise(duracion_promedio = mean(total_nights))

print(duracion_estancias)

# Graficar duración promedio de estancias

ggplot(duracion_estancias, aes(x = hotel, y = duracion_promedio, fill = hotel)) +
  geom_bar(stat = 'identity') +
  labs(title = 'Duración promedio de estancias', x = 'Tipo de Hotel', y = 'Noches') +
  theme_minimal()

# 6. Reservas con niños y bebés
reservas_con_ninos <- hotel_data %>%
  filter(children > 0 | babies > 0) %>%
  summarise(reservas_con_ninos = n())

print(reservas_con_ninos)

# 7. Importancia del estacionamiento
estacionamiento <- hotel_data %>%
  summarise(con_estacionamiento = sum(required_car_parking_spaces > 0),
            sin_estacionamiento = sum(required_car_parking_spaces == 0))

print(estacionamiento)

# Creación del data frame para el gráfico
condicion <- c('Con estacionamiento', 'Sin estacionamiento')
cant_reservas <- c(estacionamiento$con_estacionamiento, estacionamiento$sin_estacionamiento)
importancia_data <-data.frame(condicion, cant_reservas)

# Gráfico de la importancia del estacionamiento
ggplot(importancia_data, aes(x = condicion, y = cant_reservas, fill = condicion)) +
  geom_bar(stat = 'identity') +
  labs(title = 'Importancia del estacionamiento', x = 'Condición', y = 'Cantidad de reservas') +
  theme_minimal()

# 8. Meses con más cancelaciones
cancelaciones <- hotel_data %>%
  filter(is_canceled == 1) %>%
  group_by(arrival_date_month) %>%
  summarise(cancelaciones = n()) %>%
  arrange(desc(cancelaciones))

print(cancelaciones)
mean(cancelaciones$cancelaciones)
summary(cancelaciones$cancelaciones)

# Calcular el tercer cuartil
q3_cancelaciones <- quantile(cancelaciones$cancelaciones, 0.75)

# Identificar meses con cancelaciones altas
cancelaciones <- cancelaciones %>%
  mutate(es_alta = ifelse(cancelaciones >= q3_cancelaciones, "Alta", "No Alta"))


ggplot(cancelaciones, aes(x = arrival_date_month, y = cancelaciones, fill = es_alta)) +
  geom_col() +
  labs(title = 'Cancelaciones por Mes - Identificación de Meses con Cancelaciones Altas',
       x = 'Mes',
       y = 'Número de Cancelaciones',
       fill = 'Cancelación') +
  scale_x_discrete(limits = c('January', 'February', 'March', 'April', 'May', 'June', 
                              'July', 'August', 'September', 'October', 'November', 'December')) +
  scale_fill_manual(values = c("Alta" = "#FF6347", "No Alta" = "#87CEEB")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#PREGUNTA GRUPAL
# Top 10 países con más reservas
top_countries <- hotel_data %>%
  count(country, sort = TRUE) %>%
  top_n(10)

# Imprimir en consola los países y sus cantidades
print(top_countries)

ggplot(top_countries, aes(x = reorder(country, n), y = n, fill = country)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = n), hjust = -0.2, color = "white", size = 4) +
  coord_flip() +
  labs(title = "Top 10 países de origen de los huéspedes",
       x = "País",
       y = "Número de reservas") +
  theme_dark() +
  ylim(0, max(top_countries$n) * 1.1) 

