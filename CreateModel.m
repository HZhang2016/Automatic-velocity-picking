% Task: Create Model
% Written by zhanghao
% Date: August 15th, 2017

function model= CreateModel( N )
%     if N<=1
%        error(message('N must be greater than 1'));
%     end
    model = zeros(3,N);
   
    for i = 1:N
        if i ==1
            model(1,i) = 1500; %速度
            model(3,i) = 150;  %间隔
            % model(2,i) = 1.025;          
        elseif i==2
            model(1,i) = 2500 + 10*randi([0,10],1,1); 
            model(3,i) = 50 * randi([7,9],1,1);  
        else
            model(1,i) = model(1,i-1) + 100*randi([4,8],1,1);
           % model(2,i) = 1.741* (model(1,i)/1000)^0.25;
           model(3,i) = 50 * randi([7,9],1,1);   
        end
        model(2,i) = 1.741* (model(1,i)/1000)^0.25;%密度
            
    end 
end

