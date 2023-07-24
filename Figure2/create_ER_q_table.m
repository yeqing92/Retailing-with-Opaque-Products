% Run this file to generate ER and ER^2 for 1000 different q values and 500 order-up-to levels
e=1000;
c_max=500;
q_ER=zeros(e,c_max);
q_ER2=zeros(e,c_max);
for i=1:e
    i=i
    parfor j=1:c_max        
        [ER, ER2]=asymmetricER_eff(j,j,(1-i/e)/2,(1-i/e)/2,i/e);
        q_ER(i,j)=ER;
        q_ER2(i,j)=ER2;
    end
end
save('q_ER.mat', 'q_ER')
save('q_ER2.mat', 'q_ER2')
