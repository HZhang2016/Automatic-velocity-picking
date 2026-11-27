%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task: Obtain Synthetic seismogram
%  Written by zhanghao
% Date: August 15th, 2017

function [synseis,T,T0Vav,Multi_Vav] = Syn_Seismogram (model)
   
    [M,N] = size(model); %层数
     vel=model(1,:); %各层速度                                                                                                                                                                                    
    dens=model(2,:); %各层密度
    dep=model(3,:); %各层厚度
     T = zeros(1,N);
    offset =0; %偏移距
    dx=5;
    trace_num = 401;%道数
    sample_inter = 1;%采样间隔ms
    sample_num = 2000;%采集数
    wave_t = 400;%子波波长
    fp = 60;%子波频率
    wave_l=wave_t/sample_inter; 
    ref_allnum = randi([3,N-2],1,1);
    %%计 算 反 射 系 数—ref
    for i=1:N
        Z(i)=dens(i)*vel(i);
    end
    for i=1:N-1
        ref(i)=(Z(i+1)-Z(i))/(Z(i+1)+Z(i));
    end
    
    %%计 算 平 均 速 度
    h0 = 0; t0 = 0;
    T0Vav = zeros(2,N-1);
    for n=1:N-1
        h0 = h0+dep(n);
        t0 = t0+dep(n)/vel(n);
        Vav(n)=h0/t0;
        T0Vav(1,n) = Vav(n);
         T0(n) = 2*h0 / Vav(n);  %自激自收的时间
         T0Vav(2,n) = T0(n);
    end
      %计算
    
    
     T(1,1:N-1) = T0;
     T(1,N) = sample_num*0.001;  
    %计算多次波的VT对
    Multi_Vav = zeros(2,ref_allnum-1);
    for n = 1:ref_allnum-1
        Multi_Vav(1, n) = T0Vav(1,1);
        Multi_Vav(2, n) = T0Vav(2,1)*(n+1);      
    end
    

    %%-雷克子波
   % figure(1);
    w_t=-wave_t/(2*1000):0.001:wave_t/(2*1000); 
    rick=(1-2*(pi*fp*w_t).^2).*exp(-(pi*fp*w_t).^2);
   % plot(w_t*1000,rick);
   % title('雷克子波1');
    
     %%正演
    Mi = floor(trace_num/2)+1;  %中心点位置
    for i=1:trace_num 
        ref_i = i;
        for j=1:sample_num 
            a(j,i)=0; 
            b(j,i)=0;
        end
        for n=1:N-1 % N-1个反射界面-反射波
              x=offset+dx*abs(i-Mi);
              t(n)=sqrt((T0(n))^2+(x/Vav(n))^2);
              k(n,i)=round(t(n)*1000/sample_inter); 
              a(k(n,i),i)=ref(n);
        end 
        for ref_num = 2:ref_allnum
              x=offset+dx*abs(ref_i-Mi);
              t(1)=sqrt((T0(1)* ref_num)^2+(x/Vav(1))^2);
              ref_k=round(t(1)*1000/sample_inter); 
              b(ref_k,ref_i)=ref(1)*0.8^ref_num;
        end
    end
    a = a+b;
    %%convolution
    for i=1:trace_num 
        syn(:,i)=conv(a(:,i),rick); 
    end
   % synseis = zeros(sample_num,trace_num, 'gpyArray');
    for i=1:trace_num 
        for j=1:sample_num
            synseis(j,i)=syn(j+wave_t/2,i)*50; 
        end   
    end
    synseis = synseis(:,Mi:trace_num);
    figure(2);
    wigb(synseis);
end

