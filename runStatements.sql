-- Querys solicitadas (Sentencias SQL solicitadas)
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- producto más vendido por mes en 2021
WITH MesesVentas AS (
    SELECT
        EXTRACT(MONTH FROM v.fecha) AS mes,
        p.nombre_producto AS producto_mas_vendido,
        COUNT(*) AS cantidad_vendida
    FROM
        venta v
    JOIN
        prod_venta pv ON v.id_venta = pv.id_venta
    JOIN
        producto p ON pv.id_producto = p.id_producto
    WHERE
        EXTRACT(YEAR FROM v.fecha) = 2021
    GROUP BY
        mes, p.nombre_producto
)
, RankMesesVentas AS (
    SELECT
        mes,
        producto_mas_vendido,
        cantidad_vendida,
        RANK() OVER(PARTITION BY mes ORDER BY cantidad_vendida DESC) AS ranking
    FROM
        MesesVentas
)
SELECT
    rmv.mes,
    rmv.producto_mas_vendido,
    rmv.cantidad_vendida
FROM
    RankMesesVentas rmv
WHERE
    rmv.ranking = 1
ORDER BY
    rmv.mes;
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

-- ventas por mes, entre boletas y facturas (Asumiendo que se pide las cantidades)
SELECT
    EXTRACT(YEAR FROM v.fecha) AS año,
    EXTRACT(MONTH FROM v.fecha) AS mes,
    SUM(CASE WHEN td.tipo = 'Boleta' THEN 1 ELSE 0 END) AS cantidad_boletas,
    SUM(CASE WHEN td.tipo = 'Factura' THEN 1 ELSE 0 END) AS cantidad_facturas
FROM
    venta v
INNER JOIN
    tipo_doc td ON v.id_venta = td.id_venta
GROUP BY
    EXTRACT(YEAR FROM v.fecha),
    EXTRACT(MONTH FROM v.fecha) 
ORDER BY
    año, mes;

/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */

-- el empleado que mas gano por tienda

WITH SueldosEnumerados AS (
    SELECT
        t.num_tienda,
        t.alias AS alias_tienda,
        c.nombre_comuna,
        e.nombre,
        e.apellido,
        e.cargo,
        s.monto_liquido AS sueldo_maximo,
        ROW_NUMBER() OVER (PARTITION BY t.num_tienda ORDER BY s.monto_liquido DESC) AS rn
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
)
SELECT
    num_tienda,
    alias_tienda,
    nombre_comuna,
    nombre,
    apellido,
    cargo,
    sueldo_maximo
FROM SueldosEnumerados
WHERE rn = 1
ORDER BY num_tienda;
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

WITH recaudacion_por_mes AS (
    SELECT
        t.num_tienda,
        EXTRACT(YEAR FROM v.fecha) AS año,
        EXTRACT(MONTH FROM v.fecha) AS mes,
        SUM(v.monto) AS total_recaudado
    FROM
        tienda t
    LEFT JOIN venta v ON t.num_tienda = v.num_tienda
    GROUP BY
        t.num_tienda, año, mes
),
tienda_recaudacion_minima AS (
    SELECT
        año AS min_año,
        mes AS min_mes,
        MIN(total_recaudado) AS min_recaudacion
    FROM
        recaudacion_por_mes
    GROUP BY
        año, mes
)
SELECT
    to_date(min_año || '-' || min_mes || '-01', 'YYYY-MM-DD') AS fecha,
    r.num_tienda,
    t.alias AS nombre_tienda,
    r.total_recaudado AS recaudacion_por_mes
FROM
    recaudacion_por_mes r
INNER JOIN tienda t ON r.num_tienda = t.num_tienda
INNER JOIN tienda_recaudacion_minima trm ON r.año = trm.min_año AND r.mes = trm.min_mes AND r.total_recaudado = trm.min_recaudacion;

/* -------------------------------------------------------------- */
/* -------------------------------------------------------------- */
