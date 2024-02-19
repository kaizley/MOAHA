function [ArchivePosition, ArchiveCost] = MOAHA(params,MultiObj)
 warning off
% Parameters
nPop     = params.Np;
ArchiveBestSize= params.Nr;
MaxIt  = params.maxgen;
BenFunctions = MultiObj.fun;
Dim    = MultiObj.nVar;
Low = MultiObj.var_min(:)';%下限
Up = MultiObj.var_max(:)';%上限
name=MultiObj.name;%问题名
obj_no=MultiObj.numOfObj;



Individual.Position=[];
Individual.Cost=[];
Individual.Dominated=false;
Individual.CrowdingDistance=0;
Individual.Rank=[];
Individual.DominationSet=[];
Individual.DominatedCount=[];


for i=1:nPop
    Pop(i)=Individual;
    Pop(i).Position=rand(1,Dim).*(Up-Low)+Low;
    Pop(i).Cost=BenFunctions(Pop(i).Position);
end
Pop=DetermineDomination(Pop);
ArchiveBestPop=GetNonDominatedIndividuals(Pop);
VisitTable=zeros(nPop) ;
VisitTable(logical(eye(nPop)))=NaN;
newPop=Individual;
for It=1:MaxIt
    tPop=[];
    [Pop, F]=NonDominatedSorting(Pop);
    DirectVector=zeros(nPop,Dim);% Direction vector/matrix
    for i=1:nPop
        r=rand;
        if r<1/3     % Diagonal flight
            RandDim=randperm(Dim);
            if Dim>=3
                RandNum=ceil(rand*(Dim-2)+1);
            else
                RandNum=ceil(rand*(Dim-1)+1);
            end
            DirectVector(i,RandDim(1:RandNum))=1;
        else
            if r>2/3  % Omnidirectional flight
                DirectVector(i,:)=1;
            else  % Axial flight
                RandNum=ceil(rand*Dim);
                DirectVector(i,RandNum)=1;
            end
        end
        if rand<0.5   % Guided foraging
            NonDominatedMUT=[];
            [MaxUnvisitedTime,TargetFoodIndex]=max(VisitTable(i,:));
            MUT_Index=find(VisitTable(i,:)==MaxUnvisitedTime);
            if length(MUT_Index)>1
                Pop(MUT_Index)=DetermineDomination(Pop(MUT_Index));
                for k=1:length(MUT_Index)
                    NonDominatedMUT(k)= Pop(MUT_Index(k)).Dominated;
                end
                IndexNonDominatedMUT=find(NonDominatedMUT==false);
                SelectedNonDominatedMUT=randi([1 length(IndexNonDominatedMUT)]);
                TargetFoodIndex=(MUT_Index(IndexNonDominatedMUT(SelectedNonDominatedMUT)));
            end
            newPop.Position=Pop(TargetFoodIndex).Position+randn*DirectVector(i,:).*(Pop(TargetFoodIndex).Position-Pop(i).Position);
            newPop.Position=SpaceBound(newPop.Position,Up,Low);
            newPop.Cost=BenFunctions(newPop.Position);
            for k=1:numel(F)
                if ismember(i,F{k})
                    iF=k;
                    break;
                end
            end
            DominatedFlag=0;
            for k=1:numel(F{iF})
                if Dominates (newPop.Cost,Pop(F{iF}(k)).Cost)
                    DominatedFlag=1;
                    break;
                elseif Dominates (Pop(F{iF}(k)).Cost,newPop.Cost)
                    DominatedFlag=-1;
                    break;
                end
            end
            if (DominatedFlag==1)  || ( rand>0.5 && (DominatedFlag==0))
                tPop=[tPop Pop(i)];
                Pop(i)=newPop;
                VisitTable(i,:)=VisitTable(i,:)+1;
                VisitTable(i,TargetFoodIndex)=0;
                VisitTable(:,i)=max(VisitTable,[],2)+1;
                VisitTable(i,i)=NaN;
            else
                VisitTable(i,:)=VisitTable(i,:)+1;
                VisitTable(i,TargetFoodIndex)=0;
                tPop=[tPop newPop];
            end
        else    % Territorial foraging
            if rand>0.5
                newPop.Position= Pop(i).Position+randn*DirectVector(i,:).*Pop(i).Position;
            else
                newPop.Position= Pop(i).Position+randn*DirectVector(i,:).*ArchiveBestPop(randi([1 numel(ArchiveBestPop)])).Position;
            end
            newPop.Position=SpaceBound(newPop.Position,Up,Low);
            newPop.Cost=BenFunctions(newPop.Position);
            for k=1:numel(F)
                if ismember(i,F{k})
                    iF=k;
                    break;
                end
            end
            DominatedFlag=0;
            for k=1:numel(F{iF})
                if Dominates (newPop.Cost,Pop(F{iF}(k)).Cost)
                    DominatedFlag=1;
                    break;
                elseif Dominates (Pop(F{iF}(k)).Cost,newPop.Cost)
                    DominatedFlag=-1;
                    break;
                end
            end
            if (DominatedFlag==1)  || ( rand>0.5 && (DominatedFlag==0))
                tPop=[tPop Pop(i)];
                Pop(i)=newPop;
                VisitTable(i,:)=VisitTable(i,:)+1;
                VisitTable(:,i)=max(VisitTable,[],2)+1;
                VisitTable(i,i)=NaN;
            else
                VisitTable(i,:)=VisitTable(i,:)+1;
                tPop=[tPop newPop];
            end
        end
    end
    if mod(It,2*nPop)==0 % Migration foraging
        [Pop, F]=NonDominatedSorting(Pop);
        for i=1:length(F{end})
            RandMaxDominatedIndex=F{end}(i);
            Pop(RandMaxDominatedIndex).Position =rand(1,Dim).*(Up-Low)+Low;
            VisitTable(RandMaxDominatedIndex,:)=VisitTable(RandMaxDominatedIndex,:)+1;
            VisitTable(:,RandMaxDominatedIndex)=max(VisitTable,[],2)+1;
            VisitTable(RandMaxDominatedIndex,RandMaxDominatedIndex)=NaN;
            Pop(RandMaxDominatedIndex).Cost=BenFunctions(Pop(RandMaxDominatedIndex).Position);
        end
    end
    tPop=DetermineDomination([tPop Pop]);
    NonDominatedPop=GetNonDominatedIndividuals(tPop);
    ArchiveBestPop=[ArchiveBestPop  NonDominatedPop];
    ArchiveBestPop=DetermineDomination(ArchiveBestPop);
    ArchiveBestPop=GetNonDominatedIndividuals(ArchiveBestPop);
    if numel(ArchiveBestPop)>ArchiveBestSize
        ArchiveBestPop=DECD(ArchiveBestPop,numel(ArchiveBestPop)-ArchiveBestSize);%Dynamic elimination-based crowding distance
    end
    display(['MOAHA At the iteration ', num2str(It), ' there are ', num2str(size(ArchiveBestPop,2)), ' non-dominated solutions in the archive']);
end
ArchiveCost=[];
ArchivePosition=[];
for i=1:size(ArchiveBestPop,2)
    ArchiveCost=[ArchiveCost;ArchiveBestPop(i).Cost];
ArchivePosition=[ArchivePosition;ArchiveBestPop(i).Position];
end
end