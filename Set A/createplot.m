k=0;
l=0;
for j=1:14
k=j;
sum1= PSO(1,j).progress;
sum2= GA(1,j).progress;
sum3= SGA(1,j).progress;
sum4= PGPHEA(1,j).progress;
sum5= HPSOM(1,j).progress;
for i=2:params.exenum
sum1 = sum1+ PSO(i,j).progress;
sum2 = sum2+ GA(i,j).progress;
sum3 = sum3+ SGA(i,j).progress;
sum4 = sum4+ PGPHEA(i,j).progress;
sum5 = sum5+ HPSOM(i,j).progress;
end
sum1=sum1/params.exenum;
sum2=sum2/params.exenum;
sum3=sum3/params.exenum;
sum4=sum4/params.exenum;
sum5=sum5/params.exenum;
figure(j)
hold on
if j~=7&&j~=8
h1=plot((sum1(2:2000,1)),1./(abs(sum1(2:2000,2)-Minimum(j))+0.01),'r-','LineWidth',1.5);
h2=plot((sum2(2:2000,1)),1./(abs(sum2(2:2000,2)-Minimum(j))+0.01),'b-','LineWidth',1.5);
h3=plot((sum3(2:2000,1)),1./(abs(sum3(2:2000,2)-Minimum(j))+0.01),'c-.','LineWidth',1.5);
h4=plot((sum4(2:2000,1)),1./(abs(sum4(2:2000,2)-Minimum(j))+0.01),'g:','LineWidth',1.5);
h5=plot((sum5(2:2000,1)),1./(abs(sum5(2:2000,2)-Minimum(j))+0.01),'k--','LineWidth',1.5);
end
if j==7||j==8
h1=plot((sum1(2:2000,1)),sum1(2:2000,2),'r-','LineWidth',1.5);
h2=plot((sum2(2:2000,1)),sum2(2:2000,2),'b-','LineWidth',1.5);
h3=plot((sum3(2:2000,1)),sum3(2:2000,2),'c-.','LineWidth',1.5);
h4=plot((sum4(2:2000,1)),sum4(2:2000,2),'g:','LineWidth',1.5);
h5=plot((sum5(2:2000,1)),sum5(2:2000,2),'k--','LineWidth',1.5);
end
Alphabet = 'abcdefghijklmnopqrstuvwxyz';
title( [num2str(Alphabet(k)) ') ' 'Function ' num2str(k)])
xlabel('CPU time (sec)','FontSize',14)
ylabel('Fitness','FontSize',14)
legend([h1,h2,h3,h4,h5],'PSO','GA','SGA','PGPHEA','HPSOM')
set(gca, ...
'Box'         , 'off'     , ...
'TickDir'     , 'out'     , ...
'TickLength'  , [.02 .02] , ...
'XMinorTick'  , 'on'      , ...
'YMinorTick'  , 'on'      , ...
'YGrid'       , 'on'      , ...
'XColor'      , [.3 .3 .3], ...
'YColor'      , [.3 .3 .3], ...
'LineWidth'   , 1         );
set(gcf, 'PaperPositionMode', 'auto');
ylim=get(gca,'ylim');
xlim=get(gca,'xlim');
% print(([ 'Pop1 ' num2str(params.PopSize) ' FinPlot ' num2str(k)]),'-djpeg','-painters')
end