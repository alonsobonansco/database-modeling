# 🏪 Transformando el MER en Modelo Relacional

### Sumativa 2 - Semana 5

---

## 📝 Descripción del Proyecto
El proyecto consiste en normalizar, corregir y completar un diseño conceptual preliminar e incompleto para una cadena de retail internacional instalada en Chile. El sistema administra eficientemente un catálogo de 9,000 productos, organizados por marcas y modelos específicos, distribuidos en sucursales a lo largo de 50 comunas del país, gestionando un circuito completo de abastecimiento por proveedores y un módulo transaccional de emisión de boletas de venta.

---

## 📂 Estructura de Archivos en el Repositorio

* `Exp2_S5_Alonso_Bonansco.docx`: Archivo word con el formato de respuesta solicitado. Incluye las imágenes del modelo MER, modelo relacional normalizado y script generado con la herramienta.
* `Modelo_Base_Semana5.zip`: Carpeta de diseño técnico que incluye el archivo de arquitectura de datos `.dmd`.
* `script_ddl_s5.sql`: Script físico DDL final optimizado, limpio de nombres redundantes automáticos del sistema y con nomenclatura estandarizada de llaves (`PK_`, `FK_`, `UK_`).

---

## 🗺️ Imágenes de los modelos y script

### MER-E

<img width="1205" height="868" alt="Logical" src="https://github.com/user-attachments/assets/ba539b0d-bcbb-4b01-a89c-846a28490a18" />


### Modelo Relacional Normalizado

<img width="1235" height="834" alt="Relational_1" src="https://github.com/user-attachments/assets/f7fef14f-46d0-4beb-9a86-c93323662f76" />


### Script DDL

<img width="774" height="1023" alt="Sin título" src="https://github.com/user-attachments/assets/d4c5de77-f5a1-4a2e-abc9-cb0ee0b8f054" />


---

## 🎯 Principales Reglas de Negocio Implementadas

### 1. Circuitos de Venta y Desglose Transaccional (1FN)
* **Lógica Aplicada:** La relación original de muchos a muchos (*N:M*) entre `CLIENTE` y `PRODUCTO` fue disuelta mediante la creación de la entidad transaccional cabecera **`BOLETA`** y su respectiva tabla intermedia de quiebre **`DETALLE_BOLETA`** (nombrada físicamente como `DETALLE_VENTA`).
* **Atributos de Control:** El atributo relacional `cantidad` y el campo de resguardo histórico `precio_unitario` se parametrizaron exclusivamente dentro del detalle, aislando la fecha y el monto total global en la cabecera del documento para garantizar la consistencia contable del negocio.

### 2. Jerarquía de Catálogo y Fichas Técnicas (2FN)
* **Lógica Aplicada:** Para cumplir estrictamente con la Segunda Forma Normal, la descripción técnica de los productos se extrajo de la tabla `PRODUCTO` hacia una entidad especializada llamada **`MODELO`**.
* **Claves Compuestas:** Debido a que los modelos son propios de cada fabricante, la entidad `MODELO` hereda de forma identificativa la Clave Primaria de **`MARCA`**, generando una estructura de clave primaria compuesta sólida `(id_marca, codigo_modelo)` que se transfiere íntegramente hacia el inventario físico de `PRODUCTO`.

### 3. Modularidad Geográfica y Clasificación Dinámica (3FN)
* **Lógica Aplicada:** Se aisló todo rastro de dependencias transitivas mediante la creación de catálogos maestros independientes para **`COMUNA`**, **`REGION`** y **`CATEGORIA`**.
* **Opcionalidad de Negocio:** Respetando la regla de que no necesariamente se dispone de stock en todas las clasificaciones, la relación entre `CATEGORIA` y `PRODUCTO` se configuró como **Opcional** en el modelo lógico (línea discontinua) y relacional, permitiendo valores nulos (`NULL`) en la clave foránea `codigo_categoria` de la tabla de productos.
* **Control de Perecederos:** La característica de vencimiento se definió mediante un campo booleano (`tiene_vencimiento`) en la categoría maestra, permitiendo que la columna `fecha_vencimiento` en el inventario sea opcional únicamente para artículos que la requieran.

### 4. Modelo Extendido y Especialización de Proveedores (MER-E)
* **Lógica Aplicada:** El requerimiento de almacenar proveedores de tipo Persona Natural (con nombres y apellidos) y de tipo Empresa (con razón social y sitio web) se resolvió aplicando el patrón de **Herencia de Tabla Única (Single-Table Inheritance)** en el Modelo Relacional.
* **Integridad y Restricciones:** Todos los atributos específicos se unificaron en la tabla `PROVEEDOR` bajo la propiedad de opcionales (`NULL`). La integridad del modelo se garantizó mediante:
  * Un atributo discriminador llamado `tipo_proveedor`.
  * Restricciones de unicidad explícitas (**`UK_EMAIL`** y **`UK_SITIO_WEB`**) para bloquear el registro de canales digitales duplicados en el sistema.

---

## 🛠️ Herramientas requeridas  

Para abrir, editar y visualizar el archivo estructurado .dmd contenido en la carpeta, es necesario instalar uno de los siguientes:
* **Oracle SQL Developer Data Modeler** (Herramienta dedicada).
* **Oracle SQL Developer** (Versión estándar): Ir a **File** -> **Data Modeler** -> **Open**

---

### 📋 Autor:

Alonso Bonansco Vergara  
Modelamiento de Bases de Datos - 004A  
Analista Programador Computacional
