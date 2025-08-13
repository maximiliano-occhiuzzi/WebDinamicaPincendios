package com.logica;

import java.sql.Date;

public class DatoClimatico {
    private Date fecha;
    private double temperaturaGeneral;
    private double temperaturaPeligrosa;
    private double humedadTierra;
    private double humedadAire;
    private double gases;
    private double viento;
    private double latitud;
    private double longitud;
    
    
    public DatoClimatico(Date fecha, double temperaturaGeneral, double temperaturaPeligrosa,
            double humedadTierra, double humedadAire, double gases, double viento) {
        this.fecha = fecha;
        this.temperaturaGeneral = temperaturaGeneral;
        this.temperaturaPeligrosa = temperaturaPeligrosa;
        this.humedadTierra = humedadTierra;
        this.humedadAire = humedadAire;
        this.gases = gases;
        this.viento = viento;
        this.latitud= latitud;
        this.longitud= longitud;

    }

    // Getters
    public Date getFecha() {
        return fecha;
    }

    public double getTemperaturaGeneral() {
        return temperaturaGeneral;
    }

    public double getTemperaturaPeligrosa() {
        return temperaturaPeligrosa;
    }

    public double getHumedadTierra() {
        return humedadTierra;
    }

    public double gethumedadAire() {
        return humedadAire;
    }

    public double getGases() {
        return gases;
    }
    public double getViento() {
		return viento;
	}

    public double getLatitud() {
		return latitud;
	}
    public double getLongitud() {
		return longitud;
	}
}
