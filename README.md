# ✈️ Modelo Entidad-Relación (MER) - BT&Airways

Este repositorio contiene la solución correspondiente a la **Semana 2** de la asignatura **Modelamiento de Bases de Datos** de la carrera **Analista Programador Computacional** en **Duoc UC Online**.

---

## 👨‍🎓 Información del Proyecto

* **Institución:** Duoc UC Online
* **Carrera:** Analista Programador Computacional
* **Asignatura:** Modelamiento de Bases de Datos
* **Profesor:** Cristian Carreño Villarroel
* **Estudiantes:** Alonso Bonansco, Beatriz López
* **Fecha:** 23 de agosto de 2026

---

## 📄 Descripción del Caso de Negocio

La aerolínea **BT&Airways**, con más de 25 años operando en el mercado de transporte global de pasajeros, requiere optimizar sus plataformas de TI. Actualmente gestiona cerca de 35,000 vuelos anuales con proyecciones a triplicarse en el mediano plazo.

El objetivo de esta actividad formativa es diseñar el **Modelo Conceptual (Modelo Entidad-Relación - MER)** y el **Modelo Relacional/Físico (Ingeniería de la Información / Notación Bachman)** para el módulo de reserva y venta de vuelos de la compañía[cite: 1].

---

## 🛠️ Reglas de Negocio Representadas

1. **Pasajeros y Reservas:** Un pasajero puede realizar múltiples reservas de vuelo[cite: 1]. Cada reserva pertenece a un único pasajero y a un único vuelo[cite: 1].
2. **Vuelos y Aviones:** Un avión (identificado por matrícula única, marca, modelo y capacidad de 200 a 800 asientos) puede realizar múltiples vuelos[cite: 1]. Cada vuelo está asociado a un único avión[cite: 1].
3. **Atención por Empleados:** Un empleado administrativo atiende al pasajero y asigna el vuelo[cite: 1].
4. **Jerarquía de Empleados (Herencia/Especialización):**
    * **Empleado:** Entidad general que registra RUT, nombres, apellidos, dirección, sueldo base, fecha de ingreso, género y teléfonos[cite: 1].
    * **Piloto:** Almacena horas de vuelo acumuladas y AFP[cite: 1].
    * **Administrativo:** Almacena horas extras y AFP[cite: 1].
5. **Equipaje:** Un pasajero puede registrar equipaje asociado a sus reservas[cite: 1]. Se identifica por un código único y posee atributos como color, peso (kg), descripción opcional, tipo de embarque (prioritario/normal) y si es frágil[cite: 1].

---

## 🗂️ Estructura del Repositorio

El repositorio está organizado de la siguiente manera:

```text
├── Encargo_Semanal.docx        # Documento explicativo e imágenes del modelo (Entregable AVA)
├── Encargo_Semanal.zip         # Archivo comprimido con el diseño original de Data Modeler
│   ├── Modelo_Base.dmd         # Archivo principal de Oracle SQL Developer Data Modeler
│   └── Modelo_Base/            # Carpeta contenedora del diseño y metadatos
└── README.md                   # Documentación general del repositorio