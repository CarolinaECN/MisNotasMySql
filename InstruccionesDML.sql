-- INSERT

CREATE TABLE tmpPersonas as
select * from personas where 1<>1; 
-- creara la tabla con la misma estructura de campos pero sin constraints 

select * from tmppersonas;

insert into tmppersonas 
values (0, 'JAIME','jaime_1@gmail.com','567454344',1);

-- cuando insertamos filas en las tablas debemos de cumplir la integridad referencial y condiciones de la tabla 
-- como la unicidad de la pk, campos not null, etc.
select * from personas;

-- por ejemplo no podriamos insertar un reg que duplique la pk
insert into personas 
values (1, 'JAIME','jaime_1@gmail.com','567454344',1); -- como en este caso 

insert into personas 
values (12, 'JAIME','jaime_1@gmail.com','567454344',1); -- este si 

insert into personas 
values (0, 'PEPA','pepa@gmail.com','5694544344',1); -- la clave autoincrementable se puede dejar con 0 para que se calcule

-- los insert se pueden indicar con los campos que queremos cargar y se pueden cargar mas de una fila por instruccion
insert into personas (nombre, telefono, IDjefe)
values 
('JUANA PEREZ','433898470',3),
('PEDRO ALCANTARA', '768465321',3); 

rollback; -- no quito los registros que inserte, se quedaron porque tenia el commit implicito. Se pone a unable desde el boton.
select * from personas where correo like '%gmail.com';

-- insert desde otra tabla
insert into tmppersonas 
(select * from personas where correo like '%gmail.com');

select * from tmppersonas;

-- UPDATE

SELECT * FROM entradasalidadinero WHERE FECHAES='2018-01-03';

UPDATE entradasalidadinero SET MONTOIE=MONTOIE*1.10 WHERE FECHAES='2018-01-03'; 
-- Tenia seteada una limitacion en preference-->sqleditor que no me permitia hacer updates 

update usuarios set password = 'nuevopass'
where idPersonas in (select id from personas where correo like '%hotmail.com');

select * from usuarios;
select * from personas;

select * from tmppersonas;
insert into tmppersonas values
(1,	'JUAN PEREZ',	'juan@hotmail.com',	'4921301447',	1),
(2,	'MANUEL ALBERTO MARTINEZ',	'manuel@hotmail.com',	'4923567884',	4),
(3,	'JESUS DE LA CUEVA',	'jesus@hotmail.com',	'4921345678',	4),
(4,	'JOSE LUIS MONTEZ QUIÑONES',	'jose luis@hotmail.com',	'4748456789',	1);

select * from usuarios;

-- UPDATE CON DATOS DE OTRA TABLA 
-- IMPORTANTE!!! este update SIEMPRE deben limitarse las filas que quiero modificar en la clausula where !!!!!
-- de no hacerlo el RESTO DE FILAS que no se hallen en la subconsulta se completaran con nulos !!!!  
update personas set personas.nombre=(select tmppersonas.nombre from tmppersonas where personas.id=tmppersonas.id)
where id = (select tmppersonas.id from tmppersonas where personas.id=tmppersonas.id); -- esta parte where tiene que estar si o si

-- DELETE

SELECT * FROM tmppersonas WHERE length(NOMBRE)>=30; -- consulto primero para estar segura de lo que voy a eliminar
delete from  tmppersonas WHERE length(NOMBRE)>=30;  -- tambien tiene el commit implicito debe estar configurado en el workbench
													

select * from usuarios where idPersonas = 1;
delete from usuarios where idPersonas = 1;
delete from personas; -- eliminaria todas las entradas de la tabla si las fk lo permiten. 
						-- en este caso no se borran porque antes tendria que eliminar las filas de entradasalidadinero y usuarios 
                        -- con las que tiene fk

########################################
# IMPORTACION Y EXPORTACION DE UNA TABLA
########################################

# INTRUCCIONES PARA CARGAR UN FICHERO CSV EN UNA TABLA DE LA BD 

-- Creo la tabla 
create table cargapersonas 
(id int,
apaterno varchar (50),
amaterno varchar (50),
nombre varchar (50),
correo varchar (50),
telefono varchar (50),
calle varchar (50),
numero varchar (50),
colonia varchar (50),
municipio varchar (50)
);

-- Antes de subir el fichero tengo que moverlo al directorio seguro o deshabilitar la variable
SHOW VARIABLES LIKE "secure_file_priv";

-- El fichero de configuracion donde se ha de cambiar la opion secure_file_priv = "" o sea quitando el directorio que tiene asignado
-- C:\ProgramData\MySQL\MySQL Server 8.0\my.ini 
-- mysqld secure-file-priv = ""; -- no he podido deshabilitar esta variable
-- value=C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\ -- se queda asi. Colocare el fichero en este directorio

-- antes me estaba dando error 1290 que esta ejecutandose con el 'secure_file_priv' a pesar de que ubique el fichero en el directorio
-- que indicaba esta variable me seguia dando error poque al copiar la ruta desde windows me ponia \ en lugar de / 
-- he cambiado la ruta con las barras / y ahora me da otro error de permisos 

-- tambien habilito la variable para ficheros locales
SHOW GLOBAL VARIABLES LIKE 'local_infile'; -- esta en OFF 
SET GLOBAL local_infile=1; -- ahora ya esta en ON

-- instruccion de carga buena despues de muchos intentos
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\listadoclientes.csv' -- cambie " por ' porque la doble no me funciono
INTO TABLE cargapersonas
CHARACTER SET latin1 -- hago la carga con este character set porque hay caracteres que me estan dando error
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' -- agregue \r
IGNORE 1 ROWS;


-- tiene problemas para cargar una Ñ a pesar de que el character set es utf8mb4 al quitar la fila 
-- sigue dando error Código de error: 1300. Cadena de caracteres utf8mb4 no válida: 'AV.2'
-- Lo soluciono cambiando el charater set a latin1 durante la carga 
-- Tengo unos cuantos warnings porque el campo 'colonias' es corto 

-- Correcciones de warnings durante la carga                        
select max(length(colonia)) from cargapersonas; -- 50 de 50 lo amplio trunco la tabla y vuelvo a cargar el fichero
alter table cargapersonas modify colonia varchar(100);
truncate table cargapersonas;

-- El campo calle tambien resulto corto 
alter table cargapersonas modify calle varchar(80);
truncate table cargapersonas;

-- vuelvo a poner el charset y la collate que tenia que es la misma de la BD. El cambio de charset solo lo hago durante la carga
ALTER TABLE cargapersonas
  CHARACTER SET utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
                        
select count(*) from cargapersonas; -- ahora si 9402 reg cargados



# INTRUCCIONES PARA DESCARGAR UN FICHERO CSV CON LOS DATOS DE UNA TABLA 

-- tengo la variable seteada para este directorio 

SELECT * FROM personas
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\descargapersonas.csv' -- si no funciona poner doble antibarra 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'; 
                  
                  
#########################################################
# IMPORTACION Y EXPORTACION DE UNA BASE DE DATOS COMPLETA 
#########################################################

-- para cargar/descargar ficheros desde/hacia el directorio ..\bin de mysql el usuario tiene que tener permisos de lectura/escritura en el directorio

# CARGA DE LA BD

# Cargar por linea de comandos una BD 
-- primero la creo 
create table basedatos;
use basedatos;

-- mediante comando SOURCE
source bddatos.sql; -- estando el fichero en el mismo directorio del ejecutable de mysql o sea en bin ../bin/mysql.exe  por eso no especifico la ruta del fichero
show tables;

-- mediante comando mysql desde el directorio del ejecutable de mysql o sea en bin ../bin/
mysql -u root -p basedatos < bddatos.sql -- donde el primer argumento es el esquema o base de datos vacia donde se cargaran los datos y el segundo es el fichero sql que contiene la BD.
-- pide contraseña y comienza a cargar los datos

# DESCARGA DE LA BD A UN FICHERO SQL

-- Desde el directorio ..\bin de mysqlserver que es donde estan todos los ejecutables
mysqldump -u root -p basedatos > bddatos.sql 

##########################################################################
# DESCARGA DE UNA TABLA AL COMPLETO (ESTRUCTURA + DATOS) A UN FICHERO .sql
##########################################################################

-- Desde el directorio ..\bin de mysqlserver que es donde estan todos los ejecutables. Observar que es otro ejecutable!!
mysqldump -u root -p basedatos tabla > bdtabla.sql 

mysqldump -h localhost -u root -p basedatos tabla > bdtabla.sql 

-- Para volcar esta tabla y sus datos a otra BD
create database otrabasedatos;
use otrabasedatos;
mysql -u root -p otrabasedatos < bdtabla.sql 
