# 🔧 Sistema de Gestión - Taller Mecánico Mikes Ltda.

Este repositorio contiene la solución e implementación de la base de datos para el **Taller Mecánico Mikes Ltda.**, desarrollada en **Oracle SQL** como parte de la evaluación sumativa de la **Semana 8** en **Duoc UC**.

## 📌 Contenido del Proyecto
El script único `.sql` está estructurado de manera secuencial siguiendo rigurosamente las dependencias del modelo de negocio:
1. **Limpieza del Entorno:** Sentencias de destrucción (`DROP`) ordenadas jerárquicamente para permitir la idempotencia del script.
2. **Caso 1 (DDL):** Creación de tablas estructuradas desde las entidades fuertes a las más débiles, configurando claves primarias y tipos de datos de alta precisión.
3. **Vínculos de Integridad:** Bloque consolidado de `ALTER TABLE` para la creación de claves foráneas independientes.
4. **Caso 2 (Reglas de Negocio):** Modificaciones estructurales mediante `ALTER TABLE` que incorporan restricciones de unicidad (`UNIQUE`) y validaciones de datos (`CHECK`).
5. **Caso 3 (Secuencias e Inserts):** Creación de objetos secuencia e inserción de registros fijos para pruebas de consistencia.
6. **Caso 4 (DML - Reportes):** Consultas de recuperación de datos (`SELECT`) orientadas al análisis estadístico, aplicando operadores aritméticos de proyección, filtros lógicos complejos y ordenamiento avanzado de la información.

## 🛠️ Requisitos e Instrucciones de Ejecución
* **Entorno:** Oracle SQL Developer u Oracle Cloud.
* **Usuario de Ejecución:** Conectarse e implementar idealmente bajo el usuario `PRY2204_S8` según las instrucciones específicas de la actividad.
