-- Querys solicitadas (Sentencias SQL solicitadas)
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- producto más vendido por mes en 2021
SELECT 
    EXTRACT(MONTH FROM v.fecha) AS mes,
    p.nombre_producto,
    SUM(pv.id_producto) as total_ventas
FROM venta v
JOIN prod_venta pv ON v.id_venta = pv.id_venta
JOIN producto p ON pv.id_producto = p.id_producto
WHERE EXTRACT(YEAR FROM v.fecha) = 2021
GROUP BY EXTRACT(MONTH FROM v.fecha), p.nombre_producto
ORDER BY mes, total_ventas DESC
LIMIT 1;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- producto más económico por tienda

SELECT
    t.num_tienda,
    t.alias AS nombre_tienda,
    p.nombre_producto AS producto_mas_economico,
    p.precio AS precio_mas_economico
FROM
    tienda t
INNER JOIN (
    SELECT
        num_tienda,
        MIN(precio) AS precio_minimo
    FROM
        venta v
    INNER JOIN prod_venta pv ON v.id_venta = pv.id_venta
    INNER JOIN producto p ON pv.id_producto = p.id_producto
    GROUP BY
        num_tienda
) subquery ON t.num_tienda = subquery.num_tienda
INNER JOIN venta v ON t.num_tienda = v.num_tienda
INNER JOIN prod_venta pv ON v.id_venta = pv.id_venta
INNER JOIN producto p ON pv.id_producto = p.id_producto AND p.precio = subquery.precio_minimo;

/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- ventas por mes, entre boletas y facturas 

SELECT
	EXTRACT(YEAR FROM v.fecha) AS año,
    EXTRACT(MONTH FROM v.fecha) AS mes,
    SUM(CASE WHEN td.tipo = 'Boleta' THEN v.monto ELSE 0 END) AS total_boletas,
    SUM(CASE WHEN td.tipo = 'Factura' THEN v.monto ELSE 0 END) AS total_facturas
FROM
    venta v
INNER JOIN
    tipo_doc td ON v.id_venta = td.id_venta
GROUP BY
    EXTRACT(MONTH FROM v.fecha),
	EXTRACT(YEAR FROM v.fecha) 
ORDER BY
    mes;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el empleado que mas gano por tienda

SELECT
    t.num_tienda,
    t.alias AS alias_tienda,
    c.nombre_comuna,
    e.nombre,
    e.apellido,
    e.cargo,
    s.monto_liquido AS sueldo_maximo
FROM
    tienda t
JOIN
    tienda_empleado te ON t.num_tienda = te.num_tienda
JOIN
    empleado e ON te.rut_empleado = e.rut_empleado
JOIN
    comuna c ON t.id_comuna = c.id_comuna
JOIN
    sueldo s ON e.rut_empleado = s.rut_empleado
WHERE
    s.monto_liquido = (
        SELECT MAX(sueldo.monto_liquido)
        FROM sueldo
        WHERE sueldo.rut_empleado = e.rut_empleado
    )
ORDER BY
    t.num_tienda;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- la tienda que tiene menos empleados
SELECT
    t.num_tienda,
    t.alias AS nombre_tienda,
    subquery.min_cantidad_empleados AS cantidad_empleados
FROM
    tienda t
INNER JOIN (
    SELECT
        MIN(cantidad_empleados) AS min_cantidad_empleados
    FROM (
        SELECT
            num_tienda,
            COUNT(rut_empleado) AS cantidad_empleados
        FROM
            tienda_empleado
        GROUP BY
            num_tienda
    ) empleados_por_tienda
) subquery ON 1=1
INNER JOIN (
    SELECT
        num_tienda,
        COUNT(rut_empleado) AS cantidad_empleados
    FROM
        tienda_empleado
    GROUP BY
        num_tienda
) empleados_por_tienda ON t.num_tienda = empleados_por_tienda.num_tienda
WHERE
    empleados_por_tienda.cantidad_empleados = subquery.min_cantidad_empleados;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el vendedor con más ventas por mes

WITH ventas_por_mes AS (
    SELECT
        EXTRACT(YEAR FROM v.fecha) AS year,
        EXTRACT(MONTH FROM v.fecha) AS month,
        pv.rut_vendedor,
        COUNT(*) AS cantidad_ventas
    FROM
        venta v
    INNER JOIN prod_venta pv ON v.id_venta = pv.id_venta
    GROUP BY
        year, month, pv.rut_vendedor
)
SELECT
    TO_CHAR(to_date(year || '-' || month || '-01', 'YYYY-MM-DD'), 'YYYY-MM') AS fecha,
    vp.rut_vendedor,
    e.nombre AS nombre_vendedor,
    e.apellido AS apellido_vendedor,
    vp.cantidad_ventas AS ventas_por_mes
FROM
    ventas_por_mes vp
INNER JOIN empleado e ON vp.rut_vendedor = e.rut_empleado
WHERE
    (year, month, cantidad_ventas) IN (
        SELECT
            year, month, MAX(cantidad_ventas)
        FROM
            ventas_por_mes
        GROUP BY
            year, month
    );
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el vendedor que ha recaudado más dinero para la tienda por año

SELECT EXTRACT(YEAR FROM v.fecha) AS agno, t.num_tienda AS tienda, pv.rut_vendedor,
    SUM(v.monto) AS suma_montos
FROM venta v
INNER JOIN tienda t ON v.num_tienda = t.num_tienda
INNER JOIN prod_venta pv ON v.id_venta = pv.id_venta
GROUP BY EXTRACT(YEAR FROM v.fecha), t.num_tienda, pv.rut_vendedor
ORDER BY EXTRACT(YEAR FROM v.fecha), t.num_tienda, pv.rut_vendedor;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el vendedor con mas productos vendidos por tienda

WITH productos_vendidos_por_vendedor AS (
    SELECT
        t.num_tienda,
        pv.rut_vendedor,
        COUNT(pv.id_producto) AS cantidad_productos_vendidos
    FROM
        tienda t
    INNER JOIN venta v ON t.num_tienda = v.num_tienda
    INNER JOIN prod_venta pv ON v.id_venta = pv.id_venta
    GROUP BY
        t.num_tienda, pv.rut_vendedor
)
SELECT
    t.num_tienda,
    t.alias AS nombre_tienda,
    pv.rut_vendedor,
    e.nombre AS nombre_vendedor,
    e.apellido AS apellido_vendedor,
    pv.cantidad_productos_vendidos AS productos_vendidos_por_vendedor
FROM
    productos_vendidos_por_vendedor pv
INNER JOIN empleado e ON pv.rut_vendedor = e.rut_empleado
INNER JOIN tienda t ON pv.num_tienda = t.num_tienda
WHERE
    (pv.num_tienda, pv.cantidad_productos_vendidos) IN (
        SELECT
            num_tienda, MAX(cantidad_productos_vendidos)
        FROM
            productos_vendidos_por_vendedor
        GROUP BY
            num_tienda
    );
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el empleado con mayor sueldo por mes (en este caso es fijo el sueldo)

WITH sueldos_maximos AS (
    SELECT
        MAX(monto_liquido) AS maximo_sueldo_liquido
    FROM
        sueldo
)
SELECT
    empleado.rut_empleado,
    empleado.nombre,
    empleado.apellido,
    sueldo.monto_liquido AS sueldo
FROM
    sueldo
INNER JOIN empleado ON sueldo.rut_empleado = empleado.rut_empleado
INNER JOIN sueldos_maximos ON sueldo.monto_liquido = sueldos_maximos.maximo_sueldo_liquido;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- la tienda con menor recaudacion por mes

SELECT EXTRACT(MONTH FROM v.fecha) AS mes, t.num_tienda, MIN(v.monto) AS menor_monto_venta
FROM tienda t
INNER JOIN venta v ON t.num_tienda = v.num_tienda
GROUP BY EXTRACT(MONTH FROM v.fecha), t.num_tienda
ORDER BY MIN(v.monto)
LIMIT 1;
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
