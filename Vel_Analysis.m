% Task: Velocity analysis
% Written by zhanghao
% Date: August 15th, 2017

function [velspectrum,t,v]  = Vel_Analysis(data)
    offset=0;           %偏移距,
    dx=5;               %道间距.
    interval = 0.001;
    [samnum, ntrace]=size(data);  %求采样点数和地震道数
    
    % 速度分析用基本参数
	vmin=0;      % 初始速度
	vmax=5000;   % 终止速度
	dv=20;       % 速度间隔
	t0min=0;     % 初始t0时间 
	t0max=interval*(samnum-1);   % 终止t0时间
	dt=0.01;     % t0时间间隔
	%vnum=fix((vmax-vmin)/dv)+1;          %扫描速度个数
    vnum=fix((vmax-vmin)/dv);          %扫描速度个数
	t0num=fix((t0max-t0min)/dt)+1;       %扫描时间个数
	win_t=0.02;
	nwin_t=fix(win_t/2/interval); 
	velspectrum(1:vnum+1,1:t0num+1)=0;  %每个扫描速度与扫描时间对应的能量
   
    for k=1:t0num       %时间扫描
        t0=t0min+(k-1)*dt;
        for n=1:vnum       %速度扫描
            v=vmin+(n-1)*dv;
            sum2=0;
            for i=- nwin_t: nwin_t
                %时窗扫描，上下波动一个扫描时间点
                sum1=0;
                if(i>=0&&i<samnum)
                    for j=1:ntrace
                         x=offset+(j-1)*dx; %各检波器与炮点之间的距离
                         tx=sqrt(t0*t0+(x*x)/(v*v));
                         r=fix((tx)/interval);     %r=fix((tx-t0)/interval);
                         m=i+r;
                         if(m>0&&m<samnum)
                            sum1=sum1+data(m,j);  
                         end
                    end
                end
                if sum1>=500
                    sum1 =500;
                elseif sum1<1
                    sum1 = 0;
                end
                sum2=sum2+sum1^2;  
            end
           
            velspectrum(n,k)=sum2;
        end
    end
    
    t3=0:t0num;v3=0:vnum;
    t = t3*dt;
    v = v3*dv;
    velspectrum = velspectrum';
    
%     
%     figure(); 
%    imagesc(v,t,velspectrum);  
%     hold;
%      plot(v,t,'y-');
%   %  hole off;
%     set(gca,'XAxisLocation','top');
%     xlabel('Velocity(m/s)'); 
%     ylabel('Time(s)'); 
%     colorbar;
    
end

