
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.logica.DatoClimatico"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mapa Visual Térmico Dinámico - Argentina</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/styles/main.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/styles/map.css">

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<link rel="apple-touch-icon" sizes="512x512"
	href="${pageContext.request.contextPath}/multimedia/apple-touch-icon.png">


<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
</head>
<body>
	<div class="container">
		<header class="header">
			<div class="logo-container">
				<div class="logo">
					<img src="${pageContext.request.contextPath}/multimedia/logo.png"
						alt="Logo">
				</div>
				<span class="website">www.fatima.com</span>
			</div>
			<!-- Menú de navegación -->
			<nav class="main-nav">
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/vistas/inicio.jsp">Inicio</a></li>
					<li><a href="${pageContext.request.contextPath}/LeerDatos">Mapa</a></li>
					<li><a
						href="${pageContext.request.contextPath}/vistas/Bitacora.jsp">bitacora</a></li>

				</ul>
			</nav>
			<h1 class="title">Mapa visual térmico dinámico</h1>


		</header>

		<main class="main-content">
			<!-- Left - Legend -->
			<div class="panel danger-level-panel">
				<h2>Cuadro cromático de peligrosidad</h2>
				<div class="danger-levels">
					<div class="danger-level">
						<div class="color-box extreme"></div>
						<span>Extremo (40°C)</span>
					</div>
					<div class="danger-level">
						<div class="color-box high"></div>
						<span>Alto (30-40°C)</span>
					</div>
					<div class="danger-level">
						<div class="color-box medium"></div>
						<span>Medio (20-30°C)</span>
					</div>
					<div class="danger-level">
						<div class="color-box low"></div>
						<span>Bajo (10-20°C)</span>
					</div>
					<div class="danger-level">
						<div class="color-box minimal"></div>
						<span>Mínimo (10°C)</span>
					</div>
				</div>
			</div>

			<!-- Center - Map -->
			<div class="map-container">
				<div class="map-info">
					<div class="date">
						<span>Fecha: </span>
						<%
						List<DatoClimatico> datos = (List<DatoClimatico>) request.getAttribute("datos");
						DatoClimatico ultimoDato = (datos != null && !datos.isEmpty()) ? datos.get(datos.size() - 1) : null;
						if (ultimoDato != null) {
						%>
						<span id="current-date"><%=ultimoDato.getFecha()%></span>
						<%
						} else {
						%>
						<span id="current-date">No disponible</span>
						<%
						}
						%>
					</div>
				</div>
				<div id="map-wrapper">
					<div id="map"></div>
					<script>
    const map = L.map('map', {
      center: [-38.4161, -63.6167], // Centro de Argentina
      zoom: 5,
    });
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(map);
    
  </script>
					<script>
// Paso 1: Pasar los datos Java al entorno JavaScript
const datosClimaticos = [
  <%if (datos != null && !datos.isEmpty()) {
	for (int i = 0; i < datos.size(); i++) {
		DatoClimatico d = datos.get(i);
		String fechaStr = (d.getFecha() != null) ? d.getFecha().toString() : "Sin fecha";
		double tempGen = d.getTemperaturaGeneral();
		double tempPelig = d.getTemperaturaPeligrosa();
		double humedad = d.getHumedadTierra();
		double aireStr = d.gethumedadAire();
		double gasesStr = d.getGases();
		double vientoStr = d.getViento();%>
  {
    fecha: "<%=fechaStr%>",
    temperaturaGeneral: <%=tempGen%>,
    temperaturaPeligrosa: <%=tempPelig%>,
    humedadTierra: <%=humedad%>,
    aire: <%=aireStr%>,
    gases: <%=gasesStr%>,
    viento: <%=vientoStr%>,
  }<%=(i < datos.size() - 1) ? "," : ""%>
  <%}
}%>
];
console.log("Datos Climáticos recibidos:", datosClimaticos);
// Paso 2: Coordenadas para sensores en Córdoba
const coordenadasCordoba = [
  { lat: -30.5, lng: -64.0, nombre: "Sensor Norte" },
  { lat: -31.4, lng: -64.2, nombre: "Sensor Centro" },
  { lat: -32.0, lng: -62.9, nombre: "Sensor Este" }
];
// Paso 3: Función para asignar color según temperatura peligrosa
function getColor(valor) {
  const num = Number(valor);
  if (isNaN(num)) return null; // o algún color por defecto si no es número
  if (num < 10) return "#00ffff";  // celeste
  if (num < 20) return "#00cc44";  // verde
  if (num < 30) return "#ffff00";  // amarillo
  if (num < 40) return "#ff8000";  // naranja
  return "#ff0000";  // rojo si es >= 40
}
//Paso 4: Tomar solo los últimos 3 registros
let ultimosDatos = datosClimaticos.slice(-Math.min(coordenadasCordoba.length, datosClimaticos.length));
// Paso 5: Barajar los últimos datos para asignarlos al azar
for (let i = ultimosDatos.length - 1; i > 0; i--) {
  const j = Math.floor(Math.random() * (i + 1));
  [ultimosDatos[i], ultimosDatos[j]] = [ultimosDatos[j], ultimosDatos[i]];
}
// Paso 6: Crear círculos con los datos barajados
coordenadasCordoba.forEach((coord, index) => {
  const dato = ultimosDatos[index]; // asigna un dato al azar a cada sensor
  if (!dato) return; // evita errores si no hay suficiente dato
  const color = getColor(dato.temperaturaGeneral);
  const popupContent =
      "<strong>" + coord.nombre + "</strong><br>" +
      "Fecha: " + dato.fecha + "<br>" +
      "Temp. General: " + dato.temperaturaGeneral + "°C<br>" +
      "Humedad Tierra: " + dato.humedadTierra + "%<br>" +
      "Aire: " + dato.aire + "<br>" +
      "Gases: " + dato.gases + "<br>" +
      "Viento: " + dato.viento + " km/h";
  L.circle([coord.lat, coord.lng], {
      color: color,
      fillColor: color,
      fillOpacity: 0.6,
      radius: 9000
  }).addTo(map).bindPopup(popupContent);
});
let registrosConSensor = ultimosDatos.map((dato, index) => ({
	  sensor: coordenadasCordoba[index].nombre,  // nombre del sensor desde coordenadas
	  fecha: dato.fecha,
	  tempGeneral: dato.temperaturaGeneral,
	  humedadTierra: dato.humedadTierra,
	  aire: dato.aire,
	  gases: dato.gases,
	  viento: dato.viento
	}));
</script>

				</div>
				<div class="map-controls">
					<button id="zoom-in">+</button>
					<button id="zoom-out">-</button>
				</div>
			</div>

			<div class="right-panels">
				<h2>Últimos registros</h2>
				<table class="data-table" id="tablaRegistros">
					<tbody>
						<!-- Se llena con JS -->
					</tbody>
				</table>

				<div class="carousel-controls">
					<button id="prev">⟨ Anterior</button>
					<button id="next">Siguiente ⟩</button>
				</div>

				<!-- 👇 El panel de alerta va adentro de right-panels -->
				<div class="panel alert-panel" id="alert-panel">
					<h2>Mensajes de alerta</h2>
					<div class="alert-message" id="alert-message">
						<p>Cargando datos...</p>
					</div>
				</div>

				<script>
//👇 este arreglo es el que usan las alertas
let sensoresConDatos = coordenadasCordoba.map((coord, index) => ({
  nombre: coord.nombre,
  lat: coord.lat,
  lng: coord.lng,
  datos: ultimosDatos[index]
})).filter(s => s.datos);
// Función de alertas
function actualizarAlertas() {
  const alertContainer = document.getElementById("alert-message");
  alertContainer.innerHTML = ""; 
  let hayAlertas = false;
  sensoresConDatos.forEach(s => {
    if (s.datos.temperaturaGeneral > 30 &&
        s.datos.humedadTierra < 30 &&
        s.datos.viento > 30) {
      hayAlertas = true;
      alertContainer.innerHTML +=
        "<p>" +
          "<strong>⚠️ Condiciones peligrosas en " + s.nombre + ":</strong><br>" +
          "🌡 Temp: " + s.datos.temperaturaGeneral + "°C<br>" +
          "💧 Humedad: " + s.datos.humedadTierra + "%<br>" +
          "💨 Viento: " + s.datos.viento + " km/h" +
        "</p>";
    }
  });
  if (!hayAlertas) {
    alertContainer.innerHTML = "<p>No hay riesgo previsto</p>";
  }
  alertContainer.className = "alert-message " + (hayAlertas ? "danger" : "warning");
}
// ejecutar después de definir sensoresConDatos
actualizarAlertas();
</script>


			</div>
			<!-- ahora sí cierra right-panels -->
	</div>
	</main>

	</div>

	
	<script src="scripts/mostrarRegistro.js"></script>
</body>
</html>

