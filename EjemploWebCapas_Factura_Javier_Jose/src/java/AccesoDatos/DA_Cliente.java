package AccesoDatos;

import Entidades.Cliente;

import java.sql.*; // Las clases de SQL de JDBC
import java.util.*; // para manejo de Listas 

// Si uno desea utilizar los métodos de otra clase, 
// como si fueran de esta clase:
import static AccesoDatos.ClaseConexion.getConnection;
// La conexión es una variable GLOBAL, que pueden utilizar
// En este ejemplo cada método ABRE la conexión y la CIERRA


public class DA_Cliente {

  
    // ATRIBUTOS ______________________________________
    private String _mensaje;

    // PROPIEDADES
    public String getMensaje() {
        return _mensaje;
    }

    // CONSTRUCTORES ___________________________________
    public DA_Cliente() {
        _mensaje = "";
    }

    // MÉTODOS ___________________________________________________
    // Este método va a llamar a un Procedimiento Almacenado
    public int Insertar(Cliente cliente) throws Exception {
        CallableStatement CS = null; // para llamar a un procedimiento almacenado
        int resultado = -1;
        Connection _conexion = null;

        try {
            _conexion = getConnection(); // obtenemos la Cadena de Conexión
            // con static, se usa como si fuera un método de esta clase
            CS = _conexion.prepareCall("{call GUARDAR(?,?,?,?,?)}");
            // llamanos el procedimiento almacenado

            // 1) Registrar los parámetros
            CS.setInt(1, cliente.getId_cliente());
            CS.setString(2, cliente.getNombre());
            CS.setString(3, cliente.getTelefono());
            CS.setString(4, cliente.getDireccion());
            CS.setString(5, _mensaje);

            // 2) Registrar los parámetros de SALIDA
            CS.registerOutParameter(1, Types.INTEGER);
            CS.registerOutParameter(5, Types.VARCHAR);

            // 3) Ejecutar
            resultado = CS.executeUpdate();

            // 4) Leer los parámetros de Salida
            _mensaje = CS.getString(5);
            // resultado = CS.getInt(1);
            /*  También se pudo haber hecho así.
                En cuyo caso resultado sería el IDENTITY del nuevo registro insertado
                En este ejemplo resultado la CANTIDAD de registros afectados (insertados)
                Ambas son válidas, depende de lo querramos. 
             */
             /*  Si no quisiéramos hacer los pasos 2 y 4 (registrar y leer parámetros
                de salida), podemos no hacerlo. 
                Entonces haríamos algo como lo siguiente, lo cual también sería útil
                en caso que un SP NO retorne ningún mensaje (que ya no necesariamente
                un SP tiene que retornar mensajes). 
             */
            //if(resultado > 0){
            //    _mensaje = "cliente insertado satisfactoriamente";
            //}
        } catch (Exception ex) {
            //resultado = -1; // ya está definido desde el inicio en -1
            _mensaje = "Error inesperado, intente más tarde";
            throw ex;
        } finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return resultado;
    } // método insertar 

    /*
        MÉTODO 2: Modificar _________________________________________
        Recibe: un objeto tipo CLIENTE
        Retorna: un entero (la cantidad de registros (filas) afectados)
     */
    
    // No utiliza procedimientos almacenados:
    public int Modificar(Cliente EntidadCliente) throws Exception {
        int resultado = -1;
        Connection _conexion = null;

        try {
            _conexion = ClaseConexion.getConnection();
            PreparedStatement ps = _conexion.prepareStatement("UPDATE CLIENTES SET NOMBRE=?, TELEFONO=?, DIRECCION=? WHERE ID_CLIENTE = ?");

            ps.setString(1, EntidadCliente.getNombre());
            ps.setString(2, EntidadCliente.getTelefono());
            ps.setString(3, EntidadCliente.getDireccion());
            ps.setInt(4, EntidadCliente.getId_cliente());

            resultado = ps.executeUpdate();
        } catch (Exception ex) {
            //resultado = -1;
            throw ex;
        } finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
            /*
                NOTA: en estos casos este finally en realidad no se ocupa, porque
                la conexión es una VARIABLE LOCAL dentro del método, entonces
                al finalizar el método se destruye la variable automáticamente. 
                Es decir la conexión se cierra automáticamente al cerrarse finalizar
                el método. Pero la cerramos por buenas costumbres! 
             */
        }
        return resultado;
    }//Modificar

    /*
        MÉTODO 3: Eliminar _________________________________________
        Recibe: un objeto tipo CLIENTE
        Retorna: un entero (la cantidad de registros (filas) afectados)
     */
    // Utilizando un procedimiento almacenado
    
    /*
    IMPORTANTE: En este caso el SP se encarga de verificar por ejemplo que el cliente
    que se desea eliminar NO tenga factura asociadas. Este tipo de lógica del negocio
    deberíamos programarla aquí en código Java, en caso que no tuviéramos un SP
    que verificara todo eso. Es más FÁCIL manejarlo con SP en la BD, porque desde 
    código Java tendríamos que manejar objetos de cada tabla para hacer las 
    comprobaciones, lo cual consume más tiempo de desarrollo. Aunque cada 
    persona decide cómo le parece mejor crear sus soluciones, o bien la forma 
    en que lo maneje cada empresa de desarrollo. 
    */
    
    public int Eliminar(Cliente EntidadCliente) throws Exception {
        CallableStatement cs = null;//Se usa CallableStatement porque estoy "llamando" a un procedimiento almacenado
        int resultado = -1;
        Connection _conexion = null;

        try {
            _conexion = ClaseConexion.getConnection();

            cs = _conexion.prepareCall("{call Eliminar(?,?)}");

            // 1) Registrar los parámetros
            cs.setInt(1, EntidadCliente.getId_cliente());
            cs.setString(2, _mensaje);

            // 2) Registrar los parámetros de SALIDA
            cs.registerOutParameter(2, Types.VARCHAR);

            // 3) Ejecutar
            resultado = cs.executeUpdate();

            // 4) Leer los parámetros de Salida
            _mensaje = cs.getString(2);

//            if(resultado>0){
//                _Mensaje="Cliente Insertado con éxito";
//            }
            /*
        En este caso el _mensaje preferimos RECUPERARLO directamente del SP de la BD
        porque podría ser que indique que no se puede eliminar el cliente porque
|       tiene facturas asociadas, u otro mensaje de la BD. 
             */
        }//try
        catch (Exception ex) {
            //resultado = -1;
            throw ex;
        } finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return resultado;
    }//Eliminar

    /*
        MÉTODO 4: Listar Registros
        Recibe: condición (String), orden (String)
        Retorna: un RESULTSET
    */
    
    /*
    NOTA IMPORTANTE:
    En C# utilizábamos un DataSet que es un objeto SIN CONEXIÓN, podíamos llenar el 
    DataSet, cerrar la conexión y seguir trabajando con el contenido del DataSet.
    
    Aquí no! porque el ResultSet es un objeto CON CONEXIÓN, si se cierra la conexión
    no podremos utilizar los datos del ResultSet. 
    Eso puede generar problemas, por ello se creó este método que retorna un ResultSet
    como ejemplo didáctico.
    Pero el que en realidad vamos a utilizar el es método ListarRegistros que retorna 
    una LISTA. 
    */
    
    
    public ResultSet ListarRegistros(String Condicion, String Orden) throws Exception {
        // Orden es el tipo de ordenamiento que se va a utilizar en la consulta por ejemplo ORDER BY NOMBRE
       
        ResultSet rs = null;
        Connection _conexion = null;
        try {
            _conexion = ClaseConexion.getConnection();
            Statement st = _conexion.createStatement();
            String sentencia;

            sentencia = "SELECT ID_CLIENTE,NOMBRE,TELEFONO,DIRECCION FROM CLIENTES";
            if (!Condicion.equals("")) {
                sentencia = String.format("%s WHERE %s", sentencia, Condicion);
            }
            if (!Orden.equals("")) {
                sentencia = String.format("%s ORDER BY %s", sentencia, Orden);
            }
            rs =st.executeQuery(sentencia);
        } catch (Exception ex) {
            throw ex;
        }
        
        /*
            No cerramos la conexión porque entonces no podríamos utilizar el 
            ResultSet que está devolviendo el método. 
            Ya que el ResultSet necesita que esté abierta la conexión
        */
        
        return rs;
    }

    /*
        MÉTODO 5: Listar Registros
        Recibe: condición (String)
        Retorna: un LISTA de objetos cliente
     */
    public List<Cliente> ListarRegistros(String Condicion) throws Exception {
        ResultSet rs = null;
        Cliente cliente;
        List<Cliente> lista = new ArrayList<>();
        Connection _conexion = null;
        try {
            // Abrir la conexión:
            _conexion = ClaseConexion.getConnection();
            
            Statement st = _conexion.createStatement();
            String Sentencia;

            Sentencia = "SELECT ID_CLIENTE,NOMBRE,TELEFONO,DIRECCION FROM CLIENTES";
            
            if (!Condicion.equals("")) {
                Sentencia = String.format("%s WHERE %s", Sentencia, Condicion);
            }

            rs = st.executeQuery(Sentencia);
            
            // Recorremos el ResultSet agregando cada Registro a la Lista
            while (rs.next()) {
                cliente = new Cliente(rs.getInt(1), rs.getString(2), rs.getString(4), rs.getString(3));
                lista.add(cliente);
            }
        } 
        catch (Exception ex) {
            throw ex;
        } 
        finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return lista;
    }

    /*
        MÉTODO 6: Obtener registro _____________________
        Recibe: condición (String)
        Retorna: un objeto CLIENTE
     */
    public Cliente ObtenerRegistro(String Condicion) throws Exception {
        // La idea es que la Condición que ingresa permita conseguir un registro único y no varios!
        // Por tanto al llamar a este método debemos garantizar que SIEMPRE le enviemos en la condición
        // el ID de un cliente. 
        
        ResultSet rs = null;
        Cliente cliente = new Cliente();
        String sentencia;
        Connection _conexion = null;
        try {
            _conexion = ClaseConexion.getConnection();
            Statement st = _conexion.createStatement();

            sentencia = "SELECT ID_CLIENTE,NOMBRE,DIRECCION,TELEFONO FROM CLIENTES";
            if (!Condicion.equals("")) {
                sentencia = String.format("%s WHERE %s", sentencia, Condicion);
            }
            rs = st.executeQuery(sentencia);

            // Con If y no While, por si esta consulta hubiera retornado varios registros, 
            // lee solamene uno (el primero).
            // En teoría eso nunca va a pasar si en la condición el método recibe el ID de un cliente
            if (rs.next()) {
                cliente.setId_cliente(rs.getInt(1));
                cliente.setNombre(rs.getString(2));
                cliente.setDireccion(rs.getString(3));
                cliente.setTelefono(rs.getString(4));
                cliente.setExiste(true);
            } else {
                cliente.setExiste(false);
            }
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return cliente;
    }

} // clase
