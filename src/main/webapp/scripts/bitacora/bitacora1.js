/* =====================================
   DATOS DE LA BITÁCORA (EDITÁS ACÁ)
   Cada página tiene hasta 3 entradas
===================================== */

var paginas = [
    [
        {
            fecha: "26 de marzo de 2025",
            titulo: "Presentación del Proyecto",
            icono: "fa-users",
            texto: "Los profesores nos estuvieron hablando sobre la feria, los proyectos anteriores y cómo encarar el nuestro."
        },
        {
            fecha: "3 de abril de 2025",
            titulo: "Formación del Equipo",
            icono: "fa-user-friends",
            texto: "Nos reunimos para compartir ideas y comenzar a formar el grupo de trabajo."
        },
        {
            fecha: "10 de abril de 2025",
            titulo: "Definición de la Problemática",
            icono: "fa-lightbulb",
            texto: "Decidimos enfocarnos en la prevención de incendios forestales."
        }
    ],
    [
        {
            fecha: "23 de abril de 2025",
            titulo: "Inicio del Desarrollo",
            icono: "fa-laptop-code",
            texto: "Comenzamos a trabajar en la bitácora digital y la idea general del sistema."
        },
        {
            fecha: "8 de mayo de 2025",
            titulo: "Sensores y Hardware",
            icono: "fa-microchip",
            texto: "Avanzamos en la investigación y armado de sensores."
        },
        {
            fecha: "22 de mayo de 2025",
            titulo: "Base de Datos",
            icono: "fa-database",
            texto: "Diseñamos la estructura de la base de datos."
        }
    ]
];

/* =====================================
   VARIABLES DE CONTROL
===================================== */

var paginaActual = 0;

var leftPage = document.getElementById("leftPage");
var rightPage = document.getElementById("rightPage");

var btnPrev = document.getElementById("prevBtn");
var btnNext = document.getElementById("nextBtn");

var currentPageSpan = document.getElementById("currentPage");
var totalPagesSpan = document.getElementById("totalPages");

totalPagesSpan.innerHTML = paginas.length;

/* =====================================
   RENDER DE PÁGINA
===================================== */

function renderPagina() {
    leftPage.innerHTML = '<div class="page-content"></div>';
    rightPage.innerHTML = '<div class="page-content"></div>';

    var contLeft = leftPage.querySelector(".page-content");
    var contRight = rightPage.querySelector(".page-content");

    var datos = paginas[paginaActual];

    for (var i = 0; i < datos.length; i++) {
        var e = datos[i];

        var html = "";
        html += '<div class="process-entry">';
        html += '  <div class="entry-date">';
        html += '    <i class="fas fa-calendar-alt"></i>';
        html += '    <span>' + e.fecha + '</span>';
        html += '  </div>';
        html += '  <div class="entry-content">';
        html += '    <h3>' + e.titulo + '</h3>';
        html += '    <div class="entry-image">';
        html += '      <i class="fas ' + e.icono + '"></i>';
        html += '    </div>';
        html += '    <p>' + e.texto + '</p>';
        html += '  </div>';
        html += '</div>';

        if (i < 2) {
            contLeft.innerHTML += html;
        } else {
            contRight.innerHTML += html;
        }
    }

    currentPageSpan.innerHTML = paginaActual + 1;

    btnPrev.disabled = paginaActual === 0;
    btnNext.disabled = paginaActual === paginas.length - 1;
}

/* =====================================
   EVENTOS
===================================== */

btnPrev.onclick = function () {
    if (paginaActual > 0) {
        paginaActual--;
        renderPagina();
    }
};

btnNext.onclick = function () {
    if (paginaActual < paginas.length - 1) {
        paginaActual++;
        renderPagina();
    }
};

/* =====================================
   INIT
===================================== */

renderPagina();
