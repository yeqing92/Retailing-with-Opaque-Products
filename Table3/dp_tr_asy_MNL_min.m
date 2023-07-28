
mu=stdev*sqrt(6)/pi;
best_profit=0;
for f=ceil((ave1-2*stdev)/sc):floor((ave1+2*stdev)/sc-1)
  fp = f*sc;
  p1 = fp;
  p2 = fp;
  pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
  pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
  % pi_1 = exp((v-fp)/mu)/(exp((v-fp)/mu)+exp((v-fp)/mu)+1);
  % pi_1=exp((v-fp)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1);
  % pi_2=pi_1;
  % pi_3=2*exp((v-fp+delta)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1)-2*exp((v-fp+delta)/mu)/(exp((v-fp+delta)/mu)+exp((v-fp+delta)/mu)+1);
  % q=pi_3/(pi_1+pi_2+pi_3);
  pi_3=0;
(*     q=pi_3/(pi_1+pi_2+pi_3); *)
  for c=50:500
    ratio = pi_2/pi_1
    c1=round(c/(1+ratio))
    c2=(c-c1)
(*     cost=computecost(q,c,h,K,lambda*(pi_1+pi_2+pi_3)); *)
    [cost,Policy]= RatioMatching2(c1, c2, lambda*(pi_1+pi_2), pi_1, pi_2, pi_3, K, h);
    rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC)+pi_3*(dp-MC));
    profit=rev-cost;
  
    if profit > best_profit
        best_profit=profit;
        best_fp = fp;
        best_c1 = c1;
        best_c2 = c2;
    end
  end
end
