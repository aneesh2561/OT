clc
clear all
% f=@(x) x.*(x-2);
f=@(x) 3*x.*(x-9);
L=0;
R=2;
n=4;
t=linspace(L,R,100); %inbetween [0,2] how many points we want to plot
plot(t,f(t));
%generate the fibonacci series
fib=ones(1,n);% in matlab we start with index 1 so no F0
for i=3:n+1
    fib(i)=fib(i-1)+fib(i-2);
end
%construct table
for k=1:n
    ratio=fib(n+1-k)./fib(n+2-k);
    x2=L+ratio.*(R-L);
    x1=L+R-x2;
    fx1=f(x1);
    fx2=f(x2);
    rsl(k,:)=[L R x1 x2 fx1 fx2]; %for printing purpose
    if fx1<fx2
        R=x2;
    elseif fx1>fx2
        L=x1;
    elseif fx1==fx2
        if min(abs(x1),abs(L))==abs(L)
            R=x2;
        else
            L=x1;
        end
    end
end
var={'L','R','x1','x2','f(x1)','f(x2)'};
Rsl=array2table(rsl,'VariableNames',var)
xopt=(L+R)/2
fopt=f(xopt);
fprintf('Optimal value at x=%f is %f \n',xopt,fopt)