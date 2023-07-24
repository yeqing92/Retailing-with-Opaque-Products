qs=[0, 0.1, 0.2, .5, .999999];
ratios=[1.5, 2];

Cs=15:15:450;
HCost=zeros(length(Cs),length(qs),length(ratios));
KCost=zeros(length(Cs),length(qs),length(ratios));
h=1;
K=1;
lambda=1;
for c=1:length(Cs)
    for i=1:length(qs)
        for j=1:length(ratios)
        qo=qs(i);
        q1=(1-qo)/(1+ratios(j));
        q2=1-qo-q1;
        c1=round(Cs(c)/(1+ratios(j)))
        c2=(Cs(c)-c1)
        [HCost(c,i,j),Policy]= RatioMatching2(c1,c2,lambda,q1,q2,qo,0,h);
        [KCost(c,i,j),Policy]= RatioMatching2(c1,c2,lambda,q1,q2,qo,K,0);
        end
    end
end


Cs2=16:8:456;
HCost0=zeros(length(Cs),length(qs));
KCost0=zeros(length(Cs),length(qs));
h=1;
K=1;
lambda=1;
for c=1:length(Cs2)
    for i=1:length(qs)
        ratio = 1
        qo=qs(i);
        q1=(1-qo)/(1+ratio);
        q2=1-qo-q1;
        c1=round(Cs2(c)/(1+ratio))
        c2=(Cs2(c)-c1)
        [HCost0(c,i),Policy]= RatioMatching2(c1,c2,lambda,q1,q2,qo,0,h);
        [KCost0(c,i),Policy]= RatioMatching2(c1,c2,lambda,q1,q2,qo,K,0);
    end
end




fig = figure;

for i=2:length(qs)
    plot(Cs2, 100*(HCost0(:,1)-HCost0(:,i))./HCost0(:,1),'color',col(i-1,:),'LineWidth', 1.5);
    hold on
    j=1;
    col=[ 1 0 0; 0 1 0 ; 0 0 1; 0 0 0];
    plot(Cs, 100*(HCost(:,1,j)-HCost(:,i,j))./HCost(:,1,j),'color',col(i-1,:),'LineWidth', 1.5,'LineStyle','--');
    hold on
    j=2;
    plot(Cs, 100*(HCost(:,1,j)-HCost(:,i,j))./HCost(:,1,j),'color',col(i-1,:),'LineWidth', 1.5,'LineStyle',':');
    hold on   
end

axis([9   Cs(length(Cs)) 0 10.5])
xlabel('S', 'FontSize',20)
ylabel('Cost Savings %','FontSize', 20)
legend({'q_o=0.1, \rho=1', 'q_o=0.1, \rho=1.5', 'q_o=0.1, \rho=2.0','q_o=0.2, \rho=1',  'q_o=0.2, \rho=1.5', 'q_o=0.2, \rho=2.0', 'q_o=0.5, \rho=1', 'q_o=0.5, \rho=1.5', 'q_o=0.5, \rho=2.0', 'q_o=1.0, \rho=1', 'q_o=1.0, \rho=1.5', 'q_o=1.0, \rho=2.0'},'FontSize',12)
set(gca,'FontSize',20)

set(fig,'Units','centimeters');
set(gcf,'position',[10,10,20,20])
set(fig,'PaperSize',[8 8]); %set the paper size to what you want
print(fig,'filename','-dpdf','-r0')


