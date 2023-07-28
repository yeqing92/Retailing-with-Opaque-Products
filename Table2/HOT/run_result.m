% The q-ER tables we use here are the same as in Figure 2
global ERq0;
global ER2q0;
ERq0=q0_ER;
ER2q0=q0_ER2;
global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;
%%%%%%%%%%%%
h=1;
lambda=50;
aves=[100, 90];
Ks=[1000,500];
MC=50;
sc=0.2;
stdevs=[20, 10];
ii=0;
Parameters=zeros(8,3);
for i=1:2
    for j=1:2
        for k=1:2
            ii=ii+1;
            Parameters(ii,:)=[Ks(i), aves(j), stdevs(k)];
        end
    end
end            
OutputTable=zeros(8,8);
for iii=1:8
    K=Parameters(iii,1)
    ave=Parameters(iii,2)
    avg=ave;
    stdev=Parameters(iii,3)
    %%%%%%%%%%%
    % Step 1: find the optimal price and order-up-to level for traditional selling
    tic
    run('dp_fixed2_HOT.m');
    Profits1=best_profit
    c=best_c
    fprintf('Fixed policy - p= %3.2f, c=%3.0f \n',best_fp,c);
    %%%%%%%%%%%
    % Step 2: given the optimal price and order-up-to level, find the optimal discount for opaque product
    run('dp_opaque_fixed2_HOT_avg.m');
    Profits2=best_profit
    best_fp=best_fp;
    best_dp=best_dp;
    %%%%%%%%%%%%%
    % Step 3: solve for the optimal dynamic pricing policy
    run('dp_HOT_tau.m');
    Profits3=-lambda*T_hk(1,1)
    OutputTable(iii,:)=[K, ave, stdev, Profits1, Profits2, Profits3 , (Profits2-Profits1)/Profits1, (Profits3-Profits1)/Profits1];
    toc
end
