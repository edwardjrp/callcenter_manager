#Manual de usuario Domino's Contact Center - KPiQ@25 (Etapa 1)


##Introducción

Este manual explica el funcionamiento y modo de uso de las distintas herramientas disponibles en la aplicación del Contact Center de Domino's Pizza Dominicana. El manual está dividido en dos grandes partes:

1. 	*Agentes:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios básico (Agentes). Esta parte es la que necesitan la mayor parte de los usuarios.

2. 	*Administradores:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios de administrador (Administradores). Esta parte es necesaria para los usuarios con elevado nivel de acceso a la aplicación.



##Descripción:

La aplicación del Contact Center de Domino's Pizza Dominicana - KPiQ@25 es una aplicación WEB (accedida a través de un programa de navegación WEB), que tiene como objetivo principal proveer a través de un programa informático las herramientas necesarias para la venta vía telefónica de los productos de Domino's Pizza Dominicana, y la supervisión y gestión de las operaciones del Contact Center.

KPiQ@25 está diseñado para que un operador, conociendo el menú de productos ofertados por Domino's Pizza Dominicana y teniendo un conocimiento básico del manejo de un computador, sea capaz de colocar una orden de compra a solicitud de un cliente vía telefónica. Para lograr este objetivo la aplicación consta de varias secciones (o páginas) de fácil acceso y operación que procederemos a explicar detalladamente más adelante.

El ambiente de trabajo está dividido en tres partes:

1. 	La parte más ancha ubicada a la izquierda de la pantalla se corresponde con la sección dónde estemos trabajando (Clientes, tiendas, cupones) y su uso será descrito en las secciones correspondientes de este documento.

2. 	A la derecha en la parte superior encontramos un resumen de los datos correspondientes al cliente seleccionado actualmente (En el caso de los agentes que no son administradores). Para más detalles sobre las funciones disponibles ver sección *Resumen de clientes* bajo *I. AGENTES*.

3. 	A la derecha en la parte inferior está ubicado el carrito de compras (En el caso de los agentes que no son administradores). Para más detalles sobre las funciones disponibles ver sección *Carrito de compras* bajo *I. AGENTES*.

<br/>
**Figura 1**
![Ambiente_Trabajo](manual/Ambiente_trabajo2.png "Fig. 1 Ambiente de trabajo")

Cada una de estas partes del ambiente de trabajo contiene información importante y provee acceso a distintas funciones que serán descritas en lo adelante.

En todo los listados disponibles en la aplicación (Clientes, tiendas, Productos) hay filtros disponibles que permiten localizar las entrada deseadas en cada sección (Ver fig. 1).

En caso de errores, se presentará un mensaje en letras rojas en la parte superior de la pantalla. Estos mensajes desaparecen al hacer click sobre ellos.

Para poder usar la aplicación, los usuarios tendrán que iniciar sesión (login) en el sistema proveyendo su nombre de usuario y contraseña. Una vez hecho esto, podrán acceder a todas las funciones de la aplicación según su nivel de privilegios. Si desean cerrar su sesión sólo deben presionar el link logout que está siempre visible en el extremo superior derecho de la ventana, junto al nombre de usuario.

En general el flujo de colocación de una orden en KPiQ@25 es el siguiente:

1. 	Selección del cliente
2. 	Selección de la tienda donde se colocará la orden
3. 	Selección de los productos a ordenar
4. 	(opcional) Selección de los cupones a aplicar
5. 	Checkout




##I. AGENTES

Los agentes tienen la posibilidad de crear clientes en la base de datos, modificar datos de clientes, colocar órdenes, visualizar información de cupones. Un agente tiene acceso a las siguientes secciones de la aplicación que se muestran en la parte superior de la pantalla:


### Clientes


Presenta un listado paginado de todos los clientes registrados en la base de datos del sistema y un breve resumen de los datos correspondientes a los mismos. Provee acceso a las siguientes funciones:


1\.	**Buscar clientes en la base de datos**

Al introducir datos parciales sobre clientes en los campos correspondientes en el formulario de búsqueda se despliega un listado con los datos de clientes en la base de datos que coinciden con los introducidos. Ej. Para buscar un cliente de nombre Juan Pérez, se introduce "Juan Pérez" en el campo nombre del formulario y se selecciona a Juan Pérez en la lista desplegada. Para buscar un cliente con número telefónico 8095555555, se introduce "8095555555" en el campo teléfono del formulario y se selecciona el número correspondiente del listado desplegado.


2\. 	**Seleccionar clientes**

Al hacer *click* sobre un cliente mostrado en el listado este se selecciona automáticamente y se muestra en la parte derecha de la página.


3\. 	**Acceder a la sección de Gestión de clientes**

Al hacer *doble click* sobre un cliente se accede a la sección de gestión de clientes donde se muestran los datos de uso del cliente en cuestión y se accede a varias funciones (Ver *Sección de gestión de clientes* más abajo).


4\. 	**Agregar nuevos clientes a la base de datos**

Al presionar el botón "Agregar cliente" en la parte superior derecha de la página (Ver Fig. 2) se accede al formulario de nuevo cliente donde se introducen los datos para crear nuevos clientes. (Ver *Formulario de nuevo cliente* más abajo)

<br/>
**Figura 2**
![Agentes_Clientes](manual/Agentes_Clientes.png "Fig. 2 Listado de clientes")


#### Sección de Gestión de clientes

Desde esta sección es posible acceder a las siguientes funciones:


1\. 	**Visualizar el historial de órdenes de un cliente**

Se presenta automáticamente en la parte superior de la sección de gestión de clientes. En este historial se encuentran paginadas todas las órdenes colocadas correspondientes a un cliente en particular. Aquí pueden visualizarse el número (ID) de las órdenes, el estado de las órdenes, la fecha de inicio de las órdenes, el monto de las órdenes.


2\.	**Visualizar un listado de las direcciones relacionadas con el cliente en la base de datos**

Se presenta automáticamente debajo del *historial de órdenes*.


3\. 	**Visualizar y agregar comentarios relativos a los clientes**

Los comentarios introducidos en el pasado por otros agentes y por el mismo agente que accede a esta sección son presentados automáticamente debajo del historial de órdenes. Para agregar comentarios sólo hay que escribir los mismos en el cuadro de texto provisto con estos fines y presionar el botón "Crear comentario" (Ver fig. 3).


4\. 	**Acceder al formulario de edición de datos de clientes**

Al presionar el botón "Editar *Nombre de Cliente*", ubicado en la parte superior derecha de la página (Ver fig. 3), se accede a este formulario.


5\.	**Asociar RNC existentes en la base de datos a un cliente:**

A la derecha de la página aparece un resumen de los datos de cliente (Ver fig. 3). En la sección inferior de esta columna está el link "Asociar número fiscal (RNC)*, al presionar este link se abre una ventana (popup) que permite introducir un número de RNC en la caja de texto provista. Una vez introducido este número debe validarse en la base de datos presionando "Validar" al lado del número, si el número es validado el nombre correspondiente se presentará debajo del número introducido, y al presionar el botón "Asociar" el RNC será asociado al cliente en cuestión y aparecerá en el área de datos fiscales del cliente (Parte inferior de la columna de la derecha).

*Nota:* Si se desea abortar la operación una vez abierta la ventana de asociación de RNC y antes de guardar los cambios, se debe presionar la "x" en la parte inferior derecha de esta ventana.

<br/>
**Figura 3**
![Agentes_Gestión_Clientes](manual/Gestion_Clientes.png "Fig. 3 Gestión de clientes")


##### Formulario de edición de datos de clientes.

Permite modificar los datos personales de un cliente en particular, agregar/remover números de teléfono, y agregar/remover direcciones. Luego de efectuadas las modificaciones de lugar debe presionarse el botón "Actualizar clientes" al final del formulario para que los cambios sean registrados en la base de datos. Si se desea cancelar los cambios efectuados sólo hay que presionar el botón "Cancelar" al final del formulario.



##### Formulario de nuevo cliente.

Para agregar un nuevo cliente a la base de datos desde este formulario sólo hay que introducir los datos en los campos correspondientes (los campos marcados con asterisco son obligatorios). Si se desea incluir más de un número de teléfono se debe presionar el botón "Agregar otro teléfono" que desplegará los campos necesarios. Si se desea agregar más de una dirección, debe presionarse el botón "Agregar otra dirección" que desplegará los campos necesarios. Al finalizar la introducción de datos correspondientes a un cliente debe presionarse el botón "Crear cliente" al final del formulario para que los datos se registren  en la base de datos; si se desean descartar los datos introducidos sólo hay que presionar el botón "Cancelar" al final del formulario.

<br/>
<br/>
<br/>

### Tiendas.

Presenta un listado paginado de las tiendas disponibles e información relativa a las mismas. Permite filtrar por ciudad las tiendas mostradas en el listado al clickear sobre el nombre de la ciudad en la parte superior del mismo. Además permite ordenar el listado en base a cualquier campo de los datos de tienda al clickear sobre el encabezado de la columna correspondiente.

A la derecha de cada tienda hay un link marcado como "Productos" que provee acceso al listado de productos correspondiente a la tienda en cuestión.

<br/>
**Figura 4**
![Agentes_Tiendas](manual/Agentes_Tiendas.png "Fig. 4 Listado de tiendas")


#### Listado de productos

Muestra un listado paginado de todos los productos que se venden en una tienda en particular y muestra datos específicos concernientes a los productos como: *Categorycode*, *Productcode*, *Productname*, *Opciones*, y *Disponibilidad*; este último campo muestra si el producto está o no disponible en la tienda en cuestión.

Se puede filtrar por categorías el listado de productos al clickear sobre el nombre de la categoría deseada en la fila ubicada encima del listado.

Para agregar un producto de entre los que están disponibles (o es posible introducir productos que no están disponibles) a la orden actual, sólo hay que hacer click sobre la fila correspondiente al mismo.

**Notas:** No es posible incluir productos de más de una tienda en una misma orden. Si alguna de las opciones o complementos de un producto no están disponibles, bajo la columna *Disponibilidad* aparecerá la notificación "Faltan complementos"; si se intenta agregar a la orden un producto en esta condición, el sistema solicitará confirmación para la operación. Si se confirma que igual se desea agregar el producto el mismo se agregará a la orden.

<br/>
<br/>
<br/>

### Cupones

Esta sección es informativa, es decir, no perite ejecutar ninguna función. Aquí se presenta un listado paginado de todos los cupones existentes en la base de datos e información pertinente sobre los mismos.

Para introducir cupones en la orden existe una pestaña que siempre está visible en la parte inferior de la pantalla y está marcada como "Cupones" (Ver fig. 5), al hacer click sobre esta se despliega el listado de los cupones disponibles al momento (Ver fig. 6). Con sólo hacer click sobre un cupón del listado este se agregará a la orden. Para ocultar el listado se debe hacer "click" sobre la pestaña "Cupones".

<br/>
**Figura 5**
![Pestaña Cupones](manual/Cupones_1.png "Fig. 5 Pestaña Cupones")

<br/>
**Figura 6**
![Cupones](manual/Cupones_2.png "Fig. 6 Cupones")



### Resumen de datos clientes

Esta sección está visible siempre que hay un cliente seleccionado. La encontramos a la derecha de la pantalla en el límite superior del área de trabajo (Ver fig. 1). En esta sección están disponibles las siguientes opciones:

#### Liberar cliente

Al presionar la opción "Liberar" en la parte superior derecha del Resumen de clientes (Ver fig. 7), se deselecciona el cliente actual. Para poner una orden luego de ejecutar esta función es necesario ir a la sección de clientes y seleccionar algún cliente del listado.

**Nota:** Si hay productos en el carrito al momento de liberar un cliente, esta orden queda guardada como incompleta. Al seleccionar nuevamente el cliente liberado esta orden se cargará al carrito automáticamente.


#### Seleccionar dirección a usar o acceder al Formulario de edición de datos de clientes

Si el cliente no tiene ninguna dirección asignada en la base de datos, en la parte inferior de esta sección (Ver fig. 8) aparecerá el link "Agregar dirección" que nos dirigirá al formulario de edición de datos de clientes (Ver sección correspondiente bajo *Clientes* más arriba en este documento). 

Para los clientes con una o más direcciones asignadas aparecerá un campo *Dirección* en el resumen de datos de clientes mostrando la dirección que está actualmente seleccionada de entre las que están asignadas al cliente (Ver fig. 7). Esta dirección mostrada es a la vez un link que al presionarlo abre una ventana (popup) de selección de direcciones; esta ventana muestra las direcciones asociadas al cliente en la base de datos; cada una incluyendo información sobre la tienda correspondiente, y un selector. En esta ventana se puede seleccionar la dirección deseada y presionar el botón "Guardar" en la parte inferior de la ventana para aplicar la selección. La dirección seleccionada aquí será la dirección a la que se asignará la orden.

**Nota:** Para poder seleccionar el modo de servicio "Delivery" debe haberse seleccionado aquí una dirección que sea *Deliverable Address*.



#### Acceder al listado de productos de la tienda asignada

Cuando el cliente tiene direcciones asociadas, las mismas se relacionan automáticamente con la tienda correspondiente. Esta tienda aparece debajo de la dirección en el Resumen de datos de clientes (Ver fig. 7) y es a la vez un link. Si se hace click sobre este link, se nos dirigirá al listado de productos de esta tienda para seleccionar los productos de la orden.

<br/>
**Figura 7**
![Resumen_Cliente](manual/Resumen_Cliente.png "Fig. 7 Resumen de datos de cliente_1")

<br/>

**Figura 8**
![Resumen_Cliente_Vacío](manual/Resumen_Cliente_vacio.png "Fig. 8 Resumen de datos de cliente_2")

<br/>
<br/>
<br/>

### Carrito de compras

El carrito de compras está ubicado en la parte inferior de la columna a la derecha en la pantalla (Ver fig. 1). Muestra los productos -con sus opciones- que han sido seleccionados en la orden actual. Esta sección es fundamental en la colocación de órdenes ya que provee acceso a las siguientes funciones:


#### Solicitar el precio de la orden actual

Al presionar el link **$$$$** en la parte superior izquierda del carrito (Ver fig. 9) se envía una solicitud de precio a la tienda correspondiente.


#### Abandonar la orden

Si por alguna razón es necesario abandonar la orden sin ser completada, está disponible el link **Abandonar** (Ver fig. 9) que abre una ventana (popup) en la cual debe introducirse una razón del listado presentado y, como opción, escribir un comentario más detallado. Luego se presiona el botón "Cancelar orden" y la orden será abandonada.

**Nota:** para cerrar esta ventana sin abandonar la orden sólo hay que presionar la "x" en la esquina inferior derecha de la misma.


#### Acceder al checkout

Al presionar el link **Colocar** (Ver fig. 9) se accede a la ventana de *Checkout* (Ve fig. 10). En la misma se presenta un resumen de datos de la orden y se provee acceso a la asignación de datos fiscales para la factura correspondiente. Estos datos son el RNC al que se adjudicará la factura; el tipo de comprobante fiscal a emitir en la factura; y un checkbox que permite indicar si se desea emitir la factura con comprobante distinto a *NCF para consumidor final*, esta casilla esta marcada como "Emitir factura con valor fiscal".

Luego de revisar que todo esté bien en la orden y asignar los datos fiscales correspondientes, y una vez verificado el pago (cuando aplique), se debe presionar el botón "Completar" para colocar la orden. Una vez se presione este botón la orden será colocada a la tienda correspondiente.

Si se desea cerrar esta ventana e cualquier momento sin colocar la orden, sólo debe presionarse la "x" en la parte inferior derecha de la misma.

**Notas:** 

Si se marca la casilla (checkbox) "Emitir factura con valor fiscal", debe haberse seleccionado un NCF en el listbox correspondiente.

La verificación del pago es hecha a través de medios externos a la aplicación y es responsabilidad de los usuarios.


#### Acceder a listado de productos de la tienda seleccionada

Una vez se introducen productos en el carrito, el ID y el nombre de la tienda de donde se seleccionaron los mismos aparece en el carrito en la segunda línea (Ver fig. 9). Esta información sobre la tienda es a la vez un link, al presionarlo se nos dirigirá al listado de productos de la misma.

**Nota:** No es posible introducir productos de más de una tienda en la misma orden.


#### Establecer el modo de servicio

Al lado de la información sobre la tienda en el carrito (Ver fig. 9) aparece un link que nos permite elegir el modo de servicio correspondiente a la orden: *Carryout* (el cliente recogerá la orden en la tienda); *Delivery* (se le entregará la orden al cliente en su casa); o *DineIn (El cliente comerá lo que ordenó en el restaurante). Cuando no hay ningún modo de servicio seleccionado, este link está marcado como "Modo de servicio"; una vez se elige el modo de servicio este link está marcado con el modo de servicio seleccionado. Al hacer click sobre el link de modo de servicio se abre la ventana (popup) de selección de modo de servicio, esta ventana presenta un listbox con los modos de servicio disponibles y un botón "Guardar" para seleccionar el modo especificado. Si se desea cerrar esta ventan sin cambiar el modo de servicio, sólo hay que presionar la "x" en la parte inferior derecha de la misma.

**Nota:** No es posible colocar una orden sin seleccionar un modo de servicio.


#### Editar la selección de productos

En el carrito se muestran todos los productos seleccionados en la orden actual. Al lado del nombre del producto (Ver fig. 9) hay un cuadro indicando la cantidad que hay en la orden de ese producto; la cantidad deseada se puede modificar cambiando el número en este cuadro y presionando "Enter" en el teclado. Debajo de cada producto está la opción "Retirar", al hacer click sobre esta opción automáticamente se retira de la orden cualquier cantidad que haya de este producto en el carrito. 

Para los productos con opciones disponibles, se muestra debajo de cada producto el link "opciones" (Ver fig. 9). Al presionar este se muestran/ocultan las opciones seleccionadas actualmente para el producto correspondiente. Si se desea cambiar las opciones sólo hay que hacer click sobre las opciones mostradas y se abrirá la ventana de edición de opciones de productos; una vez hecho los cambios deseados debemos presionar el botón "Guardar cambios" en la parte inferior de la ventana para hacer efectivos los cambios. Si no se quiere hacer ningún cambio o se desea cancelar los cambios realizados en la ventana de edición de opciones de productos, debemos presionar la "x" en el extremo inferior derecho de dicha ventana.

<br/>
**Figura 9**
![Carrito](manual/Carrito.png "Fig. 9 Carrito de compras")

<br/>

**Figura 10**
![Checkout](manual/Checkout.png "Fig. 10 Checkout")


<br/>
<br/>
<br/>
<br/>


## II. Administradores


Los administradores tienen la posibilidad de agregar/modificar/eliminar datos de clientes en la base de datos; agregar/eliminar/modificar datos de las tiendas; editar las opciones de las categorías de productos; agregar/modificar/eliminar agentes de la base de datos; agregar/eliminar razones; agregar/modificar/eliminar direcciones; visualizar información sobre cupones; importar datos de RNC; y editar la configuración del sistema. Un administrador tiene acceso a las siguientes secciones de la aplicación que se muestran en la parte superior de la pantalla:


### Dashboard

Actualmente (En la Etapa 1 de KPiQ@25), esta sección muestra información sobre las órdenes más recientes y los nuevos clientes que han sido agregados a la base de datos.

<br/>
<br/>
<br/>


### Clientes


Presenta un listado paginado de todos los clientes registrados en la base de datos del sistema y un breve resumen de los datos correspondientes a los mismos. Provee acceso a las siguientes funciones:


1\.	**Buscar clientes en la base de datos**

Al introducir datos en el filtro a la derecha de la pantalla (ver Fig. 11 Listado de clientes) y presionar el botón "Filtrar" se despliega un listado con los clientes registrados en la base de datos cuya información coinciden con los datos introducidos en el filtro.


2\. 	**Acceder a la Sección de Gestión de clientes**

Al hacer *click* sobre el link "Mostrar" a la derecha de un cliente (ver Fig. 11 Listado de clientes) se accede a la sección de gestión de clientes donde se muestran los datos de uso del cliente en cuestión y se accede a varias funciones.


3\.	**Acceder al Formulario de edición de datos de clientes**

Al hacer *click* sobre el link "Editar" a la derecha de un cliente (ver Fig. 11 Listado de clientes) se accede a la sección de gestión de clientes. Esta página permite modificar los datos personales de un cliente en particular, agregar/remover números de teléfono, y agregar/remover direcciones. Luego de efectuadas las modificaciones de lugar debe presionarse el botón "Actualizar clientes" al final del formulario para que los cambios sean registrados en la base de datos. Si se desea cancelar los cambios efectuados sólo hay que presionar el botón "Cancelar" al final del formulario.


4\. 	**Agregar nuevos clientes a la base de datos**

Al presionar el botón "Agregar cliente" en la parte superior derecha de la página (ver Fig. 11 Listado de clientes) se accede al formulario de nuevo cliente donde se introducen los datos para crear nuevos clientes.


<br/>
**Figura 11**
![Adm_Clientes](manual/Adm_Clientes.png "Fig. 11 Listado de clientes")


#### Sección de Gestión de clientes

Desde esta sección es posible acceder a las siguientes funciones:


1\. 	**Visualizar el historial de órdenes de un cliente**

Se presenta automáticamente en la parte superior de la sección de gestión de clientes. En este historial se encuentran paginadas todas las órdenes colocadas correspondientes a un cliente en particular. Aquí pueden visualizarse el número (ID) de las órdenes, el estado de las órdenes, la fecha de inicio de las órdenes, el monto de las órdenes.


2\.	**Visualizar un listado de las direcciones relacionadas con el cliente en la base de datos**

Se presenta automáticamente debajo del *historial de órdenes*.


3\. 	**Visualizar, agregar y eliminar comentarios relativos a los clientes**

Los comentarios introducidos en el pasado por otros agentes y por el mismo agente que accede a esta sección son presentados automáticamente debajo del historial de órdenes. Para agregar comentarios sólo hay que escribir los mismos en el cuadro de texto provisto con estos fines y presionar el botón "Crear comentario". Si se quiere eliminar un cometario existente se debe presionar el link "Eliminar" debajo del comentario correspondiente.


4\. 	**Acceder al formulario de edición de datos de clientes**

Al presionar el botón "Editar *Nombre de Cliente*", ubicado en la parte superior derecha de la página, se accede a este formulario. (Ver *3. Acceder al Formulario de edición de datos de clientes*, un poco más arriba en este documento).


5\.	**Asociar RNC existentes en la base de datos a un cliente:**

A la derecha de la página aparece un resumen de los datos de cliente. En la sección inferior de esta columna está el link "Asociar número fiscal (RNC)*, al presionar este link se abre una ventana (popup) que permite introducir un número de RNC en la caja de texto provista. Una vez introducido este número debe validarse en la base de datos presionando "Validar" al lado del número, si el número es validado el nombre correspondiente se presentará debajo del número introducido, y al presionar el botón "Asociar" el RNC será asociado al cliente en cuestión y aparecerá en el área de datos fiscales del cliente (Parte inferior de la columna de la derecha).

*Nota:* Si se desea abortar la operación una vez abierta la ventana de asociación de RNC y antes de guardar los cambios, se debe presionar la "x" en la parte inferior derecha de esta ventana.

<br/>
**Figura 12**
![Adm_Gestión_Clientes](manual/Gestion_Clientes.png "Fig. 12 Gestión de clientes")


### Tiendas

Presenta un listado paginado de las tiendas disponibles e información relativa a las mismas. Permite filtrar por ciudad las tiendas mostradas en el listado al clickear sobre el nombre de la ciudad en la parte superior del mismo. Además permite ordenar el listado en base a cualquier campo de los datos de tienda al clickear sobre el encabezado de la columna correspondiente. 

A la derecha de cada tienda en el listado de tiendas hay varios links que proveen acceso a diferentes funciones:

1\. 	**Mostrar:** Lleva a la página de gestión de tiendas correspondiente a los clientes asignados a las tiendas. Aquí se muestra un listado de todos los clientes que están asignados a una tienda en particular.

2\. 	**Productos:** Provee acceso al listado de productos correspondiente a la tienda en cuestión. Más adelante explicaremos las funciones disponibles en la sección "Listado de productos".

3\. 	**Editar:** Provee acceso a la página de gestión de tiendas correspondiente a la edición de datos de tiendas. Desde aquí se puede editar los datos correspondientes a una tienda en particular.

**Nota:** Los campos TiendaID e IP son necesarios para la comunicación con las tiendas, los cambios en estos campos pudieran ocasionar problemas de comunicación. El ID de tienda debe ser exactamente el mismo especificado en la máquina de Pulse de cada tienda. El IP especificado aquí es el que se usará para comunicarse con la tienda y colocar las órdenes.

4\. 	**Eliminar:** Elimina la tienda seleccionada de la base de datos.


En la sección de Tiendas también está disponible la función de agregar tiendas, para acceder a la misma sólo hay que presionar el botón "Agregar tienda" que nos dirigirá al formulario de nuevas tiendas, introducir los datos correspondientes a la nueva tienda, y presionar el botón "Crear tienda" al final del formulario.

<br/>
**Figura 13**
![Adm_Tiendas](manual/Adm_Tiendas.png "Fig. 13 Listado de tiendas")


#### Listado de productos

Muestra un listado paginado de todos los productos que se venden en una tienda en particular y muestra datos específicos concernientes a los productos como: *Categorycode*, *Productcode*, *Productname*, *Opciones*, y *Disponibilidad*; este último campo muestra si el producto está o no disponible en la tienda en cuestión; para los productos que no están disponibles se muestra cuánto tiempo hace que no lo están bajo la columna *No disponible desde*. Se puede filtrar por categorías el listado de productos al clickear sobre el nombre de la categoría deseada en la fila ubicada encima del listado.

Este listado provee al administrador la funcionalidad de deshabilitar en el sistema ciertos productos que no estén disponibles en una tienda en particular. Para hacer esto sólo hay que presionar el link "deshabilitar" a la derecha del producto en cuestión, bajo la columna *Cambiar*. Si el producto estuviera deshabilitado y se deseara hacerlo disponible, sólo habría que presionar el link "habilitar" que aparece a la derecha del producto, bajo la columna *Cambiar*. 

**Nota:** En el caso de deshabilitar productos que son opciones o complementos de otros productos, aparecerá la notificación "Faltan complementos" bajo la columna *Disponibilidad* en los productos afectados por el cambio. Si un agente seleccionara uno de estos productos afectados, el sistema generará una alerta y solicitará confirmación de que igual se desea incluir a la orden el producto con complementos o ingredientes faltantes.

<br/>
<br/>
<br/>

### Categorías

Esta sección permite editar las opciones disponibles para las distintas categorías de productos. En el listado que se muestra hay tres columnas: 

*	La primera, llamada *Nombre*, muestra los nombres de las categorías de productos; 

*	La segunda, llamada *Tiene opciones*, permite establecer en el sistema si cierta categoría permitirá o no asignarle opciones a los productos (customizar) que pertenezcan a la misma. Por ejemplo, la categoría de productos *Drinks* no debe tener opciones habilitadas (debe decir *NO*) pues no hay nada que customizarle a los productos que pertenecen a esta categoría. En cambio la categoría *Pizza* sí debe tener opciones habilitadas (debe decir *SI*) pues el cliente final debe tener la posibilidad de decidir qué ingredientes tendrá su pizza;

*	La tercera, llamada *Las opciones son unidades*, permite indicar cómo se manejan las opciones para los productos que pertenecen a categorías que tienen habilitadas las opciones (dice *SI* en la columna anterior). Por ejemplo, Las ensaladas tienen opciones que se manejan en unidades (un aderezo César, tres aderezos Blue Cheese, etc.), por tanto en esta columna debe decir *SI* para la categoría *Ensaladas*. Ahora bien, los calzones tienen opciones que no se miden en unidades (un pepperoni, 5 jamones) sino que sólo se seleccionan con cantidades relativas (Poco queso, extra Salchicha italiana), por tanto la categoría *Calzones* debe decir *NO* en esta columna.

**Nota:** Los cambios en esta sección se guardan automáticamente, es decir, inmediatamente se hace click sobre los campos editables del listado, estos cambian y los cambios se hacen efectivos al instante.

<br/>
<br/>
<br/>

### Agentes

En esta sección se muestra un listado paginado de todos los agentes registrados en el sistema y un resumen de los datos correspondientes a los mismos. Desde aquí se pueden ejecutar las siguientes funciones sobre los agentes:

1\. 	**Mostrar historial de órdenes:** Se accede a través del link "Mostrar" a la derecha del agente seleccionado (ver Fig. 14 Listado de agentes). Aquí se presenta un listado paginado de las órdenes colocadas por un agente en particular.


2\. 	**Editar datos de agente:** Se accede a través del link "Editar" a la derecha del agente seleccionado (ver Fig. 14 Listado de agentes). En este formulario sólo hay que cambiar el contenido de los campos seleccionados y presionar el botón "Actualizar agente" al final del formulario. Para establecer si el agente es o no administrador sólo hay que marcar o no el checkbox "Administrador" en el formulario.

3\. 	**Eliminar agente:** Para eliminar un agente determinado de la base de datos, sólo hay que hacer click sobre el link "Eliminar" a la derecha del agente en cuestión (ver Fig. 14 Listado de agentes).

4\. 	**Agregar agentes:** Se accede a través del botón "Agregar agente" en la parte superior derecha de la pantalla (ver Fig. 14 Listado de agentes). Al presionar este botón se presenta un formulario de datos de nuevos agentes y, una vez completado este formulario, se presiona el botón "Crear agente" al final del formulario para guardar los datos. Si se desean ignorar los campos introducidos se debe presionar el botón "Cancelar" al final del formulario.

La contraseña inicial es establecida en este formulario y debe ser dada a conocer al agente, quien la cambiará al iniciar por primera vez una sesión.

Para establecer si el nuevo agente es o no administrador debe usarse la casilla "Administrador" ubicada en la parte inferior del formulario.

<br/>
**Figura 14**
![Adm_Agentes](manual/Adm_Agentes.png "Fig. 14 Listado de agentes")

### Razones

Es esta sección se gestionan las razones preestablecidas en el sistema para el abandono o cancelación de órdenes iniciadas por los agentes. En esta sección es posible ejecutar las siguientes funciones:

1\.	**Agregar razones:** Para agregar una razón hay que agotar tres pasos; primero debe establecerse el estado de la orden (Abandoned = Abandonada; Completed_externally = Completada fuera del sistema) al que se corresponderá la razón a agregar en el listbox colocado con esos fines al principio del formulario; segundo debe escribirse la descripción de la razón en el cuadro de texto correspondiente; y por último presionar el botón "Crear razones de cambio" al final del formulario.

2\.	**Visualizar órdenes correspondientes a las razone establecidas:** Para visualizar las órdenes abandonadas o completadas externamente para las cuales se ha establecido una determinada razón en el sistema sólo hay que presionar el link "Mostrar" a la derecha de la razón seleccionada (ver Fig. 15 Gestión de razones).

3\.	**Eliminar razones existentes:** Si se desea eliminar del sistema alguna de las razones establecidas se debe presionar el botón "Eliminar" a la derecha de la razón que se desea eliminar (ver Fig. 15 Gestión de razones).

<br/>
**Figura 15**
![Adm_Razones](manual/Adm_Razones.png "Fig. 15 Gestión de razones")


### Direcciones

Esta es la sección de gestión de direcciones registradas en el sistema. Esta sección está dividida en tres páginas distintas:

1.	Listado de ciudades

2.	Listado de sectores

3. 	Listado de calles


#### Listado de Ciudades

Presenta un listado paginado de las ciudades existentes en la aplicación. Provee acceso a las siguientes funciones:

A.	**Crear ciudades:** Si se desea "crear" una nueva ciudad en la base de datos de la aplicación sólo hay que introducir el nombre de la nueva ciudad en la caja de texto correspondiente y presionar el botón "Crear ciudad".

B.	**Acceder al listado de sectores correspondiente a una ciudad determinada:** Al presionar el link "Sectores" en la fila correspondiente a una ciudad en el listado, se accede al *Listado de Sectores* que pertenecen a esa ciudad.

C.	**Acceder al listado de tiendas por ciudad:** Desde el listado de ciudades se puede acceder al *Listado de Tiendas* filtrado con respecto a una ciudad determinada al presionar el link "Tiendas" en la fila de la ciudad correspondiente. (Ver sección **Tiendas** más arriba en este documento).

D. **Editar el nombre de la ciudad:** Al hacer click sobre el nombre de una ciudad del listado, se abre una caja de edición de texto. Luego de realizar las ediciones correspondientes se guardan los cambios presionando *Enter* en el teclado.

E. **Eliminar ciudades:** Si se desea eliminar una ciudad de la base de datos de la aplicación es necesario presionar el botón "Eliminar" en la fila correspondiente a la ciudad que se desee eliminar.


#### Listado de Sectores


Presenta un listado paginado de los sectores correspondientes a una ciudad determinada. Provee acceso a las siguientes funciones:

A. **Volver al listado de Ciudades:** Presionar el botón "Atrás" en la parte superior derecha de la página.

B. **Crear sectores:** Para crear sectores sólo es necesario escribir el nombre del sector en la caja de texto provista, seleccionar la ciudad y la tienda a la que corresponde el mismo en los listbox correspondientes, y presionar el botón "Crear sector".

C. **Acceder al listado de calles correspondientes a un sector determinado:** Al presionar el link "Calles" a la derecha de cualquier sector, se accede al *Listado de Calles* correspondiente a ese sector.

D. **Editar el nombre de un sector:** Al hacer click sobre el nombre de un sector del listado, se abre una caja de edición de texto. Luego de realizar las ediciones correspondientes se guardan los cambios presionando *Enter* en el teclado.

E. **Eliminar un sector:** Para eliminar un sector de la base de datos sólo hay que presionar el link "Eliminar" en la fila que corresponde al sector que se desea eliminar.


#### Listado de Calles

Presenta un listado paginado de las calles correspondientes a un sector determinado. Provee acceso a las siguientes funciones:

A. **Volver al listado de Sectores:** Presionar el botón "Atrás" en la parte superior derecha de la página.

B. **Crear calles:** Para crear calles sólo es necesario escribir el nombre de la calle a crear en la caja de texto provista, seleccionar el sector al que corresponde la misma en el listbox, y presionar el botón "Crear calle".

C. **Editar el nombre de una calle:** Al hacer click sobre el nombre de una calle del listado, se abre una caja de edición de texto. Luego de realizar las ediciones correspondientes se guardan los cambios presionando *Enter* en el teclado.

D. **Eliminar un sector:** Para eliminar un sector de la base de datos sólo hay que presionar el link "Eliminar" en la fila que corresponde al sector que se desea eliminar.

<br/>
<br/>
<br/>

### Cupones

Presenta un listado paginado de los cupones existentes en la base de datos con información correspondiente a los mismos. Esta sección permite ejecutar las siguientes funciones:

A. **Establecer disponibilidad de un cupón en el sistema:** Al presionar el campo bajo la columna "Disponibilidad" en la fila correspondiente a un cupón (ver Fig. 15 Gestión de cupones) este se habilita/deshabilita. Un cupón deshabilitado no aparecerá en la lista de cupones disponibles para los agentes. El texto en rojo bajo esta columna indica que el cupón está deshabilitado.

B. **Acceder al listado de productos de cupones:** Al presionar el link "Productos" a la derecha de la fila correspondiente a un cupón (ver Fig. 15 Gestión de cupones), se accede al listado de productos de cupones donde se muestra un listado con los *Target_products* correspondientes a un cupón determinado (el seleccionado). Este listado es informativo pues sólo muestra la información proveniente de *Pulse* y no permite ninguna gestión.

C. **Si se desea conocer los *Acceptable_products*** (productos que se aceptan en el sistema como parte del cupón) que  corresponden a un *Target_product* en particular, sólo hay que presionar el link "Aceptables" a la derecha del *Target_product* en cuestión en el listado d productos de cupones (ver Fig. 15 Gestión de cupones).

<br/>
**Figura 16**
![Adm_Cupones](manual/Adm_Cupones.png "Fig. 16 Gestión de cupones")

### Números Fiscales

Esta sección permite gestionar la tabla de RNC válidos existente en la base de datos del sistema. Presenta un listado paginado con todo los RNC's que existen en la tabla actual y permite consultas sobre la misma a través de los filtros a la derecha de la página.

Por otro lado, esta sección permite cargar la base de datos una nueva lista de RNC válidos obtenida de la DGII. Para hacer esto sólo hay que presionar el botón "Choose file" o "Browse" o "Buscar" (depende del navegador de Internet que usemos), seleccionar el archivo deseado existente en nuestro computador, y presionar el botón "Enviar".

*Nota:* El archivo a importar debe estar en formato .csv ó .txt, separado por pipetas, y puede o no estar comprimido (.ZIP). En caso de que esté comprimido, el archivo comprimido sólo debe contener el archivo de RNC.

<br/>
<br/>
<br/>

### Configuración

Permite modificar la configuración avanzada de la aplicación. Para cambiar cualquiera de estos valores sólo hay que hacer click sobre el valor actual de un campo y se abrirá una caja de edición de texto, una vez realizadas las modificaciones deseadas se debe presionar "Enter" en el teclado para hacer los cambios efectivos.

**Nota:** Modificar estos valores puede causar malfuncionamiento en la aplicación o que la aplicación deje de funcionar por completo. Estas modificaciones deben ser hechas por personal cualificado.

Los primeros tres valores mostrados, son correspondientes a la configuración para la comunicación con Pulse. A continuación explicamos los últimos dos valores:

*PRICE\_STORE\_IP* Este es el IP de la tienda por defecto a la que se solicitará precio si la tienda a la que se pone la orden no está disponible.

*SESSION\_TIMEOUT* Si durante el tiempo (en minutos) establecido aquí no hay ninguna actividad en la sesión de un agente, la sesión se cerrará y el agente tendrá que volver a introducir su usuario y contraseña.
