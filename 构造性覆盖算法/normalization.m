function [Input] = normalization(In)
%   将数据归一化处理
    disp('开始数据归一化');
    [m,n] = size(In);
    Input = zeros(m,n);
    [max_In,index] = max(In);
    [min_In,index2] = min(In);
    for i = [1:n]
        for j = [1:m]
            Input(j,i) = (In(j,i)-min_In(i))/(max_In(i)-min_In(i));
        end
    end
    disp('数据归一化完成');
end

