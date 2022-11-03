# Funciones habituales

select TRUNC(SYSDATE) from dual; 

# Tratamiento de nulos y decode 

select DECODE(NVL(campo,0),0,'valor para cero', 'valor para diferente de cero') INDICADOR from dual;

select TO_CHAR(TO_DATE('&2', 'YYYYMMDD') + 1, 'YYYYMMDD') from dual; -- convierte a fecha una cadena, le suma un dia y lo vuelve a convertir a cadena

SELECT TO_CHAR(TO_DATE(MAX(fecha),'YYYYMMDD')+1,'YYYYMMDD')
   INTO FECHA_INICIO -- da un nombre al campo/columna 
   FROM tabla;

select TO_NUMBER(numeroencaracter) from dual;

   select * from ALL_TAB_PARTITIONS; -- para ver las particiones de las tablas
   
# Comparador igual es = 
# Concatenar || 
# asignacion :=

# ESTRUCTURAS 

CREATE OR REPLACE PACKAGE BODY paquete  AS

	PROCEDURE nombreProcedimiento() IS
	BEGIN
		--
        RETURN; -- Sale del procedimiento o funcion sin continuar la ejecucion de las siguientes instrucciones RETURN 9; -- Para saber por donde ha salido<

	END nombreProcedimiento;
-- Los procedimientos por defecto devuelven un valor 0 que indica que todo ha ido bien.
   
END paquete;
/

WHILE condicion  LOOP

END LOOP;

IF condicion THEN

ELSE

END IF;
   
FOR i IN 1 .. n
	LOOP
         BEGIN
           
            -- EXIT  -- Eventualmente puedo necesitar abandonar el bucle y continuar con la siguiente sentencia 
         END;
	END LOOP;
      
      
      # Excepciones
 EXCEPTION
     WHEN NO_DATA_FOUND THEN -- cuando no hay datos
          -- ;
    WHEN TOO_MANY_ROWS THEN -- cuando hay mas de un registro
		 --;
    WHEN OTHERS THEN 
		NULL; -- ignora cualquier error/excepcion. Ante cualquiera de estas, el procedimiento acabara correctamente
  END;

   -- ejemplo de excepcion
   BEGIN
    SELECT MAX(SEGMENTO_01_ID)
    INTO lIdSegmento
    FROM RE_SEGMENTO_C
    WHERE SEGMENTO_01_ID < 900;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      lIdSegmento := 0;
  END;

   
#  EXECUTE IMMEDIATE  cadena_sentencia;
#  EXEC procedimiento;

#	DBMS_OUTPUT.PUT_LINE ('');
    
 CREATE UNIQUE INDEX nom_indice ON nom_tabla (nom_campo);




    
