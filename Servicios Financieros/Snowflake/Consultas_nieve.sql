/*Generar un reporte para saber los saldos de los grupos de cuentas
de cheques por sucursal por ciudad el ultimo dia de diciembre*/
WITH T1 AS (SELECT
fecha
FROM
dia
WHERE
date_part('month', fecha) = 12
AND
date_part('day', fecha) = 31)

SELECT
SUM(h.saldo_$)||' $' Saldo,
s.nombre_suc Grupo_desc,
c.ciudad_desc Ciudad
FROM
hechos h,
sucursal s,
ciudad c,
direccion d,
tipo_producto tp,
producto p,
cuenta cu,
T1
WHERE
h.id_sucursal = s.id_sucursal
AND
h.direccion_id = d.direccion_id
AND
d.ciudad_id = c.ciudad_id
AND
h.fecha = T1.fecha
AND
tp.tipo_producto_desc = 'Checking'
AND
p.tipo_producto_id = tp.tipo_producto_id
AND
cu.producto_id = p.producto_id
AND
h.numero_cuenta = cu.numero_cuenta
GROUP BY 2,3;

/*Generar un reporte que presente la sucursal que más cuentas de hipoteca (15,30, etc.
Cualquier tipo de Morgage) tiene en los últimos tres años.
¿Qué puede concluir, recomendar o decisión tomar a partir de esta información?*/
WITH hipotecas AS(
  SELECT numero_cuenta
  FROM
  cuenta c,
  producto p,
  tipo_producto t
  WHERE
  t.tipo_producto_desc LIKE 'Mortgage'
  AND
  p.tipo_producto_id = t.tipo_producto_id
  AND
  c.producto_id = p.producto_id
),
fechas AS (
  SELECT fecha
  FROM dia
  WHERE date_part('year',fecha)> 2016
)

SELECT
s.nombre_suc Nombre_suc,
COUNT(hipotecas.numero_cuenta) Numero_de_cuentas
FROM
sucursal s,
hechos h,
hipotecas,
fechas
WHERE
s.id_sucursal = h.id_sucursal
AND
h.numero_cuenta = hipotecas.numero_cuenta
AND
h.fecha = fechas.fecha
GROUP BY 1;

/*Generar un reporte que presente el estado que tiene mas prestamos personales
y lo desglose por ciudad.*/
WITH geografia AS(
  SELECT
  e.estado_desc,
  c.ciudad_desc,
  d.direccion_id
  FROM
  estado e,
  ciudad c,
  direccion d
  WHERE
  c.estado_id = e.estado_id
  AND
  d.ciudad_id = c.ciudad_id
),
producto AS(
  SELECT
  tp.tipo_producto_desc,
  c.numero_cuenta
  FROM
  tipo_producto tp,
  producto p,
  cuenta c
  WHERE
  tp.tipo_producto_desc = 'Personal Loan'
  AND
  p.tipo_producto_id = tp.tipo_producto_id
  AND
  c.producto_id = p.producto_id
)

SELECT
g.estado_desc  Estado_desc1,
COUNT(p.numero_cuenta) numero_de_prestamos_personales,
g.ciudad_desc ciudad
FROM
hechos h,
geografia g,
producto p
WHERE
h.direccion_id = g.direccion_id
AND
h.numero_cuenta = p.numero_cuenta
GROUP BY 1,3
ORDER BY 2 DESC
LIMIT 2;

/*Se requiere saber que cliente es el que tiene mas cuentas actualmente
 en todo el Sistema Financiero, su edad, estado civil y los ingresos que tiene.*/
 WITH t1 AS(SELECT
 c.nombre_cliente,
 tp.tipo_producto_desc,
 c.edad,
 c.genero,
 c.estadocivil estado_civil
 FROM
 hechos h,
 tipo_producto tp,
 producto p,
 cliente c,
 cuenta cu
 WHERE
 p.tipo_producto_id = tp.tipo_producto_id
 AND
 cu.producto_id = p.producto_id
 AND
 h.cliente_id = c.cliente_id
 AND
 h.numero_cuenta = cu.numero_cuenta),
 t2 AS(
 SELECT
 nombre_cliente,
 COUNT(tipo_producto_desc) as cuentas
 FROM T1
 GROUP BY 1
 ),
 t3 AS(
   SELECT
   MAX(cuentas) maxi
   FROM
   t2
 )

 SELECT
 t1.nombre_cliente,
 t1.tipo_producto_desc,
 t1.edad,
 t1.genero,
 t1.estado_civil
 FROM
 t1,t2,t3
 WHERE
 t1.nombre_cliente = t2.nombre_cliente
 AND
 t2. cuentas = t3.maxi
 ORDER BY 1;

 /*¿Cuáles son los pares de productos que por lo general tienen los clientes?*/
 WITH productos AS(
   SELECT
   p.producto_desc,
   c.numero_cuenta
   FROM producto p, cuenta c
   WHERE p.producto_id = c.producto_id
 ),

 t1 AS(SELECT
 c.nombre_cliente,
 p.producto_desc,
 COUNT(p.producto_desc) as usada
 FROM
 hechos h,
 cliente c,
 productos p
 WHERE
 h.cliente_id = c.cliente_id
 AND
 h.numero_cuenta = p.numero_cuenta
 GROUP BY 1,2),

 T2 AS(
 SELECT * , ROW_NUMBER() OVER(PARTITION BY nombre_cliente ORDER BY usada DESC) AS RN
 FROM T1 ),

 T3 AS
 (SELECT nombre_cliente,
 producto_desc  AS producto_desc1
 FROM T2
 WHERE RN=1),

 T4 AS
 (SELECT nombre_cliente,
 producto_desc as producto_desc2
 FROM T2
 WHERE RN=2)

 SELECT T3.nombre_cliente,
 T3.producto_desc1,
 T4.producto_desc2
 FROM T3,T4
 WHERE T3.nombre_cliente=T4.nombre_cliente;
