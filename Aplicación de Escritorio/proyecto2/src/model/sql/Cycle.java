package model.sql;

import model.sql.SQLServer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.swing.DefaultComboBoxModel;

public class Cycle {

    private ResultSet rs;
    private Statement stm = null;
    private String UsuarioProfesor;
    private static Cycle cycle;

    private Cycle(Statement pStm) {
        this.stm = pStm;
    }

    public synchronized static Cycle getInstance() {
        if (cycle == null) {
            cycle = new Cycle(SQLServer.getInstance("sa", "123", "AgriculturalProperty", "localhost").getStm());
        }
        return cycle;
    }

    public String getUsuarioProfesor() {
        return UsuarioProfesor;
    }



    // Método que retorna un ArrayList con el conjunto de resultados de la ejecución
    // de un procedimiento de la Base de Datos, con los código de los Grupos que
    // están asociados a un Profesor, con un nombre de usuario como parámetro.
    public ArrayList<String> getCycles(String pCode) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_ViewAllCyclesStart '%s'", pCode));
        while (rs.next()) {
            grupos.add(rs.getString("StartDate"));
        }
        return grupos;
    }
    public ArrayList<String> getCycles2(String pCode) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_ViewAllCyclesEnd '%s'", pCode));
        while (rs.next()) {
            grupos.add(rs.getString("EndDate"));
        }
        return grupos;
    }
    public ArrayList<String> getCycle(String pCode) throws SQLException {
        ArrayList<String> grupos = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_ViewAllCycles'%s'", pCode));
        while (rs.next()) {
            grupos.add(rs.getString("FK_Cycle"));
        }
        return grupos;
    }
}
