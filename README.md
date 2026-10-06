# ⚽ Modelamiento e Implementación de Base de Datos - ANFP (Duoc UC)

Este repositorio contiene la solución completa para la Evaluación Final Transversal (EFT) de Modelamiento de Bases de Datos. El proyecto consiste en diseñar e implementar una base de datos relacional normalizada en Oracle 19c para la Asociación Nacional de Fútbol Profesional (ANFP), resolviendo los problemas de duplicidad de las planillas independientes.

---

## 🛠️ Archivos del Proyecto

* **EFT_S9_Alonso_Bonansco.docx:** Documento final de entrega con las respuestas escritas y capturas de pantalla del MER-E y Modelo Relacional.
* **EFT_S9_Alonso_Bonansco.sql:** Script de base de datos definitivo (Fase 3 y Fase 4). Contiene la creación de tablas, restricciones (Identity, Secuencias y Checks), inserciones de datos y las consultas de los informes.
* **EFT_S9_Alonso_Bonansco.zip:** Archivos fuentes del modelo conceptual y relacional creados en Oracle SQL Developer Data Modeler para ser abiertos directamente en el programa.

---

## 📌 Decisiones del Diseño y Normalización

* **Herencia de Trabajadores:** Se utilizó la estrategia de tablas separadas compartiendo la misma Primary Key (`codigo_inscripcion`) que actúa como Foreign Key hacia `TRABAJADOR`. Esto evita repetir nombres, RUTs y sueldos tanto en `JUGADOR` como en `PERSONAL`.
* **Tablas Maestras:** Para mantener la consistencia que pedía el ramo, se normalizaron los campos categóricos creando las tablas `GENERO`, `ESTADO_CIVIL` y `POSICION_CAMPO`, conectándolas mediante claves foráneas simples.
* **Historial de Clubes:** El requerimiento variante en el tiempo se resolvió con la tabla intermedia `PERMANENCIA_CLUB` registrando `fecha_inicio` y `fecha_termino` para guardar todo el registro histórico de los jugadores.
* **El Club sin Comuna:** Para evitar errores con los datos de poblamiento oficiales entregados en la pauta, la tabla `CLUB` se configuró estrictamente con sus 5 atributos originales, dejando la calle como un texto simple.

---

## 📊 Consultas SQL de los Informes (Fase 4)

### Informe 1: Asociaciones Profesionales
Lista las asociaciones de tipo profesional creadas después del año 2000 utilizando `TO_CHAR` para dar el formato visual `DD-MM-YYYY` exigido:
```sql
SELECT
    'ID:' || codigo_asociacion || ' * ' || nombre AS ASOCIACION,
    TO_CHAR(fecha_creacion, 'DD-MM-YYYY') AS CREADA,
    tipo_asociacion AS TIPO
FROM asociacion
WHERE fecha_creacion > TO_DATE('2000-12-31', 'YYYY-MM-DD')
    AND tipo_asociacion = 'P'
ORDER BY fecha_creacion DESC;
```

### Informe 2: Patrimonio en Dólares
Calcula el patrimonio convirtiendo pesos chilenos a dólares (\$955) formateando la salida con separadores de miles y dos decimales fijos:
```sql
SELECT
    codigo_club AS CLUB,
    nombre AS NOMBRE_CLUB,
    TO_CHAR(patrimonio, '\$999,999,999,999') AS PATRIMONIO_EN_PESOS,
    TO_CHAR(patrimonio / 955, '999,999,999.99') AS PATRIMONIO_EN_DOLARES
FROM club
WHERE LOWER(nombre) LIKE '%a%'
    AND patrimonio > 200000000
    AND tipo_club = 'Profesional'
ORDER BY codigo_club DESC;
```

---

## 👥 Datos Académicos
* **Asignatura:** Modelamiento de Bases de Datos (Semana 9 - EFT)
* **Institución:** Instituto Profesional Duoc UC

