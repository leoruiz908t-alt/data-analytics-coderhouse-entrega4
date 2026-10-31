-- Pre-entrega 4.
-- Leopoldo Robelo
-- Data Analytics 2026
-- Consultas SQL de negocio.

-- =====================================
-- CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL
-- =====================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- =====================================
-- CONSULTA 2 - RANKING DE PRODUCTOS
-- =====================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- =====================================
-- CONSULTA 3 - CLIENTES RECURRENTES
-- =====================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- ==============================================
-- CONSULTA 4 - PRODUCTOS POR ENCIMA O POR DEBAJO
-- DEL PROMEDIO DE FACTURACIÓN
-- ==============================================

WITH facturacion_producto AS (

    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto

)

SELECT
    id_producto,
    total_facturado,

    CASE
        WHEN total_facturado >
        (
            SELECT AVG(total_facturado)
            FROM facturacion_producto
        )

        THEN 'Por encima'

        ELSE 'Por debajo'

    END AS comparacion_promedio

FROM facturacion_producto;


-- =====================================
-- HALLAZGOS
-- =====================================

-- Leo - Hallazgo 1:
-- El producto 1 aparece entre los productos con mayor facturación,
-- debido a su precio unitario elevado y a que se vendió más de una vez.

-- Leo - Hallazgo 2:
-- Todos los clientes registrados realizaron más de una compra,
-- por lo que pueden considerarse clientes recurrentes dentro del período analizado.

-- Leo - Hallazgo 3:
-- Todas las ventas de la base corresponden al mes de marzo de 2024,
-- por eso el resumen ejecutivo mensual devuelve un único mes.