#Manual de usuario Domino's Contact Center - KPiQ@25


##Introducción

Este manual explica el funcionamiento y modo de uso de las distintas herramientas disponibles en la aplicación del Contact Center de Domino's Pizza Dominicana. El manual está dividido en dos secciones:

1. 	*Agentes:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios básico (Agentes). Esta parte es la que necesitan la mayor parte de los usuarios.

2. 	*Administradores:* Explica el uso de las funciones disponibles para los usuarios con nivel de privilegios de administrador (Supervisores). Esta parte es necesaria para los usuarios con elevado nivel de acceso a la aplicación.



##Descripción:

La aplicación del Contact Center de Domino's Pizza Dominicana - KPiQ@25 es una aplicación WEB (accedida a través de un programa de navegación WEB), que tiene como objetivo principal proveer a través de un programa informático las herramientas necesarias para la venta vía telefónica de los productos de Domino's Pizza Dominicana, y la supervisión y gestión de las operaciones del Contact Center.

KPiQ@25 está diseñado para que un agente, conociendo el menú de productos ofertados por Domino's Pizza Dominicana y teniendo un conocimiento básico del manejo de un computador, sea capaz de colocar una orden de compra a solicitud de un cliente vía telefónica. Para lograr este objetivo la aplicación consta de varias secciones (o páginas) de fácil acceso y operación que procederemos a explicar detalladamente más adelante.

El ambiente de trabajo de los administradores está dividido en tres partes:

>1\. 	En la parte superior está en azul la **barra de menú**. Esta lista y provee acceso a las distintas secciones disponibles según el nivel de privilegio del usuario actual.   
>    
>2\. 	Justo debajo de la barra de menú y en color gris encontramos la **barra de menú secundario**. Esta se hace visible cuando se selecciona una opción en la bara de menú que a su vez tiene subsecciones. Esta barra muestra distintas opciones adicionales de menú dependiendo de la sección de menú que esté seleccionada en el momento.
>
>3\.	Debajo de las barras tenemos entonces la *ventana de trabajo* cuyo contenido y opciones disponibles dependerán de las opciones de menú seleccionadas.


Cada una de estas partes del ambiente de trabajo contiene información importante y provee acceso a distintas funciones que serán descritas en lo adelante.

En caso de errores, se presentará un mensaje en una barra verde en la parte superior de la pantalla. Estos mensajes desaparecen al hacer click sobre ellos.

Para poder usar la aplicación, los usuarios tendrán que iniciar sesión (login) en el sistema proveyendo su nombre de usuario y contraseña. Una vez hecho esto, podrán acceder a todas las funciones de la aplicación según su nivel de privilegios. Si desean cerrar su sesión sólo deben presionar el link logout que está siempre visible en el extremo superior derecho de la ventana, junto al nombre de usuario.


## II. ADMINISTRADORES


Los administradores tienen la posibilidad de agregar/modificar/eliminar datos de clientes en la base de datos; agregar/eliminar/modificar datos de las tiendas; editar las opciones de las categorías de productos; agregar/modificar/eliminar agentes de la base de datos; agregar/eliminar razones; agregar/modificar/eliminar direcciones; visualizar información sobre cupones; importar datos de RNC; y editar la configuración del sistema. Un administrador tiene acceso a las siguientes secciones de la aplicación que se muestran en la parte superior de la pantalla:


### Dashboard

Esta sección muestra información de ranking por agentes y por tienda para la última hora y el acumulado del día.

Con el fin de presentar la información deseada, hay disponibles cajas de confirmación (checkboxes) para seleccionar entre las siguientes opciones:

1. Ranking de agentes por número de órdenes vendidas.
2. Ranking de agentes por monto promedio de órdenes.
3. Ranking de tiendas por número de órdenes vendidas.
4. Ranking de tiendas por monto promedio de órdenes.
5. Otros indicadores.

<br/>
<br/>
<br/>


### Órdenes


Permite visualizar y gestionar las órdenes colocadas a través del Contact Center. Las operaciones posibles sobre las órdenes son:

1\. *Consulta*. Muestra detalles correspondientes a la orden actual.

2\. *Archivar* Guarda las órdenes fuera de la bandeja primaria. Se accede marcando las órdenes deseadas y seleccionando "Mover a archivadas" en el listbox de la parte superior.

3\. *Eliminar* Hace que las órdenes no estén disponibles para consulta por parte de los agentes. Se accede marcando las órdenes deseadas y seleccionando "Mover a eliminadas" en el listbox de la parte superior.

4\. *Completar fuera de línea* Para las órdenes que no sea completadas por problemas de comunicación.

Se muestra un filtro n la parte superior del listado de órdens que permite filtrar las órdenes presentadas de acuerdo a los siguinetes criterios:

-Marcador asignado a la orden (Eliminadas, Archivadas, Críticas, Nuevas, Completadas fuera de línea)
-Nombre del agente que la creó.
-Número de teléfono del cliente.
-Fecha.


<br/>
<br/>
<br/>

### Productos

Esta sección permite gestionar todo lo relacionado a productos en la aplicación. Conta de las siguientes subsecciones:


#### Tiendas.

Despliega un listado de las tiendas existentes en el sistema. Permite agregar, eliminar o editar tiendas en la aplicación. Además permite establecer la no disponibilidd de determinado producto para una tienda específica al presionar el botón "Productos" al lado de la tienda correspondiente.

#### Categorías

Permite configurar el comportamiento de las distintas categorías en el Builder que manejan los agentes. Las opciones para cada categoría son:

1\. *Tiene opciones* establece si la categoría tiene o no opciones disponibles en el menú.

2\. *Opciones en unidades* Establece si las opciones de determinada categoría se manejan o no en unidades (Ej. Dipcups se manejan en unidades; pepperoni no se maneja por unidades).

3\. *Selección múltiple* Permite seleccionar productos mitad y mitad (Ej. Pizza mitad Italiana y mitad Veggie)

4\. *Selección de lados* Establece si se puede o no seleccionar en qué lado del producto se colocarán las distintas opciónes.

5\. *Oculta* Si esta opción tiene valor "True", la categoría no es visible para los agentes.

6\. *Producto base* Establece un producto base para cada categoría.


#### Cupones

Muestra un listado de los cupones existentes en la base de datos. Permite ver detalles sbre los cupones, marcar cupones como "Descontinuados", y eliminar cupones de la base de datos.


#### Importación

Permite importar Productos, Cupones y Números fiscales para grabarlos en la base de datos de la aplicación y poder hacer uso de los mismos.



<br/>
<br/>
<br/>

### Gestión

Esta sección permite gestionar los distintos aspectos de la aplicación que no están directamente relacionados a los productos. Consta de las siguinetes subsecciones:


#### Clientes

Presenta un listado paginado de los clientes existentes en la base de datos de la aplicación y permite acceso a las siguientes funciones:

1\. *Buscar clientes en la base de datos* Al introducir datos en el filtro a la derecha de la pantalla y presionar el botón "Buscar" se despliega un listado con los clientes registrados en la base de datos cuyos datos coinciden con los criterios introducidos en el filtro.

2\. *Acceder a la página de información del cliente* Se accede a esta presionando el botón "Detalles" al lado del cliente correspondiente. Una vez en esta página se puede: Visualizar el historial de órdenes del cliente; Editar los datos personales del cliente (haciéndo click sobre los datos a editar); Agregar y editar números de telefono; Agregar y editar direcciones de cliente.

3\. *Eliminar clientes de la base de datos* Presionando elbotón "Eliminar" a la derecha del cliente correspodiente.

4\. *Fusionar clientes* Se accede a esta función presionando el botón "Fusión de clientes" en la parte superior del listado de clientes. Al presionarlo, se inicia un "Wizard" para la fusión de los datos de dos clientes existentes en la base de datos, conservando un nombre, un apellido, y una cédula, para unir todo slos demás datos en un solo registro de cliente.


#### Direcciones

Permite visualizar en una estructura de arbol las direcciones existentes en la base de datos de la aplicación y permite establecer correspondencia entre Calles, Zonas y Ciudades, haciéndo "drag and drop" de las mismas.


#### Agentes

Provee acceso a distintas funciones de gestión sobre los agentes registrados en la base de datos: Agregar, Editar, Mostrar (visualizar información detallada), y Eliminar.


#### Razones

Permite visualizar, crear y editar las razones preestablecidas por las cuales lo agentes podrían solicitar la anulación de una orden o dejarla como incompleta.



#### Números fiscales

Presenta un listado paginado de los números fiscales registrados en la base de datos y permite hacer consultas sobre el mismo.


#### Comunicación

Establece los parámetros de comunicación de la aplicación con la tienda de precios, Pulse y las terminales de los agentes. **Nota:** Los cambios en esta sección pueden provocar malfuncinamiento de la aplicación o que la aplicación deje de funcionar en absoluto.

<br/>
<br/>
<br/>

### Reportes

Permite generar distintos reportes con indicadores de las operaciones del Contact Center y exportar dichos reportes en format PDF o CSV.

<br/>
