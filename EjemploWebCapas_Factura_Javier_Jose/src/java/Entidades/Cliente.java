package Entidades;

public class Cliente {

    // ATRIBUTOS ____________________________________
    private int id_cliente;
    private String nombre;
    private String direccion;
    private String telefono;
    private boolean existe;

    // CONSTRUCTORES ________________________________
    public Cliente() {
        id_cliente = 0;
        nombre = "";
        direccion = "";
        telefono = "";
        existe = false;
    }

    public Cliente(int id_cliente, String nombre, String direccion, String telefono) {
        this.id_cliente = id_cliente;
        this.nombre = nombre;
        this.direccion = direccion;
        this.telefono = telefono;
        existe = true; // No se recibe por parámetro, se establece de forma predeterminada
    }

    // Un constructor con sólo dos parámetros, en caso que sea requerido luego
    public Cliente(int id_cliente, String nombre) {
        this.id_cliente = id_cliente;
        this.nombre = nombre;
        direccion = "";
        telefono = "";
        existe = true; // porque lo estamos creando con datos de un cliente que existe
    }


    // PROPIEDADES ________________________________________
    public int getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(int id_cliente) {
        this.id_cliente = id_cliente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public boolean isExiste() {
        return existe;
    }

    public void setExiste(boolean existe) {
        this.existe = existe;
    }

    // SOBRESCRIBIR MÉTODOS _______________________________
    @Override
    public String toString() {
        return id_cliente + " " + nombre;
    }

}
