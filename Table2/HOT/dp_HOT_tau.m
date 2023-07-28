% DP: solve dynamic programming using value iteration;
% in every inventory state, optimize the discount for the product with relatively more inventory

tau=.5;
h_k=100*zeros(c,c);
h_kminus1=-1000*rand(c,c);
T_hk=-1000*rand(c,c);
P1=zeros(c,c);
P2=zeros(c,c);
k=0;
t=stdev*sqrt(12);
a=ave+.5*t;
fp=best_fp;

%Value iteration
while max(max(abs(T_hk-tau*h_kminus1)))/min(min(abs(T_hk-tau*h_kminus1))+10^-5)> 1.01 || max(max(abs(h_k-h_kminus1)))>0.01
    k=k+1;
    for i=1:c
        for j=1:i
            bestT_hk=1000000;
            for d=ceil((a-t)/sc):fp/sc
                dp=d*sc;
                if (t-fp+dp)/(2*t) <= (a-fp)/t && (t-fp+dp)/(2*t) >=0
                    pi_small=(t-fp+dp)/(2*t);
                elseif (t-fp+dp)/(2*t) > (a-fp)/t && (a-fp)/t >=0
                    pi_small= (a-fp)/t;
                else
                    pi_small=0;
                end

                if (t-dp+fp)/(2*t) <= (a-dp)/t && (t-dp+fp)/(2*t)>=0
                    pi_big=(t+fp-dp)/(2*t);
                elseif (t-dp+fp)/(2*t) > (a-dp)/t && (a-dp)/t >=0
                    pi_big= (a-dp)/t;
                else
                    pi_big=0;
                end

             
                    if i<j && i>1
                        T_hk(i,j)=(i+j)*h/lambda+ pi_small*(tau*h_k(i-1,j)-fp+MC)+ pi_big*(tau*h_k(i,j-1)-dp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    elseif i<j && i==1
                        T_hk(i,j)=(i+j)*h/lambda+ pi_small*(tau*h_k(c,c)+K-fp+MC)+ pi_big*(tau*h_k(i,j-1)-dp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    elseif i>j && j>1
                        T_hk(i,j)=(i+j)*h/lambda+ pi_big*(tau*h_k(i-1,j)-dp+MC)+ pi_small*(tau*h_k(i,j-1)-fp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    elseif i>j && j==1
                        T_hk(i,j)=(i+j)*h/lambda+ pi_big*(tau*h_k(i-1,j)-dp+MC)+ pi_small*(tau*h_k(c,c)+K-fp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    elseif i==1 && j==1
                        T_hk(i,j)=(i+j)*h/lambda+ pi_big*(tau*h_k(c,c)+K-dp+MC)+ pi_small*(tau*h_k(c,c)+K-fp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    else
                        T_hk(i,j)=(i+j)*h/lambda+ pi_big*(tau*h_k(i-1,j)-dp+MC)+ pi_small*(tau*h_k(i,j-1)-fp+MC)+(1-pi_small-pi_big)*tau*h_k(i,j);
                    end
                if T_hk(i,j)<bestT_hk
                    bestT_hk=T_hk(i,j);
                    P1(i,j)=dp;
                    P2(i,j)=fp;
                    P1(j,i)=dp;
                    P2(j,i)=fp;
                end
            end
            T_hk(i,j)=bestT_hk;
            T_hk(j,i)=bestT_hk;
        end
    end
    h_kminus1=h_k;
    h_k=(1-tau)*h_k+ T_hk-T_hk(1,1);
end
Profits3=-lambda*T_hk(1,1);

