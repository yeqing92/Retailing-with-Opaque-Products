from matplotlib import pyplot as plt
import pandas as pd
import numpy as np
import random
import math
import csv
from collections import Counter
import itertools
import copy
import os
import glob

rho = dict()
result_tr = dict()
result_op = dict()
Klist = np.arange(1000,10001,1000)

"""
Step 1: load the profit data file for MNL_min with different level of asymmetry
"""

name = 'MNL_min_100'
filename = "results_100_MNL_min_op.csv"
result_tr[name]= dict.fromkeys(Klist,[])
result_op[name]= dict.fromkeys(Klist,[])
rho[name]= dict.fromkeys(Klist,0)
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_op[name][int(rows[0])]= [i for i in rows]

filename = "results_100_MNL_min_tr.csv"
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_tr[name][int(rows[0])]= [i for i in rows]

name = 'MNL_min_90'
filename = "results_90_MNL_min_op.csv"
result_tr['MNL_min_90']= dict.fromkeys(Klist,[])
result_op['MNL_min_90']= dict.fromkeys(Klist,[])
rho[name]= dict.fromkeys(Klist,0)
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_op['MNL_min_90'][int(rows[0])]= [i for i in rows]
filename = "results_90_MNL_min_tr.csv"
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_tr['MNL_min_90'][int(rows[0])]= [i for i in rows]

name = 'MNL_min_95'
filename = "results_95_MNL_min_op.csv"
result_tr[name]= dict.fromkeys(Klist,[])
result_op[name]= dict.fromkeys(Klist,[])
rho[name]= dict.fromkeys(Klist,0)
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_op[name][int(rows[0])]= [i for i in rows]
filename = "results_95_MNL_min_tr.csv"
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_tr[name][int(rows[0])]= [i for i in rows]
          
name = 'MNL_min_85'
filename = "results_85_MNL_min_op.csv"
result_tr[name]= dict.fromkeys(Klist,[])
result_op[name]= dict.fromkeys(Klist,[])
rho[name]= dict.fromkeys(Klist,0)
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_op[name][int(rows[0])]= [i for i in rows]
filename = "results_85_MNL_min_tr.csv"
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_tr[name][int(rows[0])]= [i for i in rows]

name = 'MNL_min_80'
filename = "results_80_MNL_min_op.csv"
result_tr[name]= dict.fromkeys(Klist,[])
result_op[name]= dict.fromkeys(Klist,[])
rho[name]= dict.fromkeys(Klist,0)
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_op[name][int(rows[0])]= [i for i in rows]
filename = "results_80_MNL_min_tr.csv"
with open(filename, mode='r') as inp:
    reader = csv.reader(inp)
    for rows in reader:
        if len(rows)>0:
            result_tr[name][int(rows[0])]= [i for i in rows]

"""
Step 2: calculate $\rho^{tr}$
"""
demandList = ["MNL_min_100", "MNL_min_95", 'MNL_min_90',  'MNL_min_85', 'MNL_min_80']
inputList = [100, 95, 90, 85, 80]
for i in range(len(demandList)):
    demand = "MNL_min"
    demand_input = [100, inputList[i], 20]
    for K in Klist:
        p = float(result_tr[demandList[i]][K][-2])
        (q1, q2, qo) = demand_distribution(demand, demand_input, p, 0)
        rho[demandList[i]][K] = float(q1)/q2

"""
Step 3: Plot
"""
fig = plt.figure(figsize=(18, 9))
demandList = ["MNL_min_100", "MNL_min_95", 'MNL_min_90',  'MNL_min_85', 'MNL_min_80']
legendList = [r'$\mu_1 = 100$',r'$\mu_1 = 95$',r'$\mu_1 = 90$',r'$\mu_1 = 85$',r'$\mu_1 = 80$']

# % change in profit
ax = plt.subplot(2, 3, 1)
for i in range(len(demandList)):
    demand = demandList[i]
    plt.plot(Klist, [100*float((float(result_op[demand][K][2]) - float(result_tr[demand][K][2]) ))/float( 
        result_tr[demand][K][2]) for K in Klist], label=legendList[i])
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([0,1,2,3])
plt.ylabel('% Change in Profit', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.legend(loc='best',fontsize='x-large',shadow=True, fancybox=True)
plt.xlim(1000,10000)

# percentage of opaque customers
ax = plt.subplot(2, 3, 2)
for demand in demandList:
    plt.plot(Klist, [float(result_op[demand][K][-2] ) for K in Klist], label=demand)
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([0, 5, 10, 15])
plt.ylabel('Opaque Customers (%)', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)

# % change in cost
ax = plt.subplot(2, 3, 3)
for demand in demandList:
    plt.plot(Klist, [100*(float(result_op[demand][K][5]) +float ( result_op[demand][K][6]) - float( result_tr[demand][K][5]) -float (result_tr[demand][K][6]))/(float( result_tr[demand][K][5]) +float(result_tr[demand][K][6])) for K in Klist], label=demand)
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([-3, -2, -1, 0])
plt.ylabel('% Change in Cost/Unit Sold', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)

# % change in revenue
ax = plt.subplot(2, 3, 4)
for demand in demandList:
    plt.plot(Klist, [100*float((float(result_op[demand][K][3]) - float(result_tr[demand][K][3]) ))/ float(result_tr[demand][K][3]) for K in Klist], label=demand)
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.ylabel('% Change in Revenue', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)
plt.yticks([-0.2 , 0, 0.2, 0.4])

# imbalance in demand: rho
ax = plt.subplot(2, 3, 5)
for demand in demandList:
    plt.plot(Klist, [float(rho[demand][K])  for K in Klist], label=demand)
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.ylabel(r'$\rho^{tr}$', fontsize = 14)
plt.xlabel('K', fontsize = 14)
plt.yticks([0, 0.5, 1, 1.5, 2, 2.5, 3])
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)

# % discount
ax = plt.subplot(2, 3, 6)
for demand in demandList:
    plt.plot(Klist, [100*float(float(result_op[demand][K][-1]))/ float(result_tr[demand][K][-2]) for K in Klist], label=demand)
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([0,1,2,3,4,5,6])
plt.ylabel('Opaque Discount (%)', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)

plt.show()
# figure is saved as PDF in the same folder
fig.savefig('fig_asym_profit.pdf',bbox_inches='tight') 
