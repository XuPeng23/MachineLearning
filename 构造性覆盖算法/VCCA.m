function [ ] = VCCA(Input2,Label)
%Input:Matrix of the data attributes
%Label:classfication label of the data
%   @2019.11.9
%   @XuPeng
    %构造性覆盖算法
    %ratio : training
    %1-ratio : validation
    kk = 15;
    %kk:同一训练集训练的CCA模型数量
    ratio = 0.7;
    [m,n] = size(Input2);
    %Data line1 : Label
    %Data line2 : attributes
    Data = [Label,Input2]; 
    [ndata,d] = size(Data);
    nTr = int16(ndata*ratio);
    nVar = int16(ndata*(1-ratio));
    R = randperm(ndata);
    Tr = zeros(nTr,d);
    Var = zeros(int16(nVar),d);
    %devide data into TrainData and VarData
    for i = 1:nTr
       Tr(i,:) = Data(R(i),:);
    end
    for i = nTr+1:ndata
       Var(i-nTr,:) = Data(R(i),:);
    end
    %Flag line1 : if samples is classified
    %Flag line2 : witch class 
    FlagTr = zeros(nTr,2,kk);
    FlagVar = zeros(nVar,1);
    %Hidden 1-n : w
    %Hidden n+1 : r
    %Hidden n+2 : classNo
    Hidden = zeros(1,n+2,kk);
    nHidden = zeros(1,kk);
    
    % ***************** Start Training ******************************
    for k = 1:kk
        %生成kk个CAA模型
        fprintf('Start Training (%d/%d)...',k,kk);
        % find a random sample as the center
        while sum(FlagTr(:,1,k))~=nTr
            x = rand(1,1)*(nTr-1) + 1;
            if FlagTr(x,1,k)==1
               continue; 
            end
            if FlagTr(x,1,k)==0
                nHidden(1,k) = nHidden(1,k) + 1;
                for i = 1:n
                    Hidden(nHidden(1,k),i,k) = Tr(x,i+1);
                end
                Hidden(nHidden(1,k),n+1,k) = 0;
                Hidden(nHidden(1,k),n+2,k) = Tr(x,1);
                FlagTr(x,1,k) = 1;
                FlagTr(x,2,k) = nHidden(1,k);
                dis = 0;
                for i = 1:nTr
                    if Tr(i,1)~=Hidden(nHidden(1,k),n+2,k)
                        if dis < sum(Hidden(nHidden(1,k),1:n,k).*Tr(i,2:n+1))
                            dis = sum(Hidden(nHidden(1,k),1:n,k).*Tr(i,2:n+1));
                        end
                    end
                end
                Hidden(nHidden(1,k),n+1,k) = dis;
                %fprintf('the radius of cricle %d is %f ,center is %d\n',nHidden(1,k),dis,x);
                for i = 1:nTr
                    if FlagTr(i,1,k)==0 && Tr(i,1)==Hidden(nHidden(1,k),n+2,k) 
                        if dis < sum(Hidden(nHidden(1,k),1:n,k).*Tr(i,2:n+1))
                            FlagTr(i,1,k) = 1;
                            FlagTr(i,2,k) = nHidden(1,k);
                        end
                    end
                end
            end
        end
        disp(Hidden(:,:,k));
    end
    % ***************** Start Validating ******************************
    disp('Start Validating ...');
    Class = 999*ones(nVar,kk);
    for k = 1:kk
        for x = 1:nVar
            for y = 1:nHidden(1,k)
                if sum(Hidden(y,1:n,k).*Var(x,2:n+1)) > Hidden(y,n+1,k)
                    Class(x,k) = Hidden(y,n+2,k);
                    break;
                end
            end
            if Class(x,k) == 999
                max = 0;
                for y = 1:nHidden(1,k)
                    if sum(Hidden(y,1:n,k).*Var(x,2:n+1)) > max
                        max = sum(Hidden(y,1:n,k).*Var(x,2:n+1));
                        Class(x,k) = Hidden(y,n+2,k);
                    end
                end
            end
        end
    end
    
    for i = 1:nVar
        ABC = tabulate(Class(i,:));
        [m,n] = size(ABC);
        indexMax = 1;
        for j = 2:m
           if ABC(j,3) > ABC(indexMax,3);
               indexMax = j;
           end
        end
        FlagVar(i) = ABC(indexMax,1);
    end
    
    
    nTrue = 0;
    for x = 1:nVar
       if FlagVar(x)==Var(x,1);
           nTrue = nTrue + 1;
       end
    end
    
    fprintf('nHidden = %d个\n',nHidden);
    fprintf('%d,%d\n',nTrue,nVar);
    fprintf('AccuracyRate = %.1f %s\n',nTrue*100/nVar,'%');
    

end
