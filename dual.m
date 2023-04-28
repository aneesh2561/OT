format short
clear
clc
%%
VariableNames = {'x1','x2','x3','s1','s2','Sol'};
Cost = [-2 0 -1 0 0 0];
Info = [-1 -1 1; -1 2 -4];
B = [-5; -8];
s = eye(size(Info,1));
A = [Info s B]
%% Finding starting BFS

BV = [];
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i) == s(:,j)
            BV = [BV i];
        end
    end
end
BV
%%
ZjCj = Cost(BV)*A - Cost
%%
array2table([ZjCj;A],"VariableNames",VariableNames)
%% Dual simplex

RUN = true
while RUN
    Sol = A(:,end);
    if any(Sol < 0)
        fprintf("Not Feasible")
        % Find minimum of solution : LEAVING VARIABLE
        [leaving_val,pvt_row_index] = min(Sol)

        % Find minimum of ratio of ZJ/Pvt_row (where pvt_row < 0) : ENTERING VARIABLE
        Pvt_row = A(pvt_row_index, 1: end-1)
        ZJ = ZjCj(:,1:end - 1)
        ratio = Inf(1,size(ZJ,2))
        ratio(Pvt_row < 0) = abs(ZJ(Pvt_row < 0)./Pvt_row(Pvt_row < 0))
        [minratio, pvt_col_index] = min(ratio)

        % Update BV
        BV(pvt_row_index) = pvt_col_index

        % PVT_KEY
        pvt_key = A(pvt_row_index,pvt_col_index)
        A(pvt_row_index,:) = A(pvt_row_index,:)./pvt_key

        for i = 1:size(A,1)
            if i ~= pvt_row_index
                A(i,:) = A(i,:)-A(i,pvt_col_index).*A(pvt_row_index,:);
            end
        end
        ZjCj = Cost(BV)*A - Cost
        array2table([ZjCj;A],"VariableNames",VariableNames)


    else
        RUN = false
        fprintf("Feasible and optimal")
    end
end
FINAL_BFS = zeros(1,size(A,2));
FINAL_BFS(BV) = A(:,end)
FINAL_BFS(end) = sum(FINAL_BFS.*Cost)
array2table(FINAL_BFS,"VariableNames",VariableNames)