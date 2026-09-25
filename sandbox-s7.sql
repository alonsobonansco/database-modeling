-- =====================
-- DROPS PARA PRUEBAS
-- =====================

DROP TABLE dominio;
DROP TABLE titulacion;
DROP TABLE personal;
DROP TABLE compania;
DROP TABLE comuna;
DROP TABLE region;
DROP TABLE estado_civil;
DROP TABLE idioma;
DROP TABLE titulo;
DROP TABLE genero;


-- ====================
-- CREACION TABLAS
-- ====================

CREATE TABLE estado_civil (
    id_estado_civil VARCHAR2(2 CHAR) CONSTRAINT pk_estado_civil PRIMARY KEY,
    descripcion_est_civil VARCHAR2(25 CHAR) NOT NULL
);

CREATE TABLE region (
    id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY
    (START WITH 7 INCREMENT BY 2) CONSTRAINT pk_region PRIMARY KEY,
    nombre_region VARCHAR2(25 CHAR) NOT NULL
);

CREATE TABLE titulo (
    id_titulo VARCHAR2(3 CHAR) CONSTRAINT pk_titulo PRIMARY KEY,
    descripcion_titulo VARCHAR2(60 CHAR) NOT NULL
);

CREATE TABLE idioma (
    id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY 
    (START WITH 25 INCREMENT BY 3) CONSTRAINT pk_idioma PRIMARY KEY,
    nombre_idioma VARCHAR2(30 CHAR) NOT NULL
);

CREATE TABLE genero (
    id_genero VARCHAR2(3 CHAR) CONSTRAINT pk_genero PRIMARY KEY,
    descripcion_genero VARCHAR2(25 CHAR) NOT NULL
);

CREATE TABLE comuna (
    id_comuna NUMBER(5) CONSTRAINT pk_comuna PRIMARY KEY,
    nombre_comuna VARCHAR2(50 CHAR) NOT NULL,
    id_region NUMBER(2) NOT NULL
);

CREATE TABLE compania (
    id_empresa NUMBER(2) CONSTRAINT pk_compania PRIMARY KEY,

    -- Nombre de la companía único
    nombre_empresa VARCHAR2(50 CHAR) NOT NULL CONSTRAINT uk_nombre_empresa UNIQUE,
    
    calle VARCHAR2(50 CHAR) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    id_region NUMBER(2) NOT NULL,
    renta_promedio NUMBER(10),
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5) NOT NULL
    -- cod_region NUMBER(2) NOT NULL
);

CREATE TABLE personal (
    rut_persona NUMBER(8) CONSTRAINT pk_personal PRIMARY KEY,
    dv_persona CHAR(1) NOT NULL,
    primer_nombre VARCHAR2(25 CHAR) NOT NULL,
    segundo_nombre VARCHAR2(25 CHAR),
    primer_apellido VARCHAR2(25 CHAR) NOT NULL,
    segundo_apellido VARCHAR2(25 CHAR) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR2(100 CHAR),
    calle VARCHAR2(50 CHAR) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    sueldo NUMBER(5) NOT NULL, 
    cod_comuna NUMBER(5) NOT NULL,
    -- cod_region NUMBER(2) NOT NULL,
    cod_genero VARCHAR2(3 CHAR),
    cod_estado_civil VARCHAR2(2 CHAR),
    cod_empresa NUMBER(2) NOT NULL,
    encargado_rut NUMBER(8)
);

CREATE TABLE titulacion (
    cod_titulo VARCHAR2(3 CHAR),
    persona_rut NUMBER(8) NOT NULL,
    fecha_titulacion DATE NOT NULL
);

ALTER TABLE titulacion ADD CONSTRAINT pk_titulacion PRIMARY KEY (cod_titulo, persona_rut);

CREATE TABLE dominio (
    id_idioma NUMBER(3),
    persona_rut NUMBER(8) NOT NULL,
    nivel VARCHAR2(25 CHAR) NOT NULL
);

ALTER TABLE dominio ADD CONSTRAINT pk_dominio PRIMARY KEY (id_idioma, persona_rut);


-- ====================
-- AGREGAR FOREIGN KEYS
-- ====================

ALTER TABLE comuna 
ADD CONSTRAINT fk_comuna_region 
FOREIGN KEY (id_region) REFERENCES region(id_region);

ALTER TABLE compania
ADD CONSTRAINT fk_compania_comuna
FOREIGN KEY (cod_comuna) REFERENCES comuna(id_comuna);

ALTER TABLE dominio
ADD CONSTRAINT fk_dominio_idioma
FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma);

ALTER TABLE dominio
ADD CONSTRAINT fk_dominio_personal
FOREIGN KEY (persona_rut) REFERENCES personal(rut_persona);

ALTER TABLE titulacion
ADD CONSTRAINT fk_titulacion_titulo
FOREIGN KEY (cod_titulo) REFERENCES titulo(id_titulo);

ALTER TABLE titulacion
ADD CONSTRAINT fk_titulacion_personal
FOREIGN KEY (persona_rut) REFERENCES personal(rut_persona);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_comuna
FOREIGN KEY (cod_comuna) REFERENCES comuna(id_comuna);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_genero
FOREIGN KEY (cod_genero) REFERENCES genero(id_genero);

/*ALTER TABLE personal
ADD CONSTRAINT fk_personal_region
FOREIGN KEY (cod_region) REFERENCES region(id_region);*/

ALTER TABLE personal
ADD CONSTRAINT fk_personal_estado_civil
FOREIGN KEY (cod_estado_civil) REFERENCES estado_civil(id_estado_civil);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_compania
FOREIGN KEY (cod_empresa) REFERENCES compania(id_empresa);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_encargado
FOREIGN KEY (encargado_rut) REFERENCES personal(rut_persona);

-- ====================
-- CASO 2 - MODIFICACION MODELO, ALTER TABLE
-- ====================

ALTER TABLE personal
ADD CONSTRAINT uk_personal_email UNIQUE (email);

ALTER TABLE personal
ADD CONSTRAINT chk_dv_personal
CHECK (UPPER (dv_persona) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

ALTER TABLE personal
ADD CONSTRAINT chk_sueldo_personal
CHECK (sueldo >= 450000);


-- ====================
-- CASO 3 - OBJETO SECUENCIA Y POBLACION DE DATOS
-- ====================

DROP SEQUENCE seq_comuna;

CREATE SEQUENCE seq_comuna
    START WITH 1101
    INCREMENT BY 6;
    -- NOCACHE

DROP SEQUENCE seq_compania;

CREATE SEQUENCE seq_compania
    START WITH 10
    INCREMENT BY 5;
    -- NOCACHE


-- poblar tablas: region, comuna, idioma, compania (más fuerte a más débil)

INSERT INTO region (
    nombre_region
) VALUES (
    'Arica y Parinacota'
);

INSERT INTO region (
    nombre_region
) VALUES (
    'Metropolitana'
);

INSERT INTO region (
    nombre_region
) VALUES (
    'La Araucanía'
);

INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    id_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Arica',
    7
);

INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    id_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Santiago',
    9
);

INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    id_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Temuco',
    11
);
