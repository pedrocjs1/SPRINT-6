--INSERCION DE CLIENTES PEDIDOS POR UN JSON
INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id) VALUES
("Lois", "Stout", 47730534, "1984-07-07", 80),
("Hall", "Mcconnell", 52055464, "1968-04-30", 45),
("Hilel", "Mclean", 43625213,"1993-03-28", 77),
("Jin", "Cooley", 21207908, "1959-08-24",  96),
("Gabriel", "Harmon", 57063950, "1976-04-01", 27)



--Correccion de branch_id con el tipo correcto de sucursal y posterior chequeo
UPDATE cliente
SET branch_id = 10
WHERE  customer_DNI = 47730534 OR  customer_DNI = 52055464 OR  customer_DNI = 43625213 OR  customer_DNI = 21207908 OR  customer_DNI = 57063950

SELECT * FROM cliente WHERE  customer_DNI = 47730534 OR  customer_DNI = 52055464 OR  customer_DNI = 43625213 OR  customer_DNI = 21207908 OR  customer_DNI = 57063950

--Al no encontrar a Noel David ni en clientes ni en empleados, hacemos la creacion del mismo como cliente para que aparezca en la tabla y poder borrarlo. 
--INSERT INTO cliente (customer_name, customer_surname, customer_DNI, dob, branch_id) VALUES ("Noel", "David", 57053950, "1997-06-11", 27)

DELETE FROM cliente WHERE customer_name = 'Noel' AND customer_surname = 'David'


--Creacion de vistas

CREATE VIEW ListadoDeClientes
AS
SELECT customer_id as ID, customer_name as NOMBRE, customer_surname as APELLIDO, customer_DNI as DNI, CAST(((julianday('now') - julianday(dob))/(365)) as integer) as EDAD, branch_number as NUMERO_SUCURSAL
FROM cliente INNER JOIN sucursal
ON cliente.branch_id = sucursal.branch_id


--Consultas para chequear
SELECT * from ListadoDeClientes where EDAD>40 ORDER BY DNI

SELECT * from ListadoDeClientes where NOMBRE = 'Anne' or NOMBRE = 'Tyler' ORDER BY EDAD


--Buscamos el tipo del prestamo
SELECT loan_type FROM prestamo ORDER BY loan_total DESC LIMIT 1