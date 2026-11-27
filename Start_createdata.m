%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task: create velocity spectrum 
%  Written by zhanghao
% Date: August 15th, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;

train_num = 1000;  %训练样本个数
%train_inputdata = zeros(3,2500,train_num);

%输入数据只有速度谱
%  train_inputdata_onlyspectrum  = zeros(train_num,40000);
%  train_outputdata_onlyspectrum = zeros(train_num,1);


%输入数据包含速度谱，时间，速度
%输出数据包括时间速度对
% train_inputdata  = zeros(3,40000,train_num);


tic
for i = 1:train_num
    train_inputdata  = zeros(1,50451);
    train_outputVT = zeros(1,20);
    
    %% ---------随机生成速度，密度，厚度-------------%%
    n = randi([6,10],1,1);
% 	 n = 7;
    model = CreateModel(n);
    % model(1,:); %各层速度                                                                                                                                                                                    
    % model(2,:); %各层密度
    % model(3,:); %各层厚度

    if n>1
        %% -----------自己的合成记录，只有反射波---------%%
        [synseis,T,T0Vav, Multi_Vav] = Syn_Seismogram (model);
        % synseis; %合成记录
        % T;  %地层变化的时间点

        %% -----------由速度谱获得的时间速度对---------%%
        sample_num = 2000;%采集数
        interval = 0.001;%采集时间间隔
        num = 201; %VT对个数
        VT = createVT( T0Vav,T,sample_num, interval,num);

        %% ------------速度分析-------------------%%
       
        [velspectrum,t,v] = Vel_Analysis (synseis);
        %velspectrum; 速度谱
%         figure();    
%         temp = velspectrum(1:151,51:201);
%         contourf(temp);
    else
        velspectrum=0.000*ones(100,100);
    end
    
    
    %%---------- 数据拷贝-----------------%%
%     [tT,tV] = size(velspectrum);
%     tempT = linspace(0,0.6,tV);
%     for j = 1:tT   
%         train_inputdata(1,(j-1)*tT+1:j*tT,i) = j*100;   %速度
%         train_inputdata(2,(j-1)*tT+1:j*tT,i) = tempT;
%     end
%      tempdata = reshape(velspectrum,1,10000);
%      tempdata = tempdata/max(tempdata);
%     train_inputdata(3,:,i) = tempdata;   %能量
%     train_outputdata(1,:,i) = VT(1,:); %速度
%     train_outputdata(2,:,i) = VT(2,:); %时间

%     tempdata = reshape(tempdata,50,50);
%     tempdata = flipud(tempdata);
%     figure();    
%     contourf(v,t,tempdata);
    
    %%----------数据拷贝只有速度谱--------------%%
%      tempdata = reshape(velspectrum(:,51:251), 1,40401);
%      train_inputdata_onlyspectrum(i,:) = tempdata;  
% 	 train_outputdata_onlyspectrum(i,1) = n-1;
    

   %%-----------数据拷贝包括速度谱，时间，速度
 
%      [tT,tV] = size(velspectrum);
%      tempT = linspace(0,1,tV);
%      for j = 1:tT   
%          train_inputdata(1,(j-1)*tT+1:j*tT,i) = j*100/5000;   %速度
%          train_inputdata(2,(j-1)*tT+1:j*tT,i) = tempT;
%      end
%      train_inputdata(3,:,i) = tempdata; 


% 
    train_inputdata(1,:) = velspectrum(:);
    train_inputdata(1,:) = PreprocessData(train_inputdata(1,:));
%      test_A = ceil(train_inputdata(1,:));
%      test_A(test_A<100000) = 0;
%      binranges = 100000:10000:1000000;
%      [bincounts] = histc(test_A,binranges);
%      figure;
%      bar(binranges,bincounts,'histc');
%      figure;    
%      contourf(reshape(test_A,201,201));
%      figure
%      contourf(reshape(train_inputdata(1,:), 151,151));
     
%      
% %     normT0Vav =T0Vav;
% %     normT0Vav(1,:) = normT0Vav(1,:)/5000;
      train_outputVT(1,1:2*(n-1)) = reshape(T0Vav,1,2*(n-1));
      train_outputVT(1,19) = n-1;
      [tempM,tempN] = size(Multi_Vav);
      train_outputVT(1,20) = tempN;
    fprintf('The %d model is created.\n',i);
   
    file_name = strcat(int2str(i),'.csv');
    file_in_path = strcat('./train_inputdata/', file_name);
    file_out_path = strcat('./train_outputdata/', file_name);
    csvwrite(file_in_path,train_inputdata');
    csvwrite(file_out_path,train_outputVT'); 
   
%      drawVelSpectrum(synseis,VT,velspectrum,v,t)   
    toc
end

    %% ------------画图-------------------%%
     % drawVelSpectrum(synseis,VT,velspectrum,v,t)   


