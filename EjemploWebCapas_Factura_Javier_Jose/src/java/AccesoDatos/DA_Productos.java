package AccesoDatos;


import Entidades.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author dcruz
 */
public class DA_Productos {
    //"Atributos"
        private String _Mensaje="";
    //*******************************************

    public String getMensaje() {
        return _Mensaje;
    }

    
        
    //"Constructores"
        public DA_Productos() {
            _Mensaje="";
        }
    //*******************************************

    //"Metodos"
        public int Insertar(Producto EntidadProducto) throws Exception{
            ResultSet RS=null;
            CallableStatement CS=null;
            int resultado = 0;
            Connection _Conexion=null;
            
            try{
                _Conexion=ClaseConexion.getConnection();
                CS=_Conexion.prepareCall("{call Guardar_Producto(?,?,?,?,?)}");

                CS.setInt(1, EntidadProducto.getIdProducto());
                CS.setString(2, EntidadProducto.getDescripcion());
                CS.setDouble(3, EntidadProducto.getPrecio());
                CS.setDouble(4, EntidadProducto.getExistencia());
                
                CS.setString(5, _Mensaje);
           
                resultado = CS.executeUpdate();
                
            }catch (Exception ex){
                resultado=-1;
                throw ex;
            }finally{
                if (_Conexion != null) ClaseConexion.close(_Conexion);
            }
            return resultado;
        }//fin de insertar

        public int Modificar(Producto EntidadProducto) throws Exception{
            CallableStatement CS=null;
            int resultado = 0;
            Connection _Conexion=null;
            try{
                _Conexion=ClaseConexion.getConnection();
                CS=_Conexion.prepareCall("{call Modificar_Producto(?,?,?,?)}");
              
                CS.setInt(1, EntidadProducto.getIdProducto());
                CS.setString(2, EntidadProducto.getDescripcion());
                CS.setDouble(3, EntidadProducto.getPrecio());
               
                CS.setString(4, _Mensaje);
                
                resultado = CS.executeUpdate();

                
            }catch (Exception ex){
                resultado=-1;
                throw ex;
                
            }finally{
                if (_Conexion != null) ClaseConexion.close(_Conexion);
            }
            return resultado;
        }//fin de modificar

        public int Eliminar(Producto EntidadProducto) throws Exception {
            CallableStatement CS=null;
            int resultado = 0;
            Connection _Conexion=null;
            try{
                _Conexion=ClaseConexion.getConnection();
                CS=_Conexion.prepareCall("{call Eliminar_Producto(?,?)}");
                             
                CS.setInt(1, EntidadProducto.getIdProducto());
                CS.setString(2, _Mensaje);
                CS.registerOutParameter(2, Types.VARCHAR);
                resultado = CS.executeUpdate();

                _Mensaje=CS.getString(2);
                
            }catch (Exception ex){
                resultado=-1;
                throw  ex;
            }finally{
                if (_Conexion != null) ClaseConexion.close(_Conexion);
            }
            return resultado;
        }//fin de eliminar

        public ResultSet ListarRegistros(String condicion, String orden) throws SQLException, Exception{
            ResultSet RS=null;
            String Sentencia;
            Sentencia = "SELECT ID_PRODUCTO,DESCRIPCION,PRECIO EXISTENCIA FROM PRODUCTOS";

            if (!condicion.equals("")) {
                Sentencia = String.format("%s WHERE %s", Sentencia, condicion);
            }

            if(!orden.equals("")) {
                Sentencia = String.format("%s ORDER BY %s", Sentencia, orden);
            }

            try{
                Connection _Conexion=ClaseConexion.getConnection();
                Statement ST = _Conexion.createStatement();
                RS=ST.executeQuery(Sentencia);
                
            }catch(Exception ex){
                throw ex;
            }
            return RS;
        }

        public List<Producto> ListarRegistros(String Condicion) throws Exception{
            ResultSet RS=null;
            Producto Entidad;
            List<Producto> lista=new ArrayList<>();
            Connection _Conexion=null;
            try{
                _Conexion=ClaseConexion.getConnection(); 
                Statement ST = _Conexion.createStatement();
                String Sentencia;

                Sentencia = "SELECT ID_PRODUCTO,DESCRIPCION,PRECIO,EXISTENCIA FROM PRODUCTOS";
                if (!Condicion.equals("")) {
                    Sentencia = String.format("%s WHERE %s", Sentencia, Condicion);
                }

                RS=ST.executeQuery(Sentencia);
                while(RS.next()){
                    Entidad=new Producto(RS.getInt(1), RS.getString(2), RS.getDouble(3), RS.getDouble(4));
                    lista.add(Entidad);
                }
            }catch(Exception ex){
                throw ex;
            }finally{
                if (_Conexion != null) ClaseConexion.close(_Conexion);
            }
            return lista;
        }
        
        public Producto ObtenerRegistro(String condicion) throws SQLException, Exception {
            ResultSet RS=null;
            Producto EntidadProducto=new Producto();
            String vlc_Sentencia;
            Connection _Conexion=null;
            vlc_Sentencia = "SELECT ID_PRODUCTO,DESCRIPCION,PRECIO, EXISTENCIA FROM PRODUCTOS";

            if (!condicion.equals("")) {
                vlc_Sentencia = String.format("%s WHERE %s", vlc_Sentencia, condicion);
            }

            try{
                _Conexion=ClaseConexion.getConnection();
                Statement ST = _Conexion.createStatement();
                RS=ST.executeQuery(vlc_Sentencia);
                if(RS.next()){
                    EntidadProducto.setIdProducto(RS.getInt(1));
                    EntidadProducto.setDescripcion(RS.getString(2));
                    EntidadProducto.setPrecio(RS.getDouble(3));
                    EntidadProducto.setExistencia(RS.getDouble(4));
                    
                    EntidadProducto.setExisteRegistro(true);
                    
                }else{
                    EntidadProducto.setExisteRegistro(false);
                    
                }
                   
            }catch(Exception ex){
                throw ex;
            }finally{
                if (_Conexion != null) ClaseConexion.close(_Conexion);
            }
            return EntidadProducto;
        }
        
}
