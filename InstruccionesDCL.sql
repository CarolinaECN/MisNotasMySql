
-- LOS PERMISOS SE PUEDEN DAR A NIVEL DE:
	-- DML (o sea para insert, update, delete, select, execute) O 
    -- DDL (o sea creates, views, drop, alter, etc).

-- Para ver privilegios del usuario
show privileges;
-- Lo mismo se puede ver desde workbench picando en la pestaña Administracion y en 'Usuarios y Privilegios'.
-- Alli hay una lista de usuarios donde si se selecciona uno se puede ver toda la info y privilegios del usuario, agregar o revocarlos.

-- CREAR USUARIOS

create user usuario1@localhost identified by '12345'; -- esta es la password

use mysql; -- es como una BD donde esta la info de gestion 
select user, host from user;-- una tabla de usuarios de la BD

-- desde workbench en el inicio (icono de la casita) creo una conexion para el usuario donde pone Mysql Conections el boton (+) 
-- Indicamos el nombre de la conexion y el usuario. La creamos y entramos con esa conexion. Nos pide la password. Vemos que no tiene ningun esquema asignado.
-- Le damos al usuario todos los privilegios sobre bdpendientes.

-- DAR PERMISOS 

 grant all on bdpendientes to usuario1@localhost with grant option;
 
 show grants for usuario1@localhost;

 show grants for usuario2@localhost;
 -- antes de darle privilegios la salida es esta: 
 -- 'GRANT USAGE ON *.* TO `usuario2`@`localhost`'
 
 -- otorgo privilegios 
grant select, insert on bdpendientes.* to usuario2@localhost with grant option;

show grants for usuario2@localhost;
-- la salida es esta:
-- 'GRANT USAGE ON *.* TO `usuario2`@`localhost`'
-- 'GRANT SELECT, INSERT ON `bdpendientes`.* TO `usuario2`@`localhost`'

-- QUITAR PERMISOS

revoke all, grant option from usuario2@localhost; 

show grants for usuario2@localhost;
-- GRANT USAGE ON *.* TO `usuario2`@`localhost` ## ya se eliminaron sus privilegios

-- RENOMBRAR usuarios
rename user usuario1@localhost to user1@localhost; 

show grants for usuario1@localhost; -- no existe el usuario1

show grants for user1@localhost;
-- GRANT USAGE ON *.* TO `user1`@`localhost`
-- GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, CREATE ROUTINE ON `bdpendientes`.* TO `user1`@`localhost`
-- GRANT ALL PRIVILEGES ON `mysql`.`bdpendientes` TO `user1`@`localhost` WITH GRANT OPTION

-- ELIMINAR usuario
drop user user1@localhost; 
show grants for user1@localhost; -- ya no existe

use mysql;
select user, host from user;

