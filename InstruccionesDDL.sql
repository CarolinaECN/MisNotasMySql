## --CREANDO LA BASE DE DATOS  

CREATE DATABASE dbTemporal;
USE dbTemporal; # para indicar que voy a trabajar aqui

############ TIPOS DE RESTRICCIONES/CONSTRAINTS ##############
# NOT NULL
# UNIQUE
# PRIMARY KEY
# FOREING KEY
# DEFAULT
# CHECK 
##########################################

## CONSULTA DE CONTRAINTS UTILIZANDO TABLAS CON INFORMACION DEL ESQUEMA
SELECT CONSTRAINT_NAME,
     TABLE_SCHEMA ,
     TABLE_NAME,
     CONSTRAINT_TYPE
     FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
   WHERE TABLE_NAME='Productos';
   
-- # CONSTRAINT_NAME, TABLE_SCHEMA, TABLE_NAME, CONSTRAINT_TYPE
-- 'id', 'bdtemporal', 'productos', 'UNIQUE'
-- 'nombreProducto', 'bdtemporal', 'productos', 'UNIQUE'
-- 'PRIMARY', 'bdtemporal', 'productos', 'PRIMARY KEY'

   -- Elimino una constraint
   alter table productos drop constraint nombreProducto;
   
   -- Agrego una constraint
   alter table Productos add constraint uqnombreProducto unique (nombreProducto) ;
   
## --CREO LA TABLA CON LAS CONSTRAINS A NIVEL DE LA COLUMNA
CREATE TABLE clientes
(
	id INT primary key auto_increment,
    nombreCliente varchar(30) not null unique,
    ciudad varchar(30),
    telefono varchar(30)
);

# --CREO LA TABLA CON LAS CONSTRAINS A NIVEL DE LA TABLA
CREATE TABLE clientes
(
	id INT auto_increment,
    nombreCliente varchar(30) not null,
    ciudad varchar(30),
    telefono varchar(30),
    constraint clientes_pk primary key (id),
    constraint nombreCliente_uq unique (nombreCliente)
);

create table PRODUCTOS
(
	id int not null unique auto_increment,
    nombreProducto varchar(30) unique,
    costo decimal(8,2) not null default 0 ,
    precioVenta decimal(8,2) not null default 0,
    existencia decimal(8,2) not null default 0 
);
    
    -- constraint check 
    alter table Productos add constraint existencia_ck check (existencia>=0);

    
# Crear una tabla temporal (solo estara en el esquema mientras dure la sesion)
    create temporary table tmpProductos select * from productos;

# Crear una tabla con la misma estructura que otra
    create table tmpProductos1 like productos; # Crea la estructura sin datos con mismas constraints
    
# Crear y eliminar un indice
    
    create index idx_existencia on productos(existencia);
    
     drop index idx_existencia on productos;
     
    desc productos;
    
  #  -- borramos la base de datos
drop database if exists bdtemporal;

-- creamos la base de datos
create database if not exists bdTemporal;

-- seleccionamos la base de datos
use bdTemporal;

-- crear una tabla que no tenga ningun atributo
CREATE TABLE clientes
(
  id int primary key auto_increment,
  nombreCliente varchar(30) not null unique,
  ciudad varchar (30),
  telefono varchar(30)
)ENGINE = InnoDB;

-- crear una tabla que tenga atributos en sus columnas y defina el nombre de la base de datos
CREATE TABLE IF NOT EXISTS bdTemporal.productos
(
  id int  primary key not null unique auto_increment,
  nombreProducto varchar(30)   unique,
  costo decimal(8,2)           not null    default 0,
  precioVenta decimal(8,2)     not null    default 0,
  existencia decimal(8,2)      not null    default 0
)ENGINE = InnoDB;

# drop table detalleVenta
 #no action cambio a cascade y veo como entonces si puedo eliminar al cliente 1
-- creamos la tabla 
CREATE TABLE IF NOT EXISTS detalleVenta
(
  id int primary key not null unique auto_increment,
  fechaVenta date not null,
  idClientes int not null,
  idProductos int not null,
  cantidadVendida decimal(8,2) not null,
  costo decimal(8,2) not null default 0,
  precioVenta decimal (8,2) not null,
  constraint fkDetalleVentaClientes
  foreign key (idClientes)
  references Clientes (Id)
  on delete cascade on update cascade, -- cuando se elimine un cliente se eliminaran automaticamente las entradas en detalleventa
  constraint fkDetalleVentaProductos 
  foreign key (idProductos)
  references Productos (Id)
  on delete no action on update no action -- queda restringido es decir no permitira eliminar productos con entradas en detalleventa 
)ENGINE = InnoDB; 

-- Otras opciones para ON DELETE / ON DELETE son:
 -- SET NULL pone nulos en las entradas en las claves foraneas que ya no tienen dependencia
 -- SET DEFAULT pone un valor por defecto  en las claves foraneas que ya no tienen dependencia
 

desc detalleventa;

#########################
## ALTER TABLES Ejemplos
#########################

## Acciones sobre columnas/campos 

-- Mostrar estructura de la tabla productos
desc productos;

-- Agregar un campo a la tabla de productos llamada color
alter table productos
add color varchar(20);

-- Borro el campo 
alter table productos
drop column color;

-- Agregar un campo llamado color a la tabla de productos despues del campo costo
alter table productos
add color varchar(20) after costo;

-- Agregar la columna a la tabla de productos siendo el primer campo
-- no lo hare porque es mejor que el primer campo sea la pk
alter table productos
add color varchar(20) first;

-- Cambiar el tamaño de una columna (nombreProducto), no te dejara cambiarlo si violas el tamaño de los registros que ya tengan información.
-- En este caso lo modifico a mas grande y le agrego la constraint not null.
-- conservó ademas la constraint unique
alter table productos
modify nombreProducto varchar(50) not null;

-- Cambiar el tipo de dato de una columna, no te permitira hacer el cambio
-- si tu campo no acepta el tipo de dato con los datos que ya se tengan almacenados
alter table productos
modify nombreProducto char(50)  null; # char tambien es caracter pero utiliza la totalidad en el almacenamiento a diferencia de varchar 
										# que es variable y solo utiliza la parte realmente ocupada con datos.

-- Cambiar el valor default para un registro cuando se inserte
alter table productos
modify nombreProducto char(50)  null  default 'coloqueNombreDelProducto';

-- Cambiar el nombre de un campo
alter table productos
change column costo precioCompra decimal(8,2);

## Acciones sobre constraints 

-- agregar la llave primaria si se te olvido, en la tabla detalleVenta siendo la llave primaria el campo id
ALTER TABLE bdTemporal.detalleVenta
ADD primary key (ID);

-- agregar las llaves foraneas que pertenecen a los campos idClientes y idProductos a la tabla detalleVenta si no estuvieran creadas
ALTER TABLE bdTemporal.detalleVenta
ADD constraint fkDetalleVentaClientes
  foreign key (idClientes)
  references Clientes (Id)
  on delete no action; -- queda restringida la eliminacion de clientes con entradas en detalleventa

ALTER TABLE bdTemporal.detalleVenta
ADD constraint fkDetalleVentaProductos
  foreign key (idProductos)
  references productos (Id)
  on delete cascade; -- se eliminaran las entradas en detalleventa de los productos que se eliminen
  
  desc detalleventa;
  
  -- borrar una llave primaria 
  ALTER TABLE detalleventa 
  DROP primary key;
  
  ALTER table detalleventa add constraint primary key(id);
  
    -- borrar una clave foranea 
  ALTER TABLE detalleventa 
  DROP foreign key pkDetalleVentaClientes;
  
  ALTER TABLE detalleventa 
  DROP foreign key pkDetalleVentaProductos;
  
  ## Acciones sobre tablas 
  
  -- Renombrar una tabla
  RENAME TABLE clientes TO cliente;
  # las referencias a esta tabla son modificadas por el gestor automaticamente (por ejemplo en la definicion de las fk)
   RENAME TABLE cliente TO clientes;
   
  -- Truncar una tabla 
  -- (elimina toda la informacion de la tabla, eliminandola y volviendola a crear)
# Difiere de DELETE puesto que esta instruccion elimina las filas pero por ej conserva al auto incremento de la pk  
# El TRUNCATE conserva la estructura, restricciones/contraints, indices. Vuelve a cero la tabla. Es una sentencia DDL no admite rollback.

TRUNCATE TABLE detalleVenta; -- no admite rollback 

-- Eliminar tablas 
DROP TABLE detalleVenta; # esta nos la permitiria
DROP TABLE clientes; # esta NO nos la permitiria borrar por integridad referencial con detalleVenta
DROP TABLE productos; # esta SI porque tiene el delete en cascada para detalleVenta

-- ------------------
-- Campos calculados
-- ------------------ 
ALTER TABLE detalleVenta 
ADD COLUMN beneficio float as (precioVenta-preciocosto) not null ;
# se creara como un campo VIRTUAL no almacenado en la BD. Si quisiera almacenarlo fisicamente 

ALTER TABLE detalleVenta 
ADD COLUMN beneficio float as (precioVenta-costo) STORED not null;  
# Observar que al crear esta columna, en la tabla ya tiene los valores calculados

ALTER TABLE detalleVenta 
ADD COLUMN diezPor100Dcto float as (precioVenta-(precioVenta/10)) virtual not null ;

-- creo una nueva tabla para proximas clases

CREATE TABLE cliente (
  id INT primary key NOT NULL AUTO_INCREMENT,
  apaterno VARCHAR(45) NULL,
  amaterno VARCHAR(45) NULL,
  nombre VARCHAR(45) NULL,
  correo VARCHAR(45) NULL,
  telefono VARCHAR(45) NULL,
  calle VARCHAR(100) NULL,
  numero VARCHAR(45) NULL,
  colonia VARCHAR(100) NULL,
  municipio VARCHAR(45) NULL
  )Engine Innodb;
  
  rename table cliente to clientes;
  
  select count(*) from clientes;
  
  -- CREANDO VISTAS

use bdpendientes;

create OR REPLACE view VISTA_PER_CONTACTO AS
select NOMBRE, CORREO, TELEFONO FROM PERSONAS
where CORREO LIKE '%hotmail%'
union
select NOMBRE, CORREO, TELEFONO FROM PERSONAS
where CORREO LIKE '%YAHOO%';


-- PERSONAS QUE TENGAN MAS DE 8 MOVIMIENTOS
create OR REPLACE view VISTA_PERSONAS AS
SELECT P.ID, P.NOMBRE, count(P.id) CANTIDAD_MOVIMIENTOS, SUM(montoIE) TOTAL_IMPORTES 
FROM entradasalidadinero 
inner join personas p ON idPersonas=P.ID
group by P.ID, p.nombre
having count(P.id)>8
ORDER BY 3 DESC;

select * from vista_personas;

-- este select sin inner join funciona igual que la vista aunque la vista ya esta calculada y seguramente ira mas rapida. 
SELECT P.ID, P.NOMBRE, count(P.id) CANTIDAD_MOVIMIENTOS, SUM(montoIE) TOTAL_IMPORTES 
FROM entradasalidadinero es,  personas p
where  es.idPersonas=P.ID
group by P.ID, p.nombre
having count(P.id)>8
ORDER BY CANTIDAD_MOVIMIENTOS DESC;

-- ELIMINANDO LA VISTA
drop view vista_personas;

-- SE PUEDEN REALIZAR ALGUNOS UPDATES EN LAS VISTAS
update VISTA_PER_CONTACTO
set NOMBRE = concat(NOMBRE,'-'); -- En esta vista no se puede hacer porque esta limitado por el Union 

update vista_personas
set NOMBRE = concat(NOMBRE,'-'); -- En esta vista no se puede hacer porque esta limitado por el Union ¿?


-- -----------------------------------------
-- CHARACTER SETS --------------------------
-- ------------------------------------------

-- Mostrar todos los character set del motor de base de datos
show char set;

show char set like '%utf8%';

-- mostrar el character set por default del SERVIDOR
show variables like 'character_set_server'; 
-- en este caso es utf8mb4 es un set extendido. Utiliza 4 bytes. Contiene todo el UNICODE (caracteres de la mayoria de idiomas del mundo mas emojis)
-- El utf8mb3 contiene el UNICODE y utiliza 3 bytes.

-- mostrar el character set por default de la BD
show variables like 'character_set_database'; -- tambien es utf8mb4 es un set extendido. 

-- los CHARACTER SET tienen uno o mas COLLATIONS que son reglas que aplican a los character set por ejemplo para el ordenamiento de los caracteres
-- Algunos ejemplos: latin1_general_ci
-- 					 latin1_general_cs
-- 					 utf8_general_ci
-- 					 utf8_unicode_ci
-- Los que acaban en CI son case insensitive, los CS case sensitive. 
-- Siglas AI, AS indican accent insensitive y sensitive respectivamente.
-- Los que contienen BIN ordenan segun el codigo binario que corresponde a los caracteres.

-- mostrar las collations
show collation;
show collation where charset like '%utf8mb4%';

-- mostrar la que trae por default el servidor
show variables like 'collation_server'; -- utf8mb4_0900_ai_ci (acentos y case no sensitivo)

-- mostrar la que trae por default la base de datos
show variables like 'collation_database'; -- utf8mb4_0900_ai_ci

-- mostrar la collation de cada tabla de una BD/Schema
select table_name, table_collation
from information_schema.tables
where table_schema='bdpendientes';

-- creamos una BD temporal para ver que charset y collation le asigna y como se cambia
create database if not exists bdpendientestemp1; 
-- con el schema inspector se puede ver que asigno el charset y collation por defecto utf8mb4 y utf8mb4_0900_ai_ci

-- si los quiero especificar cuando creo la BD
create database if not exists bdpendientestemp2 charset 'utf8mb3' collate 'utf8_general_ci';
-- indico un warning porque este character set es antiguo y esta sugiriendo poner el que viene por defecto
-- de nuevo con el schema inspector se puede ver que asigno estos charset y collate.

-- cambiamos el character set
alter database bdpendientestemp2 charset 'utf8mb4';
-- en el schema inspector se ve que lo ha cambiado y coloco el collete por defecto para este charset 

-- ahora cambiamos el collate
alter database bdpendientestemp2 collate 'utf8mb4_0900_ai_ci';
-- cambio el collate al que especifique y ademas actualizo el charset a utf8mb4 que es el que corresponde a ese collate

-- TODO ESTO TAMBIEN SE PUEDE HACER DE FORMA GRAFICA MEDIANTE EL ALTER SCHEMA DE WORKBENCH 

-- Tambien podemos especificarlo para una tabla en concreto  

create table if not exists personas1
(
id int not null auto_increment,
nombre varchar(30) not null,
correo varchar (30) null,
telefono varchar (30) null,
primary key (id)
) charset utf8mb4 collate utf8mb4_0900_as_cs -- observar que indico un collate con case y accent sensitive
engine InnoDB;

insert into personas1 values (0,'María García', 'mg@gmail.com', 999888777);

-- buscamos el registro en mayusculas 
select * from personas1 where nombre = 'MARIA GARCIA'; -- no se encuentra porque esta en mayusculas
-- buscamos el registro sin acentos
select * from personas1 where nombre = 'Maria Garcia'; -- tampoco porque faltan los acentos

select * from personas1 where nombre = 'María García'; -- entonces si la encuentra 

-- ahora creo una tabla con collate no sensitive 
create table if not exists personas2
(
id int not null auto_increment,
nombre varchar(30) not null,
correo varchar (30) null,
telefono varchar (30) null,
primary key (id)
) charset utf8mb4 collate utf8mb4_0900_ai_ci -- observar que esta vez indico un collate con case y accent NO sensitive
engine InnoDB;

insert into personas2 values (0,'María García', 'mg@gmail.com', 999888777);

-- buscamos el registro en mayusculas 
select * from personas2 where nombre = 'MARIA GARCIA'; -- lo encuentra aunque esta en mayusculas
-- buscamos el registro sin acentos
select * from personas2 where nombre = 'Maria Garcia'; -- lo encuentra aun sin los acentos

-- Se pueden especificar charset y collate a nivel de CAMPO
create table if not exists personas3
(
id int not null auto_increment,
nombre varchar(30) charset utf8mb4 collate utf8mb4_0900_ai_ci not null, -- Solo lo especifica para este campo
correo varchar (30) null,
telefono varchar (30) null,
primary key (id)
) 
engine InnoDB;

## RENDIMIENTO

ANALYZE TABLE tmppersonas; -- actualiza el catalogo de la tabla optimizando su uso 
							-- ESTIMATE STATISTICS SAMPLE 10240 ROWS estas opciones son de Oracle;
