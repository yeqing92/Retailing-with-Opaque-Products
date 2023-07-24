% Run this file to generate ER and ER^2 in the no-opaque setting for 500 different order-up-to levels

e=1;
c_max=500;
q0_ER=zeros(c_max,1);
q0_ER2=zeros(c_max,1);
for i=1:e
    i=i
    for j=1:c_max
        [ER, ER2]=asymmetricER_eff(j,j,1/2,1/2,0);
        q0_ER(j,1)=ER;
        q0_ER2(j,1)=ER2;
    end
end

save('q0_ER.mat', 'q0_ER')
save('q0_ER2.mat', 'q0_ER2')
