%-------------------------------------------------------------------%
%  Multi-Objective artificial hummingbird algorithm (MOAHA)         %
%  Source codes demo version 1.0                                    %
%-------------------------------------------------------------------%
% I acknowledge that this version of MOAHA has been written using
% a portion of the following code:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  MATLAB Code for                                                  %
%                                                                   %
%  Multi-Objective Particle Swarm Optimization (MOPSO)              %
%  Version 1.0 - Feb. 2011                                          %
%                                                                   %
%  According to:                                                    %
%  Carlos A. Coello Coello et al.,                                  %
%  "Handling Multiple Objectives with Particle Swarm Optimization," %
%  IEEE Transactions on Evolutionary Computation, Vol. 8, No. 3,    %
%  pp. 256-279, June 2004.                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pop=DetermineDomination(pop)

 nPop=numel(pop);

    for i=1:nPop
        pop(i).Dominated=false;
    end
    
    for i=1:nPop
        for j=i+1:nPop
            if Dominates(pop(i).Cost,pop(j).Cost)
              
                pop(j).Dominated=true;
                
            elseif Dominates(pop(j).Cost,pop(i).Cost)
                pop(i).Dominated=true;
                break;
            else
                if    all (pop(i).Cost==pop(j).Cost) %remove the same individual
                      pop(i).Dominated=true;
                end
                
            end
        end
    end

end