# 1ACC0216--TB1-2025-1

![image](https://github.com/user-attachments/assets/b47b251e-e65c-46c3-a1a4-f0c28ab554dc)

- [Universidad Peruana de Ciencias Aplicadas]

- [Curso : Fundamentos de Data Science]

- [Tema : Análisis exploratorio de un conjuntos de datos en R/RStudio]

- [Docente : Nérida Isabel Manrique Tunque]
## INTEGRANTES

- [Humberto Aesio Chumbiauca Camac]

- [Sofia Gabriel Miranda Cardenas]

- [Juan José Rodríguez Velásquez]
## OBJETIVO DEL TRABAJO

El objetivo del presente trabajo es analizar y visualizar los datos de reservas hoteleras contenidas en el dataset Hotel Booking Demand, con el propósito de identificar tendencias, comportamientos de los clientes y factores relevantes que influyen en la demanda y cancelación de reservas. A través de este análisis, se busca generar insights valiosos que apoyen la toma de decisiones estratégicas en el sector hotelero, especialmente en lo relacionado con la gestión de la ocupación, la segmentación de clientes y la planificación operativa.

## DATASET

El dataset cuenta con 32 variables que están detalladas con su nombre, tipo y descripción en la tabla 1. Estas variables describen las 40,060 reservaciones para el hotel resort y 79,330 para el hotel urbano de acuerdo con el dataset original.

Variable	Tipo	Descripción
adr	Numérico	Tasa Diaria Media.
hotel	Categórico   	Tipo de hotel (Resort o Urbano)
adults	Entero	Número de adultos.
agent	Categórico	ID de la agencia de viajes que realizó la reserva.
arrival_date_day_of_Month	Entero	Día del mes de la fecha de llegada.
arrival_date_month	Categórico	Mes de llegada con 12 categorías: “January” a “December”.
arrival_date_week_number	Entero	Número de semana de la fecha de llegada.
arrival_date_year	Entero	Año de llegada.
assigned_room_type	Categórico	Código para el tipo de habitación asignada a la reserva. 
babies	Entero	Número de bebés.
booking_changes	Entero	Número de cambios/modificaciones realizadas en la reserva.
children	Entero	Número de niños.
company	Categórico	ID de la empresa/entidad que realizó la reserva o responsable de pagar la reserva. 
country	Categórico	País de origen. 
customer_type	Categórico	Tipo de reserva, asumiendo una de cuatro categorías:
		Contrato
		Grupo
		Transitorio
		Transient-party 
days_in_waiting_list	Entero	Número de días que la reserva estaba en la lista de espera antes de que fuera confirmada al cliente.
deposit_type	Categórico	Indicación sobre si el cliente realizó un depósito para garantizar la reserva. Esta variable puede asumir tres categorías:

Sin depósito;
No reembolso;
Reembolsable.
distribution_channel	Categórico	Canal de distribución de reservas. El término “TA” significa “Travel Agents” y “TO” significa “Tour Operators”
is_canceled	Categórico	Valor que indica si la reserva fue cancelada (1) o no (0).
is_repeated_guest	Categórico	Valor que indica si el nombre de la reserva era de un huésped repetido (1) o no (0).
lead_time	Entero	Número de días transcurridos entre la fecha de entrada de la reserva en el PMS y la fecha de llegada.
market_segment	Categórico	Designación del segmento de mercado. En categorías, el término “TA” significa “Travel Agents” y “TO” significa “Tour Operators”
meal	Categórico	Tipo de comida reservada. Las categorías se presentan en paquetes estándar de comidas de hospitalidad:
		Undefined/SC – sin paquete de comidas;
		BB : Bed & Breakfast;
		HB :Media pensión (desayuno y otra comida , generalmente cena);
		FB : Pensión completa (desayuno, almuerzo y cena).
previous_bookings_not_canceled	Entero	Número de reservas anteriores no canceladas por el cliente antes de la reserva actual.
previous_cancellations	Entero	Número de reservas anteriores que fueron canceladas por el cliente antes de la reserva actual.
required_car_parking_spaces	Entero	Número de plazas de aparcamiento requeridas por el cliente
reservation_status	Categórico	Último estado de la reserva, asumiendo una de tres categorías:
		Cancelado :  reserva fue cancelada por el cliente;
		Check-Out : cliente se ha registrado pero ya se ha ido;
		No-Show : cliente no se registró e informó al hotel de la razón
reservation_status_date	Fecha	Fecha en la que se estableció el último estado. 
reserved_room_type	Categórico	Código de tipo de habitación reservado. 
stays_in_weekend_nights	Entero	Número de noches de fin de semana (Sábado o domingo) que el huésped se alojó o reservó para alojarse en el hotel.
stays_in_week_nights	Entero	Número de noches de la semana (Lunes a Viernes) que el huésped se quedó o reservó para alojarse en el hotel.
total_of_special_requests	Entero	Número de solicitudes especiales realizadas por el cliente.

