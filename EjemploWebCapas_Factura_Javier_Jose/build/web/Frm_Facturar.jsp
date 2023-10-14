<%-- 
    Document   : Frm_Facturar
    Created on : 09-oct-2023, 19:26:15
    Author     : JoaCa
--%>

<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="LogicaNegocio.*"%>
<%@page import="Entidades.*"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="lib/bootstrap-datepicker/css/bootstrap-datepicker3.standalone.min.css" rel="stylesheet" type="text/css"/>
        <link href="lib/fontawesome-free-5.14.0-web/css/all.min.css" rel="stylesheet" type="text/css"/>
        <link href="lib/DataTables/datatables.min.css" rel="stylesheet" type="text/css"/>
        <title>Facturación</title>
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
                <div class="col-10"><h1>Facturación</h1></div>
            </div>  
            <%
                int numFactura = -1;
                double total = 0;
                Factura EntidadFactura;
                BL_Factura logicaFactura = new BL_Factura();
                BL_Detalle logicaDetalle = new BL_Detalle();
                List<DetalleFactura> DatosDetalles = null;
                if (request.getParameter("txtnumFactura") != null && Integer.parseInt(request.getParameter("txtnumFactura")) != -1) {
                    numFactura = Integer.parseInt(request.getParameter("txtnumFactura"));
                    EntidadFactura = logicaFactura.ObtenerRegistro("Num_Factura=" + numFactura);
                    DatosDetalles = logicaDetalle.ListarRegistros("Num_Factura=" + numFactura);
                } else {
                    EntidadFactura = new Factura();
                    EntidadFactura.setIdFactura(-1);
                    Date fecha = new Date();
                    java.sql.Date fechasql = new java.sql.Date(fecha.getTime());
                    EntidadFactura.setFecha(fechasql);
                }
            %>
            <br>

            <!--formulario-->
            <form action="Facturar" method="post">

                <div class="form-group float-right">
                    <div class="input-group">
                        <label for="txtnumFactura" class="form-control">Num. Factura</label>
                        <input type="text" id="txtnumFactura" name="txtnumFactura" value="<%=EntidadFactura.getIdFactura()%>" readonly class="form-control">
                    </div>
                </div>

                <div class="input-group">
                    <label for="txtFechaFactura" class="form-control">Fecha</label>
                    <input type="text" id="txtFechaFactura" name="txtFechaFactura" readonly value="<%=EntidadFactura.getFecha()%>" required class="datepicker form-control">
                </div>
                <br>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" id="txtIdCliente" name="txtIdCliente" value="<%=EntidadFactura.getIdCliente()%>" readonly="" class="form-control"/>
                        <input type="text" id="txtNombreCliente" name="txtNombreCliente" value="<%=EntidadFactura.getNombreCliente()%>" readonly="" class="form-control" placeholder="Seleccione un Cliente"/> &nbsp; &nbsp;
                        <a id="btnbuscar" class="btn btn-success" data-toggle="modal" data-target="#buscarCliente"><i class="fas fa-search"></i></a>                   
                    </div>             
                </div>

                <hr>        <!-- inicia el detalle de factura -->
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" id="txtIdProducto" name="txtIdProducto" value="" readonly="" class="form-control"/>
                        <input type="text" id="txtdescripcion" name="txtdescripcion" value="" class="form-control" readonly placeholder="Seleccione un producto" /> &nbsp; &nbsp;
                        <a href="url" id="btnBuscarP" class="btn btn-success" data-toggle="modal" data-target="#buscarProdcuto"><i class="fas fa-search"></i></a> &nbsp; &nbsp;
                        <input type="number" id="txtcantidad" name="txtcantidad" value="" class="form-control" placeholder="Cantidad"/> &nbsp; &nbsp;
                        <input type="number" id="txtprecio" name="txtprecio"  readonly="true" value="" class="form-control" placeholder="Precio"/> &nbsp; &nbsp;
                        <input type="number" id="txtexistencia" readonly name="txtexistencia" value="" class="form-control" placeholder="Existencia"/>                     

                    </div>
                </div>  
                <br>
                <div class="form-group">
                    <input type="submit" name="Guardar" id="BtnGuardar" value="Agregar y Guardar" class="btn btn-primary"/>                            
                </div>
            </form>
            <hr>
            <!-- msotrar detalle de factura -->
            <h5>Detalle de Factura</h5>
            <table id="DetalleFactura" class="table">
                <thead>
                    <tr>
                        <th>Codigo</th>
                        <th>Descripcion</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Subtotal</th>
                        <th>Eliminar</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (DatosDetalles != null) {
                            for (DetalleFactura registroDetalle : DatosDetalles) {
                    %>
                    <tr>
                        <%
                            int numfactura = registroDetalle.getIdFactura();
                            int codigop = registroDetalle.getIdProducto();
                            String descripcion = new String(registroDetalle.getNombreProducto().getBytes("ISO-8859-1"), "UTF-8");
                            int cantidad = registroDetalle.getCantidad();
                            double precioV = registroDetalle.getPrecio();
                            total += (cantidad * precioV);
                        %>
                        <td><%= codigop%></td>
                        <td><%= descripcion%></td>
                        <td><%= cantidad%></td>
                        <td><%= precioV%></td>
                        <td><%= cantidad * precioV%></td>
                        <td>
                            <a href="EliminarDetalle?idproducto=<%=codigop%>&idfactura=<%=numfactura%>"><i class="fas fa-trash-alt"></i></a>
                        </td>
                    </tr>
                    <%
                            }//cierre de for
                        }//cierre del if
                    %>
                </tbody>                
            </table>

            <div class="float-right">
                <p class="text-danger h5">Total = <%= total%></p>
            </div>
            <br><br>
            <%
                //mensaje generado en el servlets facturas
                if (request.getParameter("msgFac") != null) {
                    out.print("<p class='text-danger>" + new String(request.getParameter("msgFac").getBytes("ISO-8859-1"), "UTF-8") + "</p>");
                }
            %>
            <input type="button" id="BtnCancelar" value="Realizar Facturacion" onclick="location.href = 'CancelarFactura?txtnumFactura=' +<%= EntidadFactura.getIdFactura()%>" class="btn btn-success"/> &nbsp;&nbsp;
            <a href="FrmListaFacturas.jsp" class="btn btn-secondary">Regresar</a>
        </div> <!-- Container principal -->
        <!-- Modal de clientes -->
        <div class="modal" id="buscarCliente" tabindex="1" role="dialog" aria-labelledby="tituloVentana">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 id="tituloVentaja">Buscar Cliente</h5>
                        <button class="close" data-dismiss="modal" aria-hidden="true" onclick="Limpiar()">
                            <span aria-hidden="true">&times;</span>   
                        </button>                        
                    </div>
                    <div class="modal-body">
                        <!--tabla de clientes-->
                        <table id="tablaClientes">
                            <thead>
                                <tr>
                                    <th>Codigo</th>
                                    <th>Nombre</th>
                                    <th>Seleccionar</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    BL_Cliente logicaCliente = new BL_Cliente();
                                    List<Cliente> datosClientes;
                                    datosClientes = logicaCliente.ListarRegistros("");
                                    for (Cliente registroC : datosClientes) {
                                %>
                                <tr>
                                    <%
                                        int codigoCliente = registroC.getId_cliente();
                                        String nombreCliente = registroC.getNombre();
                                    %>
                                    <td><%= codigoCliente%></td>
                                    <td><%= nombreCliente%></td>
                                    <td>
                                        <<a href="#" data-dismiss="modal" onclick="SeleccionarCliente('<%=codigoCliente%>', '<%= nombreCliente%>');">Seleccionar</a>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>                        
                    </div><!-- modal body -->
                    <div class="modal-footer">
                        <button class="btn btn-warning" type="button" data-dimiss="modal" onclick="Limpiar()">
                            Cancelar
                        </button>
                    </div>
                </div><!-- modal content -->                
            </div><!-- modal dialog -->            
        </div><!-- modal -->

        
        <!-- Modal de producto -->
        <div class="modal" id="buscarProducto" tabindex="1" role="dialog" aria-labelledby="tituloVentana">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 id="tituloVentaja">Buscar Producto</h5>
                        <button class="close" data-dismiss="modal" aria-label="Cerrar" aria-hidden="true" onclick="LimpiarProducto()">
                            <span aria-hidden="true">&times;</span>   
                        </button>                        
                    </div>
                    <div class="modal-body">
                        <!--tabla de productos-->
                        <table id="tablaProductos">
                            <thead>
                                <tr>
                                    <th>Codigo</th>
                                    <th>Descripcion</th>
                                    <th>Precio</th>
                                    <th>Seleccionar</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    BL_Producto logicaProductos = new BL_Producto();
                                    List<Producto> datosProductos;
                                    datosProductos = logicaProductos.ListarRegistros("");
                                    for (Producto registroP : datosProductos) {
                                %>
                                <tr>
                                    <%
                                        int codigoProducto = registroP.getIdProducto();
                                        String nombreProducto = registroP.getDescripcion();
                                        double precio = registroP.getPrecio();
                                        double exitencia = registroP.getExistencia();
                                    %>
                                    <td><%= codigoProducto%></td>
                                    <td><%= nombreProducto%></td>
                                    <td><%= precio%></td>
                                    <td>
                                        <<a href="#" data-dismiss="modal" onclick="SeleccionarProducto('<%=codigoProducto%>', '<%= nombreProducto%>', '<%= precio%>', '<%= exitencia%>');">Seleccionar</a>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>                        
                    </div><!-- modal body -->
                    <div class="modal-footer">
                        <button class="btn btn-warning" type="button" data-dimiss="modal" onclick="LimpiarProducto()">
                            Cancelar
                        </button>
                    </div>
                </div><!-- modal content -->                
            </div><!-- modal dialog -->            
        </div><!-- modal -->
        
        <!-- scripts requeridos -->
        <script src="lib/jquery/dist/jquery.min.js" type="text/javascript"></script>
        <script src="lib/bootstrap/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script src="lib/bootstrap-datepicker/js/bootstrap-datepicker.min.js" type="text/javascript"></script>
        <script src="lib/bootstrap-datepicker/locales/bootstrap-datepicker.es.min.js" type="text/javascript"></script>
        <script src="lib/DataTables/datatables.min.js" type="text/javascript"></script>
        
        <script src="lib/DataTables/DataTables-1.10.21/js/dataTables.bootstrap4.min.js" type="text/javascript"></script>
        
        <script>
            // cuando el documento este listo
            // cargue las siguientes funciones
            $(document).ready(function(){
                //mostrar calendario
                $('.datepicker').datepicker({
                    format: 'yyyy-mm-dd',
                    autoclose: true,
                    language: 'es'
                });
                //hacer que la lista de clientes se comporte como un datatable
                //configurar la tabla clientes del modal
                $('#tablaClientes').dataTable({
                    "lengthMenu":[[5,15,15,-1],[5,10,15,"All"]],
                    "languaje": {
                        "info": "Pagina _PAGE_ de _PAGES_",
                        "infoEmpty": "No existen Registros Disponibles",
                        "zeroRecords": "No se encuentran resgistros",
                        "search": "Buscar",
                        "infoFilter":"",
                        "lengthMenu":"Mostrar _MENU_ Registros",
                        "paginate": {
                            "first": "Primero",
                            "last": "Ultimo",
                            "next": "Siguiente",
                            "previous": "Anterior"
                        }
                    }
                });
                // configura la tabla productos del modal
                $('#tablaProductos').dataTable({
                    "lengthMenu": [[5,15,15,-1],[5,10,15,"All"]],
                    "languaje": {
                        "info": "Pagina _PAGE_ de _PAGES_",
                        "infoEmpty": "No existen Registros Disponibles",
                        "zeroRecords": "No se encuentran resgistros",
                        "search": "Buscar",
                        "infoFilter":"",
                        "lengthMenu":"Mostrar _MENU_ Registros",
                        "paginate": {
                            "first": "Primero",
                            "last": "Ultimo",
                            "next": "Siguiente",
                            "previous": "Anterior"
                        }
                    }
                });
            });
            //selecionar clientes
            //estas funciones se llaman con un evneto desde un modal
            function SeleccionarCliente(idCliente, nombreCliente){
                $("#txtIdCliente").val(idCliente);
                $("#txtIdNombreCliente").val(nombreCliente);
            }
            //selecionar producto
            function SeleccionarProducto(idProducto,Descripcion,Precio,Existencia){
                 $("#txtIdProducto").val(idProducto);
                 $("#txtdescripcion").val(Descripcion);
                 $("#txtprecio").val(Precio);
                 $("#txtexistencia").val(Existencia);
                 $("#txtcantidad").focus();
            }
            
            //limpiar cliente
            function Limpiar(){
                $("#txtIdCliente").val("");
                $("#txtIdNombreCliente").val("");
            }
            
            //limpiar producto
            function LimpiarProdcuto(){
                $("#txtIdProducto").val("");
                 $("#txtdescripcion").val("");
                 $("#txtprecio").val("");
                 $("#txtexistencia").val("");                
            }
            
        </script>
        
         </body>
</html>