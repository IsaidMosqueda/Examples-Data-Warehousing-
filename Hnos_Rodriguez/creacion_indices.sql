/*==============================================================*/
/* Index: CLIENTE_PK                                            */
/*==============================================================*/
create unique index CLIENTE_PK on CLIENTE (
CLIENTE_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_2_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_2_FK on CLIENTE (
FECHA_NACIMIENTO
);

/*==============================================================*/
/* Index: RELATIONSHIP_3_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_3_FK on CLIENTE (
TIPO_CLENTE_ID
);

/*==============================================================*/
/* Index: DIA_PK                                                */
/*==============================================================*/
create unique index DIA_PK on DIA (
FECHA
);

/*==============================================================*/
/* Index: RELATIONSHIP_9_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_9_FK on DIA (
MES_ID
);

/*==============================================================*/
/* Index: FECHA_NACIMENTO_PK                                    */
/*==============================================================*/
create unique index FECHA_NACIMENTO_PK on FECHA_NACIMENTO (
FECHA_NACIMIENTO
);

/*==============================================================*/
/* Index: HECHOS_PK                                             */
/*==============================================================*/
create unique index HECHOS_PK on HECHOS (
SALA_ID,
CLIENTE_ID,
PELICULA_ID,
HORA,
TIPO_PAGO_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_6_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_6_FK on HECHOS (
SALA_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_7_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_7_FK on HECHOS (
CLIENTE_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_8_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_8_FK on HECHOS (
PELICULA_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_11_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_11_FK on HECHOS (
HORA
);

/*==============================================================*/
/* Index: RELATIONSHIP_12_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_12_FK on HECHOS (
TIPO_PAGO_ID
);

/*==============================================================*/
/* Index: HORARIO_PK                                            */
/*==============================================================*/
create unique index HORARIO_PK on HORARIO (
HORA
);

/*==============================================================*/
/* Index: RELATIONSHIP_10_FK                                    */
/*==============================================================*/
create  index RELATIONSHIP_10_FK on HORARIO (
FECHA
);

/*==============================================================*/
/* Index: IDIOMA_PK                                             */
/*==============================================================*/
create unique index IDIOMA_PK on IDIOMA (
IDIOMA
);

/*==============================================================*/
/* Index: MES_PK                                                */
/*==============================================================*/
create unique index MES_PK on MES (
MES_ID
);

/*==============================================================*/
/* Index: NACIONALIDAD_PK                                       */
/*==============================================================*/
create unique index NACIONALIDAD_PK on NACIONALIDAD (
NACIONALIDAD
);

/*==============================================================*/
/* Index: PAGO_PK                                               */
/*==============================================================*/
create unique index PAGO_PK on PAGO (
TIPO_PAGO_ID
);

/*==============================================================*/
/* Index: PELICULAS_PK                                          */
/*==============================================================*/
create unique index PELICULAS_PK on PELICULAS (
PELICULA_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_4_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_4_FK on PELICULAS (
IDIOMA
);

/*==============================================================*/
/* Index: RELATIONSHIP_5_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_5_FK on PELICULAS (
NACIONALIDAD
);

/*==============================================================*/
/* Index: SALA_PK                                               */
/*==============================================================*/
create unique index SALA_PK on SALA (
SALA_ID
);

/*==============================================================*/
/* Index: RELATIONSHIP_1_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_1_FK on SALA (
TIPO_SALA_ID
);

/*==============================================================*/
/* Index: TIPO_CLIENTE_PK                                       */
/*==============================================================*/
create unique index TIPO_CLIENTE_PK on TIPO_CLIENTE (
TIPO_CLENTE_ID
);

/*==============================================================*/
/* Index: TIPO_SALA_PK                                          */
/*==============================================================*/
create unique index TIPO_SALA_PK on TIPO_SALA (
TIPO_SALA_ID
);