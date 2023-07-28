tic
tau=.5;
h_k=100*zeros(c1,c2);
h_kminus1=-100*rand(c1,c2);
T_hk=-100*rand(c1,c2);
P1=zeros(c1,c2);
P2=zeros(c1,c2);
k=0;

%Value iteration
mu=stdev*sqrt(6)/pi;
f=best_fp/sc;
while max(max(abs(h_k-h_kminus1)))> 0.01 || max(max(abs(T_hk-tau*h_kminus1)))/min(min(abs(T_hk-tau*h_kminus1))+10^-5)> 1.01
    if mod(k,5000)==0
        max(max(abs(T_hk-tau*h_kminus1)))/min(min(abs(T_hk-tau*h_kminus1))+10^-5)
        max(max(abs(h_k-h_kminus1)))
    end
    k=k+1;
    for i=1:c1
        for j=1:c2
            bestT_hk=100000;
            for d= ceil(0.8*best_fp/sc):f
                fp=f*sc;
                dp=d*sc;
                %
                if i>1 && j>1 && abs(j/(i-1) - rho)< abs((j-1)/i -rho)
                    % discount 1
                    p1 = dp;
                    p2 = fp;
                    pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    T_hk(i,j)=(i+j)*h/lambda+ pi_1*(tau*h_k(i-1,j)-p1+MC)+ pi_2*(tau*h_k(i,j-1)-p2+MC)+(1-pi_1-pi_2)*tau*h_k(i,j);

                elseif i>1 && j>1 && abs(j/(i-1) - rho)>= abs((j-1)/i -rho)
                    % discount 2
                    p1 = fp;
                    p2 = dp;
                    pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    T_hk(i,j)=(i+j)*h/lambda+ pi_1*(tau*h_k(i-1,j)-p1+MC)+ pi_2*(tau*h_k(i,j-1)-p2+MC)+(1-pi_1-pi_2)*tau*h_k(i,j);
                elseif i==1 && j>i
                    % discount 2
                    p1 = fp;
                    p2 = dp;
                    pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    T_hk(i,j)=(i+j)*h/lambda+ pi_1*(tau*h_k(c1,c2)+K-p1+MC)+ pi_2*(tau*h_k(i,j-1)-p2+MC)+(1-pi_1-pi_2)*tau*h_k(i,j);
                elseif i>j && j==1
                    %discount 1
                    p1 = dp;
                    p2 = fp;
                    pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    T_hk(i,j)=(i+j)*h/lambda+ pi_1*(tau*h_k(i-1,j)-p1+MC)+ pi_2*(tau*h_k(c1,c2)+K-p2+MC)+(1-pi_1-pi_2)*tau*h_k(i,j);
                elseif i==1 && j==1
                    p1 = dp;
                    p2 = fp;
                    pi_1 = exp((ave1-p1)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    pi_2= exp((ave2-p2)/mu)/(exp((ave2-p2)/mu)+exp((ave1-p1)/mu)+1);
                    T_hk(i,j)=(i+j)*h/lambda+ pi_1*(tau*h_k(c1,c2)+K-p1+MC)+ pi_2*(tau*h_k(c1,c2)+K-p2+MC)+(1-pi_1-pi_2)*tau*h_k(i,j);
                end
                if T_hk(i,j)<bestT_hk
                    bestT_hk=T_hk(i,j);
                    P1(i,j)=dp;
                    P2(i,j)=fp;
                end
            end
            T_hk(i,j)=bestT_hk;
        end
    end
    h_kminus1=h_k;
    h_k=(1-tau)*h_k+ T_hk-T_hk(1,1);
end

Profit=-lambda*T_hk(1,1)
toc



