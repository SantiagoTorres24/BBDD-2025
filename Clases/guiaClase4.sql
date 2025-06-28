--1. Crear una tabla temporal #clientes a partir de la siguiente consulta: SELECT * FROM customer
SELECT * INTO #clientes FROM customer --Selecciona todo lo de customer y ponelo en #clientes
SELECT * FROM #clientes

/*2. Insertar el siguiente cliente en la tabla #clientes
Customer_num 144
Fname Agustín
Lname Creevy
Company Jaguares SA
State CA
City Los Angeles */
INSERT INTO #clientes(customer_num, fname, lname, company, state, city) VALUES
(144, 'Agustín', 'Creevy', 'Jaguares SA', 'CA', 'Los Angeles')
SELECT customer_num FROM #clientes WHERE fname = 'Agustín' and lname = 'Creevy' --Prueba

/*3. Crear una tabla temporal #clientesCalifornia con la misma estructura de la tabla customer.
Realizar un insert masivo en la tabla #clientesCalifornia con todos los clientes de la tabla customer cuyo
state sea CA.*/
CREATE TABLE #clientesCalifornia(
customer_num smallint NOT NULL PRIMARY KEY,
fname varchar(15),
lname varchar(15),
company varchar(20),
address1 varchar(20),
address2 varchar(20),
city varchar(15),
state char(2),
zipcode char(5),
phone varchar(18),
status char(1)
)
INSERT INTO #clientesCalifornia SELECT * FROM customer WHERE state = 'CA'

--Otra forma mas rapida
SELECT * INTO #clientesCalifornia FROM customer WHERE state = 'CA'
SELECT * FROM #clientesCalifornia
/*4. Insertar el siguiente cliente en la tabla #clientes un cliente que tenga los mismos datos del cliente 103,
pero cambiando en customer_num por 155
Valide lo insertado.*/
INSERT INTO #clientes (customer_num, fname, lname, company, address1, address2, city, state, zipcode, phone, customer_num_referedBy, status)
SELECT 155, fname, lname, company, address1, address2, city, state, zipcode, phone, customer_num_referedBy, status
FROM customer WHERE customer_num = 103
SELECT * FROM #clientes WHERE customer_num = 103 or customer_num = 155
DELETE FROM #clientes WHERE customer_num = 155 and phone IS NULL

/*5. Borrar de la tabla #clientes los clientes cuyo campo zipcode esté entre 94000 y 94050 y la ciudad
comience con ‘M’. Validar los registros a borrar antes de ejecutar la acción.*/
SELECT COUNT(*) FROM #clientes
WHERE zipcode BETWEEN 94000 AND 94050
AND city LIKE 'M%' -- valida los registros que borro

DELETE FROM #clientes WHERE zipcode BETWEEN 94000 AND 94050 AND city LIKE 'M%'
SELECT * FROM #clientes WHERE city LIKE 'M%'

/*6. Modificar los registros de la tabla #clientes cambiando el campo state por ‘AK’ y el campo address2 por
‘Barrio Las Heras’ para los clientes que vivan en el state 'CO'. Validar previamente la cantidad de
registros a modificar.*/
SELECT COUNT(customer_num) FROM #clientes 
WHERE state = 'CO' --1 solo

UPDATE #clientes SET state = 'AK', address1 = '2539 South Utica Str', address2 = 'Barrios Las Heras' --me confundi y habia seteado en la 1 jeje
WHERE state = 'AK'

SELECT * FROM #clientes

/*7. Modificar todos los clientes de la tabla #clientes, agregando un dígito 1 delante de cada número
telefónico, debido a un cambio de la compañía de teléfonos.*/
UPDATE #clientes SET phone = '1' + phone