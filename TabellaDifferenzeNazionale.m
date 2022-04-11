clearvars;
close all;

addpath('./DatabaseLocale/');
addpath('./TabelleDateGoogle/');
%% Read the available table for the analysis
TabellaA = readtable("./DatabaseLocale/TabellaAppleItalia.csv");
TabellaB = readtable("./DatabaseLocale/TabellaAppleRegioni.csv");
TabellaC = readtable("./DatabaseLocale/TabellaAppleCitta.csv");
TabellaD = readtable("./DatabaseLocale/TabellaAppleMobilityItalia.csv");
TabellaE = readtable("./DatabaseLocale/TabellaGoogleItaliaCompleta.csv");
TabellaF = readtable("./DatabaseLocale/TabellaGoogleNazionaleItalia.csv");
TabellaG = readtable("./DatabaseLocale/TabellaGoogleRegionaleItalia.csv");
TabellaH = readtable("./DatabaseLocale/TabellaGoogleCittaItalia.csv");
TabellaDifferenza = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabelleDifferenze/TabellaDifferenzaOrdinata.csv");
%% Setting parameters for graphs
startDate = datetime(cellstr(TabellaA.date(1)));
endDate = datetime(cellstr(TabellaA.date(height(TabellaA))));
date = (startDate:1:endDate);
date = datetime(date,"format","yyyy-MM-dd");

Inverno2020=(date(1):date(48));
Inverno2020Confronto=(date(1):date(47));
Primavera2020=(date(49):date(140));
Estate2020=(date(141):date(232));
Autunno2020=(date(233):date(323));
Inverno2021=(date(324):date(413));
Inverno2021Confronto= (date(367):date(413));
Primavera2021 = (date(414):date(505));
Estate2021 = (date(506):date(597));
Autunno2021 = (date(598):date(688));

startDateGoogle = datetime(cellstr(TabellaF.date(1)), "format","yyyy-MM-dd");
endDateGoogle = datetime(cellstr(TabellaF.date(height(TabellaF))), "format","yyyy-MM-dd");
dateGoogle = (startDateGoogle:1:endDateGoogle);
dateGoogle = datetime(dateGoogle,"format","yyyy-MM-dd");
Inverno2020ConfrontoGoogle = (dateGoogle(1):dateGoogle(14));
Inverno2021ConfrontoGoogle = (dateGoogle(367):dateGoogle(380));
GiorniGoogle2020 = dateGoogle(1:321);
GiorniGoogle2021Confronto = dateGoogle(365:length(dateGoogle)-1);
GiorniGoogle2020 = GiorniGoogle2020';
GiorniGoogle2021Confronto = GiorniGoogle2021Confronto';
%% Linear Regression model (y = 1 + x)
MatriceApple = TabellaA(:,7:9);
ArrayApple1=table2array(MatriceApple);
ArrayApple=rmmissing(ArrayApple1);

TabellaAConfrontoGoogle = TabellaA;
for i=1:height(TabellaA)
    TabellaAConfrontoGoogle.driving(i)= TabellaAConfrontoGoogle.driving(i)-100;
    TabellaAConfrontoGoogle.walking(i)= TabellaAConfrontoGoogle.walking(i)-100;
    TabellaAConfrontoGoogle.transit(i)= TabellaAConfrontoGoogle.transit(i)-100;
end
TabellaGoogleApple = TabellaF;
TabellaTempConfrontoGoogle = TabellaAConfrontoGoogle(TabellaAConfrontoGoogle.date>=datetime("15-02-2020","Format","dd-MM-yyyy"),:);
TabellaGoogleApple(:,16:18)=TabellaTempConfrontoGoogle(:,7:9);
TabellaGoogleApple.Properties.VariableNames(16:18)=TabellaA.Properties.VariableNames(7:9);
MatriceA = TabellaGoogleApple(:,10:18);
ArrayA1=table2array(MatriceA);
ArrayA=rmmissing(ArrayA1);

% 'true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

%% Google Grocery and Pharmacy vs Google Workplaces
f51=figure("Name","Google Grocery and Pharmacy vs GoogleWorkplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,2) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f51)
subplot(231)
scatter(ArrayA(:,2),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,2)) max(ArrayA(:,2))],linear(pars_linear,[min(ArrayA(:,2)) max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f51)
subplot(232)
scatter(ArrayA(:,2),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,2)) x0 max(ArrayA(:,2))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,2)) x0 max(ArrayA(:,2))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f51)
subplot(233)
scatter(ArrayA(:,2),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,2)) pars_piecewise(4) max(ArrayA(:,2))],piecewise(pars_piecewise,[min(ArrayA(:,2)) pars_piecewise(4) max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f51)
subplot(234)
scatter(ArrayA(:,2),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,2)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,2)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,2));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,2))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,2))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f51)
subplot(235)
scatter(ArrayA(:,2),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,2)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,2)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,2))],disjoint(pars_disjoint,[x1 max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

x0_fsp = 0;
c_piecewise = pars_piecewise(1)+(pars_piecewise(2)-pars_piecewise(3))*pars_piecewise(4);
c_piecewise_fsp = pars_piecewise_fsp(1)+(pars_piecewise_fsp(2)-pars_piecewise_fsp(3))*x0_fsp;


y1_piecewise_fsp = pars_piecewise_fsp(2)*x0_fsp+pars_piecewise_fsp(1);
y2_piecewise_fsp = pars_piecewise_fsp(3)*x0_fsp+c_piecewise_fsp;

y1_piecewise = pars_piecewise(2)*pars_piecewise(4)+pars_piecewise_fsp(1);
y2_piecewise = pars_piecewise(3)*pars_piecewise(4)+c_piecewise_fsp;

y1_disjoint = pars_disjoint(2)*pars_disjoint(5)+pars_disjoint(1);
y2_disjoint = pars_disjoint(4)*pars_disjoint(5)+pars_disjoint(3);

Differenza1 = 0.5626;
Differenza2 = 8.3568;
Differenza3 = 2.9540;
Differenza4 = 26.6536;
Differenza = abs(y2_disjoint-y1_disjoint);

%%
function RSS=eval_linear(pars,data)
    x=data(:,1);
    y=data(:,2);

    y_hat=linear(pars,x);
    
    RSS=sum((y-y_hat).^2);

%     figure(101)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=linear(pars,x)
    a=pars(1);
    b=pars(2);
    
    y_hat=a+b*x;
end

function RSS=eval_piecewise_fsp(pars,data,x0)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=piecewise_fsp(pars,x,x0);

    RSS=sum((y-y_hat).^2);

%     figure(102)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=piecewise_fsp(pars,x,x0)
    a=pars(1);
    b=pars(2);
    d=pars(3);
    c=a+(b-d)*x0;
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_piecewise(pars,data)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=piecewise(pars,x);

    RSS=sum((y-y_hat).^2);

%     figure(103)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=piecewise(pars,x)
    a=pars(1);
    b=pars(2);
    d=pars(3);
    x0=pars(4);
    c=a+(b-d)*x0;
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_disjoint_fsp(pars,data,x0)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=disjoint_fsp(pars,x,x0);

    RSS=sum((y-y_hat).^2);

%     figure(104)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=disjoint_fsp(pars,x,x0)
    a=pars(1);
    b=pars(2);
    c=pars(3);
    d=pars(4);
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_disjoint(pars,data)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=disjoint(pars,x);

    RSS=sum((y-y_hat).^2);

%     figure(105)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=disjoint(pars,x)
    a=pars(1);
    b=pars(2);
    c=pars(3);
    d=pars(4);
    x0=pars(5);
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end