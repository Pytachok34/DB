CREATE TABLE cars (
	 id  integer NOT NULL,
	 model_id  TEXT NOT NULL,
	 year  DATE NOT NULL,
	 body_type  TEXT NOT NULL,
	 engine_volume  numeric(10,2) NOT NULL,
	 mileage  double NOT NULL,
	 price_id  integer NOT NULL,
	CONSTRAINT  cars_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON 	TABLE cars IS 'Машины';
COMMENT ON 	TABLE cars.id IS 'Индекс машины';
COMMENT ON 	TABLE cars.model_id IS 'Индекс Модели машины';
COMMENT ON 	TABLE cars.year IS 'Год выпуска Машины';
COMMENT ON 	TABLE cars.body_type IS 'Тип Машины';
COMMENT ON 	TABLE cars.engine_volume IS 'Мощность двигателя Машины';
COMMENT ON 	TABLE cars.mileage IS 'Пройденный киллометраж Машины';
COMMENT ON 	TABLE cars.price_id IS 'Индекс Цены Машины';


CREATE TABLE prices (
	 id  serial NOT NULL,
	 base_price  numeric(10,2) NOT NULL,
	 optioins_price  numeric(10,2) NOT NULL,
	CONSTRAINT  prices_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE price IS 'Цены';
COMMENT ON TABLE price.id IS 'Идентификатор Цены';
COMMENT ON TABLE price.base_price IS 'Цена базовой комплектации модели';
COMMENT ON TABLE price.optioins_price IS 'Цены продвинутой комлектации модели';


CREATE TABLE  Customers  (
	 id  integer NOT NULL,
	 first_name  TEXT NOT NULL,
	 last_name  TEXT NOT NULL,
	 personal_number_id  integer NOT NULL,
	 address  TEXT NOT NULL,
	CONSTRAINT  Customers_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Customers IS 'Покупатели';
COMMENT ON TABLE Customers.first_name IS 'Имя';
COMMENT ON TABLE Customers.last_name IS 'Фамилия';
COMMENT ON TABLE Customers.personal_number_id IS 'Номер покупателя';

CREATE TABLE  orders  (
	 id  integer NOT NULL,
	 customers_id  integer NOT NULL,
	 employer_id  integer NOT NULL,
	 date_of_order  DATE NOT NULL,
	 status  TEXT NOT NULL,
	 car_id  integer NOT NULL,
	 price  numeric(10,2) NOT NULL,
	CONSTRAINT  orders_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE orders IS 'Заказы';
COMMENT ON TABLE orders.id IS 'Идентификатор заказа';
COMMENT ON TABLE orders.customer_id IS 'Идентификатор покупателя';
COMMENT ON TABLE orders.employer_id IS 'Идентификатор работника';
COMMENT ON TABLE orders.date_of_order IS 'Дата создания заказа';
COMMENT ON TABLE orders.car_id IS 'Идентификатор машины';
COMMENT ON TABLE orders.price IS 'Цена';

CREATE TABLE  employees  (
	 id  integer NOT NULL,
	 first_name  TEXT NOT NULL,
	 last_name  TEXT NOT NULL,
	 position_id  integer NOT NULL,
	 personal_number_id  integer NOT NULL,
	CONSTRAINT  employees_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);



CREATE TABLE  Services  (
	 id  integer NOT NULL,
	 car_id  integer NOT NULL,
	 employer_id  integer NOT NULL,
	 service_date  DATE NOT NULL,
	 work_done  TEXT NOT NULL,
	 parts_replaced  TEXT NOT NULL,
	 customer_id  integer NOT NULL,
	CONSTRAINT  service_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Services IS 'Техническое обслуживание';
COMMENT ON TABLE Services.id IS 'Идентификатор Техническое обслуживание';
COMMENT ON TABLE Services.car_id IS 'Идентификатор машины на Техническом обслуживании';
COMMENT ON TABLE Services.employer_id IS 'Идентификатор работника Технического обслуживания';
COMMENT ON TABLE Services.service_date IS 'Дата начала Технического обслуживания';
COMMENT ON TABLE Services.work_done IS 'Сделанная работа';
COMMENT ON TABLE Services.parts_replaced IS 'Заменённые детали';
COMMENT ON TABLE Services.customer_id IS 'Идентификатор покупателя';

CREATE TABLE  accounting  (
	 id  serial NOT NULL,
	 order_id  integer NOT NULL,
	 invoice_number  TEXT NOT NULL,
	 payment_amount  numeric(10,2) NOT NULL,
	 taxes  numeric(10,2) NOT NULL,
	 commissions  numeric(10,2) NOT NULL,
	CONSTRAINT  accounting_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE accounting IS 'Бухгалтерия';
COMMENT ON TABLE accounting.id IS 'Идентификатор рассчёта';
COMMENT ON TABLE accounting.order_id IS 'Номер заказа';
COMMENT ON TABLE accounting.invoice_number IS 'Номер счёта';
COMMENT ON TABLE accounting.payment_amount IS 'Сумма оплаты';
COMMENT ON TABLE accounting.taxes IS 'Налоги';
COMMENT ON TABLE accounting.commissions IS 'Комиссия';

CREATE TABLE  Model  (
	 id  serial NOT NULL,
	 mark_id  integer NOT NULL,
	 model_name  TEXT NOT NULL,
	CONSTRAINT  Model_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Model IS 'Модель';
COMMENT ON TABLE Model.id IS 'Идентификатор Модели';
COMMENT ON TABLE Model.mark_id IS 'Идентификатор марки Модели';
COMMENT ON TABLE Model.model_name IS 'Название Модели';


CREATE TABLE  Mark  (
	 id  serial NOT NULL,
	 mark_name  TEXT NOT NULL,
	CONSTRAINT  Mark_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Mark IS 'Брэнд';
COMMENT ON TABLE Mark.id IS 'Идентификатор Брэнда';
COMMENT ON TABLE Mark.mark_name IS 'Название Брэнда';

CREATE TABLE  Employer_position  (
	 id  serial NOT NULL,
	 Position  TEXT NOT NULL,
	CONSTRAINT  Employer_position_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Employer_position IS 'Должность работника';
COMMENT ON TABLE Employer_position.id IS 'Идентификатор Должности работника';
COMMENT ON TABLE Employer_position.Position IS 'Должность';

CREATE TABLE  Personal_number  (
	 id  serial NOT NULL,
	 _number  TEXT NOT NULL,
	CONSTRAINT  Personal_number_pk  PRIMARY KEY ( id )
) WITH (
  OIDS=FALSE
);
COMMENT ON TABLE Personal_number IS 'Номер телефона';
COMMENT ON TABLE Personal_number.id IS 'Идентификатор номера телефона';
COMMENT ON TABLE Personal_number._number IS 'Номер';


ALTER TABLE  cars  ADD CONSTRAINT  cars_model  FOREIGN KEY ( model_id ) REFERENCES  Model ( id );
ALTER TABLE  cars  ADD CONSTRAINT  cars_price  FOREIGN KEY ( price_id ) REFERENCES  prices ( id );


ALTER TABLE  Customers  ADD CONSTRAINT  Customers_number  FOREIGN KEY ( personal_number_id ) REFERENCES  Personal_number ( id );

ALTER TABLE  orders  ADD CONSTRAINT  orders_customer  FOREIGN KEY ( customers_id ) REFERENCES  Customers ( id );
ALTER TABLE  orders  ADD CONSTRAINT  orders_employer  FOREIGN KEY ( employer_id ) REFERENCES  employees ( id );
ALTER TABLE  orders  ADD CONSTRAINT  orders_car  FOREIGN KEY ( car_id ) REFERENCES  cars ( id );

ALTER TABLE  employees  ADD CONSTRAINT  employees_position  FOREIGN KEY ( position_id ) REFERENCES  Employer_position ( id );
ALTER TABLE  employees  ADD CONSTRAINT  employees_number  FOREIGN KEY ( personal_number_id ) REFERENCES  Personal_number ( id );

ALTER TABLE  Services  ADD CONSTRAINT  service_car  FOREIGN KEY ( car_id ) REFERENCES  cars ( id );
ALTER TABLE  Services  ADD CONSTRAINT  service_employer  FOREIGN KEY ( employer_id ) REFERENCES  employees ( id );
ALTER TABLE  Services  ADD CONSTRAINT  service_customer  FOREIGN KEY ( customer_id ) REFERENCES  Customers ( id );

ALTER TABLE  accounting  ADD CONSTRAINT  accounting_order  FOREIGN KEY ( order_id ) REFERENCES  orders ( id );

ALTER TABLE  Model  ADD CONSTRAINT  Model_mark  FOREIGN KEY ( mark_id ) REFERENCES  Mark ( id );















