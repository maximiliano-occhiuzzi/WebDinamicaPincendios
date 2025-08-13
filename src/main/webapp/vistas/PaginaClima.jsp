<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.logica.DatoClimatico"%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mapa Visual Térmico Dinámico - Argentina</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/map.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/main1.css">

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />


<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

</head>
<body>
	<div class="container">
			<header class="header">
			<div class="logo-container">
				<div class="logo">
					<img src="${pageContext.request.contextPath}/multimedia/logo.png" alt="Logo">
				</div>
				<span class="website">www.fatima.com</span>
			</div>
			<!-- Menú de navegación -->
			<nav class="main-nav">
			  <ul>
			    <li><a href="${pageContext.request.contextPath}/vistas/inicio.jsp">Inicio</a></li>
			    <li><a href="${pageContext.request.contextPath}/vistas/PaginaClima.jsp">Mapa</a></li>
			    <li><a href="${pageContext.request.contextPath}/vistas/about.jsp">About</a></li>
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
// Paso 4: Crear círculos con popups que muestran todos los valores
const circulos = {};
// Usamos los últimos 3 datos para los 3 sensores
const datosMostrar = datosClimaticos.slice(-3);

datosMostrar.forEach((dato, i) => {
  const coord = coordenadasCordoba[i];
  const color = getColor(dato.temperaturaGeneral);

  
  const popupContent =
	  "<strong>" + coord.nombre + "</strong><br>" +
	  "Fecha: " + dato.fecha + "<br>" +
	  "Temp. General: " + dato.temperaturaGeneral + "°C<br>" +
	  "Temp. Peligrosa: " + dato.temperaturaPeligrosa + "°C<br>" +
	  "Humedad Tierra: " + dato.humedadTierra + "%<br>" +
	  "Aire: " + dato.aire + "<br>" +
	  "Gases: " + dato.gases + "<br>" +
	  "Viento: " + dato.viento + " km/h";
	
  const circulo = L.circle([coord.lat, coord.lng], {
	 
    color: color,
    fillColor: color,
    fillOpacity: 0.6,
    radius: 9000
  }).addTo(map).bindPopup(popupContent);

  circulos[i] = circulo;

});

</script>

				</div>
				<div class="map-controls">
					<button id="zoom-in">+</button>
					<button id="zoom-out">-</button>
				</div>
			</div>

			<!-- Right - Data + Alerta -->
			<div class="right-panels">
				<!-- Panel de datos -->
				<div class="panel data-panel">
					<h2>Datos diarios sensados y levantados de la BD</h2>
					<%
					if (ultimoDato == null) {
					%>
					<p>No hay datos para mostrar.</p>
					<%
					} else {
					%>
					<table class="data-table">
						<tr>
							<th>Fecha</th>
							<td><%=ultimoDato.getFecha()%></td>
						</tr>
						<tr>
							<th>Temperatura General</th>
							<td><%=ultimoDato.getTemperaturaGeneral()%>°C</td>
						</tr>
						<tr>
							<th>Temperatura Peligrosa</th>
							<td><%=ultimoDato.getTemperaturaPeligrosa()%>°C</td>
						</tr>
						<tr>
							<th>Humedad Tierra</th>
							<td><%=ultimoDato.getHumedadTierra()%>%</td>
						</tr>
						<tr>
							<th>Aire</th>
							<td><%=ultimoDato.gethumedadAire()%></td>
						</tr>
						<tr>
							<th>Gases</th>
							<td><%=ultimoDato.getGases()%></td>
						</tr>
						<tr>

							<th>viento</th>
							<td><%=ultimoDato.getViento()%></td>

					</table>
					<%
					}
					%>
				</div>

<%
    String alertClass = "";
    if (datos != null && !datos.isEmpty()) {
        boolean hayAlertas = false;
        String[] nombresSensores = { "Sensor Norte", "Sensor Centro", "Sensor Este", "Sensor Sur", "Sensor Extra" };

        for (int i = 0; i < datos.size(); i++) {
            DatoClimatico dato = datos.get(i);
            if (dato.getTemperaturaGeneral() > 30 &&
                dato.gethumedadAire() > 30 &&
                dato.getViento() > 30) {
                hayAlertas = true;
                alertClass = "danger"; // Aquí marcamos clase danger
            }
        }

        if (!hayAlertas) {
            alertClass = "warning"; // Podrías usar warning si no hay peligro
        }
    } else {
        alertClass = "warning";
    }
%>

<div class="panel alert-panel" id="alert-panel">
  <h2>Mensajes de alerta</h2>
    <div class="alert-message <%= alertClass %>" id="alert-message">
        <%
            if (datos != null && !datos.isEmpty()) {
                boolean hayAlertas = false;
                String[] nombresSensores = { "Sensor Norte", "Sensor Centro", "Sensor Este", "Sensor Sur", "Sensor Extra" };

                for (int i = 0; i < datos.size(); i++) {
                    DatoClimatico dato = datos.get(i);
                    if (dato.getTemperaturaGeneral() > 30 &&
                        dato.gethumedadAire() > 30 &&
                        dato.getViento() > 30) {
                        hayAlertas = true;
                        String nombreSensor = (i < nombresSensores.length) ? nombresSensores[i] : "Sensor " + (i + 1);
        %>
         <p>
   			 <strong>Condiciones peligrosas en <%= nombreSensor %>:</strong><br>
  				  🌡 Temperatura: <%= dato.getTemperaturaGeneral() %>°C<br>
   					 💧 Humedad: <%= dato.gethumedadAire() %>%<br>
    					💨 Viento: <%= dato.getViento() %> km/h
		</p>
        <%
                    }
                }

                if (!hayAlertas) {
        %>
                    <p>No hay riesgo previsto</p>
        <%
                }
            } else {
        %>
                <p>Sin información disponible.</p>
        <%
            }
        %>
    </div>
</div>

	</div>
		</main>
		
	</div>

	<script src="scripts/data.js"></script>
	<script src="scripts/map.js"></script>
	<script src="scripts/main.js"></script>
</body>
</html>