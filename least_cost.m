clc
clear
cost = [11 20 7  8;
        21 16 10 12;
        8  12 18 9];
B = [30 25 35 40];
A = [50 40 70];
if sum(A) == sum(B)
    fprint("Balanced")
else
    fprintf('Unbalanced')
    if sum(A) < sum(B)
        cost(end + 1, :) = zeros(1, length(B));
        A(end + 1) = sum(B) - sum(A);
    else
        cost(:, end + 1) = zeros(length(A), 1);
        B(end + 1) = sum(A) - sum(B);
    end
end
intial_cost = cost;
X = zeros(size(cost));
[m n] = size(cost);
BFS = m + n - 1;
for i = 1:size(cost, 1)
    for j = 1:size(cost, 2)
        mincost = min(cost(:));
        [rowind colind] = find(mincost == cost);
        x1 = min(A(rowind), B(colind));
        [val ind] = max(x1);
        ii = rowind(ind);
        jj = colind(ind);
        y1 = min(A(ii), B(jj));
        X(ii,jj) = y1;
        A(ii) = A(ii) - y1;
        B(jj) = B(jj) - y1;
        cost(ii,jj) = inf;
    end
end
fprintf("BFS : \n");
array2table(X)
totalBFS = length(nonzeros(X));
if totalBFS == BFS
    fprintf("Non degenerate\n")
else
    fprintf("Degenerate\n")
end
ITC = sum(sum(intial_cost .* X));
fprintf("Initial cost : %d\n", ITC)