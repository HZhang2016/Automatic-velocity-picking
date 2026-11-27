function wigb(a, scale, x, z)
%WIGB 简化版地震剖面波形图（替代 CREWES 工具箱中的 wigb）
%   a: 采样点数 x 道数 的地震数据矩阵
%   scale, x, z 参数可选，仅作兼容占位

    if nargin < 2 || isempty(scale), scale = 1; end
    [nsamp, ntrace] = size(a);
    if nargin < 3 || isempty(x), x = 1:ntrace; end
    if nargin < 4 || isempty(z), z = (0:nsamp-1); end

    maxa = max(abs(a(:)));
    if maxa == 0, maxa = 1; end
    dx = median(diff(x));
    if isempty(dx) || dx == 0, dx = 1; end

    hold on;
    for i = 1:ntrace
        trace = a(:, i) / maxa * scale * 0.9 * dx;
        plot(x(i) + trace, z, 'k-', 'LineWidth', 0.5);
    end
    hold off;
    set(gca, 'YDir', 'reverse');
    xlabel('道号');
    ylabel('采样点');
    title('合成地震记录');
end
