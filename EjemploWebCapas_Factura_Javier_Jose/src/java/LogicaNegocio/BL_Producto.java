package LogicaNegocio;

import AccesoDatos.DA_Productos;
import Entidades.Producto;
import java.sql.ResultSet;
import java.util.List;

/**
 *
 * @author dcruz
 */
public class BL_Producto {
    private String _Mensaje;

    public String getMensaje() {
        return _Mensaje;
    }
    
    public int Insertar(Producto Entidad) throws Exception{
            int Resultado= 0;

            try{
                
                DA_Productos DA = new DA_Productos();

                Resultado = DA.Insertar(Entidad);
                

            }catch(Exception ex){
                Resultado=-1;
                throw ex;
            }

            return Resultado;
    }

    public int Modificar(Producto Entidad) throws Exception{
        int Resultado= 0;
        
        try{

            DA_Productos DA = new DA_Productos();

            Resultado = DA.Modificar(Entidad);
            

        }catch(Exception ex){
            Resultado=-1;
            throw ex;
        }

        return Resultado;
    }
    
    public int Eliminar(Producto Entidad) throws Exception {
        int Resultado= 0;
       
        try{

            DA_Productos DA = new DA_Productos();

            Resultado = DA.Eliminar(Entidad);
            _Mensaje = DA.getMensaje();
          

        }catch(Exception ex){
            Resultado=-1;
            throw ex;
        }

        return Resultado;
    }

    public ResultSet ListarRegistros(String condicion, String orden) throws Exception{
        ResultSet RS;
       
        try{
            
            DA_Productos DA = new DA_Productos();

            RS = DA.ListarRegistros(condicion, orden);
            

        }catch (Exception ex){
            RS=null;
            throw ex;
        }

        return RS;
    }

    public List<Producto> ListarRegistros(String condicion) throws Exception{
        List<Producto> Datos;
       
        try{
            
            DA_Productos DA = new DA_Productos();

            Datos = DA.ListarRegistros(condicion);
            

        }catch (Exception ex){
            Datos=null;
            throw ex;
        }

        return Datos;
    }
    
    public Producto ObtenerRegistro(String condicion) throws Exception{
        Producto Entidad=null;
        
        try{
            
            DA_Productos DA = new DA_Productos();

            Entidad = DA.ObtenerRegistro(condicion);
            

        }catch (Exception ex){
            throw ex;
        }

        return Entidad;
    }
}
