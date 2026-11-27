function [ test_A ] = PreprocessData( data )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

     figure;
     contourf(flipud(reshape(data, 201,251)));
     title('未白化的速度谱')
     binranges = 0:10000:1000000;
     [bincounts] = histc(data,binranges);
     figure;
     bar(binranges,bincounts,'histc');
     title('未白化速度谱能量值分布');
     
     test_A = ceil(data);
     test_A(test_A<300000) = 0;

     
     figure;    
     contourf(flipud(reshape(test_A,201,251)));
     title('白化后的速度谱')
     
     binranges = 0:10000:1000000;
     [bincounts] = histc(test_A,binranges);
     figure;
     bar(binranges,bincounts,'histc');
     title('白化速度谱能量值分布');
     

end

