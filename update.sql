-- PRUEBA DE CARGA DE DATOS PARA CORREGIR FECHA DE EMPLOYEE_HIRE_DATE 

--INSERT INTO empleado (employee_id, employee_name, employee_surname, employee_hire_date, employee_dni, branch_id) values (1, 'Juancito', 'Perez', '29/07/2022', '23192755', 2) 

--UPDATE empleado 
--SET employee_hire_date =  ('29/07/2022')

--SELECT * from empleado

UPDATE empleado
SET employee_hire_date = (substr(employee_hire_date, 7, 4) || '-' || substr(employee_hire_date, 4, 2) || '-' || substr(employee_hire_date, 1, 2)) 
WHERE employee_hire_date <> ''

