-- Pre-entrega 5
-- Leopoldo Robelo.
-- Data Analytics
-- Consultas con JOINs para el proyecto


-- =====================================
-- Consulta 1: Vista base del proyecto
-- Propósito:
-- Obtener una vista completa de las ventas junto con los datos
-- de clientes, productos y categorías.
-- =====================================

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta

FROM ventas v

INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente

INNER JOIN productos p
    ON v.id_producto = p.id_producto

INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo:
-- La consulta permite ver toda la información relevante de una venta
-- en una sola fila, facilitando futuros análisis en Power BI.



-- =====================================
-- Consulta 2: Clientes sin ventas
-- Propósito:
-- Detectar clientes registrados que nunca realizaron compras.
-- =====================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro

FROM clientes c

LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente

WHERE v.id_cliente IS NULL;

-- Hallazgo:
-- No se encontraron clientes sin ventas.
-- Todos los clientes registrados realizaron al menos una compra.



-- =====================================
-- Consulta 3: Productos sin ventas
-- Propósito:
-- Identificar productos del catálogo sin movimiento.
-- =====================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio

FROM productos p

LEFT JOIN ventas v
    ON p.id_producto = v.id_producto

INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria

WHERE v.id_producto IS NULL;

-- Hallazgo:
-- No se encontraron productos sin ventas.
-- Todo el catálogo tuvo movimiento durante el período analizado.



-- =====================================
-- Consulta 4: Consolidado por canal
-- Propósito:
-- Comparar ventas simulando dos canales de venta.
-- =====================================

SELECT
    canal,
    SUM(total) AS total_canal

FROM (

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Online' AS canal
    FROM ventas
    WHERE id_cliente <= 3

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE id_cliente > 3

) AS consolidado

GROUP BY canal;

-- Hallazgo:
-- El resultado permite comparar rápidamente la facturación
-- entre los dos canales definidos para el análisis.



-- =====================================
-- Comentario final
-- =====================================

-- Leo:
-- Los JOINs permiten conectar la información de distintas tablas
-- para obtener una visión más completa del negocio.
-- Con este tipo de consultas se puede analizar clientes,
-- productos y ventas de forma integrada.