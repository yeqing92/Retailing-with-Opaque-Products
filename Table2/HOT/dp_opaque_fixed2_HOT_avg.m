global ERq0;
global ER2q0;
ERq0=q0_ER;
ER2q0=q0_ER2;

global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;

%Value iteration
t=stdev*sqrt(12);
a=ave+.5*t;
best_profit=0;
%for f=ceil((a-t)/sc):floor(a/sc)
f=best_fp/sc;
for d=ceil((a-t)/sc):f

%for d=f
    fp=f*sc;
    dp=d*sc;
    delta=fp-dp;
    if (t-2*delta)/(2*t) <= (a-fp)/t && (t-2*delta)/(2*t) >=0
        pi_1=(t-2*delta)/(2*t);
    elseif (t-2*delta)/(2*t) > (a-fp)/t && (a-fp)/t >=0
        pi_1= (a-fp)/t;
    else
        pi_1=0;
    end
    pi_2=pi_1;

    if 2*a-t-2*fp+2*delta>=0
        pi_3=min(1,2*delta/t);
    else
        pi_3=0;
    end
    q=pi_3/(pi_1+pi_2+pi_3);

cost=computecost(q,c,h,K,lambda*(pi_1+pi_2+pi_3));
rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC)+pi_3*(dp-MC));
profit=rev-cost;


if profit > best_profit
    best_profit=profit;
    best_fp=fp;
    best_dp=dp;
    q=q;
end
end
