package AccesoDatos;

import java.sql.*;

/*
Esta clase se va a encargar de abrir y cerrar las conexiones. No siempre hay que cerrarlas, 
algunas veces da error y es porque las estamos cerrando cuando en realidad aún no se 
han abierto. 
Esta clase Conexión la creamos por orden, para manejar en esta clase la apertura y 
cierre de la conexión. En realidad podrían abrirse y cerrarse desde las otras clases, 
pero se prefiere tener todo más ordenado. 
*/

public class ClaseConexion {
    
    //ATRIBUTOS: ___________________________________________
    
    // CADENA DE CONEXIÓN: 
    private static final String connectionString = "jdbc:sqlserver://localhost:1433;databaseName=EJEMPLO2_Prueba;user=sa;password=sa;";
    //Asumimos que esa cadena de conexión nunca va a cambiar, por eso es una constante (final) y estática
    
    /*
    Todos los métodos que vamos a hacer dentro de esta clase van a ser MÉTODO ESTÁTICOS, para 
    poder utilizarlos dentro de todas las clases de Acceso a Datos sin necesidad de estar
    creando instancias de esta clase. 
    */
    
    // MÉTODOS: ______________________________________________
    
    // Método para establecer la conexión:
    // Retorna un objeto de tipo Connection 
    public static Connection getConnection() throws SQLException, ClassNotFoundException{
        
        //Class.forName("com.microsoft.sqlserver.jadb.SQLServerDriver");
        
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // forName no es necesario en versiones más recientes del JDK
        // Pero en este caso tenemos que trabajar con JDK8 porque es la última
        // versión disponible para aplicaciones empresariales (aplicaciones Web JEE),
        
        // Retorna un objeto Connection:
        return DriverManager.getConnection(connectionString);
    }
    
    /* Nota sobre throws, aunque no tengamos TRY-CATCH los métodos nos van a pedir que
        tenga la capacidad de lanzar excepciones, si borramos el throws ... al método
        anterior veremos que nos da un error y nos ofrece generar los THROWS 
        automáticamente. 
    */
    
    // Es una buena práctica crear varios métodos sobrecargados close(), 
    // que cierren diferentes objetos:
    
    public static void close(ResultSet rs) throws SQLException{
        rs.close();
    }
    
    public static void close(Statement st) throws SQLException{
        st.close();
    }
    
    public static void close(PreparedStatement pst) throws SQLException{
        pst.close();
    }
    
    public static void close(CallableStatement cst) throws SQLException{
        cst.close();
    }
    
    public static void close(Connection conexion) throws SQLException{
        conexion.close();
    }
    
    /*
    No necesariamente los vamos a ocupar todos, porque al cerrar la CONEXIÓN
    automáticamente todos los demás se liberan. Pero deberíamos ser capaces 
    de cerrarlos en orden, cerrar 
        - primero cerrar el ResultSet
        - luego el Statement (cualquiera de los 3 tipos de objeto Statement)
        - finalmente cerrar la conexión 
    */
    
            
}
