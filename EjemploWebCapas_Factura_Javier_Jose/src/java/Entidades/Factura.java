package Entidades;

import java.sql.Date;
/*  Hay varios objetos para manejar fechas, en este caso como son fechas
    que manipulamos diretamente de la BD debemos agregar este import, para 
    que las fechas sean compatibles con el driver de la BD que estamos manejando.
    Si no hacemos ese import, al declarar el atributo fecha automáticamente
    nos va a sugerir el import java.util.Date, pero el de UTIL es un objeto
    de fecha GENÉRICO, el que nos sirve es el de SQL.
*/

public class Factura {
    
    // ATRIBUTOS
    private int idFactura;
    private int idCliente;
    private Date fecha;
    private String estado;
    private boolean existeRegistro;
    private String nombreCliente; // No es un campo mapeado de la BD
    
    // PROPIEDADES
    public int getIdFactura() {
        return idFactura;
    }

    public void setIdFactura(int IdFactura) {
        this.idFactura = IdFactura;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int IdCliente) {
        this.idCliente = IdCliente;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String NombreCliente) {
        this.nombreCliente = NombreCliente;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date Fecha) {
        this.fecha = Fecha;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String Estado) {
        this.estado = Estado;
    }

    public boolean isExisteRegistro() {
        return existeRegistro;
    }

    public void setExisteRegistro(boolean ExisteRegistro) {
        this.existeRegistro = ExisteRegistro;
    }
    
    // CONSTRUCTORES

    public Factura() {
        idFactura = 0;
        idCliente = 0;
        nombreCliente = "";
        fecha = null; // Para obtener la fecha actual se usa getTime() de la clase Date
        estado = "";
        existeRegistro = false;
    }

    public Factura(int IdFactura, int IdCliente, String NombreCliente, Date Fecha, String Estado) {
        this.idFactura = IdFactura;
        this.idCliente = IdCliente;
        this.nombreCliente = NombreCliente;
        this.fecha = Fecha;
        this.estado = Estado;
        existeRegistro = true; // no se recibe por parámetro
    }
    
}
