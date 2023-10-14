package Servlets;

import Entidades.Cliente;
import LogicaNegocio.BL_Cliente;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Estos dos son sólo de ejemplo:
// import java.text.SimpleDateFormat;
// import java.util.Date;

public class CrearModificarCliente extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /*
            Este Servlete va a hacer un trabajo muy sencillo, va a crear una entidad Cliente
            para enviárselo al metodo correspondiente (insertar o modificar)
        */
        
        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();
        // No la incluimos dentro del Try, porque necesitamos usarla en el catch

        try {
            BL_Cliente Logica = new BL_Cliente();
            Cliente cliente = new Cliente();
            int resultado;

            cliente.setId_cliente(Integer.parseInt(request.getParameter("txtCodigo")));
            // txtCodigo sabemos que tiene un int, por ello lo parseamos a Intenger

            cliente.setNombre(new String(request.getParameter("txtNombre").getBytes("ISO-8859-1"), "UTF-8"));
            // Los campos de texto les aplicamos una CODIFICACIÓN DE CARACTERES con un new String y con el 
            // método getBytes. Esto por si viene con caracteres que no sean reconocidos por la BD por ejemplo. 
            // De no hacer esta conversión, por ejemplo en lugar de las tildes o las ñ pueden aparecer símbolos "extraños" para el usuario

            cliente.setTelefono(request.getParameter("txtTelefono"));
            // El teléfono en teoría sólo tiene números y guiones. Pero si quisiéramos prevenir que no incluya 
            // caracteres especiales no reconocidos, también podríamos aplicarle la codificación de caracteres. 

            cliente.setDireccion(new String(request.getParameter("txtDireccion").getBytes("ISO-8859-1"), "UTF-8"));

            // Si tuviéramos que trabajar un dato del tipo fecha:
            // Por ejemplo cuando se haga la facturación, que necesita llevar una fecha
            /*
            SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
            String fechaString = request.getParameter("txtFecha"); // en este ejemplo ese campo no existe
            Date fecha = formato.parse(fechaString);
            java.sql.Date fechasql = new java.sql.Date(fecha.getTime());
            EntidadFactura.setFecha(fechasql); // en este ejemplo no existe esa entidad
            */
            
            if (cliente.getId_cliente() > 0) {
                resultado = Logica.Modificar(cliente);
            } else {
                resultado = Logica.Insertar(cliente);
            }
            response.sendRedirect("FrmListarClientes.jsp");

        } catch (Exception ex) {
            out.print(ex.getMessage());
        }
    }

    /*  El siguiente código oculto lo que tiene es la definición del doGet y el doPost, 
        que de forma predeteminada ambos están llamando al método processRequest. 
        
        En nuestro caso este Servlet será llamado mediante un POST de Frm_clientes.jsp, 
        entonces requerimos programar el método doPost. 
        Lo estamos haciendo en el método processRequest, porque el método doPost llama
        a este método. Esto nos permite "despreocuparnos" si la petición es Get o es Post
        y lo que sea que quiera hacer lo hacemos en el ProcessRequest. 
        
        Pero si se ocupa que el GET ejecute ciertas acciones y el POST otra acciones, 
        se deben manejar de forma separada en sus respectivos métodos doGet y doPost
        (no de forma genérica en el processRequest)
    
        En este ejemplo usamos el método ProcessRequest, pero habría sido lo mismo 
        si hubiéramos utilizado el método doPOST (en cuyo caso podríamos borrar el método 
        processRequest)
    
        Nota técnica: Si en el FOMRULARIO uno definiera que el MÉTODO es GET, igual va a 
        funcionar. La diferencia es que todos los parámetros se van a enviar como un 
        QueryString en la URL. En este caso el único cuidado que habría que tener es que
        el Servlet entonces debería manejarlo con el método doGET. Por ello el uso del
        método processRequest (en el cual no nos preocupamos si el método que lo 
        invocó fue POST o GET) es útil si uan persona programó el formulario y otra 
        persona programa el Servlet. 
    
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
