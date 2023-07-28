% no opaque, search for the best price and order up to level

mu=stdev*sqrt(6)/pi;
best_profit=0;
for f=ceil((ave2-stdev)/sc):floor((ave1+stdev)/sc-1)
  fp = f*sc;
  p1 = fp;
  p2 = fp;
  pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
  pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
  q1=pi_1/(pi_1+pi_2);
  q2=pi_2/(pi_1+pi_2);
  rho = pi_2/pi_1;
  % pi_1 = exp((v-fp)/mu)/(exp((v-fp)/mu)+exp((v-fp)/mu)+1);
  % pi_1=exp((v-fp)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1);
  % pi_2=pi_1;
  % pi_3=2*exp((v-fp+delta)/mu)/(exp((v-fp)/mu)+exp((v-fp+delta)/mu)+1)-2*exp((v-fp+delta)/mu)/(exp((v-fp+delta)/mu)+exp((v-fp+delta)/mu)+1);
  % q=pi_3/(pi_1+pi_2+pi_3);
  q3=1-q1-q2;
  for c=50:500
    ratio = pi_2/pi_1;
    c1=round(c/(1+ratio));
    c2=c-c1;
    [cost,Policy]= RatioMatching2(c1, c2, lambda*(pi_1+pi_2), q1, q2, q3, K, h);
    rev=lambda*(pi_1*(fp-MC)+pi_2*(fp-MC));
    profit=rev-cost;
  
    if profit > best_profit
        best_profit=profit;
        best_fp = fp;
        best_c1 = c1;
        best_c2 = c2;
        best_rho = rho;
    end
  end
end
