from buildingspy.io.outputfile import Reader
import pandas as pd
import numpy as np


finame = "ChillerPlantSystem_FMU.mat"

ofr1 = Reader(finame, "dymola") 

variables = ofr1.varNames()


keywords = ['Ent.T','senMasFloCHW.m_flow','senMasFloCW.m_flow','Lea.T','senMasFlo.m_flow','.TWetBul','weaBus.TDryBul','.dP','.P']

df = pd.DataFrame()

for variable in variables:
         
         for keyword in keywords:
         
                   if variable[-len(keyword):] == keyword:
                   
                              print variable
                   
                              (time, temp) = ofr1.values(variable)
                              
                              print len(temp)
                                                            
                              df[variable] =  temp


df['time'] = time

sample_time=np.arange(df['time'].iloc[0]+86400,df['time'].iloc[0]+86400*8,60)

df2 = pd.DataFrame()

df2['time'] = sample_time

df = df.merge(df2, on = ["time"], how ='inner')

df = df.sort_values(by=['time'])

df = df.interpolate()

df = df.drop_duplicates('time')

df.to_csv('chiller.csv')