# Generate data in Figure 3 and 4
"""
The code contains 3 parts:
1) the supporting functions,
2) calculate profit for each parameter setting,
3) save to file.
"""
# Asymmetric MNL demand and the opaque option is valued as the minimum of the valuation of the two products

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

"""
Part 1: functions
"""

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
            elif (i1>1.5) and (i2> 1.5) and (np.abs(float(i2)/(i1-1)-float(q2)/q1) < np.abs(float(i2-1)/i1- float(q2)/q1)):
                J1[index1+1][index2+1] = 1+q1*J1[index1][index2+1]+q2*J1[index1+1][index2]+qo*J1[index1][index2+1]
                J2[index1+1][index2+1] = q1*J2[index1][index2+1]+q2*J2[index1+1][index2]+qo*J2[index1][index2+1]
            elif (i1>1.5) and (i2> 1.5) and (np.abs(float(i2)/(i1-1)-float(q2)/q1) >= np.abs(float(i2-1)/i1- float(q2)/q1)):
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
#    calculate the profit from traditional selling
    (q_1, q_2, q_o) = demand_distribution(demand, demand_input, p, 0)
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
    # calculate the profit with opaque selling
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
# return the optimal price and S that maximize the profit for the traditional selling
    profit = [[compute_profit_tr(p, c, S, arr_rate, h, K,demand, demand_input)[0] for S in SList] for p in pList]
    (index1, index2) = np.where(profit == max(max(profit)))
    pstar = pList[index1[0]]
    Sstar = SList[index2[0]]
    return(pstar, Sstar)


def find_optimal_op(dList, p, S1, S2, c, arr_rate, h, K, demand, demand_input):
# return the optimal discount that maximizes the average profit given price and order-up-to levels
    profit = [compute_profit_op(p, c, discount, S1, S2, arr_rate, h, K, demand, demand_input)[0] for discount in dList]
    index = np.argmax(profit)
    dstar = dList[index]
    return(dstar)

"""
Search for the optimal price and S for the traditional policy, then search for the optimal discount, finally evaluate 
"""
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


"""
Part 2: compute profit for each parameter setting

Note: adjust the search range of price, S, and discount for each setting,
      make sure that the optimal solution searched is in the middle of the searching range.
"""
c = 50
m1 = 100
m2 = 80 # change m2 to 85, 90, 95, and 100 to generate the other 4 scenarios in Figure 3 and 4
stdev = 20
arr_rate = 50
h = 1

demand = "MNL_min" # change demand to "MNL_avg", "HOT_avg", "UNI_avg" for other settings
m = stdev*np.sqrt(6)/math.pi
demand_input = [m1, m2, m]

result_tr = dict()
result_op = dict()
Klist = np.arange(1000,10001,1000)
result_tr[demand]= dict.fromkeys(Klist,[])
result_op[demand]= dict.fromkeys(Klist,[])

############################################
K = 1000
pList = np.arange(95.5, 96.4, 0.01)  
SList = np.arange(252,261,2)
dList = np.arange(2.9, 3.5, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 2000
pList = np.arange(96.2, 97, 0.01)
SList = np.arange(342, 353, 2)
dList = np.arange(3, 3.4, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 3000
pList = np.arange(97, 97.8, 0.01)
SList = np.arange(418, 428, 2)
dList = np.arange(3.2, 3.6, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 4000
pList = np.arange(97.1, 98, 0.01)
SList = np.arange(496, 508, 2)
dList = np.arange(3.4, 4, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 5000
pList = np.arange(97.7, 98.4, 0.01)
SList = np.arange(556, 570, 2)
dList = np.arange(4.5, 4.8, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 6000
pList = np.arange(98, 98.8, 0.01)
SList = np.arange(588, 600, 2)
dList = np.arange(4.6, 5.4, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 7000
pList = np.arange(98.2, 99, 0.01)
SList = np.arange(648, 657, 2)
dList = np.arange(4.6, 5.2, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 8000
pList = np.arange(98.5, 99.5, 0.01)
SList = np.arange(680, 690, 2)
dList = np.arange(4.6, 5, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 9000
pList = np.arange(99, 100, 0.01)
SList = np.arange(736, 750, 2)
dList = np.arange(5.1, 6, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

#########################
K = 10000
pList = np.arange(99.4, 100, 0.01)
SList = np.arange(768, 780, 2)
dList = np.arange(5.4, 5.8, 0.01)
resultList = result(demand, demand_input, c, arr_rate, h, K, pList, SList, dList)
result_tr[demand][K]=[ i for i in resultList[0]]
result_op[demand][K]=[ i for i in resultList[1]]

"""
Part 3: save to file
"""
for K in Klist:
    txtname = "results_"+str(m2)+"_" +demand + "_tr.csv"
    with open(txtname, "a") as f:
        writer = csv.writer(f)
        writer.writerows([result_tr[demand][K]])

    txtname = "results_"+str(m2)+"_" +demand + "_op.csv"
    with open(txtname, "a") as f:
        writer = csv.writer(f)  
        writer.writerows([result_op[demand][K]])
         
