-- TERCER PROBLEMATICA 

--PUNTO 1 (selecciona las cuentas con saldo negativo)
SELECT *
from cuenta
where balance < 0;

--PUNTO 2 (Selecciona  el nombre, apellido y edad de los clientes que tengan en el apellido la letra Z)
SELECT cliente.customer_name, cliente.customer_surname as Apellido_Cliente, customer_age as Edad_Cliente
from cliente_edad
INNER JOIN cliente on cliente_edad.customer_id = cliente.customer_id
WHERE Apellido_Cliente like "%z%";

--PUNTO 3 (Seleccionar el nombre, apellido, edad y nombre de sucursal de las personas cuyo nombre sea “Brendan” y el resultado ordenarlo por nombre de sucursal)
SELECT customer_name as Nombre_Cliente,customer_surname as Apellido_Cliente, customer_age as Edad_Cliente, sucursal.branch_name as Nombre_Sucursal
from cliente_edad
INNER JOIN sucursal on cliente_edad.branch_id = sucursal.branch_id
WHERE Nombre_Cliente = "Brendan"
ORDER by branch_name;

--PUNTO 4 (Selecciona de la tabla de préstamos, los préstamos con un importe mayor a $80.000 y los préstamos prendarios)
SELECT * 
FROM prestamo
WHERE loan_total > 8000000 
UNION
SELECT * 
FROM prestamo
WHERE loan_type = "PRENDARIO";

--PUNTO 5 (Selecciona los prestamos cuyo importe sea mayor que el importe medio de todos los prestamos)
SELECT *
FROM prestamo
WHERE loan_total > (SELECT avg(loan_total) FROM prestamo);

--PUNTO 6  (Cuenta la cantidad de clientes menores a 50 años)
SELECT count(customer_id) as ClienteMenor50
from cliente_edad 
where customer_age < 50;

--PUNTO 7  (Selecciona Seleccionar las primeras 5 cuentas con saldo mayor a 8.000$)
SELECT *
FROM cuenta 
WHERE balance > 800000 
ORDER BY account_id 
LIMIT 5;

--PUNTO 8 (Selecciona los préstamos que tengan fecha en abril, junio y agosto, ordenándolos por importe)
SELECT strftime('%d-%m-%Y', loan_date) as date, loan_total
FROM prestamo
where strftime('%m', loan_date) in ('04','06','08')
order by loan_total DESC;

--PUNTO 9 (Obtiene el importe total de los prestamos agrupados por tipo de préstamos.)
select  loan_type, sum(loan_total) as loan_total_accu
from prestamo
group by loan_type;