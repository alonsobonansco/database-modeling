# 📊 Modelando jerarquía entre entidades

### Sumativa 1 - Semana 3

Este repositorio contiene la solución técnica para el caso de negocio de la compañía **HiLogic Solutions**, correspondiente a la actividad sumativa individual de la Semana 3. El objetivo principal es diseñar e implementar un Modelo Entidad-Relación Extendido (MER-E) que resuelva los problemas de cuadratura de ingresos por ventas y cálculo de comisiones para vendedores y supervisores.

## 📂 Estructura de Archivos en el Repositorio
* `Exp1_S3_Alonso_Bonansco.docx`: Archivo word con el formato de respuesta solicitado. Incluye las imágenes de los modelos en notación Barker y Bachman.
* `Modelo_Base_Semana3.zip`: Carpeta de diseño técnico que incluye el archivo de arquitectura de datos `.dmd`.

---

## 📐 Aspectos Clave del Diseño del Modelo

### 👥 1. Jerarquías y Herencia (MER-E)
* **Entidad Supertipo CONTRATO:** Centraliza los datos comunes de la contratación y la información personal del personal contratado (`numero_contrato`, `fecha_contrato`, `rut_trabajador`, `nombres`, `apellidos`, etc.).
  * **Subtipo CONTRATO_INDEFINIDO:** Almacena atributos obligatorios exclusivos de planta como `sueldo_base`, `afp` y `sistema_salud`. Requiere una relación mandatoria con un cargo.
  * **Subtipo CONTRATO_PRACTICANTE:** Registra la asignación exclusiva de `compensacion` para alumnos en práctica, manteniendo el puesto o cargo de forma opcional.

* **Entidad Supertipo CLIENTE:** Divide a los compradores según su fidelización en `CLIENTE_VIP` (con porcentaje de descuento) y `CLIENTE_NORMAL` (con tope de descuento fijo en pesos).

### 🔒 2. Restricciones y Reglas de Integridad
* **Relación Intransferible (Rombo de Bloqueo):** Aplicada en la unión entre `SUCURSAL` y `CONTRATO`. Garantiza que un contrato emitido en una sucursal no pueda ser modificado o traspasado a otra en el futuro.
* **Atributo Relacional (Caja Intermedia N:M):** El campo `cantidad_productos` se ha modelado en la intersección de la relación Muchos a Muchos entre `BOLETA` y `PRODUCTO`, resolviendo físicamente el desglose de ítems por cada venta realizada.

---

## 🛠️ Herramientas requeridas  

Para abrir, editar y visualizar el archivo estructurado .dmd contenido en la carpeta, es necesario instalar uno de los siguientes:
* **Oracle SQL Developer Data Modeler** (Herramienta dedicada).
* **Oracle SQL Developer** (Versión estándar): Ir a **File** -> **Data Modeler** -> **Open**

---

### 📋 Autor:

Alonso Bonansco Vergara  
Modelamiento de Base de Datos - 004A  
Analista Programador Computacional
