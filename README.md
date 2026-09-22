![Duoc UC](https://www.duoc.cl/wp-content/uploads/2022/09/logo-0.png)

# Actividad Formativa – Semana 6
## Implementando un Modelo Relacional con Sentencias SQL

### Proyecto: Consultorio Médico Municipalidad Santa Gema — Script DDL y Restricciones (Caso 1 y Caso 2)

---

## Autor del proyecto

| Campo | Detalle |
|---|---|
| **Nombre completo** | Alonso Bonansco Beatriz López Casanova |
| **Asignatura** | Modelamiento de Bases de Datos (PRY2204) |
| **Carrera** | Analista Programador Computacional |
| **Profesor** | Cristian Carreño |
| **Sede** | Virtual |
| **Fecha** | 21/09/2026 |

---

## Descripción

Entrega de la **Experiencia 3 – Semana 6**. A partir del Modelo Relacional del **Consultorio Médico de la Municipalidad Santa Gema** (sistema de gestión de recetas, entrega de medicamentos y pagos), se implementa la estructura física en la base de datos Oracle SQL utilizando sentencias DDL.

El trabajo incluye la creación de tablas con columnas autoincrementables (`IDENTITY`), la definición explícita de restricciones de integridad (`PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `NOT NULL`) y la aplicación posterior de modificaciones estructurales mediante sentencias `ALTER TABLE` para responder a nuevos requerimientos de negocio (Caso 2).

---

---

## Entidades y Atributos

`#` PK · `*` obligatorio · `o` opcional · `F` FK

| Entidad | Tipo | Identificador | Atributos Principales |
|---|---|---|---|
| `COMUNA` | Fuerte | `# cod_comuna` | `* nombre` (Identity desde 1101) |
| `ESPECIALIDAD` | Fuerte | `# cod_especialidad` | `* nombre` (Identity) |
| `DIAGNOSTICO` | Fuerte | `# cod_diagnostico` | `* nombre` |
| `TIPO_RECETA` | Fuerte | `# id_tipo_receta` | `* nombre` |
| `BANCO` | Fuerte | `# cod_banco` | `* nombre` |
| `DIGITADOR` | Fuerte | `# id_digitador` | `* dv_digitador`, `* pnombre`, `* papellido` |
| `PACIENTE` | Fuerte | `# rut_pac` | `* dv_pac`, `* pnombre`, `o snombre`, `* fecha_nacimiento` *(ex edad)*, `o telefono`, `* calle`, `* numeracion`, `F cod_comuna` |
| `MEDICO` | Fuerte | `# rut_med` | `* dv_med`, `* pnombre`, `o snombre`, `* papellido`, `* sapellido`, `* telefono` (UNIQUE), `F cod_especialidad` |
| `MEDICAMENTO` | Fuerte | `# cod_medicamento` | `* nombre`, `* tipo_medicamento`, `* via_administra`, `* stock`, `* precio_unitario` (CHECK 1.000 - 2.000.000) |
| `RECETA` | Fuerte | `# cod_receta` | `o observaciones`, `* fecha_emision`, `o fecha_vencimiento`, `F id_digitador`, `F pac_rut`, `F id_diagnostico`, `F med_rut`, `F id_tipo_receta` |
| `DOSIS` | **Débil** / N:M | `# id_medicamento` + `# id_receta` | `* descripcion_dosis`, `* unidades_medicamento`, `* dias_tratamiento` |
| `PAGO` | Fuerte | `# cod_boleta` | `* fecha_pago`, `* monto_total`, `* metodo_pago` (CHECK), `F id_receta`, `F id_banco` |

---

## Relaciones (cardinalidad)

| Relación | Cardinalidad | Obligación |
|---|---|---|
| COMUNA – PACIENTE | 1 : N | Paciente siempre pertenece a una comuna; comuna puede no tener pacientes |
| ESPECIALIDAD – MEDICO | 1 : N | Médico siempre tiene especialidad; especialidad abarca muchos médicos |
| MEDICO – RECETA | 1 : N | Receta siempre la emite un médico; médico puede emitir varias recetas |
| DIGITADOR – RECETA | 1 : N | Receta siempre la ingresa un digitador; digitador ingresa varias recetas |
| DIAGNOSTICO – RECETA | 1 : N | Receta siempre tiene un diagnóstico asociado |
| TIPO_RECETA – RECETA | 1 : N | Receta siempre tiene un tipo (Digital, Retenida, Magistral, etc.) |
| PACIENTE – RECETA | 1 : N | Receta siempre pertenece a un paciente; paciente puede recibir varias recetas |
| RECETA – DOSIS | 1 : N | Identificativa; receta con al menos una dosis/línea de fármaco |
| MEDICAMENTO – DOSIS | 1 : N | Dosis siempre especifica un medicamento de catálogo |
| RECETA – PAGO | 1 : N | Pago siempre está vinculado a una receta; receta puede tener 1 o más pagos |
| BANCO – PAGO | 1 : N | Pago asignado a un banco registrado |

---

## Normalización (resumen)

- **1FN:** Descomposición de datos de paciente y médico en campos atómicos (`pnombre`, `snombre`, `papellido`, `sapellido`). Los medicamentos prescritos en una receta se gestionan en la entidad asociativa `DOSIS`.
- **2FN:** La clave primaria de `DOSIS` es compuesta (`id_medicamento`, `id_receta`). Los atributos `unidades_medicamento`, `descripcion_dosis` y `dias_tratamiento` dependen de la clave completa.
- **3FN:** Eliminación de dependencias transitivas. La comuna se separa en la entidad `COMUNA`. La especialidad del médico se abstrae en `ESPECIALIDAD`. Se elimina la columna calculada `edad` en `PACIENTE` reemplazándola por `fecha_nacimiento`.

---

## Modificaciones de estructura (Caso 2)

Posterior a la creación de tablas iniciales, se aplican las siguientes reglas mediante `ALTER TABLE`:
1. **Precio unitario:** Incorporación de la columna `precio_unitario` a la tabla `MEDICAMENTO`.
2. **Rango de precios:** Restricción `CHECK` que exige un precio entre **$1.000** y **$2.000.000** pesos.
3. **Métodos de pago:** Restricción `CHECK` en `PAGO` aceptando únicamente **'EFECTIVO'**, **'TARJETA'** o **'TRANSFERENCIA'**.
4. **Optimización de paciente:** Eliminación de la columna `edad` (`DROP COLUMN`) e inclusión de la columna `fecha_nacimiento` (`ADD DATE`).

---

## Instrucciones de ejecución

1. Abrir **Oracle SQL Developer**.
2. Conectarse a la base de datos con el usuario asignado (`PRY2204_S6` o la conexión `PRY2204_SEMANA6`).
3. Abrir el archivo `Encargo_Semanal.sql`.
4. Ejecutar el script completo (**F5** o botón *Ejecutar Script*). 
5. El script ejecutará automáticamente las sentencias en el siguiente orden secuencial:
   - Limpieza inicial de tablas (`DROP TABLE ... CASCADE CONSTRAINTS`).
   - Creación de tablas e identidades (Caso 1).
   - Creación de claves primarias, foráneas y validaciones `CHECK`/`UNIQUE`.
   - Modificaciones estructurales mediante `ALTER TABLE` (Caso 2).

---

## Entrega AVA

1. Archivo `Encargo_Semanal.sql` sin comprimir con el código DDL debidamente documentado mediante comentarios (`--` y `/* ... */`).
2. Enlace directo a este repositorio público de GitHub.

---

© Duoc UC | Escuela de Informática y Telecomunicaciones
