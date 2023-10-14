package Servlets;

import Entidades.Factura;
import LogicaNegocio.BL_Factura;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CancelarFactura extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            BL_Factura LogicaFactura = new BL_Factura();
            int idFactura = Integer.parseInt(request.getParameter("txtnumFactura"));
            Factura EntidadFactura = LogicaFactura.ObtenerRegistro("Num_Factura" + idFactura);
            EntidadFactura.setEstado("Cancelada");
            LogicaFactura.ModificarEstado(EntidadFactura);
            response.sendRedirect("Frm_Facturar.jsp?txtnumFactura=-1");
        } catch (Exception e) {
            out.print(e.getMessage());
            
        }
    }
    
}