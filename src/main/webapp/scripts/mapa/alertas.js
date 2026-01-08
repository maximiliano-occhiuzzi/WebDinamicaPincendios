/**
 * ===============================
 * SCRIPT DE ALERTAS – ES5
 * ===============================
 * Requiere:
 *  - coordenadasCordoba (array)
 *  - ultimosDatos (array)
 *  - div #alert-message
 */

/* ===============================
   UNIR COORDENADAS + DATOS
================================ */

var sensoresConDatos = [];

for (var i = 0; i < coordenadasCordoba.length; i++) {
    var coord = coordenadasCordoba[i];
    var dato = ultimosDatos[i];

    if (!dato) continue;

    var sensor = {};
    sensor.nombre = coord.nombre;
    sensor.lat = coord.lat;
    sensor.lng = coord.lng;

    // copiar propiedades del dato (sin spread)
    for (var prop in dato) {
        if (dato.hasOwnProperty(prop)) {
            sensor[prop] = dato[prop];
        }
    }

    sensoresConDatos.push(sensor);
}

/* ===============================
   FUNCIÓN DE ALERTAS
================================ */

function actualizarAlertas() {
    var alertContainer = document.getElementById("alert-message");
    alertContainer.innerHTML = "";

    var hayAlertas = false;

    for (var i = 0; i < sensoresConDatos.length; i++) {
        var s = sensoresConDatos[i];

        if (
            s.temperaturaGeneral > 30 &&
            s.humedadTierra < 30 &&
            s.viento > 30
        ) {
            hayAlertas = true;

            var html = "";
            html += "<p>";
            html += "<strong>⚠️ Condiciones peligrosas en " + s.nombre + ":</strong><br>";
            html += "🌡 Temp: " + s.temperaturaGeneral + "°C<br>";
            html += "💧 Humedad: " + s.humedadTierra + "%<br>";
            html += "💨 Viento: " + s.viento + " km/h";
            html += "</p>";

            alertContainer.innerHTML += html;
        }
    }

    if (!hayAlertas) {
        alertContainer.innerHTML = "<p>No hay riesgo previsto</p>";
    }

    // clases para el CSS que ya tenés
    alertContainer.className = "alert-message " + (hayAlertas ? "danger" : "warning");
}

/* ===============================
   EJECUCIÓN
================================ */

actualizarAlertas();
