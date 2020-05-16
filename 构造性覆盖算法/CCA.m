function [ ] = CCA(Input2,Label)
%Input:Matrix of the data attributes
%Label:classfication label of the data
%   @2019.11.9
%   @XuPeng
    %构造性覆盖算法
    %ratio : training
    %1-ratio : validation
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
    FlagTr = zeros(nTr,2);
    FlagVar = zeros(nVar,2);
    %Hidden 1-n : attributes 
    %Hidden n+1 : radius
    %Hidden n+2 : classNumber
    Hidden = zeros(1,n+2);
    nHidden = 0;
    
    % ***************** Start Training ******************************
    disp('Start Training ...');
    % find a random sample as the center
    while sum(FlagTr(:,1))~=nTr
        x = rand(1,1)*(nTr-1) + 1;
        if FlagTr(x,1)==1
           continue; 
        end
        if FlagTr(x,1)==0
            nHidden = nHidden + 1;
            for i = 1:n
                Hidden(nHidden,i) = Tr(x,i+1);
            end
            Hidden(nHidden,n+1) = 0;
            Hidden(nHidden,n+2) = Tr(x,1);
            FlagTr(x,1) = 1;
            FlagTr(x,2) = nHidden;
            dis = 0;
            for i = 1:nTr
                if Tr(i,1)~=Hidden(nHidden,n+2)
                    if dis < sum(Hidden(nHidden,1:n).*Tr(i,2:n+1))
                        dis = sum(Hidden(nHidden,1:n).*Tr(i,2:n+1));
                    end
                end
            end
            Hidden(nHidden,n+1) = dis;
            %fprintf('the radius of cricle %d is %f ,center is %d\n',nHidden,dis,x);
            for i = 1:nTr
                if FlagTr(i,1)==0 && Tr(i,1)==Hidden(nHidden,n+2) 
                    if dis < sum(Hidden(nHidden,1:n).*Tr(i,2:n+1))
                        FlagTr(i,1) = 1;
                        FlagTr(i,2) = nHidden;
                    end
                end
            end
        end
    end
    disp(Hidden);
    % ***************** Start Validating ******************************
    disp('Start Validating ...');
    for x = 1:nVar
        for y = 1:nHidden
            if sum(Hidden(y,1:n).*Var(x,2:n+1)) > Hidden(y,n+1)
                FlagVar(x,1) = 1;
                FlagVar(x,2) = Hidden(y,n+2);
                break;
            end
        end
        if FlagVar(x,1) == 0
            max = 0;
            FlagVar(x,1) = 8;
            for y = 1:nHidden
                if sum(Hidden(y,1:n).*Var(x,2:n+1)) > max
                    max = sum(Hidden(y,1:n).*Var(x,2:n+1));
                    FlagVar(x,2) = Hidden(y,n+2);
                end
            end
        end
    end
    nTrue = 0;
    for x = 1:nVar
       if FlagVar(x,2)==Var(x,1);
           nTrue = nTrue + 1;
       end
    end
%     disp('XXX  predictedValue  realValue');
%     disp([FlagVar,Var(:,1)]);
    numC = 0;
    for i = 1:nVar
       if FlagVar(i,1)==1
           numC = numC + 1;
       end
    end
    
    fprintf('nHidden = %d个\n',nHidden);
    fprintf('%d,%d\n',nTrue,nVar);
    fprintf('AccuracyRate = %.1f %s\n',nTrue*100/nVar,'%');
    fprintf('%d,%d\n',numC,nVar);
    fprintf('num_sample_inCricles = %.1f %s\n',numC*100/nVar,'%');
    

end

