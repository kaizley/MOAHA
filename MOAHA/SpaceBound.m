
function  X=SpaceBound(X,Up,Low)
Dim=length(X);

if rand>0.5
    
    S=(X>Up)+(X<Low);
    X=(rand(1,Dim).*(Up-Low)+Low).*S+X.*(~S);
    
else
    
    X= min(max(X,Low),Up);
    
end



        
            
        
   
