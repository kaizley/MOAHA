close all;
clear ; 
clc;
global P_load; %电负荷
global WT;%风电
global PV;%光伏
%%
TestProblem=1;
MultiObj = GetFunInfo(TestProblem);
MultiObjFnc=MultiObj.name;%问题名
% Parameters
params.Np =100;        %  种群大小(可以修改)
params.Nr =200 ; % （外部存档的大小）
params.maxgen =200;    % 最大迭代次数(可以修改)
[Xbest,Fbest] = MOAHA(params,MultiObj);
% Xbest是MOAHA所求得到的POX
% Fbest是MOAHA所求得到的POF

%% 画结果图
figure(1)
plot(Fbest(:,1),Fbest(:,2),'ro');
legend('MOAHA');
xlabel('运行成本')
ylabel('环境保护成本')

%% 比较不同目标函数寻优对调度结果的影响
%% 第1种.将两个目标函数值归一化相加，取相加后最小的目标值的粒子，即寻找折衷解并画图
object=sum(Fbest./max(Fbest),2);
[~,idx]=min(object);
pg=Xbest(idx,:);
Title = sprintf('折衷解情况下');

%% 第2种寻找总成本最低时的解并画图
% [~,idx]=min(sum(Fbest,2));
% pg=Xbest(idx,:);
% Title = sprintf('总成本最低情况下');

%% 第3种寻找运行成本最低时的解并画图
% [~,idx]=min(Fbest(:,1));
% pg=Xbest(idx,:);
% Title = sprintf('运行成本最低情况下');

%% 第4种寻找环境保护成本最低时的解并画图
% [~,idx]=min(Fbest(:,2));
% pg=Xbest(idx,:);
% Title = sprintf('环境保护成本最低情况下');

%% 不同情况下的解赋值
 for i=1:24
   pg_PV(i)=pg(i);
 end  

 for m=25:48
    pg_WT(m-24)=pg(m);
end
for m=49:72
    pg_BESS(m-48)=pg(m);
end
for m=73:96
    pg_DE(m-72)=pg(m);
end
for m=97:120
    pg_MT(m-96)=pg(m);
end
for m=121:144
    pg_grid(m-120)=pg(m);
end
%% 画图

figure
subplot(3,1,1)
plot(pg_PV,'--ko')
hold on;
plot(PV,'-g*')
xlim([1 24])
legend('实际光伏功率','预测光伏功率');
xlabel('时间/h')
ylabel('功率/kw')
title('光伏发电机PV')


subplot(3,1,2)
plot(pg_WT,'--ko')
hold on;
plot(WT,'-g*')
xlim([1 24])
legend('实际风电功率','预测风电功率');
xlabel('时间/h')
ylabel('功率/kw')
title('风力发电机WT')

subplot(3,1,3)
bar(P_load,'facecolor','c')
hold on
plot(P_load,'m-*','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('时间/h')
ylabel('功率/kw')
title('微电网负荷Pload')

figure
subplot(2,2,1)
bar(pg_DE,'facecolor','g')
hold on
plot(pg_DE,'r-p','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('时间/h')
ylabel('功率/kw')
title('柴油发电机DE')

subplot(2,2,2)
bar(pg_BESS)
hold on
plot(pg_BESS,'r-*','linewidth',1.5)
xlim([1 24])
xlabel('时间/h')
ylabel('功率/kw')
title('蓄电池BESS')




subplot(2,2,3)
bar(pg_MT,'facecolor','m')
hold on
plot(pg_MT,'k-o','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('时间/h')
ylabel('功率/kw')
title('微型燃气轮机MT')

subplot(2,2,4)
bar(pg_grid,'facecolor','b')
hold on
plot(pg_grid,'r-*','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('时间/h')
ylabel('功率/kw')
title('主网交互Grid')

figure
plot(pg_grid,'-k<')
hold on
plot( pg_DE,'-ro')
hold on
plot(pg_BESS,'-mp');
hold on
plot(pg_MT,'-c>')
legend('Grid','DE','BESS','MT');
xlabel('时间/h')
ylabel('功率/kw')
title(Title)

figure
plot(pg_PV,'-rd')
hold on
plot(pg_WT,'-g*');
hold on
plot(P_load,'-bo');
legend('PV','WT','Pload');
xlabel('时间/h')
ylabel('功率/kw')
title(Title)



