clc
clear all
format short
M = 10000;
Cost=[-2 -1 0 0 -M -M 0]; % Last 0 represents solution
A=[3 1 0 0 1 0;4 3 -1 0 1 0;1 2 0 0 0 1];
b=[3; 6; 3];
A = [A b];
BV = [4 5 6];
ZjCj=Cost(BV)*A-Cost;
ZCj=[ZjCj; A];
SimpTable=array2table(ZCj,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'}) 
Run=true;
while Run
    if any(ZjCj(1:end-1)<0)
        fprintf('The current BFS is not optimal \n')
        fprintf('\n=========The next iteration continues========\n')
        disp('Old Basic Variable (BV)=')
        disp(BV)
        ZC=ZjCj(1:end-1);
        [EnterCol, Pvt_Col]=min(ZC);
        fprintf('The most negative element in Z-Row is %d Corresponding to Column %d \n', EnterCol, Pvt_Col)
        fprintf('Entering Variable is %d \n', Pvt_Col)
        sol=A(:,end);
        Column=A(:,Pvt_Col)
        if all(Column<=0)
            error('LPP has unbounded solution. All entries <= 0 in column %d', Pvt_Col)
        else
            for i=1:size(Column,1)
                if Column(i)>0
                    ratio(i)=sol(i)./Column(i);
                else
                    ratio(i)=inf;
                end
            end
            [MinRatio, Pvt_Row]=min(ratio);
            fprintf('Minimum ratio corresponding to pivot row is %d \n', Pvt_Row)
            fprintf('Leaving Variable is %d \n', BV(Pvt_Row))
        end
        BV(Pvt_Row)=Pvt_Col;
        disp('New Basic Variables (BV) =')
        disp(BV)
        Pvt_Key=A(Pvt_Row,Pvt_Col);
        A(Pvt_Row,:)=A(Pvt_Row,:)./Pvt_Key;
        for i=1:size(A,1)
            if i~=Pvt_Row
                A(i,:)=A(i,:)-A(i,Pvt_Col).*A(Pvt_Row,:);
            end
        end
        ZjCj=ZjCj-ZjCj(Pvt_Col).*A(Pvt_Row,:);
        %To print the updated table
        ZCj=[ZjCj;A];
        SimpTable=array2table(ZCj,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'})
        BFS=zeros(1,size(A,2));
        BFS(BV)=A(:,end);
        BFS(end)=sum(BFS.*Cost);
        CurrentBFS=array2table(BFS,'VariableNames',{'x_1','x_2','x_3','s_1','s_2','s_3','Sol'})
    else
        Run=false
        fprintf('The current BFS is optimal and Optimality is reached \n')
    end
end
