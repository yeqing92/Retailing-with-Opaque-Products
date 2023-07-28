

%Value iteration
a=ave - .5*stdev*sqrt(12);
b=ave + .5*stdev*sqrt(12);
best_profit=0;
for f=ceil(a/sc):floor(b/sc-1)
for d=f
    fp=f*sc;
    dp=d*sc;
    pi_1=(2*(b-fp)*(dp-a)+(b-fp)^2)/(2*(b-a)^2);
    pi_2=pi_1;
    pi_3=0;
    q=pi_3/(pi_1+pi_2+pi_3);

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
