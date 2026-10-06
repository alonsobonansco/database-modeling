
-- Drops para pruebas

DROP TABLE idioma_jugador;
DROP TABLE permanencia_club;
DROP TABLE jugador;
DROP TABLE personal;
DROP TABLE trabajador;
DROP TABLE comuna;
DROP TABLE region;
DROP TABLE genero;
DROP TABLE estado_civil;
DROP TABLE nacionalidad;
DROP TABLE asociacion;
DROP TABLE escuela;
DROP TABLE posicion_campo;
DROP TABLE idioma;
DROP TABLE club;

DROP SEQUENCE seq_club;


-- CREACIÓN DE TABLAS

CREATE TABLE genero (
    codigo_genero NUMBER(2) CONSTRAINT pk_genero PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE estado_civil (
    codigo_estado_civil NUMBER(2) CONSTRAINT pk_estado_civil PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

-- Identity, comienza en 210, incrementa de 2 en 2
CREATE TABLE nacionalidad (
    codigo_nacionalidad NUMBER(3) GENERATED ALWAYS AS IDENTITY
    (START WITH 210 INCREMENT BY 2) CONSTRAINT pk_nacionalidad PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE asociacion (
    codigo_asociacion NUMBER(2) CONSTRAINT pk_asociacion PRIMARY KEY,
    nombre VARCHAR2(50 CHAR) NOT NULL,
    fecha_creacion DATE NOT NULL,
    tipo_asociacion CHAR(1) NOT NULL
);

CREATE TABLE escuela (
    codigo_escuela NUMBER(4) CONSTRAINT pk_escuela PRIMARY KEY,
    nombre VARCHAR2(50 CHAR) NOT NULL,
    capacidad NUMBER(5) NOT NULL,
    fecha_fundacion DATE NOT NULL
);

CREATE TABLE posicion_campo (
    codigo_posicion NUMBER(2) CONSTRAINT pk_posicion_campo PRIMARY KEY,
    descripcion VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE club (
    codigo_club NUMBER(3) CONSTRAINT pk_club PRIMARY KEY,
    nombre VARCHAR2(50 CHAR) NOT NULL,
    patrimonio NUMBER(11) NOT NULL,
    direccion VARCHAR2(200 CHAR) NOT NULL,
    tipo_club VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE idioma (
    codigo_idioma NUMBER(3) CONSTRAINT pk_idioma PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE region (
    codigo_region NUMBER(2) CONSTRAINT pk_region PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE comuna (
    codigo_comuna NUMBER(3) CONSTRAINT pk_comuna PRIMARY KEY,
    nombre VARCHAR2(50 CHAR) NOT NULL,
    codigo_region NUMBER(2) NOT NULL
);

CREATE TABLE trabajador (
    codigo_inscripcion NUMBER(9) CONSTRAINT pk_trabajador PRIMARY KEY,
    rut NUMBER(8),
    dv CHAR(1) NOT NULL,
    nombres VARCHAR2(100 CHAR) NOT NULL,
    apellido_paterno VARCHAR2(50 CHAR) NOT NULL,
    apellido_materno VARCHAR2(50 CHAR) NOT NULL,
    sueldo NUMBER(8) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono_movil VARCHAR2(20 CHAR),
    email VARCHAR2(100 CHAR),
    direccion VARCHAR2(150 CHAR) NOT NULL,
    codigo_comuna NUMBER(3) NOT NULL,
    codigo_nacionalidad NUMBER(3) NOT NULL,
    codigo_estado_civil NUMBER(2) NOT NULL,
    codigo_genero NUMBER(2) NOT NULL
);

CREATE TABLE personal (
    codigo_inscripcion NUMBER(9) CONSTRAINT pk_personal PRIMARY KEY,
    horas_trabajadas NUMBER(7),
    valor_hora_extra NUMBER(6)
);

CREATE TABLE jugador (
    codigo_inscripcion NUMBER(9) CONSTRAINT pk_jugador PRIMARY KEY,
    monto_total NUMBER(8) NOT NULL,
    codigo_posicion NUMBER(2) NOT NULL,
    anio_egreso_amateur NUMBER(4),
    codigo_asociacion NUMBER(2) NOT NULL,
    codigo_escuela NUMBER(4)
);

CREATE TABLE idioma_jugador (
    codigo_inscripcion NUMBER(9), --  No es necesario poner NOT NULL porque se añade CONSTRAINT dentro de la creación de la tabla
    codigo_idioma NUMBER(3),
    nivel_dominio VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT pk_idioma_jugador PRIMARY KEY (codigo_inscripcion, codigo_idioma)
);

CREATE TABLE permanencia_club (
    codigo_inscripcion NUMBER(9),
    codigo_club NUMBER(3),
    fecha_inicio DATE NOT NULL,
    fecha_termino DATE,
    CONSTRAINT pk_permanencia_club PRIMARY KEY (codigo_inscripcion, codigo_club)
);


-- AGREGAR CLAVES FORÁNEAS

ALTER TABLE comuna
ADD CONSTRAINT fk_comuna_region
FOREIGN KEY (codigo_region) REFERENCES region (codigo_region);

ALTER TABLE trabajador
ADD CONSTRAINT fk_trabajador_comuna
FOREIGN KEY (codigo_comuna) REFERENCES comuna (codigo_comuna);

ALTER TABLE trabajador
ADD CONSTRAINT fk_trabajador_nacionalidad
FOREIGN KEY (codigo_nacionalidad) REFERENCES nacionalidad (codigo_nacionalidad);

ALTER TABLE trabajador
ADD CONSTRAINT fk_trabajador_estado_civil
FOREIGN KEY (codigo_estado_civil) REFERENCES estado_civil (codigo_estado_civil);

ALTER TABLE trabajador
ADD CONSTRAINT fk_trabajador_genero
FOREIGN KEY (codigo_genero) REFERENCES genero (codigo_genero);

ALTER TABLE personal
ADD CONSTRAINT fk_personal_trabajador
FOREIGN KEY (codigo_inscripcion) REFERENCES trabajador (codigo_inscripcion);

ALTER TABLE jugador
ADD CONSTRAINT fk_jugador_trabajador
FOREIGN KEY (codigo_inscripcion) REFERENCES trabajador (codigo_inscripcion);

ALTER TABLE jugador
ADD CONSTRAINT fk_jugador_posicion_campo
FOREIGN KEY (codigo_posicion) REFERENCES posicion_campo (codigo_posicion);

ALTER TABLE jugador
ADD CONSTRAINT fk_jugador_asociacion
FOREIGN KEY (codigo_asociacion) REFERENCES asociacion (codigo_asociacion);

ALTER TABLE jugador
ADD CONSTRAINT fk_jugador_escuela
FOREIGN KEY (codigo_escuela) REFERENCES escuela (codigo_escuela);

ALTER TABLE idioma_jugador
ADD CONSTRAINT fk_idioma_jugador_jugador
FOREIGN KEY (codigo_inscripcion) REFERENCES jugador (codigo_inscripcion);

ALTER TABLE idioma_jugador
ADD CONSTRAINT fk_idioma_jugador_idioma
FOREIGN KEY (codigo_idioma) REFERENCES idioma (codigo_idioma);

ALTER TABLE permanencia_club
ADD CONSTRAINT fk_permanencia_club_jugador
FOREIGN KEY (codigo_inscripcion) REFERENCES jugador (codigo_inscripcion);

ALTER TABLE permanencia_club
ADD CONSTRAINT fk_permanencia_club_club
FOREIGN KEY (codigo_club) REFERENCES club (codigo_club);


-- RESTRICCIONES SOLICITADAS

-- Nombre único para club
ALTER TABLE club ADD CONSTRAINT uk_club_nombre UNIQUE (nombre);

-- Fecha creación asociacion >= 31/12/1980
ALTER TABLE asociacion ADD CONSTRAINT ck_asociacion_fecha_creacion CHECK (fecha_creacion >= DATE '1980-12-31');

-- Secuencia para código de club, comienza en 703, incrementa de 4 en 4
CREATE SEQUENCE seq_club START WITH 703 INCREMENT BY 4;


-- POBLAMIENTO DE TABLAS

-- valores region

INSERT INTO region (codigo_region, nombre) VALUES (1, 'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO region (codigo_region, nombre) VALUES (2, 'ANTOFAGASTA');
INSERT INTO region (codigo_region, nombre) VALUES (3, 'ATACAMA Y COQUIMBO');
INSERT INTO region (codigo_region, nombre) VALUES (5, 'VALPARAISO');
INSERT INTO region (codigo_region, nombre) VALUES (13, 'METROPOLITANA');

-- Valores para parchar los datos entregados en las instruccione
INSERT INTO region (codigo_region, nombre) VALUES (8, 'REGIÓN DEL BÍO-BÍO (DUMMY)');
INSERT INTO region (codigo_region, nombre) VALUES (16, 'REGIÓN DE ÑUBLE (DUMMY)');

COMMIT;

-- valores comuna

INSERT INTO comuna (codigo_comuna, nombre, codigo_region) VALUES (101, 'Santiago', 13);
INSERT INTO comuna (codigo_comuna, nombre, codigo_region) VALUES (102, 'Valparaíso', 5);
INSERT INTO comuna (codigo_comuna, nombre, codigo_region) VALUES (103, 'Concepción', 8);
INSERT INTO comuna (codigo_comuna, nombre, codigo_region) VALUES (104, 'Antofagasta', 2);
INSERT INTO comuna (codigo_comuna, nombre, codigo_region) VALUES (105, 'Chillán', 16);

COMMIT;

-- valores asociacion

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (25, 'Asociación de Fútbol de Santiago', TO_DATE('15-05-2001', 'DD-MM-YYYY'), 'P');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (26, 'Asociación Nacional de Fútbol Amateur', TO_DATE('10-03-1998', 'DD-MM-YYYY'), 'A');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (27, 'Asociación de Fútbol de Valparaíso', TO_DATE('21-07-1987', 'DD-MM-YYYY'), 'P');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (28, 'Asociación de Fútbol de Concepción', TO_DATE('30-11-1995', 'DD-MM-YYYY'), 'A');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (29, 'Asociación de Fútbol de Antofagasta', TO_DATE('25-06-2003', 'DD-MM-YYYY'), 'P');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (30, 'Asociación de Fútbol de Temuco', TO_DATE('12-01-2010', 'DD-MM-YYYY'), 'A');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (31, 'Asociación de Fútbol de Rancagua', TO_DATE('08-09-1999', 'DD-MM-YYYY'), 'P');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (32, 'Asociación de Fútbol de Puerto Montt', TO_DATE('20-04-2005', 'DD-MM-YYYY'), 'A');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (33, 'Asociación de Fútbol de La Serena', TO_DATE('14-08-2012', 'DD-MM-YYYY'), 'P');

INSERT INTO asociacion (codigo_asociacion, nombre, fecha_creacion, tipo_asociacion)
VALUES (34, 'Asociación de Fútbol de Chillán', TO_DATE('01-12-2018', 'DD-MM-YYYY'), 'A');

COMMIT;

-- valores nacionalidad

INSERT INTO nacionalidad (descripcion) VALUES ('Chilena');
INSERT INTO nacionalidad (descripcion) VALUES ('Argentina');
INSERT INTO nacionalidad (descripcion) VALUES ('Peruana');
INSERT INTO nacionalidad (descripcion) VALUES ('Boliviana');
INSERT INTO nacionalidad (descripcion) VALUES ('Brasileña');

COMMIT;

-- valores club

INSERT INTO club (codigo_club, nombre, patrimonio, direccion, tipo_club)
VALUES (seq_club.NEXTVAL, 'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');

INSERT INTO club (codigo_club, nombre, patrimonio, direccion, tipo_club)
VALUES (seq_club.NEXTVAL, 'Universidad de Chile', 450000000, 'Av. El Parrón 0931', 'Profesional');

INSERT INTO club (codigo_club, nombre, patrimonio, direccion, tipo_club)
VALUES (seq_club.NEXTVAL, 'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');

INSERT INTO club (codigo_club, nombre, patrimonio, direccion, tipo_club)
VALUES (seq_club.NEXTVAL, 'Huachipato', 220000000, 'Avenida Desiderio García 909', 'Profesional');

INSERT INTO club (codigo_club, nombre, patrimonio, direccion, tipo_club)
VALUES (seq_club.NEXTVAL, 'Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

COMMIT;


-- RECUPERACIÓN DE DATOS

-- 1
SELECT
    'ID:' || codigo_asociacion || ' * ' || nombre AS ASOCIACION,
    TO_CHAR(fecha_creacion, 'DD-MM-YYYY') AS CREADA,
    tipo_asociacion AS TIPO
FROM asociacion
WHERE fecha_creacion > TO_DATE('2000-12-31', 'YYYY-MM-DD')
    AND tipo_asociacion = 'P'
ORDER BY fecha_creacion DESC;

-- 2
SELECT
    codigo_club AS CLUB,
    nombre AS NOMBRE_CLUB,
    TO_CHAR(patrimonio, '$999,999,999,999') AS PATRIMONIO_EN_PESOS,
    TO_CHAR(patrimonio / 955, '999,999,999.99') AS PATRIMONIO_EN_DOLARES
FROM club
WHERE LOWER(nombre) LIKE '%a%'
    AND patrimonio > 200000000
    AND tipo_club = 'Profesional'
ORDER BY codigo_club DESC;
