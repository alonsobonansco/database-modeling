
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
    cod_tipo_auto CHAR(3) NOT NULL,
    cod_modelo NUMBER(5) NOT NULL,
    cod_marca NUMBER(2) NOT NULL,
    cl_rut NUMBER(8) NOT NULL
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
    cl_rut NUMBER(8) CONSTRAINT pk_estandar PRIMARY KEY,
    puntaje_fidelidad NUMBER(10) NOT NULL
);

CREATE TABLE premium (
    cl_rut NUMBER(8),
    pesos_clientes NUMBER(10) NOT NULL,
    monto_credito NUMBER(10)
);

CREATE TABLE mantencion (
    num_mantencion NUMBER(4) CONSTRAINT pk_mantencion PRIMARY KEY,
    cod_sucursal CHAR(3) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    fecha_salida DATE,
    patente_auto CHAR(8),
    cod_mecanico NUMBER(5) NOT NULL,
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

DROP SEQUENCE seq_servicio;
DROP SEQUENCE seq_ciudad;

-- servicio: id_servicio secuencia (inicia en 400, se aumenta en 2)
CREATE SEQUENCE seq_servicio START WITH 400 INCREMENT BY 2;

-- ciudad: id_ciudad secuencia (inicia en 165, se aumenta en 5)
CREATE SEQUENCE seq_ciudad START WITH 165 INCREMENT BY 5;


-- valores mecanicos

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);
 
INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Juan', 'Pablo', 'Sánchez', 'R.', NULL, 859000, 23380, 474);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alberto', 'P.', 'Cerda', 'Ramírez', NULL, 559000, 22380, 460);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);

INSERT INTO mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);

SELECT * FROM mecanico;

-- valores servicios

INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Cambio Luces', 45000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Desabolladura', 67000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Revisión Frenos', 30000);
INSERT INTO servicio (id_servicio, descripcion, costo) VALUES (seq_servicio.NEXTVAL, 'Cambio Puerta Trasera', 50000);

SELECT * FROM servicio;

-- valores paises

INSERT INTO pais (nom_pais) VALUES ('Chile');
INSERT INTO pais (nom_pais) VALUES ('Perú');
INSERT INTO pais (nom_pais) VALUES ('Colombia');

SELECT * FROM pais;

-- valores ciudades

INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Santiago', 9);
INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Lima', 12);
INSERT INTO ciudad (id_ciudad, nom_ciudad, cod_pais) VALUES (seq_ciudad.NEXTVAL, 'Bogotá', 15);

SELECT * FROM ciudad;

-- valores sucursales

INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad) 
VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165);

INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);

INSERT INTO sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
VALUES ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);

SELECT * FROM sucursal;

-- valores mantenciones

INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (101, 'S01', TO_DATE('12-04-2023', 'DD-MM-YYYY'), NULL, NULL, 481, 'Reserva');

INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (102, 'S02', TO_DATE('21-02-2023', 'DD-MM-YYYY'), TO_DATE('21-02-2023', 'DD-MM-YYYY'), NULL, 502, 'Entregado');

INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (103, 'S02', TO_DATE('09-10-2023', 'DD-MM-YYYY'), NULL, NULL, 502, 'Anulado');

INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (104, 'S03', TO_DATE('11-08-2023', 'DD-MM-YYYY'), TO_DATE('18-08-2023', 'DD-MM-YYYY'), NULL, 509, 'Entregado');

INSERT INTO mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
VALUES (105, 'S03', TO_DATE('03-12-2023', 'DD-MM-YYYY'), NULL, NULL, 509, 'Ingresado');

SELECT * FROM mantencion;


-- =======================
-- ======= CASO 4 ========
-- =======================

-- Informe 1
SELECT
    cod_mecanico AS "ID MECANICO",
    pnombre || ' ' || apaterno AS "NOMBRE MECANICO",    
    sueldo AS SALARIO,
    monto_impuestos AS "IMPUESTO ACTUAL",
    monto_impuestos * 0.8 AS "IMPUESTO REBAJADO", -- 80% de los impuestos
    sueldo - (monto_impuestos * 0.8) AS "SUELDO CON REBAJA IMPUESTOS" -- sueldo - impuestos rebajados
FROM mecanico
WHERE monto_impuestos < 40000 AND bono_jefatura IS NULL
ORDER BY monto_impuestos DESC, apaterno ASC;

-- order: impuestos actuales desc; apaterno asc (a-z)

-- Informe 2
SELECT
    cod_mecanico AS "IDENTIFICADOR",
    pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
    sueldo AS "SALARIO ACTUAL",
    sueldo * 0.05 AS "AJUSTE",
    sueldo + (sueldo * 0.05) AS "SALARIO_REAJUSTADO"
FROM mecanico
WHERE sueldo BETWEEN 600000 AND 900000 OR cod_supervisor IS NULL
ORDER BY sueldo ASC, "MECANICO" DESC;
