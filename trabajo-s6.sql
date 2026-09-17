/*DROP TABLE banco CASCADE CONSTRAINTS;
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
DROP TABLE tipo_receta CASCADE CONSTRAINTS;*/


DROP TABLE dosis;
DROP TABLE pago;
DROP TABLE receta;
DROP TABLE medico;
DROP TABLE medicamento;
DROP TABLE digitador;
DROP TABLE diagnostico;
DROP TABLE tipo_receta;
DROP TABLE paciente;
DROP TABLE especialidad;
DROP TABLE banco;
DROP TABLE comuna;
DROP TABLE ciudad;
DROP TABLE region;


-- ===================        
-- ===== CASO 1 ======
-- ===================

CREATE TABLE banco (
    id_banco NUMBER(4) NOT NULL,
    nombre   VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE banco ADD CONSTRAINT pk_banco PRIMARY KEY (id_banco);

CREATE TABLE ciudad (
    id_ciudad NUMBER(3) NOT NULL,
    nombre    VARCHAR2(50 CHAR) NOT NULL,
    id_region NUMBER(2) NOT NULL
);

ALTER TABLE ciudad ADD CONSTRAINT pk_ciudad PRIMARY KEY (id_ciudad);

-- ALTERACION DE LA TABLA
CREATE TABLE comuna (
    id_comuna NUMBER(4) GENERATED ALWAYS AS IDENTITY
    (START WITH 1101 INCREMENT BY 1) PRIMARY KEY,
    nombre    VARCHAR2(50 CHAR) NOT NULL,
    id_ciudad NUMBER(3) NOT NULL
);

CREATE TABLE diagnostico (
    id_diagnostico NUMBER(3) NOT NULL,
    nombre         VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE diagnostico ADD CONSTRAINT pk_diagnostico PRIMARY KEY (id_diagnostico);

CREATE TABLE digitador (
    id_digitador NUMBER(4) NOT NULL,
    nombres      VARCHAR2(100 CHAR) NOT NULL,
    apellidos    VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE digitador ADD CONSTRAINT pk_digitador PRIMARY KEY (id_digitador);

CREATE TABLE dosis (
    id_medicamento       VARCHAR2(7 CHAR) NOT NULL,
    id_receta            NUMBER(7) NOT NULL,
    descripcion_dosis    VARCHAR2(400 CHAR) NOT NULL,
    duracion_tratamiento NUMBER(2),
    unidades_medicamento NUMBER(2) NOT NULL
);

ALTER TABLE dosis ADD CONSTRAINT pk_dosis PRIMARY KEY (id_medicamento,
                                                        id_receta);
-- ALTERACION DE LA TABLA
CREATE TABLE especialidad (
    id_especialidad NUMBER(3) GENERATED ALWAYS AS IDENTITY
    (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    nombre          VARCHAR2(50 CHAR) NOT NULL
);

CREATE TABLE medicamento (
    id_medicamento     VARCHAR2(7 CHAR) NOT NULL,
    nombre             VARCHAR2(50 CHAR) NOT NULL,
    tipo_medicamento   VARCHAR2(50 CHAR) NOT NULL,
    via_administracion VARCHAR2(50 CHAR) NOT NULL,
    stock              NUMBER(8) NOT NULL
);

ALTER TABLE medicamento ADD CONSTRAINT pk_medicamento PRIMARY KEY (id_medicamento);

-- ALTERACION DE LA TABLA
CREATE TABLE medico (
    rut_medico      VARCHAR2(12 CHAR) NOT NULL,
    dv_medico       CHAR(1 CHAR) NOT NULL,
    nombres         VARCHAR2(100 CHAR) NOT NULL,
    apellidos       VARCHAR2(100 CHAR) NOT NULL,
    id_especialidad NUMBER(3) NOT NULL,
    telefono        VARCHAR2(20 CHAR) NOT NULL
);

ALTER TABLE medico 
ADD CONSTRAINT chk_dv_medico
CHECK (UPPER (dv_medico) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

ALTER TABLE medico ADD CONSTRAINT pk_medico PRIMARY KEY (rut_medico);

-- TELEFONO UNICO PARA MEDICOS
ALTER TABLE medico ADD CONSTRAINT uk_telefono UNIQUE (telefono);

-- ALTERACION DE LA TABLA
CREATE TABLE paciente (
    rut_paciente VARCHAR2(12 CHAR) NOT NULL,
    dv_paciente  CHAR(1 CHAR) NOT NULL,
    nombres      VARCHAR2(100 CHAR) NOT NULL,
    apellidos    VARCHAR2(100 CHAR) NOT NULL,
    edad         NUMBER(3) NOT NULL,
    telefono     NUMBER(11) NOT NULL,
    calle        VARCHAR2(100 CHAR) NOT NULL,
    numeracion   NUMBER(4) NOT NULL,
    id_comuna    NUMBER(4) NOT NULL
);

ALTER TABLE paciente ADD CONSTRAINT pk_paciente PRIMARY KEY (rut_paciente);

ALTER TABLE paciente 
ADD CONSTRAINT chk_dv_paciente 
CHECK (UPPER (dv_paciente) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K'));

-- FORMA ALTERNATIVA
/*ALTER TABLE paciente
ADD CONSTRAINT chk_dv_paciente
CHECK (dv_paciente BETWEEN '0' AND '9' OR dv_paciente ='K');*/

CREATE TABLE pago (
    id_pago     NUMBER(8) NOT NULL,
    fecha_pago  DATE NOT NULL,
    monto_total NUMBER(8) NOT NULL,
    metodo_pago VARCHAR2(20 CHAR) NOT NULL,
    id_receta   NUMBER(7) NOT NULL,
    id_banco    NUMBER(4) NOT NULL
);

ALTER TABLE pago ADD CONSTRAINT pk_pago PRIMARY KEY (id_pago);

CREATE TABLE receta (
    id_receta         NUMBER(7) NOT NULL,
    observaciones     VARCHAR2(200 CHAR),
    fecha_emision     DATE NOT NULL,
    fecha_vencimiento DATE,
    rut_paciente      VARCHAR2(12 CHAR) NOT NULL,
    rut_medico        VARCHAR2(12 CHAR) NOT NULL,
    id_digitador      NUMBER(4) NOT NULL,
    id_diagnostico    NUMBER(3) NOT NULL,
    id_tipo_receta    NUMBER(3) NOT NULL
);

ALTER TABLE receta ADD CONSTRAINT pk_receta PRIMARY KEY (id_receta);

CREATE TABLE region (
    id_region NUMBER(2) NOT NULL,
    nombre    VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE region ADD CONSTRAINT pk_region PRIMARY KEY (id_region);

CREATE TABLE tipo_receta (
    id_tipo_receta NUMBER(3) NOT NULL,
    nombre         VARCHAR2(25 CHAR) NOT NULL
);

ALTER TABLE tipo_receta ADD CONSTRAINT pk_tipo_receta PRIMARY KEY (id_tipo_receta);

ALTER TABLE ciudad
    ADD CONSTRAINT fk_ciudad_region FOREIGN KEY (id_region)
        REFERENCES region (id_region);

ALTER TABLE comuna
    ADD CONSTRAINT fk_comuna_ciudad FOREIGN KEY (id_ciudad)
        REFERENCES ciudad (id_ciudad);

ALTER TABLE dosis
    ADD CONSTRAINT fk_dosis_medicamento FOREIGN KEY (id_medicamento)
        REFERENCES medicamento (id_medicamento);

ALTER TABLE dosis
    ADD CONSTRAINT fk_dosis_receta FOREIGN KEY (id_receta)
        REFERENCES receta (id_receta);

ALTER TABLE medico
    ADD CONSTRAINT fk_medico_especialidad FOREIGN KEY (id_especialidad)
        REFERENCES especialidad (id_especialidad);

ALTER TABLE paciente
    ADD CONSTRAINT fk_paciente_comuna FOREIGN KEY (id_comuna)
        REFERENCES comuna (id_comuna);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_banco FOREIGN KEY (id_banco)
        REFERENCES banco (id_banco);

ALTER TABLE pago
    ADD CONSTRAINT fk_pago_receta FOREIGN KEY (id_receta)
        REFERENCES receta (id_receta);

ALTER TABLE receta
    ADD CONSTRAINT fk_receta_diagnostico FOREIGN KEY (id_diagnostico)
        REFERENCES diagnostico (id_diagnostico);

ALTER TABLE receta
    ADD CONSTRAINT fk_receta_digitador FOREIGN KEY (id_digitador)
        REFERENCES digitador (id_digitador);

ALTER TABLE receta
    ADD CONSTRAINT fk_receta_medico FOREIGN KEY (rut_medico)
        REFERENCES medico (rut_medico);

ALTER TABLE receta
    ADD CONSTRAINT fk_receta_paciente FOREIGN KEY (rut_paciente)
        REFERENCES paciente (rut_paciente);

ALTER TABLE receta
    ADD CONSTRAINT fk_receta_tipo_receta FOREIGN KEY (id_tipo_receta)
        REFERENCES tipo_receta (id_tipo_receta);
        
        
-- ===================        
-- ===== CASO 2 ======
-- ===================

-- AGREGAR PRECIO MEDICAMENTO
ALTER TABLE medicamento ADD precio_unitario NUMBER(7) NOT NULL;

-- DEFINIR RANGO PRECIO MEDICAMENTO
ALTER TABLE medicamento ADD CONSTRAINT chk_precio_unitario CHECK (precio_unitario BETWEEN 1000 AND 2000000);

-- DEFINIR METODOS DE PAGO
ALTER TABLE pago
ADD CONSTRAINT chk_metodo_pago
CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA'));

-- OPTIMIZAR DATOS, ELIMINAR COLUMNA edad Y REEMPLAZAR POR fecha_nacimiento
ALTER TABLE paciente DROP COLUMN edad;
ALTER TABLE paciente ADD fecha_nacimiento DATE NOT NULL;
