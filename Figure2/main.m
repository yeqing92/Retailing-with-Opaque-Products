% Matlab code to generate Figure 2(a) and 2(b)

load q0_ER;
load q0_ER2;
load q_ER;
load q_ER2;


global ERq0;
global ER2q0;
ERq0=q0_ER; 
ER2q0=q0_ER2;

global ERq;
global ER2q;
ERq=q_ER;
ER2q=q_ER2;

qs=[0, 0.1, 0.2, 0.5, 1];
HCost=zeros(500,length(qs));
KCost=zeros(500,length(qs));
Klb=zeros(500,length(qs));
Kub=zeros(500,length(qs));
Hlb=zeros(500,length(qs));
Hub=zeros(500,length(qs));

h=1;
K=1;
lambda=1;
for c=1:500
    for i=1:length(qs)
        HCost(c,i)=computecost(qs(i),c,h,0,lambda);
        KCost(c,i)=computecost(qs(i),c,0,K,lambda);
        Hlb(c,i)=max([0, 1/sqrt(pi*c)-1/(4*qs(i)*c)-7/(8*c)]);
        Hub(c,i)=1/sqrt(pi*c);
        Klb(c,i)=max([0, 1/sqrt(pi*c)-1/(4*qs(i)*c)-1/(2*c)]);
        Kub(c,i)=1/sqrt(pi*c);
    end
end

fig = figure;

for i=2:length(qs)
    col=[ 1 0 0; 0 1 0 ; 0 0 1; 0 0 0];

plot(2:2:1000, 100*(HCost(:,1)-HCost(:,i))./HCost(:,1),'color',col(i-1,:),'LineWidth', 1.5);
hold on
end

for i=2:length(qs)
    col=[ 1 0 0; 0 1 0 ; 0 0 1; 0 0 0];
    plot(2:2:1000, 100*Hlb(:,i),'color',col(i-1,:), 'LineStyle' , '-.','LineWidth', 1.5);
    hold on 
end

xlabel('S', 'FontSize',20)
xticks([0 200 400 600 800 1000])
ylabel('Cost Savings %','FontSize', 20)
legend({'q_o=0.1', 'q_o=0.2', 'q_o=0.5', 'q_o=1.0'},'FontSize',14)
set(gca,'FontSize',20)

set(fig,'Units','centimeters');
set(gcf,'position',[10,10,20,20])

set(fig,'PaperSize',[8 8]); %set the paper size to what you want
print(fig,'HoldingCostSavings','-dpdf','-r0')


% uncomment the following block to generate Figure 2(a)
% 
% for i=2:length(qs)
%     col=[ 1 0 0; 0 1 0 ; 0 0 1; 0 0 0];
% 
% plot(1:500, 100*(KCost(:,1)-KCost(:,i))./KCost(:,1),'color',col(i-1,:),'LineWidth', 1.5);
% hold on
% end
% 
% 
% for i=2:length(qs)
%     col=[ 1 0 0; 0 1 0 ; 0 0 1; 0 0 0];
%     plot(1:500, 100*Klb(:,i),'color',col(i-1,:), 'LineStyle' , '--','LineWidth', 1.5);
%     hold on 
% end
% xlabel('S', 'FontSize',20)
% ylabel('Cost Savings %','FontSize', 20)
% legend({'q=0.1', 'q=0.2', 'q=0.5', 'q=1.0'},'FontSize',14)
% set(gca,'FontSize',20)
% set(fig,'Units','centimeters');
% set(gcf,'position',[10,10,20,20])
% set(fig,'PaperSize',[8 8]); %set the paper size to what you want
% print(fig,'OrderingCost','-dpdf','-r0')

