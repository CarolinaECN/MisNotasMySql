########################################
## FUNCIONES/OPERADORES DE USO FRECUENTE
########################################

# Operadores de comparacion: = , <> o != , < , >  

# FUNCION PARA CONVERTIR TIPOS DE DATOS

select convert('-22', signed integer) entero;
select convert('22', signed integer) entero;

# TRATAMIENTO DE NULOS

select precioCosto, isnull(precioCosto) from productos; -- comprobacion de nulo. Devuelve 1 si es nulo y 0 si no lo es
select color, isnull(color) from productos; -- son nulos por tanto devuelve 1
select isnull('abc') from dual; -- si no es nulo retorna 0

SELECT IF(precioCosto is null, 0, 1) indicador from productos;

select IF(isnull(precioCosto),'No Tiene precio de Coste','Tiene precio de coste') control from productos; 


# FUNCIONES NUMERICAS

select truncate(312,25) from dual; -- 312

select count(1) cant, count(*) cant, max(precioVenta) max, min(precioVenta) min, avg(precioCosto) prom, sum(existencia) total from productos; 

select montoIE, montoIE div 2 as 'parte_entera', montoIE mod 2 as 'residuo' from entradaSalidaDinero; -- parte entera y resto de la division

select count(idclientes) tot, count(distinct(idclientes)) sinrepeticion from detalleventa; -- contar y contar diferentes

select montoIE, round(montoIE), round(montoIE,1) from entradaSalidaDinero; -- redondeo a entero y a un decimal

-- Funcion over
select idPersonas, montoIE, sum(montoIE) over() as TotalMonto -- devuelve el resultado total gral en cada fila 107680.00
from entradasalidadinero
where year(fechaES)=2018 and month(fechaES)=1
order by idPersonas; 

# Funcion signo 
select sign(10) from productos; -- devuelve 1 si es positivo
select sign(-10) from productos; -- devuelve -1 si es negativo

# Funcion mayor y menor
select greatest(56,67,89); -- el mayor entre los argumentos
select least(56,67,89); -- el menor entre los argumentos 


# FUNCIONES DE FECHA 

select now() from productos; -- FECHA ACTUAL 2022-09-30 09:53:24 

select round(now()) from productos; #20220930082653

select date_format(now(),'%d-%m-%Y') fecha from productos; # 30-09-2022

select year(now()), month(now()), day(now()) from dual; 

select id, fechaES, date_format(fechaES, '%d/%m/%y') as fecha_simple, -- y año en dos digitos Y en cuatro 
		date_format(fechaES, '%e-%b-%Y') as fecha_guay -- 1-Jan-2018
from entradasalidadinero; 

select distinct year(fechaES) as años from entradasalidadinero;

SELECT distinct date_format(fechaES, '%Y%m%d') dias_diferentes FROM entradasalidadinero;

select current_date() fecha_actual, date_format(current_date(), '%D-%M-%Y') as hoy; -- 6th-October-2022

select date(now()) a_fecha from productos; -- 2022-09-30
select date('2022-07-29') a_fecha from productos; -- 2022-07-29 
select date('2022-07-29 09:50:16') a_fecha from productos; -- 2022-07-29 

-- sumar y restar tiempo a una fecha
-- se pueden sumar y restar minutos, horas, dias, semanas, meses, años
select date_add(now(), interval 2 day) from productos; -- 2022-10-02 10:36:18
select date_sub(now(), interval 2 day) from productos; -- 2022-09-28 10:36:54 

select fechaES, datediff(now(), fechaES) as plazo_en_dias  from entradasalidadinero order by 2 desc; 

-- cantidad de dias entre dos fechas
select fechaES, datediff(now(), '20221003') as diferencia_en_dias  from entradasalidadinero order by 2 desc; -- equivalente indica columna 2 del select



## FUNCIONES PARA CADENAS

select * from personas where correo like '%gmail.com';

select nombre, instr(nombre,'A') from personas; -- instr() indica la primera posicion del caracter en la cadena
select substr(nombre, 1, instr(nombre,' ')-1) nombre_de_pila, nombre from personas; 

select max(length(nombreProducto)) from productos;

select nombre, concat(correo,'/',telefono) contacto from personas;

select concat(nombre,' - ',correo) from personas; -- para concatenar campos

select left(nombre,10) from clientes; -- 10 primeros caracteres
select trim(' cadena con espacios ') from dual; -- Elimina espacios delate y detras 
select replace('%cadena con espacios%', '%','') from dual; -- Asi elimino caracteres raros

select substring(nombreCliente, 5, 3) sub, nombreCliente from Clientes; -- subcadena desde hasta
select substring(nombreCliente, 4) sub, nombreCliente from Clientes; -- desde la posicion incluida hasta el final
select substring(nombreCliente, -4) sub, nombreCliente from Clientes; -- desde el final, o sea los ultimos 4 

# Funcion para encontrar caracteres dentro de una cadena
select locate('o', nombreProducto) primeraO, nombreproducto from productos; -- encuentra el caracter en la cadena (primera ocurrencia)

# Funcion para extraer una subcadena de una cadena
select substring(nombreproducto, 2) sub, nombreproducto from productos; -- subcadena desde la posicion N incluida  
select substring(nombreproducto, -2) sub, nombreproducto from productos; -- los dos ultimos caracteres de la cadena 

# Funciones caps
select upper('mayuscula') from dual; -- convierte a mayuscula
select lower('MINUSCULA') from dual; -- convierte a minuscula

# Funcion para relleno
select lpad('cadena',20,0) from dual; -- rellena la cadena a izquierda con el caracter especificado hasta la longitud especificada 
select rpad('cadena',20,0) from dual; -- rellena la cadena a derecha con el caracter especificado hasta la longitud especificada 

-- aqui quito la primera palabra de la cadena 
select locate(' ', nombreProducto) primerespacio, substring(nombreproducto, locate(' ', nombreProducto)+1) sub, nombreproducto from productos;

-- quiero obtener el numero de esta cadena 'Mesa nro 5'
select locate('nro', 'Mesa nro 5')+3; -- tengo que saltar la cadena nro
select substr('Mesa nro 5', locate('nro', 'Mesa nro 5')+4 ) ; -- uno mas para saltarme el espacio 
select convert(substr('Mesa nro 5', locate('nro', 'Mesa nro 5')+4 ), signed integer) ; -- ahora ya puedo convertir a numero entero

# Funcion para especficar un orden diferente al que seria por defecto
use dbemployees;
select * from employees order by field(gender,'M','F');
-- ordeno a mi modo, no hace falta colocar todos los dif valores, el resto van a continuacion sin ningun orden

show variables;


