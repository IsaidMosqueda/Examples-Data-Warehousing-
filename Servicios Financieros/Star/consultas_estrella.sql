/*Generar un reporte para saber los saldos de los grupos de cuentas
de cheques por sucursal por ciudad el ultimo dia de diciembre*/

WITH T1 AS (SELECT
llave_tiempo
FROM
tiempo
WHERE
date_part('month', fecha) = 12
AND
date_part('day', fecha) = 31)

SELECT
SUM(h.saldo_$)||' $' Saldo,
o.nombre_suc Grupo_desc,
g.ciudad_desc Ciudad
FROM
hechos h JOIN geografia g
ON
h.llave_geografia = g.llave_geografia
JOIN T1
ON
h.llave_tiempo = T1.llave_tiempo
JOIN organizacion o
ON
h.llave_org = o.llave_org
JOIN producto p
ON
h.llave_producto = p.llave_producto
WHERE
tipo_producto_desc = 'Checking'

GROUP BY 2,3;

/*Generar un reporte que presente la sucursal que más cuentas de hipoteca (15,30, etc.
Cualquier tipo de Morgage) tiene en los últimos tres años.
¿Qué puede concluir, recomendar o decisión tomar a partir de esta información?*/
with m AS(
  SELECT llave_producto
  FROM
  producto
  WHERE
  tipo_producto_desc LIKE 'Mortgage'
),
 t AS(
  SELECT llave_tiempo
  FROM
  tiempo
  WHERE
  anno IN(2017,2018,2019)
)

SELECT
o.nombre_suc Nombre_suc,
COUNT(m.llave_producto) Numero_de_cuentas
FROM
hechos h,
organizacion o,
m,
t
WHERE
h.llave_producto = m.llave_producto
AND
h.llave_org = o.llave_org
AND
h.llave_tiempo = t.llave_tiempo
GROUP BY 1
ORDER BY 2 DESC;

/*Generar un reporte que presente el estado que tiene mas prestamos personales
y lo desglose por ciudad.*/
SELECT
g.estado_desc  Estado_desc1,
COUNT(p.numero_cuenta) numero_de_prestamos_personales,
g.ciudad_desc ciudad
FROM
hechos h,
geografia g,
producto p
WHERE
p.tipo_producto_desc = 'Personal Loan'
AND
h.llave_geografia = g.llave_geografia
AND
h.llave_producto = p.llave_producto
GROUP BY 1,3
ORDER BY 2 DESC
LIMIT 2;

/*Se requiere saber que cliente es el que tiene mas cuentas actualmente
 en todo el Sistema Financiero, su edad, estado civil y los ingresos que tiene.*/
WITH t1 AS(SELECT
c.nombre_cliente,
p.producto_desc,
c.edad,
c.genero,
c.estadocivil estado_civil
FROM
hechos h,
cliente c,
producto p
WHERE
h.llave_cliente = c.llave_cliente
AND
h.llave_producto = p.llave_producto),
t2 AS(
SELECT
nombre_cliente,
COUNT(producto_desc) as cuentas
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
t1.producto_desc,
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
WITH t1 AS(SELECT
c.nombre_cliente,
p.producto_desc,
COUNT(p.producto_desc) as usada
FROM
hechos h,
cliente c,
producto p
WHERE
h.llave_cliente = c.llave_cliente
AND
h.llave_producto = p.llave_producto
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
