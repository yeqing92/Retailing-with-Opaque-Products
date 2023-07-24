% This function generates the E[R] and E[R^@] for given q values and order-up-to levels

function [Jstar1, Jstar2] = asymmetricER_eff(c1,c2,q1,q2,qo)

J1=zeros(c1+1,c2+1);

J2=zeros(c1+1,c2+1);

for i=1:c1+c2
    for i1=max([0,i-c2]):min([i,c1])
        i2=i-i1;
        if i1>=1 && i2>=1 
            J1(i1+1,i2+1)=1+q1*J1(i1,i2+1)+q2*J1(i1+1,i2)+qo*max([J1(i1,i2+1),J1(i1+1,i2)]);
            
            [a, b]=max([J1(i1,i2+1),J1(i1+1,i2)]);
            if b==1
                J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1,i2+1);
            else
                J2(i1+1,i2+1)=q1*J2(i1,i2+1)+q2*J2(i1+1,i2)+qo*J2(i1+1,i2);
            end
        else 
            J2(i1+1,i2+1)=(c1+c2-i)^2;
        end
    end
end
Jstar1=J1(c1+1,c2+1);
Jstar2=J2(c1+1,c2+1);
