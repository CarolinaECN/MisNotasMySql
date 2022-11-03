-- ORDEN DE LOS DISTINTOS APARTADOS DE UNA CONSULTA
select 
from
where
group by
having
order by;


-- EJEMPLOS DE SELECT 
SELECT nombre, correo FROM personas order by nombre desc;

select concat(nombre,' - ',correo) from personas; -- para concatenar campos

-- regresa fecha de entrada o salida de dinero, el monto de entrada o salida de la tabla entradaSalidaDinero, 
-- donde la fecha este entre el 1 de enero de 2018 y el 31 de enero del mismo año ordenados por fecha ascendente
SELECT fechaES, montoIE 
FROM entradasalidadinero 
WHERE fechaES between '2018/01/01' and '2018/01/31'
ORDER BY fechaES asc; 

-- regresa los registros de la tabla entradaSalidaDinero cuyo monto sea mayor o igual a 500, y 
-- ese monto se muestra multiplicado por 2
select fechaES, montoIE, montoIE*2 as montoX2 from entradasalidadinero where montoIE >= 500;  

-- realizamos una consulta del ingresoegreso con id = 21 y con el aplicamos los diferentes operadores 
-- aritmeticos básicos (MOD residuo de la division, DIV parte entera de la division) 
select idIngresosEgresos, montoIE, montoIE div 2 as 'parte_entera', montoIE mod 2 as 'residuo'
from entradaSalidaDinero
where id=368;

-- hacemos uso de parentesis en operacion aritmetica para demostrar la presedencia
select idIngresosEgresos, montoIE, montoIE + 2 * 3 as sinParentesis, -- aqui ejecutara segun precedencia aritmetica 
       (montoIE + 2) * 3 as conParentesis -- si quiero calcular en otro orden tengo que utilizar los parentesis
from entradaSalidaDinero 
where id=21;

-- Realiza un ejemplo con la tabla personas en la cual concatenas tres campos y una funcion propia de mysql
-- ademas utiliza las apostrofes dentro de la cadena para demostrar como se utilizan.
-- now() es la fecha actual
select id, now(), concat(nombre,', "tel: ',telefono, ' ", mail: "', correo) as campoConcatenado from personas;

 -- Hacer uso de las tres funciones antes explicadas, dar formato a campo de fecha, 
 -- extraer los 10 primeros caracteres de un campo de base de datos llamado observaciones y por ultimo
 -- redondear un dato numerico en tres diferenes formatos con información de la tabla entradaSalidaDinero
 -- formato de fecha
 select id, fechaES, date_format(fechaES, '%d/%m/%y') as fecha_simple, -- y año en dos digitos Y en cuatro
		date_format(fechaES, '%e-%b-%Y') as fecha_guay, left(observaciones,10) observaciones,
        round(montoIE) as redondeo, montoIE, round(montoIE, 1) as redondeo1dec
        from entradasalidadinero where id>500; 
        

-- sentencia DISTINCT 
SELECT distinct date_format(fechaES, '%Y%m%d') dias_diferentes FROM entradasalidadinero;

select distinct year(fechaES) as años from entradasalidadinero;
select distinct fechaES, year(fechaES) as años from entradasalidadinero; -- la dupla distinta
select count(distinct year(fechaES)) as cant_años from entradasalidadinero;
SELECT count(distinct fechaES) cuantos FROM entradasalidadinero;

select distinct(idEstadoPendiente), e.estado from pendiente p, estadopendiente e 
where p.idEstadoPendiente=e.id;

-- CLAUSULA WHERE
select * from personas where left(telefono,2)='49';
select * from personas where substr(telefono,2,1)='7';
select * from personas where id<>5; 
select * from personas where id!=5; 
-- con fechas 
select * from entradasalidadinero where fechaES='2018-01-02'; -- año, mes, dia en este orden
select * from entradasalidadinero where fechaES='2018/01/02';

select * from entradasalidadinero where montoIE*2<500;
select nombre, instr(nombre,'A') from personas; -- instr() indica la primera posicion del caracter en la cadena
select nombre from personas where instr(nombre,' ')>1;
-- operador substr(cadena, desde, hasta) devuelve la subcadena e instr(cadena, caracter) devuelve posicion
select substr(nombre, 1, instr(nombre,' ')-1) nombre_de_pila, nombre from personas; 
select nombre, left(nombre,1) from personas where left(nombre, 1)<='L'; -- operador <= y left()
select * from personas where id mod 2 = 0 or left(telefono,3)='444'; -- operador or
select * from personas where not left(telefono, 3)='493'; -- operador not
select instr('aabc','a');
-- operador IN 
select * from personas where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES');
select * from personas where id not in (1,2,3,4);
-- subconsultas
select * from personas where id not in (select id from personas  where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES') );
select * from entradasalidadinero where idPersonas in (select id from personas  where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES') );
-- Operador between 
select * from entradasalidadinero where fechaES between '2018-01-01' and '2018-12-31' and montoIE between 100 and 2000;
select nombre from personas where left(nombre, 1) between 'A' and 'J' order by left(nombre, 1);

-- Expresiones regulares REGEXP 
select nombre from personas where nombre regexp 'SA';
select nombre from personas where nombre regexp '^MA'; -- alt94 ^ empiezan con la cadena
select nombre from personas where nombre regexp 'e$'; -- terminan con la cadena (la collate es case insensitive)
select nombre from personas where nombre regexp 're|se'; -- cadenas que contengan 're' o 'se'
select nombre from personas where nombre regexp 'r[a,i]'; -- que contenga r y a continuacion a o i
select nombre from personas where nombre regexp 'b[a-t]'; -- que contenda b y a continuacion una letra entre a y t
select nombre from personas where nombre regexp 'mar[t,S]'; -- que contenga mar y a continuacion una T o una S
select * from personas where nombre regexp 'ch[a,e][z]'; -- que contenga ch luego una a o e y luego una Z
select * from personas where nombre regexp 'c[a,e,i,o,u][a,e,i,o,u]$'; -- una c, luego vocal, luego vocal y que este todo al final
select * from personas where nombre regexp '[a-z][aeiou]s$'; -- una letra cualquiera, seguida de vocal, seguida de s y que esta subcadena este al final de la cadena

-- clausula like 
select nombre from personas where nombre like 'Man%'; -- no es case sensitive el % indica 'cualquier cadena'
select nombre from personas where nombre like '%ar%'; 
select nombre from personas where nombre like '%pa__a%'; -- el guion bajo indica cualquier caracter
select nombre from personas where nombre like '%chez'; -- que terminen con 'chez'
select nombre from personas where nombre like '_______________________'; -- nombres con 23 caracteres 
select nombre from personas where length(nombre)=23; -- es equivalente a lo anterior 

 SELECT nombre, correo FROM personas order by nombre desc;

-- regresa fecha de entrada o salida de dinero, el monto de entrada o salida de la tabla entradaSalidaDinero, 
-- donde la fecha este entre el 1 de enero de 2018 y el 31 de enero del mismo año ordenados por fecha ascendente
SELECT fechaES, montoIE 
FROM entradasalidadinero 
WHERE fechaES between '2018/01/01' and '2018/01/31'
ORDER BY fechaES asc; 

-- regresa los registros de la tabla entradaSalidaDinero cuyo monto sea mayor o igual a 500, y 
-- ese monto se muestra multiplicado por 2
select fechaES, montoIE, montoIE*2 as montoX2 from entradasalidadinero where montoIE >= 500;  

-- realizamos una consulta del ingresoegreso con id = 21 y con el aplicamos los diferentes operadores 
-- aritmeticos básicos (MOD residuo de la division, DIV parte entera de la division) 
select idIngresosEgresos, montoIE, montoIE div 2 as 'parte_entera', montoIE mod 2 as 'residuo'
from entradaSalidaDinero
where id=368;

-- hacemos uso de parentesis en operacion aritmetica para demostrar la precedencia
select idIngresosEgresos, montoIE, montoIE + 2 * 3 as sinParentesis,
       (montoIE + 2) * 3 as conParentesis
from entradaSalidaDinero 
where id=21;

-- Realiza un ejemplo con la tabla personas en la cual concatenas tres campos y una funcion propia de mysql
-- ademas utiliza las apostrofes dentro de la cadena para demostrar como se utilizan.
-- now() es la fecha actual
select id, now(), concat(nombre,', "tel: ',telefono, ' ", mail: "', correo) as campoConcatenado from personas;

 -- Hacer uso de las tres funciones antes explicadas, dar formato a campo de fecha, 
 -- extraer los 10 primeros caracteres de un campo de base de datos llamado observaciones y por ultimo
 -- redondear un dato numerico en tres diferenes formatos con información de la tabla entradaSalidaDinero
 -- formato de fecha, round()
 select id, fechaES, date_format(fechaES, '%d/%m/%y') as fecha_simple,
		date_format(fechaES, '%e-%b-%Y') as fecha_guay, left(observaciones,10) observaciones,
        round(montoIE) as redondeo, montoIE, round(montoIE, 1) as redondeo1dec
        from entradasalidadinero where id>500; 
        
-- VARIABLES DE ENTORNO FECHA current_date() y now() son la fecha actual pero tienen diferentes funcionalidades
select current_date() fecha_actual, date_format(current_date(), '%D-%M-%Y') as hoy;

-- concatenando cadenas 
select left(concat("HOLA A TODOS","BUENOS DIAS"), 12) AS CADENA;

-- redondeando numeros decimales 
select 10*3 as a, round(567.3456, 3) r;

-- sentencia DISTINCT 
SELECT distinct date_format(fechaES, '%Y%m%d') dias_diferentes FROM entradasalidadinero;

select distinct year(fechaES) as años from entradasalidadinero;
select count(distinct year(fechaES)) as cant_años from entradasalidadinero;
SELECT count(distinct fechaES) cuantos FROM entradasalidadinero;

select distinct(idEstadoPendiente) from pendiente;

-- CLAUSULA WHERE
select * from personas where left(telefono,2)='49';
select * from personas where substr(telefono,2,1)='7';
select * from personas where id<>5;
select * from personas where id!=5; # <> ~!=
-- con fechas 
select * from entradasalidadinero where fechaES='2018-01-02'; -- año, mes, dia en este orden
select * from entradasalidadinero where fechaES='2018/01/02';

select * from entradasalidadinero where montoIE*2<500;
select nombre, instr(nombre,'A') from personas; -- instr() indica la primera posicion del caracter en la cadena
select nombre from personas where instr(nombre,' ')>7;
-- operador substr(cadena, desde, hasta) devuelve la subcadena e instr(cadena, caracter) devuelve posicion
select substr(nombre, 1, instr(nombre,' ')-1) nombre_de_pila, nombre from personas; 
select nombre, left(nombre,1) from personas where left(nombre, 1)<='L'; -- operador <= y left()
select * from personas where id mod 2 = 0 or left(telefono,3)='444'; -- operador or
select * from personas where not left(telefono, 3)='493'; -- operador not
select instr('aabc','a');
-- operador IN 
select * from personas where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES');
select * from personas where id not in (1,2,3,4);
-- subconsultas
select * from personas where id not in (select id from personas  where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES') );
select * from entradasalidadinero where idPersonas in (select id from personas  where nombre in ('GILBERTO ESPARZA TORRES','LUZ ELENA GONZALES MARES') );
-- Operador between 
select * from entradasalidadinero where fechaES between '2018-01-01' and '2018-12-31' and montoIE between 100 and 2000;
select nombre from personas where left(nombre, 1) between 'A' and 'J' order by left(nombre, 1);

-- Expresiones regulares REGEXP 
select nombre from personas where nombre regexp 'SA';
select nombre from personas where nombre regexp '^MA'; -- alt94 ^ empiezan con la cadena
select nombre from personas where nombre regexp 'e$'; -- terminan con la cadena
select nombre from personas where nombre regexp 're|se'; -- cadenas que contengan 're' o 'se'
select nombre from personas where nombre regexp 'r[a,i]'; -- que contenga r y a continuacion a o i
select nombre from personas where nombre regexp 'b[a-t]'; -- que contenda b y a continuacion una letra entre a y t
select nombre from personas where nombre regexp 'mar[t,S]'; -- que contenga mar y a continuacion una T o una S
select * from personas where nombre regexp 'ch[a,e][z]'; -- que contenga ch luego una a o e y luego una Z
select * from personas where nombre regexp 'c[a,e,i,o,u][a,e,i,o,u]$'; -- una c, luego vocal, luego vocal y que este al final
select * from personas where nombre regexp '[a-z][aeiou]s$'; -- una letra cualquiera, seguida de vocal, seguida de s y que esta subcadena este al final de la cadena
-- clausula like 
select nombre from personas where nombre like 'Man%'; -- no es case sensitive el % indica 'cualquier cadena'
select nombre from personas where nombre like '%ar%'; 
select nombre from personas where nombre like '%pa__a%'; -- el guion bajo indica cualquier caracter (solo uno)
select nombre from personas where nombre like '%chez'; -- que terminen con 'chez'
select nombre from personas where nombre like '_______________________'; -- nombres con 23 caracteres 
select nombre from personas where length(nombre)=23; -- es equivalente a lo anterior 

-- datos nulos 
select * from ingresosegresos where observaciones is null; -- notese que es diferente a:
select * from ingresosegresos where observaciones=''; -- una cosa es el valor null y otra una cadena vacia
select * from ingresosegresos where observaciones is not null;

-- cambio algunos datos a nulo porque no habia ninguno
update ingresosegresos set observaciones = null where id<=10;
commit;
-- 
replace into ingresosegresos (observaciones) values ('',null); -- no me ha dejado 
update ingresosegresos set observaciones=null where observaciones='';
select distinct observaciones from ingresosegresos; -- hay nulos y vacios
rollback;

-- el ORDER BY
select * FROM entradasalidadinero 
WHERE fechaES BETWEEN '2018-03-01' AND '2018-03-10' ORDER BY fechaES ASC, idPersonas DESC;
-- diferencia de fechas 
select fechaES, datediff(now(), fechaES) as plazo  from entradasalidadinero order by plazo desc;
select fechaES, datediff(now(), fechaES) as plazo  from entradasalidadinero order by 2 desc; -- equivalente indica columna 2 del select

-- si quiero dar un orden particular indicado como lo quiero funcion FIELD()
use dbemployees;
select * from employees order by field(gender,'M','F');
select * from employees order by field(gender,'F','M'); 
-- ordeno a mi modo, no hace falta colocar todos los dif valores, el resto van a continuacion sin ningun orden

-- Limitar la cantidad de filas devueltas por la consulta LIMIT
SELECT * FROM usuarios order by idPersonas limit 5; -- solo devuelve los 5 primeros
select * from usuarios order by idPersonas limit 2,3; -- despreciara los 2 primeros y a partir del 3to arrojara 3 filas

select * from usuarios ;

-- Tratamiento de nulos

use bdpendientes;
SELECT
  (CASE 
    WHEN observaciones IS NULL THEN 'no hay observaciones' 
    ELSE observaciones
  END) observaciones
from ingresosegresos;

select count(distinct observaciones) from ingresosegresos; -- Contabiliza vacios y nulos como la misma cosa
select distinct observaciones from ingresosegresos; -- son nulos y vacios pero los considera iguales cuando los cuenta

SELECT
  IF(observaciones is null, 'no hay observaciones', observaciones)  observaciones
from ingresosegresos;

SELECT
  IF(observaciones, '', 'observaciones vacias')  observaciones
from ingresosegresos; -- no puedo tratar vacias y nulas por separado de esta manera


-- Hago dos CASE anidados uno tratara los nulos y el otro las cadenas vacias. Esta consulta si que funciona bien.
SELECT observaciones OBS1,
	CASE
    WHEN
		  (CASE 
			WHEN observaciones is NULL THEN 'no hay observaciones' -- no funciona ¿?
			ELSE observaciones
			END) = '' THEN 'Observaciones vacias'
	ELSE 
			(CASE 
			WHEN observaciones is NULL THEN 'no hay observaciones' -- no funciona ¿?
			ELSE observaciones
			END)
	END OBS2
from ingresosegresos;

-- uso de CASE (sirve como decode)
use dbemployees;
select gender, 
		case 
        when gender='M' then 'Masculino'
        when gender='F' then 'Femenino'
        else 'Sin dato'
        end as Genero
from employees;


-- SELECT CON MAS DE UNA TABLA (JOIN)

SELECT entradasalidadinero.fechaES, entradasalidadinero.montoIE, personas.nombre 
FROM entradasalidadinero inner join personas on entradasalidadinero.idpersonas=personas.id;

SELECT entradasalidadinero.fechaES, entradasalidadinero.montoIE,
		personas.nombre, 
        ingresosEgresos.descripcion
FROM entradasalidadinero 
inner join personas on entradasalidadinero.idpersonas=personas.id
inner join ingresosEgresos on entradasalidadinero.idIngresosEgresos=ingresosEgresos.id;

SELECT entradasalidadinero.fechaES, entradasalidadinero.montoIE,
		personas.nombre, 
        ingresosEgresos.descripcion,
        tipoingeg.descripcion as desc_ingreso
FROM entradasalidadinero 
inner join personas on entradasalidadinero.idpersonas=personas.id
inner join ingresosEgresos on entradasalidadinero.idIngresosEgresos=ingresosEgresos.id
inner join tipoIngEg on ingresosegresos.idTipoIngEg = tipoIngEg.id;

SELECT entradasalidadinero.fechaES, entradasalidadinero.montoIE,
		personas.nombre, 
        ingresosEgresos.descripcion,
        tipoingeg.descripcion as desc_ingreso,
        grupoingeg.descripcion desc_grupo
FROM entradasalidadinero 
inner join personas on entradasalidadinero.idpersonas=personas.id
inner join ingresosEgresos on entradasalidadinero.idIngresosEgresos=ingresosEgresos.id
inner join tipoIngEg on ingresosegresos.idTipoIngEg = tipoIngEg.id
inner join grupoingeg on ingresosegresos.idGrupoIngEg=grupoingeg.id;

-- utilizando alias de tablas para reducir la consulta
-- importante!!!! SI UTILIZAMOS ALIAS DEBEMOS HACERLO EN TODA LA CONSULTA
SELECT ES.fechaES, ES.montoIE,
		P.nombre, 
        IE.descripcion,
        T.descripcion as desc_ingreso,
        G.descripcion desc_grupo
FROM entradasalidadinero ES
inner join personas P on ES.idpersonas = P.id
inner join ingresosEgresos IE on ES.idIngresosEgresos = IE.id
inner join tipoIngEg T on IE.idTipoIngEg = T.id
inner join grupoingeg G on IE.idGrupoIngEg = G.id;

-- CONSULTAS ENTRE BASES DE DATOS DIFERENTES (solo hay que indicar nombreBD.nombreTABLA.nombre.CAMPO de la BD externa)
-- las bases de datos DEBEN ESTAR EN EL MISMO SERVIDOR y por supuesto TENER PERMISOS
use dbemployees;

select bdpendientes.personas.id, bdpendientes.personas.nombre,
		employees.hire_date,
        salaries.salary
from bdpendientes.personas
	inner join employees on employees.emp_no = bdpendientes.personas.id 
    inner join salaries on employees.emp_no = salaries.emp_no
where employees.emp_no in (1,4);

USE bdpendientes;

alter table personas add column idJefe int ;
update personas set idJefe=1 where id not in (2,3,6,7,9,10);

-- CONSULTA SELF JOIN de una tabla consigo misma 
-- en la misma tabla de personas algunas son jefes de otras (necesito alias para no liarla)
select empleados.id, empleados.nombre,  jefe.nombre as nombre_jefe
from personas empleados
inner join personas jefe on empleados.idJefe=jefe.id; -- la tabla se referencia a si misma

select * from personas;

-- LEFT JOIN y RIGHT JOIN

USE DBEMPLOYEES;

select bdpendientes.personas.id, bdpendientes.personas.nombre,
		employees.hire_date
from bdpendientes.personas
	LEFT JOIN employees on employees.emp_no = bdpendientes.personas.id ;
-- Trae todos los registros de personas tengan o no tengan correspondencia en employees completando los campos con NULOS

-- para que no me traiga los campos NULOS de la tabla de empleados
select bdpendientes.personas.id, bdpendientes.personas.nombre,
	(CASE 
    WHEN employees.hire_date is NULL THEN 0 -- Reemplazo los nulos por 0
    ELSE employees.hire_date
  END) hire_date -- employees.hire_date,
from bdpendientes.personas
	LEFT JOIN employees on employees.emp_no = bdpendientes.personas.id ;

select bdpendientes.personas.id, bdpendientes.personas.nombre,
		employees.hire_date
from bdpendientes.personas
	RIGHT JOIN employees on employees.emp_no = bdpendientes.personas.id ;
-- en este caso trae todos los registros de employees aunque no tengan correspondencia en personas completando los campos con nulos

-- completo los nulos en personas
select bdpendientes.personas.id, 
			case 
			when bdpendientes.personas.nombre is null then 'No existe en personas'
			else bdpendientes.personas.nombre
			end as nombre,
		employees.hire_date
from bdpendientes.personas
	RIGHT JOIN employees on employees.emp_no = bdpendientes.personas.id ;

-- USING EN JOINS cuando las tablas tienen el mismo campo en comun (mismo nombre de campo de join)

select count(*)
from employees
inner join salaries using (emp_no)
where emp_no between 10010 and 10020;
-- ESTO ES EQUIVALENTE A 
select count(*)
from employees
inner join salaries ON  employees.emp_no = salaries.emp_no
where employees.emp_no between 10010 and 10020;

-- Hacer el JOIN mediante WHERE 
 -- con  joins
 SELECT count(*)
FROM entradasalidadinero ES
inner join personas P on ES.idpersonas = P.id
inner join ingresosEgresos IE on ES.idIngresosEgresos = IE.id
inner join tipoIngEg T on IE.idTipoIngEg = T.id
inner join grupoingeg G on IE.idGrupoIngEg = G.id;
-- con where
 SELECT COUNT(*)
FROM entradasalidadinero ES,  personas P, ingresosEgresos IE, tipoIngEg T, grupoingeg G
WHERE ES.idpersonas = P.id AND
	ES.idIngresosEgresos = IE.id AND 
	IE.idTipoIngEg = T.id AND
    IE.idGrupoIngEg = G.id;
    
-- sentencia UNION para hacer la union es necesario que los campos del select sean del mismo tipo
-- si no se especifica ningun parametro el union eliminara duplicados
-- IMPORTANTE: si se quiere que traiga todo aunque sean repetidos indicar ALL
SELECT ID, NOMBRE FROM PERSONAS
union 
SELECT ID, concat(NOMBRE,' ',APATERNO,' ', AMATERNO) NOMBRE_COMPLETO FROM CLIENTES;
-- se puede utilizar para simplificar consultas complejas

-- SUBQUERIES se pueden utilizar en:
		-- WHERE
        -- HAVING (esta sentencia es el where de un group by, una vez que agrupa verifica la condicion en los datos agrupados)
        -- FROM
		-- SELECT 
 -- recordar encerrar la subquery entre ()
 
-- SUBQUERY en WHERE
select * from entradasalidadinero where montoIE > (select avg(montoIE) from entradasalidadinero );

-- SUBQUERY en SELECT y en WHERE
select montoIE, (select ROUND(avg(montoIE)) from entradasalidadinero ) Promedio FROM entradasalidadinero
		 where montoIE > (select avg(montoIE) from entradasalidadinero );
         
-- SUBQUERY en FROM
SELECT * FROM CLIENTES, (select id from clientes where municipio='RIO GRANDE') clientes_RG
where clientes.id = clientes_RG.id; -- esta consulta no es nada eficiente pero se puede hacer

-- otro ejemplo de subquery en where 
select * from entradasalidadinero where idPersonas in
(select id from personas where nombre like 'JUAN%');
-- si quisiera listar algun campo de la tabla personas tendria que hacer un inner join puesto que en la 
-- consulta padre no tengo disponibles los campos de la subconsulta.
select entradasalidadinero.*, personas.nombre 
from entradasalidadinero 
inner join personas on personas.id=entradasalidadinero.idPersonas
where nombre like 'JUAN%';
-- por ultimo se puede resolver con una consulta simple
select entradasalidadinero.*, personas.nombre 
from entradasalidadinero, personas
where personas.id=entradasalidadinero.idPersonas
and nombre like 'JUAN%';
-- las tres formas anteriores son equivalentes, arrojan los mismos datos

-- clausula ALL
select * from entradasalidadinero 
where montoIE < all (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- debe ser menor a todos 
select * from entradasalidadinero 
where montoIE > all (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- deben ser mayores a todos los del subconjunto
select * from entradasalidadinero 
where montoIE = all (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- igual a todos (esto no lo veo es confuso)
select * from entradasalidadinero 
where montoIE <> all (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- distinto a todos 
-- tener cuidado en caso de que la subquery no de resultados, entonces se mostraran todos los datos

-- ANY  SOME son equivalentes 
select * from entradasalidadinero 
where montoIE < any (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- debe ser menor a alguno 
select * from entradasalidadinero 
where montoIE > any (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- deben ser mayores a alguno de los valores de la subconsulta
select * from entradasalidadinero 
where montoIE = any (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- igual a alguno 
select * from entradasalidadinero 
where montoIE <> any (select montoIE from entradasalidadinero where idIngresosEgresos=1);
-- distinto a alguno de la lista. En este caso me muestra todos porque igual a todos no puede ser. Es confuso.
-- Es mejor que la subconsulta arroje solo uno o pocos resultados para poder visualizarlo y no cometer errores
-- tener cuidado en caso de que la subquery no de resultados, entonces NO se mostraran datos

-- seleccionamos de la tabla de movimientos aquellos registros que por cada persona superen su promedio
-- podemos utilizar una subconsulta tanto en el select como en el where, con pocos datos no deberia tener problemas.
select per.idPersonas, personas.nombre, per.montoIE, 
		(select round(avg(prom.montoIE)) from  entradasalidadinero prom where  per.idPersonas=prom.idPersonas) promedio
from entradasalidadinero per, personas
where  personas.id=per.idPersonas
and per.montoIE>(select avg(prom.montoIE) from  entradasalidadinero prom where  per.idPersonas=prom.idPersonas);


-- operador EXIST / NOT EXIST
-- no significa que el reg que compara no exista en la lista sino que NO hay nada en la lista

select * from personas where not exists (select * from usuarios where personas.id=usuarios.idPersonas);
-- id todos menos del 2 al 5 OK!
select distinct idpersonas from usuarios;  -- del 2 al 5

-- tabla virtual, se ejecuta en linea al momento de la ejecucion de la consulta, 
-- es un select en el from con un alias que funciona como una tabla
select montos.*, usuarios.nombre from 
(select personas.id, personas.nombre,  sum(montoIE) total
from personas
inner join entradasalidadinero on (personas.id=entradasalidadinero.idpersonas)
group by 1,2) montos
inner join usuarios on idpersonas=montos.id;

-- uso de CTE (common table expression) es para crear las TABLAS VIRTUALES previo a la query principal
-- Se ejecutan las dos juntas
WITH monto AS 
(select personas.id, personas.nombre,  sum(montoIE) total
from personas
inner join entradasalidadinero on (personas.id=entradasalidadinero.idpersonas)
group by 1,2) -- , y se podrian poner mas tablas virtuales

select monto.*, usuarios.nombre 
from monto 
inner join usuarios on usuarios.idpersonas=monto.id;

-- FUNCIONES DE AGREGADO/AGRUPACION

SELECT  'Fecha > 2018', count(distinct(idPersonas)) 'Personas', count(*) 'Cantidad', 
		round(avg(montoie)) 'Promedio' , round(sum(montoIE)) 'Total', min(montoie) Minimo, max(montoIE) 'Maximo'
FROM entradasalidadinero
WHERE year(FECHAES)>2018;
-- En este caso solo tenemos una agrupacion

-- A los datos de tipo varchar tambien se le pueden aplicar max y min
select Min(nombre), max(nombre) from personas;


SELECT PERSONAS.NOMBRE, IE.DESCRIPCION, COUNT(*) CANTIDAD_LINEAS, SUM(ES.MONTOIE) SUMA
FROM entradasalidadinero ES
INNER JOIN INGRESOSEGRESOS IE ON idIngresosEgresos=IE.ID
INNER JOIN PERSONAS PERSONAS ON PERSONAS.ID=IDPERSONAS
WHERE PERSONAS.ID<8 -- ESTA CONDICION SE EJECUTA ANTES DE AGRUPAR
GROUP BY PERSONAS.NOMBRE, IE.DESCRIPCION
HAVING SUMA>1000 AND CANTIDAD_LINEAS=2 -- ESTA CONDICION SE EJECUTA UNA VEZ SE AGRUPAN LOS DATOS
ORDER BY PERSONAS.NOMBRE;

SELECT SUM(MONTOIE) FROM entradasalidadinero; -- 877025.61 

SELECT SUM(MONTOIE)
FROM entradasalidadinero ES
INNER JOIN INGRESOSEGRESOS IE ON idIngresosEgresos=IE.ID
INNER JOIN PERSONAS PERSONAS ON PERSONAS.ID=IDPERSONAS; -- 877025.61

-- sentencia WITH ROLLUP que acompaña al group by 
-- sirve para poner informacion de resumen para cada agrupado y para el final

SELECT COUNT(*) CANTIDAD_LINEAS, SUM(ES.MONTOIE) SUMA
FROM entradasalidadinero ES
INNER JOIN INGRESOSEGRESOS IE ON idIngresosEgresos=IE.ID
INNER JOIN PERSONAS PERSONAS ON PERSONAS.ID=IDPERSONAS;

-- 510	877025.61 

SELECT  personas.nombre, IE.descripcion, COUNT(*) 'CANTIDAD_LINEAS', SUM(ES.MONTOIE) 'SUMA'
FROM entradasalidadinero ES
INNER JOIN INGRESOSEGRESOS IE ON idIngresosEgresos=IE.ID
INNER JOIN PERSONAS PERSONAS ON PERSONAS.ID=IDPERSONAS
GROUP BY  personas.nombre, IE.descripcion
WITH ROLLUP; -- hace subtotales por nombre y el total general 
-- 877025.61 este es el resumen final que coincide con la suma que hice antes 
-- TENER CUIDADO CON EL HAVING!! Tiene problemas conjuntamente con WITH ROLLUP 

-- OPERADOR GROUPING
-- para que queden mejor los subtotales y el total general. Es meramente estetico.

SELECT  personas.nombre, IE.descripcion, 
	if(grouping(personas.nombre)=1,'Total Gral','') as total_gral,
	if(grouping(ie.descripcion)=1,'Total del Grupo','') as total_grupo,
COUNT(*) 'CANTIDAD_LINEAS', SUM(ES.MONTOIE) 'SUMA'
FROM entradasalidadinero ES
INNER JOIN INGRESOSEGRESOS IE ON idIngresosEgresos=IE.ID
INNER JOIN PERSONAS PERSONAS ON PERSONAS.ID=IDPERSONAS
GROUP BY  personas.nombre, IE.descripcion
WITH ROLLUP;

-- OPERADOR OVER (windows functions)
-- Sirve para hacer calculos sobre todas las filas que devuelve la consulta y muestra en cada fila ese calculo
select sum(montoIE)
from entradasalidadinero
where year(fechaES)=2018 and month(fechaES)=1;  -- resultado 107680.00

select idPersonas, montoIE, sum(montoIE) over() as TotalMonto -- devuelve el resultado total 107680.00 en cada fila 
from entradasalidadinero
where year(fechaES)=2018 and month(fechaES)=1
order by idPersonas;

 select idPersonas, sum(montoIE), sum(montoIE) over() as TotalMonto
from entradasalidadinero
where year(fechaES)=2018 and month(fechaES)=1
group by idPersonas
order by idPersonas; -- aqui sale algo raro no trae la suma del monto total al hacer el group by

-- los subtotales se hacer de esta manera
select idPersonas, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total 35 en cada fila
    sum(montoIE) over(partition by idpersonas) as TotalPorPersona -- devuelve un subtotal por cada persona
from entradasalidadinero
where year(fechaES)=2018 and month(fechaES)=1; 

select idPersonas, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total
    sum(montoIE) over(partition by idpersonas order by montoIE desc) as TotalPorPersona -- se le puede indicar un orden por grupo en este caso por monto.
from entradasalidadinero						-- ademas devuelve un subtotal por cada persona, realizando el ACUMULADO
where year(fechaES)=2018 and month(fechaES)=1; 

select idPersonas, fechaES, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total
    count(*) over(partition by idpersonas) CantPersona, -- agrego cantidad por persona
    sum(montoIE) over(partition by idpersonas order by montoIE desc) as TotalPorPersona -- se le puede indicar un orden por grupo en este caso por monto.
from entradasalidadinero											--  devuelve un subtotal por cada persona, realizando el ACUMULADO
where year(fechaES)=2018 and month(fechaES)=1; 

-- agrego inner joins
select idPersonas, personas.nombre, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total
    count(*) over(partition by idpersonas) CantPersona,
    sum(montoIE) over(partition by idpersonas order by montoIE desc) as TotalPorPersona -- se le puede indicar un orden por grupo en este caso por monto.
from entradasalidadinero													-- devuelve un subtotal por cada persona, realizando el ACUMULADO
inner join personas on idPersonas=personas.id													
where year(fechaES)=2018 and month(fechaES)=1; 

select idPersonas, personas.nombre, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total
    count(*) over(partition by idpersonas) CantPersona,
    sum(montoIE) over(partition by idpersonas order by montoIE desc
    rows between unbounded preceding and current row) as TotalPorPersona --  esto dice que es para hacer el acumulado pero la anterior consulta ya cumulaba
from entradasalidadinero	
inner join personas on idPersonas=personas.id													
where year(fechaES)=2018 and month(fechaES)=1; 

-- una ligera modificacion a la anterior consulta
-- en lugar de rows indica range y cambia el order by a fecha
-- esto hace que el subtotal lo haga por fecha en lugar de por monto, y en caso de fecha repetida la suma queda bien indicada por la fecha
-- ver personaid=2 fecha 2018/01/07
select idPersonas, personas.nombre, fechaES, montoIE, 
	sum(montoIE) over() as TotalMonto, -- devuelve el resultado total 107680.00 en cada fila 
    count(*) over() Cantidad, -- devuelve la cantidad de filas total
    count(*) over(partition by idpersonas) CantPersona,
    sum(montoIE) over(partition by idpersonas order by fechaES desc
    range between unbounded preceding and current row) as TotalPorPersona --  esto dice que es para hacer el acumulado pero la anterior consulta ya cumulaba
from entradasalidadinero	
inner join personas on idPersonas=personas.id													
where year(fechaES)=2018 and month(fechaES)=1; 

select * from detalleventa;

select count(idclientes) tot, count(distinct(idclientes)) sinrepeticion from detalleventa; 

select * from detalleventa where idProductos in (1,3); -- obtener un subconjunto mediante IN 

# Exists
select 'Se vendio el producto', p.nombreproducto from productos p where exists (select 1  from detalleventa d where p.id=d.idproductos);

select 1 from dual; -- para indicar que no hago referencia a ninguna tabla en particular
select last_insert_id(); -- devuelve el ultimo valor insertado para una clave id auto_increment
