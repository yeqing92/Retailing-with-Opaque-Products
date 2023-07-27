

%Value iteration
t=stdev*sqrt(12);
a=ave+.5*t;
best_profit=0;
for f=ceil((a-t)/sc):floor(a/sc)
for d=f
    fp=f*sc;
    dp=d*sc;
    if (t-fp+dp)/(2*t) <= (a-fp)/t && (t-fp+dp)/(2*t) >=0
        pi_1=(t-fp+dp)/(2*t);
    elseif (t-fp+dp)/(2*t) > (a-fp)/t && (a-fp)/t >=0
        pi_1= (a-fp)/t;
    else
        pi_1=0;
    end
    pi_2=pi_1;
    pi_3=0;
    q=0;
 for c=1:500
cost=computecost(q,c,h,K,lambda*(pi_1+pi_2+pi_3));
rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC)+pi_3*(dp-MC));
profit=rev-cost;


if profit > best_profit
    best_profit=profit;
    best_fp=fp;
    best_dp=dp;
    best_c=c;
end
 end
end
end