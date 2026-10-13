
-- Instrucciones de borrado exclusivo para ambientes de desarrollo o pruebas

-- NIVEL 1: Tablas de transacciones o intermedias (Nadie depende de ellas)
DROP TABLE dosis;
DROP TABLE pago;

-- NIVEL 2: Tablas que dependían del nivel 1 pero siguen teniendo llaves foráneas
DROP TABLE receta;

-- NIVEL 3: Tablas maestras secundarias (Hijas de comunas, especialidades, etc.)
DROP TABLE medico;
DROP TABLE paciente;        -- Apunta a comuna así que se borra primero.    
DROP TABLE comuna;          -- Apunta a ciudad y así.
DROP TABLE ciudad;
DROP TABLE medicamento;

-- NIVEL 4: Tablas maestras absolutas (Tablas independientes de las que todos dependen)
DROP TABLE digitador;
DROP TABLE diagnostico;
DROP TABLE tipo_receta;
DROP TABLE especialidad;
DROP TABLE banco;
DROP TABLE region;
DROP TABLE tipo_medicamento;
DROP TABLE via_administracion;


/* DROP TABLE con CASCADE CONSTRAINTS:
Para eliminar todas las restricciones de integridad referencial con la tabla

DROP TABLE banco CASCADE CONSTRAINTS;
DROP TABLE ciudad CASCADE CONSTRAINTS;
DROP TABLE comuna CASCADE CONSTRAINTS;
DROP TABLE diagnostico CASCADE CONSTRAINTS;
DROP TABLE digitador CASCADE CONSTRAINTS;
DROP TABLE dosis CASCADE CONSTRAINTS;
DROP TABLE especialidad CASCADE CONSTRAINTS;
DROP TABLE medicamento CASCADE CONSTRAINTS;
DROP TABLE medico CASCADE CONSTRAINTS;
DROP TABLE paciente CASCADE CONSTRAINTS;
DROP TABLE pago CASCADE CONSTRAINTS;
DROP TABLE receta CASCADE CONSTRAINTS;
DROP TABLE region CASCADE CONSTRAINTS;
DROP TABLE tipo_medicamento CASCADE CONSTRAINTS;
DROP TABLE tipo_receta CASCADE CONSTRAINTS;
DROP TABLE via_administracion CASCADE CONSTRAINTS;*/


-- ===================        
-- ===== CASO 1 ======
-- ===================

/* Como lo hizo el profe.
CREATE TABLE banco (
    id_banco NUMBER(4) CONSTRAINT pk_banco PRIMARY KEY,
    nombre   VARCHAR2(50 CHAR) CONSTRAINT banco_nombre_nn NOT NULL
);*/

CREATE TABLE banco (
    id_banco NUMBER(4) CONSTRAINT pk_banco PRIMARY KEY,
    nombre   VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE ciudad (
    id_ciudad NUMBER(3) CONSTRAINT pk_ciudad PRIMARY KEY,
    nombre    VARCHAR2(50 CHAR) NOT NULL,
    id_region NUMBER(2) NOT NULL
);

-- Índice autoincrementable para la tabla comuna, que comienza en 1101 y se incrementa en 1
CREATE TABLE comuna (
    id_comuna NUMBER(4) GENERATED ALWAYS AS IDENTITY
    (START WITH 1101 INCREMENT BY 1) CONSTRAINT pk_comuna PRIMARY KEY,
    nombre    VARCHAR2(50 CHAR) NOT NULL,
    id_ciudad NUMBER(3) NOT NULL
);

CREATE TABLE diagnostico (
    id_diagnostico NUMBER(3) CONSTRAINT pk_diagnostico PRIMARY KEY,
    nombre         VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE digitador (
    id_digitador NUMBER(4) CONSTRAINT pk_digitador PRIMARY KEY,
    nombres      VARCHAR2(100 CHAR) NOT NULL,
    apellidos    VARCHAR2(100 CHAR) NOT NULL
);

CREATE TABLE dosis (
    id_medicamento       VARCHAR2(7 CHAR) NOT NULL,
    id_receta            NUMBER(7) NOT NULL,
    descripcion_dosis    VARCHAR2(400 CHAR) NOT NULL,
    duracion_tratamiento NUMBER(2),
    unidades_medicamento NUMBER(2) NOT NULL
);

-- Se mantiene la definición de la clave primaria fuera de CREATE TABLE, ya que es una clave primaria compuesta por dos columnas
ALTER TABLE dosis ADD CONSTRAINT pk_dosis PRIMARY KEY (id_medicamento, id_receta);

-- ïndice autoincrementable para la tabla especialidad, que comienza en 1 y se incrementa en 1
CREATE TABLE especialidad (
    id_especialidad NUMBER(3) GENERATED ALWAYS AS IDENTITY
    (START WITH 1 INCREMENT BY 1) CONSTRAINT pk_especialidad PRIMARY KEY,
    nombre          VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE medicamento (
    id_medicamento     VARCHAR2(7 CHAR) CONSTRAINT pk_medicamento PRIMARY KEY,
    nombre             VARCHAR2(50 CHAR) NOT NULL,
    stock              NUMBER(8) NOT NULL,
    id_tipo_medicamento   NUMBER(3) NOT NULL,
    id_via_administracion NUMBER(3) NOT NULL    
);

CREATE TABLE medico (
    rut_medico      VARCHAR2(12 CHAR) CONSTRAINT pk_medico PRIMARY KEY,
    dv_medico       CHAR(1 CHAR) NOT NULL,
    nombres         VARCHAR2(100 CHAR) NOT NULL,
    apellidos       VARCHAR2(100 CHAR) NOT NULL,
    id_especialidad NUMBER(3) NOT NULL,

    -- Teléfono único para médicos
    telefono        VARCHAR2(20 CHAR) NOT NULL CONSTRAINT uk_telefono UNIQUE 
);

-- Check en dígito verificador del médico
ALTER TABLE medico 
ADD CONSTRAINT chk_dv_medico
CHECK (UPPER (dv_medico) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

-- Forma alternativa de restricción para dígito verificador
/*ALTER TABLE medico
ADD CONSTRAINT chk_dv_medico
CHECK (dv_paciente BETWEEN '0' AND '9' OR dv_paciente ='K');*/

CREATE TABLE paciente (
    rut_paciente VARCHAR2(12 CHAR) CONSTRAINT pk_paciente PRIMARY KEY,
    dv_paciente  CHAR(1 CHAR) NOT NULL,
    nombres      VARCHAR2(100 CHAR) NOT NULL,
    apellidos    VARCHAR2(100 CHAR) NOT NULL,
    edad         NUMBER(3) NOT NULL,
    telefono     VARCHAR2(20 CHAR) NOT NULL,
    calle        VARCHAR2(100 CHAR) NOT NULL,
    numeracion   NUMBER(4) NOT NULL,
    id_comuna    NUMBER(4) NOT NULL
);

-- Check en dígito verificador del paciente
ALTER TABLE paciente 
ADD CONSTRAINT chk_dv_paciente 
CHECK (UPPER (dv_paciente) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

CREATE TABLE pago (
    id_pago     NUMBER(8) CONSTRAINT pk_pago PRIMARY KEY,
    fecha_pago  DATE NOT NULL,
    monto_total NUMBER(8) NOT NULL,
    metodo_pago VARCHAR2(20 CHAR) NOT NULL,
    id_receta   NUMBER(7) NOT NULL,
    id_banco    NUMBER(4) NOT NULL
);

CREATE TABLE receta (
    id_receta         NUMBER(7) CONSTRAINT pk_receta PRIMARY KEY,
    observaciones     VARCHAR2(200 CHAR),
    fecha_emision     DATE NOT NULL,
    fecha_vencimiento DATE,
    rut_paciente      VARCHAR2(12 CHAR) NOT NULL,
    rut_medico        VARCHAR2(12 CHAR) NOT NULL,
    id_digitador      NUMBER(4) NOT NULL,
    id_diagnostico    NUMBER(3) NOT NULL,
    id_tipo_receta    NUMBER(3) NOT NULL
);

CREATE TABLE region (
    id_region NUMBER(2) CONSTRAINT pk_region PRIMARY KEY,
    nombre    VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE tipo_medicamento (
    id_tipo_medicamento NUMBER(3) CONSTRAINT pk_tipo_medicamento PRIMARY KEY,
    nombre              VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE tipo_receta (
    id_tipo_receta NUMBER(3) CONSTRAINT pk_tipo_receta PRIMARY KEY,
    nombre         VARCHAR2(25 CHAR) NOT NULL
);

CREATE TABLE via_administracion (
    id_via_administracion NUMBER(3) CONSTRAINT pk_via_administracion PRIMARY KEY,
    nombre                VARCHAR2(50 CHAR) NOT NULL
);


-- Agregar las restricciones de clave foránea a las tablas correspondientes
ALTER TABLE ciudad
ADD CONSTRAINT fk_ciudad_region 
FOREIGN KEY (id_region) REFERENCES region (id_region);

ALTER TABLE comuna
ADD CONSTRAINT fk_comuna_ciudad 
FOREIGN KEY (id_ciudad) REFERENCES ciudad (id_ciudad);

ALTER TABLE dosis
ADD CONSTRAINT fk_dosis_medicamento 
FOREIGN KEY (id_medicamento) REFERENCES medicamento (id_medicamento);

ALTER TABLE dosis
ADD CONSTRAINT fk_dosis_receta 
FOREIGN KEY (id_receta) REFERENCES receta (id_receta);

ALTER TABLE medicamento
ADD CONSTRAINT fk_med_tipo_med
FOREIGN KEY (id_tipo_medicamento) REFERENCES tipo_medicamento (id_tipo_medicamento);

ALTER TABLE medicamento
ADD CONSTRAINT fk_med_via_admin
FOREIGN KEY (id_via_administracion) REFERENCES via_administracion (id_via_administracion);

ALTER TABLE medico
ADD CONSTRAINT fk_medico_especialidad 
FOREIGN KEY (id_especialidad) REFERENCES especialidad (id_especialidad);

ALTER TABLE paciente
ADD CONSTRAINT fk_paciente_comuna 
FOREIGN KEY (id_comuna) REFERENCES comuna (id_comuna);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_banco 
FOREIGN KEY (id_banco) REFERENCES banco (id_banco);

ALTER TABLE pago
ADD CONSTRAINT fk_pago_receta 
FOREIGN KEY (id_receta) REFERENCES receta (id_receta);

ALTER TABLE receta
ADD CONSTRAINT fk_receta_diagnostico 
FOREIGN KEY (id_diagnostico) REFERENCES diagnostico (id_diagnostico);

ALTER TABLE receta
ADD CONSTRAINT fk_receta_digitador 
FOREIGN KEY (id_digitador) REFERENCES digitador (id_digitador);

ALTER TABLE receta
ADD CONSTRAINT fk_receta_medico 
FOREIGN KEY (rut_medico) REFERENCES medico (rut_medico);

ALTER TABLE receta
ADD CONSTRAINT fk_receta_paciente 
FOREIGN KEY (rut_paciente) REFERENCES paciente (rut_paciente);

ALTER TABLE receta
ADD CONSTRAINT fk_receta_tipo_receta 
FOREIGN KEY (id_tipo_receta) REFERENCES tipo_receta (id_tipo_receta);
        
        
-- ===================        
-- ===== CASO 2 ======
-- ===================

-- Agregar precio unitario a la tabla medicamento
ALTER TABLE medicamento ADD precio_unitario NUMBER(7) NOT NULL;

-- Definir un CHECK para el precio unitario, asegurando que esté entre 1000 y 2000000
ALTER TABLE medicamento
ADD CONSTRAINT chk_precio_unitario
CHECK (precio_unitario BETWEEN 1000 AND 2000000);

-- Definir un CHECK para el método de pago, asegurando que solo se acepten los valores 'EFECTIVO', 'TARJETA' o 'TRANSFERENCIA'
ALTER TABLE pago
ADD CONSTRAINT chk_metodo_pago
CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA'));

-- Optimizar datos, eliminar columna EDAD y reemplazar por FECHA_NACIMIENTO en la tabla paciente
ALTER TABLE paciente DROP COLUMN edad;
ALTER TABLE paciente ADD fecha_nacimiento DATE NOT NULL;
