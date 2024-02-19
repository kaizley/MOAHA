close all;
clear ; 
clc;
global P_load; %�縺��
global WT;%���
global PV;%���
%%
TestProblem=1;
MultiObj = GetFunInfo(TestProblem);
MultiObjFnc=MultiObj.name;%������
% Parameters
params.Np =100;        %  ��Ⱥ��С(�����޸�)
params.Nr =200 ; % ���ⲿ�浵�Ĵ�С��
params.maxgen =200;    % ����������(�����޸�)
[Xbest,Fbest] = MOAHA(params,MultiObj);
% Xbest��MOAHA����õ���POX
% Fbest��MOAHA����õ���POF

%% �����ͼ
figure(1)
plot(Fbest(:,1),Fbest(:,2),'ro');
legend('MOAHA');
xlabel('���гɱ�')
ylabel('���������ɱ�')

%% �Ƚϲ�ͬĿ�꺯��Ѱ�ŶԵ��Ƚ����Ӱ��
%% ��1��.������Ŀ�꺯��ֵ��һ����ӣ�ȡ��Ӻ���С��Ŀ��ֵ�����ӣ���Ѱ�����ԽⲢ��ͼ
object=sum(Fbest./max(Fbest),2);
[~,idx]=min(object);
pg=Xbest(idx,:);
Title = sprintf('���Խ������');

%% ��2��Ѱ���ܳɱ����ʱ�ĽⲢ��ͼ
% [~,idx]=min(sum(Fbest,2));
% pg=Xbest(idx,:);
% Title = sprintf('�ܳɱ���������');

%% ��3��Ѱ�����гɱ����ʱ�ĽⲢ��ͼ
% [~,idx]=min(Fbest(:,1));
% pg=Xbest(idx,:);
% Title = sprintf('���гɱ���������');

%% ��4��Ѱ�һ��������ɱ����ʱ�ĽⲢ��ͼ
% [~,idx]=min(Fbest(:,2));
% pg=Xbest(idx,:);
% Title = sprintf('���������ɱ���������');

%% ��ͬ����µĽ⸳ֵ
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
%% ��ͼ

figure
subplot(3,1,1)
plot(pg_PV,'--ko')
hold on;
plot(PV,'-g*')
xlim([1 24])
legend('ʵ�ʹ������','Ԥ��������');
xlabel('ʱ��/h')
ylabel('����/kw')
title('��������PV')


subplot(3,1,2)
plot(pg_WT,'--ko')
hold on;
plot(WT,'-g*')
xlim([1 24])
legend('ʵ�ʷ�繦��','Ԥ���繦��');
xlabel('ʱ��/h')
ylabel('����/kw')
title('���������WT')

subplot(3,1,3)
bar(P_load,'facecolor','c')
hold on
plot(P_load,'m-*','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('ʱ��/h')
ylabel('����/kw')
title('΢��������Pload')

figure
subplot(2,2,1)
bar(pg_DE,'facecolor','g')
hold on
plot(pg_DE,'r-p','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('ʱ��/h')
ylabel('����/kw')
title('���ͷ����DE')

subplot(2,2,2)
bar(pg_BESS)
hold on
plot(pg_BESS,'r-*','linewidth',1.5)
xlim([1 24])
xlabel('ʱ��/h')
ylabel('����/kw')
title('����BESS')




subplot(2,2,3)
bar(pg_MT,'facecolor','m')
hold on
plot(pg_MT,'k-o','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('ʱ��/h')
ylabel('����/kw')
title('΢��ȼ���ֻ�MT')

subplot(2,2,4)
bar(pg_grid,'facecolor','b')
hold on
plot(pg_grid,'r-*','linewidth',1.5)
hold on;
xlim([1 24])
xlabel('ʱ��/h')
ylabel('����/kw')
title('��������Grid')

figure
plot(pg_grid,'-k<')
hold on
plot( pg_DE,'-ro')
hold on
plot(pg_BESS,'-mp');
hold on
plot(pg_MT,'-c>')
legend('Grid','DE','BESS','MT');
xlabel('ʱ��/h')
ylabel('����/kw')
title(Title)

figure
plot(pg_PV,'-rd')
hold on
plot(pg_WT,'-g*');
hold on
plot(P_load,'-bo');
legend('PV','WT','Pload');
xlabel('ʱ��/h')
ylabel('����/kw')
title(Title)



