-- ---------
--  VISTAS
-- ---------

create OR REPLACE view VISTA_PERSONAS AS
select NOMBRE, CORREO, TELEFONO FROM PERSONAS
where CORREO LIKE '%hotmail%'
union
select NOMBRE, CORREO, TELEFONO FROM PERSONAS
where CORREO LIKE '%YAHOO%';

SELECT * FROM VISTA_PERSONAS; 

-- PERSONAS QUE TENGAN MAS DE 8 MOVIMIENTOS

create OR REPLACE view VISTA_PERSONAS AS
SELECT P.ID, P.NOMBRE, count(P.id) CANTIDAD_MOVIMIENTOS, SUM(montoIE) TOTAL_IMPORTES 
FROM entradasalidadinero 
inner join personas p ON idPersonas=P.ID
group by P.ID
having count(P.id)>8
ORDER BY 3 DESC;

-- --------------------------
-- PROGRAMAS ALMACENADOS ---
-- --------------------------

-- Tipos:
-- Store procedures: procesos almacenados que pueden invocarse desde cualquier programa con acceso a la BD
-- Store function: procesos almacenados que devuelven un valor. Se invocan desde selects o dentro de otros procesos.
-- Triggers: procesos almacenados que se ejecutan durante un evento (insert, delete o update de alguna tabla).
-- Event: procesos almacenados de ejecucion programada para una fecha/hora establecida.

-- CREAR PROCEDIMIENTO

DELIMITER //
create procedure PRUEBA()
begin

declare NUEVOS int;
declare FINALIZADOS int;

select COUNT(*) 
into NUEVOS -- GUARDO EL RESULTADO EN LA VARIABLE QUE DECLARE
from pendiente
inner join estadopendiente ep ON IDESTADOPENDIENTE=ep.id
where ep.estado='NUEVO' ;

select COUNT(*) 
into FINALIZADOS -- GUARDO EL RESULTADO EN LA VARIABLE QUE DECLARE
from pendiente
inner join estadopendiente ep ON IDESTADOPENDIENTE=ep.id
where ep.estado='FINALIZADO' ;

select NUEVOS AS pendientes_nuevos, FINALIZADOS AS pendientes_finalizados; -- select para mostrar los resultados
end // 
DELIMITER ;

-- LLAMADA AL PROCEDIMIENTO
call PRUEBA(); -- con o sin ()

-- ELIMINAR PROCEDIMIENTO 
drop procedure PRUEBA;

select * from estadopendiente;
select Count(*) from pendiente where idEstadoPendiente=1

-- ------
-- IF --
-- ------
 
delimiter // 
create procedure TOTALPENDIENTES (in varIdPersonaAsignado int, out frase varchar(100), out persona varchar(80)) 
BEGIN

declare totalPendientes int default 0;
-- totalPendientes == 0; -- no me deja hacer esta asignacion ¿?
select count(*) into totalPendientes 
from pendiente 
where idPersonaAsignada=varIdPersonaAsignado;

If totalPendientes = 0 then 
	set frase='Esta persona no tiene pendientes asignados'; -- aqui debo de poner SET para asignar el valor a la variable de salida
elseif totalPendientes > 0 and totalPendientes <=5 then
    set frase = concat('Esta persona tiene una ocupacion baja: ',totalPendientes,' pendientes.');
elseif totalPendientes > 5 and totalPendientes <= 15 then
	set frase = concat('Esta persona tiene una ocupacion media: ',totalPendientes,' pendientes.');
elseif totalPendientes > 15 then
	set frase = concat('Esta persona tiene una ocupacion alta: ',totalPendientes,' pendientes.');
end if;

select nombre 
into persona
from personas
where id=varIdPersonaAsignado;
END // 

delimiter ;

CALL totalPendientes (5, @fr, @per); -- no tienen que indicarse necesariamente los mismos nombres de variables que tiene el procedimiento
select @per, @fr;

drop procedure totalPendientes;

-- --------
-- CASE ---
-- --------
-- En el ejemplo anterior cambiamos los IF ELSEIF por CASE
delimiter // 
create procedure TOTALPENDIENTES (in varIdPersonaAsignado int, out frase varchar(100), out persona varchar(80)) 
BEGIN

declare totalPendientes int default 0;

select count(*) into totalPendientes 
from pendiente 
where idPersonaAsignada=varIdPersonaAsignado;

case -- totalPendientes  aca no se pone la variable sino sale mal 
	when totalPendientes = 0 then
		set frase='Esta persona no tiene pendientes asignados';
    when totalPendientes >= 1 and totalPendientes <=5 then
		set frase = concat('Esta persona tiene una ocupacion baja: ',totalPendientes,' pendientes.');
	when totalPendientes > 5 and totalPendientes <= 15 then 
		set frase = concat('Esta persona tiene una ocupacion media: ',totalPendientes,' pendientes.');
    else 
		set frase = concat('Esta persona tiene una ocupacion alta: ',totalPendientes,' pendientes.');
end case; -- en el case se asigna el valor al parametro de salida 'frase'

select nombre into persona from personas where id=varIdPersonaAsignado; -- aqui asigno el valor al parametro de salida 'persona'
END // 

delimiter ;

call totalpendientes(5, @fr, @per);
select @per as Persona, @fr as Frase from dual;

-- ---- ---
-- WHILE --
-- --------

DELIMITER //
create procedure PROCESO_WHILE()
begin
	declare cont int default 1;
    declare s varchar(100) default '';
    
    while cont <=5 do
		set s = concat (s, ' cont: ', cont, '|');
		set cont=cont+1;
    end while;
    
    select s as mensaje;

end // 
delimiter ;

call PROCESO_WHILE; -- ya me arroja la variable  'mensaje' una vez se ejecuta el procedimiento

drop procedure proceso_while;

-- ----------
-- REPEAT ---
-- ----------

DELIMITER //
create procedure PROCESO_REPEAT()
begin
	declare cont int default 1;
    declare s varchar(100) default '';
    
    repeat
		set s = concat (s, ' cont: ', cont, '|');
		set cont=cont+1;
    until cont = 6 -- NOTAR QUE PARA QUE LLEGUE A MOSTRAR EL 5 HAY QUE HACER EL CORTE EN EL SIGUIENTE PORQUE EL CONTADOR SE INCREMENTA DESPUES DE SET s
    end repeat;
    
    select s as mensaje;

end // 
DELIMITER ;

call PROCESO_REPEAT; 

drop procedure PROCESO_REPEAT;

-- ------- 
-- LOOP -- Es muy raro no me gusta
-- -------
DELIMITER //
create procedure PROCESO_LOOP()
begin
	declare cont int default 1;
    declare s varchar(100) default '';
    declare testLoop varchar(10);
    
    testLoop : LOOP
         set s = concat(s,' cont =',cont,'|');
         set cont=cont +1;
         if cont=6 then
            LEAVE testLoop;
         end if;
    end loop testLoop;
    
    select s as mensaje;

END //

call PROCESO_LOOP;

-- ------------
-- CURSORES ---
-- ------------

delimiter //
create procedure PROCESO_CURSORES()
begin
	declare id_persona_var int;
    declare telefono_var varchar(30);
	declare row_not_found tinyint default false; -- BANDERA PARA GUARDAR EL not_found DEL CURSOR
    declare update_cont int default 0; -- GUARDARA EL NUMERO DE FILAS QUE SE ACTUALIZARAN
    -- declaracion del cursor  (observar que no va INTO en el select porque esto es solo una declaracion)
    declare id_persona_cursor cursor for
    select id, telefono from personas
    where correo like '%hotmail%';
    
    -- declaracion del manejador de errores para cuando el cursor no encuentre mas registros
    declare continue handler for not found -- declara la continuacion del manejador para cuando no hay mas registros
		set row_not_found = true;
        
	-- abro el cursor
    open id_persona_cursor;
   
   while row_not_found=false do
		-- cojo un registro del cursor y almaceno los datos del cursor en las variables
        fetch id_persona_cursor into id_persona_var, telefono_var; -- aqui si va el INTO para utilizar las variables que declare
        
        if length(telefono_var)>0 then
			update pendiente set observaciones = telefono_var
            where idPersonaAsignada=id_persona_var;
		else 
			update pendiente set observaciones = 'SOLICITAR TELEFONO DE CONTACTO'
            where idPersonaAsignada=id_persona_var;
            set update_cont = update_cont + 1; -- no olvidar SET para asignar valores a las variables
		end if;
	end while;
    
	-- Cierro el cursor
	close id_persona_cursor;
    select concat('Filas sin telefono: ',update_cont) as mensaje; -- Esto es lo que se muestra 
end //
delimiter ;

call PROCESO_CURSORES;

drop procedure PROCESO_CURSORES;

SELECT * FROM PENDIENTE;
 
SELECT * FROM PENDIENTE WHERE IDPERSONAASIGNADA=6;

SELECT * FROM PERSONAS WHERE ID=6; -- Esta persona no entro porque no tiene mail de hotmail

-- ----------------------
-- FUNCIONES ALMACENADAS
-- ----------------------
-- Solo retornan un valor. No mas de uno. No se puede hacer insert, delete  update en ellas.
-- Se suelen utilizar en las consultas para obtener un valor calculado sobre datos de la BD.

set global log_bin_trust_function_creators = 1; -- setear esta variable para que me permita crear funciones. 

delimiter //
create function montosIE(idIE int)
returns decimal(10,2) -- returns en plural
begin
	declare sumatoria decimal(10,2);
    select sum(montoIE)
    into sumatoria
	from entradasalidadinero
    inner join ingresosegresos ie on idIngresosEgresos=ie.id
    where ie.idtipoingeg=idIE;
    
    If sumatoria > 0 then
		return sumatoria; -- aqui return en singular
	else 
		return 0;
	end if;
end //
delimiter ;

-- delimiter ;

drop function montosIE;

select sum(montoIE) 
	from entradasalidadinero
    inner join ingresosegresos ie on idIngresosEgresos=ie.id
    where ie.idtipoingeg=1; -- '174850.00' corresponde a gastos de ropa personal

    -- llamada a la funcion 
select descripcion, montosIE(id) from ingresosegresos;

select * from entradasalidadinero;
select * from ingresosegresos;
  
   
-- ------------
-- TRIGGERS --
-- ------------

-- Procesos almacenados que se ejecutan antes o despues de alguna instruccion DML (insert, delete, update)
-- Pueden ser utiles para almacenar datos en un log para registrar los cambios efectuados
-- CREATE TRIGGER nombre_trigger 
-- BEFORE|AFTER INSERT|UPDATE|DELETE ON nombre_tabla
-- FOR EACH ROW 
-- BEGIN
-- END 

-- En el caso de los deletes no contamos con los valores NEW (solo tendremos OLD)
-- En el caso de los inserts no contamos con los valores OLD (solo contamos con los NEW)
-- En el caso de los updates tenemos valores OLD y NEW

-- creo un trigger para pasar a minuscula las direcciones de correo de la tabla de personas despues de un update
-- y ademas que no permita (de un error) ingresar correos de gmail

drop trigger personas_before_update;

delimiter // 
create trigger personas_before_update before update on Personas 
for each row
begin
		if new.correo like '%gmail%'
        then
			signal sqlstate 'HY000' -- signal se utiliza para devolver un error
            set message_text='Introducir una cuenta que no sea de gmail'; -- es un 'atributo' del error (hay mas). Es el mensaje que devuelve.
        else
			set new.correo=lower(new.correo);
		end if;
end //

delimiter ;

update personas set correo='MICORREO@gmail.COM' WHERE id=1; -- en este caso da error 
update personas set correo='MICORREO@HOTMAIL.COM' WHERE id=1; -- en este caso pasa todo a minusculas 

select * from personas;

-- --------------------------------------------------------------------
-- Creo una tabla de logs para almacenar info de eventos/transacciones
-- --------------------------------------------------------------------


create table if not exists bdpendientes.log_eventos 
(
nombre_tabla varchar(45),
after_before varchar(45),
valor_new varchar(45),
valor_old varchar(45),
estatus varchar(45),
fecha_hora datetime
) ENGINE = InnoDB;

-- ahora creo el mismo trigger pero este ademas almacenara la informacion a la tabla de logs 

drop trigger personas_before_update;

delimiter // 
create trigger personas_before_update before update on Personas 
for each row
begin
		if new.correo like '%gmail%'
        then
			begin
			insert into bdpendientes.log_eventos values ('Personas', 'Before', new.correo, old.correo, 'No se realizo la actualizacion', now()); -- este insert no se realiza
			end; -- asi tampoco hace el insert
            signal sqlstate 'HY000' -- Este manejo de error inhabilita el insert. Seguramente porque se trata de una misma transaccion. 
            set message_text='Introducir una cuenta que no sea de gmail';
        else
			set new.correo=lower(new.correo);
            insert into bdpendientes.log_eventos values ('Personas', 'Before', new.correo, old.correo, 'Actualizacion realizada', now());
		end if;
end //

delimiter ;

-- vuelvo a realizar los updates

update personas set correo='MICORREO@gmail.COM' WHERE id=1; -- en este caso da error 
update personas set correo='MICORREO@HOTMAIL.COM' WHERE id=1; -- en este caso pasa todo a minusculas 

select * from personas;
-- veo la tabla de logs
select * from log_eventos;


-- ---------------
-- EVENTOS -------
-- ---------------
-- Los eventos son tareas programadas en el tiempo que se ejecutan en la BD con cierta periodicidad o cuando se 'agende' la tarea. 
-- Para poder crear eventos debemos tenemos que habilitar esta variable.
SET GLOBAL event_scheduler = ON; -- en OFF se detienen todos los eventos

-- Los intervalos:
-- YEAR | QUARTER | MONTH | DAY | HOUR | MINUTE | WEEK | SECOND | YEAR_MONTH | DAY_HOUR | DAY_MINUTE | DAY_SECOND | HOUR_MINUTE | HOUR_SECOND | MINUTE_SECOND
              
-- Para ver los eventos 
SHOW events;

-- Para borrar un evento
DROP EVENT nombre_evento;

-- Una vez que el evento haya cumplido todas las ejecuciones que tenia programadas, se eliminara autometicamente.
-- Para preservarlo:
-- ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
-- ON COMPLETION PRESERVE -- se guardara aunque haya caducado

-- Ejemplo de evento
CREATE EVENT insertion_event
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO INSERT INTO test VALUES ('Evento 1', NOW());

select CURRENT_TIMESTAMP ; -- 2022-10-10 10:09:32
select now(); -- 2022-10-10 10:09:50  

-- Otro ejemplo
DELIMITER //

CREATE EVENT insertion_event
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
BEGIN
 INSERT INTO test VALUES ('Evento 1', NOW());
 INSERT INTO test VALUES ('Evento 2', NOW());
 INSERT INTO test VALUES ('Evento 3', NOW());
END //

DELIMITER ;

-- Algo común con los eventos es trabajar con store procedures.

CREATE EVENT nombre_evento
ON SCHEDULE AT 'fecha de ejeución' 
DO
CALL store_procedure();

-- Otro ejemplo
CREATE EVENT insertion_event
ON SCHEDULE EVERY 1 MINUTE STARTS '2018-07-07 18:30:00' -- comienza en este momento
ENDS '2018-07-07 19:00:00' -- acaba en este otro y se ejecuta un minuto
DO INSERT INTO test VALUES ('Evento 1', NOW());

-- Para detener un evento hay que deshabilitarlo
ALTER EVENT nombre_evento DISABLE;
-- Para habilitarlo nuevamente 
ALTER EVENT nombre_evento ENABLE;
-- Para detener todos los eventos
SET GLOBAL event_scheduler = OFF;



-- --------------------------------------
-- ---- SQL DINAMICO --------------------
-- --------------------------------------
-- Se crean mediante procedimientos almacenados para ejecutar consultas creadas por parametros

drop procedure sqldinamico;

delimiter //
create procedure sqldinamico(camposeleccionado int, valor varchar(50))
begin
   
    declare campo varchar(30);       -- variable que guardara el valor del campo seleccionado en parametros
    set campo='';

	if (camposeleccionado=1) then  -- si el usuario selecciono o envio como parametro 1 es porque quiere buscar por nombre
	   set campo= concat(" nombre = ","'", valor, "'");
    end if;

    if (camposeleccionado=2) then -- si el usuario selecciono o envio como parametro 2 es porque quiere buscar por correo
       set campo= concat(" correo = ","'", valor, "'");
    end if;

    if (camposeleccionado=3) then -- si el usuario selecciono o envio como parametro 3 es porque quiere buscar por telefono
       set campo= concat(" telefono = ","'", valor, "'");
    end if;
    
    if (camposeleccionado=4) then -- si el usuario selecciono o envio como parametro 4 es porque quiere buscar por id
       set campo= concat(" id = ", valor); -- aqui quito las comillas porque es un valor numerico
    end if;

    if (camposeleccionado=5) then -- si el usuario selecciono o envio como parametro 5 es porque quiere buscar por nombre pero con LIKE
       set campo= concat(" nombre like  '%", valor ,"%'");
    end if;
 
    set @sqlsentencia=concat('select id,nombre,correo,telefono
                              from personas
							  where', campo);-- formamos una instruccion SQL con la sintaxis creada con los parametros de entrada
                              
    -- estas tres instrucciones son necesarias para que se prepare, ejecute y mande a salida los datos arrojados
    prepare select_invoices_statement from   @sqlsentencia;
    execute select_invoices_statement;
    deallocate prepare select_invoices_statement;
end //

delimiter ;


call sqldinamico(1,'juan');
call sqldinamico(1,'JUAN PEREZ GARCIA'); -- 1 Busqueda por nombre

call sqldinamico(2,'juanis@gmail.com'); -- 2 Busqueda por mail

call sqldinamico(3,'4935405678'); -- 3 Busqueda por telefono

call sqldinamico(4,'10'); -- Busqueda por Id

call sqldinamico(5,'an'); -- 5 Busqueda por like nombre

select * from personas;

-- ------------------------------------
-- UTILIZACION DE TRANSACCIONES ------
-- ------------------------------------
-- MYSQL tiene implicito el auto commit para cualquier transaccion que se ejecute 
-- Para hacer un control de transacciones con posibilidad de rollback/commit se debe crear un procedimiento que maneje la transaccion 

drop procedure transacciones;
delimiter //
create procedure Transacciones () -- sin parametros
BEGIN
	declare SQLERROR tinyint default FALSE;
    declare continue handler for sqlexception   
    set SQLERROR = TRUE; --  -- Este es el manejo de errores. La variable comienza con False y se cambia a True cuando hay una excepcion
    
    start transaction;  -- Aqui comienza la transaccion (trozo de codigo que se confirma en conjunto o se descarta en conjunto)
    
	delete from tmppersonas; -- sentencia valida
    insert into tmppersonas select * from personas; -- sentencia valida
    update tmppersonas set telefono = '123'; -- sentencia valida
   -- insert into tmppersonas values (0,null,'mail@gmail.com','999222333',10); -- esta no es valida 
    insert into tmppersonas values (0,'Carol','mail@gmail.com','999222333',10); -- esta si es valida
    
    -- Si cualquiera de las transacciones anteriores generara una excepcion la variable SQLERROR tomaria el valor True
    
    -- Aqui es donde acabaria la transaccion ya sea por commit o por rollback
	if SQLERROR = FALSE then 
		commit;
        select 'La transaccion fue ejecutada' as RESULTADO;
	else
		rollback;
        select 'La transaccion NO fue ejecutada' as RESULTADO;
	end if;
	
END //

delimiter ; 

call transacciones;

select * from tmppersonas;

-- ATENCION!!! HE DESABILITADO EL AUTO COMMIT DESDE EL BOTON CON EL TILDE AZUL. AHORA TENGO UN BOTON DE COMMIT Y OTRO DE ROLLBACK

delete from tmppersonas;

## Manejo de errores EN ORACLE

-- Whenever Sqlerror Exit Sql.Sqlcode;
