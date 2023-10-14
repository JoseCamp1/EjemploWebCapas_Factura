package LogicaNegocio;

import AccesoDatos.DA_Factura;
import Entidades.DetalleFactura;
import Entidades.Factura;
import java.util.List;

public class BL_Factura {

    private String _Mensaje;

    public String getMensaje() {
        return _Mensaje;
    }

    public List<Factura> ListarRegistros(String condition) throws Exception {
        List<Factura> Datos;
        try {
            DA_Factura DA = new DA_Factura(_Mensaje);
            Datos = DA.ListarRegistros(condition);
        } catch (Exception e) {
            Datos = null;
            throw e;
        }
        return Datos;
    }
    
    public Factura ObtenerRegistro(String condicion) throws Exception{
        Factura Entidad = null;
        try {
            
            DA_Factura DA = new DA_Factura(_Mensaje);
            
            Entidad = DA.ObtenerRegistro(condicion);
            
        } catch (Exception ex) {
            throw ex;
        }
        return Entidad;
    }
    
    public int Insertar(Factura Entidad,DetalleFactura EntidadDetalle)throws Exception{
        int Resultado = 0;
        try {
            DA_Factura DA = new DA_Factura(_Mensaje);
            Resultado = DA.Insertar(Entidad, EntidadDetalle);
            _Mensaje=DA.getMessage();
            
        } catch (Exception ex) {
            Resultado = -1;
            throw ex;
        }
        return Resultado;
    }
    
    public int ModificarCliente(Factura Entidad)throws Exception{
        int idfactura = 0;
        try {
            DA_Factura DA = new DA_Factura(_Mensaje);
            idfactura = DA.ModificarCliente(Entidad);            
        } catch (Exception ex) {
             throw ex;
        }
        return idfactura;
    }//fin
    
public int ModificarEstado(Factura Entidad) throws Exception {
        int resultado = 0;
        try {
            DA_Factura DA = new DA_Factura(_Mensaje);
            resultado = DA.ModificarEstado(Entidad);

        } catch (Exception e) {
            throw e;
        }

        return resultado;
    }
    
}
