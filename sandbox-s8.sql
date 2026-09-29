
-- DROPS PRUEBAS

DROP TABLE detalle_servicio;
DROP TABLE mantencion;
DROP TABLE automovil;
DROP TABLE estandar;
DROP TABLE premium;
DROP TABLE cliente;
DROP TABLE sucursal;
DROP TABLE ciudad;
DROP TABLE pais;
DROP TABLE modelo;
DROP TABLE marca;
DROP TABLE servicio;
DROP TABLE tipo_automovil;
DROP TABLE mecanico;


-- =======================
-- ======= CASO 1 ========
-- =======================

CREATE TABLE servicio (
    id_servicio NUMBER(3) CONSTRAINT pk_servicio PRIMARY KEY,
    descripcion VARCHAR2(100 CHAR) NOT NULL,
    costo NUMBER(7) NOT NULL
);

CREATE TABLE marca (
    id_marca NUMBER(2) CONSTRAINT pk_marca PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

CREATE TABLE modelo (
    id_modelo NUMBER(5),
    marca_id NUMBER(2) NOT NULL,
    descripcion VARCHAR2(20 CHAR) NOT NULL,
    CONSTRAINT pk_modelo PRIMARY KEY (id_modelo, marca_id)
);

-- Identity inicia en 9, se incrementa en 3
CREATE TABLE pais (
    id_pais NUMBER(3) GENERATED ALWAYS AS IDENTITY
    (START WITH 9 INCREMENT BY 3) CONSTRAINT pk_pais PRIMARY KEY,
    nom_pais VARCHAR2(30 CHAR) NOT NULL
);

CREATE TABLE ciudad (
    id_ciudad NUMBER(3) CONSTRAINT pk_ciudad PRIMARY KEY,
    nom_ciudad VARCHAR2(30 CHAR) NOT NULL,
    cod_pais NUMBER(3) NOT NULL
);

CREATE TABLE sucursal (
    id_sucursal CHAR(3) CONSTRAINT pk_sucursal PRIMARY KEY,
    nom_sucursal VARCHAR2(20 CHAR) NOT NULL,
    calle VARCHAR2(20 CHAR) NOT NULL,
    num_calle NUMBER(4) NOT NULL,
    cod_ciudad NUMBER(3) NOT NULL
);

CREATE TABLE tipo_automovil (
    id_tipo CHAR(3) CONSTRAINT pk_tipo_automovil PRIMARY KEY,
    descripcion VARCHAR2(20 CHAR) NOT NULL
);

-- Identity inicia en 460, se incrementa en 7
CREATE TABLE mecanico (
    cod_mecanico NUMBER(5) GENERATED ALWAYS AS IDENTITY
    (START WITH 460 INCREMENT BY 7) CONSTRAINT pk_mecanico PRIMARY KEY,
    pnombre VARCHAR2(20 CHAR) NOT NULL,
    snombre VARCHAR2(20 CHAR) NOT NULL,
    apaterno VARCHAR2(20 CHAR) NOT NULL,
    amaterno VARCHAR2(20 CHAR) NOT NULL,
    bono_jefatura NUMBER(10),
    sueldo NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor NUMBER(5)
);

CREATE TABLE automovil (
    patente CHAR(8) CONSTRAINT pk_automovil PRIMARY KEY,
    annio NUMBER(4) NOT NULL,
    cant_puertas NUMBER(1) NOT NULL,
    km NUMBER(6) NOT NULL,
    color VARCHAR2(30 CHAR) NOT NULL,
    cod_tipo_auto CHAR(3) NOT NULL, -- F TIPO_AUTOMOVIL
    cod_modelo NUMBER(5) NOT NULL, -- F MODELO
    cod_marca NUMBER(2) NOT NULL, -- F MARCA
    cl_rut NUMBER(8) NOT NULL -- F CLIENTE
);

CREATE TABLE cliente (
    rut NUMBER(8) CONSTRAINT pk_cliente PRIMARY KEY,
    dv CHAR(1) NOT NULL,
    pnombre VARCHAR2(20 CHAR) NOT NULL,
    snombre VARCHAR2(20 CHAR),
    apaterno VARCHAR2(20 CHAR) NOT NULL,
    amaterno VARCHAR2(20 CHAR) NOT NULL,
    telefono VARCHAR2(12 CHAR),
    email VARCHAR2(40 CHAR),
    tipo_cli CHAR(1) NOT NULL
);

CREATE TABLE estandar (
    cl_rut NUMBER(8) CONSTRAINT pk_estandar PRIMARY KEY, -- PF CLIENTE (pk_normal)
    puntaje_fidelidad NUMBER(10) NOT NULL
);

CREATE TABLE premium (
    cl_rut NUMBER(8), -- PF CLIENTE
    pesos_clientes NUMBER(10) NOT NULL,
    monto_credito NUMBER(10)
);

CREATE TABLE mantencion (
    num_mantencion NUMBER(4) CONSTRAINT pk_mantencion PRIMARY KEY,
    cod_sucursal CHAR(3) NOT NULL, -- F SUCURSAL
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE,
    patente_auto CHAR(8), -- F AUTOMOVIL
    cod_mecanico NUMBER(5) NOT NULL, -- F MECANICO
    costo_total NUMBER(7) NOT NULL,
    estado VARCHAR2(15 CHAR)
);

CREATE TABLE detalle_servicio (
    mantencion_num NUMBER(4),
    cod_servicio NUMBER(3),
    descuento_serv NUMBER(4,3) NOT NULL,
    cantidad NUMBER(3) NOT NULL,
    CONSTRAINT pk_detalle_servicio PRIMARY KEY (mantencion_num, cod_servicio)
);


-- FOREIGN KEYS

ALTER TABLE ciudad ADD CONSTRAINT fk_ciudad_pais FOREIGN KEY (cod_pais) REFERENCES pais (id_pais);

ALTER TABLE sucursal ADD CONSTRAINT fk_sucursal_ciudad FOREIGN KEY (cod_ciudad) REFERENCES ciudad (id_ciudad);

ALTER TABLE mecanico ADD CONSTRAINT fk_mecanico_supervisor FOREIGN KEY (cod_supervisor) REFERENCES mecanico (cod_mecanico);

ALTER TABLE detalle_servicio
ADD CONSTRAINT fk_detalle_servicio_mantencion FOREIGN KEY (mantencion_num) REFERENCES mantencion (num_mantencion)
ADD CONSTRAINT fk_detalle_servicio_servicio FOREIGN KEY (cod_servicio) REFERENCES servicio (id_servicio);

ALTER TABLE modelo ADD CONSTRAINT fk_modelo_marca FOREIGN KEY (marca_id) REFERENCES marca (id_marca);

ALTER TABLE estandar ADD CONSTRAINT fk_estandar_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut);

ALTER TABLE premium ADD CONSTRAINT fk_premium_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut);

ALTER TABLE automovil ADD CONSTRAINT fk_automovil_tipo_automovil FOREIGN KEY (cod_tipo_auto) REFERENCES tipo_automovil (id_tipo);

ALTER TABLE automovil ADD CONSTRAINT fk_automovil_modelo FOREIGN KEY (cod_modelo, cod_marca) REFERENCES modelo (id_modelo, marca_id);

ALTER TABLE automovil ADD CONSTRAINT fk_automovil_cliente FOREIGN KEY (cl_rut) REFERENCES cliente (rut);

ALTER TABLE mantencion ADD CONSTRAINT fk_mantencion_sucursal FOREIGN KEY (cod_sucursal) REFERENCES sucursal (id_sucursal);

ALTER TABLE mantencion ADD CONSTRAINT fk_mantencion_automovil FOREIGN KEY (patente_auto) REFERENCES automovil (patente);

ALTER TABLE mantencion ADD CONSTRAINT fk_mantencion_mecanico FOREIGN KEY (cod_mecanico) REFERENCES mecanico (cod_mecanico);


-- =======================
-- ======= CASO 2 ========
-- =======================

-- Eliminar costo_total de mantencion
ALTER TABLE mantencion DROP (costo_total);

-- Ajustar fk en detalle_servicio

-- email en cliente único
ALTER TABLE cliente ADD CONSTRAINT uk_email UNIQUE (email);

-- check a dv en cliente
ALTER TABLE cliente ADD CONSTRAINT chk_cliente_dv CHECK (dv BETWEEN '0' AND '9' OR dv = 'K'); -- dos ==?

-- sueldo en mecanico mayor o igual a 510.000
ALTER TABLE mecanico ADD CONSTRAINT chk_mecanico_sueldo CHECK (sueldo >= 510000);

-- estado mantencion check 'Reserva, Ingresado, Entregado, Anulado'
ALTER TABLE mantencion ADD CONSTRAINT chk_mantencion_estado CHECK (estado IN ('Reserva', 'Ingresado', 'Entregado', 'Anulado'));


-- =======================
-- ======= CASO 3 ========
-- =======================

