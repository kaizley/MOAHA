function Archive=DECD(Archive,Ex)
%-------------------------------------------------------------------%
%  Multi-Objective artificial hummingbird algorithm (MOAHA)         %
%  Source codes demo version 1.0                                    %
%-------------------------------------------------------------------%
    %Dynamic elimination-based crowding distance (DECD)
    
    Costs=[Archive.Cost];
    Costs=Costs';
    [nPop,nObj]=size(Costs);
    [SortedC, SortedI]=sort(Costs);
    [~,RSortedI] = sort(SortedI);
    d=zeros(nPop,nObj);

    for j=1:nObj
        for i=2:nPop-1
            d(SortedI(i,j),j)=abs(SortedC(i+1,j)-SortedC(i-1,j))/abs(SortedC(1,j)-SortedC(end,j));
        end
        d(SortedI(1,j),j)=inf;
        d(SortedI(end,j),j)=inf;
    end

    for i=1:nPop
        D(i)=sum(d(i,:));
    end

    for i=1:Ex  % Ex:The number of the removed solutions

        [~,DelId]=min(D);

        for j=1:nObj
            DelIdx(j)=RSortedI(DelId,j);
        end

        Costs(DelId,:)=[];
        Archive(DelId)=[];
        d(DelId,:)=[];
        D(DelId)=[];
        [SortedC, SortedI]=sort(Costs);
        [~,RSortedI] = sort(SortedI);

        for j=1:nObj

            if 2<DelIdx(j)
                d(SortedI(DelIdx(j)-1,j),j)=abs(SortedC(DelIdx(j),j)......
                -SortedC(DelIdx(j)-2,j))/abs(SortedC(1,j)-SortedC(end,j));
            else
                d(SortedI(DelIdx(j)-1,j),j)=inf;
            end

            if DelIdx(j)<numel(SortedC(:,j))
                d(SortedI(DelIdx(j),j),j)=abs(SortedC(DelIdx(j)+1,j)......
                -SortedC(DelIdx(j)-1,j))/abs(SortedC(1,j)-SortedC(end,j));
            else
                d(SortedI(DelIdx(j),j),j)=inf;
            end
        end

        D(SortedI(DelIdx(1),1))=sum(d(SortedI(DelIdx(1),1),:));
        D(SortedI(DelIdx(1)-1,1))=sum(d(SortedI(DelIdx(1)-1,1),:));

    end


