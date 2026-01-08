<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.logica.DatoClimatico"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mapa - Firenova</title>

<!-- CSS -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/styles/mapa/mapa.css">

<!-- Icons -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">

<!-- Leaflet -->
<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>

<body>
	<script>
var DATOS_CLIMATICOS = [
<%List<DatoClimatico> datos = (List<DatoClimatico>) request.getAttribute("datos");
if (datos != null) {
	for (int i = 0; i < datos.size(); i++) {
		DatoClimatico d = datos.get(i);%>
{
    fecha: "<%=d.getFecha()%>",
    temperatura: <%=d.getTemperaturaGeneral()%>,
    humedad: <%=d.getHumedadTierra()%>,
    viento: <%=d.getViento()%>,
    gases: <%=d.getGases()%>
}<%=(i < datos.size() - 1) ? "," : ""%>
<%}
}%>
];
</script>

	<header class="header">
		<nav class="navbar">
			<div class="nav-brand">
				<i class="fas fa-fire flame-icon"></i> <span class="brand-text">FIRENOVA</span>
			</div>

			<div class="nav-links">
				<a href="<%=request.getContextPath()%>/vistas/inicio.jsp"
					class="nav-link">Inicio</a> <a
					href="<%=request.getContextPath()%>/LeerDatos"
					class="nav-link active">Mapa</a> <a
					href="<%=request.getContextPath()%>/vistas/Consejos.jsp"
					class="nav-link">Consejos</a> <a href="#" class="nav-link">Bitácora</a>
			</div>

			<div class="mobile-menu-btn">
				<i class="fas fa-bars"></i>
			</div>
		</nav>
	</header>

	<main class="main-content">
		<div class="container">

			<!-- SELECTOR -->
			<div class="selector-container">
				<label for="sensor-select">Seleccionar Sensor:</label> <select
					id="sensor-select" class="sensor-selector">
					<option value="all">Todos los sensores</option>
					<option value="1">Sensor 1 - CABA</option>
					<option value="2">Sensor 2 - Córdoba</option>
					<option value="3">Sensor 3 - Mendoza</option>
				</select>
			</div>

			<!-- MAPA + SENSORES -->
			<div class="map-section">

				<!-- LEFT -->
				<div class="sensors-left">
					<div class="sensor-data" id="sensor-1">
						<div class="sensor-icon">
							<i class="fas fa-temperature-high"></i>
						</div>
						<div class="sensor-info">
							<h4>Temperatura</h4>
							<p class="sensor-value" id="temp-1">28°C</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>

					<div class="sensor-data" id="sensor-2">
						<div class="sensor-icon">
							<i class="fas fa-tint"></i>
						</div>
						<div class="sensor-info">
							<h4>Humedad</h4>
							<p class="sensor-value" id="humidity-1">45%</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>

					<div class="sensor-data" id="sensor-3">
						<div class="sensor-icon">
							<i class="fas fa-wind"></i>
						</div>
						<div class="sensor-info">
							<h4>Viento</h4>
							<p class="sensor-value" id="wind-1">15 km/h</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>
				</div>

				<!-- MAP -->
				<div class="map-container">
					<div id="map"></div>
				</div>

				<!-- RIGHT -->
				<div class="sensors-right">
					<div class="sensor-data" id="sensor-4">
						<div class="sensor-icon">
							<i class="fas fa-smog"></i>
						</div>
						<div class="sensor-info">
							<h4>CO2</h4>
							<p class="sensor-value" id="co2-1">400 ppm</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>

					<div class="sensor-data" id="sensor-5">
						<div class="sensor-icon">
							<i class="fas fa-fire-alt"></i>
						</div>
						<div class="sensor-info">
							<h4>Riesgo</h4>
							<p class="sensor-value" id="risk-1">Bajo</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>

					<div class="sensor-data" id="sensor-6">
						<div class="sensor-icon">
							<i class="fas fa-gauge-high"></i>
						</div>
						<div class="sensor-info">
							<h4>Presión</h4>
							<p class="sensor-value" id="pressure-1">1013 hPa</p>
							<span class="sensor-status normal">Normal</span>
						</div>
					</div>
				</div>
			</div>

			<!-- BOTTOM -->
			<div class="bottom-section">

				<div class="chromatic-panel">
					<h3>Cuadro Cromático</h3>
					<div class="color-scale">
						<div class="color-item">
							<div class="color-box" style="background: #22c55e"></div>
							<span>Bajo</span>
						</div>
						<div class="color-item">
							<div class="color-box" style="background: #eab308"></div>
							<span>Moderado</span>
						</div>
						<div class="color-item">
							<div class="color-box" style="background: #f97316"></div>
							<span>Alto</span>
						</div>
						<div class="color-item">
							<div class="color-box" style="background: #ef4444"></div>
							<span>Crítico</span>
						</div>
					</div>

					<div class="legend-info">
						<p>
							<strong>Regla de los 30:</strong>
						</p>
						<ul>
							<li>Temperatura &gt; 30°C</li>
							<li>Viento &gt; 30 km/h</li>
							<li>Humedad &lt; 30%</li>
						</ul>
					</div>
				</div>

				<div class="alert-panel">
					<h3>
						<i class="fas fa-exclamation-triangle"></i> Alertas
					</h3>
					<div class="alerts-container" id="alerts-container"></div>
				</div>

			</div>

			<!-- EMERGENCIA -->
			<div class="emergency-section">
				<h2>
					<i class="fas fa-phone-alt"></i> Números de Emergencia
				</h2>

				<div class="emergency-grid">
					<div class="emergency-card">
						<div class="emergency-icon">
							<i class="fas fa-fire-extinguisher"></i>
						</div>
						<div class="emergency-info">
							<h4>Bomberos</h4>
							<a href="tel:100" class="emergency-number">100</a>
							<p>Emergencias de incendios</p>
						</div>
					</div>

					<div class="emergency-card">
						<div class="emergency-icon">
							<i class="fas fa-hospital"></i>
						</div>
						<div class="emergency-info">
							<h4>SAME</h4>
							<a href="tel:107" class="emergency-number">107</a>
							<p>Emergencias médicas</p>
						</div>
					</div>

					<div class="emergency-card">
						<div class="emergency-icon">
							<i class="fas fa-shield-alt"></i>
						</div>
						<div class="emergency-info">
							<h4>Policía</h4>
							<a href="tel:911" class="emergency-number">911</a>
							<p>Emergencias generales</p>
						</div>
					</div>

					<div class="emergency-card">
						<div class="emergency-icon">
							<i class="fas fa-leaf"></i>
						</div>
						<div class="emergency-info">
							<h4>Defensa Civil</h4>
							<a href="tel:103" class="emergency-number">103</a>
							<p>Emergencias ambientales</p>
						</div>
					</div>
				</div>
			</div>

		</div>
	</main>

	<footer class="footer">
		<div class="container">
			<div class="footer-content">
				<div class="footer-brand">
					<i class="fas fa-fire"></i> <span>FIRENOVA</span>
				</div>
				<p>&copy; 2024 Firenova. Todos los derechos reservados.</p>
			</div>

			<button class="scroll-to-top" id="scrollToTop">
				<i class="fas fa-arrow-up"></i>
			</button>
		</div>
	</footer>

	<!-- JS -->
	<script src="<%=request.getContextPath()%>/scripts/mapa/mapa.js"></script>

</body>
</html>
