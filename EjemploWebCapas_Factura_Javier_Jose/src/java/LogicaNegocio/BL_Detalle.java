package LogicaNegocio;

import AccesoDatos.DA_Detalle;
import Entidades.DetalleFactura;
import java.util.List;

public class BL_Detalle {
    
    private String _message;

    public String getMessage() {
        return _message;
    }
    
    public List<DetalleFactura> ListarRegistros(String condition) throws Exception {
        List<DetalleFactura> Datos;
        try {
            DA_Detalle DA  = new DA_Detalle();
            Datos = DA.ListarRegistros(condition);
        } catch (Exception e) {
            Datos = null;
            throw e;
        }
        return Datos;
    }
    
    public int Eliminar(DetalleFactura Entidad) throws Exception {
        int resultado = 0;
        try {
            DA_Detalle DA = new DA_Detalle();
            resultado = DA.Eliminar(Entidad);
        } catch (Exception e) {
            resultado = -1;
            throw e;
        }
        return resultado;
    }
    
}
