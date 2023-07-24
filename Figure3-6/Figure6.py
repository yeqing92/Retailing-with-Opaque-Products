
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

# Functions
def matchRatio(q_1, q_2, S):
    if q_1-q_2<1e-5:
        S1 = round(float(S)/2)
    else:
        ratio = float(q_2)/q_1
        S1 = round(float(S)/(1+ratio))
        
    S2 = S - S1
    return (S1, S2)

def demand_distribution(demand, demand_input, p, discount):
    if demand == "MNL_min":
        (q1, q2, qo) = demand_MNL_min(demand_input, p, discount)
    elif demand =="MNL_avg":
        (q1, q2, qo) = demand_MNL_avg(demand_input, p, discount)
    elif demand == "HOT_avg":
        (q1, q2, qo) = demand_Hot_avg(demand_input, p, discount)
    elif demand =="UNI_avg":
        (q1, q2, qo) = demand_UNI_avg(demand_input, p, discount)
    else:
        print("error: input wrong")
    return (q1, q2, qo)



def demand_MNL_min(mu, p, discount):
    # only one price
    m1 = mu[0]
    m2 = mu[1]
    m = mu[2]
    A = np.exp(float(m1-p)/m)
    B = np.exp(float(m2-p)/m)
    C = np.exp(float(m1-p+discount)/m)
    D = np.exp(float(m2-p+discount)/m)
    q1 = float(A)/(1+A+D)
    q2 = float(B)/(1+B+C)
    qo = float(C)/(1+C+B) + float(D)/(1+D+A) - float(C+D)/(1+C+D) 
    return (q1, q2, qo)


def demand_Hot_avg(demand_input, p, discount):
    # only one price
    a = demand_input[0]
    t = demand_input[1]
    q1 = 0
    q2 = 0
    qo = 0
    A = float(t-2*discount)/2
    B = a - p
    if (A<=B) and (A>0):
        q1 = float(A)/t
        q2 = float(A)/t
    elif (A>B):
        q1 = float(B)/t
        q2 = q1
    if A<=B:
        qo = min(1, float(2*discount)/t)
    return (q1, q2, qo)


def demand_MNL_avg(mu, p, discount):
    # only one price
    # simulate 10^7 smaples
    m1 = mu[0]
    m2 = mu[1]
    m = mu[2]
    k = 1000000
    
    V0 = np.random.gumbel(0, m, k)
    V1 = m1 + np.random.gumbel(0, m, k) 
    V2 = m2 + np.random.gumbel(0, m, k) 
    V3 = [(V1[i]+V2[i])/2 for i in range(k)]
    
    q1 =sum([ 1 if (V1[i]-p>V0[i]) and (V1[i]>V2[i]) and (V1[i] > V3[i]+discount) else 0 for i in range(k)])/k
    q2 = sum([ 1 if (V2[i]-p>V0[i]) and (V2[i]>V1[i]) and (V2[i] > V3[i]+discount) else 0 for i in range(k)])/k
    qo = sum([ 1 if (V3[i]-p+discount>V0[i]) and (V3[i]+discount>V1[i]) and (V3[i] + discount > V2[i]) else 0 for i in range(k)])/k
    if m1==m2:
        q1 = float(q1+q2)/2
        q2 = q1
    return (q1, q2, qo)


def demand_UNI_avg(demand_input, p, discount):
    # only one price
    a = demand_input[0]
    b = demand_input[1]
    q1 = 0
    q2 = 0
    qo = 0
    if (p-2*discount-a>=0):
        q1 = float((b - p)*(b + p - 4*discount - 2*a))/(2*(b-a)*(b-a))
        q2 = q1
        qo = float(2*discount *(discount +2*b - 2*p))/((b-a)*(b-a))
    elif (2*discount-b+a < 0):
        q1 = float((b-a-2*discount)*(b-a-2*discount))/(2*(b-a)*(b-a))
        q2 = q1
        qo = float(discount*(4*b - 8*a + 4*p) - 2*(p-a)*(p-a) - 6 * discount*discount)/((b-a)*(b-a))
    else:
        qo = 1
    return (q1, q2, qo)

def find_ER(S1, S2, q1, q2, qo):
    rho = 1
    if q1>0:
        rho = float(q2)/q1
    
    J1 =np.zeros((S1+1, S2+1))
    J2 =np.zeros((S1+1, S2+1))
    for i in np.arange(1,S1+S2+1):
        for i1 in np.arange(max(0,i-S2), min(i,S1)+1):
            i2 = i - i1
            index1 = i1-1
            index2 = i2-1
            if (i1==1) and (i2>=1):
                J1[index1+1][index2+1] = 1+q1*J1[index1][index2+1]+q2*J1[index1+1][index2]+qo*J1[index1+1][index2]
                J2[index1+1][index2+1] = q1*J2[index1][index2+1]+q2*J2[index1+1][index2]+qo*J2[index1+1][index2]
            elif (i2==1) and (i1>=1):
                J1[index1+1][index2+1] = 1+q1*J1[index1][index2+1]+q2*J1[index1+1][index2]+qo*J1[index1][index2+1]
                J2[index1+1][index2+1] = q1*J2[index1][index2+1]+q2*J2[index1+1][index2]+qo*J2[index1][index2+1]
            elif (i1>1.5) and (i2> 1.5) and (np.abs(float(i2)/(i1-1)-rho)< np.abs(float(i2-1)/i1- rho)):
                J1[index1+1][index2+1] = 1+q1*J1[index1][index2+1]+q2*J1[index1+1][index2]+qo*J1[index1][index2+1]
                J2[index1+1][index2+1] = q1*J2[index1][index2+1]+q2*J2[index1+1][index2]+qo*J2[index1][index2+1]
            elif (i1>1.5) and (i2> 1.5) and (np.abs(float(i2)/(i1-1)-rho) >= np.abs(float(i2-1)/i1- rho)):
                J1[index1+1][index2+1] = 1+q1*J1[index1][index2+1]+q2*J1[index1+1][index2]+qo*J1[index1+1][index2]
                J2[index1+1][index2+1] = q1*J2[index1][index2+1]+q2*J2[index1+1][index2]+qo*J2[index1+1][index2]
            else:
                J2[index1+1][index2+1] =(S1+S2-i)**2          
                
    ER = J1[S1][S2]
    ER2 = J2[S1][S2]
    return (ER, ER2)
    
"""
traditional selling
input: price, total inventory, total arrival rate, cost parameters
compute demand q1, q2, qo;
construct S1, S2
output: costs, revenue, profit
"""
def compute_profit_tr(p, c, S, arr_rate, h, K, demand, demand_input):
    #print((demand, demand_input, p, discount))
    (q_1, q_2, q_o) = demand_distribution(demand, demand_input, p, 0)
#     print((q_1, q_2, q_o))
    (S1, S2)= matchRatio(q_1, q_2,S)
    lamb_tr = arr_rate*(q_1+q_2+q_o)
    
    q1 = q_1/(q_1 +q_2 + q_o)
    q2 = q_2/(q_1+q_2+q_o)
    qo = q_o/(q_1+q_2+q_o)

    (ER,ER2)=find_ER(S1, S2, q1, q2, qo)
    HC = float(((2*S+1)*ER-ER2)*h)/(2*ER)
    KC= float(lamb_tr*K)/ER;
    revenue = (p-c)* lamb_tr
    totalCost = HC+KC
    HC = HC/lamb_tr
    KC = KC/lamb_tr
    profit = revenue - totalCost
    return (profit, revenue, totalCost, HC, KC , S1, S2 )

def compute_profit_op(p, c, discount, S1, S2, arr_rate, h, K, demand, demand_input):
    
    (q_1, q_2, q_o) = demand_distribution(demand, demand_input, p, discount)
    lamb_tr = arr_rate*(q_1+q_2+q_o)
    
    q1 = q_1/(q_1+q_2+q_o)
    q2 = q_2/(q_1+q_2+q_o)
    qo = 1-q1-q2

    (ER,ER2)=find_ER(S1, S2, q1, q2, qo)
    
    S = S1+S2
    
    HC = float(((2*S+1)*ER-ER2)*h)/(2*ER)
    KC=float(lamb_tr*K)/ER
   
    revenue = (p-c)* arr_rate*(q_1+q_2) + (p-c-discount)*arr_rate*q_o
    
    totalCost = HC+KC
    HC = HC/lamb_tr
    KC = KC/lamb_tr
    profit = revenue - totalCost
    return ( profit, revenue,totalCost, HC, KC, qo)


def find_optimal_tr(pList, SList, c, arr_rate, h, K, demand, demand_input):
# return the optimal price and S
    profit = [[compute_profit_tr(p, c, S, arr_rate, h, K,demand, demand_input)[0] for S in SList] for p in pList]
    (index1, index2) = np.where(profit == max(max(profit)))
    pstar = pList[index1[0]]
    Sstar = SList[index2[0]]
#     print(index2)
#     print(profit[index1[0]][index2[0]])
    return(pstar, Sstar)



def find_optimal_op(dList, p, S1, S2, c, arr_rate, h, K, demand, demand_input):
# return the optimal discount
    profit = [compute_profit_op(p, c, discount, S1, S2, arr_rate, h, K, demand, demand_input)[0] for discount in dList]
    index = np.argmax(profit)
    dstar = dList[index]
#     print(index)
#     print(profit[index])
    return(dstar)



def result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList):
    (pstar,Sstar) = find_optimal_tr(pList, SList, c, arr_rate, h, K, demand, demand_input)
    print("result")
    print("K = "+str(K))
    print( (pstar, Sstar))
    (profit, revenue, totalCost, HC, KC , S1, S2) = compute_profit_tr(pstar, c, Sstar, arr_rate, h, K, demand, demand_input)
    print((profit, revenue, totalCost, HC, KC , S1, S2))
    discount = find_optimal_op(dList, pstar, S1, S2, c, arr_rate, h, K, demand, demand_input)
    print(discount)
    (profit_op, rev_op, totalCost_op, HC_op, KC_op, qo) = compute_profit_op(pstar, c, discount, S1, S2, arr_rate, h, K, demand, demand_input)
    print((profit_op, rev_op, totalCost_op, HC_op, KC_op, qo))
    return ([K, demand, profit, revenue, totalCost, HC, KC , S1, S2, pstar, Sstar], [K, demand, profit_op, rev_op, totalCost_op, HC_op, KC_op, qo*100, discount])

#
result_tr = dict()
result_op = dict()
Klist =[int(i) for i in np.arange(1000,10001,1000)]

#############
c = 50
mean = 100
stdev = 20
arr_rate = 50
h = 1
SList = [400]

demand = "HOT_avg"
t = stdev*np.sqrt(12)
a = mean + 0.5*t
demand_input = [a, t]

result_tr[demand]= dict.fromkeys(Klist,[])
result_op[demand]= dict.fromkeys(Klist,[])

pList = np.arange(99, 108, 0.1)
dList = np.arange(0.1, 10, 0.1)

for K in Klist:
    resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
    result_tr[demand][K]=[ i for i in resultList[0]]
    result_op[demand][K]=[ i for i in resultList[1]]
    
#############

demand ="UNI_avg"
a = mean - stdev*np.sqrt(12)/2
b = mean + stdev*np.sqrt(12)/2
demand_input = [a, b]

result_tr[demand]= dict.fromkeys(Klist,[])
result_op[demand]= dict.fromkeys(Klist,[])

pList = np.arange(99, 111, 0.1)
dList = np.arange(0.1, 5, 0.1)

for K in Klist:
    resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
    result_tr[demand][K]=[ i for i in resultList[0]]
    result_op[demand][K]=[ i for i in resultList[1]]

############################################################
demand = "MNL_min"
m = stdev*np.sqrt(6)/math.pi
demand_input = [mean, mean, m]

result_tr[demand]= dict.fromkeys(Klist,[])
result_op[demand]= dict.fromkeys(Klist,[])

pList = np.arange(99, 110.5, 0.1)
dList = np.arange(2, 10, 0.1)
for K in Klist:
    resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
    result_tr[demand][K]=[ i for i in resultList[0]]
    result_op[demand][K]=[ i for i in resultList[1]]

###########################################################
demand = "MNL_avg"
m = stdev*np.sqrt(6)/math.pi
demand_input = [mean, mean, m]

result_tr[demand]= dict.fromkeys(Klist,[])
result_op[demand]= dict.fromkeys(Klist,[])

pList = [np.arange(98, 101.2, 0.1), np.arange(100, 102.1, 0.1), 
         np.arange(100, 102.1, 0.1), np.arange(102, 114.1, 0.1),
         np.arange(103, 105.2, 0.1), np.arange(103, 105.1, 0.1), 
         np.arange(104, 106.1, 0.1), np.arange(105, 107.1, 0.1),
         np.arange(107, 109.1, 0.1), np.arange(107, 109.1, 0.1)]
    
dList = [np.arange( 2,  4 ,  0.1), np.arange( 2,  4 ,  0.1),
         np.arange( 1.5, 3.1 ,  0.1), np.arange( 2, 4,  0.1),
         np.arange( 2,  5.1 ,  0.1), np.arange( 2,  5.1 ,  0.1),
         np.arange(4, 6.1, 0.1), np.arange(3, 7.1, 0.1),
        np.arange(3,6, 0.1), np.arange(3,7, 0.1)]

for i in range(len(Klist)):
    K = Klist[i]
    resultList = result(demand, demand_input, c, arr_rate, h, K, pList[i], SList, dList[i])
    result_tr[demand][K]=[ i for i in resultList[0]]
    result_op[demand][K]=[ i for i in resultList[1]]
    

# Finally, generate Figure 6

fig = plt.figure(figsize=(18, 5))
demandList = ["MNL_avg", "HOT_avg", "UNI_avg", "MNL_min"]
legendList = ["MNL (avg)", "HOT (avg)", "UNI (avg)", "MNL (min)"]

# % change in profit
ax = plt.subplot(1, 3, 1)

for i in range(len(demandList)):
    demand = demandList[i]
    plt.plot(Klist, [100*float((float(result_op[demand][K][2]) - float(result_tr[demand][K][2]) ))/float( 
        result_tr[demand][K][2]) for K in Klist], label=legendList[i])
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([0,5, 10])

plt.ylabel('% Change in Profit', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)

plt.xlim(1000,10000)
plt.ylim(0,10)

# % of opaque customers
ax = plt.subplot(1, 3, 2)

for demand in demandList:
    plt.plot(Klist, [float(result_op[demand][K][-2] ) for K in Klist], label=legendList[i])

plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([0, 10,20, 30])

plt.ylabel('Opaque Customers (%)', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)

# % change in cost
ax = plt.subplot(1, 3, 3)

for i in range(len(demandList)):
    demand = demandList[i]
    plt.plot(Klist, [100*(float(result_op[demand][K][5]) +float ( result_op[demand][K][6]) - float( result_tr[demand][K][5])
                          -float (result_tr[demand][K][6]))/(float( result_tr[demand][K][5]) +float(result_tr[demand][K][6])) 
                     for K in Klist], label=legendList[i])
plt.xticks([2000, 4000, 6000, 8000, 10000])
plt.yticks([ -6 ,-4,  -2, 0])
plt.ylabel('% Change in Cost/Unit Sold', fontsize = 14)
plt.xlabel('K', fontsize = 14)
ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
plt.xlim(1000,10000)
plt.legend(loc='best',fontsize='x-large',shadow=True, fancybox=True)
plt.show()

# # figure is saved as PDF in the same folder
fig.savefig('fig_profit_fixedS400_20.pdf',bbox_inches='tight') 
