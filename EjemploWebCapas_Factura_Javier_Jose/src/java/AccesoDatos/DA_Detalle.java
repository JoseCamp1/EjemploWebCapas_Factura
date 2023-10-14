package AccesoDatos;

import Entidades.DetalleFactura;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;




public class DA_Detalle {
    //atributos
    private String _Mensaje;
    //propiedades
    public String getMensaje(){
        return _Mensaje;
    }
    
    //constructor vacio
    public DA_Detalle(){
        _Mensaje="";
    }
    //metodos
   public List<DetalleFactura> ListarRegistros(String condition) throws Exception {
        ResultSet RS = null;
        DetalleFactura Entidad;
        List<DetalleFactura> lista = new ArrayList<>();
        Connection _conection = null;
        try {
            _conection = ClaseConexion.getConnection();
            Statement ST = _conection.createStatement();
            String sentencia = "SELECT NUM_FACTURA, DETALLE_FACTURA.ID_PRODUCTO,DESCRIPCION,CANTIDAD,PRECIO_VENTA "
                    +"FROM DETALLE_FACTURA "
                    + "INNER JOIN PRODUCTOS ON DETALLE_FACTURA.ID_PRODUCTO = PRODUCTOS.ID_PRODUCTO";
            
            if (!condition.equals("")) {
                sentencia = String.format("%S WHERE %S", sentencia, condition);
            }
            RS = ST.executeQuery(sentencia);
            while (RS.next()) {
                Entidad = new DetalleFactura(RS.getInt("NUM_FACTURA"),
                        RS.getInt("ID_PRODUCTO"),
                        RS.getString("DESCRIPCION"),
                        RS.getInt("CANTIDAD"),
                        RS.getInt("PRECIO_VENTA"));
                lista.add(Entidad);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (_conection != null) {
                ClaseConexion.close(_conection);
            }
        }
        
        return lista;
    } 
   
   public int Eliminar(DetalleFactura Entidad) throws Exception {
        CallableStatement CS = null;
        int resultado = 0;
        Connection _conexion = null;
        try {
            _conexion = ClaseConexion.getConnection();
            CS = _conexion.prepareCall("{call Eliminar_Detalle(?,?,?)}");

            CS.setInt(1, Entidad.getIdFactura());
            CS.setInt(2, Entidad.getIdProducto());
            CS.setString(3, _Mensaje);
            resultado = CS.executeUpdate();
        } catch (Exception e) {
            throw e;
        }finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return resultado;
    }
    
    
}//fin
