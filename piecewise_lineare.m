clearvars
close all
clc

% `true' parameters
a=50;
b=2;
d=-0.5;
x0=20;
c=a+(b-d)*x0;

% generate noisy data points
np=200;
xmin=-100;
xmax=100;

x=rand(np,1)*(xmax-xmin)-xmax;

y=nan(np,1);
mask=x<=x0;
y(mask)=(a+b*x(mask));
mask=x>x0;
y(mask)=c+d*x(mask);

% % offset the right portion of the data
% y(mask)=y(mask)+50;

y=y+2*a*(rand(np,1)-1/2);
data=[x y];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b].*(1+0.5*(rand(1,2)-0.5));
[pars_linear,RSS_linear]=fminsearch(fun,p0);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

subplot(231)
scatter(x,y,'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(x) max(x)],linear(pars_linear,[min(x) max(x)]),'Color',col,'LineWidth',2)
%% Parallelismo con funzione fitlm
tbl = table(x,y);
lm = fitlm(tbl,'linear');
subplot(232)
plot(lm);
%%
function RSS=eval_linear(pars,data)
    x=data(:,1);
    y=data(:,2);

    y_hat=linear(pars,x);
    
    RSS=sum((y-y_hat).^2);
end

function y_hat=linear(pars,x)
    a=pars(1);
    b=pars(2);
    
    y_hat=a+b*x;
end