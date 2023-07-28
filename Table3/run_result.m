% Run this file to generate results in Table 3

% Parameters
h=1;
lambda=50;
ave1 = 100
aves=[100, 98, 96, 94, 92, 90];
K = 1000;
MC=50;
sc=0.2;
stdevs=[20, 10];
ii=0;

Parameters=zeros(12,2);
for i=1:2
    for j=1:2
        ii=ii+1;
        Parameters(ii,:)=[aves(i), stdevs(j)];
    end
end
            
OutputTable=zeros(12, 7);
for iii=1:12
    ave2 = Parameters(iii,1)
    stdev = Parameters(iii,2)
    tic
    % Step 1: find the optimal price and order-up-to level for traditional selliong for each setting
    run('dp_tr_asy_MNL_min.m');
    Profits1=best_profit
    c1 = best_c1
    c2 = best_c2
    fprintf('Fixed policy - p= %3.2\n', best_fp);
    
    % Step 2: find the optimal discount for opaque selling
    run('dp_opaque_asy_MNL_min.m');
    fprintf('Opqaque (avg) policy - p= %3.2f, d=%3.2f \n', best_fp, best_fp-best_dp)
    Profits2=best_profit
    best_fp=best_fp;
    best_dp=best_dp;

% Step 3: solve the dynamic pricing problem and save the profit
    run('dp_asy_MNL_tau.m');
    Profits3=-lambda*T_hk(1,1)
    OutputTable(iii,:)=[ave, stdev, Profits1, Profits2, Profits3 , (Profits2-Profits1)/Profits1, (Profits3-Profits1)/Profits1];
    toc
end

