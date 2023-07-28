
tau=.5;
h_k=100*zeros(c,c);
h_kminus1=100*rand(c,c);
T_hk=100*rand(c,c);
P1=zeros(c,c);
P2=zeros(c,c);
k=0;

%Value iteration
mu=stdev*sqrt(6)/pi;
v=ave;
f=best_fp/sc;
while max(max(abs(h_k-h_kminus1)))>0.01 ||max(max(abs(T_hk-tau*h_kminus1)))/min(min(abs(T_hk-tau*h_kminus1))+10^-5)> 1.01 
        
    if mod(k,1000)==0
max(max(abs(T_hk-tau*h_kminus1)))/min(min(abs(T_hk-tau*h_kminus1))+10^-5)
max(max(abs(h_k-h_kminus1)))
    end
    k=k+1;
    for i=1:c
        for j=1:i
            bestT_hk=1000;
            for d=ceil(.8*best_fp/sc):f
                fp=f*sc;
                dp=d*sc;
                pi_small=exp((v-fp)/mu)/(exp((v-dp)/mu)+exp((v-fp)/mu)+1);
                pi_big=exp((v-dp)/mu)/(exp((v-dp)/mu)+exp((v-fp)/mu)+1);
                
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


