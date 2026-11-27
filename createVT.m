% Task: create VT
% Written by zhanghao
% Date: August 15th, 2017

function VT = createVT( T0Vav,T,sample_num, interval,n)
    VT = zeros(2,n);
    VT(1,1) = T0Vav(1,1);
    [num, layer_num] = size(T0Vav);
    j=1;
    pre_num = 0;
    
    for i = 2:n
        VT(2,i) = VT(2,i-1) + sample_num*interval/n; 
        if j==1
            if VT(2,i)<T(1,j)
                VT(1,i) = T0Vav(1,j);
                pre_num = i;
            else
                j = j+1;
                if layer_num>1
                    deltaT = T0Vav(2,j)-T0Vav(2,j-1);
                    deltaN = deltaT/(sample_num*interval/n); 
                    deltaV = (T0Vav(1,j)-T0Vav(1,j-1))/ deltaN ;
                    VT(1,i) = T0Vav(1,j-1) + (i-pre_num)*deltaV;
                else
                    VT(1,i) = T0Vav(1,layer_num);
                end
            end    
        elseif j>layer_num
            VT(1,i) = T0Vav(1,layer_num);
        else 
            if VT(2,i)<T(1,j)
                deltaT = T0Vav(2,j)-T0Vav(2,j-1);
                deltaN = deltaT/(sample_num*interval/n); 
                deltaV = (T0Vav(1,j)-T0Vav(1,j-1))/ deltaN ;
                VT(1,i) = T0Vav(1,j-1) + (i-pre_num)*deltaV;
            else
                j = j+1;
                pre_num = i;
                if  j > layer_num
                     VT(1,i) = T0Vav(1,layer_num);
                else
                	deltaT = T0Vav(2,j)-T0Vav(2,j-1);
                    deltaN = deltaT/(sample_num*interval/n); 
                    deltaV = (T0Vav(1,j)-T0Vav(1,j-1))/ deltaN ;
                    VT(1,i) = T0Vav(1,j-1) + (i-pre_num)*deltaV;
                end

            end
        end
        
%          if j > layer_num
%              VT(1,i) = T0Vav(1,layer_num);
%          else
%             if VT(2,i)<T(1,j)            
%                 VT(1,i) = T0Vav(1,j);  
%                 pre_num = i;
%             else
%                 VT(1,i) = T0Vav(1,j-1) + (i-pre_num)*(T0Vav(1,j) - T0Vav(1,j-1))/((T0Vav(2,j)-T0Vav(2,j-1))/(sample_num*interval));
%                 
%                 j=j+1;
%             end  
%         end
     
    end
%     VT(1,1) = model(1,1);
%     j=1;
%     for i = 2:n
%         VT(2,i) = VT(2,i-1) + sample_num*interval/n;
%         if VT(2,i)<T(1,j)
%             VT(1,i) = model(1,j);
%         else       
%             VT(1,i) = model(1,j);
%             j = j+1;
%         end      
%     end
end

