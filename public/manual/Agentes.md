#Manual de usuario Domino's Contact Center - KPiQ@25


##Introducción

Este manual explica el funcionamiento y modo de uso de las distintas herramientas disponibles en la aplicación del Contact Center de Domino's Pizza Dominicana. El manual está dividido en dos secciones:

1. 	*Agentes:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios básico (Agentes). Esta parte es la que necesitan la mayor parte de los usuarios.

2. 	*Administradores:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios de administrador (Supervisores). Esta parte es necesaria para los usuarios con elevado nivel de acceso a la aplicación.



##Descripción:

La aplicación del Contact Center de Domino's Pizza Dominicana - KPiQ@25 es una aplicación WEB (accedida a través de un programa de navegación WEB), que tiene como objetivo principal proveer a través de un programa informático las herramientas necesarias para la venta vía telefónica de los productos de Domino's Pizza Dominicana, y la supervisión y gestión de las operaciones del Contact Center.

KPiQ@25 está diseñado para que un agente, conociendo el menú de productos ofertados por Domino's Pizza Dominicana y teniendo un conocimiento básico del manejo de un computador, sea capaz de colocar una orden de compra a solicitud de un cliente vía telefónica. Para lograr este objetivo la aplicación consta de varias secciones (o páginas) de fácil acceso y operación que procederemos a explicar detalladamente más adelante.

El ambiente de trabajo está dividido en tres partes:

>1\. 	En la parte superior está en azul la **barra de menú**. Esta lista y provee acceso a las distintas secciones disponibles según el nivel de privilegio del usuario actual.   
>    
>2\. 	Justo debajo de la barra de menú y en color gris encontramos la **barra de opciones**. Esta estará siempre visible para los *agentes* y presenta de izquierda a derecha:
>
>>A. **Nombre del cliente actual y link a información del cliente** (para más información ver sección *Información de clientes* bajo *I. AGENTES*).
>>
>>B. **Selector de modo de servicio.** Permite seleccionar el modo de servicio (Delivery, Dinein, y Pickup) para la orden actual.
>>
>>C. **Selector de tienda.** Permite seleccionar la tienda a donde se enviará la orden actual.
>>
>>D. **Link a Checkout.** Provee acceso al checkout para colocar la orden actual.
>
>3\.	Debajo de las barras tenemos entonces la *ventana de trabajo* cuyo contenido y opciones disponibles dependerán de las opciones de menú seleccionadas.


Cada una de estas partes del ambiente de trabajo contiene información importante y provee acceso a distintas funciones que serán descritas en lo adelante.

En caso de errores, se presentará un mensaje en una barra verde en la parte superior de la pantalla. Estos mensajes desaparecen al hacer click sobre ellos.

Para poder usar la aplicación, los usuarios tendrán que iniciar sesión (login) en el sistema proveyendo su nombre de usuario y contraseña. Una vez hecho esto, podrán acceder a todas las funciones de la aplicación según su nivel de privilegios. Si desean cerrar su sesión sólo deben presionar el link logout que está siempre visible en el extremo superior derecho de la ventana, junto al nombre de usuario.

En general los pasos necesarios para la colocación de una orden en KPiQ@25 son los siguientes:

1. 	Selección del cliente
2.	Selección del modo de servicio
3. 	Selección de la tienda donde se colocará la orden
4. 	Selección de los productos a ordenar
5. 	(opcional) Selección de los cupones a aplicar
6. 	Checkout




##I. AGENTES

Los agentes tienen la posibilidad de crear clientes en la base de datos, modificar datos de clientes, colocar órdenes, visualizar información de cupones, y ver información sobre las órdenes que él mismo ha colocado. Un agente tiene acceso a las siguientes secciones de la aplicación que se muestran en la parte superior de la pantalla:


### Clientes

Es esta la sección por defecto a dónde la aplicación envía a los agentes al momento de iniciar su sesión. En ella se provee acceso a las funciones de **selección de clientes existentes** y **agregar nuevos clientes a la base de datos**. Esta sección presenta un formulario que en principio sólo permite introducir un número de teléfono y una extensión. Una vez introducido el número de teléfono la aplicación efectuará una de dos posibles operaciones:

>1\. Si el teléfono existe, se desplegara un listado de los récords que coincidan con los datos introducidos, de entre los cuáles se puede selccionar uno haciendo *click* sobre el mismo.

>2\. Si el teléfono no existe, y una vez se intrduzcan exactamente 10 dígitos en el campo correpondiente al teléfono, se desplegará el formulario de creación de clientes, donde se podrá introducir toda la información relacionada al cliente.

Funciones dipsonibles en esta sección:


1\.	**Buscar clientes en la base de datos**

Al introducir datos parciales en el campo *teléfono* del formulario de búsqueda se despliega un listado con los datos de clientes en la base de datos que coinciden con los introducidos. Ej. Para buscar un cliente con número telefónico 8095555555, se introduce "8095555555" en el campo teléfono del formulario y se selecciona el número y extensión correspondiente del listado desplegado.


2\. 	**Seleccionar clientes**

Al hacer *click* sobre un número mostrado en el listado, la aplicación solicita que se presione "Enter" para seleccionar el mismo. Una vez seleccionado su nombre se muestra en el extremo izquierdo de la *barra de opciones*.


3\. 	**Agregar nuevos clientes a la base de datos**

Cuando se introducen en el campo teléfono del formulario de clientes 10 dígitos que no corresponden a ninguno de los récords existentes en la base de datos, se despliega un formulario que permite el registro de los datos correspondientes al nuevo cliente. (Nota: los únicos campos obligatorios para agregar un clientes son *Nombre*, *Apellido*, y *Número de teléfono*). Una vez introducidos los datos correspondientes se debe hacer *click* sobre el botón "Agregar cliente" y confirmar, entonces el cliente se agregará a la base de datos de la aplicación.

<br/>
**Figura 1**
![Formulario_nuevo_cliente](manual/Formulario_nuevo_cliente.png "Fig. 1 Formulario nuevos clientes")

<br/>
<br/>

### Información de clientes

Se accede a esta sección haciendo click sobre el nombre del cliente (extremo izquierdo de la *barra de opciones*. Desde esta aquí es posible acceder a las siguientes funciones:


1\. 	**Visualizar el historial de órdenes de un cliente**

Se presenta automáticamente en la parte derecha de la *ventana de trabajo*. En este historial se encuentran paginadas todas las órdenes colocadas correspondientes a un cliente en particular. Aquí pueden visualizarse el número (ID) de las órdenes, el estado de las órdenes, la fecha de inicio de las órdenes, el monto de las órdenes.


2\.	**Edición de datos personales del cliente**

Disponible en el recuadro "Información del cliente".


3\. 	**Agregar y editar números de teléfono**

Funciones disponibles en el recuadro "Teléfonos".


4\. 	**Agregar y editar direcciones de cliente**

Funciones disponibles en el recuadro "Direcciones".



<br/>
<br/>


### Builder

Esta sección permite seleccionar de manera customizada los productos que se desean colocar en la orden. En la parte superior se presenta un listado con las categorías de productos disponibles, al clickear sobre una categoría se despliegan las opciones correspondientes a la misma (Especialidad, Flavor_code, Size_code, Options), luego de especificar las selecciones deseadas para cada campo se presiona el botón agregar en la parte superior y el producto es introducido a la orden.

Para los productos más simples solo hay que especificar una selección para uno o ambos de los campos **Sabores** (Flavor_code) y **Tamaños** (Size_code). Otras categorías de productos más complejas exigen que se especifique una o varias selecciones para el campo **Opciones** (Options), para estos casos hay varias posibilidades:

1\. *Opciones que son unidades*. Para estos casos sólo se especifica la cantidad en números enteros deseada para cada opción disponible en el recuadro correspondiente.

2\. *Opciones que no son unidades*. En este caso se especifica la cantidad relativa (nada, poco, normal, extra, etc.) que se desea para cada opción disponible mediante el listbox ubicado justo bajo el nombre de cada opción.

3\. *Opciones para categorías con lados*. Para las categorías aplicables, en cada opción disponible se presentará un selector con tres botones que indican **izquierda**, **todo el producto**, y **derecha** respectivamente. Justo debajo de los botones se encuentre el listbox para especificar la cantidad relativa deseada para cada opción.

4\. *Selecciones de mitad y mitad*. En los casos donde los productos permitan las selecciones "Mitad & Mitad", cada opción presentará dos listboxes justo debajo del nombre de la opción, cada uno de los listboxes corresponde a la cantidad realtiva de la opción correspondiente que se desea en el lado del producto que corresponde a la ubicación del listbox (en el listbox de la izquierda se selecciona la cantidad deseada a la izquierda del producto, el listbox de la derecha corresponde a la derecha del producto). Como una ayuda visual cada listbox tiene un color que corresponde a los colores que se asignan a cada una de las dos *Especialidades* seleccionadas (Azul y Rojo).

<br/>
**Figura 2**
![Builder](manual/Builder.png "Fig. 2 Builder")


### Carro de compras

El carrito de compras está ubicado a la derecha de la pantalla en la sección del *Builder*. Muestra los productos -con sus opciones- que han sido seleccionados en la orden actual. Esta sección es fundamental en la colocación de órdenes ya que provee acceso a las siguientes funciones:

1\. *Editar las cantidades de cada producto*. Al lado del nombre del producto (Ver fig. 3) hay un cuadro indicando la cantidad que hay en la orden de ese producto; la cantidad deseada se puede modificar cambiando el número en este cuadro y presionando "Enter" en el teclado. 

Debajo de cada producto hay un set de tres iconos que permiten las siguientes funciones: 

2\. *Retirar producto*. Retira el producto de la orden actual.

3\. *Ver opciones*. Despliega las opciones selecionadas para el producto.

4\. *Modificar*. Dirige a la categoría correspondiente en el builder con las opciones especificadas en el producto preseleccionadas y permite la edición de las selecciones hechas.


<br/>
**Figura 3**
![Carro_de_compras](manual/Carro_de_compras.png "Fig. 3 Carro de compras")


### Cupones

En la parte inferior del área de trabajo se presenta una pestaña que está siempre visible con el nombre *Cupones*. Al presionar esta pestaña se presenta el listado de cupones. Si se quiere agregar un cupón a la orden actual solo hay que hacer click sobre el mismo. Para ocultar denuevo la pestaña se debe hacer click sobre el botón ocultar en la parte superior derecha de la misma.


### Ayuda

Si se necesita la asistencia de un supervisor se puede solicitar mediante un sistema de chat disponible en una pstaña ubicada justo al lado de la de cupones descrita en el punto anterior.

### Checkout

Permite gestionar el pago y finalizar la orden. Esta sección presenta un resumen de la orden actual con posibilidad de editar cantidades y remover productos, además provee acceso al formulario de datos para el pago, el cual permite seleccionar un RNC de los registrados para el cliente actual y especificar el tipo de factura qeu se generará.

Permite además efectuar las siguientes acciones sobre la orden actual:

1\. *Completar* Coloca la orden en la tienda correspondiente y finaliza el porceso de tomade la orden actual.

2\. *Anular* Cierra la orden y la marca como anulada. Esta opción requiere la especificación de una razón y la autorización de un supervisor.

3\. *Dejar como incompleta* Abandona la orden y la deja incompleta en el sistema. Esta opción requiere la especificación de una razón.

4\. *Exonerar impuestos* Elimina el monto correspondiente a los impuestos en la orden actual. Esta opción requiere autorización de un supervisor.

<br/>
