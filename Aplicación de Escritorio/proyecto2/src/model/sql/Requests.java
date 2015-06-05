
package model.sql;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Requests {

    private ResultSet rs;
    private Statement stm = null;
    private static Requests request;

    private Requests(Statement pStm) {
        this.stm = pStm;
    }

    public synchronized static Requests getInstance() {
        if (request == null) {
            request = new Requests(SQLServer.getInstance("sa", "123", "RegistroNotas", "localhost").getStm());
        }
        return request;
    }

    // Método que retorna un ArrayList con el conjunto de resultados de la ejecución de 
    // un procedimiento de la Base de Datos, el cual retorna los Miembros de un Grupo,
    // con un código de Grupo como parámetro.
    public ArrayList<String> requestviewdescrip(Integer pID) throws SQLException {
        ArrayList<String> desctiption = new ArrayList<>();
        rs = this.stm.executeQuery(String.format("dbo.APSP_ApproveRequestView '%s'", pID));
        while (rs.next()) {
            desctiption.add(rs.getString("RequestDescription"));
        }
        return desctiption;
    }

}
