# Semana 4 — Ministerio del Trabajo (MER + normalización)

Caso de **Modelamiento de Bases de Datos (PRY2204)**.  
Hay que modelar el concurso público TIC a partir del formulario de postulación (Vista 1) y dejar el esquema en **3FN**.

Ejemplo del enunciado: **Pedro Pablo Zunino Contreras**, folio `0447899`, postula a **Cisco System** (`cis`) en California, USA.

Cómo leer las tablas de más abajo:

- `#` = identificador (UID / PK)
- `*` = atributo obligatorio
- sin `*` = opcional
- `FK` = clave foránea (viene de otra tabla)

---

## 1. Entidades

Hay tres grupos: **catálogos** (listas que se reutilizan), **negocio** (lo del concurso) e **intermedias** (rompen las N:M).

### 1.1 Catálogos

Sirven para no escribir mil veces el mismo texto (“Soltero”, “Ecuador”, “Español”).

| Entidad | Identificador | Qué guarda | Ejemplo |
|---|---|---|---|
| `PAIS` | `# id_pais` | `* nombre_pais` | 459 = Ecuador, 39 = Chile |
| `CIUDAD` | `# id_ciudad` | `* nombre_ciudad` + FK a país | Santiago, California |
| `COMUNA` | `# id_comuna` | `* nombre_comuna`, `* codigo_postal` + FK a ciudad | Maipú, 14109 |
| `GENERO` | `# id_genero` | `* descripcion` | H = Hombre |
| `ESTADO_CIVIL` | `# id_estado_civil` | `* descripcion` | 02 = Soltero |
| `GRADO_ACADEMICO` | `# id_grado` | `* descripcion` | L / M / D (Pedro es Magíster) |
| `IDIOMA` | `# id_idioma` | `* nombre_idioma` | Español, Inglés, Francés |
| `PROFESION` | `# id_profesion` | `* nombre_profesion` | Ing. Informática, Diseño Industrial |

### 1.2 Entidades de negocio

#### `POSTULANTE`

La persona del formulario. El sistema le asigna un **folio único**. El RUT no puede ser PK: hay extranjeros sin RUT.

| Atributo | Obligatorio | Nota corta |
|---|---|---|
| `# nro_folio` | sí | Lo genera el sistema (ej. 447899) |
| `* nombres`, `* apellidos` | sí | Pedro Pablo / Zunino Contreras |
| `* fecha_nacimiento` | sí | 10-07-1999 |
| `* email` | sí | debe tener `@` |
| `web_site` | no | si existe, no se puede repetir |
| `* renta_actual` | sí | en pesos |
| `* calle` | sí | Alberto Llona 3478 (solo la calle; el resto va a comuna/ciudad/país) |
| `rut`, `dv` | no | solo si es chileno; el DV es 0-9 o K |
| `id_comuna` FK | sí | siempre reside en Chile |
| `id_genero` FK | sí | |
| `id_estado_civil` FK | sí | |
| `id_pais_origen` FK | sí | nacionalidad (Ecuador) |
| `id_grado` FK | sí | un solo grado vigente |

#### `EMPRESA`

Ya **no es supertipo**. Nacional o extranjera se marca con un booleano.

| Atributo | Obligatorio | Nota corta |
|---|---|---|
| `# sigla` + `# nro_correlativo` | sí | 3 letras + 01, 02… Ejemplo: `cis` + `01` |
| `* nombre` | sí | único. Cisco System |
| `* direccion` | sí | solo calle/número (180 West Tasman Drive) |
| `* remuneracion_maxima` | sí | entre $1.850.000 y $4.800.000 |
| `* es_extranjera` | sí | `S` = extranjera (Cisco, Microsoft, Apple). `N` = nacional (Amazon, Google, Oracle) |
| `id_ciudad` FK | sí | de ahí se llega al país |

#### `POSTULACION` (sí es supertipo)

Un postulante postula a **una sola** empresa, así que `POSTULANTE` — `POSTULACION` es **1:1**.  
Se deja como entidad aparte porque los datos **cambian** según si la empresa es nacional o extranjera.

| Atributo | Obligatorio | Nota corta |
|---|---|---|
| `# nro_folio` | sí | es el mismo folio del postulante (relación identificativa) |
| `* fecha_postulacion` | sí | 12-02-2025 |
| `sigla` + `nro_correlativo` FK | sí | empresa a la que postula |

Subtipos **exclusivos y totales** (una postulación es una u otra, nunca las dos):

| Subtipo | Atributos propios | Cuándo se usa |
|---|---|---|
| `POSTULACION_NACIONAL` | `* pretension_renta` (CLP) | cuando `EMPRESA.es_extranjera = N` |
| `POSTULACION_EXTRANJERA` | `* id_nivel` FK, `* fecha_visa`, `* id_visa` (3 letras + 10 números) | cuando `EMPRESA.es_extranjera = S` |

Regla: el subtipo de la postulación tiene que coincidir con `es_extranjera`. No se postula a Oracle (Chile) con visa, ni a Cisco (USA) solo con pretensión de renta.

### 1.3 Tablas intermedias (resuelven N:M)

No se dibujan como línea naranja N:M. Se crean como **entidades azules** con dos relaciones 1:N identificativas.

| Entidad | Identificador | Atributo propio | Regla |
|---|---|---|---|
| `TITULO_PROFESIONAL` | `# nro_folio` + `# id_profesion` | `* fecha_obtencion` | mínimo 1 y máximo 2 títulos por postulante |
| `NIVEL_IDIOMA` | `# nro_folio` + `# id_idioma` | `es_nativo` (S/N) | un postulante declara 1 o más idiomas |

---

## 2. Relaciones

Lectura: el lado `1` es “el padre”; el lado `N` es “puede haber varios”.

**Opcional** = puede no existir (círculo / `o`).  
**Obligatorio** = siempre existe (línea / `||`).

| Relación | Cardinalidad | ¿Opcional u obligatorio? | En simple |
|---|---|---|---|
| `PAIS` — `CIUDAD` | 1 : N | ciudad siempre tiene país. Un país puede no tener ciudades cargadas | California pertenece a USA |
| `CIUDAD` — `COMUNA` | 1 : N | comuna siempre tiene ciudad | Maipú pertenece a Santiago |
| `CIUDAD` — `EMPRESA` | 1 : N | empresa siempre tiene ciudad. Una ciudad puede no tener empresas | Cisco se domicilia en California |
| `COMUNA` — `POSTULANTE` | 1 : N | postulante siempre vive en una comuna chilena | Pedro vive en Maipú |
| `PAIS` — `POSTULANTE` (origen) | 1 : N | país de origen obligatorio | Pedro nace en Ecuador |
| `GENERO` — `POSTULANTE` | 1 : N | obligatorio del lado postulante | |
| `ESTADO_CIVIL` — `POSTULANTE` | 1 : N | obligatorio del lado postulante | |
| `GRADO_ACADEMICO` — `POSTULANTE` | 1 : N | un grado vigente | Magíster |
| `POSTULANTE` — `POSTULACION` | 1 : 1 | ambos lados obligatorios e identificativa | un folio = una postulación |
| `EMPRESA` — `POSTULACION` | 1 : N | postulación siempre a una empresa. Una empresa puede no tener postulantes aún | muchos pueden postular a Cisco |
| `POSTULANTE` — `TITULO_PROFESIONAL` | 1 : N | el postulante debe tener al menos 1 (máx. 2) | Pedro tiene 2 títulos |
| `PROFESION` — `TITULO_PROFESIONAL` | 1 : N | **opcional** del lado profesión: el catálogo puede existir sin que nadie la haya declarado. Del lado título es **obligatoria** | cada título apunta a una profesión |
| `POSTULACION` — `DOMINIO_IDIOMA` | 1 : N | el postulante declara idiomas | Español, Inglés, Francés = 3 filas |
| `IDIOMA` — `DOMINIO_IDIOMA` | 1 : N | opcional del lado idioma (puede no haber hablantes aún). Obligatoria del lado dominio | |
| `POSTULACION` — `POSTULACION_NACIONAL` / `EXTRANJERA` | 1 : 1 | arco exclusivo y total | o pretensión o visa, no ambas |

---

## 3. Normalización (de la Vista 1 a 3FN)

Si copias el formulario a **una sola tabla**, queda en 0FN. Eso es lo que hay que ir corrigiendo.

### 3.1 0FN — formulario sucio (una fila)

```
POSTULACION_VISTA1
( folio, nombres, apellidos, fecha_postulacion,
  direccion_chile, genero, email, estado_civil, cod_estado_civil,
  renta, fecha_nacimiento, pais_origen, id_pais,
  web, idiomas, grado,
  profesion1, fecha1, profesion2, fecha2,
  empresa, sigla, direccion_empresa, renta_max,
  pretension, nivel_idioma, fecha_visa, id_visa )
```

Problemas que se ven altiro:

- `direccion_chile` y `direccion_empresa` son **compuestas** (calle + ciudad + país).
- `idiomas` = “Español, Inglés, Francés” → **multivaluado**.
- `profesion1` / `profesion2` → **grupo repetitivo**.
- Si 200 personas postulan a Cisco, se repite 200 veces el nombre, la dirección y la renta máxima.
- “Soltero” se copia cada vez que aparece el código `02`.

### 3.2 1FN — valores atómicos, sin grupos repetitivos

**Regla:** en cada celda va un solo valor. Nada de listas ni `profesion1` / `profesion2`.

Se parte la dirección y se sacan idiomas y títulos a tablas hijas:

```
POSTULANTE_1FN   (folio PK, nombres, ..., calle, comuna, ciudad, pais,
                  empresa, sigla, dir_empresa, ciudad_empresa, ...)

TITULO_1FN       (folio, nombre_profesion, fecha_obtencion)
                 PK (folio, nombre_profesion)

DOMINIO_IDIOMA_1FN (folio, nombre_idioma)
                 PK (folio, nombre_idioma)
```

Ya no hay “Español, Inglés, Francés” en una celda ni columnas `profesion1` / `profesion2`.

Todavía está mal: los datos de Cisco, de Maipú y de “Soltero” **no dependen del folio**.

### 3.3 2FN — todo no-llave depende de **toda** la PK

**Regla:** si la PK es compuesta, un atributo no puede depender de solo una parte.

En `TITULO_1FN` la fecha depende de `(folio + profesión)` completa → esa tabla ya está bien.

El problema grande está en `POSTULANTE_1FN`: nombre de empresa, dirección y renta máxima dependen de `(sigla + correlativo)`, no del folio.

Se separa:

```
EMPRESA_2FN      (sigla, correlativo, nombre, direccion, ciudad, pais, renta_max)
                 PK (sigla, correlativo)

POSTULANTE_2FN   (folio, datos personales, calle, comuna, estado civil, ...)

POSTULACION_2FN  (folio PK/FK, fecha, sigla, correlativo,
                  pretension, nivel, visa, ...)
```

### 3.4 3FN — sin dependencias transitivas

**Regla:** un atributo que no es llave no puede determinar a otro que tampoco es llave.

Ejemplos que aún sobraban:

| Esto dependía de otra cosa (no de la PK) | Se crea |
|---|---|
| código `02` → “Soltero” | `ESTADO_CIVIL` |
| `459` → “Ecuador” | `PAIS` |
| `M` → “Magíster” | `GRADO_ACADEMICO` |
| comuna → código postal, ciudad, país | `COMUNA` + `CIUDAD` + `PAIS` |
| ciudad de la empresa → país | misma geografía |
| nombre de idioma / profesión como texto | `IDIOMA`, `PROFESION` |
| pretensión **o** visa según el tipo de empresa | subtipos de `POSTULACION` + `es_extranjera` |

Al final, cada atributo describe **solo a su entidad**. Si 200 personas postulan a Cisco, Cisco se guarda **una vez**.

### 3.5 Esquema final (3FN)

```
PAIS                 ( id_pais PK, nombre_pais UK )
CIUDAD               ( id_ciudad PK, nombre_ciudad, id_pais FK )
COMUNA               ( id_comuna PK, nombre_comuna, codigo_postal, id_ciudad FK )
GENERO               ( id_genero PK, descripcion UK )
ESTADO_CIVIL         ( id_estado_civil PK, descripcion UK )
GRADO_ACADEMICO      ( id_grado PK, descripcion UK )
IDIOMA               ( id_idioma PK, nombre_idioma UK )
NIVEL_IDIOMA         ( id_nivel PK, descripcion UK )
PROFESION            ( id_profesion PK, nombre_profesion UK )

EMPRESA              ( sigla, nro_correlativo, nombre UK, direccion,
                       remuneracion_maxima, es_extranjera, id_ciudad FK )
                     PK (sigla, nro_correlativo)

POSTULANTE           ( nro_folio PK, nombres, apellidos, fecha_nacimiento,
                       email, web_site UK, renta_actual, calle, rut UK, dv,
                       id_comuna FK, id_genero FK, id_estado_civil FK,
                       id_pais_origen FK, id_grado FK )

POSTULACION          ( nro_folio PK/FK, fecha_postulacion,
                       sigla FK, nro_correlativo FK )
POSTULACION_NACIONAL     ( nro_folio PK/FK, pretension_renta )
POSTULACION_EXTRANJERA   ( nro_folio PK/FK, id_nivel FK, fecha_visa, id_visa UK )

TITULO_PROFESIONAL   ( nro_folio FK, id_profesion FK, fecha_obtencion )
                     PK (nro_folio, id_profesion)
DOMINIO_IDIOMA       ( nro_folio FK, id_idioma FK, es_nativo )
                     PK (nro_folio, id_idioma)
```

---

## 4. Cómo se guarda el ejemplo de Pedro

| Tabla | Qué se inserta |
|---|---|
| `PAIS` | Chile, Ecuador, Estados Unidos |
| `CIUDAD` | Santiago (Chile), California (USA) |
| `COMUNA` | Maipú, 14109, Santiago |
| `ESTADO_CIVIL` | 02 = Soltero |
| `GENERO` | H = Hombre |
| `GRADO_ACADEMICO` | M = Magíster |
| `IDIOMA` | Español, Inglés, Francés |
| `PROFESION` | Ing. Informática, Diseño Industrial |
| `EMPRESA` | `cis` + `01`, Cisco, `es_extranjera = S` |
| `POSTULANTE` | folio 447899, Pedro Pablo, origen Ecuador, vive en Maipú |
| `POSTULACION` | folio 447899, fecha 12-02-2025, empresa `cis01` |
| `POSTULACION_EXTRANJERA` | nivel + fecha de visa + id de visa |
| `TITULO_PROFESIONAL` | Informática 11-12-2021 y Diseño 09-03-2019 |
| `DOMINIO_IDIOMA` | 3 filas (un idioma cada una) |

Si tu modelo no puede guardar esto **sin repetir** “Cisco System” ni “Español, Inglés, Francés”, todavía no está en 3FN.

---

## 5. Errores que hay que evitar

1. Una sola entidad con todos los campos del formulario → eso es 0FN.
2. Poner `profesion1` y `profesion2` “porque el máximo es 2”. El máximo es una **restricción**, no una columna extra.
3. Usar el RUT como PK. Hay extranjeros sin RUT. El folio es el UID.
4. Hacer N:M entre postulante y empresa. El enunciado dice **una sola** empresa.
5. Mezclar idiomas que habla la persona con el nivel que pide la visa.
6. Identificar la empresa solo como `cis`. Falta el correlativo (`cis01`).

---

Entrega AVA: capturas **Barker** y **Bachman** desde Data Modeler + el `.dmd` con su subcarpeta.
