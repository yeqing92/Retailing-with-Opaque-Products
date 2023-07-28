global ERq0;
global ER2q0;
ERq0=q0_ER;
ER2q0=q0_ER2;

global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;

%Value iteration
a=ave - .5*stdev*sqrt(12);
b=ave + .5*stdev*sqrt(12);
best_profit=0;
%for f=ceil(a/sc):floor(b/sc-1)
f=best_fp/sc;
for d=ceil(a/sc):f

%for d=f
    fp=f*sc;
    dp=d*sc;
   
    delta=fp-dp;
    if 2*dp-fp >=a
        pi_1=(b-fp)*(b+fp-4*(fp-dp)-2*a)/(2*(b-a)^2);
        pi_2=pi_1;
        pi_3=2*delta*(2*b-fp-dp)/(b-a)^2;
    elseif 2*dp-fp < a && 2*(fp-dp)< b-a
        pi_1=(b-a-2*delta)^2/(2*(b-a)^2);
        pi_2=pi_1;
        pi_3=(delta*(4*b-8*a+4*fp)-2*(fp-a)^2-6*delta^2)/(b-a)^2;
    else
        pi_1=0;
        pi_2=pi_1;
        pi_3=1;
    end
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