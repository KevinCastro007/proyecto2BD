
package model.sql;

import model.sql.SQLServer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.swing.DefaultComboBoxModel;

public class Lot {

    private ResultSet rs;
    private Statement stm = null;
    private String UsuarioProfesor;
    private static Lot lot;

    private Lot(Statement pStm) {
        this.stm = pStm;
    }

    public synchronized static Lot getInstance() {
        if (lot == null) {
            lot = new Lot(SQLServer.getInstance("sa", "123", "AgriculturalProperty", "localhost").getStm());
        }
        return lot;
    }

    public String getUsuarioProfesor() {
        return UsuarioProfesor;
    }

    // Método que retorna un ArrayList con el conjunto de resultados de la ejecución
    // de un procedimiento de la Base de Datos, con los código de los Grupos que
    // están asociados a un Profesor, con un nombre de usuario como parámetro.
    public ArrayList<String> getLots(String pProp) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_Lotsname '%s'", pProp));
        while (rs.next()) {
            grupos.add(rs.getString("Code"));
        }
        return grupos;
    }
    
    
    public ArrayList<String> getProps() throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_Propertiesname"));
        while (rs.next()) {
            grupos.add(rs.getString("Name"));
        }
        return grupos;
    }

}



