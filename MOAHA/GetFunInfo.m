function MultiObj = GetFunInfo(TestProblem) %46����Ŀ����Ժ���
switch TestProblem
    case 1
        global P_load; %�縺��
        global WT;%���
        global PV;%���
        global buy_price;%�����
        global sell_price;%�۵���
        %��ȡ����
        data=xlsread('data.xlsx');
        P_load=data(:,1);
        PV=data(:,2);
        WT=data(:,3);
        buy_price=data(:,4);
        sell_price=data(:,5);
        %�������ŵ繦�ʣ�����ʾΪ�縺�ɹ��磬���ŵ磩
        BESSMax_dischar=30;
        %��������繦��
        BESSMax_char=-30;
        %���ͻ���󷢵繦��
        DEMax=30;
        %���ͻ���С���繦��
        DEMin=6;
        %ȼ���ֻ���󷢵繦��
        MTMax=30;
        %ȼ���ֻ���С���繦��
        MTMin=3;
        %�������������(����ʾΪ�縺�ɹ���)
        GridMax=30;
        %����������С����
        GridMin=-30;
        %���豸����Լ��
        for n=1:144 %���ӳ���Ϊ144���������磬���ܣ�����,ȼ���ֻ���������6*24��Сʱ������
            if n<25
                lower_bound(n)=0;
                upper_bound(n) =PV(n);
            end
            if n>24&&n<49
                lower_bound(n)=0;
                upper_bound(n) =WT(n-24);
            end
            if n>48&&n<73
                lower_bound(n)=BESSMax_char;
                upper_bound(n) =BESSMax_dischar;
            end
            if n>72&&n<97
                lower_bound(n)=DEMin;
                upper_bound(n) =DEMax;
            end
            if n>96&&n<121
                lower_bound(n)=MTMin;
                upper_bound(n) =MTMax;
            end
            if n>120
                lower_bound(n)=GridMin;
                upper_bound(n) =GridMax;
            end
        end
        CostFunction = @Fun;
        nVar = 144;
        VarMin = lower_bound;
        VarMax = upper_bound;
        name='΢�����Ż�';
        numOfObj = 2;
end
MultiObj.nVar=nVar;
MultiObj.var_min = VarMin;
MultiObj.var_max =VarMax;
MultiObj.fun=CostFunction;
MultiObj.numOfObj=numOfObj;
MultiObj.name=name;
end
function o=Fun(x)
o=prob(x) ;
end