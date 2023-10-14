package LogicaNegocio;

import AccesoDatos.DA_Cliente;
import Entidades.Cliente;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BL_Cliente {

    // ATRIBUTOS __________________________
    private String _mensaje;

    // PROPIEDADES ________________________
    public String getMensaje() {
        return _mensaje;
    }

    // CONSTRUCTOR
    public BL_Cliente() {
        _mensaje = "";
    }

    /*
        MÉTODO 1: Insertar un registro en la base de datos
        Recibe: un objeto tipo CLIENTE
        Retorna: un entero (la cantidad de registros afectacos)
     */
    public int Insertar(Cliente cliente) throws Exception {
        int resultado = 0;
        // Llamar a la capa de acceso a datos:
        DA_Cliente accesoDatos = new DA_Cliente();
        
        try {
            resultado = accesoDatos.Insertar(cliente);
            _mensaje = accesoDatos.getMensaje();
        } catch (Exception e) {
            throw e;
        }
        return resultado;
    }

    /*
        MÉTODO 2: Modificar _________________________________________
        Recibe: un objeto tipo CLIENTE
        Retorna: un entero (la cantidad de registros (filas) afectados)
     */
    public int Modificar(Cliente cliente) throws Exception {
        int resultado = 0;
        DA_Cliente accesoDatos  = new DA_Cliente();
        
        try {
            resultado = accesoDatos.Modificar(cliente);
            _mensaje = accesoDatos.getMensaje();
        } catch (Exception e) {
            throw e;
        }
        return resultado;
    }

    /*
        MÉTODO 3: Eliminar _________________________________________
        Recibe: un objeto tipo CLIENTE
        Retorna: un entero (la cantidad de registros (filas) afectados)
     */
    public int Eliminar(Cliente cliente) throws Exception {
        int resultado = 0;
        DA_Cliente accesoDatos  = new DA_Cliente();
        
        try {
            resultado = accesoDatos.Eliminar(cliente);
            _mensaje = accesoDatos.getMensaje();
        } catch (Exception e) {
            throw e;
        }
        return resultado;
    }

    /*
        MÉTODO 4: Listar Registros
        Recibe: condición (String), orden (String)
        Retorna: un RESULTSET
     */
    
    public ResultSet ListarRegistros(String condicion, String orden) throws Exception{
    ResultSet resultado;
    DA_Cliente accesoDatos  = new DA_Cliente();
    
        try {
            resultado = accesoDatos.ListarRegistros(condicion, orden);
        } 
        catch (Exception e) {
            throw e;
        }
        return resultado;
    }
    
    /*
        MÉTODO 5: Listar Registros
        Recibe: condición (String)
        Retorna: un LISTA de objetos cliente
     */
    
    public List<Cliente> ListarRegistros(String condicion) throws Exception{
        List<Cliente> resultado = new ArrayList();
        DA_Cliente accesoDatos  = new DA_Cliente();
        
        try {
            resultado = accesoDatos.ListarRegistros(condicion);
        } 
        catch (Exception e) {
            throw e;
        }
        return resultado;
    }
    
    /*
        MÉTODO 6: Obtener registro _____________________
        Recibe: condición (String)
        Retorna: un objeto CLIENTE
    */
    
    public Cliente ObtenerRegistro(String condicion) throws Exception{
        Cliente cliente;
        DA_Cliente accesoDatos  = new DA_Cliente();;
        
        try {
            cliente = accesoDatos.ObtenerRegistro(condicion);
            
            if(cliente.isExiste()){
                _mensaje = "Cliente recuperado satisfactoriamente";
            }
            else {
                _mensaje = "El cliente no existe";
            }
            
        } catch (Exception e) {
            throw e;
        }
        
        return cliente;
    }
    
} // clase
