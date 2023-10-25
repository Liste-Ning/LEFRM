import numpy as np
import pandas as pd

df1 = pd.read_excel('D:/code/Fig_factor_1850.xls') 
df1.head(2)

df3 = pd.read_excel('D:/code/ST_data.xlsx') 
df3.head(2)

aa = df1.drop(columns=['time', 'APT', 'human']).to_numpy() #1880-2017
x = aa[0:168]

y = df3.loc[0:167,['all_forcing']]

x1880 = x[30:168]
y1880 = y[30:168]
print(y1880)

x1880mean  = np.mean(x1880,axis=0)
x1880td    = np.std(x1880, axis=0)
x1880stand = (x1880 - x1880mean) / x1880td

y1880mean  = np.mean(y1880, axis=0)
y1880td    = np.std(y1880, axis=0)
y1880stand = (y1880 - y1880mean) / y1880td

from sklearn.cross_decomposition import PLSRegression

plsModel2 = PLSRegression(n_components=6, scale=False)  # False True
plsModel2.fit(x1880stand, y1880stand)
coef2  = plsModel2.coef_
inter2 = plsModel2.intercept_

x1880td_g   = np.tile(x1880td[:, np.newaxis], (1,1, ))
x1880mean_g = np.tile(x1880mean[:, np.newaxis], (1,1, ))
y1880td_g   = np.array(y1880td)[np.newaxis]

nocoef2 = coef2 * y1880td_g / x1880td_g
a2 = sum(nocoef2 * x1880mean_g)
nointer2 = inter2 * y1880td + y1880mean - a2

A = np.vstack((nocoef2,nointer2))

np.savetxt('coefficient_intercept_all_forcing.txt', A ,fmt='%f',delimiter=',')
np.savetxt('standardized_coefficient_all_forcing.txt', coef1 ,fmt='%f',delimiter=',')