DROP VIEW IF EXISTS Car_list;
DROP VIEW IF EXISTS Customer_Details;
DROP VIEW IF EXISTS Order_History;
DROP VIEW IF EXISTS Service_History;
DROP Trigger if exists check_service_date_trigger ON Services;
DROP FUNCTION IF EXISTS check_service_date;
DROP FUNCTION IF EXISTS generate_car_id, generate_mechanic_id, generate_customer_id, generate_date,  generate_parts, generate_consultant_id;
DROP PROCEDURE IF EXISTS generate_order, generate_service;
-- Удаление таблиц
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS Employer_position;
DROP TABLE IF EXISTS cars;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Mark;
DROP TABLE IF EXISTS Personal_number;

-- Удаление схемы
DROP SCHEMA IF EXISTS CarDealer;

-- Создание новой схемы
CREATE SCHEMA IF NOT EXISTS CarDealer AUTHORIZATION abdurakhimov_ab;
COMMENT ON SCHEMA CarDealer IS 'Автодилер';

-- Назначение прав доступа
GRANT ALL ON SCHEMA CarDealer TO abdurakhimov_ab;

-- Изменение search_path для роли
ALTER ROLE abdurakhimov_ab IN DATABASE abdurakhimov_ab_db SET search_path TO CarDealer, public;

CREATE TABLE IF NOT EXISTS cars (
	 id  integer NOT NULL,
	 model_id  integer NOT NULL,
	 year  DATE NOT NULL,
	 body_type  TEXT NOT NULL,
	 engine_volume  numeric(10,2) NOT NULL,
	 mileage  numeric(10,2) NOT NULL,
	 price  numeric(10,2) NOT NULL,
	CONSTRAINT  cars_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON 	TABLE cars IS 'Машины';
COMMENT ON 	Column cars.id IS 'Индекс машины';
COMMENT ON 	Column cars.model_id IS 'Индекс Модели машины';
COMMENT ON 	Column cars.year IS 'Год выпуска Машины';
COMMENT ON 	Column cars.body_type IS 'Тип Машины';
COMMENT ON 	Column cars.engine_volume IS 'Мощность двигателя Машины';
COMMENT ON 	Column cars.mileage IS 'Пройденный киллометраж Машины';
COMMENT ON COLUMN cars.price IS 'Цена машины';

CREATE TABLE IF NOT EXISTS Customers  (
	 id  integer NOT NULL,
	 first_name  TEXT NOT NULL,
	 last_name  TEXT NOT NULL,
	 personal_number_id  integer NOT NULL,
	CONSTRAINT  Customers_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Customers IS 'Покупатели';
COMMENT ON Column Customers.first_name IS 'Имя';
COMMENT ON Column Customers.last_name IS 'Фамилия';
COMMENT ON Column Customers.personal_number_id IS 'Номер покупателя';


CREATE TABLE IF NOT EXISTS employees  (
	 id  integer NOT NULL,
	 first_name  TEXT NOT NULL,
	 last_name  TEXT NOT NULL,
	 position_id  integer NOT NULL,
	 personal_number_id  integer NOT NULL,
	CONSTRAINT  employees_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);

CREATE TABLE IF NOT EXISTS orders  (
	 id  serial PRIMARY KEY,
	 customers_id  integer NOT NULL REFERENCES Customers(id) ON DELETE CASCADE,
	 employer_id  integer NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
	 date_of_order  DATE NOT NULL,
	 car_id  integer NOT NULL REFERENCES cars(id) ON DELETE CASCADE
);
COMMENT ON TABLE orders IS 'Заказы';
COMMENT ON Column orders.id IS 'Идентификатор заказа';
COMMENT ON Column orders.customers_id IS 'Идентификатор покупателя';
COMMENT ON Column orders.employer_id IS 'Идентификатор работника';
COMMENT ON Column orders.date_of_order IS 'Дата создания заказа';
COMMENT ON Column orders.car_id IS 'Идентификатор машины';
COMMENT ON TABLE employees IS 'Работники';
COMMENT ON COLUMN employees.id IS 'Идентификатор работника';
COMMENT ON COLUMN employees.first_name IS 'Имя работника';
COMMENT ON COLUMN employees.last_name IS 'Фамилия работника';
COMMENT ON COLUMN employees.position_id IS 'индекс должности работника';
COMMENT ON COLUMN employees.personal_number_id IS 'идентификатор номера работника';

CREATE TABLE IF NOT EXISTS Model  (
	 id  serial NOT NULL,
	 mark_id  integer NOT NULL,
	 model_name  TEXT NOT NULL UNIQUE,
	CONSTRAINT  Model_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Model IS 'Модель';
COMMENT ON Column Model.id IS 'Идентификатор Модели';
COMMENT ON Column Model.mark_id IS 'Идентификатор марки Модели';
COMMENT ON Column Model.model_name IS 'Название Модели';


CREATE TABLE IF NOT EXISTS Mark  (
	 id  serial NOT NULL,
	 mark_name  TEXT NOT NULL UNIQUE,
	CONSTRAINT  Mark_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Mark IS 'Брэнд';
COMMENT ON Column Mark.id IS 'Идентификатор Брэнда';
COMMENT ON Column Mark.mark_name IS 'Название Брэнда';

CREATE TABLE IF NOT EXISTS Employer_position  (
	 id  serial NOT NULL,
	 _Position  TEXT NOT NULL,
	CONSTRAINT  Employer_position_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Employer_position IS 'Должность работника';
COMMENT ON Column Employer_position.id IS 'Идентификатор Должности работника';
COMMENT ON Column Employer_position._Position IS 'Должность';

CREATE TABLE IF NOT EXISTS Personal_number  (
	 id  serial NOT NULL,
	 _number  TEXT NOT NULL UNIQUE,
	CONSTRAINT  Personal_number_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Personal_number IS 'Номер телефона';
COMMENT ON Column Personal_number.id IS 'Идентификатор номера телефона';
COMMENT ON Column Personal_number._number IS 'Номер';

CREATE TABLE IF NOT EXISTS Services (
   id  SERIAL PRIMARY KEY,
   car_id  integer NOT NULL REFERENCES cars(id) ON DELETE CASCADE,
   employer_id  integer NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
   service_date  DATE NOT NULL,
   parts_replaced  TEXT NOT NULL,
   customer_id  integer NOT NULL REFERENCES Customers(id) ON DELETE CASCADE
) ;
COMMENT ON TABLE Services IS 'Техническое обслуживание';
COMMENT ON Column Services.id IS 'Идентификатор Техническое обслуживание';
COMMENT ON Column Services.car_id IS 'Идентификатор машины на Техническом обслуживании';
COMMENT ON Column Services.employer_id IS 'Идентификатор работника Технического обслуживания';
COMMENT ON Column Services.service_date IS 'Дата начала Технического обслуживания';
COMMENT ON Column Services.parts_replaced IS 'Заменённые детали';
COMMENT ON Column Services.customer_id IS 'Идентификатор покупателя';

ALTER TABLE  cars  ADD CONSTRAINT  cars_model  FOREIGN KEY ( model_id ) REFERENCES  Model ( id ) ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE  Customers  ADD CONSTRAINT  Customers_number  FOREIGN KEY ( personal_number_id ) REFERENCES  Personal_number ( id ) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE  employees  ADD CONSTRAINT  employees_position  FOREIGN KEY ( position_id ) REFERENCES  Employer_position ( id ) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE  employees  ADD CONSTRAINT  employees_number  FOREIGN KEY ( personal_number_id ) REFERENCES  Personal_number ( id ) ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE  Model  ADD CONSTRAINT  Model_mark  FOREIGN KEY ( mark_id ) REFERENCES  Mark ( id ) ON UPDATE CASCADE ON DELETE RESTRICT;

INSERT INTO Mark Values (1,'Renault');
INSERT INTO Mark Values (2, 'Wolkswagen');
INSERT INTO Mark Values (3,'BMW');
INSERT INTO Mark Values (4,'Skodia');
INSERT INTO Mark Values (5,'Lada');

INSERT INTO Model Values (1,1,'Logan');
INSERT INTO Model Values (2,1,'Megan');
INSERT INTO Model Values (3,1,'Arkana');
INSERT INTO Model Values (4,1,'Laguna');
INSERT INTO Model Values (5,2,'Polo');
INSERT INTO Model Values (6,2,'Jeta');
INSERT INTO Model Values (7,2,'Tiguan');
INSERT INTO Model Values (8,3,'X5');
INSERT INTO Model Values (9,3,'X3');
INSERT INTO Model Values (10,3,'M3');
INSERT INTO Model Values (11,4,'Rapid');
INSERT INTO Model Values (12,4,'Octavia');
INSERT INTO Model Values (13,4,'Kodiaq');
INSERT INTO Model Values (14,5,'Vesta');

INSERT INTO cars Values (1,1,'2010-06-21','Седан',98.3,5000,1);
INSERT INTO cars Values (2,4,'2005-03-09','Лифт-бэк',118,15000,1);
INSERT INTO cars Values (3,4,'1998-10-11','Универсал',118,12300,1);
INSERT INTO cars Values (4,5,'2023-11-15','Хэч-бек',100,10,2);
INSERT INTO cars Values (5,10,'2021-03-09','Седан',510,49000,6);

Insert into Personal_number Values (1,'89515508490');
Insert into Personal_number Values (2,'89081262391');
insert into Personal_number Values (3,'89502338912');
insert into Personal_number Values (4,'89128767125');
insert into Personal_number Values (5,'89102789183');
insert into Personal_number Values (6,'89065736612');
insert into Personal_number Values (7,'89011234567');
insert into Personal_number Values (8,'89022345678');
insert into Personal_number Values (9,'89033456789');
insert into Personal_number Values (10,'89044567890');

INSERT INTO Customers Values(1,'Иван','Агафонов',1);
Insert into Customers Values (2,'Хызыр','Аппаев',2);
insert into Customers Values (3,'Максим','Максимов',3);
insert into Customers Values (4,'Кирилл','Смирнов',4);
insert into Customers Values (5,'Семён','Пыхов',5);

insert into Employer_position Values (1,'консультант');
insert into Employer_position Values (2,'автомеханик');
insert into Employer_position Values (3,'Директор');

Insert into employees Values (1,'Валерий','Чеботарёв',2,6);
Insert into employees Values (2,'Степан','Начальников',3,7);
Insert into employees Values (3,'Ольга','Помогатова',1,8);
Insert into employees Values (4,'Андрей','Работников',2,9);
Insert into employees Values (5,'Ирина','Гордон',1,10);

INSERT INTO orders Values (50,1,3,'2023-12-01',3);
INSERT INTO orders Values (51,2,5,'2021-08-09',1);
INSERT INTO orders Values (52,3,3,'2022-03-14',2);
INSERT INTO orders Values (53,4,5,'2023-11-25',4);
INSERT INTO orders Values (54,5,5,'2019-03-27',5);

INSERT INTO Services Values (12,5,1,'2022-04-25','Правое крыло',5);
INSERT INTO Services Values (13,4,4,'2023-12-03','Свечи',4);
Insert into Services Values (14,3,1,'2005-01-29','Ремень ГРМ',3);

CREATE OR REPLACE FUNCTION check_service_date() RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM orders
    WHERE car_id = NEW.car_id
      AND date_of_order > NEW.service_date
  ) THEN
    RAISE EXCEPTION 'Service date cannot be earlier than order date';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_service_date_trigger
AFTER INSERT OR UPDATE ON Services
FOR EACH ROW
EXECUTE FUNCTION check_service_date();

CREATE OR REPLACE VIEW Car_list AS
SELECT
    c.id AS car_id,
    m.model_name,
    mk.mark_name
FROM
    cars c
JOIN
    Model m ON c.model_id = m.id
JOIN
    Mark mk ON m.mark_id = mk.id;


CREATE OR REPLACE VIEW Customer_Details AS
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    pn._number AS personal_number_id
FROM
    Customers c
JOIN
    Personal_number pn ON c.personal_number_id = pn.id;

CREATE OR REPLACE VIEW Order_History AS
SELECT
    o.id,
    CONCAT(cs.first_name, ' ', cs.last_name) AS customer_name,
    o.date_of_order,
    CONCAT(m.model_name, ', ', c.year, ', ', c.body_type, ', ', c.engine_volume, ', ', c.mileage) AS car_details
FROM
    orders o
JOIN
    Customers cs ON o.customers_id = cs.id
JOIN
    cars c ON o.car_id = c.id
JOIN
    Model m ON c.model_id = m.id
WHERE
    o.date_of_order >= '2020-01-01';
	
CREATE OR REPLACE VIEW Service_History AS
SELECT
    s.id,
    CONCAT(m.model_name, ', ', c.year, ', ', c.body_type, ', ', c.engine_volume, ', ', c.mileage) AS car_details,
    s.service_date,
    s.parts_replaced,
    CONCAT(cs.first_name, ' ', cs.last_name) AS customer_name
FROM
    Services s
JOIN
    cars c ON s.car_id = c.id
JOIN
    Model m ON c.model_id = m.id
JOIN
    customers cs ON c.id = cs.id;
	
	
CREATE OR REPLACE FUNCTION generate_car_id() RETURNS INT AS
$$
BEGIN
	Return id from cars ORDER BY RANDOM() LIMIT 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_mechanic_id()
RETURNS INT AS $$
DECLARE
    mechanic_id INT;
BEGIN
    SELECT id INTO mechanic_id
    FROM employees
    WHERE position_id = (
        SELECT id
        FROM Employer_position
        WHERE _Position = 'автомеханик'
    )
    ORDER BY RANDOM()
    LIMIT 1;

    RETURN mechanic_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_customer_id() RETURNS INT AS
$$
BEGIN
	Return id from Customers ORDER BY RANDOM() LIMIT 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_date() RETURNS DATE AS $$
DECLARE
    start_date TIMESTAMP := '2019-01-01'::DATE; 
    end_date TIMESTAMP := '2023-12-31'::DATE;
BEGIN
    RETURN start_date + random() * (end_date - start_date);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_parts() RETURNS varchar(200) AS
$$
DECLARE
    parts varchar[] := ARRAY['Колодки', 'Ремень ГРМ', 'Заднее крыло', 'боковое зеркало', 'Стартер','Ручник'];
    random_index int;
BEGIN
    random_index := 1 + floor(random() * array_length(parts, 1));

    RETURN parts[random_index];
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE generate_service(number INT) AS
$$
DECLARE
	i INT;
BEGIN
	FOR i in 1..number LOOP
		INSERT INTO Services(
			car_id,
			employer_id,
			service_date,
			parts_replaced,
			customer_id
		)
		VALUES (
			generate_car_id(),
			generate_mechanic_id(),
			generate_date(),
			generate_parts(),
			generate_customer_id()
		);
	END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_consultant_id()
RETURNS INT AS $$
DECLARE
    consultant_id INT;
BEGIN
    SELECT id INTO consultant_id
    FROM employees
    WHERE position_id = (
        SELECT id
        FROM Employer_position
        WHERE _Position = 'консультант'
    )
    ORDER BY RANDOM()
    LIMIT 1;

    RETURN consultant_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE generate_order(number INT) AS
$$
DECLARE
	i INT;
BEGIN
	FOR i in 1..number LOOP
		INSERT INTO orders(
			customers_id,
			employer_id,
			date_of_order,
			car_id
		)
		VALUES (
			generate_customer_id(),
			generate_consultant_id(),
			generate_date(),
			generate_car_id()
		);
	END LOOP;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL PRIVILEGES ON DATABASE abdurakhimov_ab_db FROM consultant;
REVOKE ALL PRIVILEGES ON SCHEMA CarDealer FROM consultant;
REVOKE ALL PRIVILEGES ON TABLE cars, Model, Mark FROM consultant;
REVOKE ALL PRIVILEGES ON DATABASE abdurakhimov_ab_db FROM consultant_user;
REVOKE ALL PRIVILEGES ON SCHEMA CarDealer FROM consultant_user;
REVOKE ALL PRIVILEGES ON TABLE cars, Model, Mark, orders, Customers FROM consultant_user;
DROP ROLE IF EXISTS consultant, consultant_user;
CREATE ROLE consultant;
CREATE USER consultant_user WITH PASSWORD 'consultant';
GRANT consultant to consultant_user;
GRANT CONNECT ON DATABASE abdurakhimov_ab_db TO consultant_user;
GRANT USAGE ON SCHEMA Cardealer to consultant;
ALTER ROLE consultant_user IN DATABASE abdurakhimov_ab_db SET search_path TO CarDealer, public;
GRANT SELECT, INSERT, UPDATE ON TABLE Customers TO consultant;
GRANT SELECT, INSERT, UPDATE ON TABLE orders TO consultant;
GRANT SELECT ON TABLE cars TO consultant;
GRANT SELECT ON TABLE Model TO consultant;
GRANT SELECT ON TABLE Mark TO consultant;

REVOKE ALL PRIVILEGES ON DATABASE abdurakhimov_ab_db FROM mechanic;
REVOKE ALL PRIVILEGES ON SCHEMA CarDealer FROM mechanic;
REVOKE ALL PRIVILEGES ON TABLE cars, Model, Mark FROM mechanic;
REVOKE ALL PRIVILEGES ON DATABASE abdurakhimov_ab_db FROM mechanic_user;
REVOKE ALL PRIVILEGES ON SCHEMA CarDealer FROM mechanic_user;
REVOKE ALL PRIVILEGES ON TABLE cars, Model, Mark, Services, Customers FROM mechanic_user;
DROP ROLE IF EXISTS mechanic, mechanic_user;
CREATE ROLE mechanic;
CREATE USER mechanic_user WITH PASSWORD 'mechanic';
GRANT mechanic to mechanic_user;
GRANT CONNECT ON DATABASE abdurakhimov_ab_db TO mechanic_user;
GRANT USAGE ON SCHEMA Cardealer to mechanic;
ALTER ROLE mechanic_user IN DATABASE abdurakhimov_ab_db SET search_path TO CarDealer, public;
GRANT SELECT, INSERT, UPDATE ON TABLE Services TO mechanic;
GRANT SELECT ON TABLE Customers TO mechanic;
GRANT SELECT ON TABLE cars TO mechanic;
GRANT SELECT ON TABLE Model TO manager;
GRANT SELECT ON TABLE Mark TO manager;
