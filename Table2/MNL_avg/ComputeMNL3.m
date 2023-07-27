function [pi1, pi2 ,pi3] = ComputeMNL3(rt,ro,avg,stdev)
k=10^7;
%V_0=0;
V_0=-evrnd(0, sqrt(6)/pi*stdev,k,1);
V_1=avg-evrnd(0, sqrt(6)/pi*stdev,k,1);
V_2=avg-evrnd(0, sqrt(6)/pi*stdev,k,1);
V_3=(V_1+V_2)/2;

pi1= sum((V_1-rt>V_0).*(V_1-rt>V_2-rt).*(V_1-rt > V_3-ro))/k;
pi2= sum((V_2-rt>V_0).*(V_2-rt>V_1-rt).*(V_2-rt > V_3-ro))/k;
pi3= sum((V_3-ro>V_0).*(V_3-ro>V_1-rt).*(V_3-ro > V_2-rt))/k;

pi1=(pi1+pi2)/2;
pi2=pi1;