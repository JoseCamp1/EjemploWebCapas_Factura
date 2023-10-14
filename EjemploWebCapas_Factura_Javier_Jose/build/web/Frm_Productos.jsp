<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Entidades.Producto" %>
<%@page import="LogicaNegocio.BL_Producto" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Agregar productos</title>
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
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <div class="card-header">
                        <h1>Lista de Productos</h1>
                    </div>

                    <%
                        Producto entidad;
                        BL_Producto logica = new BL_Producto();
                        int idproducto;
                        if (request.getParameter("txtIdproducto") != null
                                && !request.getParameter("txtIdproducto").equals("")) {
                            idproducto = Integer.parseInt(request.getParameter("txtIdproducto"));
                            entidad = logica.ObtenerRegistro("Id_producto=" + idproducto);
                        } else {
                            entidad = new Producto();
                            entidad.setIdProducto(-1);
                        }
                    %>
                    <br>
                    <form action="AddProducto" method="post">

                        <div class="form-group">
                            <input type="hidden" name="txtIdproducto" id="txtIdproducto" class="form-control"
                                   value="<%= entidad.getIdProducto()%>" readonly/>

                            <label for="txtdescripcion">Descripción</label>
                            <input type="text" name="txtdescripcion" id="txtdescripcion" 
                                   value="<%= entidad.getDescripcion()%>" required class="form-control"/>
                        </div>  
                        <div class="form-group">
                            <label for="txtprecio">Precio</label>
                            <input type="text" name="txtprecio" id="txtprecio" 
                                   value="<%= entidad.getPrecio()%>" required class="form-control"/>
                        </div>
                        <div class="form-group">
                            <label for="txtexistencia">Existencia</label>
                            <input type="text" name="txtexistencia" id="txtexistencia" 
                                   value="<%= entidad.getExistencia()%>" required class="form-control"/>

                        </div>  
                        <div class="form-group">
                            <input type="submit" value="Guardar" class="btn btn-primary">
                            <input type="button" id="btnRegresar" value="Regresar" onclick="location.href = 'Frm_ListarProductos.jsp'" class="btn btn-secondary"/>
                        </div>  
                    </form>
                </div> <!-- clase que crea las 6 columnas -->

            </div> <!-- class row, div de la fila -->

        </div> <!-- class container -->

        <script src="lib/jquery/dist/jquery.min.js" type="text/javascript"></script>
        <script src="lib/bootstrap/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
    </body>
</html>
