package Entidades;

/**
 *
 * @author dcruz
 */
public class Producto {

        private int idProducto;
        private String descripcion;
        private double precio;
        private double existencia;
        private boolean existeRegistro;
    
    //***********************************
    //"Constructores"

    public Producto() {
        idProducto = 0;
        descripcion = "";
        precio = 0;
        existencia = 0;
        existeRegistro = false;
    }
    
    public Producto(int idProducto, String descripcion, double precio, double existencia) {
        this.idProducto = idProducto;
        this.descripcion = descripcion;
        this.precio = precio;
        this.existencia = existencia;
    }
    //***********************************
        public int getIdProducto() {
        return idProducto;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public double getPrecio() {
        return precio;
    }

    public double getExistencia() {
        return existencia;
    }

    //"Atributos"
    public boolean isExisteRegistro() {
        return existeRegistro;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public void setExistencia(double existencia) {
        this.existencia = existencia;
    }

    public void setExisteRegistro(boolean existeRegistro) {
        this.existeRegistro = existeRegistro;
    }
}