package com.logica;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RecibirDatos")
public class RecibirDatos extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RecibirDatos() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Declarar variables fuera del try para que estén disponibles luego
        double temperatura = 0;
        double humedad_tierra = 0;
        double aire_valor = 0;
        double gases_valor = 0;

        try {
            // Recibir parámetros desde Arduino
            String tempParam = request.getParameter("temperatura");
            String humedadSuelo = request.getParameter("humedadSuelo");
            String humedadAire = request.getParameter("humedadAire");
            String gas = request.getParameter("gas");
            // Agregar "velocidad" en el resto del programa
            String velocidad = request.getParameter("velocidad");
            
            System.out.println("Temperatura: " + tempParam);
            System.out.println("Humedad suelo: " + humedadSuelo);
            System.out.println("Humedad aire: " + humedadAire);
            System.out.println("Gases: " + gas);
            System.out.println("Velocidad: " + gas);
            System.out.println("\n");

            if (tempParam == null || humedadSuelo == null || humedadAire == null || gas == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros.");
                return;
            }
            System.out.println("Recibido - humedadSuelo: " + humedadSuelo);

            // Conversión de tipos
            temperatura = Double.parseDouble(tempParam);
            humedad_tierra = Double.parseDouble(humedadSuelo);
            aire_valor = Double.parseDouble(humedadAire);
            gases_valor = Double.parseDouble(gas);

            // Enviar respuesta a Arduino
            response.setContentType("text/plain");
            response.getWriter().write("Datos recibidos correctamente");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Error al procesar datos: " + e.getMessage());
            return;
        }

        // Si no hubo errores, reenviar los datos como atributos a CrearDatos
        request.setAttribute("temperatura", temperatura);
        request.setAttribute("humedad_tierra", humedad_tierra);
        request.setAttribute("aire", aire_valor);
        request.setAttribute("gases", gases_valor);

        // Despachar al servlet CrearDatos
        RequestDispatcher dispatcher = request.getRequestDispatcher("/CrearDatos");
        dispatcher.forward(request, response);
    }
}
