
/*==============================================================*/
/* Table: TIPO_CLIENTE                                          */
/*==============================================================*/
create table TIPO_CLIENTE (
   TIPO_CLENTE_ID       INT4                 not null,
   TIPO_CLIENTE_DESC    CHAR(40)             not null,
   constraint PK_TIPO_CLIENTE primary key (TIPO_CLENTE_ID)
);

/*==============================================================*/
/* Table: FECHA_NACIMENTO                                       */
/*==============================================================*/
create table FECHA_NACIMENTO (
   FECHA_NACIMIENTO     DATE                 not null,
   constraint PK_FECHA_NACIMENTO primary key (FECHA_NACIMIENTO)
);

/*==============================================================*/
/* Table: CLIENTE                                               */
/*==============================================================*/
create table CLIENTE (
   CLIENTE_ID           INT4                 not null,
   FECHA_NACIMIENTO     DATE                 null,
   TIPO_CLENTE_ID       INT4                 null,
   NOMBRE_CLIENTE       CHAR(60)             not null,
   constraint PK_CLIENTE primary key (CLIENTE_ID)
);

/*==============================================================*/
/* Table: MES                                                   */
/*==============================================================*/
create table MES (
   MES_ID               INT4                 not null,
   MES_DESC             CHAR(40)             not null,
   constraint PK_MES primary key (MES_ID)
);

/*==============================================================*/
/* Table: DIA                                                   */
/*==============================================================*/
create table DIA (
   FECHA                DATE                 not null,
   MES_ID               INT4                 null,
   constraint PK_DIA primary key (FECHA)
);

/*==============================================================*/
/* Table: HORARIO                                               */
/*==============================================================*/
create table HORARIO (
   HORA                 TIME                 not null,
   FECHA                DATE                 null,
   constraint PK_HORARIO primary key (HORA)
);

/*==============================================================*/
/* Table: IDIOMA                                                */
/*==============================================================*/
create table IDIOMA (
   IDIOMA               CHAR(40)             not null,
   constraint PK_IDIOMA primary key (IDIOMA)
);

/*==============================================================*/
/* Table: NACIONALIDAD                                          */
/*==============================================================*/
create table NACIONALIDAD (
   NACIONALIDAD         CHAR(40)             not null,
   constraint PK_NACIONALIDAD primary key (NACIONALIDAD)
);

/*==============================================================*/
/* Table: PELICULAS                                             */
/*==============================================================*/
create table PELICULAS (
   PELICULA_ID          INT4                 not null,
   IDIOMA               CHAR(40)             null,
   NACIONALIDAD         CHAR(40)             null,
   NOMBRE_PELICULA      CHAR(40)             not null,
   constraint PK_PELICULAS primary key (PELICULA_ID)
);
/*==============================================================*/
/* Table: TIPO_SALA                                             */
/*==============================================================*/
create table TIPO_SALA (
   TIPO_SALA_ID         INT4                 not null,
   TIPO_SALA_DESC       CHAR(40)             not null,
   constraint PK_TIPO_SALA primary key (TIPO_SALA_ID)
);

/*==============================================================*/
/* Table: SALA                                                  */
/*==============================================================*/
create table SALA (
   SALA_ID              INT4                 not null,
   TIPO_SALA_ID         INT4                 null,
   constraint PK_SALA primary key (SALA_ID)
);

/*==============================================================*/
/* Table: PAGO                                                  */
/*==============================================================*/
create table PAGO (
   TIPO_PAGO_ID         CHAR(40)             not null,
   constraint PK_PAGO primary key (TIPO_PAGO_ID)
);

/*==============================================================*/
/* Table: HECHOS                                                */
/*==============================================================*/
create table HECHOS (
   SALA_ID              INT4                 not null,
   CLIENTE_ID           INT4                 not null,
   PELICULA_ID          INT4                 not null,
   HORA                 TIME                 not null,
   TIPO_PAGO_ID         CHAR(40)             not null,
   NUM_ENTRADAS         INT4                 not null,
   IMPORTE              MONEY                not null,
   constraint PK_HECHOS primary key (SALA_ID, CLIENTE_ID, PELICULA_ID, HORA, TIPO_PAGO_ID)
);

alter table CLIENTE
   add constraint FK_CLIENTE_RELATIONS_FECHA_NA foreign key (FECHA_NACIMIENTO)
      references FECHA_NACIMENTO (FECHA_NACIMIENTO)
      on delete restrict on update restrict;

alter table CLIENTE
   add constraint FK_CLIENTE_RELATIONS_TIPO_CLI foreign key (TIPO_CLENTE_ID)
      references TIPO_CLIENTE (TIPO_CLENTE_ID)
      on delete restrict on update restrict;

alter table DIA
   add constraint FK_DIA_RELATIONS_MES foreign key (MES_ID)
      references MES (MES_ID)
      on delete restrict on update restrict;

alter table HECHOS
   add constraint FK_HECHOS_RELATIONS_HORARIO foreign key (HORA)
      references HORARIO (HORA)
      on delete restrict on update restrict;

alter table HECHOS
   add constraint FK_HECHOS_RELATIONS_PAGO foreign key (TIPO_PAGO_ID)
      references PAGO (TIPO_PAGO_ID)
      on delete restrict on update restrict;

alter table HECHOS
   add constraint FK_HECHOS_RELATIONS_SALA foreign key (SALA_ID)
      references SALA (SALA_ID)
      on delete restrict on update restrict;

alter table HECHOS
   add constraint FK_HECHOS_RELATIONS_CLIENTE foreign key (CLIENTE_ID)
      references CLIENTE (CLIENTE_ID)
      on delete restrict on update restrict;

alter table HECHOS
   add constraint FK_HECHOS_RELATIONS_PELICULA foreign key (PELICULA_ID)
      references PELICULAS (PELICULA_ID)
      on delete restrict on update restrict;

alter table HORARIO
   add constraint FK_HORARIO_RELATIONS_DIA foreign key (FECHA)
      references DIA (FECHA)
      on delete restrict on update restrict;

alter table PELICULAS
   add constraint FK_PELICULA_RELATIONS_IDIOMA foreign key (IDIOMA)
      references IDIOMA (IDIOMA)
      on delete restrict on update restrict;

alter table PELICULAS
   add constraint FK_PELICULA_RELATIONS_NACIONAL foreign key (NACIONALIDAD)
      references NACIONALIDAD (NACIONALIDAD)
      on delete restrict on update restrict;

alter table SALA
   add constraint FK_SALA_RELATIONS_TIPO_SAL foreign key (TIPO_SALA_ID)
      references TIPO_SALA (TIPO_SALA_ID)
      on delete restrict on update restrict;
