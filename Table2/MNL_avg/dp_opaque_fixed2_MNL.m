global ERq0;
global ER2q0;
ERq0=q0_ER;
ER2q0=q0_ER2;

global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;

%Value iteration
mu=stdev*sqrt(6)/pi;
v=ave;
best_profit=0;
%for f=ceil((ave-2*stdev)/sc):floor((ave+2*stdev)/sc-1)
f=best_fp/sc;
for d=ceil((ave-2*stdev)/sc):f

%for d=f
    fp=f*sc;
    dp=d*sc;
    delta=fp-dp;
    [pi_1, pi_2 ,pi_3] = ComputeMNL3(fp,dp,avg,stdev);
    %pi_1=exp((v-fp)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1);
    %pi_2=pi_1;
    %pi_3=2*exp((v-fp+delta)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1)-2*exp((v-fp+delta)/mu)/(exp((v-fp+delta)/mu)+exp((v-fp+delta)/mu)+1);
    q=pi_3/(pi_1+pi_2+pi_3);

cost=computecost(q,c,h,K,lambda*(pi_1+pi_2+pi_3));
rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC)+pi_3*(dp-MC));
profit=rev-cost;


if profit > best_profit
    best_profit=profit;
    best_fp=fp;
    best_dp=dp;
end
end