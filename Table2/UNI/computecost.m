function [cost]= computecost(q,c,h,K,lambda)
    global ERq0;
    global ER2q0;
    global ERq;
    global ER2q;
    index=round(q*1000);
if index>0
    ER=ERq(index,c);
    ER2=ER2q(index,c);
else

    ER=ERq0(c);
    ER2=ER2q0(c);
end
    HC=((4*c+1)*ER-ER2)*h/(2*ER);
    KC=lambda*K/ER;
    cost=HC+KC;
end