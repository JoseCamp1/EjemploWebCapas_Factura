<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="LogicaNegocio.BL_Cliente"%>
<%@page import="Entidades.Cliente"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <!-- Agregamos los vínculos a Bootstrap y a nuestro archivo de estilos: -->
        <link href="lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <link href="css/estilos.css" rel="stylesheet" type="text/css"/>
        <title>Mantenimiento de Cliente</title>
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
                        <h1>Mantenimiento de  Clientes</h1>
                    </div>
                    <!-- Este formulario lo vamos a utilziar para dos trabajos: 
                    Crear un cliente NUEVO y también MODIFICAR un cliente existente.
                    
                    Cuando vamos a crear un CLIENTE NUEVO vamos a llamarlo enviándole un 
                    código -1 en el campo de código del cliente.
                    
                    Cuando vamos a llamarlo para MODIFICAR un cliente existente vamos a 
                    llamarlo enviándole el código que corresponde al cliente a modificar. 
                    
                    Por ello lo primero que debemos hacer es crear una entidad cliente 
                    para colocar en el VALUE de los INPUTS los datos de ese cliente:
                    
                    -->

                    <%
                        String id = request.getParameter("idCrearModificar");
                        int codigo = Integer.parseInt(id);
                        Cliente cliente;
                        BL_Cliente logica = new BL_Cliente();

                        if (codigo > 0) {
                            // Si el cliente existe, lo obtiene enviándole una
                            // CONDICIÓN al método que obtiene un registro:
                            cliente = logica.ObtenerRegistro("ID_CLIENTE=" + id);
                        } else {
                            // Sino, crea uno nuevo
                            cliente = new Cliente();
                        }
                    %>

                    <form action="CrearModificarCliente" method="post" id="form_AgregarModificar">
                        <!-- la ACCIÓN del formulario es llamar al Servlet CrearModificarCliente, sabemos que es un 
                            Servlet porque no tiene extención .jsp, el método es POST porque es un formulario.
                        
                            Entonces luego deberemos crear un SERVLET llamado AddCliente que deberemos programarle 
                            un método doPost 
                            
                            El formulario necesita un ID para poder hacerle validación con el jqueryvalidate
                        -->

                        <!-- Cada form-group es una fila, para que se coloquen horizontalmente -->

                        <!-- form-group para los controles de ID -->
                        <div class="form-group">
                            <%if (codigo > 0) {%>
                            <!-- Si el cliente existe, mostrará la etiqueta y el ID, deshabilitado para que no se pueda editar -->
                            <label for="txtCodigo" class="control-label">Código</label>
                            <input type="number" id="txtCodigo" name="txtCodigo" value="<%=cliente.getId_cliente()%>" readonly class="form-control"/><br>
                            <%} else {%>
                            <!-- Sino, el campo ID se le asigna -1 y no se muestra en pantalla -->
                            <input type="hidden" id="txtCodigo" name="txtCodigo" value="-1"/><br>
                            <%}%>
                        </div>

                        <!-- form-group para los controles de Nombre -->
                        <div class="form-group">
                            <label for="txtNombre" class="control-label">Nombre</label>
                            <input type="txt" id="txtNombre" name="txtNombre" value="<%=cliente.getNombre()%>" class="form-control"/><br>
                        </div>

                        <!-- form-group para los controles de Teléfono -->
                        <div class="form-group">
                            <label for="txtTelefono" class="control-label">Teléfono</label>
                            <input type="txt" id="txtTelefono" name="txtTelefono" value="<%=cliente.getTelefono()%>" class="form-control" placeholder="00-00-00-00"/><br>
                        </div>

                        <!-- form-group para los controles de Dirección -->
                        <div class="form-group">
                            <label for="txtDireccion" class="control-label">Dirección</label>
                            <input type="txt" id="txtDireccion" name="txtDireccion" value="<%=cliente.getDireccion()%>" class="form-control"/><br>
                        </div>

                        <!-- form-group para los BOTONES de guardar y regresar  -->
                        <div class="form-group">
                            <div class="input-group">
                                <input type="submit" id="btnGuardar" value="Guardar" class="btn btn-primary"/> &nbsp;&nbsp;
                                <input type="button" id="btnRegresar" value="Regresar" onclick="location.href = 'FrmListarClientes.jsp'" class="btn btn-secondary"/>
                                <!-- El botón Regresar lleva a la página FrmListarClientes.jsp, no estamos haciendo un RESPONSE
                                porque no está respondiento a ninguna petición, entonces el Regresar lo estamos haciendo por medio de 
                                Javascript con un atributo ONCLICk a ese botón, y en el ONCLICK estamos usando un LOCATION.HREF
                                y poder redireccionar a otra página. -->
                            </div>
                        </div>

                    </form>

                </div> <!-- clase que crea las 6 columnas -->

            </div> <!-- class row, div de la fila -->

        </div> <!-- class container -->

        <!-- Agregamos las referencias a Bootstrap, jquery y jquery-validation -->
        <script src="lib/bootstrap/dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
        <script src="lib/jquery/dist/jquery.min.js" type="text/javascript"></script>
        <script src="lib/jquery-validation/dist/jquery.validate.min.js" type="text/javascript"></script>

        <!-- Código de Javascript para realizar la VALIDACIÓN del formulario:
            En este ejemplo este código se incluyó dentro de la misma página JSP, si uno quisiera 
            puede crear un archivo aparte para manejar el código JS (al igual que lo hicimos con CSS), 
            y en la página JSP hacer el enlace al archivo JS. 
        -->

        <script>
                                    // Cuando el documento está listo
                                    $(document).ready(function () {
                                        
                                        /* Hacemos una FUNCIÓN ANÓNIMA (que no tiene nombre)
                                         El $ es propio de JQuery, seleccionar el formulario (por medio de su ID) y le aplica
                                         el método .validate
                                         Con sólo el .validate ya es suficiente para que el formulario valide, pero recordemos que 
                                         los mensajes predetermiandos están en inglés. Por ello entre paréntes y entre llaves le agregamos
                                         las REGLAS y los MENSAJES que deseamos personalizar. 
        
                                         Nota: estos nombres (por ejemplo txtNombre) son los nombres (atributo name) de los INPUTs.
                                         Los atributos name de los inputos diferencias mayúsuclas de minúsuclas. 
                                        */
                                        
                                        $("#form_AgregarModificar").validate({
                                            // Reglas que deseamos personalizar:
                                            rules: {
                                                // Si no definimos estas reglas, solamente se aplicarán las reglas que estén definidas
                                                // dentro de cada input (por ejemplo el input se definió como requiered)
                                                
                                                txtNombre: {required: true, maxlength: 50},
                                                txtTelefono: {required: true, minlength: 8, maxlength: 11},
                                                // el tamaño anterior podría ser cualquier otro, entre 8 y 11 es sólo un ejemplo

                                                txtDireccion: {required: true, maxlength: 80}
                                                
                                                // Nota: Para determinar estos tamaños debemos verificar las restricciones de nuestra BD
                                                
                                                
                                            },
                                            // Mensajes que deseamos personalizar: 
                                            messages: {
                                                txtNombre: "El campo de Nombre es obligatorio (max 50 caracteres)",
                                                txtTelefono: "El campo Teléfono es obligatorio (mínimo 8 caracteres, máximo 11)",
                                                txtDireccion: "El campo Dirección es obligatorio (max 80 caracteres)"
                                            },
                                            errorElement: 'span'
                                            // Indicamos que si muestar mensajes de error, los muestre dentro de un span, con esto 
                                            // de forma automática si se produce un error se va a generar un SPAN, y por eso fue 
                                            // que creamos un ESTILO para indicar que el color de ese SPAN fuera rojo en una letra
                                            // un poco más pequeña. 
                                        });
                                    });
                                    /* Si hubiera estado este código dentro de un archivo JS, funcionaría igual. 
                                     * Pero siempre debemos tener cuidado de primero agregar Jquery y Jquery-validate
                                     * Primero se debe agregar el Jquery (el core) y después del validate, porque el validate
                                     * utiliza el core. Por ello el orden en que se inserten si es importante. 
                                     */
        </script>

    </body>
</html>
