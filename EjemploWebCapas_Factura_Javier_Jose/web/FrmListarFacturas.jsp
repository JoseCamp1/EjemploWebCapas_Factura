<%-- 
    Document   : FrmListarFacturas
    Created on : 09-oct-2023, 17:54:12
    Author     : JoaCa
--%>
<%@page import="java.util.List"%>
<%@page import="Entidades.Factura"%>
<%@page import="AccesoDatos.DA_Factura"%>
<%@page import="LogicaNegocio.BL_Factura"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.DateFormat"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="lib/fontawesome-free-5.14.0-web/css/all.min.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <header>
            <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-light bg-white border-bottom box-shadow mb-3">
                <div class="container">
                    <a class="navbar-brand" href="index.html">Sistema Facturación <i class="fas fa-tasks"></i></a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target=".navbar-collapse" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="navbar-collapse collapse d-sm-inline-flex flex-sm-row-reverse">
                        <ul class="navbar-nav flex-grow-1">
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="index.html">Inicio</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="Frm_ListarProductos.jsp">Productos</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="FrmListarClientes.jsp">Clientes</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="FrmListarFacturas.jsp">Facturación</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </header>



        <div class="container">
            <div class="card-header">
                <h1>Listado de Facturas Pendientes</h1><br><!-- comment -->
            </div>


            <form action="FrmListarFacturas.jsp" method="post">
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" id="txtfecha" name="txtfecha" value="" placeholder="Seleccione la fecha" 
                               class="datepicker">&nbsp; &nbsp;



                        <input type="submit" id="btnbuscar" name="btnbuscar" value="Buscar" 
                               class="btn-success"><br><br>
                    </div>
                </div>
            </form>
            <hr><!-- comment -->
            <table class="table">
                <thread>
                    <tr>
                        <th>Num. Factura</th>
                        <th>Cliente</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Opciones</th>
                    </tr>
                </thread>
                <tbody>
                    <%
                        String fecha = "";
                        String condicion = "";
                        if (request.getParameter("txtfecha") != null && !request.getParameter("txtfecha").equals("")) {
                            fecha = request.getParameter("txtfecha");
                            condicion = condicion + "FECHA = '" + fecha + "'";
                        }
                        BL_Factura logica = new BL_Factura();
                        List<Factura> datos;
                        datos = logica.ListarRegistros(condicion);
                        for (Factura registro : datos) {
                    %>
                    <tr>
                        <%int num = registro.getIdFactura();%>
                        <td><%= num%></td>
                        <td><%= registro.getNombreCliente()%></td>
                        <td><%= registro.getFecha()%></td>
                        <td><%= registro.getEstado()%></td>
                        <td>
                            <a href="Frm_Facturar.jsp?txtnumFactura=<%= num%>">
                                <i class="fas fa-cart-plus"></i></a>
                        </td>
                    </tr>
                    <%}%>

                </tbody>
            </table>
            <br>
            <a href="Frm_Facturar.jsp?txtnumFactura=-1" class="btn btn-primary">Nueva Factura</a>
        </div>
                    
        <script src="lib/jquery/dist/jquery.min.js" type="text/javascript"></script>         
        <script src="lib/bootstrap/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>        
        <script src="lib/bootstrap-datepicker/js/bootstrap-datepicker.min.js" type="text/javascript"></script>
        <script src="lib/bootstrap-datepicker/locales/bootstrap-datepicker.es.min.js" type="text/javascript"></script>
        
    </body>
    
    <script>
        $('.datepicker').datepicker({
            format: 'yyyy-mm-dd',
            autoclose: 'true',
            languaje: 'es'
        });
    </script>   
    
</html>
