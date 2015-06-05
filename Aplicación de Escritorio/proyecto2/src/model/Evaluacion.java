/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.util.ArrayList;

/**
 *
 * @author usuario
 */
public class Evaluacion {
    private final String tipoEvaluacion;
    private float porcentaje;
    private int cantidadInstancia;
    private final String tipoInstancia;
    private ArrayList<InstanciaEvaluacion> instancias;
            
    public Evaluacion(String tipoEvaluacion, float porcentaje, String tipoInstancia) {
        this.tipoEvaluacion = tipoEvaluacion;
        this.porcentaje = porcentaje;
        this.tipoInstancia = tipoInstancia;
        this.cantidadInstancia = 0;
    }
    
    public float getPorcentaje() {
        return this.porcentaje;
    }    
    
    public void setPorcentaje(float porcentaje) {
        this.porcentaje = porcentaje;
    }
    
    public String getTipoEvaluacion() {
        return this.tipoEvaluacion;
    }     
    
    public int getCantidadInstancia() {
        return this.cantidadInstancia;
    }    
    
    public String getTipoInstancia() {
        return this.tipoInstancia;
    }      
    
    public void agregarInstancia(InstanciaEvaluacion instancia) {
        this.instancias.add(instancia);
        this.cantidadInstancia++;
    }

    public void agregarInstancias(ArrayList<InstanciaEvaluacion> instancias) {
        this.instancias = instancias;
        this.cantidadInstancia = instancias.size();
    }    
    
    public ArrayList<InstanciaEvaluacion> getInstancias() {
        return this.instancias;
    }
    
    public boolean evaluarInstancias() {
        float total = 0;
        for (InstanciaEvaluacion instancia : this.instancias) {
            total += instancia.getValor();
            if (total > 100) {
                return false;
            }
        }       
        return true;
    }
}


