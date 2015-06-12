
package model.sql;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.sql.SQLServer;

public class LotXCycle {
    
    private ResultSet rs;
    private Statement stm = null;
    private static LotXCycle LotxCycl;   

    private LotXCycle(Statement pStm) {
        this.stm = pStm;
    }

    public synchronized static LotXCycle getInstance() {
        if (LotxCycl == null) {
            LotxCycl = new LotXCycle(SQLServer.getInstance("sa", "123", "AgriculturalProperty", "localhost").getStm());
        }
        return LotxCycl;
    }

    // Método para insertar una Instancia de Evaluación, de una Evaluación especificada de Grupo determinado, haciendo 
    // uso de un procedimiento almacenado de la Base de Datos, el cual inserta la Instancia con toda la información requerida.
     public void approveRequest(String pOldDesc, Float prealAmount,String pRealDesc) throws SQLException {
         ArrayList<String> grupos = new ArrayList<>();
        try{
            this.stm.executeQuery(String.format("dbo.APSP_ApproveRequest '%s', '%s', '%s'", pOldDesc, prealAmount, pRealDesc)); 
        }catch (SQLException ex) {
            System.out.println(" ");
        }
    }   
     
     public void modifyRequest(String pOldDesc,String pModDesc,String pModType ,Float pModAmount) throws SQLException {
         ArrayList<String> grupos = new ArrayList<>();
        try{
            this.stm.executeQuery(String.format("dbo.APSP_ModifyRequest '%s', '%s', '%s','%s'", pOldDesc, pModDesc,pModType, pModAmount)); 
        }catch (SQLException ex) {
            System.out.println(" ");
        }
    }   
    
    public ArrayList<String> getDescription(String pLot, String pCycle) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_RequestDescription '%s', '%s'", pLot,pCycle));
        while (rs.next()) {
            grupos.add(rs.getString("RequestDescription"));
        }
        return grupos;
    } 
    
    public ArrayList<String> getActivityType(Integer pActivity) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_ActivityType '%s'", pActivity));
        while (rs.next()) {
            grupos.add(rs.getString("Name"));
        }
        return grupos;
    }  
    
    public ArrayList<String> getRequestName(String pDescription) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_RequestNames '%s'", pDescription));
        while (rs.next()) {
            grupos.add(rs.getString("Name"));
        }
        return grupos;
    }  
    
   public boolean validateapprove(String pOldDesc, Float prealAmount,String pRealDesc) throws SQLException {
        rs = this.stm.executeQuery(String.format("SELECT Result = dbo.APFN_ApproveRequestVerify('%s', '%s', '%s')", pOldDesc, prealAmount, pRealDesc));
        String result = "";
        while (rs.next()) {
            result = (rs.getString("Result"));
        }
        return (!result.equals("0"));
    }
   
   public boolean validatemodify(String pOldDesc,String pModDesc,String pModType ,Float pModAmount) throws SQLException {
        rs = this.stm.executeQuery(String.format("SELECT Result = dbo.APFN_ModifyValidate('%s', '%s', '%s', '%s')", pOldDesc, pModDesc,pModType, pModAmount));
        String result = "";
        while (rs.next()) {
            result = (rs.getString("Result"));
        }
        return (!result.equals("0"));
    }

    

        // Método que retorna un valor booleano según el resultado de ejecución de un función
    // de la Base de Datos, donde se indentifica un Profesor, con un nombre de usuario
    // y una clave como parámetros.
    public boolean validate(String pLot, String pCycle) throws SQLException {
        rs = this.stm.executeQuery(String.format("SELECT Result = "
                + "dbo.APFN_LotXCycle('%s', '%s')", pLot, pCycle));
        String result = "";
        while (rs.next()) {
            result = (rs.getString("Result"));
        }
        return (!result.equals("0"));
    }
}
