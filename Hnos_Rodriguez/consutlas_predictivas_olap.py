# -*- coding: utf-8 -*-
"""Consutlas Predictivas_olap.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/124WGMCGpDiu-BKevbTbLZkJG_0yPameC
"""

!pip install pandasql

#Para hacer las consultas se cargaran las bases en csv, se obtendran las consultas encesarias y se operara sobre estas.
import pandas as pd
import numpy as np
import pandasql as ps

"""#1. En base a la edad de un nuevo cliente, predecir con que tipo de pago realizara su compra. 

Para esta consulta, primero debemos de obtener los datos correspondientes a las tablas de cliente, hechos y tipo pago:
"""

hechos=pd.read_csv('/content/hechos.csv')
cliente=pd.read_csv('/content/cliente.csv')
pago = pd.read_csv('/content/pago.csv')

"""Teniendo los datos cargados, realizamos una consulta para obtener las tuplas correspondientes a las fechas de los clientes y sus tipos de pago registrados."""

#Guardamos en una tabla el dataframe correspondiente a las fechas de nacimiento de los clientes registrados junto con sus tipos de pago. 
q1="""SELECT 
fecha_nacimiento, tipo_pago_id
FROM
cliente JOIN hechos ON cliente.cliente_id == hechos.cliente_id"""
data = ps.sqldf(q1,locals())

data.head()

#Cambiamos el tipo de dato a fecha para operar con esta columna.
data['fecha_nacimiento'] = pd.to_datetime(data['fecha_nacimiento'], format='%Y/%m/%d')
data.sort_values(by='fecha_nacimiento')

"""Teniendo los datos ordenados, procedemos a realizar el algoritmo de K-Nearest Neighbors"""

def predict_payment_type(date_birth, k=7):   
  '''
  A la funcion se le pasa una fecha a consultar junto con 
  el numero de vecinos en el quese fijara el
  algoritmo para realizar la busqueda.
  '''
  date_birth = pd.to_datetime(date_birth, format='%Y/%m/%d')
  labels = list(set(data['tipo_pago_id']))

  vals = range(len(labels))
  lbls = zip(labels,vals)
  labels_dict = dict(lbls)
  freqs = [0]*len(labels)

  backward = k//2 
  forward = k//2 + 1

  forwards = list(data[data['fecha_nacimiento'] > date_birth]['tipo_pago_id'])
  backwards = list(data[data['fecha_nacimiento'] < date_birth]['tipo_pago_id'])
  backwards.reverse()

  distance_1 = min(len(backwards),backward)
  distance_2 = min(len(forwards),forward)

  for i in range(distance_1):
    labl = backwards[i]
    freqs[labels_dict[labl]]+=1

  for i in range(distance_2):
    labl = forwards[i]
    freqs[labels_dict[labl]]+=1
  
  prediction_index = np.argmax(freqs)

  return list(labels_dict.keys())[prediction_index]

print(predict_payment_type('1970-10-28'))
print(predict_payment_type('1974-06-03'))
print(predict_payment_type('1999-07-12'))

"""#2. En base a la edad de un nuevo cliente, predecir si es asiduo o eventual.

Esta consulta se puede hacer de manera muy similar a la anterior utilizando el algoritmo de KNN, la unica diferencia estara en las etiquietas que se evaluaran.
"""

tipo_cliente = pd.read_csv('/content/tipo_cliente.csv')

#Guardamos en una tabla el dataframe correspondiente a las fechas de nacimiento de los clientes registrados junto con sus tipos de pago. 
q2="""SELECT 
fecha_nacimiento, tipo_cliente_desc
FROM
cliente JOIN tipo_cliente ON cliente.tipo_clente_id == tipo_cliente.tipo_clente_id"""
data2 = ps.sqldf(q2,locals())
data2['fecha_nacimiento'] = pd.to_datetime(data2['fecha_nacimiento'], format='%Y/%m/%d')
data2.sort_values(by='fecha_nacimiento')
data2.head()

def predict_client_type(date_birth, k=7):   
  '''
  A la funcion se le pasa una fecha a consultar junto con 
  el numero de vecinos en el quese fijara el
  algoritmo para realizar la busqueda.
  '''
  date_birth = pd.to_datetime(date_birth, format='%Y/%m/%d')
  labels = list(set(data2['tipo_cliente_desc']))

  vals = range(len(labels))
  lbls = zip(labels,vals)
  labels_dict = dict(lbls)
  freqs = [0]*len(labels)

  backward = k//2 
  forward = k//2 + 1

  forwards = list(data2[data2['fecha_nacimiento'] > date_birth]['tipo_cliente_desc'])
  backwards = list(data2[data2['fecha_nacimiento'] < date_birth]['tipo_cliente_desc'])
  backwards.reverse()

  distance_1 = min(len(backwards),backward)
  distance_2 = min(len(forwards),forward)

  for i in range(distance_1):
    labl = backwards[i]
    freqs[labels_dict[labl]]+=1

  for i in range(distance_2):
    labl = forwards[i]
    freqs[labels_dict[labl]]+=1
  
  prediction_index = np.argmax(freqs)

  return list(labels_dict.keys())[prediction_index]

#Realizamos las consultas predectivas con la funcion creada anteriormente
print(predict_client_type('1970-10-28'))
print(predict_client_type('1974-06-03'))
print(predict_client_type('1999-07-12'))

"""#3. Predecir entradas vendidas por mes. 

Tomaremos los datos de hechos y horarios para poder obtener la fecha de las visitas al cine y el numero de entradas que se compraron por mes.
"""

hechos=pd.read_csv('hechos.csv')
horario=pd.read_csv('horario.csv')

"""Uniremos las dos tablas necesarias mediante una consulta de sql para poder obtener las fechas y numero de entradas compradas por los clientes"""

q1="""SELECT fecha, sum(num_entradas) as num_entradas, importe 
FROM
horario JOIN hechos ON horario.hora == hechos.hora
GROUP BY fecha
"""
data = ps.sqldf(q1,locals())

"""Agruparemos los datos por mes, es decir, sumaremos todas las entradas vendidas en Enero, después las de Febrero y asi sucesivamente para obtener los totales vendidos por mes."""

data['fecha'] = pd.to_datetime(data['fecha'], format='%Y/%m/%d')
data.sort_values(by='fecha')
data.index = data['fecha']
data.resample("M").sum()

import matplotlib.pyplot as plt
plt.figure(figsize=(12,6))
plt.plot(data.num_entradas)
plt.title('Entradas vendidas por mes')
plt.grid()
plt.show()

"""Utilizaremos medias moviles para poder encontrar el patron con el que los cliente visitan y compran entradas en el cine, utilizando una ventana de 2 meses obtenermos la siguiente aproximación."""

def moving_mean(serie,n):
    return np.average(serie[-n:])

from sklearn.metrics import mean_absolute_error

def mean_absolute_porcentage_error(y_true, y_pred):
    return np.mean(np.abs((y_true-y_pred)/y_true))*100

def plotMovingAverage(series, window, intervals=False, scale=1.96, plot_anomalies=False):
    rolling_mean = series.rolling(window=window).mean()
    plt.figure(figsize=(15,3))
    plt.title('Media movil \ntamaño de ventana ={}'.format(window))
    plt.plot(rolling_mean,'g', label='Tendencia por media movil')

    #Intervalo de confianza
    if intervals:
        mae = mean_absolute_error(series[window:], rolling_mean[window:])
        deviation = np.std(series[window:]-rolling_mean[window:])
        lower_bound = rolling_mean - (mae + scale * deviation)
        upper_bound = rolling_mean + (mae + scale * deviation)
        plt.plot(lower_bound, 'r--', label='Límite sup/inf')
        plt.plot(upper_bound, 'r--')

    #Anomalias
    if plot_anomalies:
        anomalies = pd.DataFrame(index=series.index, columns=series.columns)
        anomalies[series < lower_bound ]= series[ series < lower_bound]
        anomalies[series > upper_bound ]= series[ series > upper_bound]
        plt.plot(anomalies, 'ro', markersize =10)

    plt.plot(series[window:], label='Valores reales')
    plt.legend(loc='upper left')
    plt.grid(True)
    plt.show()

plotMovingAverage(data.num_entradas,2,intervals=True, scale=1.96)

"""Tambien aplicando K-vecinos cercanos podemos obtener una predicción sobre el número de entradas que se venderán en determinada fecha."""

def predict_tickets(date, consult, k=7):   
  '''
  A la funcion se le pasa una fecha a consultar junto con 
  el numero de vecinos en el quese fijara el
  algoritmo para realizar la busqueda.
  '''
  date = pd.to_datetime(date, format='%Y/%m/%d')
  labels = list(set(consult['num_entradas']))

  vals = range(len(labels))
  lbls = zip(labels,vals)
  labels_dict = dict(lbls)
  freqs = [0]*len(labels)

  backward = k//2 
  forward = k//2 + 1

  forwards = list(consult[consult['fecha'] > date]['num_entradas'])
  backwards = list(consult[consult['fecha'] < date]['num_entradas'])
  backwards.reverse()

  distance_1 = min(len(backwards),backward)
  distance_2 = min(len(forwards),forward)

  for i in range(distance_1):
    labl = backwards[i]
    freqs[labels_dict[labl]]+=1

  for i in range(distance_2):
    labl = forwards[i]
    freqs[labels_dict[labl]]+=1
  
  prediction_index = np.argmax(freqs)

  return list(labels_dict.keys())[prediction_index]

print(predict_tickets('2020-01-31',data))
print(predict_tickets('2000-10-03',data))

"""## 4.Decidir tipo de sala en oferta"""

import pandas as pd 
import pandasql as ps
import numpy

hechos=pd.read_csv('/hechos.csv')
sala =pd.read_csv('/sala.csv')
tipo_sala =pd.read_csv('/tipo_sala.csv')

hechos.head()

q1="""select NUM_ENTRADAS as "entradas",s.TIPO_SALA_ID
from hechos join sala s on HECHOS.SALA_ID = s.sala_id join sala s2 on s.TIPO_SALA_ID = s2.tipo_sala_id


"""
data = ps.sqldf(q1,locals())

data.head()

import numpy as np 
from matplotlib import pylab as plt 
plt.rcParams['figure.figsize']=(10,9)
plt.style.use('ggplot')

f2= data.entradas.values
f1= data.tipo_sala_id.values
plt.scatter(f1,f2,s=10)

from sklearn.cluster import KMeans
X = np.array(list(zip(f1,f2)))
kmeans = KMeans(n_clusters=1)
kmeans = kmeans.fit(X)
y=kmeans.predict(X)
C_ = kmeans.cluster_centers_
C_

fig , ax = plt.subplots()
ax.scatter(X[:,0],X[:,1],c=y)
ax.scatter(C_[:,0],C_[:,1],marker='*',s=200,c='k')