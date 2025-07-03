#la gloria de gestion de datos por EL_KUELGE

#parciales_tomados_2020
#without_answers---------------------
El arbol B+ permite busquedas por rango con claves duplicadas
'SinRespuesta'

La implementacion de un hash permite obtener a partir de una entrada X una salida Y 
unica y reversible
'SinRespuesta'

Un Data Marts es una Datawarehouse afectado a un departamento o sector de la empresa
'Verdadero'

Un store procedure es un procedimiento asociado a una base de datos, mientras que 
un triger es un procedimiento asociado a una tabla
'Verdadero'

Si un arbol binario esta completo y balanceado todas las hojas estan en el mismo 
nivel 
'Falso'

Un arbol B es la tecnica de creacion de indices que debe utilizarse cuando no se 
tiene informacion del archivo a mantener ordenado
'Falso'

Una funcion en SQL es el equivalente a un Store Procedure con la diferencia que puede 
retornar valores o una tabla
'Falso'

Si el puntero Ledge de un nodo no es nulo, entonces el nodo es un minimal
'SinRespuesta'

Un grafo que posee n nodos y (n-1) arcos siempre es un arbol 
'Falso'

Arboles – Si un árbol de 50 nodos se implementa sobre una matriz de adyacencia 
la cantidad de posiciones ocupadas de la misma es de 49.
'Falso'

Arboles – El árbol B es más performante que el árbol B+ en el manejo de consultas por rangos
'Falso'

La ejecucion sin filas de resultado de una query dentro de un trigger genera la 
cancelacion de la transaccion
'Falso'

El Datamining es un conjunto de técnicas utilizadas para la exploración de un
Datawarehouse a efectos de encontrar información oculta relevante para la toma de decisiones
'Verdadero'

#with_answers---------------------

Un vector se puede utilizar para representar cualquier grafo restricto.  
'Verdadero'

Cuando un grafo no es unívoco, debe ser categorizado como un grafo irrestricto. 
'VERDADERO. DADO QUE PERMITE CUALQUIER TIPO DE RELACIONES'

Un motor de base de datos cuenta con su propio User Manager,File Manager y Disk mamager,por lo cual no tiene contacto con el sistema operativo sobre el cual corre. 
'FALSO. MAS ALLÁ DE TENER ESOS COMPONENTES REQUIERE COMUNICARSE CON EL SO PARA ACCEDER A LOS DISPOSITIVOS'

Las unicas restricciones posibles aplicables en el modelo relacional, son por tabla. 
'FALSO. POR EJ EXISTEN LAS RESTRICCIONES POR COLUMNA COMO EL NOT NULL Y LOS CHECK'

En la implementación de un Arbol B, todos los nodos de datos que contiene claves, se encuentran en el mismo nivel. 
'VERDADERO'

En una base de datos relacional, los indices garantizan la unicidad de claves. 
'FALSO. ESO LO REALIZAN LAS PK PUEDE HABER INDICES CON CLAVES DUPLICADAS'

A veces una Primary Key en una dentrode una Base de datos Relacional puede permitir valores repetidos. 
'FALSO'

Un grafo es biunivoco cuando tiene un solo predecesor y un solo sucesor . 
'VERDADERO'

Si un arbol binario esta completo y balanceado todas las hojas estan en el mismo nivel. 
'FALSO. PUEDE QUE NO TIENE QUE ESTAR PERFECTAMENTE BALANCEADO Y NO SOLO BALANCEADO.'

Las tecnicas más comunes utilizadas en datamining son las redes neuronales, los arboles de decision y las reglas de inducción. 
'VERDADERO , SON LAS TECNICAS QUE SE UTILIZAN'

Si en un arbol el subarbol derecho e izquierdo tienen la misma profundidad y la misma cantidad de elementos,entonces está perfectamente balanceado. 
'FALSO, TIENE QUE OCURRIR EN TODOS LOS NIVELES'

Cuando un grafo no es unívoco, debe ser categorizado como un grafo irrestricto.
'VERDADERO. DADO QUE PERMITE CUALQUIER TIPO DE RELACIONES'

En SQL, una subconsulta en el SELECT siempre debe retornar una fila y una columna. 
'VERDADERO'

El comando CHECK es una restricción al modelo . 
'VERDADERO'

El heap es un arbol n-ario el cual debe cumplir la norma de que el sea mayor que sus
hijos en todos los niveles
'Falso'

Si una columna posee la constraint UNIQUE, entonces una sola fila como maximo 
puede contener NULL en dicha columna
'Veradero'

Un arbol B o bien un B+ tiene un alto costo de mantenimiento, y por ello, implementa 
un factor de carga en cada nodo
'Verdadero'

Una foreign key FK es una relacion entre uno o mas campos de una tabla con uno o mas 
campos de otra de igual tipo.
'Falso'

Si en un arbol el subarbol derecho e izquierdo tienen la misma profundidad y la misma 
cantidad de elementos, entonces esta perfectamente balanceado.
'Falso'

Cuando un grafo no es univoco, debe ser categorizado como un grafo irrestricto
'Verdadero'

en SQL, una subconsulta en el SELECT siempre debe retornar una fila y una columna 
'Verdadero'

El comando check es una restriccion al modelo
'Verdadero'

A veces una primary key PK en una tabla dentro de una base de datos relacional puede 
permitir valores repetidos
'Falso'

En una base de datos relacional, los indices garantizan la unicidad de claves 
'Falso'

En la implementacion de un Arbol B, todos los nodos de datos que contienen claves 
se encuentran en el mismo nivel
'Verdadero'

La cantidad de nodos de un arbol de expresion siempre es par 
'Falso'

Si un arbol binario esta completo y balanceado todas las hojas estan en el mismo nivel 
'Falso'

Una subconsulta en el HAVING, siempre debe retornar una fila y una columna 
'Falso'

La ejecucion sin filas de resultado de una query dentro de un trigger genera la 
cancelacion de la transaccion
'Falso'

El barrido de pre orden se puede hacer en todo tipo de arboles pero el simetrico 
es solo para arboles binarios
'Verdadero'

Todo grafo de grado 2 es un árbol binario 
'Verdadero'

Un vector se puede utilizar para representar cualquier grafo restricto
'Verdadero'

Una tabla sin Primary Key no puede tener una Foreign Key 
'Falso'

Un Data Marts es un Datawarehouse afectado a un Departamento o sector de la empresa
'Verdadero'

Solo los arbolines binarios perfectos son balanceados
'Falso'

En ambos es O(n.logn)
'Verdadero'

__________________________________________________________________________________
#desarrollables

'Un grafo se define como G(V, A) donde V es el conjunto de vértices (o nodos) y A el conjunto de aristas'
'que las une. Un grafo sirve para modelizar problemas matemáticos, el más conocodi: el problema del viajero '
'que aún no tiene solución por ser de complejidad NP.'
Su clasificación puede ser por restricción:
- Restrictos: Solo pueden modelizar relaciones que cumplan las propiedades de de transitividad, simetría y reflexividad
- Irrestrictos: Pueden modelizar cualquier tipo de relación sin importar las restrcciones arriba mencionadas
Por su direccionalidad.
- Dirigidos: Las aristas que unen los vértices tienen un sentido de recorrido, eso significa que no son bidireccionales.
- No dirigidos: Las aristas pueden ser recoridas en un sentido o el otro y ambas son válidas.
Hay problemas de la realidad donde es necesario grafo dirigido y otros que no. Ninguno es 'mejor' que el otro 
La representación computacional puede ser estática o dinámica.
Las representaciones estáticas pueden ser:
Matriz de adyacencia: Conecta vertice con vertice, como resultado resulta en una matriz de nxn siendo n el numero de vertices. Es muy ineficiente en espacio porque su tamaño es fijo y es funcion de la cantidad de vertices n (nxn)
Matriz de Incidencia: Las filas son vertices y las columnas aristas. Si el grafo es no dirigido contiene como máximo dos 1
por columna. Es de tamaño fijo nxm siendo n los vertices y m las aristas. Ineficiente como la anterior para grafos dispersos

Las dinámicos suelen representarse en:
Listas de adyacencia: Cada vertice es un nodo con una lista de adyacencia asociada a él. De esta forma el tamaño 
crece dinámicamente conforme aumentan los caminos entre vertices. Es más eficiente en terminos de complejidad espacial porque no 
guarda datos sobre vertices no conectados (a diff de la las repr. estaticas)
Listas de Graal: Es una mejora de las listas de adyacencia que utiliza punteros para optimizar el uso de la memoria. También 
consiste en un nodo con un puntero a una lista de nodos a los cuales puede ir este vertice. Si es un grafo no dirigido, 
el vertice destino tambien va a tener al propio en su lista de adyacencia (o un puntero a el)
Representación de Platz: Utiliza structs para representar un nodo con su informacion y un puntero al siguiente nodo, tien otro struct 
para representar la arista y de donde viene y hacia donde va (y un puntero a la siguiente arista)

'Describa la búsqueda de una clave única en un árbol B.'

La búsqueda de una clave única en un árbol B consiste en ubicarse en el nodo raíz del árbol, si la clave se encuentra ahí se termina la búsqueda, caso contrario, se selecciona entre los hijos al que se encuentra entre dos 
valores de clave que son menor y mayor que el buscado respectivamente y se repite el proceso hasta encontrarlo.
En el caso que se llegue a una hoja y no pueda continuar la búsqueda de la clave, entonces esa clave no se encuentra en el árbol.
Enumerando, los pasos a seguir son:
Seleccionar como nodo actual la raíz del árbol. Si el árbol está vacío la búsqueda falla.
Comprobar si la clave se encuentra en el nodo actual:
Si la clave está presente, se termina la búsqueda.
Si la clave no está presente, hay 3 posibilidades a considerar: 

    • Si el elemento x a buscar es menor que K1(clave) , entonces se continúa buscando en el subárbol T0 .

    • Si x es más grande que K n-1 , se continúa buscando en el subárbol Tn-1 .

    • Si existe un i tal que 1 ≤ i ≤ n - 1 para el cual K i ≤ x ≤ K i+1 entonces se continúa buscando en el árbol Ti .

'Qué beneficios brinda la aplicación de la normalización a diseñó de un modelo de bases de datos?'
La normalización evita todo tipo de redundancias (duplicaciones de datos) y a su vez, evita problemas de actualización de los datos en la tabla y protege 
la integridad de los mismos evitando o reduciendo anomalías en la manipulación de datos; dejando de esta forma datos precisos, únicos y relevantes según las 
necesidades del sistema. Al disminuir el volumen de los datos, facilita y agiliza notablemente el acceso, el mantenimiento y consultas a los mismos. 
También reduce el impacto de los cambios en los datos.

'La tabla de hechos en una arquitectura de Data Warehouse contiene información primaria del dominio del negocio.'
Nro de cliente, edad, ingresos, variando según las necesidades de los sujetos que van a consumir la base.
Contiene las primary keys a partir de las cuales cada dimension table se joinea para explotar un aspecto del negocio.
Cada tabla de dimensión explota un aspecto de esos datos ofreciendo consultas históricas, que permiten consumir los datos de forma exploratoria sin tener que pensar querys sql, ver si compilan, etc. Esto es porque el concepto de Data warehouse está orientado al sujeto, a ayudarlo a que tome decisiones y pone énfasis en la historia de las operaciones por lo cual se dice que es variante en el tiempo, de modo que es posible reconstruir hechos a partir de la información contenida. Otra característica importante es la de integración, al ser una recolección de distintas fuentes de información (BD SQL, NOSQL, archivos..) debe consolidar la información de forma consistente para poder explorarla. 
En su origen tenía una implementación no SQL, pero las grandes companías de bases de datos vieron el nicho y agregaron soporte para este tipo de bases de datos multidimensionales.
Otra diferencia importante con las bases de datos operacionales es que la información aquí no está normalizada, porque su objetivo no es la performance, sino ofrecer información al cliente que le sirve para el desarrollo de su negocio

La representación computacional puede ser estática o dinámica.
Las representaciones estáticas pueden ser:
Matriz de adyacencia: Conecta vertice con vertice, como resultado resulta en una matriz de nxn siendo n el numero de vertices. Es muy ineficiente en espacio porque su tamaño es fijo y es funcion de la cantidad de vertices n (nxn)
Matriz de Incidencia: Las filas son vertices y las columnas aristas. Si el grafo es no dirigido contiene como máximo dos 1
por columna. Es de tamaño fijo nxm siendo n los vertices y m las aristas. Ineficiente como la anterior para grafos dispersos

Las dinámicos suelen representarse en:
Listas de adyacencia: Cada vertice es un nodo con una lista de adyacencia asociada a él. De esta forma el tamaño crece dinámicamente conforme aumentan los caminos entre vertices. Es más eficiente en terminos de complejidad espacial porque no guarda datos sobre vertices no conectados (a diff de la las repr. estaticas)
Listas de Graal: Es una mejora de las listas de adyacencia que utiliza punteros para optimizar el uso de la memoria. También consiste en un nodo con un puntero a una lista de nodos a los cuales puede ir este vertice. Si es un grafo no dirigido, el vertice destino tambien va a tener al propio en su lista de adyacencia (o un puntero a el)
Representación de Platz: Utiliza structs para representar un nodo con su informacion y un puntero al siguiente nodo, tien otro struct para representar la arista y de donde viene y hacia donde va (y un puntero a la siguiente arista)

b. La tabla de hechos en una arquitectura de Data Warehouse contiene información primaria del dominio del negocio.
 Nro de cliente, edad, ingresos, variando según las necesidades de los sujetos que van a consumir la base.
 Contiene las primary keys a partir de las cuales cada dimension table se joinea para explotar un aspecto del negocio.
Cada tabla de dimensión explota un aspecto de esos datos ofreciendo consultas históricas, que permiten consumir los datos de forma exploratoria sin tener que pensar querys sql, ver si compilan, etc. Esto es porque el concepto de Data warehouse está orientado al sujeto, a ayudarlo a que tome decisiones y pone énfasis en la historia de las operaciones por lo cual se dice que es variante en el tiempo, de modo que es posible reconstruir hechos a partir de la información contenida. Otra característica importante es la de integración, al ser una recolección de distintas fuentes de información (BD SQL, NOSQL, archivos..) debe consolidar la información de forma consistente para poder explorarla. 
En su origen tenía una implementación no SQL, pero las grandes companías de bases de datos vieron el nicho y agregaron soporte para este tipo de bases de datos multidimensionales.
Otra diferencia importante con las bases de datos operacionales es que la información aquí no está normalizada, porque su objetivo no es la performance, sino ofrecer información al cliente que le sirve para el desarrollo de su negocio

'Cual es el objetivo de los grafos?'
Los grafos permiten modelizar matematicamente relaciones. En la computación se utiliza para modelar estructuras de datos
no solo estructuras de datos 

'Que se entiende por grafo conexo?':
grafo que para cualquier par de vertices existira un camino que los conecte entre si 

'Qué es y cuál es la diferencia entre paso y camino?'
El paso es de un vertice  a otro mientras que el.
Un camino simple es aquel que no repite vertices en su camino.
Paso/camino: hay paso entre el nodo x e y si se puede llegar de x a y. Un nodo siempre tiene paso a sí mismo.
Paso simple: un paso es simple si se pasa por todos nodos distintos

'Qué beneficios brinda la aplicación de la normalización a diseño de un modelo de base de datos?'
La capacidad de normalizar datos para evitar o reducir anomalías de datos, redundancia de datos 
y duplicaciones de datos, al tiempo que se mejora la integridad de los datos, la han convertido en 
una parte importante del conjunto de herramientas del desarrollador de bases de datos durante muchos años. 
Ha sido una de las características del modelo de datos relacional.

'Describa la busqueda de una clave unica en un arbol B.'
Localizar una clave en un B-árbol es una operación simple pues consiste en situarse en el nodo raíz 
del árbol,si la clave se encuentra ahí hemos terminado y si no es así seleccionamos de entre los hijos 
el que se encuentra entre dos valores de clave que son menor y mayor que la buscada respectivamente y repetimos el 
proceso hasta que la encontremos.En caso de que se llegue a una hoja y no podamos proseguir la búsqueda la clave no se encuentra en el árbol.
En definitiva,los pasos a seguir son los siguientes:

Seleccionar como nodo actual la raíz del árbol.

Comprobar si la clave se encuentra en el nodo actual:
Si la clave está, fin.
Si la clave no está:
Si estamos en una hoja,no se encuentra la clave.Fin.
Si no estamos en una hoja,hacer nodo actual igual al hijo que corresponde según el valor de la clave a buscar y 
los valores de las claves del nodo actual(i buscamos la clave K en un nodo con n claves:
el hijo izquierdo si K<K1,el hijo derecho si K>Kn y el hijo i-ésimo si Ki<K<Ki+1)y volver al segundo paso.

'Desarrolle cual es la importancia de la selección del pivote en el metodo Quicksort en funcion de los diferentes conjuntos de datos a ordenar.'
De ahí marca el punto de partida para ordenar la tabla.
Tomar un elemento cualquiera como pivote tiene la ventaja de no requerir ningún cálculo adicional,
lo cual lo hace bastante rápido. Sin embargo, esta elección «a ciegas» siempre provoca que el algoritmo tenga un orden de 
O(n²) para ciertas permutaciones de los elementos en la lista.

'Defina el concepto de transación  en un Sistema de Base de Datos'
Una transacción es un conjunto de operaciones sql que se ejecutan como un único bloque, 
si falla una operación entonces fallan todas, si una transacción tiene éxito, todas las 
modificaciones de los datos realizadas durante la transacción se confirman y se convierten en 
una parte permanente de la base de datos en cambio sí una transacción encuentra errores y debe cancelarse, 
se borran todas las modificaciones de los datos.

'En qué difieren las Bases de Datos Multidimensionales con las relaciones. Ventajas y desventajas.'
'Describir la arquitectura ANSI Sparc'
Modelo ANSI/SPARC
Nivel externo o VISTAS: percepción de los usuarios respecto de la DB.
Nivel conceptual o LÓGICO: representa de forma entendible la información contenida en una base de datos Se define mediante un esquema conceptual que se escribe en DDL.
Nivel interno o Físico: cómo se almacenan los datos en disco, representación a bajo nivel de toda la base de datos.
------------------------
Transformación externa/conceptual:
Dada una determinada vista externa, esta transformación define la correspondencia entre dicha vista externa y la vista conceptual.
Transformación conceptual/interna
Define la correspondencia entre la vista conceptual y la base de datos almacenada, y especifica la representación en el nivel interno de las filas y columnas del modelo conceptual.

'Enumere y explique al menos tres algoritmos de clasificación u ordenamiento que conozca.'
Quicksort
Es un ordenamiento con intercambio de partición
Si un elemento de un vector está ubicado de tal forma que todos los que están antes que el son menores y todos los que están después son mayores ⇒ está en su posición final cuando 
el vector esté ordenado.
El algoritmo usa dos punteros: DOWN y UP
Y un flag que indica cuál puntero se venía decrementando/incrementando.
Se puede definir como un procedimiento recursivo.
Tiempo de ordenamiento de n elemento en el tiempo proporcional de :  n* log(n)

HeapSort
Objetivo → dado un conjunto de claves ingresadas en forma aleatoria, se busca ordenar el conjunto minimizando el tiempo de búsqueda
Este algoritmo consiste en almacenar todos los elementos del vector a ordenar en un 
montículo (heap), y luego extraer el nodo que queda como nodo raíz del montículo (cima) en sucesivas 
iteraciones obteniendo el conjunto ordenado. Basa su funcionamiento en una propiedad de los 
montículos, por la cual, la cima contiene siempre el menor elemento (o el mayor, según se haya 
	definido el montículo) de todos los almacenados en él.

MergeSort
El método MergeSort es un algoritmo de ordenación recursivo con un número de comparaciones entre elementos del array mínimo.
Su funcionamiento es similar al Quicksort, y está basado en la técnica divide y vencerás.
De forma resumida el funcionamiento del método MergeSort es el siguiente:
- Si la longitud del array es menor o igual a 1 entonces ya está ordenado.
- El array a ordenar se divide en dos mitades de tamaño similar.
- Cada mitad se ordena de forma recursiva aplicando el método MergeSort.
- A continuación las dos mitades ya ordenadas se mezclan formando una secuencia ordenada.

'Describa el barrido simétrico o in orden de un arbol binario, ejemplifique.'
Entreorden o simétrico:
Visitar el subárbol izquierdo
Informar la raíz
Visitar el subárbol derecho

'Describa de forma clara y concisa los terminos Datamining, Datawarehouse y OLAP y cómo se relacionan entre sí.'
'Desarrollarel concepto de JOIN, enumere y explique cada uno de los tipos. Ejemplifique'
INNER JOIN solo muestra las filas  que coincidan, 
OUTER JOIN  mostrara todas las filas de la tabla dominante matcheen o no con los datos de la otra tabla
Puede ser left, rigth o full

'Que entiende por grafo conexo'
Grafo conexo: un grafo se considera conexo si todo par de vértices está conectado por un camino, o sea, 
si para cualquiera par de vértices existe al menos un camino posible entre ellos, o dicho de otra forma que existe 
al menos una conexión entre todos los nodos que conforman el grafo, sea esta directa (a través de un arco entre ambos) 
o indirecta (a través de más de un arco entre ambos).

'Describir el nivel de aislamiento repeat able read y el concepto de lectura repetible '
Repeatable read:
Lockea en los selects de todos los registros consultados mientras dure la transacción.
Pueden aparecer lecturas fantasmas.
Y si tiene lectura repetible.

'Mencionar que funcionalidades se pueden usar en un stored procedures y que no se pueden hacer en una función.'
En una funcion no se pueden invocar procedimientos
Dentro de una funcion se puede llamar a otra funcion
Se pueden usar funciones dentro de un stored procedure

'Enumere una forma de implementación estáticos sobre grafos y describalo.'
Matriz de adyacencia o incidencia
Matriz de Adyacencia
Dado un grafo G = (V, A) con n vértices {V1, ..., Vn} su matriz de adyacencia
es la matriz de orden nxn, A(G)=(Aij) donde Aij es el número de aristas que unen los
vértices Vi y Vj.
Matriz de incidencia : Dado un grafo simple G = (V, A) con n vértices V = {V1, ..., Vn} y m = aristas A
= {A1, ..., Am}, su matriz de incidencia es la matriz de orden nxm, B(G)=(bij), donde
bij=1 si Vi es incidente con Aj y bij=0 en caso contrario.



'En que difieren las DB multidimensionales con las relacionales: ventajas y desventajas'
la principal diferencia que tienen las bases de datos multidimensionales frente a las 
relacionales es que el objeto de las primeras es agilizar las consultas en grandes 
cantidades de datos.. mientras que el objetivo de las bases de datos relacionales es 
asegurar las propiedades ACID en las transacciones que recibe.
Ventajas multidimensionales:
	- consultas agiles en grandes volumenes de datos
	- capacidades analiticas (consulta por particiones, calculo de percentiles, etc)
	- segmentar los datos segun un criterio propuesto por el usuario.
Desventajas multidimensionales:
	- es imposible realizar cambios de estructuras 
Ventajas relacionales:
	- propiedades ACID 
	- flexibilidad en los modelos de datos pese a las reglas normales 
Desventajas relacionales:
	- los joins entre tablas pueden ser muy costoso
	- los datos deben ser estructurados

'Beneficios brinda la aplicacion de la normalizacion a diseño de un modelo de base de datos'
Una de las principales ventajas de la normalizacion es que evita todo tipo de redundancias,
a su vez, evita problemas de actualizacion de los datos en la tabla y protege la integridad 
de los mismos.. de esta manera, se dejan los datos precisos, unicos y relevantes segun 
las necesidades del sistema. al disminuir el volumen de los datos, facilita y agiliza 
considerablemente el acceso y las consultas a los mismos.

'Escribir metodo de ordenamiento de merge sort:'
se trata de un algoritmo recursivo, el metodo se bbasa en dividir el conjunto de 
elemenos a ordenar en dos.. estas dos partes se vuelven a dividir y los sub conjuntos 
se dividen nuevamente. Asi recursivamente hasta que se queden dos grupos con un size 
de 1 (caso base).
se considerara que ambos grupos estan ordenados y lo unico que se hara es el "merge"
entre ambas partes. se van ordenando y fusionando ambas subsecuencias hasta obtener dos 
conjuntos ordenados.
Es entonces cuando se va a hacer un ultimo merge para que quede el conjunto completo ordenado.

'Explique el objetivo de los índices y sus características.'
Los índices son estructuras opcionales asociadas a una tabla.
La función de los índices es la de permitir un acceso más rápido a los datos de una tabla, 
se pueden crear distintos tipos de índices sobre uno o más campos.
Los índices son lógica y físicamente independientes de los datos en la tabla asociada. Se 
puede crear o borrar un índice en cualquier momento sin afectar a las tablas base o a otros índices.

TIPOS DE INDICES
Btree Index
Estructura de índice estándar y más utilizada.
Btree Cluster Index
Este tipo de índice provoca al momento de su creación que físicamente los datos de la tabla sean ordenados por el mismo. 
(Informix / SQLServer / DB2)
Bitmap Index (Oracle)
Son utilizados para pocas claves con muchas repeticiones
Cada bit en el Bitmap corresponde a una fila en particular.
Si el bit esta en on significa que la fila con el correspondiente rowid tiene el valor de la clave.
Hash Index (MySql)
Están implementados en tablas de hash y se basan en otros indices Btree existentes para una tabla. Si una tabla entra 
integramente en memoria, la manera más rápida de ejecutar consultas sobre ella es usando un hash index.

Functional Index / Function based Index
Son indices cuya clave deriva del resultado de una función.
En general las funiciones deben ser funciones definidas por un usuario.
Reverse Key Index (Oracle) 
Invierte los bytes de la clave a indexar. Esto sirve para los índices cuyas claves son una serie constante con por ej. 
Crecimiento ascendente. para que las inserciones se distribuyan por todas las hojas del árbol de índice.


'Describa la busqueda de una clave unica en un arbol B'
si necesitamos buscar un item X en un arbol B, debemos comenzar por la raiz.. 
si el arbol esta vacio, la busqueda falla, de lo contrario, las claves en la nodo 
raiz son examinadas para determinar si el elemento que se esta buscando esta presente 
si ese elemento esta, la busqueda termina exitosamente.. si no esta, hay 3 posibildades
	1. si el elemento x a buscar es menor que y, se continua buscando en el subarbol T
	2. si x es mas grande que Yn-1 , se continua buscando en el arbol Tn-1
	3. si existe un i tal que 1 <= i <= n-1 para el cual Yi <= X <= Yi+1 entonces se
	   continua buscando en el arbol Ti 
el tiemp ode ejecucion de una busqueda exitosa depende por la profundidad en que se 
encuentre el elemento a buscar dentro del arbol y en el peor de los casos esta determinada 
por la altura del arbol B

'Desarrole cual es la importancia de la seleccion del pivote en el metodo quicksort'
'en funcion de los diferentes conjuntos de datos a ordenar'
una mala eleccion seria elegir el primer elemento como pivote, que si bien seria 
aceptable en uan entrada aleatoria nos llevaria al peor caso si al entrada esta ya 
ordenada o en orden inverso.. lo mejor seria elegir el elemento central como pivorte 
, el que esta en la posicion (izquierda + derecha /2) del array. Otra eleccion que 
seria mejor es la de elegir 3 valroes (ejemplo, el primero, el del medio y el ultimo)
y agarrar el menor de esos 3 como pivote.

'Defina el concepto de transaccion en un sistema de base de datos'
Una transaccion es un conjunto de operaciones que se ejecutan como una unica unidad.. 
estas transacciones deben cumplir 4 propiedades fundamentales conocidas como ACID:
atomicidad, consistencia, aislamiento y durabilidad
Atomicidad: cualquier cambio que produce una transaccion es atomico, osea , se ejecutan
	 		todas las operaciones o nose ejecuta ninguna.
Consistencia: aseguera que una transaccion no rompera la integridad de la base de datos 
Aislamiento: asegura que no se afectaran entre si las transacciones que se ejecuten de manera 
			 concurrente 
Durabilidad: asegura la presistencia de una transaccion, osea, una vez que la transaccion 
			 quedo aceptada no podra deshacerse aunque falle el sistema 

'Explicar los conceptos de Data Warehouse y Data Mining y el objetivo de utilizar cada uno de ellos.'
DW: son sistemas donde se almacenan y extraen datos de diversas fuentes para la toma de decisiones. 
DM: es la extracción de información oculta y predecible de grandes BDs, ayuda a las compañías a concentrarse 
en la información más importantes de sus bases y predecir nuevas tendencias.

'Explique y desarrolle los diferentes niveles de aislamiento de una base de datos relacional.'
Niveles de aislamiento:
Read uncommitted: no asegura lockeos por select, lo que mejora el rendimiento pero afecta la 
integridad porque hay lecturas sucias, lecturas no repetibles y lecturas fantasmas.
no lockeos por select => mejor rendimiento
	si lecturas sucias
	si lectura no repetibles 
	si lectura fantasma fantasmas
Read committed: asegura que no exista lecturas sucias pero no asegura lecturas repetibles, 
ya que una vez que leyó los datos, libera el lockeo. En una misma transacción puede tener dos llamados 
a un mismo select y este arrojar resultados distintos.
	no lecturas sucias
	si lecturas no repetibles
	si lectura fantasma
lee los datos y libera el lockeo
dos llamados en una misma transacción puede tener resultados distintos
Repeatable read: asegura que no existan lecturas sucias y que las lecturas puedan ser repetibles, 
pero no evita lecturas fantasmas.
	no lecturas sucias
	no lectura no repetible
	si lectura fantasma
Serializable read: asegura que no existan lecturas sucias, lecturas fantasmas y que las lecturas puedan 
ser repetibles. El problema es que se implementa un nivel de bloqueo que puede afectar a los demás usuarios.
	no lectura sucia
	no lectura no repetible
	no lectura fantasma
	tantos bloqueos pueden afectar a los demás usuarios	

'Explique las propiedades ACID de una BD y su relación con las transacciones.'
Las propiedades ACID garantizan que las transacciones se realicen de forma
confiable en una BD. 
Atomicidad:  la transacción debe ejecutarse en su totalidad o no debe ejecutarse 
	  		 en absoluto.
Consistencia: luego de la transacción , la BD debe quedar consistente satisfaciendo 
			  todas las restricciones de integridad.
Aislamiento (isolation): cuando las transacciones se ejecutan concurrentemente, sus 
						 efectos deben ser aislados y no deben interferirse entre sí.
Durabilidad: una vez que la transacción termina, su efecto no debe perderse aunque el 
			  sistema falle.

Explique y desarrolle 3 objetos de BD que sirven para asegurar la Integridad de datos
	Objetos relacionados con la integridad:
Constraints (unique, not null, check, default)
Triggers
Índices
Vistas (con check options)
Stores procedures

'Defina el concepto de transacción, cite un ejemplo de cuando el motor de BD ejecutaría un Rollback en una transacción.'
Transacción es un conjunto de instrucciones las cuales deben ejecutarse todas 
o ninguna, manteniendo la integridad de los datos.
Un Rollback puede ejecutarse en el caso de que se quiera borrar una fila que
está relacionada con otra tabla por medio de una FK, por lo cual fallaría. Esto
en el caso que no esté configurada en “Delete on cascade”.

'Mencione dos objetos que tengan que ver con la seguridad, descríbalos e indique de qué modo puede utilizarlos para dicha funcionalidad.'
Objetos relacionados con la seguridad:
	Vistas: es una consulta que se presenta como una tabla (virtual). Se puede por ej, para algunos usuarios 
	crear una vista de una tabla donde obtenga solo parte de las cantidad real de columnas que tiene la tabla.
	Triggers: son objetos que se relacionan a tablas, y permiten administrar mejor la BD. Se puede por ej, crear 
	un trigger en una tabla que ante un delete de n filas, no haga caso al delete, o escriba un histórico.
	Stores procedures: es un conjunto de instrucciones que se almacenan y ejecutan en la BD. Se puede por ej, 
	crear un SP para obtener un listado de los usuarios que accedieron a determinadas tablas, horarios, etc.


'Defina el concepto de lectura sucia, repetible y fantasma.'
Lectura sucia: ocurre cuando se le permite a una transacción hacer una lectura de una fila que ha sido modificada 
por otra transacción concurrente, pero aún no ha sido confirmada (commiteada).
Lectura repetible: ocurre cuando en el curso de la transacción se lee una fila dos veces, y los valores coinciden.
Lectura no repetible: ocurre cuando en el curso de la transacción se lee una fila dos veces, y los valores no coinciden.
Lectura fantasma: ocurre cuando durante una transacción se ejecutan dos consultas idénticas y los resultados de la 
segunda son distintos a los de la primera.

'Que es un Data Mart, explique por qué motivo posee datos desnormalizados.'
Un Data Mart es un subconjunto de un Data Warehouse, con el propósito de 
ayudar en un área específica dentro del negocio para que se puedan tomar
mejores decisiones. Los datos en un Data Mart están desnormalizados para
disminuir la cantidad de tablas necesarias.

'Explique el concepto de transacción y su relación con las propiedades ACID.'
Una transacción es un conjunto de órdenes que se ejecutan atómicamente.
Las propiedades ACID garantizan que las transacciones se realicen de forma
confiable en una BD. (ver 3)	

'Explique Algoritmo de Huffman, en que se basa para la compresión de datos.'
Es un algoritmo que puede ser usado para compresión o encriptación de datos. Por ej: se usa cuando la cantidad de 
espacio en disco es insuficiente o los tiempos de transmisión son prolongados con costos elevados. 
Huffman se basa en asignar códigos de distinta longitud de bits a cada uno de los caracteres de un archivo. Si se asignan 
códigos más cortos a los caracteres que aparecen más a menudo se consigue una compresión del archivo.
Esta compresión es mayor cuando la variedad de caracteres diferentes que aparecen es menor. Ej: si el texto se compone 
únicamente de números o mayúsculas, se conseguirá una compresión mayor.

'Detalle las estructuras del algoritmo de Huffman'
El algoritmo de Hffman se usa para la compresion o encriptacion de datos mediante el estudio de la frecuencia
de aparicion de caracteres. Se basa en el uso de un arbol binario donde las hojas representan los simbolos del conjunto de 
entrada.
Para conseguir el codido de huffman asociado a cada simbolo unicamente hay que seguir las aristas que unen la raiz con la hoja 
determinada. 
Estructuras utilizadas
Tabla de huffman: Es una matriz compuesta por 5 columnas (estado, carácter, frecuencia, código, dirección en el árbol) y una fila por 
cada carácter distinto.
Un árbol binario completo compuesto por el carácter, la frecuencia, punteros a dos hijos y un puntero al padre.
Una pila.

'Detallar el objeto BD Constraint y su relacion con integridad'
Integridad de Entidad
La integridad de entidades es usada para asegurar que los datos pertenecientes a 
una misma tabla tienen una única manera de identificarse, es decir que cada fila de cada tabla tenga una primary key capaz de identificar 
unívocamente una fila y esa no puede ser nula
PRIMARY KEY CONSTRAINT: Puede estar compuesta por una o más columnas, y deberá representar unívocamente a cada fila de la tabla. 
No debe permitir valores nulos (depende del motor de base de datos).
Integridad Referencial
La integridad referencial es usada para asegurar la coherencia entre datos de dos tablas.
FOREIGN KEY CONSTRAINT:Puede estar compuesta por una o más columnas, y estará referenciando a la PRIMARY KEY de otra tabla.
Los constraints referenciales permiten a los usuarios especificar claves primarias y foráneas para asegurar una relación PADRE-HIJO 
(MAESTRO-DETALLE).

Integridad Semántica
La integridad semántica es la que nos asegura que los datos que vamos a almacenar tengan una apropiada configuración y que 
respeten las restricciones 
definidas sobre los dominios o sobre los atributos.
•DATA TYPE 
•DEFAULT
•UNIQUE
•NOT NULL
•CHECK

Integridad Semántica
DATA TYPE: Este define el tipo de valor que se puede almacenar en una columna. 
DEFAULT CONSTRAINT: Es el valor insertado en una columna cuando al insertar un registro ningún valor fue especificado para dicha columna. El valor default por default es el NULL. 
Se aplica a columnas no listadas en una sentencia INSERT.
El valor por default puede ser un valor literal o una función SQL (USER, TODAY, etc.)
Aplicado sólo durante un INSERT (NO UPDATE).
UNIQUE CONSTRAINT: Especifica sobre una o más columnas que la inserción o actualización de una fila contiene un valor único en esa columna o conjunto de columnas.
NOT NULL CONSTRAINT:Asegura que una columna contenga un valor durante una operación de INSERT o UPDATE. Se considera el NULL como la ausencia de valor.

CHECK CONSTRAINT: Especifica condiciones para la inserción o modificación en una columna. Cada fila insertada en una tabla debe cumplir con dichas condiciones. 
Actúa tanto en el INSERT, como en el UPDATE.
Es una expresión que devuelve un valor booleano de TRUE o FALSE.
Son aplicados para cada fila que es INSERTADA o MODIFICADA.
Todas las columnas a las que referencia deben ser de la misma tabla (la corriente). 
No puede contener subconsultas, secuencias, funciones (de fecha, usuario) ni pseudocolumnas.
Todas las filas existentes en una tabla deben pasar un nuevo constraint creado para dicha tabla. En el caso de que alguna de las filas no cumpla, no se podrá crear dicho constraint o se creará en estado deshabilitado.


'Que es una tabla temporal'
Son tablas creadas cuyos datos son de existencia temporal.
No son registradas en las tablas del diccionario de datos(se refiere a la lista de tablas que tengo).
No es posible alterar tablas temporarias. Si eliminarlas y crear los índices temporales que necesite una aplicación.
Las actualizaciones a una tabla temporal podrían no generar ningún log transaccional si así se configurara.


'Explique las Reglas de Integridad según el Modelo Relacional'
Regla de integridad de la entidad: ninguno de los atributos que componen la clave primaria puede ser nulo. 
Regla de la integridad referencial: si en una relación hay una clave foránea, sus valores deben coincidir con los valores de la clave primaria.

'Explicar Clave Primaria, Foránea, Candidata y dominio de los datos.'
Clave Primaria: es un campo o combinación de campos que identifica de forma única a cada fila de la tabla.
Clave Foránea: identifica una columna o grupo de columnas en una tabla que se refiere a una columna o grupo de columnas en otra tabla.
Clave Candidata: son claves que podrían servir como clave primaria.
Dominio de los Datos: un dominio describe un conjunto de posibles valores para cierto atributo. 

'Desarrolle el concepto de restore y recovery.'
Restore: es la acción de tomar un Back Up ya realizado y restaurar la 
estructura y datos sobre una base dada.
Recovery: es un mecanismo provisto por los motores de base de datos que se ejecuta en cada inicio del motor de forma automática como 
dispositivo de tolerancia de fallas. Sus objetivos son , retornar el el motor al punto consistente más reciente y utilizar logs transaccionales 
para retornar al motor a un estado lógico consistente.

'Describa los diferentes conceptos que se relacionan directamente con la funcionalidad de concurrencia.'
Los motores permiten controlar elacceso concurrente a sus recursos a travez 	de loqueos y de niveles de aislamiento.

'Describa ventajas y desventajas de cada uno de los métodos de creación de índices, Arbol B y Tablas de Hashing.'
Hashing: busca establecer una relación directa entre el valor de los datos y el 
valor de la clave con una función hash, que aplicada a una clave devuelve el 
subíndice de la tabla.
Ventajas: acceso directo a los datos (más rápido que Árbol B para acceso a datos). No se utiliza espacio extra para su implementación.
Desventajas: el principal problema es cuando la función hash devuelve un valor igual para dos o más claves, lo que se llama colisión. 
Cuanto más datos, más colisiones. No es bueno para búsquedas secuenciales.
Árbol B: la estructura de Árbol B parte del concepto de árboles n-arios de búsqueda. Está pensado para disminuir la cantidad de accesos 
a disco y la posibilidad de mantener en memoria la parte que se está utilizando y el resto conservarlo en disco. 	
Ventajas: se utiliza para grandes volúmenes de datos y es mejor que hash para archivos secuenciales. 
Desventajas: es más lento que Hashing para la creación de índices, 	dado que es necesario crear toda la estructura en memoria.	 

'Explique el acceso a datos por hashing into buckets, mencionar de que modo trata'
'las colisiones'
Cuando dos o mas calves intentan asignarse a una misma direccion en la tabla hash, cuando 
dos clases se direccionan a la misma se produce una colision.
cuando hay colisiones se requiere un proceso adicional para encontrar una posicion disponible 
para la clave:
las cuales son:
	• direccionamiento abierto: consiste en poner en la siguiente posicion vacioa 
	• direccionamiento cerrado: no hay problema con que se repita la misma direccion.


'Explicar objetos de BD que nos permiten la integridad referencial, reglas de integridad de entidad y la integridad semántica.'
Integridad semántica = Consistencia.	 	

'Explique el concepto de Fact table y Dimensiones en un Data Warehouse.'
Fact table: es la tabla primaria en cada modelo dimensional, orientada a 
	contener reglas de negocio. Cada Fact table representa una relación de 
	muchos a muchos, y contiene un conjunto de dos o más foreings keys que 
	hacen referencia a sus respectivas tablas de dimensión.
Dimensiones en DW: llamamos dimensiones a aquellos datos que nos 
	permiten agrupar o filtrar información. Existe una Dimensión Table que 
	restringe los criterios de selección de la Fact table. Cada dimensión está 
	definida por su clave primaria que sirve como base para la integridad 
	referencial con la fact table.

'En PL SQL o TSQL, no se puede abrir un cursor dentro de otro.'
Falso 


'Dado el grafo G(P,E) donde P={(a)} y E={(a,a)} decimos que el mismo es un árbol'
Falso


'Explique la relación existente entre la Constraints UNIQUE y PRIMARY KEY y el Objeto índice.'
Constraint Unique: las restricciones son reglas que el motor aplica de forma 
				   automática la Unique es para garantizar que todos los valores de una columna 
				   sean únicos. La restricción Check valida que el dato de la columna esté dentro de un rango.
Primary Key:es un campo o combinación de campos que identifica de forma 
			única a cada fila de la tabla.
Objeto Índice: es una estructura de datos que mejora la velocidad de la 
			   operaciones por medio de un identificador único de cada fila de la tabla, 
			   permitiendo un rápido acceso a los registros de una BD.
Entonces => La PK es el identificador de la tabla que puede estar formado por 
uno o más campos y no se puede repetir, la Constraint Unique se aplica sobre 
una columna cualquiera para que no se repitan los datos y el índice crea ???

'Cómo implementaría la integridad referencial entre dos tablas de dos bases de datos en diferentes servidores.'
'Diferencias entre Store procedure, Función y Trigger.'
Los SPs son procedimientos almacenados en una BD, los cuales son ejecutados por un usuario o por otro proceso,
y pueden realizar operaciones varias como altas, bajas y modificaciones de tablas. En cambio las Funciones no pueden hacer 
modificaciones de tablas, solo hacer consultas y retornar un valor. Los trigger se ejecutan automáticamente ante 
eventos (insert, delete, update) en las tablas y al igual que en los SPs, puede hacerce operaciones varias.
Explique las principales características que diferencian a una Base de datos Operacional de un Datawarehouse.

#preguntas más viejas

'Determine los componentes y las variables que intervienen en el diseño de un modelo OLAP.'
Proporciona información fiable sobre los indicadores clave del funcionamiento de una organización para los sectores que 
toman decisiones.
A diferencia de los sistemas transaccionales, OLAP procesa información y aplica inteligencia.
Un sistema OLAP se alimenta de uno o varios OLTP que lo proveen de datos.     
Todos los campos son calculados.
Se usa para tomar decisiones.
Se basa en patrones de interés.
OLTP → DTS → OLAP. El DTS se ejecuta periódicamente para generar información.
Se implementa con distintas tecnologías: MOLAP (bases de datos multidimensionales), ROLAP (bases de datos relacionales), 
HOLAP (bases de datos híbridas).
MOLAP: ya no se trabaja con el concepto de filas y columnas sino dimensiones. Técnicas de hipercubo (hay dispersión) y 
multicubo (se saltan los cubos que no contienen información).
ROLAP

'Que características de funcionamiento tiene y que variantes existen del método quicksort de clasificación.'
Es un método de fácil implementación y poco consumo de recursos.
Es  recursivo  pero  se  usan  versiones  iterativas  para  mejorar  su  rendimiento, también es in-situ,
ya que usa solo una pila auxiliar.
El QuickSort está basado en la idea de divide y vencerás, en el cual un problema se soluciona dividiéndolo en dos o más subproblemas,
 resolviendo recursivamente cada uno de ellos para luego juntar sus soluciones para obtener la solución del original.

'Indique por que un índice conformado por una clave numérica corta es más rápido en el acceso a los datos que'
'un índice compuesto o conformado con un string largo.  '
Al ocupar más espacio cada nodo del árbol supera el tamaño de una página del File System, de esta forma el Sistema
Operativo debe leer varias páginas para levantar un nodo, por eso es mas lento.

'Desarrolle el concepto de trigger en cuanto a ejecución, instancias y funcionalidad.'
Ejecución: un trigger es un procedimiento que se ejecuta ante un acontecimiento (INSERT, UPDATE, DELETE) sobre una tabla determinada.
Tipos: se puede aplicar a la fila que disparó el trigger o a todas las filas.
Before, After & Instead of (en lugar del evento que lo invocó).
Atomicidad: si un error ocurre cuando un trigger se está ejecutando, la operación que disparó el trigger falla, 
o sea que no se modifica la tabla.
Uso: se usan triggers cuando la integridad referencial y los constraints son insuficientes; reglas de consistencia 
(no provistas por el modelo relacional); replicación de datos; auditoría; acciones en cascada; autorización de seguridad; 
los triggers constituyen la herramienta más potente para el mantenimiento de la integridad de la base de datos, ya que 
pueden llevar a cabo cualquier acción que sea necesaria para mantener dicha integridad; un trigger puede modificar filas 
de una tabla que un usuario no puede modificar directamente; pueden llamar procedimientos y disparar otros triggers, pero no 
pueden llevar parámetros.
Ventaja: la principal ventaja es que permiten a los usuarios crear y mantener un conjunto de código más manejable para 
su empleo por todas las aplicaciones asociadas con las base de datos existentes y futuras.
Tablas virtuales: acceso a tablas virtuales de sólo lectura INSERTED y DELETED.
Recursividad: un trigger puede disparar una acción que a su vez, lance otro trigger y así sucesivamente.

'Desarrollar el concepto de Data Warehouse, ejemplifique'
Un Data Warehouse es una colección de datos orientada a sujetos, integrada, variante en el tiempo, no volátil, 
organizados para soportar necesidades empresariales.
Integración de bases de datos heterogéneas (relacionales, documentales, Geográficas, archivos, etc.).
Ejecución de consultas complejas no predefinidas visualizando el resultado en forma de gráfica y en diferentes 
niveles de agrupamiento y totalización de datos.
Acceso interactivo e inmediato a información estratégica de un área de negocios.
Análisis de problema en términos de dimensiones (por ejemplo el tiempo).
Control de calidad de datos para asegurar la relevancia de los datos en base a los cuales se toman las decisiones.

'Desarrolle el concepto de índice asociado a una Base de Datos Relacional.'
Los índices son estructuras físicas y no lógicas.
Mejoran la performance de la aplicación, aumentando la velocidad de acceso a los datos.
De forma similar al índice de un libro, se guardan parejas de elementos: el elemento que se desea indexar y su posición en la base de datos.
Se guardan por un lado los índices (header) ordenados y por otro los datos (cuerpo) en forma secuencial.
Se pueden utilizar dos métodos: tablas de hashing y árbol-B.
Tablas de hashing: se guarda en una tabla la clave (es por lo que se ordena), la posición relativa que ocupa en la 
parte de datos y un puntero a una lista de duplicados.  Se indexa por los campos que son accedidos con más frecuencia. 
Las claves pueden ser compuestas, por ejemplo nombre y legajo, entonces ordeno por nombre y a igual nombre ordeno por legajo 
(un solo índice). Pero si necesito ordenar por DNI y legajo entonces se necesitan dos índices.
Árbol-B: el número máximo de claves por nodo constituye el orden del árbol-B y el número mínimo de claves permitidas en un 
nodo es normalmente la mitad del orden excepto para la raíz. En los nodos no terminales se guardan los datos y un apuntador a 
otro nodo con valores menores o iguales. Todas las hojas tienen la misma profundidad (pertenecen al mismo nivel).
Las hojas poseen apuntadores a los registros en el fichero de datos, de forma que el nivel completo de las hojas forma un índice 
ordenado del fichero de datos.

'Cual es el objetivo de un Trigger.  Describa un ejemplo práctico de su utilización.'
Es mantener la integridad referencial entre tablas.

'Defina claramente el concepto de transacción, indicando su utilidad y forma de uso.'
Utilidad: Mantener la consistencia e integridad de los datos,  haciendo que
 las instrucciones que la componen no finalicen en un estado intermedio
 evitando, de esta manera, posibles fallos en el sistema donde se ejecutan.
Forma de uso:
BEGIN TRANSACTION
      UPDATE LEGAJOS
      SET LEGA_APELLIDO = 'RIOS'  
      WHERE LEGA_LEGAJO = 1
COMMIT

'Desde el punto de vista de la Performance, en que consiste el armado de un plan de consulta?'
El plan de consulta es la forma en que el motor va a resolver una consulta enviada para su resolución, 
para ello existe un optimizador del propio DBMS que de varias opciones se queda con la mejor. Del mismo modo,
 quien ejecuta la consulta debe optimizarla previamente tratando de que por ejemplo utilice índices de acceso 
 en forma parcial o total para que la consulta tenga mayor perfomance.

'Que características distintivas brinda un DBMS?'
Sistema de Administración de Bases de Datos (DBMS): Construido sobre sus capacidades en vez
de las simples funciones de recuperación y almacenamiento de datos. Estos productos comúnmente incluyen grandes 
capacidades de back-up y recuperación de datos, ingreso al sistema, control de concurrencia y bloqueo, y mecanismos de seguridad.

'A la hora de elegir un Motor de Bases de Datos determinado, que características tendría que analizar para su elección?'
Costo, Volumen de datos, tiempo de respuesta, control de acceso concurrente y seguridad, redundancia y recuperación de datos.

'Desde el punto de vista de la Performance, en que mejora el armado de un Modelo OLAP.'
OLAP: En el análisis multidimensional, los datos se presentan mediante dimensiones como producto, territorio y cliente. 
Por lo regular las dimensiones se relacionan en jerarquías, por ejemplo, ciudad, estado, región, país y continente, o estado, 
territorio y región.
Al procesamiento analítico o análisis multidimensional se le conoce también como procesamiento analítico en línea (OLAP). 
Se procesa en una visión multidimensional de los datos empresariales en el Data Warehouse y puede tener un motor de depósito 
de base de datos multidimensional. De esta forma, dentro de un Data Warehouse  existen dos tecnologías complementarias, una 
relacional para consultas y una multidimensional para análisis. Este concepto nace ante la debilidad fundamental de las bases 
de datos relacionales para proveer capacidad de análisis y sistemas de soporte a las decisiones.
La siguiente definición muestra las mejoras que provee un Modelo Olap:
Fast (Rápido), significa que el sistema está orientado a tener tiempos de respuesta de 5 segundos, con respuestas de 1 segundo
a consultas sencillas y, algunas más complejas, con respuestas de hasta 30 segundos . En situaciones típicas, si las respuestas 
toman más tiempo, el usuario perderá la concentración en lo que busca analizar.
Analysis (Análisis), lo que indica que al usuario debe proporcionársele suficiente funcionalidad para resolver sus problemas, 
sin la necesidad de contar con el apoyo de sistemas o de una pre-programación. De esta forma, se podrán realizar consultas no 
definidas, cálculos de diferencias, variaciones y tendencias, consolidar y llevar a cabo análisis de sensibilidad y de búsqueda de metas.
Shared (Compartida), significa que debe haber facilidad de acceso simultáneo, tanto de lectura como de escritura,
aunado a un esquema de seguridad adecuado, con el objeto de guardar la confidencialidad (probablemente a nivel de celda).
Multidimensional, ha sido y continuará siendo un requisito, con la habilidad de manejar múltiples jerarquías y dimensiones.
Information (Información), son todos los datos y la información derivada, cuando y donde sea necesaria, en su contexto, tanto de información “suave”
como información “dura”, interna o externa.


'Que se entiende por Multicubo y Hypercubo y cual es la utilización y diferencias entre ambos.'
Es una forma de almacenamiento en forma de array de los datos de las base Multidimensionales.

'Cual es el concepto de Data Marts?  Para que se utilizan?.  Cual es la diferencia entre un Data Marts y un Datawarehouse?'
Data Marts es el mismo concepto que Datwherehousing pero se utiliza en departamentos, son pequeños proyectos de Data wherehousing.
La principal diferencia es el tamaño, dado que los Datawharehousing tienen grandes cantidades de información almacenada de toda la 
empresa, por otro lado el data mart solo tiene información de un departamento, esto no quiere decir que sea poca información, pero si lo es 
en relación, por otro lado, al ser mas pequeño, tiene diferencias, de costo, implementación, accesos, etc.

'Qué se entiende por DTS?'
Son herramientas y objetos que permiten mover datos entre varios orígenes de datos diferentes o iguales. Un DTS 
puede realizar las siguientes tareas:
- Importación y exportación de datos entre dos orígenes de datos.
- Transformación de datos.
- Copia de objetos de base de datos : tablas, índices, etc.
- Ejecución de instrucciones de Transact-SQL.
DTS tiene una arquitectura OLE DB por lo que puede copiar y transformar múltiples orígenes de datos, entre ellos: SQL Server, Oracle.

'En que consiste la Técnica de Data Mining?  Para que se utiliza e indique alguna de las técnicas algorítmicas aplicadas en el mismo.'
Las computadoras son cargadas con mucha información acerca de una variedad de situaciones donde una respuesta es conocida y luego el 
software de Data Mining en la computadora debe correr a través de los datos y distinguir las características de los datos que llevarán al modelo. 
Una vez que el modelo se construyó, puede ser usado en situaciones similares donde no se conoce la respuesta.

'Indique las características y funcionalidad de una DataWarehouse.'
Un Data Warehouse es una colección de datos orientada a sujetos, integrada, variante en el tiempo, no volátil, 
organizados para soportar necesidades empresariales.
Integración de bases de datos heterogéneas (relacionales, documentales, Geográficas, archivos, etc.).
Ejecución de consultas complejas no predefinidas visualizando el resultado en forma de gráfica y en diferentes niveles de agrupamiento y totalización de datos.
Acceso interactivo e inmediato a información estratégica de un área de negocios.
Análisis de problema en términos de dimensiones (por ejemplo el tiempo).
Control de calidad de datos para asegurar la relevancia de los datos en base a los cuales se toman las decisiones.


'¿Por qué se establece que las Reglas del Negocio deben estar en el Motor de Base de Datos y no en la aplicación cliente?'
Reglas de negocio: cada aplicación debe reflejar las restricciones que existen en el negocio dado, de modo que nunca sea posible 
realizar acciones no válidas.
La información puede ser manipulada por muchos programas distintos que podrán variar de acuerdo a los departamentos de la organización, 
los cuales tendrán distintas visiones y necesidades pero que en cualquier caso, siempre deberán respetar las reglas de negocio.  	
Es por lo anterior expuesto que las reglas del negocio deben estar en el motor de base de datos.

'¿En qué consisten, para qué se utilizan y cómo pueden implementarse las tecnologías OLAP? Ejemplifique.'
Proporciona información fiable sobre los indicadores clave del funcionamiento de una organización para los 
sectores que toman decisiones.
A diferencia de los sistemas transaccionales, OLAP procesa información y aplica inteligencia.
Un sistema OLAP se alimenta de uno o varios OLTP que lo proveen de datos.     
Todos los campos son calculados.
Se usa para tomar decisiones.
Se basa en patrones de interés.
OLTP → DTS → OLAP. El DTS se ejecuta periódicamente para generar información.
Se implementa con distintas tecnologías: MOLAP (bases de datos multidimensionales), ROLAP (bases de datos relacionales), 
HOLAP (bases de datos híbridas).
MOLAP: ya no se trabaja con el concepto de filas y columnas sino dimensiones. Técnicas de hipercubo (hay dispersión) y 
multicubo (se saltan los cubos que no contienen información).

'Explique el Modelo Star para el armado de una DataWarehouse. Ejemplifique.'
Es un esquema relacional orientado a la representación de dimensiones que convergen sobre un hecho común o un valor cuantificable.
De esta forma se logra implementar en un sistema de base de datos tradicional el concepto de cubos multidimensionales.
Existe una tabla central denominada “tabla de hechos” que representa el atributo cuantificable.
Alrededor de esta tabla central se definen otras tablas ligadas a esta mediante claves foráneas, y se denominan tablas de 
dimensiones y son aquellas que definen cualidades del atributo representado por la tabla de hechos.
La clave primaria de la tabla de hechos será una clave compuesta por todas las claves foráneas que representan las claves primarias 
de cada una de las dimensiones asociadas.


'Enumere y explique al menos 3 algoritmos de clasificación que conozca.'
Dicotómico o burbuja: funciona revisando cada elemento de la lista que va a ser ordenada con el siguiente, 
intercambiándolos de posición si están en el orden equivocado. Es necesario revisar varias veces la lista hasta que no se 
necesiten más intercambios, lo cual significa que la lista está ordenada.
Quicksort: elegir un elemento de la lista a ordenar (pivote). Resituar los demás elementos de la lista a cada lado del pivote, 
de un lado los menores y del otro los mayores (en este momento el pivote está ordenado). Se repite el proceso de forma recursiva 
para las dos sublistas mientras éstas contengan más de un elemento. Una vez terminado el proceso todos los elementos estarán ordenados. 
Eficiencia promedio nxlog(n); en el peor de los casos n2.
Heapsort: el algoritmo consiste en almacenar todos los elementos del vector a ordenar en un montículo (heap), y luego extraer el nodo que 
queda como nodo raíz del montículo (cima) en sucesivas iteraciones obteniendo el conjunto ordenado. Basa su funcionamiento en una propiedad 
de los montículos por la cual la cima contiene siempre el menor elemento (o el mayor, según se haya definido) de todos los elementos almacenados en él.

'Enumere ventajas, desventajas y diferencias entre una Base de Datos Orientada a Objetos y una Base de Datos Relacional.'
Ventajas BDOO:
Simplifica la programación.
Flexibilidad: uso de sub-clases que permiten la herencia de atributos, esto permite que una BDOO puede ajustarse a usar siempre 
el espacio de los campos que son necesarios, eliminando el espacio desperdiciado en registros con campos que no se usan.
Manejo de datos complejos: manipula datos complejos de forma rápida y ágil. La estructura de la BDOO está dada por referencias 
(apuntadores lógicos) entre objetos.
Desventajas BDOO:
Baja performance.
Inmadurez del mercado de BDOO.
Falta de estándares en la industria orientada a objetos.

'¿En qué consiste la técnica de Data Mining? ¿Para qué se utiliza? Indique alguna de las técnicas algorítmicas aplicadas en el mismo.'
Consiste en la extracción de información oculta y predecible de grandes bases de datos.
Las herramientas de datamining predicen futuras tendencias y comportamientos, permitiendo tomar decisiones conducidas por un conocimiento 
acabado de la información (knowledge-driven).
Predicción automatizada de tendencias y comportamientos.
Descubrimientos automatizados de modelos previamente desconocidos.
Las técnicas más comúnmente usadas son: redes neuronales, árboles de decisión, algoritmos genéticos, etc.


'Desarrollar las ventajas y desventajas de crear mayor o menor cantidad de índices sobre las tablas de un modelo físico.'
Si tuviera que elegir un método de creación de índices, entre Hashing y Árbol B, cuando usaría cada uno de ellos y por qué?
Indique las diferentes funcionalidades y características de un DBMS.
Desarrollo el concepto de FUNCION en PL-SQL.  Indique ventajas y desventajas sobre otros objetos similares en un DBMS.
Que se entiende por DTS. Indique el concepto y su utilización.
Defina claramente el concepto de transacción, indicando su utilidad y forma de uso.
Cuáles son las diferencias entre una PK y una constraint de Unique ?
Explicar el modelo estrella de un datawarehouse.
Indique las características mandatarias y opcionales de un Motor de Base de Datos Relacional.
¿Qué diferencia conceptual existe entre los índices de archivos de datos tradicionales y los índices creados en una Base de Datos Relacional?
¿Desde el punto de vista de la performance, en qué mejora el armado de un modelo OLAP?
A la hora de elegir un Motor de Base de Datos determinado, ¿qué características tendría en que analizar para su elección?

'¿Qué entiende por diccionario de datos, catálogo de datos o metadata?'
Para representar una base de datos relacional, necesitamos almacenar no sólo las relaciones mismas, 
sino también una cantidad de información adicional acerca de las relaciones.
El conjunto de tal información se llama diccionario de datos o metainformación.
El diccionario de datos debe contener información como: nombre de las relaciones en la base de datos; nombre 
de los atributos de cada relación; dominio de cada atributo; tamaño de cada relación; método de almacenamiento 
de cada relación; claves y otras restricciones de seguridad; nombres y definiciones de vistas.
Además debe contener información sobre los usuarios de la base de datos y los poderes que éstos tienen: nombre de 
los usuarios; costo del uso efectuado por cada usuario; nivel de privilegio de cada usuario.
Es de notar que el diccionario de datos no es más que una base datos acerca de la base de datos, y puede almacenarse 
y manejarse con los mismos métodos.

'¿Qué beneficios brinda la aplicación de la normalización al diseño de un modelo de base de datos?'
Elimina la redundancia de datos.
Mejora la performance.

'Defina los conceptos de Data Warehouse y Datamart. Especialmente similitudes y diferencias.'
DataWarehouse: YA ESTÁ EXPLICADO.
DataMart: podemos entender un Data Mart como un subconjunto de los datos del Data Warehouse 
con el objetivo de responder a un determinado análisis, función o necesidad y con una población de usuarios específica. 
La diferencia entre un DataWarehouse y un DataMart es que el data mart está pensado para cubrir las necesidades de un grupo 
de trabajo o de un determinado departamento dentro de la organización. Es el almacén natural para los datos departamentales. 
En cambio, el ámbito del data warehouse es la organización en su conjunto. Al igual que en un data warehouse, los datos están 
estructurados en modelos de estrella o copo de nieve y un data mart puede ser dependiente o independiente de un data warehouse. 
Los orígenes de datos son homogéneos a diferencia del DW.

'Describa y cite al menos un ejemplo de una representación computacional que permite representar computacionalmente un grafo irrestricto.'
De manera estática: con una matriz de adyacencia nxn (n: cantidad de nodos del grafo), en donde un 1 en una posición ij representa la 
existencia de una flecha del nodo i hacia el nodo j. Presenta el problema de ocupar mucho espacio para representar lo que realmente existe 
ya que se reserva espacio para lugares que no tienen datos.
De manera dinámica: utilizando una lista o vector de punteros donde se guardan los nodos que participan del grafo con sus correspondientes datos. 
Cada elemento contiene un puntero a una lista adicional que contiene “las flechas que salen” del nodo que representan. No se guarda el dato en la 
lista adicional, guarda los punteros a datos.

'¿Cuál es la diferencia entre la utilización de Multicubos e Hypercubos para la implementación de bases de datos multidimensionales?'
Hipecubos:
Se guardan todas las dimensiones en un cubo.
Cada intersección del cubo es otro cubo y así sucesivamente.
Se pueden agregar dimensiones pero es estático porque no se puede variar la dimensión del cubo.
Hay dispersión de datos porque los datos no están compactos por el hecho de que puede haber muchos datos vacíos.

Multicubos:
Se genera una lista con los cubos que tienen información, es decir se saltea los cubos vacíos.

'Desde el punto de vista de la performance, ¿en qué consiste el armado de un plan de consulta?'
El optimizador de consultas es el componente del sistema de gestión de base de datos que intenta determinar la 
forma más eficiente de ejecutar una consulta SQL.
Se decide cuál de los posibles planes de ejecución de una consulta dada es el más eficiente.
Los optimizadotes basados en costos asignan un costo (operaciones de E/S requeridas, CPU, etc.) a cada uno de esos planes 
y se elige el que tiene menor costo.
El optimizador no puede ser accedido directamente por los usuarios, sino que, una vez enviadas las consultas al servidor, 
pasan primero por el analizador y recién entonces llegan al optimizador.
Una consideración muy importante es el orden de los “join”.

'¿Qué características distintivas brinda un DBMS? NO SÉ A QUÉ SE REFIERE'
Describa los componentes básicos de un DBMS. Teniendo en cuenta la administración de datos, la interfaz con el 
usuario y el procesamiento cliente-servidor
Dos lenguajes: DML y DDL.
3 capas: externa (usuario), lógica (conceptual) e interna (física).
Disk manager (recibe peticiones del file manager y las envía al SO), file manager (decide que página contiene el 
registro deseado y la solicita el disk manager) y user manager (permite la interacción con el usuario).
Arquitectura cliente-servidor: las aplicaciones corren en el cliente y generan solicitudes para y reciben respuestas del servidor. 
El servidor realiza el procesamiento de datos y aplica las reglas de negocio establecidas.
Clustering: es la forma de agrupar la información. Hay dos formas, intra-file clustering (todas las tablas conviven con sus elementos) 
e inter-file clustering (se guarda cada objeto con sus relaciones).

<<<<<<< HEAD
'A la hora de elegir un Motor de Bases de Datos determinado, que características tendría que analizar para su elección?'
En que consiste un Plan de Consulta, cual es su utilización y la ventaja de su implementación.
Indique concepto, tipos, funcionalidades y cual es la mayor ventaja de los triggers.
Que se entiende por Multicubo y Hypercubo y cual es la utilización y diferencias entre ambos.
Cual es el concepto de Data Marts?  Para que se utilizan?.  Cual es la diferencia entre un Data Marts y un Datawarehouse?
Los data marts se ajustan a las necesidades que tiene una parte específica de un negocio, más que a las de toda una empresa. Optimizan la
distribución de información útil para la toma de decisiones y se enfocan al manejo de datos resumidos o de muestras. No necesitan ser administrados centralmente por el departamento de sistemas de una organización, sino que pueden estar a cargo de un grupo específico dentro del área de la empresa que los utilice.
En ocasiones, los proyectos que comienzan como data warehouses evolucionan a data marts. Cuando las organizaciones acumulan grandes
cantidades de datos históricos para el apoyo de decisiones, que rara vez o nunca usan, pueden reducir la información guardada y convertir su data
warehouse en un data mart mejor enfocado.
Los sistemas que extraen y almacen datos de diversas fuentes para la toma de decisiones, se denominaban Data Warehouses. En fechas recientes se ha hecho una distinción entre los grandes sistemas para almacenar datos (data warehouses) y los sistemas más pequeños (data marts).
En que consisten, para que se utilizan y como pueden implementarse las Tecnologías OLAP.  Ejemplifique.
Responde con rapidez a las consultas, de modo que el proceso de
análisis no se interrumpe y la información no se desactualiza.
_ Tiene un motor de depósito de datos multidimensional, que almacena los
datos en arreglos. Esos arreglos son una representación lógica de las
dimensiones empresariales.
La tecnología OLAP se aplica en muchas áreas funcionales de una empresa,
tales como producción, ventas y análisis de rentabilidad de la comercialización,
mezcla de manufacturas y análisis de logística; consolidaciones financieras,
presupuestos y pronósticos, planeación de impuestos y contabilidad de costos.
OLAP surge como un proceso para ser usado en el análisis de ventas y
mercadotecnia, para elaborar reportes administrativos y consolidaciones, para
presupuestación y planeación, para análisis de rentabilidad, reportes de calidad
y otras aplicaciones que requieren una visión flexible, de arriba a abajo, del
negocio. OLAP provee de reportes sumarios que los ejecutivos requieren para
tomar decisiones, así como la facilidad de elaborar cálculos complejos,
enfoques a detalles operativos y consultas no programadas. OLAP se alimenta
principalmente de los sistemas transaccionales y como tales, debe considerar
una eficiente administración de la base de datos y proveer un nivel adecuado
de seguridad.

1.      Es correcto decir que tanto las claves PK como las claves FK son
 Check Constraints?
Si
2.      Se podría decir que las Check Constraints son restricciones al
 modelo físico?
Si
2. Que diferencias existen entre decir Constraints y Check Constraints desde
 el punto de vista conceptual?
Yo tengo entendido que las Check Constraints son un subconjunto de las
 Constraints, pero no estoy muy seguro que sea correcto.
Es esto

1. Si tuviera que elegir un método de creación de índices, entre Hashing y
 Árbol B, cuando usaría cada uno de ellos y por qué?
Que parámetros tendría que tener en cuenta para decidirme por algún método
 en especial? Tengo entendido que el volumen de los datos influye en la
 elección de los métodos pero me gustaría saber la respuesta correcta a esta
 pregunta.
Influye el volumen de los datos, los tipos de clave, dado que Hashing genera
 redundancia y el tipo de acceso, dado que Hashing está preparado para un
 acceso directo y no secuencial
2. Determinar que índices implementaría sobre las tablas intervinientes en
 la siguiente consulta, sabiendo que no existen claves implementadas
 actualmente en el modelo, especificar por que:
SELECT usr_nombre, usr_clave, usr_apellido
FROM  usuario, rol
WHERE ( user_nombre='usuario001'  OR usr_apellido LIKE '%Gonzalez' )
AND usuario.usr_id = rol.usr_id AND rol_tipo=lower('Administrador');
Cuando se está hablando de índices, en este caso, sería erróneo contestar
 que implementaría una clave PK y una clave FK, la clave PK asociada a la
 columna usr_id de la tabla usuario y la clave FK asociada a la columna
 usr_id de la tabla rol?
Pregunto esto, ya que al implementar estas claves PK se generan índices para
 esas columnas.
Con respecto a la justificación:
Al hacer el join usuario.usr_id = rol.usr_id en el where y teniendo en
 cuenta que ambas columnas son PK (tienen un indice asociado), el DBMS
 resuelve la query de una manera mucho mas rápida y eficiente que sin
 definirlas como PK.
Seria correcta esta respuesta? Haría falta agregar algo mas?
Es correcto, pero además se podría crear un índice por el campo user_nombre
 para que la busqueda sea más rápida, no por apellido, dado que el LIKE anula
la búsqueda por índice,
=======
'Anexo Preguntas o Conceptos de Final'

'FUNCIONALIDADES Y CARACTERISTICAS DE UN DBMS:'
- Concurrencia: permite el acceso simultáneo de muchas usuarios/procesos.
- Atomicidad: asegura que un conjunto de operaciones se ejecuta todo o falla en su conjunto.
- Consistencia: asegura que la integridad de los datos se mantiene antes y después de realizar una operación.
- Backup y Restore: provee herramientas para realizarlos.
- Gestión de almacenamiento: independiza al usuario de los detalles de bajo nivel de cómo se almacenan los datos. (tratamiento con FS)
- Aislamiento: usuario se abstrae de la implementación física del modelo.
- Facilidad de consultas.
- Transaccionalidad.
- Abstracción.
- Procesamiento distribuido: las diferentes capas o sistemas de un DBMS interactúan entre sí para llevar a cabo los objetivos generales de un DBMS.

'QUE DEBE CUMPLIR UN MOTOR DE BD'
- Relación costo/beneficio.
- Volúmenes de datos a manejar.
- Tipos de bloqueos.
- Concurrencia.
- Si el sistema es o no orientado a objetos.
- Capacidad del equipo de trabajo.
- Plataforma (Hardware y SO)

'Características de los DSS Queries (DataWarehouse) ­> OLAP:'
- Muchas filas son leídas y el resultado no esta en una transacción
- Los datos son leídos secuencialmente
- SQL complejos son ejecutados
- Grandes archivos temporarios son creados
- El tiempo de respuesta es medido en horas y minutos
- Hay relativamente poca concurrencia de queries

'CARACTERISTICAS DEL Ambiente OLTP: On­Line Transaction Processing'
- Relativamente pocas filas leídas
- Alta frecuencia de transacciones
- Acceso a los datos a través de índices
- Simple Operaciones SQL
- Respuesta de scan medida en segundos
- Muchos queries concurrentes

'Existen 3 niveles de Seguridad:'
 a) Base de datos
 b) Tabla
 c) Columna (depende del motor de bd)
 
'PLAN DE CONSULTA:' Consiste en que el SGBD tiene armado un plan de cómo va a acceder a
los datos, esto hace que el acceso sea más rápido. Los SP, Vistas y Funciones implementan un plan
de ejecución, es por esto que son más veloces que un query normal.
­El optimizador de consultas es el componente del sistema de gestión de base de ­datos que
intenta determinar la forma más eficiente de ejecutar una consulta SQL.
­Se decide cuál de los posibles planes de ejecución de una consulta dada es el más eficiente.
­Los optimizadores basados en costos asignan un costo (operaciones de E/S requeridas, CPU,
etc.) a cada uno de esos planes y se elige el que tiene menor costo.

'Por qué se establece que las Reglas del Negocio deben estar en el Motor de Base de Datos y no
en la aplicación cliente?'
- Reglas de negocio: cada aplicación debe reflejar las restricciones que existen en el negocio
dado, de modo que nunca sea posible realizar acciones no válidas.
- La información puede ser manipulada por muchos programas distintos que podrán variar de
acuerdo a los departamentos de la organización, los cuales tendrán distintas visiones y
necesidades pero que en cualquier caso, siempre deberán respetar las reglas de negocio.
- Es por lo anterior expuesto que las reglas del negocio deben estar en el motor de base de
datos.

'Describa los componentes básicos de un DBMS. Teniendo en cuenta la administración de
datos, la interfaz con el usuario y el procesamiento cliente­servidor.'
- Dos lenguajes: DML y DDL.
- 3 capas: externa (usuario), lógica (conceptual) e interna (física).
- Disk manager (recibe peticiones del file manager y las envía al SO), file manager (decide que página contiene el registro deseado y la solicita el disk manager) y user manager (permite la interacción con el usuario).
- Arquitectura cliente­servidor: las aplicaciones corren en el cliente y generan solicitudes para y reciben respuestas del servidor. El servidor realiza el procesamiento de datos y aplica las
reglas de negocio establecidas.
- Clustering: es la forma de agrupar la información. Hay dos formas, intra­file clustering (todas las tablas conviven con sus elementos) e inter­file clustering (se guarda cada objeto con sus relaciones).

'¿Qué beneficios brinda la aplicación de la normalización al diseño de un modelo de base de datos?'
- Evitar la redundanciade los datos.
- Evitar problemas de actualización de los datos en las tablas.
- Proteger la integridad de los datos.

'Cuál es el objetivo del algoritmo de Dijkstra?'

Es un algoritmo cuyo objetivo es determinar la ruta más corta, desde el nodo origen, hasta cualquier nodo de la red. Su metodología está basada en iteraciones, 
con lo cual su complejidad aumenta a medida que aumente el tamaño de la red. 
Para esto, hace uso y define etiquetas a partir del nodo origen y para cada uno de los nodos subsiguientes. Estas etiquetas contienen información relacionada 
con un valor acumulado del tamaño de los arcos y con la procedencia más próxima de la ruta.

'Desarrolle el concepto de Datawarehouse, en lo que respecta a utilidad, técnicas de armado, convivencia son modelos transacconales y acceso a la información.'
Un Data Warehouse es un almacén de información orientada a sujetos, integrada, variante en el tiempo, no volátil, organizados y orientados para la toma de decisiones. 
La información proviene de la integración de múltiples fuentes (bbdd relacionales, bbdd documentales, archivos, etc.). 
La idea de un data Warehouse es, mediante el data mining, explotar la información contenida y poder sacar buena información para la toma de decisiones. 
Los diferentes modelos de construcción son MOLAP (multidimensional), ROLAP (relacional) y HOLAP (hibrido).
Existen los data marts, que permiten contar con vistas multidimensionales de cada área que componen al data warehouse.
Tanto el DW como los data marts pueden ser implementados en un RDBMS utilizando el modelo estrella, en el cual la información está conformada por dos tipos de 
tablas: los hechos (definen métricas de un evento específico) y las dimensiones (definen características).

'¿Qué entiende por diccionario de datos, catálogo de datos o metadata?'
✔ Para representar una base de datos relacional, necesitamos almacenar no sólo las relaciones mismas, sino también una cantidad de información adicional acerca de las relaciones.
- El conjunto de tal información se llama diccionario de datos o metainformación.
- El diccionario de datos debe contener información como: nombre de las relaciones en la base de datos; nombre de los atributos de cada relación; dominio de cada atributo; tamaño
de cada relación; método de almacenamiento de cada relación; claves y otras restricciones de seguridad; nombres y definiciones de vistas.
- Además debe contener información sobre los usuarios de la base de datos y los poderes que éstos tienen: nombre de los usuarios; costo del uso efectuado por cada usuario; nivel de
privilegio de cada usuario.

-----------------------------------------------------------------
'a)Con un constraint check, se puede definir un rango de fecha preestablecido'
VERDADERO - CHECK CONSTRAINT → especifica condiciones al hacer un INSERT o UPDATE en una columna. Cada fila insertada o actualizada debe cumplir con dichas condiciones.

'b)Si un arbol binario de busqueda tiene N niveles, la cantidad maxima de lecturas sobre el mismo para encontrar una clave es N-1'
FALSO - en la busqueda de un elemento el maximo de niveles a recorrer es hasta el nivel de la hoja mas baja en el nivel N. Por lo cual debo hacer comparaciones hasta N veces y encontrar el valor (no N-1).
--------------------------------------------------------------------------
'a)En el algoritmo de Huffman, la cantidad de nodos es la siguiente: (total de hojas * 2)-1.'
VERDADERO

'b)Si una columna posee la constraint UNIQUE, entonces una sola fila como máximo puede contener NULL en dicha columna'
VERDADERO - cada valor debe ser distinto en la fila
--------------------------------------------------------------------------
'a)En una db Relacional las vistas pueden ser utilizadas para brindar consistencia de datos'
FALSO - Las transacciones son utilizadas para brindar consistencia de datos.

'b)En huffman si un caracter posee el codigo 0011, entonces con seguridad existe al menos otro cuyo codigo comienza con 001'
VERDADERO
--------------------------------------------------------------------------
'a)Un constraint de tipo CHECK siempre puede ser reemplazado por un trigger'
 VERDADERO
'b)Los Arboles B garantizan un numero de niveles menos que otro arboles' 
FALSO - Los árboles-B no garantizan menos niveles. Los niveles dependen de cosas como la cantidad de datos, el orden, el grado de completitud de un nodo, …
--------------------------------------------------------------------------
'a)Una columna afectada por una constraint UNIQUE no puede almacenar valores repetidos ni NULL'
FALSO - Puede almacenar un unico NULL
'b)Hashing es mas performante que el Arbol B en la busqueda de una clave unica en particular existente.'
VERDADERO - En el caso más general, Hashing es más performante que Árbol B: Hashing,
a partir de una clave, devuelve un índice de una tabla con la dirección de memoria del
registro con dicha clave, con el riesgo de que ocurran colisiones, por eso es más
performante que Árbol B en búsqueda por clave. De hecho, Árbol B es mejor para
búsquedas por rango. Sin embargo, siempre hay que tener en cuenta la distribución de
datos y como esté configurada la función de hash: si una búsqueda por hash produce
muchas colisiones para una misma clave, es probable que un Árbol B sea más performante
que Hashing.

TAMBIEN PUEDE SER FALSO - Si tenés que hacer rehashing 10000 veces para acceder
directo a una clave cuando podías agarrar la dirección de la primer hoja del árbol B, bueno,
ahí sí es más performante Árbol B
--------------------------------------------------------------------------
'a)Es posible implementar el concepto de ABB (Arbol Binario de Busqueda) en un Array'
VERDADERO
'b)Todo grafo de grado 2 es un arbol binario'
FALSO. De ser reflexivo ya el grafo no seria arbol.
--------------------------------------------------------------------------
'a)Si se desea que no se puedan eliminar registros de una tabla de auditoria, una opcion es crear un trigger que lo impida.'
VERDADERO
'b)La cantidad de nodos de un arbol de expresion siempre es par'
FALSO
--------------------------------------------------------------------------
'a)El Arbol B+ es un arbol Principal Derecho Balanceado'
VERDADERO - Es balanceado y el Arbol Principal Derecho todos los nodos noprincipales tienen un unico padre y el nodo principal es el minimal del arbol (llamado raiz) y es unico.
'b)Para entornos transaccionales de alta concurrencia es conveniente setear el Isolation Level en Repeatable Read'
FALSO - Dado que tiene un mayor alcance de lockeo de los registros, se verá afectada la performance. Es recomendable un nivel mas permisivo como read commited o read uncommited
--------------------------------------------------------------------------
'a) En caso de no querer eliminar registros de una tabla de audtoría, podría definirse un trigger para que lo impida.'
VERDADERO
'b) La cantidad de nodos de los árboles de expresión es siempre par.'
FALSO - Contraejemplo: {(x, 1), (y, 2)}.
--------------------------------------------------------------------------
'b) El algoritmo de Huffman obtiene los códigos comprimidos parseando un árbol binario balanceado'
FALSO El árbol binario no es necesariamente balanceado. Tomen como ejemplo el árbol que
surge de comprimir el texto "Tomemos como ejemplo esta frase. " con Huffman.
--------------------------------------------------------------------------
'a)En el arbol de Huffman la cantidad total de nodos es la siguiente:(total de hojas *2)-1'
VERDADERO
'b)La implementacion de la cantidad de entradas para claves en una tabla de hash es dinamica.'
FALSO - La implementación de las claves de hash pueden ser dinámicas o
estáticas.
--------------------------------------------------------------------------
'a)Si un arbol N-ario tiene un total de 2 niveles, entonces la profundidad maxima que alcanza un nodo en la transformada de Knuth es N'
VERDADERO siempre que N>2
'b)El nivel de aislamiento repeatable read acepta lecturas fantasmas'
VERDADERO
--------------------------------------------------------------------------
'a)El algoritmo de Huffman solo es aplicable a archivos de texto por la forma en que trabajan las repeticiones.'
FALSO
'b)Las foreign key son la unica forma que tienen las bases de datos para implementar la integridad relacional entre las tablas de un modelo.'
FALSO
--------------------------------------------------------------------------
'a)Si una funcion de hash no posee una buena dispersion, se van a producir muchas colisiones'
VERDADERO
'b)Nunca es posible ejecutar la operacion de insert sobre un vista'
FALSO - Se puede hacer un INSERT sobre una vista
--------------------------------------------------------------------------2
'a). El árbol de expresión siempre está balanceado en su raíz.'
FALSO - Contraejemplo: a + (b + c) * d.
'b)El Heapsort tiene peor rendimiento si los datos ya vienen ordenados.'
FALSO - El rendimiento del Heapsort es siempre constante y es O(n log n).
--------------------------------------------------------------------------
'a)Un arbol binario de busqueda siempre es un arbol completo'
FALSO
'b)En un trigger de update las tablas inserted y deleted tienen siempre la misma cantidad de registros'
VERDADERO
--------------------------------------------------------------------------
'a)El tiempo de ejecucion del Algoritmo de clasificacion HEAPSORT solo depende de la cantidad de elementos a ordenar.'
VERDADERO
'b)Un arbol de grado mayor a dos no puede ser representado mediante una representacion computacional estatica.'
FALSO
--------------------------------------------------------------------------
'a)Siempre es recomendable que toda la tabla indexada por ARBOL B+ tenga load factor.'
VERDADERO
Manejo del Load Factor
FILLFACTOR– Porcentaje de cada página del índice a ser dejado como espacio
libre en su creación. Por ej. Si el FILLFACTOR=20, en la creación del
índice se ocupará hasta el 80% de cada nodo.
CREATE UNIQUE INDEX ix1_ordenes ON ordenes(N_orden) WITH FILLFACTOR = 20
'b)Un nivel de aislamiento SERIALIZABLE es recomendable para no leer datos sucios de una tabla.'
VERDADERO
--------------------------------------------------------------------------
'a)Un sistema de Data Warehousing no permite la integracion de bases de datos heterogeneas (relacionales, documentales, geograficas, archivos, etc)'
FALSO
'b)Un trigger unicamente puede modificar datos de la tabla a la que pertenece'
FALSO
--------------------------------------------------------------------------
'a)La reexpresion de caracteres al aplicar huffman implica la disminucion de 8bits para la expresion de todos los caracteres.'
FALSO
'b)La ejecucion sin filas de resultado de una query dentro de un trigger genera la cancelacion de la transaccion.'
FALSO
--------------------------------------------------------------------------
'a)Los niveles de aislamiento permiten que no se generen deadlocks.'
FALSO - Repeatable read puede generar deadlocks.
'b)En SQL Server una tabla puede tener mas de un trigger INSTEAD OF INSERT'
FALSO
--------------------------------------------------------------------------
'a) El algoritmo de Huffman siempre se basa en árboles completos' 
FALSO. Puede ser que tengas un nodo a la derecha y 200 a la izquierda; todo depende de la frecuencia de los caracteres
'b) El algoritmo QuickSort es siempre más rápido que Heap Sort'
FALSO. QuickSort iba de O(n log n) a O(n^2) (creo; ya no me acuerdo),
mientras que HeapSort siempre tenía O(n log n)
--------------------------------------------------------------------------
'a)Si un arbol B tiene N claves entonces el grado es N+1'
FALSO
'b)Una sub consulta ubicada en el where siempre debe retornar al menos una fila'
FALSO
--------------------------------------------------------------------------
'a)Es posible asegurar Integridad Referencial entre dos tablas de Base de Datos Diferentes'
VERDADERO - Trigger
'b)La estructura de un ABB (Arbol Binario de Busqueda) es un arbol completo.'
FALSO
--------------------------------------------------------------------------
'a)Si una consulta posee la constraint de unique, entonces ninguna fila acepta nulos en dicha columna.'
FALSO. aceptara solo uno
'b)Al aplicar un barrido simetrico sobre un ABB se obtiene el conjunto de datos ordenado.'
VERDADERO
--------------------------------------------------------------------------
'a) Dada una tabla que tiene un trigger de INSERT; Si al insertar una fila sin ninguna transacción iniciada en la tabla, la acción disparada por el trigger falla, el insert de la fila no se inserta en la tabla. (Quedó
medio chota, por eso en el final el profesor aclaró que la afirmación se refiere a que no se insertan datos en la tabla)'
FALSO
'b) El árbol lleno y el árbol completo son dos tipos de árboles binarios balanceados.'
FALSO
--------------------------------------------------------------------------
'a)Las claves alternas, son posibles claves foraneas que pertenecen al conjunto de las claves candidatas'
FALSO. Claves PRIMARIAS
'b)El metodo de Hashing resuelve mas eficientemente las busquedas con rangos de claves.'
FALSO. ARBOL B+
--------------------------------------------------------------------------
'a)La siguiente consulta retorna como maximo 1 fila
SELECT distinct 1 FROM tabla1 WHERE campo1 = 1 union all SELECT distinct 1
FROM tabla1 WHERE campo2=2'
FALSO
'b)La cantidad de nodos de un arbol de huffman siempre es impar.'
VERDADERO
--------------------------------------------------------------------------
'a)El QuickSort es mas performante que el HeapSort, sin importar como vengan los datos (ordenados o desordenados)'
FALSO - misma performance para ambos
'b)Sobre un arbol n-ario con n>2 se pueden realizar los siguientes barridos (recorridos), preorden, simetrico, posorden y por niveles' 
FALSO - Solo por niveles
--------------------------------------------------------------------------
'b)La implementacion de la cantidad de entradas para claves en una tabla de hash es dinamica'
FALSO
--------------------------------------------------------------------------
'a)Toda consulta que utilice al menos una funcion de grupo debe ir acompañada de la clausula "group by"'
VERDADERO
'b)La ejecucion sin filas de resultado de una query dentro de un trigger siempre genera la cancelacion de la transaccion.'
FALSO
--------------------------------------------------------------------------
'a)Si tengo un conjunto de datos tendiendo a ordenados, el algoritmo de QuickSort es el mas eficiente para su ordenamiento total.'
FALSO.
'b)La accion que ejecuta un trigger y el evento que lo dispara siempre se ejecutan de manera atomica'
VERDADERO
--------------------------------------------------------------------------
'a)El Orden de complejidad de un ABB siempre es mejor que el Orden de complejidad del QuickSort'
FALSO
'b)Para comprimir en el algoritmo de Huffman, se debe leer en un ciclo cada caracter del archivo a comprimir y acceder al arbol desde la raiz para llegar a la hoja
 que contiene el caracter. Si desciendo por un hijoizquierdo agrego un 0 como bit del codigo comprimido, si desciendo por un hijo derecho agrego un 1.'
FALSO
------------------------------------------------------------------------
GRAFOS 

'Para representar grafos irrestrictos son más performantes las representaciones dinámicas que las estáticas.'
FALSO
Los grafos irrestrictos son más performantes si se implementan en forma estática, ya que de lo contrario tendrían que estar pidiendo espacio a memoria en forma continua.

'Para reducir espacio al representar un grafo siempre es más conveniente la forma dinámica que estática.'
VERDADERO
La forma dinámica ocupa menor cantidad de espacio que la estática, ya que la estática pide todo el espacio de entrada, sin aprovecharlo del todo.

'La única estructura de datos estática capaz de representar cualquier grafo es una matriz.'
VERDADERO
La matriz podría ser de adyacencia o de incidencia.

'Todo grafo de grado dos es binario.'
FALSO Contraejemplo: un grafo reflexivo.

'Dado el grafo G = {(E; P);E({a}), P({a; a}) se puede decir que es un árbol.'
FALSO 
No se puede decir que es un árbol porque es reflexivo.
-----------------------------------------------------------------
Árboles Árbol-B → árbol de búsqueda. AB → árbol binario.
ABB ​→ ​árbol binario de búsqueda.
AVL ​→ ​ABB en donde la diferencia entre las alturas de los
subárboles de cada uno de sus nodos es, como mucho, 1.

'El método de Árbol B no es aplicable a archivos con grandes volúmenes de datos.'
FALSO
El método de Árbol B sí es aplicable a grandes volúmenes de datos: es lo que utilizan los sistemas operativos para manejar sus sistemas de directorio y las bases de datos para manejar los índices.

'En un índice de un DBMS, armado en un Árbol B, el tiempo de acceso a la información depende en parte del tamaño de la clave almacenada.'
FALSO
El tiempo de acceso en un árbol-B depende del orden y de la altura.

'Dado el árbol {(c, a);(c, b);(c, d);(c, e)} su barrido simétrico es a, b, c, d, e.'
FALSO
No se puede hacer un barrido simétrico en un árbol no bi- nario.

'Si un árbol está balanceado entonces está completo.'
Verdadero si está estrictamente balanceado

'Un ABB siempre es más rápido que una lista para ordenar un conjunto de valores.' 
FALSO
Las velocidades de ordenamiento de un ABB y de una lista dependen del algoritmo de ordenamiento y de los 
datos.

'Un AB con cuatro nodos nunca puede ser completo.'
FALSO Contraejemplo: {(1, 2), (1, 3), (2, 4)}.

'Debido a que el crecimiento de un árbol es exponencial en base al ancho del mismo, los tiempos de búsqueda en el mismo son siempre logarítmicos.'
FALSO
Los tiempos de búsqueda sobre un árbol dependen de cosas como su balanceo.

'Un árbol de expresión siempre es completo.'
VERDAERO
Depende de lo que se interprete por “completo”: · Si se piensa por el lado de que todos los nodos no maximales tienen que tener el mismo grado, es completo.
Si se piensa por el lado de que para un árbol de profun- didad h, todos los nodos hasta h-1 tienen que tener grado 2 y el nivel h se completa de izquierda
a derecha, entonces no es completo.

'Un vector es una representación computacional estática que puede almacenar un árbol.' 
VERDADERO

'En un árbol de expresión los nodos maximales siempre son los operadores.'
FALSO
Los nodos maximales en un árbol de expresión son operandos.

'En la implementación de un Árbol B, todos los nodos de datos que contienen claves se encuentran en el mismo nivel.'
VERDADERO

'El Árbol B garantiza un número de niveles menor que otros árboles.'
FALSO
Los árboles-B no garantizan menos niveles. Los niveles dependen de cosas como la cantidad de datos, el orden, el grado de completitud de un nodo, …

'Si un AB está completo y balanceado todas las hojas están en el mismo nivel'
Depende de lo que se entienda por completo.Si es un árbol cuyos nodos no maximales tienen grado dos, es FALSO.
Si es un árbol que tiene una profundidad h y que todos los nodos hasta h-1 tienen grado dos y los que están en h se colocan de izquierda a derecha, es VERDADERO.

'Un árbol siempre tiene más punteros que elementos de datos.'
FALSO 
Un árbol implementado con un vector no tiene punteros.

'Un ABB recorrido en orden simétrico (infijo) siempre devuelve un conjunto de valores ordenados.'
VERDADERO
Un ABB recorrido en forma infija devuelve un conjunto de valores ordenados en forma ascendente.

'El árbol de expresión siempre está balanceado en su raíz.'
FALSO Contraejemplo: a + (b + c) * d.

'La cantidad de nodos en un árbol de expresión siempre es par.'
FALSO Contraejemplo: {(x, 1), (y, 2)}.

'Es posible implementar el concepto de ABB con un vector.'
VERDADERO

'Sobre un árbol n-ario con n>2, se pueden realizar los barridos pre-orden, simétrico, post-orden y por niveles.'
FALSO En un árbol n-ario con n>2 solamente se puede realizar el barrido por niveles.

'Cuando un ABB se basa en un AVL su orden de complejidad es el mejor n log2 n.'
FALSO El orden de complejidad de un árbol AVL es O(log n).

'El orden de complejidad de un ABB es similar al del Árbol B.'
FALSO El orden de complejidad de un árbol-B es mejor al de un ABB.

'Si un árbol binario de búsquedas N niveles, la cantidad de máxima de lecturas sobre el mismo para encontrar una clave es N-1'
FALSO

'El Árbol B+ es un Árbol Principal Derecho Balanceado'
FALSO

'La máxima cantidad de nodos que puede contener un árbol está acotada por el grado del mismo'
VERDADERO
---------------------------------------------------------------------------
Árboles – Métodos de Clasificación

'El orden de complejidad de un Árbol B siempre es mejor que el orden de complejidad del ​Quicksort​.'
FALSO
El orden de complejidad puede variar de acuerdo a cómo vengan ordenados los datos

'El orden de complejidad del ​Quicksort ​puede variar dependiendo de cómo vengan ordenados los datos.'
FALSO
El orden de complejidad del Quicksort depende de la elección del pivote. En el mejor de los casos, se elige el pivote que divide a la lista en dos partes iguales. Pero 
en el peor de los casos, se elige el pivote que divide a la lista en una gran lista y una muy pequeña.

'El algoritmo ​Quicksort ​tiene un promedio un grado de complejidad O(n log n) pero en determinada circunstancia puede tener grado de complejidad O(n²) y ser el peor de todos los métodos de clasificación.'
VERDADERO
Si bien es cierto que en el peor de los casos su orden de complejidad es O(n​2​), no es el peor algoritmo ya que, por ejemplo, el algoritmo de la burbuja también se comporta como O(n​2​)

'Si tengo un conjunto de datos tendiendo a ordenados, el algoritmo de ​Quicksort ​es el más eficiente para su ordenamiento total.'
FALSO
Quicksort puede llegar a ser bueno según la elección del pivote. Otro bueno podría ser Heapsort, que es in situ y con orden O(n · log n).

'El algoritmo ​Quicksort ​siempre tiene el mismo orden de complejidad que el algoritmo de ​Heapsort​.'
FALSO
El orden de complejidad de los algoritmos depende de cómo vengan ordenados los datos. Quicksort en el peor de los casos es O(n​2​), mientras que Heapsort es O(n log n).

'El ​Heapsort ​tiene peor rendimiento si los datos ya vienen ordenados.'
FALSO
El rendimiento del Heapsort es siempre constante y es O(n log n).

'La técnica de ​hashing ​puede generar muchas lecturas secuenciales para un valor clave ​hash ​cuando hay alto grado de repetición de claves de usuario.'
VERDADERO

'La técnica de ​hashing ​abierto puede generar muchas lecturas secuenciales para un valor “clave ​hash​” cuando hay alto grado de repetición de claves de usuario.'
SinRespuesta

'La técnica de ​hashing ​no puede ser implementada para uso de caché, ya que no garantiza el acceso de alta velocidad.'
SinRespuesta

'Una tabla de ​hash ​permite desarrollar un mecanismo indexado para recuperación de claves únicas.'
VERDADERO
También se permite para claves duplicadas.

'La implementación de la cantidad de entradas para claves en una tabla de ​hash ​es dinámica.'
FALSO
La implementación de las claves de hash pueden ser dinámicas o estáticas.

'La implementación de la cantidad de entradas para una tabla de ​hash ​es dinámica.'
FALSO
Puede ser dinámica o estática.

'Las funciones de ​hash ​no poseen funciones inversas.'
FALSO
Hay funciones hash que permiten la inversibilidad.
'Si una función de ​hash ​no posee una buena dispersión, se van a producir muchas colisiones.'
VERDADERO

'La implementación de un ​hash ​permite obtener a partir de una entrada "x" una salida "y" única y reversible.'
FALSO
La función de hash, ante una entrada determinada, devuelve siempre la misma salida. Hay situaciones en las que no se puede recuperar la entrada teniendo la salida.

---------------------------------------------------------------
Hashing vs Árbol-B

'La técnica de ​hashing ​es más rápida para el acceso a los datos que el Árbol B.'
SinRespuesta
Hashing es más veloz para accesos directos.
Árbol B es más veloz para accesos secuenciales.

'La técnica de ​hashing ​es más rápida para el tratamiento de claves duplicadas que el Árbol B.'
SinRespuesta

'La técnica de ​hashing ​es menos performante que el Árbol B para el manejo de claves duplicadas.'
VERDADERO

'Todos los DBMS utilizan la técnica de ​hashing ​para el armado de sus índices.'
FALSO 
No sólo se usa la técnica de hashing, sino también la de los árboles-B.

'La técnica de ​hashing ​es más performante que Árbol B en la búsqueda de una clave existente en particular.'
VERDADERO
Hashing es más veloz para accesos directos. Árbol B mejor para rangos
-------------------------------------------------------------------
Algoritmo de Huffman
'La compactación por algoritmo de Huffman permite redefinir el almacenamiento lógico de símbolos de tal manera que la pérdida de información sea despreciable.'
FALSO
La compactación por algoritmo de Huffman no pierde información, ya que es sin pérdida.

'El método de compresión de Huffman es sin pérdida, por eso no es recomendable para compactar imágenes o video.'
VERDADERO
Para reducir el tamaño de imágenes o videos, el algoritmo de Huffman no me servirá (es sin pérdida).
'La compresión que se logra mediante el algoritmo de Huffman es mayor cuando la variedad de caracteres diferentes que aparecen es menor.'
VERDADERO
Con menor cantidad de caracteres distintos, menor espacio ocupará cada carácter.

'Un árbol de Huffman es siempre completo.'
FALSO No quedan todas las hojas al mismo nivel

'En un árbol de Huffman, si el código del caracter "m" es 1011, entonces no puede ningún otro caracter poseer el código 1011111'
VERDADERO
Solamente los maximales tienen código… Si es maximal, no puede tener hijos.

'El algoritmo de Huffman obtiene los códigos comprimidos parseando un AB balanceado.'
FALSO
El árbol en el que se basa Huffman no está necesariamente balanceado.

'El árbol en el que se basa Huffman es principal derecho balanceado.'
FALSO El árbol en el que se basa Huffman no está necesariamente balanceado.

'En el algoritmo de Huffman, la cantidad de nodos es la siguiente: (total de hojas * 2) 1.'
VERDADERO

'La reexpresión de caracteres al aplicar Huffman implica la disminución de 8 bits para la expresión de todos los caracteres.'
FALSO
Cuando aplicamos Huffman, puede haber caracteres que terminan pesando más de 8 bits.

'Para comprimir en el algoritmo de Huffman, se debe leer en un ciclo cada carácter del archivo a comprimir y acceder al árbol desde la raíz para llegar a la hoja que contiene el carácter. Si desciendo por un hijo izquierdo,
agrego un 0 como bit del código comprimido. Si desciendo por un hijo derecho, agrego un 1 como bit del código comprimido.'
FALSO
Para comprimir, se empieza a buscar desde el nodo maximal hacia la raíz. Para descomprimir, se empieza a buscar desde la raíz hasta el nodo maximal.

'Si una palabra es capicúa, su código de Huffman también lo es.'
FALSO
Contraejemplo: el código Huffman de una palabra que empieza y termina con la misma letra, cuyo código es 001, será: 001…001.

'En Huffman si un caracter posee el código 0011, entonces con seguridad existe al menos otro caracter cuyo código comienza con 001'
VERDADERO
-------------------------------------------------------------------------------
Bases de Datos – Objetos de BD – RDBMS

'Un ​constraint ​de tipo CHECK siempre puede ser reemplazado por un ​trigger​.'
VERDADERO

'El checksum es una de las técnicas utilizadas para corroborar la integridad de los datos.'
VERDADERO

'En un modelo de DB OLTP el concepto de transacción está asociado a la atomicidad de procesamiento.'
FALSO
El concepto de transacción no solamente está asociado a la atomicidad, sino también a la consistencia, al aislamiento y a la durabilidad (ACID).

'Una vista en un RDBMS permite restringir el acceso a modelo y tener una vista simplificada del mismo.'
VERDADERO
Las vistas se usan para generar abstracciones más sencillas del modelo de datos. Además, pueden usarse para compartir código de una manera más segura ya que el cliente no tiene acceso al modelo de datos sino a la vista.

'Las claves foráneas brindan integridad relacional al modelo de datos y es su principal función.'
VERDADERO

'Las claves foráneas eliminan redundancia de datos.'
FALSO Aunque sean claves foráneas, puede haber redundancia de datos para mejorar la performance.

'Los índices aseguran unicidad de claves.'
FALSO

'Mediante la utilización de ​triggers ​se puede simular la integridad referencial entre tablas de diferentes bases de datos.'
VERDADERO

'En PL-SQL, la única diferencia entre una función y un ​stored procedure ​es que puede retornar valores.'
FALSO No es la única diferencia.

'Las únicas restricciones posibles a aplicar en el modelo relacional son por tabla.'
FALSO
También se pueden aplicar restricciones a nivel de columna y de BD, por ejemplo.

'Un índice en una BD relacional es una restricción al modelo físico.'
FALSO
Un índice es independiente del modelo físico y del modelo lógico.

'Una tabla no puede tener dos claves foráneas que referencian a la misma tabla.'
FALSO
Contraejemplo: un registro de una tabla Persona podría tener una clave foránea a la tabla Persona que simbolice la relación madre y una que simbolice la relación padre.

'Una clave primaria y una clave foránea son restricciones al modelo físico.'
FALSO
La clave primaria y la clave foránea son restricciones al modelo lógico.

'La vista conceptual o lógica se define mediante un esquema conceptual. Este esquema conceptual se escribe en DDL. Contiene definiciones del contenido de la base, tipos de datos,restricciones, reglas de integridad, etc.'
VERDADERO

'La ejecución de una query sin filas de resultado dentro de un Trigger ​genera la cancelación de la transacción.'
FALSO
El trigger continúa ejecutando incluso ante una consulta que no devuelva filas.

'La única forma de definir una restricción de integridad sobre una columna de una tabla es mediante la restricción CHECK.'
FALSO
Puedo usar triggers también.

'Nunca es posible ejecutar la operación de INSERT sobre una vista.'
FALSO
Se puede hacer un INSERT sobre una vista.

'En los RDBMS no está permitido hacer INSERTS sobre una vista.'
FALSO Se pueden hacer INSERTs sobre una vista.

'Luego de ejecutar una sentencia SQL para crear una tabla, si se ejecuta un rollback la tabla queda dropeada.'
FALSO
Para que quede dropeada, el CREATE TABLE se debería haber ejecutado dentro de una transacción.

'Siempre es conveniente tener una tabla indexada por su clave primaria.'
VERDADERO
Ya que es uno de los campos que más se utiliza para comparar.

'Una ​constraint ​es más eficiente que un ​trigger ​para validar el dominio de un atributo.'
VERDADERO
Una constraint se ejecuta en mucho menos tiempo que un trigger.

'Una vista es el equivalente a una consulta estática de una o más tablas.'
FALSO
Una vista es una consulta dinámica ya que cada vez que se usa, consulta las tablas. Es decir, puedes ejecutar la misma vista en dos momentos distintos y que me retornen dos resultados diferentes.

'La acción que ejecuta un ​trigger ​y el evento que lo dispara siempre se ejecutan de manera atómica.'
VERDADERO
La acción y el evento de un trigger conforman una transacción.

'La normalización aplicada al diseño de un modelo de datos relacional nos permite desarrollar un modelo de manera estructurada, independiente de la performance que ese
modelo pueda llegar a obtener.'
FALSO
La normalización no es independiente de la performance. En algunas ocasiones se desnormaliza para poder mejorar la performance.

'Los ​triggers ​son las funciones con las que cuenta un RDBMS que permite controlar la integridad referencial.'
VERDADERO
Si y también las constraints

'En un RDBMS, una función creada por el usuario puede modificar el contenido de una tabla de la base donde fue creada.'
FALSO Una función no puede tener efecto colateral.

'Un DBMS que soporta atomicidad, consistencia, aislamiento y durabilidad (ACID) puede ser considerado transaccional.'
VERDADERO Toda transacción cumple con las siglas ACID (atomicidad, consistencia, aislamiento y durabilidad).

'Las tablas INSERTED y DELETED pueden ser utilizados en ​stored procedures ​y funciones siempre que estos sean invocados dentro de un ​trigger​.'
FALSO
Los contextos de las funciones, de los stored procedures y de los triggers son distintos, por eso no las podrán usar a menos que se la pase por parámetro.


'No se pueden crear índices en las vistas.'
VERDADERO

'Si se tiene una vista que relaciona varias tablas y una de ellas posee un índice, el motor no puede utilizarlo para generar una consulta más performante.'
FALSO
Las vistas pueden usar los índices de las tablas a las que referencian, pero no pueden crearse índices sobre esas vistas.

'Se puede ejecutar un ​stored procedure ​en una consulta SELECT.'
FALSO

'Si se desea ocultar columnas de una tabla a una aplicación, el mejor objeto que podemos usar es un sinónimo.'
FALSO
Para este caso, si bien emplear un sinónimo no está mal, la vista es el mejor objeto a usar.

'Si se desea que no se puedan eliminar registro de una tabla de auditoría, una opción es crear un ​trigger ​que lo impida.'
VERDADERO
Un trigger sobre un DELETE podría anular la eliminación del registro.

'Gracias a los índices se puede asegurar la integridad referencial.'
FALSO
Los índices son utilizados para optimizar la busqueda de registros. La integridad se logra con constraints / triggers

'La única manera para asegurar unicidad de los campos es con una clave primaria o con UNIQUE'
FALSO
También se pueden usar triggers. Para entornos transaccionales de alta concurrencia es conveniente setear el isolation level en repeatable read

'En una bd relacional las vistas pueden ser utilizadas para brindar consistencia de datos'
FALSO
Las transacciones son para eso

'Los indices en una base de datos relacion solo sirven para aumentar la velocidad de acceso a los datos'
VERDADERO

'Un motor de base de datos relacional utiliza los conceptos de Álgebra relacional para la resolución de las consultas'
VERDADERO

'El modelo estrella no cumple con al menos una forma normal.'
VERDADERO

'La ejecución sin filas de resultado de una query dentro de un trigger genera la cancelación de la transacción'
FALSO
----------------------------------------------------------------------
Bussiness Intelligence (BDs multidimensionales – OLTP-OLAP – modelo STAR – Data Warehouse – Data Mining)

'Hipercubo y Multicubo son dos técnicas utilizadas para el armado de la capa interna de una Base de Datos Multidimensional.'
VERDADERO

'Un modelo OLAP posee al menos una tabla de hechos con campos precalculados.'
FALSO Un modelo OLAP no contiene tablas. El que contiene tablas es el Data Warehouse.

'En un modelo OLAP se puede aplicar normalización en cualquier tabla que no sea la tabla de hechos.'
FALSO
Un modelo OLAP no contiene tablas. El que contiene tablas es el Data Warehouse. Y se puede aplicar normalización en las tablas de dimensión.

'En un modelo OLAP se puede aplicar normalización en cualquier tabla de dimensión.'
VERDADERO

'El modelo OLAP no se puede implementar si no se tiene una BD Multidimensional.'
FALSO
El modelo OLAP se puede implementar sin una BD multidimensional, pero es conveniente no hacerlo.

'En el modelo OLAP no es aplicable la normalización de datos.'
FALSO Existen dos modelos: el modelo STAR (no normalizado) y el modelo SNOWFLAKE (normalizado).

'No es posible obtener el mismo resultado de una consulta OLAP a partir del OLTP que dio origen al mismo.'
FALSO

'El modelo STAR no cumple con al menos una forma normal.'
VERDADERO En el modelo STAR la tabla de dimensiones no están normalizadas.

'Una tabla de dimensión en el modelo STAR es el equivalente a una cara en un cubo de información multidimensional.'
FALSO
Un atributo en la tabla de dimensión se corresponde con una cara en el cubo.

'Las técnicas más comunes utilizadas en ​Data Mining ​son las redes neuronales, los árboles de decisión y las reglas de inducción.'
VERDADERO

'Data Mining ​son las técnicas y algoritmos utilizados para encontrar información y relaciones ocultas en un ​Data Warehouse​.'
VERDADERO
---------------------------------------------------------------------------
Consultas SQL

'Para poder realizar UNION entre dos consultas, las mismas deben tener la misma cantidad de columnas en el mismo orden e igual tipo de dato por cada una.'
VERDADERO
El UNION requiere que las dos consultas devuelvan la misma cantidad de columnas con el mismo tipo de datos. (Se entiende por columna, como las columnas impresas en los SELECT colum1, colum2, ect

'Un SELECT con 3 tablas en el FROM consume igual recursos que 3 SELECT con una tabla cada una.'
FALSO
Tres consultas consumen más recursos que una consulta a tres tablas.

'En SQL, una subconsulta ubicada en el WHERE siempre debe retornar una fila y una columna.'
FALSO
Una subconsulta en el WHERE podría retornar más de una columna si se lo usa con el operador IN.

'Si en una consulta SELECT, hay al menos una función de grupo (COUNT, SUM, AVG, …) siempre debe colocarse la cláusula GROUP BY en dicho SELECT.'
FALSO
Se puede hacer SELECT COUNT (*) FROM Libros.

'Un ​stored procedure ​posee la siguiente sentencia en su cuerpo: DELETE FROM tl_funciones WHERE tlstatus = 'Finalizada' Si al ejecutar el procedimiento no existe ningún registro que cumpla con
la citada condición, entonces la ejecución se cancela.'
FALSO
Se ejecuta y no borra nada

'Luego de ejecutar la siguiente instrucción:
CREATE TABLE miTablita (campo1 VARCHAR(5), campo2 VARCHAR(5))
y poblar la tabla, la siguiente igualdad va a ser siempre verdadera para cualquier set de datos posibles:
SELECT COUNT(campo1) FROM miTablita = SELECT COUNT(campo2) FROM miTablita​.'
FALSO
Como COUNT no cuenta los NULLs cuando es aplicado sobre un campo, si el número de NULLs en cada campo es diferente, las consultas van a ser distintas.

'Las siguientes consultas nunca devuelve el mismo resultado a excepción de la primera que siempre devuelve nada:
SELECT 1 FROM tablita WHERE campo1 = 1 OR campo2 = 2
SELECT 1 FROM tablita WHERE campo1 = 1 UNION SELECT 1 FROM tablita WHERE
campo2 = 2'
FALSO
La primera no devuelve NULL, sino un registro 1 por cada registro donde su campo1=1 o bien su campo2=2.

'Si una columna posee la ​constraint ​UNIQUE, entonces una sola fila como máximo puede contener NULL en dicha columna.'
VERDADERO

'Si existe un SELECT dentro de una cláusula HAVING, este debe retornar una fila y una columna.'
FALSO
Podría retornar más de una fila si se lo usa con el operador IN.

'Las siguientes consultas devuelven lo mismo sin importar el set de datos:
SELECT COUNT(campo1) FROM tabla = SELECT COUNT(*) FROM tabla​. La "tabla" sólo tiene la columna campo1.'
FALSO
No devuelven lo mismo.

'COUNT(campo1) no cuenta los valores nulos mientras que COUNT(*) sí cuenta los valores nulos. Una constraint de check puede utilizarse para validar que una fecha pertenezca a un rango predefinido'
VERDADERO
>>>>>>> a3610f4e881b2fbcfcadeaac3cb6a89ad034ff78
