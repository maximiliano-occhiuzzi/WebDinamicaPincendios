# 🔥 FireNova

![Estado](https://shields.io)
![Java](https://img.shields.io/badge/Java-Backend-orange)
![MySQL](https://img.shields.io/badge/Base%20de%20Datos-MySQL-blue)
![Leaflet](https://img.shields.io/badge/Mapa-Leaflet-green)
![Licencia](https://img.shields.io/badge/licencia-Educativo-lightgrey)

---

## 📌 Descripción

**FireNova** es una plataforma web de monitoreo ambiental en tiempo real orientada a la **detección temprana de condiciones de riesgo**, como incendios o eventos climáticos extremos. 

Este proyecto fue desarrollado de forma **colaborativa**, integrando hardware físico desplegado en terreno con una infraestructura de software robusta para la visualización y análisis de datos.

---

## 🎯 Objetivo

Brindar una herramienta visual integral que permita:
* Detectar condiciones peligrosas de forma temprana mediante sensores físicos.
* Analizar variables climáticas críticas en tiempo real.
* Representar datos geolocalizados de manera clara e intuitiva para la toma de decisiones.

---

## ⚙️ Tecnologías y Desarrollo

### 💻 Desarrollo de Software (Fullstack & DB)
Responsable del ciclo completo de la aplicación:
* **Backend:** Arquitectura en Java (Servlets + JSP) para la gestión de lógica de negocios.
* **Frontend:** Interfaz dinámica con HTML5, CSS3 y JavaScript (ES5), integrando **Leaflet.js** para el renderizado de mapas interactivos.
* **Base de Datos:** Diseño y administración de **MySQL** para el almacenamiento histórico y actual de los reportes.

### 🔌 Hardware y Despliegue
El equipo de hardware se encargó de la configuración, ensamblaje y puesta en marcha de los dispositivos físicos, los cuales se encuentran actualmente **desplegados y operativos**, enviando datos reales al sistema.

---

## 🧠 Funcionalidades Implementadas

* 📍 **Mapa interactivo:** Sensores geolocalizados en tiempo real.
* 🌡 **Monitoreo de Variables:** Temperatura, humedad (suelo/aire), gases y viento.
* 🎨 **Semáforo de Riesgo:** Indicadores visuales por color según la criticidad.
* 🚨 **Alertas Dinámicas:** Notificaciones automáticas basadas en umbrales de peligro.
* 📊 **Historial:** Panel con los últimos registros capturados por el hardware físico.

---

## 🗺️ Arquitectura y Flujo de Datos

El sistema funciona mediante una arquitectura cliente-servidor integrada con hardware IoT:

1. **Captura:** El **Hardware físico (Arduino)** captura las variables ambientales.
2. **Recepción:** El Servlet `RecibirDatos` procesa la petición vía **WiFi (HTTP/POST)** y persiste la información en **MySQL**.
3. **Lectura:** El Servlet `LeerDatos` recupera los registros actuales cuando el cliente lo requiere.
4. **Visualización:** El **Frontend** transforma los datos en objetos JS y **Leaflet** los renderiza en el mapa con alertas visuales.

---

## 💻 Mi Rol en el Proyecto

Me encargué de desarrollar la infraestructura digital completa:
* **API de Recepción:** Servlet para comunicación WiFi con Arduino.
* **Persistencia:** Diseño y gestión de la base de datos en MySQL.
* **Lógica:** Procesamiento de alertas y lógica de negocio en Java.
* **UI/UX:** Diseño del Dashboard y mapa interactivo.

---

## 🚀 Acceso al Proyecto

Puedes ver la plataforma en funcionamiento aquí:
🔗 [Demo FireNova](http://proyectos.fatimarem.edu.ar:8081/FireNova/)

---

## 👥 Equipo de Trabajo


| Integrante | Rol / Especialidad |
| :--- | :--- |
| **Maximiliano Occhiuzzi** | Desarrollo de Software (Fullstack) & DB |
| **Mayra Equice** | Desarrollo de IA "Fira" |
| **Ailen Mier** | Hardware & Robótica |
| **Brenda Cardozo** | Hardware & Robótica |

---

## 📜 Licencia
Proyecto con fines educativos - **Instituto Técnico Nuestra Señora de Fátima**.
