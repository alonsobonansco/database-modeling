
-- DROPS PARA PRUEBAS

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


-- ==================================
-- CASO 1 - IMPLEMENTACION DEL MODELO
-- ==================================

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

-- debería ser clave primaria compuesta
CREATE TABLE comuna (
    id_comuna NUMBER(5),
    nombre_comuna VARCHAR2(50 CHAR) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT pk_comuna PRIMARY KEY (id_comuna, cod_region)
);

CREATE TABLE compania (
    id_empresa NUMBER(2) CONSTRAINT pk_compania PRIMARY KEY,

    -- Nombre de la companía único
    nombre_empresa VARCHAR2(50 CHAR) NOT NULL CONSTRAINT uk_nombre_empresa UNIQUE,
    
    calle VARCHAR2(50 CHAR) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    renta_promedio NUMBER(10),
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL
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

    /*Se deja NUMBER(5) para ser 100% fiel a la pauta aunque luego se pida
    una restricción de CHECK para que sea mayor o igual a 450000 (NUMBER(6) como mínimo)*/
    sueldo NUMBER(6) NOT NULL, 

    cod_comuna NUMBER(5) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
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


-- AGREGAR FOREIGN KEYS

ALTER TABLE comuna 
ADD CONSTRAINT fk_comuna_region 
FOREIGN KEY (cod_region) REFERENCES region(id_region);

--agregué clave foranea compuesta
ALTER TABLE compania
ADD CONSTRAINT fk_compania_comuna
FOREIGN KEY (cod_comuna, cod_region) REFERENCES comuna(id_comuna, cod_region);

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

--agregué la clave foranea compuesta
ALTER TABLE personal
ADD CONSTRAINT fk_personal_comuna
FOREIGN KEY (cod_comuna, cod_region) REFERENCES comuna(id_comuna, cod_region);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_genero
FOREIGN KEY (cod_genero) REFERENCES genero(id_genero);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_region
FOREIGN KEY (cod_region) REFERENCES region(id_region);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_estado_civil
FOREIGN KEY (cod_estado_civil) REFERENCES estado_civil(id_estado_civil);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_compania
FOREIGN KEY (cod_empresa) REFERENCES compania(id_empresa);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_encargado
FOREIGN KEY (encargado_rut) REFERENCES personal(rut_persona);


-- =================================
-- CASO 2 - MODIFICACION DEL MODELO
-- =================================

ALTER TABLE personal
ADD CONSTRAINT uk_personal_email UNIQUE (email);

ALTER TABLE personal
ADD CONSTRAINT chk_dv_personal
CHECK (UPPER (dv_persona) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

ALTER TABLE personal
ADD CONSTRAINT chk_sueldo_personal
CHECK (sueldo >= 450000);


-- ================================
-- CASO 3 - POBLAMIENTO DEL MODELO
-- ================================

DROP SEQUENCE seq_comuna;
DROP SEQUENCE seq_compania;

-- Objetos secuencia
CREATE SEQUENCE seq_comuna
    START WITH 1101
    INCREMENT BY 6;
    -- NOCACHE

CREATE SEQUENCE seq_compania
    START WITH 10
    INCREMENT BY 5;
    -- NOCACHE


-- Poblamiento de tablas idioma, region, comuna y compania

-- insert idioma identity
INSERT INTO idioma (
    nombre_idioma
) VALUES (
    'Ingles'
);

INSERT INTO idioma (
    nombre_idioma
) VALUES (
    'Chino'
);

INSERT INTO idioma (
    nombre_idioma
) VALUES (
    'Aleman'
);

INSERT INTO idioma (
    nombre_idioma
) VALUES (
    'Espanol'
);

INSERT INTO idioma (
    nombre_idioma
) VALUES (
    'Frances'
);

-- prueba idiomas
SELECT * FROM idioma;

-- insert region identity
INSERT INTO region (
    nombre_region
) VALUES (
    'ARICA Y PARINACOTA'
);

INSERT INTO region (
    nombre_region
) VALUES (
    'METROPOLITANA'
);

INSERT INTO region (
    nombre_region
) VALUES (
    'LA ARAUCANIA'
);

-- prueba regiones
SELECT * FROM region;

--insert comuna sequence
INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    cod_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Arica',
    7
);

INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    cod_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Santiago',
    9
);

INSERT INTO comuna (
    id_comuna,
    nombre_comuna,
    cod_region
) VALUES (
    seq_comuna.NEXTVAL,
    'Temuco',
    11
);

-- prueba comunas
SELECT * FROM comuna;

--insert compania sequence

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'CCyRojas',
    'Amapolas',
    506,
    1857000,
    0.5,
    1101,
    7
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'SenTTy',
    'Los Alamos',
    3490,
    897000,
    0.025,
    1101,
    7
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'Praxia LTDA',
    'Las Camelias',
    11098,
    2157000,
    0.035,
    1107,
    9
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'TIC spa',
    'FLORES S.A.',
    4357,
    857000,
    NULL,
    1107,
    9
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'SANTANA LTDA',
    'AVDA VIC. MACKENA',
    106,
    757000,
    0.015,
    1101,
    7
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'FLORES Y ASOCIADOS',
    'PEDRO LATORRE',
    557,
    589000,
    0.015,
    1107,
    9
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'J.A. HOFFMAN',
    'LATINA D.32',
    509,
    1857000,
    0.025,
    1113,
    11
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'CAGLIARI D.',
    'ALAMEDA',
    206,
    1857000,
    NULL,
    1107,
    9
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'Rojas HNOS LTDA',
    'SUCRE',
    106,
    957000,
    0.005,
    1113,
    11
);

INSERT INTO compania (
    id_empresa,
    nombre_empresa,
    calle,
    numeracion,
    renta_promedio,
    pct_aumento,
    cod_comuna,
    cod_region
) VALUES (
    seq_compania.NEXTVAL,
    'FRIENDS P. S.A',
    'SUECIA',
    506,
    857000,
    0.015,
    1113,
    11
);

-- prueba companias
SELECT * FROM compania;


-- ===============================
-- CASO 4 - RECUPERACION DE DATOS
-- ===============================

-- Informe 1
/*
Se requiere que el informe incluya los siguientes datos:
• El nombre de la empresa
• La dirección completa
• La renta promedio de cada una
• La simulación de la renta promedio aplicando el porcentaje de aumento
correspondiente
Ordena la información en función de la columna " Renta Promedio " de mayor a menor. En caso de empate, organiza las filas
alfabéticamente por " Nombre Empresa "
*/

SELECT 
    nombre_empresa AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección",
    renta_promedio AS "Renta Promedio",
    renta_promedio * (1 + pct_aumento) AS "Simulación de Renta"
FROM compania
ORDER BY 
    "Renta Promedio" DESC,
    "Nombre Empresa" ASC;

-- Informe 2
/* 
    NOTA: el resultado con esta query se ve diferente al presentado en las instrucciones específicas
    porque el modelo entregado en estas no se encuentra ordenado de forma descendente en la 
    columna EMPRESA (nombre_empresa)
*/
SELECT
    id_empresa AS CODIGO,
    nombre_empresa AS EMPRESA,
    renta_promedio AS "PROM RENTA ACTUAL",
    pct_aumento + 0.15 AS "PCT AUMENTADO EN 15%",
    renta_promedio * (pct_aumento + 0.15) AS "RENTA AUMENTADA"
FROM compania
ORDER BY renta_promedio ASC, nombre_empresa DESC;


/*Usa en las 
sentencias de consulta 
SQL operadores 
matemáticos, alias y 
cláusulas de 
ordenamiento para 
solucionar los 
requerimientos de 
información planteados.*/
