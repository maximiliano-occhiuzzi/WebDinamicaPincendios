package com.logica;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/LeerDatos")
public class LeerDatos extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<DatoClimatico> datos = new ArrayList<>();
        String sql = "SELECT id, fecha, temperatura_general, temperatura_peligrosa, " +
                     "humedad_tierra, gases, humedad_aire, viento " +
                     "FROM datos " +
                     "ORDER BY fecha DESC " +
                     "LIMIT 10";

        try (Connection conexion = ConexionBD.obtenerConexion();
             Statement statement = conexion.createStatement();
             ResultSet rs = statement.executeQuery(sql)) {

            System.out.println("Conexión exitosa a la base de datos.");

            boolean tieneDatos = false;

            while (rs.next()) {
                tieneDatos = true;

                Timestamp timestamp = rs.getTimestamp("fecha");
                Date fecha = new Date(timestamp.getTime());

                double temperaturaGeneral = rs.getDouble("temperatura_general");
                double temperaturaPeligrosa = rs.getDouble("temperatura_peligrosa");
                double humedadTierra = rs.getDouble("humedad_tierra");
                double gases = rs.getDouble("gases");
                double humedadAire = rs.getDouble("humedad_aire");
                double viento = rs.getDouble("viento");

                System.out.println("Fecha: " + fecha +
                        ", Temp general: " + temperaturaGeneral +
                        ", Peligrosa: " + temperaturaPeligrosa +
                        ", Tierra: " + humedadTierra +
                        ", Humedad Aire: " + humedadAire +
                        ", Gases: " + gases +
                        ", Viento: " + viento);

                DatoClimatico dato = new DatoClimatico(
                        fecha, temperaturaGeneral, temperaturaPeligrosa,
                        humedadTierra, humedadAire, gases, viento
                );

                datos.add(dato);
            }

            if (!tieneDatos) {
                System.out.println("No se encontraron datos en la base de datos.");
            }

            request.setAttribute("datos", datos);
            request.getRequestDispatcher("vistas/PaginaClima.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error de base de datos: " + e.getMessage());
            request.getRequestDispatcher("vistas/ErrorPage.jsp").forward(request, response);
        }
    }
}
