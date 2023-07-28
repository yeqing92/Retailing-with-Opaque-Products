mu=stdev*sqrt(6)/pi;
best_profit=0;
f=best_fp/sc;
for d=ceil((ave2-stdev)/sc):f
  fp=f*sc;
  dp=d*sc;
  delta=fp-dp;
  pi_1=exp((ave1-fp)/mu)/(exp((ave1-fp)/mu)+exp((ave2-fp+delta)/mu)+1);
  pi_2= exp((ave2-fp)/mu)/(exp((ave2-fp)/mu)+exp((ave1-fp+delta)/mu)+1);
  pi_3= exp((ave1-fp+delta)/mu)/(exp((ave2-fp)/mu)+exp((ave1-fp+delta)/mu)+1)+ exp((ave2-fp+delta)/mu)/(exp((ave1-fp)/mu)+exp((ave2-fp+delta)/mu)+1)-exp((ave1-fp+delta)/mu)/(exp((ave1-fp+delta)/mu)+exp((ave2-fp+delta)/mu)+1)- exp((ave2-fp+delta)/mu)/(exp((ave1-fp+delta)/mu)+exp((ave2-fp+delta)/mu)+1);
  q1=pi_1/(pi_1+pi_2+pi_3);
  q2=pi_2/(pi_1+pi_2+pi_3);
  q3=pi_3/(pi_1+pi_2+pi_3);
  [cost,Policy]= RatioMatching2(c1,c2,lambda*(pi_1+pi_2+pi_3),q1,q2,q3,K,h);
  rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC)+pi_3*(dp-MC));
  profit=rev-cost;
  if profit > best_profit
      best_profit=profit;
      best_fp=fp;
      best_dp=dp;
  end
end
