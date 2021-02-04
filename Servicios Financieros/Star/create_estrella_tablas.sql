CREATE TABLE Organizacion(
  llave_org   int NOT NULL,
  id_sucursal int NOT NULL,
  nombre_suc  varchar(40) NOT NULL,
  PRIMARY KEY (llave_org)
);
CREATE UNIQUE INDEX Organizacion_PK on Organizacion (
llave_org
);

CREATE TABLE Geografia(
  llave_geografia int NOT NULL,
  estado_id       int NOT NULL,
  estado_desc     varchar(40) NOT NULL,
  ciudad_id       int NOT NULL,
  ciudad_desc     varchar(40) NOT NULL,
  direccion_id    int NOT NULL,
  direccion_desc  varchar(60) NOT NULL,
  PRIMARY KEY (llave_geografia)
);
CREATE UNIQUE INDEX Geografia_PK on Geografia (
llave_geografia
);

CREATE TABLE Cliente(
  llave_cliente   int NOT NULL,
  grupo_id        int NOT NULL,
  grupo_desc      varchar(40),
  cliente_id      int NOT NULL,
  nombre_cliente  varchar(40) NOT NULL,
  ingreso_cliente int NOT NULL,
  edad            int NOT NULL,
  genero          varchar(2) NOT NULL,
  estadocivil     varchar(20) NOT NULL,
  PRIMARY KEY(llave_cliente)
);
CREATE UNIQUE INDEX Cliente_PK on Cliente (
llave_cliente
);

CREATE TABLE Producto(
  Llave_producto     int NOT NULL,
  Tipo_porducto_id   int NOT NULL,
  Tipo_porducto_desc varchar(40) NOT NULL,
  producto_id        int NOT NULL,
  producto_desc      varchar(40) NOT NULL,
  numero_cuenta      int NOT NULL,
  tasa_interes       decimal NOT NULL,
  saldo_minimo       float NOT NULL,
  PRIMARY KEY (Llave_producto)
);
CREATE UNIQUE INDEX Producto on Producto (
Llave_producto
);

CREATE TABLE Tiempo(
  llave_tiempo int NOT NULL,
  anno         int NOT NULL,
  mes_desc     varchar(10) NOT NULL,
  fecha        date NOT NULL,
  PRIMARY KEY(llave_tiempo)
);
CREATE UNIQUE INDEX Tiempo_PK on Tiempo (
llave_tiempo
);

CREATE TABLE Hechos(
  llave_org  int NOT NULL,
  llave_geografia int NOT NULL,
  llave_cliente   int NOT NULL,
  Llave_producto  int NOT NULL,
  llave_tiempo    int NOT NULL,
  saldo_$         float NOT NULL,
  FOREIGN KEY (llave_org)       REFERENCES  organizacion(llave_org) ON UPDATE CASCADE,
  FOREIGN KEY (llave_geografia) REFERENCES  geografia(llave_geografia) ON UPDATE CASCADE,
  FOREIGN KEY (llave_cliente)   REFERENCES  cliente(llave_cliente) ON UPDATE CASCADE,
  FOREIGN KEY (llave_producto)  REFERENCES  producto(llave_producto) ON UPDATE CASCADE,
  FOREIGN KEY (llave_tiempo)    REFERENCES  tiempo(llave_tiempo) ON UPDATE CASCADE,
  PRIMARY KEY (llave_org,llave_geografia,llave_cliente,Llave_producto,llave_tiempo)
);
CREATE UNIQUE INDEX Organizacion_PK on Organizacion (
llave_org,
llave_geografia,
llave_cliente,
Llave_producto,
llave_tiempo
);
