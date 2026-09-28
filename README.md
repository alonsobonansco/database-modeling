![Duoc UC](https://www.duoc.cl/wp-content/uploads/2022/09/logo-0.png)

# Actividad Formativa – Semana 7
## Realizando el poblamiento y consultas en la base de datos con sentencias SQL

### Proyecto: Holding Carpenter SPA – Base de Datos Relacional y Consultas SQL

---

## Autores del proyecto

| Campo | Detalle |
|---|---|
| **Integrantes** | Beatriz López <br> Alonso Bonansco |
| **Docente** | Cristian Carreño |
| **Asignatura** | Modelamiento de Bases de Datos (PRY2204) |
| **Carrera** | Analista Programador Computacional |
| **Sede** | Duoc UC Online |

---

## Descripción general del sistema

**Carpenter SPA** es un holding de empresas del sector retail en Chile. En esta fase del proyecto se implementó la base de datos relacional para gestionar el personal de las distintas compañías que conforman el holding, utilizando el motor **Oracle Database** y el IDE **Oracle SQL Developer**.

El desarrollo incluye:

1. **Construcción DDL:** Creación de tablas, claves primarias (`PK`), claves foráneas (`FK`), restricciones de unicidad (`UNIQUE`) y secuencias/columnas de identidad (`IDENTITY`).
2. **Reglas de negocio (ALTER TABLE):** Definición de restricciones adicionales como unicidad de correo electrónico, validación de dígito verificador y sueldo mínimo ($450.000).
3. **Poblamiento de datos (DML):** Inserción secuencial respetando las dependencias relacionales y el uso de secuencias (`SEQUENCE`) e `IDENTITY`.
4. **Reportes de gestión (SELECT):** Generación de informes analíticos con simulaciones de renta promedio mediante operadores aritméticos, concatenación y ordenamiento múltiple.

| Objeto / Regla | Configuración aplicada |
|---|---|
| Secuencia Comuna | `SEQ_COMUNA` inicia en `1101`, incrementa en `6` |
| Secuencia Compañía | `SEQ_COMPANIA` inicia en `10`, incrementa en `5` |
| Autoincrementable Región | `IDENTITY` inicia en `7`, incrementa en `2` |
| Autoincrementable Idioma | `IDENTITY` inicia en `25`, incrementa en `3` |
| Sueldo Mínimo | `CHECK (sueldo >= 450000)` |
| Validación DV | `CHECK (dv_persona IN ('0'..'9', 'K'))` |

---

## Estructura del script SQL

El script de esta semana está organizado en 4 bloques secuenciales dentro del archivo `Encargo_Semanal.sql`:
