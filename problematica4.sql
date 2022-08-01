-- CUARTA PROBLEMATICA 

--PUNTO 1 (devuelve la cantidad de clientes por nombre de sucursal ordenando de mayor a menor)
SELECT count(cliente.customer_id) as Cantidad_Clientes, sucursal.branch_name
FROM cliente 
INNER JOIN sucursal on cliente.branch_id = sucursal.branch_id
GROUP BY sucursal.branch_id
ORDER BY Cantidad_Clientes DESC;

--PUNTO 2 (anexa a la tabla sucursal una columna con la cantidad de empleados por cliente de cada sucursal)
-- creo view para unir data de tablas 
CREATE VIEW c_cl AS 
  SELECT sucursal.branch_id, sucursal.branch_name,count(cliente.customer_id) as Cantidad_Clientes
  FROM cliente 
  INNER JOIN sucursal on cliente.branch_id = sucursal.branch_id
  GROUP BY sucursal.branch_id
  ORDER BY sucursal.branch_id;

CREATE VIEW c_emp_x_cl AS
  SELECT c_cl.branch_id, branch_name, round((Cantidad_Clientes*1.0)/(count(empleado.employee_id)),2) as Cant_Empleados_por_cliente
  FROM c_cl
  INNER JOIN empleado ON empleado.branch_id = c_cl.branch_id
  GROUP BY c_cl.branch_id
  ORDER BY c_cl.branch_id;

-- creo columna 
ALTER TABLE sucursal 
ADD COLUMN employee_amnt_per_client REAL NOT NULL DEFAULT 0.0;

-- la actualizo con los valores obtenidos en las views  
UPDATE sucursal 
SET employee_amnt_per_client = (SELECT Cant_Empleados_por_cliente FROM c_emp_x_cl WHERE branch_id = sucursal.branch_id)
WHERE branch_id IN(SELECT branch_id FROM c_emp_x_cl);

-- borro las views utilizadas
DROP VIEW c_cl;
DROP VIEW c_emp_x_cl;

--PUNTO 3 (anexa a la tabla sucursal dos columnas con la cantidad de tarjetas de cada tipo emitidas por sucursal)
-- creo views para unir data de tablas 
CREATE VIEW c_t_credit_x_s AS 
  SELECT count(account_id) as Cantidad_Tarjetas, card_type, cliente.branch_id
  FROM tarjeta
  INNER JOIN cliente ON cliente.customer_id = tarjeta.customer_id
  GROUP BY cliente.branch_id
  HAVING tarjeta.card_type = 'credit'
  ORDER by cliente.branch_id;

CREATE VIEW c_t_dedit_x_s AS  
  SELECT count(account_id) as Cantidad_Tarjetas, card_type, cliente.branch_id
  FROM tarjeta
  INNER JOIN cliente ON cliente.customer_id = tarjeta.customer_id
  GROUP BY cliente.branch_id
  HAVING tarjeta.card_type = 'debit'
  ORDER by cliente.branch_id;
    
-- creo columnas
ALTER TABLE sucursal 
ADD COLUMN given_credit_cards INTEGER NOT NULL DEFAULT 0;

ALTER TABLE sucursal
ADD COLUMN given_dedit_cards INTEGER NOT NULL DEFAULT 0;

-- las actualizo con los valores obtenidos en las views
UPDATE sucursal 
SET given_credit_cards = (SELECT Cantidad_Tarjetas FROM c_t_credit_x_s WHERE branch_id = sucursal.branch_id)
WHERE branch_id IN(SELECT branch_id FROM c_t_credit_x_s);

UPDATE sucursal
SET given_dedit_cards = (SELECT Cantidad_Tarjetas FROM c_t_dedit_x_s WHERE branch_id = sucursal.branch_id)
WHERE branch_id IN(SELECT branch_id FROM c_t_dedit_x_s);

-- borro las views utilizadas
DROP VIEW c_t_credit_x_s;
DROP VIEW c_t_dedit_x_s;


--PUNTO 4 (anexa a la tabla sucursal una columna con la cantidad de prestamos emitidos por sucursal)
-- creo views para unir data de tablas 
CREATE VIEW esquema_prestamos AS 
SELECT branch_id, CLIENTE.customer_id, prestamo.loan_id FROM CLIENTE
LEFT JOIN prestamo
ON cliente.customer_id = prestamo.customer_id
order by branch_id;

CREATE VIEW diagrama_prestamos AS
SELECT esquema_prestamos.branch_id, count(loan_id) AS cant_prestamos, count(cliente.customer_id) AS cant_clientes
from esquema_prestamos 
INNER JOIN cliente on esquema_prestamos.branch_id = cliente.branch_id
group by esquema_prestamos.branch_id;

CREATE VIEW diagrama_promedio AS
SELECT branch_id, CAST(round((((cant_prestamos*1.0)/cant_clientes)*100),1)as TEXT) || '%' as promedio from diagrama_prestamos;

-- creo columna 
ALTER TABLE sucursal 
ADD COLUMN average_given_loans TEXT NOT NULL DEFAULT '0%';

-- la actualizo con los valores obtenidos en las views 
UPDATE sucursal 
SET average_given_loans = (SELECT promedio FROM diagrama_promedio WHERE branch_id = sucursal.branch_id)
WHERE branch_id IN(SELECT branch_id FROM diagrama_promedio);

--borro las views utilizadas
DROP VIEW diagrama_prestamos;
DROP VIEW diagrama_promedio;
DROP VIEW esquema_prestamos;

--PUNTO 5 (crea tabla auditoria y trigger que al activarse registrara en la tabla los movimientos)
CREATE TABLE auditoria_cuenta ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  old_id INT,
  new_id INT, 
  old_balance INT, 
  new_balance INT, 
  old_iban TEXT, 
  new_iban TEXT, 
  old_type TEXT, 
  new_type TEXT, 
  user_action TEXT, 
  created_at TEXT
);

--creo trigger con los parametros de activacion y las acciones a realizar
CREATE TRIGGER registro_movimientos_cuenta AFTER UPDATE ON cuenta 
WHEN old.balance<>new.balance OR old.iban<>new.iban OR old.type<>new.type
BEGIN
  INSERT INTO auditoria_cuenta (old_id,new_id,old_balance,new_balance, old_iban, new_iban, old_type, new_type, user_action, created_at)
  VALUES (old.account_id, new.account_id, old.balance, new.balance, old.iban, new.iban, old.type, new.type, 'UPDATE', datetime('NOW'));
END;

--hago el update de cuentas que quedara registrado en la tabla auditoria
UPDATE cuenta 
SET balance = balance - 10000
WHERE account_id IN (10,11,12,13,14);

--PUNTO 6 (Crear índice para DNI en la tabla Cliente)
create unique index index_dni on cliente (customer_DNI);

--PUNTO 7 (Crear tabla movimientos, hacer una transferencia y registrarlo en la tabla movimientos)
CREATE TABLE movimientos (
  movement_id INTEGER PRIMARY KEY AUTOINCREMENT,
  no_account INTEGER NOT NULL,
  amount INTEGER NOT NULL,
  type_operation TEXT NOT NULL,
  hour DATE NOT NULL
);
-- hago un commit de la transaccion generada automaticamente por sqlite e inicio una nueva donde en caso de error hara un rollback
COMMIT;
begin TRANSACTION;

update or ROLLBACK cuenta
set balance = balance - 1000
where account_id = 200;

update or ROLLBACK cuenta 
set balance = balance + 1000
where account_id = 400;

insert or ROLLBACK into movimientos(no_account, amount, type_operation, hour)
values(200, -1000, "Transfer", time("now"));

insert or ROLLBACK into movimientos(no_account, amount, type_operation, hour)
values(400, 1000, "Transfer", time("now"));

COMMIT;