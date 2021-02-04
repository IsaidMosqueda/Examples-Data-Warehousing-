/*Dimensión Organización*/
CREATE TABLE Sucursal(
  sucursal_id int NOT NULL,
  nombre_suc  varchar(40) NOT NULL,
  PRIMARY KEY (sucursal_id)
);
CREATE UNIQUE INDEX Sucursal_PK on Sucursal (
sucursal_id
);

/*Dimensión Geografia*/
CREATE TABLE Estado(
  estado_id   int NOT NULL,
  estado_desc varchar(40) NOT NULL,
  PRIMARY KEY (estado_id)
);
CREATE UNIQUE INDEX Estado_PK on Estado (
estado_id
);

CREATE TABLE Ciudad(
  ciudad_id   int NOT NULL,
  ciudad_desc varchar(40) NOT NULL,
  estado_id   int NOT NULL,
  PRIMARY KEY (ciudad_id),
  FOREIGN KEY (estado_id) REFERENCES Estado(estado_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Ciudad_PK on Ciudad (
ciudad_id
);

CREATE TABLE Direccion(
  direccion_id   int NOT NULL,
  direccion_desc varchar(60) NOT NULL,
  ciudad_id      int NOT NULL,
  PRIMARY KEY (direccion_id),
  FOREIGN KEY (ciudad_id) REFERENCES Ciudad(ciudad_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Direccion_PK on Direccion (
direccion_id
);

/*Dimensión Cliente*/
CREATE TABLE Household(
  grupo_id   int NOT NULL,
  grupo_desc varchar(40),
  PRIMARY KEY(grupo_id)
);
CREATE UNIQUE INDEX Household_PK on Household (
grupo_id
);

CREATE TABLE ingreso(
  ingreso int NOT NULL,
  PRIMARY KEY(ingreso)
);
CREATE UNIQUE INDEX ingreso_PK on ingreso (
ingreso
);

CREATE TABLE edad(
  edad int NOT NULL,
  PRIMARY KEY(edad)
);
CREATE UNIQUE INDEX edad_PK on edad (
edad
);

CREATE TABLE genero(
  genero varchar(2) NOT NULL,
  PRIMARY KEY(genero)
);
CREATE UNIQUE INDEX genero_PK on genero (
genero
);

CREATE TABLE estado_civil(
  estadocivil varchar(20) NOT NULL,
  PRIMARY KEY(estadocivil)
);
CREATE UNIQUE INDEX estado_civil_PK on estado_civil (
estadocivil
);

CREATE TABLE Cliente(
  cliente_id     int NOT NULL,
  nombre_cliente varchar(40) NOT NULL,
  grupo_id       int NOT NULL,
  ingreso        int NOT NULL,
  edad           int NOT NULL,
  genero         varchar(2) NOT NULL,
  estadocivil    varchar(20) NOT NULL,
  PRIMARY KEY(cliente_id),
  FOREIGN KEY (grupo_id)    REFERENCES household(grupo_id) ON UPDATE CASCADE,
  FOREIGN KEY (ingreso)     REFERENCES ingreso(ingreso) ON UPDATE CASCADE,
  FOREIGN KEY (edad)        REFERENCES edad(edad) ON UPDATE CASCADE,
  FOREIGN KEY (genero)      REFERENCES genero(genero) ON UPDATE CASCADE,
  FOREIGN KEY (estadocivil) REFERENCES estado_civil(estadocivil) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Cliente_PK on Cliente (
cliente_id
);

/*Dimensión Producto*/
CREATE TABLE Tipo_producto(
  tipo_porducto_id   int NOT NULL,
  tipo_porducto_desc varchar(40) NOT NULL,
  PRIMARY KEY (tipo_porducto_id)
);
CREATE UNIQUE INDEX Tipo_producto_PK on Tipo_producto (
tipo_porducto_id
);

CREATE TABLE Tasa_interes(
  tasa_interes decimal NOT NULL,
  PRIMARY KEY (tasa_interes)
);
CREATE UNIQUE INDEX Tasa_interes_PK on Tasa_interes (
tasa_interes
);

CREATE TABLE saldo_minimo(
  saldo_minimo float NOT NULL,
  PRIMARY KEY (saldo_minimo)
);
CREATE UNIQUE INDEX saldo_minimo_PK on saldo_minimo (
saldo_minimo
);

CREATE TABLE Producto(
  producto_id      int NOT NULL,
  producto_desc    varchar(40) NOT NULL,
  tipo_porducto_id int NOT NULL,
  tasa_interes     decimal NOT NULL,
  saldo_minimo     float NOT NULL,
  PRIMARY KEY (producto_id),
  FOREIGN KEY (tipo_porducto_id) REFERENCES tipo_producto(tipo_porducto_id) ON UPDATE CASCADE,
  FOREIGN KEY (tasa_interes)     REFERENCES tasa_interes(tasa_interes) ON UPDATE CASCADE,
  FOREIGN KEY (saldo_minimo)     REFERENCES saldo_minimo(saldo_minimo) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Producto_PK on Producto (
producto_id
);

CREATE TABLE Cuenta(
  numero_cuenta int NOT NULL,
  producto_id   int NOT NULL,
  PRIMARY KEY (numero_cuenta),
  FOREIGN KEY (producto_id) REFERENCES producto(producto_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Cuenta_PK on Cuenta (
numero_cuenta
);

/*Dimensión Tiempo*/
CREATE TABLE Anno(
  anno int NOT NULL,
  PRIMARY KEY(anno)
);
CREATE UNIQUE INDEX Anno_PK on Anno (
anno
);

CREATE TABLE Mes(
  mes_id   int NOT NULL,
  mes_desc varchar(10) NOT NULL,
  anno     int NOT NULL,
  PRIMARY KEY(mes_id),
  FOREIGN KEY (anno) REFERENCES anno(anno) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Mes_PK on Mes (
mes_id
);

CREATE TABLE Dia(
  fecha   date NOT NULL,
  mes_id  int NOT NULL,
  PRIMARY KEY(fecha),
  FOREIGN KEY (mes_id) REFERENCES mes(mes_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX Dia_PK on Dia (
fecha
);

CREATE TABLE Hechos(
  sucursal_id   int NOT NULL,
  direccion_id  int NOT NULL,
  cliente_id    int NOT NULL,
  numero_cuenta int NOT NULL,
  fecha         date NOT NULL,
  saldo_$       float NOT NULL,
  FOREIGN KEY (sucursal_id)   REFERENCES  sucursal(sucursal_id) ON UPDATE CASCADE,
  FOREIGN KEY (direccion_id)  REFERENCES  direccion(direccion_id) ON UPDATE CASCADE,
  FOREIGN KEY (cliente_id)    REFERENCES  cliente(cliente_id) ON UPDATE CASCADE,
  FOREIGN KEY (numero_cuenta) REFERENCES  Cuenta(numero_cuenta) ON UPDATE CASCADE,
  FOREIGN KEY (fecha)         REFERENCES  Dia(fecha) ON UPDATE CASCADE,
  PRIMARY KEY (sucursal_id,direccion_id,cliente_id,numero_cuenta,fecha)
);
CREATE UNIQUE INDEX Hechos_PK on Hechos (
sucursal_id,
direccion_id,
cliente_id,
numero_cuenta,
fecha
);
