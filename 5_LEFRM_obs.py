import numpy as np
import pandas as pd

df1 = pd.read_excel('D:/code/Fig_factor_1850.xls') 
df1.head(2)

df2 = pd.read_excel('D:/code/ST_data.xlsx') 
df2.head(2)

aa = df1.drop(columns=['time', 'APT', 'human']).to_numpy() #1880-2017
x = aa[30:168]

y1 = df2.loc[30:167,['Imax']]
y2 = df2.loc[30:167,['Imin']]
y3 = df2.loc[30:167,['BE']]
y4 = df2.loc[30:167,['HadCRUT5']]
y5 = df2.loc[30:167,['GISTEMP']]
y6 = df2.loc[30:167,['NOAAGlobalTemp']]
y = np.hstack((y1,y2,y3,y4,y5,y6))
yavg = np.mean(y,axis=1)

x1880 = x
y1880 = yavg

x1880mean  = np.mean(x1880,axis=0)
x1880td    = np.std(x1880, axis=0)
x1880stand = (x1880 - x1880mean) / x1880td

y1880mean  = np.mean(y1880, axis=0)
y1880td    = np.std(y1880, axis=0)
y1880stand = (y1880 - y1880mean) / y1880td

from sklearn.cross_decomposition import PLSRegression

plsModel1 = PLSRegression(n_components=6, scale=False)  # False True
plsModel1.fit(x1880stand, y1880stand)
coef1 = plsModel1.coef_
inter1 = plsModel1.intercept_

x1880td_g   = np.tile(x1880td[:, np.newaxis], (1,1, ))
x1880mean_g = np.tile(x1880mean[:, np.newaxis], (1,1, ))
y1880td_g   = np.array(y1880td)[np.newaxis]

nocoef1 = coef1 * y1880td_g / x1880td_g
a1 = sum(nocoef1 * x1880mean_g)
nointer1 = inter1 * y1880td + y1880mean - a1
A = np.vstack((nocoef1,nointer1))

np.savetxt('coefficient_intercept.txt',A,fmt='%f',delimiter=',')
np.savetxt('standardized_coefficient.txt', coef1 ,fmt='%f',delimiter=',')