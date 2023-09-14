CREATE DATABASE tiendaComercial
USE tiendaComercial

--Tabla Empleado
CREATE TABLE empleado (
rut_empleado SERIAL PRIMARY KEY,
nombre VARCHAR(50),
apellido VARCHAR(50),
mail VARCHAR(50),
num_telefono INT,
cargo VARCHAR(50)
);

--Tabla Producto
CREATE TABLE producto (
id_producto SERIAL PRIMARY KEY,
nombre_producto VARCHAR(50),
precio INT
);

--Tabla Comuna
CREATE TABLE comuna (
id_comuna SERIAL PRIMARY KEY,
nombre_comuna VARCHAR(50),
codigo_postal INT
);

--Tabla Sueldo
CREATE TABLE sueldo (
num_liquidacion SERIAL PRIMARY KEY,
rut_empleado BIGINT REFERENCES empleado (rut_empleado),
monto_bruto INT,
monto_liquido INT
);

--Tabla Vendedor
CREATE TABLE vendedor (
rut_vendedor SERIAL PRIMARY KEY,
nombre_vendedor VARCHAR(50),
apellido_vendedor VARCHAR(50),
rut_empleado BIGINT REFERENCES empleado(rut_empleado)
);

-- Tabla tienda
CREATE TABLE tienda (
	num_tienda INT PRIMARY KEY,
	id_comuna INT REFERENCES comuna (id_comuna),
	direccion VARCHAR(50),
	alias VARCHAR(50),
);

-- Tabla tienda_empleado
CREATE TABLE tienda_empleado(
	id_tiendaempleado INT PRIMARY KEY,
	num_tienda INT REFERENCES tienda (num_tienda),
	rut_empleado SERIAL REFERENCES empleado (rut_empleado),
);

-- Tabla venta
CREATE TABLE venta (
	id_venta BIGINT PRIMARY KEY,
	monto BIGINT,
	num_tienda INT REFERENCES tienda (num_tienda),
	fecha DATE,
);

-- Tabla tipo_doc
CREATE TABLE tipo_doc (
	num_documento BIGINT PRIMARY KEY,
	tipo VARCHAR(50),
	id_venta BIGINT REFERENCES  venta (id_venta),
);
-- tabla prod_venta
CREATE TABLE prod_venta(
	id_prod_venta BIGINT PRIMARY KEY,
	id_producto SERIAL REFERENCES  producto (id_producto),
	id_venta BIGINT REFERENCES  venta (id_venta),
	rut_vendedor SERIAL REFERENCES vendedor (rut_vendedor),
);
