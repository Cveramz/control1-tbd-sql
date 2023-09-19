-- Querys solicitadas (Sentencias SQL solicitadas)

-- producto más vendido por mes en 2021

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
