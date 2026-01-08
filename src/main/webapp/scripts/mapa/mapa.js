// ================= MAPA =================
var map;
var markers = [];

// ================= COORDENADAS =================
var SENSOR_COORDS = [
    { id: 1, nombre: "Sensor Norte", lat: -30.5, lng: -64.0 },
    { id: 2, nombre: "Sensor Centro", lat: -31.4, lng: -64.2 },
    { id: 3, nombre: "Sensor Sur", lat: -32.0, lng: -62.9 }
];

// ================= INIT =================
function initMap() {
    map = L.map("map").setView([-31.5, -64.1], 6);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: "© OpenStreetMap",
        maxZoom: 18
    }).addTo(map);

    cargarSelect();
    cargarSensores();
    cargarAlertasGlobales();
    cargarPanelSensor(0);
}

// ================= RIESGO =================
function calcularRiesgo(d) {
    if (d.temperatura > 35 && d.viento > 30 && d.humedad < 30) return "CRITICO";
    if (d.temperatura > 30) return "ALTO";
    if (d.temperatura > 25) return "MODERADO";
    return "BAJO";
}

function getColor(r) {
    if (r === "BAJO") return "#22c55e";
    if (r === "MODERADO") return "#eab308";
    if (r === "ALTO") return "#f97316";
    if (r === "CRITICO") return "#ef4444";
    return "#6b7280";
}

// ================= SELECT =================
function cargarSelect() {
    var select = document.getElementById("sensor-select");
    if (!select) return;

    select.innerHTML = "<option value='all'>Todos los sensores</option>";

    for (var i = 0; i < SENSOR_COORDS.length; i++) {
        var op = document.createElement("option");
        op.value = i;
        op.innerHTML = SENSOR_COORDS[i].nombre;
        select.appendChild(op);
    }

    select.onchange = function () {
        if (this.value !== "all") {
            cargarPanelSensor(this.value);
            map.setView(
                [SENSOR_COORDS[this.value].lat, SENSOR_COORDS[this.value].lng],
                8
            );
        }
    };
}

// ================= SENSORES =================
function cargarSensores() {
    for (var i = 0; i < markers.length; i++) {
        map.removeLayer(markers[i]);
    }
    markers = [];

    for (var i = 0; i < SENSOR_COORDS.length; i++) {
        var d = DATOS_CLIMATICOS[i];
        if (!d) continue;

        var riesgo = calcularRiesgo(d);
        var color = getColor(riesgo);

        var icon = L.divIcon({
            className: "custom-marker",
            html:
                "<div style='background:" + color + ";" +
                "width:30px;height:30px;border-radius:50%;" +
                "border:3px solid white;" +
                "box-shadow:0 2px 8px rgba(0,0,0,.3);" +
                "animation:pulse-marker 2s infinite'></div>",
            iconSize: [30, 30],
            iconAnchor: [15, 15]
        });

        var popup =
            "<div class='custom-popup'>" +
            "<h4>" + SENSOR_COORDS[i].nombre + "</h4>" +
            "<p><strong>Fecha:</strong> " + d.fecha + "</p>" +
            "<p><strong>Temperatura:</strong> " + d.temperatura + " °C</p>" +
            "<p><strong>Humedad:</strong> " + d.humedad + " %</p>" +
            "<p><strong>Viento:</strong> " + d.viento + " km/h</p>" +
            "<p><strong>Gases:</strong> " + d.gases + "</p>" +
            "<div class='risk-badge' style='background:" + color + ";color:white'>" +
            "Riesgo: " + riesgo +
            "</div></div>";

        markers.push(
            L.marker(
                [SENSOR_COORDS[i].lat, SENSOR_COORDS[i].lng],
                { icon: icon }
            ).addTo(map).bindPopup(popup)
        );
    }
}

// ================= PANEL SENSOR =================
function cargarPanelSensor(i) {
    var d = DATOS_CLIMATICOS[i];
    if (!d) return;

    document.getElementById("temp-1").innerHTML = d.temperatura + " °C";
    document.getElementById("humidity-1").innerHTML = d.humedad + " %";
    document.getElementById("wind-1").innerHTML = d.viento + " km/h";
    document.getElementById("co2-1").innerHTML = d.gases;
    document.getElementById("risk-1").innerHTML = calcularRiesgo(d);
}

// ================= ALERTAS =================
function cargarAlertasGlobales() {
    var cont = document.getElementById("alerts-container");
    cont.innerHTML = "";

    var hayCritico = false;

    for (var i = 0; i < DATOS_CLIMATICOS.length; i++) {
        var d = DATOS_CLIMATICOS[i];
        var r = calcularRiesgo(d);

        if (r !== "BAJO") {
            var div = document.createElement("div");
            div.className =
                "alert-item " +
                (r === "CRITICO" ? "danger" : "warning");

            div.innerHTML =
                "<i class='fas fa-exclamation-triangle'></i>" +
                "<div class='alert-content'>" +
                "<strong>" + SENSOR_COORDS[i].nombre + "</strong>" +
                "<p>Riesgo " + r +
                " - Temp: " + d.temperatura + "°C</p>" +
                "<span class='alert-time'>Fecha: " + d.fecha + "</span>" +
                "</div>";

            cont.appendChild(div);
            if (r === "CRITICO") hayCritico = true;
        }
    }

    if (!cont.innerHTML) {
        cont.innerHTML =
            "<div class='alert-item normal'>" +
            "<i class='fas fa-check-circle'></i>" +
            "<div class='alert-content'>" +
            "<strong>Sistema Normal</strong>" +
            "<p>Sin alertas activas</p></div></div>";
    }

    if (hayCritico) mostrarModalCritico();
}

// ================= MODAL =================
function mostrarModalCritico() {
    var modal = document.createElement("div");
    modal.style.cssText =
        "position:fixed;top:0;left:0;width:100%;height:100%;" +
        "background:rgba(0,0,0,.6);display:flex;" +
        "align-items:center;justify-content:center;z-index:9999";

    modal.innerHTML =
        "<div style='background:#111827;padding:25px;border-radius:12px;" +
        "color:white;text-align:center;box-shadow:0 0 20px rgba(239,68,68,.6)'>" +
        "<h2 style='color:#ef4444'>⚠ ALERTA CRÍTICA</h2>" +
        "<p>Se detectó riesgo elevado de incendio</p>" +
        "<button id='cerrarModal' style='margin-top:15px;padding:8px 14px;" +
        "border:none;border-radius:6px;background:#ef4444;color:white'>" +
        "Entendido</button></div>";

    document.body.appendChild(modal);
    document.getElementById("cerrarModal").onclick = function () {
        document.body.removeChild(modal);
    };
}

// ================= LOAD =================
document.addEventListener("DOMContentLoaded", initMap);

// ================= ANIM =================
var style = document.createElement("style");
style.innerHTML =
    "@keyframes pulse-marker{0%,100%{transform:scale(1)}50%{transform:scale(1.1)}}";
document.head.appendChild(style);
