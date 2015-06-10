
package model.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

// Clase donde se implementa la librería JDBC para la conexión con MSSQL - Patrón Singleton -
public class SQLServer {

    // Variables para la configuración de la conexión.
    private final String user;
    private final String password;
    private final String db;
    private final String host;
    private String url;
    private Connection conn = null;
    private Statement stm = null;
    private ResultSet rs;

    private static SQLServer conexion;

    // Constructor
    private SQLServer(String pUser, String pPassword, String pDb, String pHost) {
        this.user = pUser;
        this.password = pPassword;
        this.db = pDb;
        this.host = pHost;
        this.url = "jdbc:sqlserver://" + this.host + ";databaseName=" + this.db;
    }

    public synchronized static SQLServer getInstance(String pUser, String pPassword, String pDb, String pHost) {
        if (conexion == null) {
            conexion = new SQLServer(pUser, pPassword, pDb, pHost);
            conexion.conectar();
        }
        return conexion;
    }

    public Statement getStm() {
        return stm;
    }

    // Método para conectar a MSSQL con la configuración especificada.
    public Statement conectar() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, user, password);
            if (conn != null) {
                System.out.println("Conexión efecitva a la BD: " + url);
                stm = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            }
        } catch (SQLException ex) {
            System.out.println("Hubo un problema al intentar conectarse con la base de datos " + url);
            System.out.println(ex);
        } catch (ClassNotFoundException ex) {
            System.out.println(ex);
        }
        return stm;
    }
}
