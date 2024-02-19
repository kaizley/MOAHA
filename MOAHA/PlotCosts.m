function PlotCosts(PopFit,Fbest,Title)
figure(1)
plot(PopFit(:,1),PopFit(:,2),'ro')
hold on
plot(Fbest(:,1),Fbest(:,2),'b*')
xlabel('目标函数1：运行成本')
ylabel('目标函数2：环境保护成本')
grid on
hold off
title(Title)
legend('NSDBO的可行解' ,'存档库内非占优解')%,'location','best')


figure(10)
plot(Fbest(:,1),Fbest(:,2),'m*');
legend('NSDBO');
xlabel('运行成本')
ylabel('环境保护成本')
title('pareto前沿解集')
end