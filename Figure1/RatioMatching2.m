function [OptimalCost,Policy]= RatioMatching2(c1,c2,lambda,q1,q2,qo,K,h)

J1=zeros(c1+1,c2+1);
J2=zeros(c1+1,c2+1);
Policy=zeros(c1,c2);
for i=1:c1+c2
    for i1=max([0,i-c2]):min([i,c1])
        i2=i-i1;
        if i1==1 && i2>=1
            J1(i1+1,i2+1)=1+q1*J1(i1,i2+1)+q2*J1(i1+1,i2)+qo*J1(i1+1,i2);
            J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1+1,i2);
            Policy(i1,i2)=2;
        elseif i2==1 && i1>=1
            J1(i1+1,i2+1)=1+q1*J1(i1,i2+1)+q2*J1(i1+1,i2)+qo*J1(i1,i2+1);
            J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1,i2+1);
            Policy(i1,i2)=1;
        elseif i1>1.5 && i2> 1.5 && abs(i2/(i1-1)-q2/q1) < abs((i2-1)/i1- q2/q1)            
            J1(i1+1,i2+1)=1+q1*J1(i1,i2+1)+q2*J1(i1+1,i2)+qo*J1(i1,i2+1);
            J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1,i2+1);
            Policy(i1,i2)=1;
       elseif i1>1.5 && i2> 1.5 && abs(i2/(i1-1)-q2/q1) >= abs((i2-1)/i1- q2/q1)
            J1(i1+1,i2+1)=1+q1*J1(i1,i2+1)+q2*J1(i1+1,i2)+qo*J1(i1+1,i2);
            J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1+1,i2);
            Policy(i1,i2)=2;
        else 
            J2(i1+1,i2+1)=(c1+c2-i)^2;
        end
    end
end
ER=J1(c1+1,c2+1)
ER2=J2(c1+1,c2+1)
c=(c1+c2)/2;
HC=((4*c+1)*ER-ER2)*h/(2*ER);
KC=lambda*K/ER;
OptimalCost=HC+KC;
