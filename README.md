# 📊 Aplicando conceptos de modelamiento inicial

### Formativa 1 - Semana 1

Este repositorio contiene el diagrama conceptual y lógico de la base de datos para el proyecto. Aquí se detallan de
forma visual las entidades, sus atributos y las relaciones que estructuran nuestro sistema.

## 📂 Contenido del Repositorio

* **`Encargo_Semanal.docx`**: Archivo word con el formato de respuesta solicitado. Incluye las imágenes de los modelos en
  notación Barker y Bachman.
* **`[Encargo_Semanal.zip]/`**: Carpeta de diseño técnico que incluye el archivo de arquitectura de datos `.dmd`.

## 🗺️ Modelos Entidad-Relación (MER)

### Notación de Barker

<img width="686" height="534" alt="Barker_semana1" src="https://github.com/user-attachments/assets/92431776-b7af-4bb7-96af-32c05b89e13d" />


### Notación de Bachman

<img width="684" height="536" alt="Bachman_semana1" src="https://github.com/user-attachments/assets/1661c0ff-5647-4f30-b29a-58dc5fa580f2" />

## 📝 Reglas de Negocio Clave

* Un **Pasajero** puede realizar múltiples **Reservas**, pero una Reserva pertenece a un único Pasajero.
* Un **Vuelo** puede tener muchas **Reservas**, pero éstas están asociadas a un solo Vuelo.
* Para que exista un **Vuelo** válido es necesario que exista una reserva. No se consideran vuelos fantasmas (sin
  pasajeros).

*Nota: Definir la relación entre VUELO y RESERVA como totalmente continua provoca un **Bloqueo de Integridad Referencial
Circular**, creando una dependencia
mutua donde ninguno de los registros puede guardarse primero en la base de datos. Pero actualmente nuestro sistema
representa un Modelo Conceptual de Negocio y no un modelo físico de implementación.

## 🛠️ Herramientas Requeridas

Para abrir, editar y visualizar el archivo estructurado `.dmd` contenido en la carpeta, es necesario instalar uno de los
siguientes:

* **Oracle SQL Developer Data Modeler** (Herramienta dedicada).
* **Oracle SQL Developer** (Versión estándar): Ir a **File** -> **Data Modeler** -> **Open**

---

### Autores:

Alonso Bonansco y Beatriz López  
Modelamiento de Base de Datos - 004A  
Analista Programador Computacional
