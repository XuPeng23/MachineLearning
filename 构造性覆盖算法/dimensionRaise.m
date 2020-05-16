function [Input2] = dimensionRaise(In)
    %属性数据升维处理
    disp('开始数据升维处理');
    [m,n] = size(In);
    Input2 = [In,zeros(m,1)];
    Dis = zeros(m,1);
    for i = [1:m]
        for j = [1:n]
            Dis(i) = Dis(i) + Input2(i,j)^2;
        end
    end
    indexMax = find(Dis == max(Dis));
    for i = 1:m
        Input2(i,n+1) = sqrt(max(Dis) - Dis(i));
    end
    disp('数据升维处理完成');
end

