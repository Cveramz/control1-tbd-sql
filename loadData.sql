-- Comuna
INSERT INTO public.comuna (id_comuna, nombre_comuna, codigo_postal)VALUES 
(1, 'Santiago', 8320000),
(2, 'Viña del Mar', 2570000),
(3, 'Concepción', 4030000),
(4, 'Valparaíso', 2360000),
(5, 'La Serena', 1700000),
(6, 'Antofagasta', 1240000),
(7, 'Temuco', 4780000),
(8, 'Puerto Montt', 5480000),
(9, 'Arica', 1000000),
(10, 'Iquique', 1100000);

-- Empleado

INSERT INTO public.empleado (rut_empleado, nombre, apellido, mail, num_telefono, cargo) VALUES 
(115656611, 'Juan', 'Pérez', 'juan.perez@gmail.com', 987654321, 'Vendedor'),
(142652924, 'María', 'González', 'maria.gonzalez@hotmail.com', 987654322, 'Cajero'),
(239645337, 'Pedro', 'Sánchez', 'pedro.sanchez@outlook.com', 987654323, 'Vendedor'), 
(144793647, 'Luisa', 'López', 'luisa.lopez@gmail.com', 987654324, 'Vendedor'),
(153421559, 'Carlos', 'Torres', 'carlos.torres@hotmail.com', 987654325, 'Cajero'),
(169635663, 'Ana', 'Martínez', 'ana.martinez@outlook.com', 987654326, 'Gerente'),
(176834273, 'José', 'Rodríguez', 'jose.rodriguez@gmail.com', 987654327, 'Vendedor'),
(186546387,'Laura', 'Hernández', 'laura.hernandez@hotmail.com', 987654328, 'Cajero'),
(194465460, 'Roberto', 'López', 'roberto.lopez@outlook.com', 987654329, 'Gerente'),
(101432132, 'Isabel', 'Gómez', 'isabel.gomez@gmail.com', 987654330, 'Vendedor');

-- Sueldo

INSERT INTO public.sueldo (num_liquidacion, rut_empleado, monto_bruto, monto_liquido) VALUES 
(1, 115656611, 500000, 400000),
(2, 142652924, 450000, 360000),
(3, 239645337, 600000, 480000),
(4, 144793647, 550000, 440000),
(5, 153421559, 480000, 384000),
(6, 169635663, 520000, 416000),
(7, 176834273, 470000, 376000),
(8, 186546387, 510000, 408000),
(9, 194465460, 490000, 392000),
(10, 101432132, 530000, 424000);

--Tienda 

INSERT INTO public.tienda (num_tienda, id_comuna, direccion, alias) VALUES 
(1, 1, 'Avenida Providencia 123', 'Tienda Central'),
(2, 2, 'Calle Valparaíso 456', 'Tienda del Mar'),
(3, 3, 'Calle Concepción 789', 'Tienda del Sur'),
(4, 4, 'Avenida Santiago 101', 'Tienda Metropolitana'),
(5, 5, 'Avenida Serena 202', 'Tienda Serena'),
(6, 6, 'Calle Antofagasta 303', 'Tienda Norte'),
(7, 7, 'Avenida Temuco 404', 'Tienda Temuco'),
(8, 8, 'Calle Puerto Montt 505', 'Tienda Montt'),
(9, 9, 'Avenida Arica 606', 'Tienda Arica'),
(10, 10, 'Calle Iquique 707', 'Tienda Iquique');

--Producto

INSERT INTO public.producto (id_producto, nombre_producto, precio)VALUES 
(1, 'Smartphone Samsung Galaxy S22', 799990),
(2, 'Laptop HP Pavilion 15', 649990),
(3, 'Tablet Apple iPad Pro', 999990),
(4, 'Smart TV LG OLED 55"', 1299990),
(5, 'Cámara Sony Alpha A7III', 1999990),
(6, 'Consola de Juegos Xbox Series X', 899990),
(7, 'Auriculares Inalámbricos Bose QuietComfort 45', 49990),
(8, 'Impresora HP LaserJet Pro', 299990),
(9, 'Monitor Dell UltraSharp 27"', 399990),
(10, 'Reproductor de Blu-ray Samsung', 79990),
(11, 'Altavoces Bluetooth JBL', 69990);

-- tienda empleado

INSERT INTO public.tienda_empleado(id_tiendaempleado, num_tienda, rut_empleado) VALUES 
(1,1, 115656611),
(2,2, 142652924),
(3,3, 239645337),
(4,8, 144793647),
(5,5, 153421559),
(6,6, 169635663),
(7,8, 176834273),
(8,8, 186546387),
(9,9, 194465460),
(10,9, 101432132);

-- Vendedores
INSERT INTO public.vendedor(rut_vendedor, nombre_vendedor, apellido_vendedor, rut_empleado) VALUES
(115656611, 'Juan', 'Pérez',115656611 ),
(239645337, 'Pedro', 'Sánchez', 239645337), 
(144793647, 'Luisa', 'López',144793647 ),
(176834273, 'José', 'Rodríguez',176834273 ),
(101432132, 'Isabel', 'Gómez', 101432132);

-- venta
INSERT INTO public.venta (id_venta, monto, num_tienda, fecha) VALUES 
(1, 799990, 1, '2021-09-13'),
(2, 799990, 2, '2020-08-14'),
(3, 1299990, 3, '2022-07-15'),
(4, 299990, 4, '2023-07-16'),
(5, 1299990, 5, '2021-06-17'),
(6, 399990, 6, '2022-05-18'),
(7, 49990, 7, '2020-04-19'),
(8, 49990, 8, '2021-04-20'),
(9, 299990, 9, '2022-02-21'),
(10, 49990, 10, '2020-10-22'),
(11, 899990, 10, '2023-12-19'),
(12, 69990, 10, '2023-12-19');

-- tipo doc
INSERT INTO public.tipo_doc (num_documento, tipo, id_venta) VALUES 
(1, 'Boleta', 1),
(2, 'Boleta', 2),
(3, 'Factura', 3),
(4, 'Factura', 4),
(5, 'Boleta', 5),
(6, 'Factura', 6),
(7, 'Boleta', 7),
(8, 'Factura', 8),
(9, 'Boleta', 9),
(10, 'Factura', 10),
(11, 'Boleta', 11),
(12, 'Factura', 12);

-- prod venta 
INSERT INTO public.prod_venta (id_prod_venta, id_producto, id_venta, rut_vendedor)VALUES 
(1, 1, 1, 115656611),
(2, 2, 2, 239645337),
(3, 3, 3, 144793647),
(4, 4, 4, 176834273),
(5, 5, 5, 101432132),
(6, 1, 6, 115656611),
(7, 2, 7, 239645337),
(8, 3, 8, 144793647),
(9, 4, 9, 176834273),
(10, 5, 10, 101432132),
(11, 6, 11, 101432132),
(12,11,12, 101432132);
