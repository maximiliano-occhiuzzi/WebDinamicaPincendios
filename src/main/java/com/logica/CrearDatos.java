package com.logica;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/CrearDatos")
public class CrearDatos extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Obtener atributos enviados desde RecibirDatos
            double temperatura = (double) request.getAttribute("temperatura");
            double humedad_tierra = (double) request.getAttribute("humedad_tierra");
            double aire = (double) request.getAttribute("aire");
            double gases = (double) request.getAttribute("gases");
            // agregar "velocidad"
            
            // Conexión a la base de datos
            try (Connection conexion = ConexionBD.obtenerConexion()) {
                String sql = "INSERT INTO datos (temperatura_general, humedad_tierra, humedad_aire, gases, fecha) VALUES (?, ?, ?, ?, NOW())";
                try (PreparedStatement statement = conexion.prepareStatement(sql)) {
                    statement.setDouble(1, temperatura);
                    statement.setDouble(2, humedad_tierra);
                    statement.setDouble(3, aire);
                    statement.setDouble(4, gases);
                    
                    int filasAfectadas = statement.executeUpdate();
                    if (filasAfectadas > 0) {
                        System.out.println("Datos insertados correctamente.");
                    } else {
                        System.out.println("No se insertaron datos.");
                    }
                }
            }

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Datos insertados en la base correctamente.");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error al insertar datos: " + e.getMessage());
        }
    }
}
