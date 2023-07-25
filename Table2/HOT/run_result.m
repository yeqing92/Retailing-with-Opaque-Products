global ERq0;
global ER2q0;
ERq0=q0_ER;
ER2q0=q0_ER2;

global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;
h=1;
lambda=50;
aves=[100, 90 ];
%Ks=500:500:1000;
Ks=[1000,5000];
%K=5000;
MC=50;
sc=1;
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

tic
run('dp_fixed2_HOT.m');

Profits1=best_profit
c=best_c
fprintf('Fixed policy - p= %3.2f, c=%3.0f \n',best_fp,c);
run('dp_opaque_fixed2_HOT_avg.m');

Profits2=best_profit

best_fp=best_fp;
best_dp=best_dp;

% fprintf('Opqaque (avg) policy - p= %3.2f, d=%3.2f \n',best_fp, best_fp-best_dp)
% run('dp_opaque_fixed2_HOT_min.m');
% fprintf('Opqaque (min) policy - p= %3.2f, d=%3.2f \n',best_fp, best_fp-best_dp)
% run('dp_opaque_fixedp_HOT_avg_tau.m');
% run('dp_opaque_fixedp_HOT_min_tau.m');
% run('dp_opaque_HOT_avg_tau.m');
% run('dp_opaque_HOT_min_tau.m');
% 
run('dp_HOT_tau.m');
Profits3=-lambda*T_hk(1,1)
% % 
% run('dp_dream_HOT.m');
% fprintf('Dynamic pricing policy - p= %3.2f, d=%3.2f \n \n',best_fp, best_fp-best_dp)
% Profits3=-lambda*T_hk(1,1);

OutputTable(iii,:)=[K, ave, stdev, Profits1, Profits2, Profits3 , (Profits2-Profits1)/Profits1, (Profits3-Profits1)/Profits1];
% fprintf('Opaque (avg) Improvements - %3.2f%% \n',100*(Profits(2,:)./Profits(1,:)-1))
%fprintf('Opaque (min) Improvements - %3.2f%% \n',100*(Profits(3,:)./Profits(1,:)-1))
% fprintf('Dynamic Improvements - %3.2f%% \n',100*(Profits(9,:)./Profits(1,:)-1))

toc
end
%OutputTable=OutputTable
