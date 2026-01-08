package com.logica;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

	private static final String URL = "jdbc:mysql://localhost:3306/datosclimaticos?useUnicode=true&characterEncoding=UTF-8";
	private static final String USUARIO = "root";
	private static final String CONTRASENA = ""; // Si la base de datos no tiene contraseña, deja esto vacío


    public static Connection obtenerConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Corregido: sin espacios extra
            Connection conexion = DriverManager.getConnection(URL, USUARIO, CONTRASENA);
            System.out.println("Conexión exitosa a la base de datos.");
            return conexion;
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver JDBC no encontrado", e);
        }
    }
}

