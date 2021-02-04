/* 1. Cuantas entradas se venden en cuantas proyecciones por cada sala */
/*Dicing*/

SELECT
sala_id,
count(pelicula_id) as proyecciones,
sum(num_entradas) as entradas
FROM
hechos
GROUP BY sala_id;

/* 2. Por cada cliente asiduo las peliculas a las que asistio y la cantidad total de entradas que compro */
/*Slicing*/
SELECT
c.nombre_cliente,
p.nombre_pelicula,
sum(num_entradas) AS entradas
FROM hechos h
JOIN cliente c ON c.cliente_id = h.cliente_id
JOIN peliculas p ON p.pelicula_id = h.pelicula_id
WHERE c.tipo_clente_id = 222
GROUP BY 1,2;

/*3.Desean saber cuáles películas les han proporcionado mayores ganancias, de tal forma que
se reporte el nombre de la película, el total de las entradas vendidas y el total de proyecciones.*/
/*Roll Up*/
SELECT
p.nombre_pelicula,
SUM(h.importe) AS ganancias,
SUM(h.num_entradas) AS entradas,
count(h.hora) AS proyecciones
FROM peliculas p, hechos h
WHERE
p.pelicula_id = h.pelicula_id
GROUP BY 1
ORDER BY 2 DESC;

/*4.Para estas películas más vendidas les gustaría saber en qué horario y sala se proyectó.*/
/*Roll Up*/
WITH T1 AS(SELECT
p.nombre_pelicula,
p.pelicula_id,
SUM(h.importe) AS ganancias
FROM peliculas p, hechos h
WHERE
p.pelicula_id = h.pelicula_id
GROUP BY 1,2
ORDER BY 3 DESC LIMIT 4)

SELECT
t1. nombre_pelicula,
t1.ganancias,
ho.hora,
s.sala_id AS sala,
t.tipo_sala_desc
FROM
T1,
horario ho,
sala s,
tipo_sala t,
hechos h
WHERE
h.pelicula_id = T1.pelicula_id
AND
h.hora = ho.hora
AND
t.tipo_sala_id = s.tipo_sala_id
AND
h.sala_id = s.sala_id
ORDER BY 2 DESC;
/*5.También se desea saber los nombres de las películas, el total de ventas de entradas, pero con
--el detalle del tipo de pago (cuantas entradas se vendieron con pago en efectivo
--y cuantas con tarjeta de crédito).*/
SELECT
p.nombre_pelicula,
h.tipo_pago_id AS tipo_pago,
SUM(h.importe) AS ventas,
SUM(h.num_entradas) AS entradas,
CASE WHEN h.tipo_pago_id='efectivo'  THEN sum(h.num_entradas)  ELSE 0 END AS entradas_efectivo,
CASE WHEN h.tipo_pago_id='tarjeta de credito '  THEN sum(h.num_entradas) ELSE 0 END AS entradas_tarjeta_credito,
CASE WHEN h.tipo_pago_id='tarjeta de debito'  THEN sum(h.num_entradas)  ELSE 0 END AS entradas_tarjeta_debito
FROM peliculas p, hechos h
WHERE
p.pelicula_id = h.pelicula_id
GROUP BY 1,2;

/* 6. Para las peliculas se desea saber en que idiona esta y que nacionalidad tiene. */
/*Slicing*/
SELECT
nombre_pelicula,
idioma,
nacionalidad
FROM
peliculas
GROUP BY pelicula_id;
