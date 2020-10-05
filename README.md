# COVID19
Salario Real Disponible EEUU-MXN

El salario real disponible se realizó a través de los datos de ETOE INEGI 2020 correspondiente marzo a junio y los datos de "Personal Real Disposable Income" de la FRED, entonces para poder comparar aproximadamente estos datos.

DATOS:
FRED: https://fred.stlouisfed.org/series/DSPIC96 | MAR-JUN 2020
INEGI: https://www.inegi.org.mx/investigacion/etoe/ | MAR-JUN 2020
DOLAR: BANXICO
TABLA ISR: SHCP


------Salario mínimo real disponible MX-------
Primero calculamos el salario mínimo mensual reportado en la encuesta que es de $3746 mxn, después multiplicamos la cantidad de personas que ganan n salarios mínimos mensuales por el nivel de salario mínimo mensual reportado usando una como ejemplo una función PQ, donde Q es la cantidad de personas y P el nivel de salario mínimo mensual reportado en la ETOE.

El siguiente paso es hacer disponible el salario por bracket mediante la tabla de ISR mensual de la SHCP. Con esto tenemos un salario mínimo mensual disponible

Como bien sabemos para hacer una variable real necesita quitarse de la inflación por lo que usamos la inflación promedio de los periodos mar-jun reportada por INEGI y realizamos el proceso, con esto hacemos el salario mínimo real disponible, y lo hacemos en miles de millones de pesos mxn.

A continuación pasamos agruparlo en brackets de 1 a +5 salarios mínimos mensuales y realizamos la gráfica y observaremos la caída y ascenso de los salarios mínimos por bracket laboral.

--------------Real disposable personal income MXN-USD--------
Teniendo los datos anteriores podemos sacar una media por periodo, olvidando el bracket al que pertenezcan y de esta forma los ingresos serán de la nación.

El siguiente paso es comparar con los datos de la FRED del mismo periodo mar-jun expresado en billions usd. Al hacer una comparación internacional necesitamos que las cifras sean equivalentes en moneda y terminología científica por lo que tendríamos que dividir los datos de FRED para hacerlos en miles de millones (NO CONVERTIR A MXN).

Realizar la conversión de tipo de cambio mxn a usd a través de una media diaria en los periodos de mar-jun, por lo que de esta forma nuestros datos estarán en el mismo nivel.

Guardamos la información y ploteamos de forma logaritmica para que nuestros datos se vean mejor.

Listo!
