/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/**
 *
 * @author KEDAC
 */
public class InstanciaEvaluacion {
    private String descripcion;
    private String fecha;
    private float valor;
    private float nota;    
    
    public InstanciaEvaluacion(float valor, String descripcion, String fecha) {
        this.valor = valor;
        this.descripcion = descripcion;
        this.fecha = fecha;
    }
    
    public InstanciaEvaluacion(float valor, String descripcion, float nota, String fecha) {
        this.fecha = fecha;        
        this.valor = valor;
        this.descripcion = descripcion;
        this.nota = nota;
    }    
    
    public InstanciaEvaluacion(String descripcion, String fecha, float nota) {
        this.fecha = fecha;
        this.descripcion = descripcion;
        this.nota = nota;
    }        
    
    public float getValor() {
        return this.valor;
    }
    
    public void setValor(float valor) {
        this.valor = valor;
    }  
    
    public float getNota() {
        return this.nota;
    }
    
    public void setNota(float nota) {
        this.nota = nota;
    }        

    public String getDescripcion() {
        return this.descripcion;
    }
    
    public String getFecha() {
        return this.fecha;
    }    
}
