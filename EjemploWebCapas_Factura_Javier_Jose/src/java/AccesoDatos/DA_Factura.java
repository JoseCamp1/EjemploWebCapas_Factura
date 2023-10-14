package AccesoDatos;

import Entidades.DetalleFactura;
import Entidades.Factura;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class DA_Factura {

    //atributos
    private String _Mensaje;

    public DA_Factura(String _message) {
        this._Mensaje = _message;
    }

    public String getMessage() {
        return _Mensaje;
    }

    public void setMessage(String _message) {
        this._Mensaje = _message;
    }

    //metodo para listar facturas
    public List<Factura> ListarRegistros(String condition) throws Exception {
        ResultSet RS = null;
        Factura factura;
        List<Factura> ListaF = new ArrayList<>();
        Connection _conection = null;
        try {
            _conection = ClaseConexion.getConnection();
            Statement ST = _conection.createStatement();
            String sentencia = "SELECT NUM_FACTURA, F.ID_CLIENTE, NOMBRE, FECHA, ESTADO FROM FACTURA F "
                    + "INNER JOIN CLIENTES ON CLIENTES.ID_CLIENTE = F.ID_CLIENTE";

            if (!condition.equals("")) {
                sentencia = String.format("%s WHERE %S", sentencia, condition);
            }
            RS = ST.executeQuery(sentencia);
            while (RS.next()) {
                factura = new Factura(RS.getInt("NUM_FACTURA"),
                        RS.getInt("Id_Cliente"),
                        RS.getString("Nombre"),
                        RS.getDate("Fecha"),
                        RS.getString("Estado"));
                ListaF.add(factura);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (_conection != null) {
                ClaseConexion.close(_conection);
            }
        }

        return ListaF;
    }

    public Factura ObtenerRegistro(String condicion) throws Exception {
        ResultSet RS = null;
        Factura Entidad = new Factura();
        String Sentencia;
        Connection _Conexion = null;
        Sentencia = "SELECT NUM_FACTURA,F.ID_CLIENTE,NOMBRE,FECHA,ESTADO "
                + "FROM FACTURA F INNER JOIN CLIENTES "
                + "ON CLIENTES.ID_CLIENTE=F.ID_CLIENTE";

        if (!condicion.equals("")) {
            Sentencia = String.format("%S WHERE %S", Sentencia, condicion);
        }
        try {
            _Conexion = ClaseConexion.getConnection();
            Statement ST = _Conexion.createStatement();
            RS = ST.executeQuery(Sentencia);
            if (RS.next()) {
                Entidad.setIdFactura(RS.getInt("NUM_FACTURA"));
                Entidad.setIdCliente(RS.getInt("Id_Cliente"));
                Entidad.setNombreCliente(RS.getString("Nombre"));
                Entidad.setFecha(RS.getDate("Fecha"));
                Entidad.setEstado(RS.getString("Estado"));
                Entidad.setExisteRegistro(false);
            } else {
                Entidad.setExisteRegistro(false);
            }
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (_Conexion != null) {
                ClaseConexion.close(_Conexion);
            }
        }
        return Entidad;
    }

    public int Insertar(Factura entidadFactura, DetalleFactura entidaDetalle) throws Exception {
        CallableStatement CS;
        int resutado = 0;
        int idFactura = 0;
        Connection _Conexion = null;
        try {
            _Conexion = ClaseConexion.getConnection();
            //por defecto el objeto connection trabaja las transacciones con confirmacion automatica
            //pero en este ejemplo deseamos realizar varias transacciones y que todas se manejan como si fuera una sola
            _Conexion.setAutoCommit(false);//en true hace commit cada vez que se ejecute un comando,
            //en false - todas las operaciones de aque en adelante se manejan como una 
            // para garantizar que se hagan todas las operaciones en una sola transaccion
            CS = _Conexion.prepareCall("{call Guardar_Factura(?,?,?,?,?)}");
            CS.setInt(1, entidadFactura.getIdFactura());
            CS.setInt(2, entidadFactura.getIdCliente());
            CS.setDate(3, entidadFactura.getFecha());
            CS.setString(4, entidadFactura.getEstado());
            CS.setString(5, _Mensaje);
            CS.registerOutParameter(1, Types.INTEGER);//se obtiene el id de factura
            resutado = CS.executeUpdate();
            idFactura = CS.getInt(1);
            CS = _Conexion.prepareCall("{call Guardar_Detalle(?,?,?,?,?)}");
            CS.setInt(1, idFactura);// llama a la variable que acabamos de declarar
            CS.setInt(2, entidaDetalle.getIdProducto());
            CS.setInt(3, entidaDetalle.getCantidad());
            CS.setDouble(4, (double) entidaDetalle.getPrecio());
            CS.setString(5, _Mensaje);
            // registrar mensaje para salida 
            CS.registerOutParameter(5, Types.VARCHAR);
            resutado = CS.executeUpdate();
            //se recibe del sp
            _Mensaje = CS.getString(5);
            _Conexion.commit();//todo esta bien            
        } catch (ClassNotFoundException | SQLException ex) {
            _Conexion.rollback();// si algo salio mal se deshacen todas transacciones 
            throw ex;
        } finally {
            if (_Conexion != null) {
                ClaseConexion.close(_Conexion);
            }
        }
        return idFactura;
    }//fin de insertar

    public int ModificarCliente(Factura EntidadFactura) throws Exception {
        int idfactura = 0;
        Connection _Conexion = null;
        try {
            _Conexion = ClaseConexion.getConnection();
            PreparedStatement PS = _Conexion.prepareStatement("UPDATE FACTURA SET ID_CLIENTE = ? WHERE NUM_FACTURA = ?");
            PS.setInt(1, EntidadFactura.getIdCliente());
            PS.setInt(2, EntidadFactura.getIdFactura());
            PS.executeUpdate();
            idfactura = EntidadFactura.getIdFactura();//este devuelve el ID FACTURA             
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (_Conexion != null) {
                ClaseConexion.close(_Conexion);
            }
        }
        return idfactura;
    }
    
    public int ModificarEstado(Factura EntidadFactura) throws Exception {
        int resultado = 0;
        Connection _conexion = null;
        try {
            _conexion = ClaseConexion.getConnection();
            PreparedStatement PS = _conexion.prepareStatement("update Factura set ID_ESTADO = ? where NUM_FACTURA = ?");
            PS.setString(1,EntidadFactura.getEstado());
            PS.setInt(2,EntidadFactura.getIdFactura());
            
            resultado = PS.executeUpdate();
          
        } catch (Exception e) {
        throw e;
        }finally {
            if (_conexion != null) {
                ClaseConexion.close(_conexion);
            }
        }
        return resultado;
    }
    
    
}
