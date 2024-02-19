function MultiObj = GetFunInfo(TestProblem) %46个多目标测试函数
switch TestProblem
    case 1
        global P_load; %电负荷
        global WT;%风电
        global PV;%光伏
        global buy_price;%买电电价
        global sell_price;%售电电价
        %获取数据
        data=xlsread('data.xlsx');
        P_load=data(:,1);
        PV=data(:,2);
        WT=data(:,3);
        buy_price=data(:,4);
        sell_price=data(:,5);
        %蓄电池最大放电功率（正表示为电负荷供电，即放电）
        BESSMax_dischar=30;
        %蓄电池最大充电功率
        BESSMax_char=-30;
        %柴油机最大发电功率
        DEMax=30;
        %柴油机最小发电功率
        DEMin=6;
        %燃气轮机最大发电功率
        MTMax=30;
        %燃气轮机最小发电功率
        MTMin=3;
        %主网交互最大功率(正表示为电负荷供电)
        GridMax=30;
        %主网交互最小功率
        GridMin=-30;
        %各设备出力约束
        for n=1:144 %粒子长度为144（光伏，风电，储能，柴油,燃气轮机，主网的6*24个小时出力）
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
        name='微电网优化';
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