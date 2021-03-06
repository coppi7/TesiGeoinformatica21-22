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

%% Preallocation of table to save parameters of interest
sz = [36 8];
VarTypes = ["string" "double" "double" "double" "double" "double" "string" "string"];
VarNamesConfronti = ["Comparison" "a" "b" "c" "d" "x0" "model" "approximation"];
VarCategoriesConfronti = ["walking vs driving" "walking vs transit" "walking vs retail" "walking vs groc_and_pharm"...
    "walking vs parks" "walking vs transit stations" "walking vs workplaces" "walking vs residential" ...
    "driving vs transit" "driving vs retail" "driving vs groc_and_pharm" "driving vs parks" ...
    "driving vs transit stations" "driving vs workplaces" "driving vs residential" "transit vs retail"...
    "transit vs groc_and_pharm" "transit vs parks" "transit vs transit stations" "transit vs workplaces"...
    "transit vs residential" "retail vs groc_and_pharm" "retail vs parks" "retail vs transit stations" ...
    "retail vs workplaces" "retail vs residential" "groc_and_pharm vs parks" "groc_and_pharm vs transit stations"...
    "groc_and_pharm vs workplaces" "groc_and_pharm vs residential" "parks vs transit stations" "parks vs workplaces"...
    "parks vs residential" "transit stations vs workplaces" "transit stations vs residential" "workplaces vs residential"];
TabellaConfrontiAIC = table('Size',sz, 'VariableTypes',VarTypes,'VariableNames',VarNamesConfronti);
for i=1:height(TabellaConfrontiAIC)
    TabellaConfrontiAIC.Comparison(i)= VarCategoriesConfronti(i);
end
% 'true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;
%% Google Transit Stations vs Google Residential
f62=figure("Name","GoogleTransitStations vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,4) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f62)
subplot(231)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,4)) max(ArrayA(:,4))],linear(pars_linear,[min(ArrayA(:,4)) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f62)
subplot(232)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) x0 max(ArrayA(:,4))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,4)) x0 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f62)
subplot(233)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))],piecewise(pars_piecewise,[min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f62)
subplot(234)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,4)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,4));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f62)
subplot(235)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,4)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint(pars_disjoint,[x1 max(ArrayA(:,4))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f62)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
set(gca,'FontSize',20);
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(35) =  "linear";
    TabellaConfrontiAIC.a(35) =  pars_linear(1);
    TabellaConfrontiAIC.b(35) =  pars_linear(2);
    TabellaConfrontiAIC.c(35) =  nan;
    TabellaConfrontiAIC.d(35) =  nan;
    TabellaConfrontiAIC.x0(35) =  nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(35) =  "piecewise_fsp";
    TabellaConfrontiAIC.a(35) =  pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(35) =  pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(35) =  pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(35) =  0;
    TabellaConfrontiAIC.c(35) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(35) =  "piecewise";
    TabellaConfrontiAIC.a(35) =  pars_piecewise(1);
    TabellaConfrontiAIC.b(35) =  pars_piecewise(2);
    TabellaConfrontiAIC.d(35) =  pars_piecewise(3);
    TabellaConfrontiAIC.x0(35) =  pars_piecewise(4);
    TabellaConfrontiAIC.c(35) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(35) =  "disjoint_fsp";
    TabellaConfrontiAIC.a(35) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(35) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(35) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(35) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(35) =  0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(35) =  "disjoint";
    TabellaConfrontiAIC.a(35) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(35) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(35) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(35) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(35) = pars_disjoint(5);
end
if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(35) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(35) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(35) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(35) = "(disjoint_fsp)";
end
%% Apple Walking vs Apple Driving
f21=figure("Name","AppleWalking vs AppleDriving");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,7)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f21)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f21)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f21)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f21)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f21)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(1) = "linear";
    TabellaConfrontiAIC.a(1) = pars_linear(1);
    TabellaConfrontiAIC.b(1) = pars_linear(2);
    TabellaConfrontiAIC.c(1) = nan;
    TabellaConfrontiAIC.d(1) = nan;
    TabellaConfrontiAIC.x0(1) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(1) = "piecewise_fsp";
    TabellaConfrontiAIC.a(1) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(1) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(1) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(1) = 0;
    TabellaConfrontiAIC.c(1) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(1) = "piecewise";
    TabellaConfrontiAIC.a(1) = pars_piecewise(1);
    TabellaConfrontiAIC.b(1) = pars_piecewise(2);
    TabellaConfrontiAIC.d(1) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(1) = pars_piecewise(4);
    TabellaConfrontiAIC.c(1) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(1) = "disjoint_fsp";
    TabellaConfrontiAIC.a(1) = pars_disjoint(1);
    TabellaConfrontiAIC.b(1) = pars_disjoint(2);
    TabellaConfrontiAIC.c(1) = pars_disjoint(3);
    TabellaConfrontiAIC.d(1) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(1) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(1) = "disjoint";
    TabellaConfrontiAIC.a(1) = pars_disjoint(1);
    TabellaConfrontiAIC.b(1) = pars_disjoint(2);
    TabellaConfrontiAIC.c(1) = pars_disjoint(3);
    TabellaConfrontiAIC.d(1) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(1) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(1) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(1) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(1) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(1) = "(disjoint_fsp)";
end

figure(f21)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Walking vs Apple Transit
f20=figure("Name","AppleWalking vs AppleTransit");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,9)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f20)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,9),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f20)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f20)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f20)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f20)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(2) = "linear";
    TabellaConfrontiAIC.a(2) = pars_linear(1);
    TabellaConfrontiAIC.b(2) = pars_linear(2);
    TabellaConfrontiAIC.c(2) = nan;
    TabellaConfrontiAIC.d(2) = nan;
    TabellaConfrontiAIC.x0(2) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(2) = "piecewise_fsp";
    TabellaConfrontiAIC.a(2) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(2) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(2) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(2) = 0;
    TabellaConfrontiAIC.c(2) = TabellaConfrontiAIC.a(2)+(TabellaConfrontiAIC.b(2)-TabellaConfrontiAIC.d(2))*TabellaConfrontiAIC.x0(2);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(2) = "piecewise";
    TabellaConfrontiAIC.a(2) = pars_piecewise(1);
    TabellaConfrontiAIC.b(2) = pars_piecewise(2);
    TabellaConfrontiAIC.d(2) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(2) = pars_piecewise(4);
    TabellaConfrontiAIC.c(2) = TabellaConfrontiAIC.a(2)+(TabellaConfrontiAIC.b(2)-TabellaConfrontiAIC.d(2))*TabellaConfrontiAIC.x0(2);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(2) = "disjoint_fsp";
    TabellaConfrontiAIC.a(2) = pars_disjoint(1);
    TabellaConfrontiAIC.b(2) = pars_disjoint(2);
    TabellaConfrontiAIC.c(2) = pars_disjoint(3);
    TabellaConfrontiAIC.d(2) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(2) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(2) = "disjoint";
    TabellaConfrontiAIC.a(2) = pars_disjoint(1);
    TabellaConfrontiAIC.b(2) = pars_disjoint(2);
    TabellaConfrontiAIC.c(2) = pars_disjoint(3);
    TabellaConfrontiAIC.d(2) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(2) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(2) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(2) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(2) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(2) = "(disjoint_fsp)";
end

figure(f20)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google Retail and Recreation
f7=figure("Name","AppleWalking vs Google Retail and Recreation");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,1)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f7)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,1),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f7)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f7)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f7)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f7)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(3) = "linear";
    TabellaConfrontiAIC.a(3) = pars_linear(1);
    TabellaConfrontiAIC.b(3) = pars_linear(2);
    TabellaConfrontiAIC.c(3) = nan;
    TabellaConfrontiAIC.d(3) = nan;
    TabellaConfrontiAIC.x0(3) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(3) = "piecewise_fsp";
    TabellaConfrontiAIC.a(3) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(3) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(3) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(3) = 0;
    TabellaConfrontiAIC.c(3) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(3) = "piecewise";
    TabellaConfrontiAIC.a(3) = pars_piecewise(1);
    TabellaConfrontiAIC.b(3) = pars_piecewise(2);
    TabellaConfrontiAIC.d(3) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(3) = pars_piecewise(4);
    TabellaConfrontiAIC.c(3) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(3) = "disjoint_fsp";
    TabellaConfrontiAIC.a(3) = pars_disjoint(1);
    TabellaConfrontiAIC.b(3) = pars_disjoint(2);
    TabellaConfrontiAIC.c(3) = pars_disjoint(3);
    TabellaConfrontiAIC.d(3) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(3) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(3) = "disjoint";
    TabellaConfrontiAIC.a(3) = pars_disjoint(1);
    TabellaConfrontiAIC.b(3) = pars_disjoint(2);
    TabellaConfrontiAIC.c(3) = pars_disjoint(3);
    TabellaConfrontiAIC.d(3) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(3) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(3) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(3) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(3) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(3) = "(disjoint_fsp)";
end

figure(f7)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google grocery and pharmacy
f8=figure("Name","AppleWalking vs Google grocery and pharmacy");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,2)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f8)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,2),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f8)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f8)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f8)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f8)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(4) = "linear";
    TabellaConfrontiAIC.a(4) = pars_linear(1);
    TabellaConfrontiAIC.b(4) = pars_linear(2);
    TabellaConfrontiAIC.c(4) = nan;
    TabellaConfrontiAIC.d(4) = nan;
    TabellaConfrontiAIC.x0(4) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(4) = "piecewise_fsp";
    TabellaConfrontiAIC.a(4) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(4) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(4) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(4) = 0;
    TabellaConfrontiAIC.c(4) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(4) = "piecewise";
    TabellaConfrontiAIC.a(4) = pars_piecewise(1);
    TabellaConfrontiAIC.b(4) = pars_piecewise(2);
    TabellaConfrontiAIC.d(4) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(4) = pars_piecewise(4);
    TabellaConfrontiAIC.c(4) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(4) = "disjoint_fsp";
    TabellaConfrontiAIC.a(4) = pars_disjoint(1);
    TabellaConfrontiAIC.b(4) = pars_disjoint(2);
    TabellaConfrontiAIC.c(4) = pars_disjoint(3);
    TabellaConfrontiAIC.d(4) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(4) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(4) = "disjoint";
    TabellaConfrontiAIC.a(4) = pars_disjoint(1);
    TabellaConfrontiAIC.b(4) = pars_disjoint(2);
    TabellaConfrontiAIC.c(4) = pars_disjoint(3);
    TabellaConfrontiAIC.d(4) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(4) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(4) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(4) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(4) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(4) = "(disjoint_fsp)";
end

figure(f8)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google parks
f9=figure("Name","AppleWalking vs Google parks");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,3)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f9)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,3),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f9)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f9)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f9)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f9)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(5) = "linear";
    TabellaConfrontiAIC.a(5) = pars_linear(1);
    TabellaConfrontiAIC.b(5) = pars_linear(2);
    TabellaConfrontiAIC.c(5) = nan;
    TabellaConfrontiAIC.d(5) = nan;
    TabellaConfrontiAIC.x0(5) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(5) = "piecewise_fsp";
    TabellaConfrontiAIC.a(5) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(5) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(5) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(5) = 0;
    TabellaConfrontiAIC.c(5) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(5) = "piecewise";
    TabellaConfrontiAIC.a(5) = pars_piecewise(1);
    TabellaConfrontiAIC.b(5) = pars_piecewise(2);
    TabellaConfrontiAIC.d(5) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(5) = pars_piecewise(4);
    TabellaConfrontiAIC.c(5) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(5) = "disjoint_fsp";
    TabellaConfrontiAIC.a(5) = pars_disjoint(1);
    TabellaConfrontiAIC.b(5) = pars_disjoint(2);
    TabellaConfrontiAIC.c(5) = pars_disjoint(3);
    TabellaConfrontiAIC.d(5) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(5) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(5) = "disjoint";
    TabellaConfrontiAIC.a(5) = pars_disjoint(1);
    TabellaConfrontiAIC.b(5) = pars_disjoint(2);
    TabellaConfrontiAIC.c(5) = pars_disjoint(3);
    TabellaConfrontiAIC.d(5) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(5) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(5) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(5) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(5) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(5) = "(disjoint_fsp)";
end

figure(f9)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google transit station
f10=figure("Name","AppleWalking vs Google transit station");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,4)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f10)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f10)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f10)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f10)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f10)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(6) = "linear";
    TabellaConfrontiAIC.a(6) = pars_linear(1);
    TabellaConfrontiAIC.b(6) = pars_linear(2);
    TabellaConfrontiAIC.c(6) = nan;
    TabellaConfrontiAIC.d(6) = nan;
    TabellaConfrontiAIC.x0(6) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(6) = "piecewise_fsp";
    TabellaConfrontiAIC.a(6) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(6) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(6) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(6) = 0;
    TabellaConfrontiAIC.c(6) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(6) = "piecewise";
    TabellaConfrontiAIC.a(6) = pars_piecewise(1);
    TabellaConfrontiAIC.b(6) = pars_piecewise(2);
    TabellaConfrontiAIC.d(6) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(6) = pars_piecewise(4);
    TabellaConfrontiAIC.c(6) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(6) = "disjoint_fsp";
    TabellaConfrontiAIC.a(6) = pars_disjoint(1);
    TabellaConfrontiAIC.b(6) = pars_disjoint(2);
    TabellaConfrontiAIC.c(6) = pars_disjoint(3);
    TabellaConfrontiAIC.d(6) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(6) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(6) = "disjoint";
    TabellaConfrontiAIC.a(6) = pars_disjoint(1);
    TabellaConfrontiAIC.b(6) = pars_disjoint(2);
    TabellaConfrontiAIC.c(6) = pars_disjoint(3);
    TabellaConfrontiAIC.d(6) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(6) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(6) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(6) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(6) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(6) = "(disjoint_fsp)";
end

figure(f10)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google workplaces
f11=figure("Name","AppleWalking vs Google Workplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f11)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f11)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f11)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f11)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f11)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(7) =  "linear";
    TabellaConfrontiAIC.a(7) = pars_linear(1);
    TabellaConfrontiAIC.b(7) = pars_linear(2);
    TabellaConfrontiAIC.c(7) = nan;
    TabellaConfrontiAIC.d(7) = nan;
    TabellaConfrontiAIC.x0(7) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(7) = "piecewise_fsp";
    TabellaConfrontiAIC.a(7) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(7) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(7) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(7) = 0;
    TabellaConfrontiAIC.c(7) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(7) = "piecewise";
    TabellaConfrontiAIC.a(7) = pars_piecewise(1);
    TabellaConfrontiAIC.b(7) = pars_piecewise(2);
    TabellaConfrontiAIC.d(7) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(7) = pars_piecewise(4);
    TabellaConfrontiAIC.c(7) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(7) = "disjoint_fsp";
    TabellaConfrontiAIC.a(7) = pars_disjoint(1);
    TabellaConfrontiAIC.b(7) = pars_disjoint(2);
    TabellaConfrontiAIC.c(7) = pars_disjoint(3);
    TabellaConfrontiAIC.d(7) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(7) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(7) = "disjoint";
    TabellaConfrontiAIC.a(7) = pars_disjoint(1);
    TabellaConfrontiAIC.b(7) = pars_disjoint(2);
    TabellaConfrontiAIC.c(7) = pars_disjoint(3);
    TabellaConfrontiAIC.d(7) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(7) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(7) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(7) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(7) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(7) = "(disjoint_fsp)";
end

figure(f11)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple walking vs Google residential
f12=figure("Name","AppleWalking vs Google residential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,8) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f12)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f12)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f12)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f12)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f12)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(8) = "linear";
    TabellaConfrontiAIC.a(8) = pars_linear(1);
    TabellaConfrontiAIC.b(8) = pars_linear(2);
    TabellaConfrontiAIC.c(8) = nan;
    TabellaConfrontiAIC.d(8) = nan;
    TabellaConfrontiAIC.x0(8) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(8) = "piecewise_fsp";
    TabellaConfrontiAIC.a(8) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(8) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(8) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(8) = 0;
    TabellaConfrontiAIC.c(8) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(8) = "piecewise";
    TabellaConfrontiAIC.a(8) = pars_piecewise(1);
    TabellaConfrontiAIC.b(8) = pars_piecewise(2);
    TabellaConfrontiAIC.d(8) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(8) = pars_piecewise(4);
    TabellaConfrontiAIC.c(8) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(8) = "disjoint_fsp";
    TabellaConfrontiAIC.a(8) = pars_disjoint(1);
    TabellaConfrontiAIC.b(8) = pars_disjoint(2);
    TabellaConfrontiAIC.c(8) = pars_disjoint(3);
    TabellaConfrontiAIC.d(8) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(8) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(8) = "disjoint";
    TabellaConfrontiAIC.a(8) = pars_disjoint(1);
    TabellaConfrontiAIC.b(8) = pars_disjoint(2);
    TabellaConfrontiAIC.c(8) = pars_disjoint(3);
    TabellaConfrontiAIC.d(8) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(8) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(8) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(8) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(8) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(8) = "(disjoint_fsp)";
end

figure(f12)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Apple Transit
f23=figure("Name","AppleDrving vs AppleTransit");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,7) ArrayA(:,9)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f23)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,9),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f23)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f23)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f23)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f23)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,9),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(9) = "linear";
    TabellaConfrontiAIC.a(9) = pars_linear(1);
    TabellaConfrontiAIC.b(9) = pars_linear(2);
    TabellaConfrontiAIC.c(9) = nan;
    TabellaConfrontiAIC.d(9) = nan;
    TabellaConfrontiAIC.x0(9) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(9) = "piecewise_fsp";
    TabellaConfrontiAIC.a(9) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(9) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(9) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(9) = 0;
    TabellaConfrontiAIC.c(9) = TabellaConfrontiAIC.a(2)+(TabellaConfrontiAIC.b(2)-TabellaConfrontiAIC.d(2))*TabellaConfrontiAIC.x0(2);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(9) = "piecewise";
    TabellaConfrontiAIC.a(9) = pars_piecewise(1);
    TabellaConfrontiAIC.b(9) = pars_piecewise(2);
    TabellaConfrontiAIC.d(9) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(9) = pars_piecewise(4);
    TabellaConfrontiAIC.c(9) = TabellaConfrontiAIC.a(2)+(TabellaConfrontiAIC.b(2)-TabellaConfrontiAIC.d(2))*TabellaConfrontiAIC.x0(2);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(9) = "disjoint_fsp";
    TabellaConfrontiAIC.a(9) = pars_disjoint(1);
    TabellaConfrontiAIC.b(9) = pars_disjoint(2);
    TabellaConfrontiAIC.c(9) = pars_disjoint(3);
    TabellaConfrontiAIC.d(9) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(9) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(9) = "disjoint";
    TabellaConfrontiAIC.a(9) = pars_disjoint(1);
    TabellaConfrontiAIC.b(9) = pars_disjoint(2);
    TabellaConfrontiAIC.c(9) = pars_disjoint(3);
    TabellaConfrontiAIC.d(9) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(9) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(9) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(9) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(9) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(9) = "(disjoint_fsp)";
end

figure(f23)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Google retail and recreation
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f1=figure ("Name","AppleDriving vs Google retail and recreation");
data = [ArrayA(:,7) ArrayA(:,1)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f1)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,1),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f1)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f1)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f1)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f1)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(10) = "linear";
    TabellaConfrontiAIC.a(10) = pars_linear(1);
    TabellaConfrontiAIC.b(10) = pars_linear(2);
    TabellaConfrontiAIC.c(10) = nan;
    TabellaConfrontiAIC.d(10) = nan;
    TabellaConfrontiAIC.x0(10) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(10) = "piecewise_fsp";
    TabellaConfrontiAIC.a(10) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(10) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(10) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(10) = 0;
    TabellaConfrontiAIC.c(10) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(10) = "piecewise";
    TabellaConfrontiAIC.a(10) = pars_piecewise(1);
    TabellaConfrontiAIC.b(10) = pars_piecewise(2);
    TabellaConfrontiAIC.d(10) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(10) = pars_piecewise(4);
    TabellaConfrontiAIC.c(10) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(10) = "disjoint_fsp";
    TabellaConfrontiAIC.a(10) = pars_disjoint(1);
    TabellaConfrontiAIC.b(10) = pars_disjoint(2);
    TabellaConfrontiAIC.c(10) = pars_disjoint(3);
    TabellaConfrontiAIC.d(10) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(10) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(10) = "disjoint";
    TabellaConfrontiAIC.a(10) = pars_disjoint(1);
    TabellaConfrontiAIC.b(10) = pars_disjoint(2);
    TabellaConfrontiAIC.c(10) = pars_disjoint(3);
    TabellaConfrontiAIC.d(10) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(10) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(10) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(10) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(10) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(10) = "(disjoint_fsp)";
end

figure(f1)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Google grocery and pharmacy
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f2=figure ("Name","AppleDriving vs Google grocery and pharmacy");
data = [ArrayA(:,7) ArrayA(:,2)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f2)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,2),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f2)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f2)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f2)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f2)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(11) = "linear";
    TabellaConfrontiAIC.a(11) = pars_linear(1);
    TabellaConfrontiAIC.b(11) = pars_linear(2);
    TabellaConfrontiAIC.c(11) = nan;
    TabellaConfrontiAIC.d(11) = nan;
    TabellaConfrontiAIC.x0(11) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(11) = "piecewise_fsp";
    TabellaConfrontiAIC.a(11) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(11) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(11) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(11) = 0;
    TabellaConfrontiAIC.c(11) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(11) = "piecewise";
    TabellaConfrontiAIC.a(11) = pars_piecewise(1);
    TabellaConfrontiAIC.b(11) = pars_piecewise(2);
    TabellaConfrontiAIC.d(11) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(11) = pars_piecewise(4);
    TabellaConfrontiAIC.c(11) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(11) = "disjoint_fsp";
    TabellaConfrontiAIC.a(11) = pars_disjoint(1);
    TabellaConfrontiAIC.b(11) = pars_disjoint(2);
    TabellaConfrontiAIC.c(11) = pars_disjoint(3);
    TabellaConfrontiAIC.d(11) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(11) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(11) = "disjoint";
    TabellaConfrontiAIC.a(11) = pars_disjoint(1);
    TabellaConfrontiAIC.b(11) = pars_disjoint(2);
    TabellaConfrontiAIC.c(11) = pars_disjoint(3);
    TabellaConfrontiAIC.d(11) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(11) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(11) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(11) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(11) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(11) = "(disjoint_fsp)";
end

figure(f2)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs GoogleParks
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f3=figure ("Name","AppleDriving vs GoogleParks");
data = [ArrayA(:,7) ArrayA(:,3)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f3)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,3),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f3)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f3)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f3)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f3)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(12) = "linear";
    TabellaConfrontiAIC.a(12) = pars_linear(1);
    TabellaConfrontiAIC.b(12) = pars_linear(2);
    TabellaConfrontiAIC.c(12) = nan;
    TabellaConfrontiAIC.d(12) = nan;
    TabellaConfrontiAIC.x0(12) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(12) = "piecewise_fsp";
    TabellaConfrontiAIC.a(12) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(12) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(12) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(12) = 0;
    TabellaConfrontiAIC.c(12) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(12) = "piecewise";
    TabellaConfrontiAIC.a(12) = pars_piecewise(1);
    TabellaConfrontiAIC.b(12) = pars_piecewise(2);
    TabellaConfrontiAIC.d(12) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(12) = pars_piecewise(4);
    TabellaConfrontiAIC.c(12) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(12) = "disjoint_fsp";
    TabellaConfrontiAIC.a(12) = pars_disjoint(1);
    TabellaConfrontiAIC.b(12) = pars_disjoint(2);
    TabellaConfrontiAIC.c(12) = pars_disjoint(3);
    TabellaConfrontiAIC.d(12) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(12) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(12) = "disjoint";
    TabellaConfrontiAIC.a(12) = pars_disjoint(1);
    TabellaConfrontiAIC.b(12) = pars_disjoint(2);
    TabellaConfrontiAIC.c(12) = pars_disjoint(3);
    TabellaConfrontiAIC.d(12) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(12) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(12) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(12) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(12) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(12) = "(disjoint_fsp)";
end

figure(f3)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Google transit station
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f4=figure ("Name","AppleDriving vs Google transit station");
data = [ArrayA(:,7) ArrayA(:,4)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f4)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f4)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f4)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f4)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f4)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(13) = "linear";
    TabellaConfrontiAIC.a(13) = pars_linear(1);
    TabellaConfrontiAIC.b(13) = pars_linear(2);
    TabellaConfrontiAIC.c(13) = nan;
    TabellaConfrontiAIC.d(13) = nan;
    TabellaConfrontiAIC.x0(13) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(13) = "piecewise_fsp";
    TabellaConfrontiAIC.a(13) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(13) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(13) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(13) = 0;
    TabellaConfrontiAIC.c(13) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(13) = "piecewise";
    TabellaConfrontiAIC.a(13) = pars_piecewise(1);
    TabellaConfrontiAIC.b(13) = pars_piecewise(2);
    TabellaConfrontiAIC.d(13) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(13) = pars_piecewise(4);
    TabellaConfrontiAIC.c(13) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(13) = "disjoint_fsp";
    TabellaConfrontiAIC.a(13) = pars_disjoint(1);
    TabellaConfrontiAIC.b(13) = pars_disjoint(2);
    TabellaConfrontiAIC.c(13) = pars_disjoint(3);
    TabellaConfrontiAIC.d(13) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(13) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(13) = "disjoint";
    TabellaConfrontiAIC.a(13) = pars_disjoint(1);
    TabellaConfrontiAIC.b(13) = pars_disjoint(2);
    TabellaConfrontiAIC.c(13) = pars_disjoint(3);
    TabellaConfrontiAIC.d(13) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(13) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(13) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(13) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(13) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(13) = "(disjoint_fsp)";
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(13) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(13) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(13) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(13) = "(disjoint_fsp)";
end

figure(f4)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Google Workplaces
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f5=figure ("Name","AppleDriving vs Google Workplaces");
data = [ArrayA(:,7) ArrayA(:,5)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f5)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f5)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f5)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f5)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f5)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(14) = "linear";
    TabellaConfrontiAIC.a(14) = pars_linear(1);
    TabellaConfrontiAIC.b(14) = pars_linear(2);
    TabellaConfrontiAIC.c(14) = nan;
    TabellaConfrontiAIC.d(14) = nan;
    TabellaConfrontiAIC.x0(14) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(14) = "piecewise_fsp";
    TabellaConfrontiAIC.a(14) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(14) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(14) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(14) = 0;
    TabellaConfrontiAIC.c(14) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(14) = "piecewise";
    TabellaConfrontiAIC.a(14) = pars_piecewise(1);
    TabellaConfrontiAIC.b(14) = pars_piecewise(2);
    TabellaConfrontiAIC.d(14) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(14) = pars_piecewise(4);
    TabellaConfrontiAIC.c(14) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(14) = "disjoint_fsp";
    TabellaConfrontiAIC.a(14) = pars_disjoint(1);
    TabellaConfrontiAIC.b(14) = pars_disjoint(2);
    TabellaConfrontiAIC.c(14) = pars_disjoint(3);
    TabellaConfrontiAIC.d(14) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(14) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(14) = "disjoint";
    TabellaConfrontiAIC.a(14) = pars_disjoint(1);
    TabellaConfrontiAIC.b(14) = pars_disjoint(2);
    TabellaConfrontiAIC.c(14) = pars_disjoint(3);
    TabellaConfrontiAIC.d(14) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(14) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(14) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(14) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(14) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(14) = "(disjoint_fsp)";
end

figure(f5)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Driving vs Google Residential
% `true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

f6=figure ("Name","AppleDriving vs Google Residential");
data = [ArrayA(:,7) ArrayA(:,6)];

% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f6)
subplot(231)
scatter(ArrayA(:,7),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,7)) max(ArrayA(:,7))],linear(pars_linear,[min(ArrayA(:,7)) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f6)
subplot(232)
scatter(ArrayA(:,7),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,7)) x0 max(ArrayA(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,7)) x0 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f6)
subplot(233)
scatter(ArrayA(:,7),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))],piecewise(pars_piecewise,[min(ArrayA(:,7)) pars_piecewise(4) max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f6)
subplot(234)
scatter(ArrayA(:,7),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,7))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f6)
subplot(235)
scatter(ArrayA(:,7),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,7))],disjoint(pars_disjoint,[x1 max(ArrayA(:,7))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(15) = "linear";
    TabellaConfrontiAIC.a(15) = pars_linear(1);
    TabellaConfrontiAIC.b(15) = pars_linear(2);
    TabellaConfrontiAIC.c(15) = nan;
    TabellaConfrontiAIC.d(15) = nan;
    TabellaConfrontiAIC.x0(15) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(15) = "piecewise_fsp";
    TabellaConfrontiAIC.a(15) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(15) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(15) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(15) = 0;
    TabellaConfrontiAIC.c(15) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(15) = "piecewise";
    TabellaConfrontiAIC.a(15) = pars_piecewise(1);
    TabellaConfrontiAIC.b(15) = pars_piecewise(2);
    TabellaConfrontiAIC.d(15) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(15) = pars_piecewise(4);
    TabellaConfrontiAIC.c(15) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(15) = "disjoint_fsp";
    TabellaConfrontiAIC.a(15) = pars_disjoint(1);
    TabellaConfrontiAIC.b(15) = pars_disjoint(2);
    TabellaConfrontiAIC.c(15) = pars_disjoint(3);
    TabellaConfrontiAIC.d(15) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(15) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(15) = "disjoint";
    TabellaConfrontiAIC.a(15) = pars_disjoint(1);
    TabellaConfrontiAIC.b(15) = pars_disjoint(2);
    TabellaConfrontiAIC.c(15) = pars_disjoint(3);
    TabellaConfrontiAIC.d(15) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(15) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(15) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(15) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(15) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(15) = "(disjoint_fsp)";
end

figure(f6)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Transit vs Google Retail and Recreation
f13=figure("Name","AppleTransit vs Google Retail and Recreation");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,1)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f13)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,1),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f13)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f13)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f13)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f13)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,1),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(16) = "linear";
    TabellaConfrontiAIC.a(16) = pars_linear(1);
    TabellaConfrontiAIC.b(16) = pars_linear(2);
    TabellaConfrontiAIC.c(16) = nan;
    TabellaConfrontiAIC.d(16) = nan;
    TabellaConfrontiAIC.x0(16) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(16) = "piecewise_fsp";
    TabellaConfrontiAIC.a(16) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(16) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(16) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(16) = 0;
    TabellaConfrontiAIC.c(16) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(16) = "piecewise";
    TabellaConfrontiAIC.a(16) = pars_piecewise(1);
    TabellaConfrontiAIC.b(16) = pars_piecewise(2);
    TabellaConfrontiAIC.d(16) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(16) = pars_piecewise(4);
    TabellaConfrontiAIC.c(16) = TabellaConfrontiAIC.a(3)+(TabellaConfrontiAIC.b(3)-TabellaConfrontiAIC.d(3))*TabellaConfrontiAIC.x0(3);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(16) = "disjoint_fsp";
    TabellaConfrontiAIC.a(16) = pars_disjoint(1);
    TabellaConfrontiAIC.b(16) = pars_disjoint(2);
    TabellaConfrontiAIC.c(16) = pars_disjoint(3);
    TabellaConfrontiAIC.d(16) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(16) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(16) = "disjoint";
    TabellaConfrontiAIC.a(16) = pars_disjoint(1);
    TabellaConfrontiAIC.b(16) = pars_disjoint(2);
    TabellaConfrontiAIC.c(16) = pars_disjoint(3);
    TabellaConfrontiAIC.d(16) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(16) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(16) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(16) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(16) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(16) = "(disjoint_fsp)";
end

figure(f13)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Transit vs Google grocery and pharmacy
f14=figure("Name","AppleTransit vs Google grocery and pharmacy");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,2)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f14)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,2),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f14)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f14)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f14)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f14)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(17) = "linear";
    TabellaConfrontiAIC.a(17) = pars_linear(1);
    TabellaConfrontiAIC.b(17) = pars_linear(2);
    TabellaConfrontiAIC.c(17) = nan;
    TabellaConfrontiAIC.d(17) = nan;
    TabellaConfrontiAIC.x0(17) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(17) = "piecewise_fsp";
    TabellaConfrontiAIC.a(17) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(17) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(17) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(17) = 0;
    TabellaConfrontiAIC.c(17) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(17) = "piecewise";
    TabellaConfrontiAIC.a(17) = pars_piecewise(1);
    TabellaConfrontiAIC.b(17) = pars_piecewise(2);
    TabellaConfrontiAIC.d(17) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(17) = pars_piecewise(4);
    TabellaConfrontiAIC.c(17) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(17) = "disjoint_fsp";
    TabellaConfrontiAIC.a(17) = pars_disjoint(1);
    TabellaConfrontiAIC.b(17) = pars_disjoint(2);
    TabellaConfrontiAIC.c(17) = pars_disjoint(3);
    TabellaConfrontiAIC.d(17) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(17) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(17) = "disjoint";
    TabellaConfrontiAIC.a(17) = pars_disjoint(1);
    TabellaConfrontiAIC.b(17) = pars_disjoint(2);
    TabellaConfrontiAIC.c(17) = pars_disjoint(3);
    TabellaConfrontiAIC.d(17) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(17) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(17) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(17) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(17) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(17) = "(disjoint_fsp)";
end

figure(f14)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Transit vs Google parks
f15=figure("Name","AppleTransit vs Google parks");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,3)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f15)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,3),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f15)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f15)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f15)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f15)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(18) = "linear";
    TabellaConfrontiAIC.a(18) = pars_linear(1);
    TabellaConfrontiAIC.b(18) = pars_linear(2);
    TabellaConfrontiAIC.c(18) = nan;
    TabellaConfrontiAIC.d(18) = nan;
    TabellaConfrontiAIC.x0(18) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(18) = "piecewise_fsp";
    TabellaConfrontiAIC.a(18) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(18) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(18) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(18) = 0;
    TabellaConfrontiAIC.c(18) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(18) = "piecewise";
    TabellaConfrontiAIC.a(18) = pars_piecewise(1);
    TabellaConfrontiAIC.b(18) = pars_piecewise(2);
    TabellaConfrontiAIC.d(18) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(18) = pars_piecewise(4);
    TabellaConfrontiAIC.c(18) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(18) = "disjoint_fsp";
    TabellaConfrontiAIC.a(18) = pars_disjoint(1);
    TabellaConfrontiAIC.b(18) = pars_disjoint(2);
    TabellaConfrontiAIC.c(18) = pars_disjoint(3);
    TabellaConfrontiAIC.d(18) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(18) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(18) = "disjoint";
    TabellaConfrontiAIC.a(18) = pars_disjoint(1);
    TabellaConfrontiAIC.b(18) = pars_disjoint(2);
    TabellaConfrontiAIC.c(18) = pars_disjoint(3);
    TabellaConfrontiAIC.d(18) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(18) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(18) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(18) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(18) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(18) = "(disjoint_fsp)";
end

figure(f15)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Transit vs Google transit station
f16=figure("Name","AppleTransit vs Google transit station");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,4)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f16)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f16)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f16)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f16)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f16)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(19) = "linear";
    TabellaConfrontiAIC.a(19) = pars_linear(1);
    TabellaConfrontiAIC.b(19) = pars_linear(2);
    TabellaConfrontiAIC.c(19) = nan;
    TabellaConfrontiAIC.d(19) = nan;
    TabellaConfrontiAIC.x0(19) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(19) = "piecewise_fsp";
    TabellaConfrontiAIC.a(19) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(19) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(19) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(19) = 0;
    TabellaConfrontiAIC.c(19) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(19) = "piecewise";
    TabellaConfrontiAIC.a(19) = pars_piecewise(1);
    TabellaConfrontiAIC.b(19) = pars_piecewise(2);
    TabellaConfrontiAIC.d(19) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(19) = pars_piecewise(4);
    TabellaConfrontiAIC.c(19) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(19) = "disjoint_fsp";
    TabellaConfrontiAIC.a(19) = pars_disjoint(1);
    TabellaConfrontiAIC.b(19) = pars_disjoint(2);
    TabellaConfrontiAIC.c(19) = pars_disjoint(3);
    TabellaConfrontiAIC.d(19) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(19) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(19) = "disjoint";
    TabellaConfrontiAIC.a(19) = pars_disjoint(1);
    TabellaConfrontiAIC.b(19) = pars_disjoint(2);
    TabellaConfrontiAIC.c(19) = pars_disjoint(3);
    TabellaConfrontiAIC.d(19) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(19) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(19) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(19) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(19) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(19) = "(disjoint_fsp)";
end

figure(f16)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
%% Apple Transit vs Google workplaces
f17=figure("Name","AppleTransit vs Google Workplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f17)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f17)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f17)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f17)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f17)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(20) = "linear";
    TabellaConfrontiAIC.a(20) = pars_linear(1);
    TabellaConfrontiAIC.b(20) = pars_linear(2);
    TabellaConfrontiAIC.c(20) = nan;
    TabellaConfrontiAIC.d(20) = nan;
    TabellaConfrontiAIC.x0(20) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(20) = "piecewise_fsp";
    TabellaConfrontiAIC.a(20) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(20) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(20) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(20) = 0;
    TabellaConfrontiAIC.c(20) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(20) = "piecewise";
    TabellaConfrontiAIC.a(20) = pars_piecewise(1);
    TabellaConfrontiAIC.b(20) = pars_piecewise(2);
    TabellaConfrontiAIC.d(20) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(20) = pars_piecewise(4);
    TabellaConfrontiAIC.c(20) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(20) = "disjoint_fsp";
    TabellaConfrontiAIC.a(20) = pars_disjoint(1);
    TabellaConfrontiAIC.b(20) = pars_disjoint(2);
    TabellaConfrontiAIC.c(20) = pars_disjoint(3);
    TabellaConfrontiAIC.d(20) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(20) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(20) = "disjoint";
    TabellaConfrontiAIC.a(20) = pars_disjoint(1);
    TabellaConfrontiAIC.b(20) = pars_disjoint(2);
    TabellaConfrontiAIC.c(20) = pars_disjoint(3);
    TabellaConfrontiAIC.d(20) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(20) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(20) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(20) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(20) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(20) = "(disjoint_fsp)";
end

figure(f17)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

%% Apple Transit vs Google residential
f18=figure("Name","AppleTransit vs Google residential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,9) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f18)
subplot(231)
scatter(ArrayA(:,9),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,9)) max(ArrayA(:,9))],linear(pars_linear,[min(ArrayA(:,9)) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f18)
subplot(232)
scatter(ArrayA(:,9),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,9)) x0 max(ArrayA(:,9))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,9)) x0 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f18)
subplot(233)
scatter(ArrayA(:,9),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))],piecewise(pars_piecewise,[min(ArrayA(:,9)) pars_piecewise(4) max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f18)
subplot(234)
scatter(ArrayA(:,9),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,9)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,9)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,9));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,9))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f18)
subplot(235)
scatter(ArrayA(:,9),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,9)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,9)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,9))],disjoint(pars_disjoint,[x1 max(ArrayA(:,9))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(21) = "linear";
    TabellaConfrontiAIC.a(21) = pars_linear(1);
    TabellaConfrontiAIC.b(21) = pars_linear(2);
    TabellaConfrontiAIC.c(21) = nan;
    TabellaConfrontiAIC.d(21) = nan;
    TabellaConfrontiAIC.x0(21) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(21) = "piecewise_fsp";
    TabellaConfrontiAIC.a(21) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(21) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(21) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(21) = 0;
    TabellaConfrontiAIC.c(21) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(21) = "piecewise";
    TabellaConfrontiAIC.a(21) = pars_piecewise(1);
    TabellaConfrontiAIC.b(21) = pars_piecewise(2);
    TabellaConfrontiAIC.d(21) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(21) = pars_piecewise(4);
    TabellaConfrontiAIC.c(21) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(21) = "disjoint_fsp";
    TabellaConfrontiAIC.a(21) = pars_disjoint(1);
    TabellaConfrontiAIC.b(21) = pars_disjoint(2);
    TabellaConfrontiAIC.c(21) = pars_disjoint(3);
    TabellaConfrontiAIC.d(21) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(21) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(21) = "disjoint";
    TabellaConfrontiAIC.a(21) = pars_disjoint(1);
    TabellaConfrontiAIC.b(21) = pars_disjoint(2);
    TabellaConfrontiAIC.c(21) = pars_disjoint(3);
    TabellaConfrontiAIC.d(21) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(21) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(21) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(21) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(21) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(21) = "(disjoint_fsp)";
end

figure(f18)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

%% google retail and recreation vs Google Grocery and Pharmacy
f43=figure("Name","GoogleRetail vs Google Grocery and Pharmacy");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,1) ArrayA(:,2)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f43)
subplot(231)
scatter(ArrayA(:,1),ArrayA(:,2),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,1)) max(ArrayA(:,1))],linear(pars_linear,[min(ArrayA(:,1)) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f43)
subplot(232)
scatter(ArrayA(:,1),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,1)) x0 max(ArrayA(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,1)) x0 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f43)
subplot(233)
scatter(ArrayA(:,1),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))],piecewise(pars_piecewise,[min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f43)
subplot(234)
scatter(ArrayA(:,1),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f43)
subplot(235)
scatter(ArrayA(:,1),ArrayA(:,2),'filled')
hold on
plot([min(ArrayA(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint(pars_disjoint,[x1 max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f43)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(22) = "linear";
    TabellaConfrontiAIC.a(22) = pars_linear(1);
    TabellaConfrontiAIC.b(22) = pars_linear(2);
    TabellaConfrontiAIC.c(22) = nan;
    TabellaConfrontiAIC.d(22) = nan;
    TabellaConfrontiAIC.x0(22) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(22) = "piecewise_fsp";
    TabellaConfrontiAIC.a(22) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(22) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(22) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(22) = 0;
    TabellaConfrontiAIC.c(22) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(22) = "piecewise";
    TabellaConfrontiAIC.a(22) = pars_piecewise(1);
    TabellaConfrontiAIC.b(22) = pars_piecewise(2);
    TabellaConfrontiAIC.d(22) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(22) = pars_piecewise(4);
    TabellaConfrontiAIC.c(22) = TabellaConfrontiAIC.a(4)+(TabellaConfrontiAIC.b(4)-TabellaConfrontiAIC.d(4))*TabellaConfrontiAIC.x0(4);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(22) = "disjoint_fsp";
    TabellaConfrontiAIC.a(22) = pars_disjoint(1);
    TabellaConfrontiAIC.b(22) = pars_disjoint(2);
    TabellaConfrontiAIC.c(22) = pars_disjoint(3);
    TabellaConfrontiAIC.d(22) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(22) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(22) = "disjoint";
    TabellaConfrontiAIC.a(22) = pars_disjoint(1);
    TabellaConfrontiAIC.b(22) = pars_disjoint(2);
    TabellaConfrontiAIC.c(22) = pars_disjoint(3);
    TabellaConfrontiAIC.d(22) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(22) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(22) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(22) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(22) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(22) = "(disjoint_fsp)";
end
%% Google Retail and recreation vs Google Parks
f44=figure("Name","GoogleRetail vs GoogleParks");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,1) ArrayA(:,3)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f44)
subplot(231)
scatter(ArrayA(:,1),ArrayA(:,3),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,1)) max(ArrayA(:,1))],linear(pars_linear,[min(ArrayA(:,1)) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f44)
subplot(232)
scatter(ArrayA(:,1),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,1)) x0 max(ArrayA(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,1)) x0 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f44)
subplot(233)
scatter(ArrayA(:,1),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))],piecewise(pars_piecewise,[min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f44)
subplot(234)
scatter(ArrayA(:,1),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f44)
subplot(235)
scatter(ArrayA(:,1),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint(pars_disjoint,[x1 max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f44)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(23) = "linear";
    TabellaConfrontiAIC.a(23) = pars_linear(1);
    TabellaConfrontiAIC.b(23) = pars_linear(2);
    TabellaConfrontiAIC.c(23) = nan;
    TabellaConfrontiAIC.d(23) = nan;
    TabellaConfrontiAIC.x0(23) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(23) = "piecewise_fsp";
    TabellaConfrontiAIC.a(23) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(23) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(23) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(23) = 0;
    TabellaConfrontiAIC.c(23) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(23) = "piecewise";
    TabellaConfrontiAIC.a(23) = pars_piecewise(1);
    TabellaConfrontiAIC.b(23) = pars_piecewise(2);
    TabellaConfrontiAIC.d(23) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(23) = pars_piecewise(4);
    TabellaConfrontiAIC.c(23) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(23) = "disjoint_fsp";
    TabellaConfrontiAIC.a(23) = pars_disjoint(1);
    TabellaConfrontiAIC.b(23) = pars_disjoint(2);
    TabellaConfrontiAIC.c(23) = pars_disjoint(3);
    TabellaConfrontiAIC.d(23) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(23) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(23) = "disjoint";
    TabellaConfrontiAIC.a(23) = pars_disjoint(1);
    TabellaConfrontiAIC.b(23) = pars_disjoint(2);
    TabellaConfrontiAIC.c(23) = pars_disjoint(3);
    TabellaConfrontiAIC.d(23) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(23) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(23) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(23) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(23) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(23) = "(disjoint_fsp)";
end
%% google retail and recreation vs Google Transit Stations
f45=figure("Name","GoogleRetail vs GoogleTransitStations");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,1) ArrayA(:,4)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f45)
subplot(231)
scatter(ArrayA(:,1),ArrayA(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,1)) max(ArrayA(:,1))],linear(pars_linear,[min(ArrayA(:,1)) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f45)
subplot(232)
scatter(ArrayA(:,1),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,1)) x0 max(ArrayA(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,1)) x0 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f45)
subplot(233)
scatter(ArrayA(:,1),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))],piecewise(pars_piecewise,[min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f45)
subplot(234)
scatter(ArrayA(:,1),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f45)
subplot(235)
scatter(ArrayA(:,1),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint(pars_disjoint,[x1 max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f45)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(24) = "linear";
    TabellaConfrontiAIC.a(24) = pars_linear(1);
    TabellaConfrontiAIC.b(24) = pars_linear(2);
    TabellaConfrontiAIC.c(24) = nan;
    TabellaConfrontiAIC.d(24) = nan;
    TabellaConfrontiAIC.x0(24) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(24) = "piecewise_fsp";
    TabellaConfrontiAIC.a(24) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(24) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(24) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(24) = 0;
    TabellaConfrontiAIC.c(24) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(24) = "piecewise";
    TabellaConfrontiAIC.a(24) = pars_piecewise(1);
    TabellaConfrontiAIC.b(24) = pars_piecewise(2);
    TabellaConfrontiAIC.d(24) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(24) = pars_piecewise(4);
    TabellaConfrontiAIC.c(24) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(24) = "disjoint_fsp";
    TabellaConfrontiAIC.a(24) = pars_disjoint(1);
    TabellaConfrontiAIC.b(24) = pars_disjoint(2);
    TabellaConfrontiAIC.c(24) = pars_disjoint(3);
    TabellaConfrontiAIC.d(24) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(24) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(24) = "disjoint";
    TabellaConfrontiAIC.a(24) = pars_disjoint(1);
    TabellaConfrontiAIC.b(24) = pars_disjoint(2);
    TabellaConfrontiAIC.c(24) = pars_disjoint(3);
    TabellaConfrontiAIC.d(24) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(24) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(24) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(24) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(24) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(24) = "(disjoint_fsp)";
end
%% google retail and recreation vs Google Workplaces
f46=figure("Name","GoogleRetail vs GoogleWorkplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,1) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f46)
subplot(231)
scatter(ArrayA(:,1),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,1)) max(ArrayA(:,1))],linear(pars_linear,[min(ArrayA(:,1)) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f46)
subplot(232)
scatter(ArrayA(:,1),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,1)) x0 max(ArrayA(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,1)) x0 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f46)
subplot(233)
scatter(ArrayA(:,1),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))],piecewise(pars_piecewise,[min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f46)
subplot(234)
scatter(ArrayA(:,1),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f46)
subplot(235)
scatter(ArrayA(:,1),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint(pars_disjoint,[x1 max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f46)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(25) = "linear";
    TabellaConfrontiAIC.a(25) = pars_linear(1);
    TabellaConfrontiAIC.b(25) = pars_linear(2);
    TabellaConfrontiAIC.c(25) = nan;
    TabellaConfrontiAIC.d(25) = nan;
    TabellaConfrontiAIC.x0(25) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(25) = "piecewise_fsp";
    TabellaConfrontiAIC.a(25) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(25) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(25) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(25) = 0;
    TabellaConfrontiAIC.c(25) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(25) = "piecewise";
    TabellaConfrontiAIC.a(25) = pars_piecewise(1);
    TabellaConfrontiAIC.b(25) = pars_piecewise(2);
    TabellaConfrontiAIC.d(25) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(25) = pars_piecewise(4);
    TabellaConfrontiAIC.c(25) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(25) = "disjoint_fsp";
    TabellaConfrontiAIC.a(25) = pars_disjoint(1);
    TabellaConfrontiAIC.b(25) = pars_disjoint(2);
    TabellaConfrontiAIC.c(25) = pars_disjoint(3);
    TabellaConfrontiAIC.d(25) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(25) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(25) = "disjoint";
    TabellaConfrontiAIC.a(25) = pars_disjoint(1);
    TabellaConfrontiAIC.b(25) = pars_disjoint(2);
    TabellaConfrontiAIC.c(25) = pars_disjoint(3);
    TabellaConfrontiAIC.d(25) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(25) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(25) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(25) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(25) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(25) = "(disjoint_fsp)";
end
%% google retail and recreation vs Google Residential
f47=figure("Name","GoogleRetail vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,1) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f47)
subplot(231)
scatter(ArrayA(:,1),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,1)) max(ArrayA(:,1))],linear(pars_linear,[min(ArrayA(:,1)) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f47)
subplot(232)
scatter(ArrayA(:,1),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,1)) x0 max(ArrayA(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,1)) x0 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f47)
subplot(233)
scatter(ArrayA(:,1),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))],piecewise(pars_piecewise,[min(ArrayA(:,1)) pars_piecewise(4) max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f47)
subplot(234)
scatter(ArrayA(:,1),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,1))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f47)
subplot(235)
scatter(ArrayA(:,1),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,1))],disjoint(pars_disjoint,[x1 max(ArrayA(:,1))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f47)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(26) = "linear";
    TabellaConfrontiAIC.a(26) = pars_linear(1);
    TabellaConfrontiAIC.b(26) = pars_linear(2);
    TabellaConfrontiAIC.c(26) = nan;
    TabellaConfrontiAIC.d(26) = nan;
    TabellaConfrontiAIC.x0(26) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(26) = "piecewise_fsp";
    TabellaConfrontiAIC.a(26) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(26) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(26) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(26) = 0;
    TabellaConfrontiAIC.c(26) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(26) = "piecewise";
    TabellaConfrontiAIC.a(26) = pars_piecewise(1);
    TabellaConfrontiAIC.b(26) = pars_piecewise(2);
    TabellaConfrontiAIC.d(26) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(26) = pars_piecewise(4);
    TabellaConfrontiAIC.c(26) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(26) = "disjoint_fsp";
    TabellaConfrontiAIC.a(26) = pars_disjoint(1);
    TabellaConfrontiAIC.b(26) = pars_disjoint(2);
    TabellaConfrontiAIC.c(26) = pars_disjoint(3);
    TabellaConfrontiAIC.d(26) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(26) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(26) = "disjoint";
    TabellaConfrontiAIC.a(26) = pars_disjoint(1);
    TabellaConfrontiAIC.b(26) = pars_disjoint(2);
    TabellaConfrontiAIC.c(26) = pars_disjoint(3);
    TabellaConfrontiAIC.d(26) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(26) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(26) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(26) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(26) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(26) = "(disjoint_fsp)";
end
%% Google Grocery and Pharmacy vs Google Parks
f49=figure("Name","Google Grocery and Pharmacy vs GoogleParks");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,2) ArrayA(:,3)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f49)
subplot(231)
scatter(ArrayA(:,2),ArrayA(:,3),'filled')
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

figure(f49)
subplot(232)
scatter(ArrayA(:,2),ArrayA(:,3),'filled')
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

figure(f49)
subplot(233)
scatter(ArrayA(:,2),ArrayA(:,3),'filled')
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

figure(f49)
subplot(234)
scatter(ArrayA(:,2),ArrayA(:,3),'filled')
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

figure(f49)
subplot(235)
scatter(ArrayA(:,2),ArrayA(:,3),'filled')
hold on
plot([min(ArrayA(:,2)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,2)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,2))],disjoint(pars_disjoint,[x1 max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f49)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(27) = "linear";
    TabellaConfrontiAIC.a(27) = pars_linear(1);
    TabellaConfrontiAIC.b(27) = pars_linear(2);
    TabellaConfrontiAIC.c(27) = nan;
    TabellaConfrontiAIC.d(27) = nan;
    TabellaConfrontiAIC.x0(27) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(27) = "piecewise_fsp";
    TabellaConfrontiAIC.a(27) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(27) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(27) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(27) = 0;
    TabellaConfrontiAIC.c(27) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(27) = "piecewise";
    TabellaConfrontiAIC.a(27) = pars_piecewise(1);
    TabellaConfrontiAIC.b(27) = pars_piecewise(2);
    TabellaConfrontiAIC.d(27) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(27) = pars_piecewise(4);
    TabellaConfrontiAIC.c(27) = TabellaConfrontiAIC.a(5)+(TabellaConfrontiAIC.b(5)-TabellaConfrontiAIC.d(5))*TabellaConfrontiAIC.x0(5);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(27) = "disjoint_fsp";
    TabellaConfrontiAIC.a(27) = pars_disjoint(1);
    TabellaConfrontiAIC.b(27) = pars_disjoint(2);
    TabellaConfrontiAIC.c(27) = pars_disjoint(3);
    TabellaConfrontiAIC.d(27) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(27) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(27) = "disjoint";
    TabellaConfrontiAIC.a(27) = pars_disjoint(1);
    TabellaConfrontiAIC.b(27) = pars_disjoint(2);
    TabellaConfrontiAIC.c(27) = pars_disjoint(3);
    TabellaConfrontiAIC.d(27) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(27) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(27) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(27) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(27) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(27) = "(disjoint_fsp)";
end
%% Google Grocery and Pharmacy vs Google Transit Stations
f50=figure("Name","Google Grocery and Pharmacy vs GoogleTransitStations");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,2) ArrayA(:,4)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f50)
subplot(231)
scatter(ArrayA(:,2),ArrayA(:,4),'filled')
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

figure(f50)
subplot(232)
scatter(ArrayA(:,2),ArrayA(:,4),'filled')
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

figure(f50)
subplot(233)
scatter(ArrayA(:,2),ArrayA(:,4),'filled')
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

figure(f50)
subplot(234)
scatter(ArrayA(:,2),ArrayA(:,4),'filled')
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

figure(f50)
subplot(235)
scatter(ArrayA(:,2),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,2)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,2)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,2))],disjoint(pars_disjoint,[x1 max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f50)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(28) = "linear";
    TabellaConfrontiAIC.a(28) = pars_linear(1);
    TabellaConfrontiAIC.b(28) = pars_linear(2);
    TabellaConfrontiAIC.c(28) = nan;
    TabellaConfrontiAIC.d(28) = nan;
    TabellaConfrontiAIC.x0(28) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(28) = "piecewise_fsp";
    TabellaConfrontiAIC.a(28) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(28) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(28) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(28) = 0;
    TabellaConfrontiAIC.c(28) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(28) = "piecewise";
    TabellaConfrontiAIC.a(28) = pars_piecewise(1);
    TabellaConfrontiAIC.b(28) = pars_piecewise(2);
    TabellaConfrontiAIC.d(28) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(28) = pars_piecewise(4);
    TabellaConfrontiAIC.c(28) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(28) = "disjoint_fsp";
    TabellaConfrontiAIC.a(28) = pars_disjoint(1);
    TabellaConfrontiAIC.b(28) = pars_disjoint(2);
    TabellaConfrontiAIC.c(28) = pars_disjoint(3);
    TabellaConfrontiAIC.d(28) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(28) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(28) = "disjoint";
    TabellaConfrontiAIC.a(28) = pars_disjoint(1);
    TabellaConfrontiAIC.b(28) = pars_disjoint(2);
    TabellaConfrontiAIC.c(28) = pars_disjoint(3);
    TabellaConfrontiAIC.d(28) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(28) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(28) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(28) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(28) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(28) = "(disjoint_fsp)";
end
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

figure(f51)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(29) = "linear";
    TabellaConfrontiAIC.a(29) = pars_linear(1);
    TabellaConfrontiAIC.b(29) = pars_linear(2);
    TabellaConfrontiAIC.c(29) = nan;
    TabellaConfrontiAIC.d(29) = nan;
    TabellaConfrontiAIC.x0(29) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(29) = "piecewise_fsp";
    TabellaConfrontiAIC.a(29) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(29) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(29) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(29) = 0;
    TabellaConfrontiAIC.c(29) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(29) = "piecewise";
    TabellaConfrontiAIC.a(29) = pars_piecewise(1);
    TabellaConfrontiAIC.b(29) = pars_piecewise(2);
    TabellaConfrontiAIC.d(29) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(29) = pars_piecewise(4);
    TabellaConfrontiAIC.c(29) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(29) = "disjoint_fsp";
    TabellaConfrontiAIC.a(29) = pars_disjoint(1);
    TabellaConfrontiAIC.b(29) = pars_disjoint(2);
    TabellaConfrontiAIC.c(29) = pars_disjoint(3);
    TabellaConfrontiAIC.d(29) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(29) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(29) = "disjoint";
    TabellaConfrontiAIC.a(29) = pars_disjoint(1);
    TabellaConfrontiAIC.b(29) = pars_disjoint(2);
    TabellaConfrontiAIC.c(29) = pars_disjoint(3);
    TabellaConfrontiAIC.d(29) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(29) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(29) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(29) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(29) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(29) = "(disjoint_fsp)";
end
%% Google Grocery and Pharmacy vs Google Residential
f52=figure("Name","Google Grocery and Pharmacy vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,2) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f52)
subplot(231)
scatter(ArrayA(:,2),ArrayA(:,6),'filled')
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

figure(f52)
subplot(232)
scatter(ArrayA(:,2),ArrayA(:,6),'filled')
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

figure(f52)
subplot(233)
scatter(ArrayA(:,2),ArrayA(:,6),'filled')
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

figure(f52)
subplot(234)
scatter(ArrayA(:,2),ArrayA(:,6),'filled')
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

figure(f52)
subplot(235)
scatter(ArrayA(:,2),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,2)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,2)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,2))],disjoint(pars_disjoint,[x1 max(ArrayA(:,2))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f52)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(30) = "linear";
    TabellaConfrontiAIC.a(30) = pars_linear(1);
    TabellaConfrontiAIC.b(30) = pars_linear(2);
    TabellaConfrontiAIC.c(30) = nan;
    TabellaConfrontiAIC.d(30) = nan;
    TabellaConfrontiAIC.x0(30) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(30) = "piecewise_fsp";
    TabellaConfrontiAIC.a(30) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(30) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(30) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(30) = 0;
    TabellaConfrontiAIC.c(30) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(30) = "piecewise";
    TabellaConfrontiAIC.a(30) = pars_piecewise(1);
    TabellaConfrontiAIC.b(30) = pars_piecewise(2);
    TabellaConfrontiAIC.d(30) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(30) = pars_piecewise(4);
    TabellaConfrontiAIC.c(30) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(30) = "disjoint_fsp";
    TabellaConfrontiAIC.a(30) = pars_disjoint(1);
    TabellaConfrontiAIC.b(30) = pars_disjoint(2);
    TabellaConfrontiAIC.c(30) = pars_disjoint(3);
    TabellaConfrontiAIC.d(30) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(30) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(30) = "disjoint";
    TabellaConfrontiAIC.a(30) = pars_disjoint(1);
    TabellaConfrontiAIC.b(30) = pars_disjoint(2);
    TabellaConfrontiAIC.c(30) = pars_disjoint(3);
    TabellaConfrontiAIC.d(30) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(30) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(30) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(30) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(30) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(30) = "(disjoint_fsp)";
end
%% Google Parks vs Google Transit Stations
f55=figure("Name","GoogleParks vs GoogleTransitStations");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,3) ArrayA(:,4)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f55)
subplot(231)
scatter(ArrayA(:,3),ArrayA(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,3)) max(ArrayA(:,3))],linear(pars_linear,[min(ArrayA(:,3)) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f55)
subplot(232)
scatter(ArrayA(:,3),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,3)) x0 max(ArrayA(:,3))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,3)) x0 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f55)
subplot(233)
scatter(ArrayA(:,3),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))],piecewise(pars_piecewise,[min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f55)
subplot(234)
scatter(ArrayA(:,3),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,3)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,3)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,3));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f55)
subplot(235)
scatter(ArrayA(:,3),ArrayA(:,4),'filled')
hold on
plot([min(ArrayA(:,3)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,3)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint(pars_disjoint,[x1 max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f55)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(31) = "linear";
    TabellaConfrontiAIC.a(31) = pars_linear(1);
    TabellaConfrontiAIC.b(31) = pars_linear(2);
    TabellaConfrontiAIC.c(31) = nan;
    TabellaConfrontiAIC.d(31) = nan;
    TabellaConfrontiAIC.x0(31) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(31) = "piecewise_fsp";
    TabellaConfrontiAIC.a(31) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(31) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(31) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(31) = 0;
    TabellaConfrontiAIC.c(31) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(31) = "piecewise";
    TabellaConfrontiAIC.a(31) = pars_piecewise(1);
    TabellaConfrontiAIC.b(31) = pars_piecewise(2);
    TabellaConfrontiAIC.d(31) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(31) = pars_piecewise(4);
    TabellaConfrontiAIC.c(31) = TabellaConfrontiAIC.a(6)+(TabellaConfrontiAIC.b(6)-TabellaConfrontiAIC.d(6))*TabellaConfrontiAIC.x0(6);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(31) = "disjoint_fsp";
    TabellaConfrontiAIC.a(31) = pars_disjoint(1);
    TabellaConfrontiAIC.b(31) = pars_disjoint(2);
    TabellaConfrontiAIC.c(31) = pars_disjoint(3);
    TabellaConfrontiAIC.d(31) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(31) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(31) = "disjoint";
    TabellaConfrontiAIC.a(31) = pars_disjoint(1);
    TabellaConfrontiAIC.b(31) = pars_disjoint(2);
    TabellaConfrontiAIC.c(31) = pars_disjoint(3);
    TabellaConfrontiAIC.d(31) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(31) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(31) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(31) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(31) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(31) = "(disjoint_fsp)";
end
%% Google Parks vs Google Workplaces
f56=figure("Name","GoogleParks vs GoogleWorkplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,3) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f56)
subplot(231)
scatter(ArrayA(:,3),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,3)) max(ArrayA(:,3))],linear(pars_linear,[min(ArrayA(:,3)) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f56)
subplot(232)
scatter(ArrayA(:,3),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,3)) x0 max(ArrayA(:,3))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,3)) x0 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f56)
subplot(233)
scatter(ArrayA(:,3),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))],piecewise(pars_piecewise,[min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f56)
subplot(234)
scatter(ArrayA(:,3),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,3)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,3)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,3));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f56)
subplot(235)
scatter(ArrayA(:,3),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,3)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,3)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint(pars_disjoint,[x1 max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f56)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(32) = "linear";
    TabellaConfrontiAIC.a(32) = pars_linear(1);
    TabellaConfrontiAIC.b(32) = pars_linear(2);
    TabellaConfrontiAIC.c(32) = nan;
    TabellaConfrontiAIC.d(32) = nan;
    TabellaConfrontiAIC.x0(32) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(32) = "piecewise_fsp";
    TabellaConfrontiAIC.a(32) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(32) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(32) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(32) = 0;
    TabellaConfrontiAIC.c(32) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(32) = "piecewise";
    TabellaConfrontiAIC.a(32) = pars_piecewise(1);
    TabellaConfrontiAIC.b(32) = pars_piecewise(2);
    TabellaConfrontiAIC.d(32) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(32) = pars_piecewise(4);
    TabellaConfrontiAIC.c(32) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(32) = "disjoint_fsp";
    TabellaConfrontiAIC.a(32) = pars_disjoint(1);
    TabellaConfrontiAIC.b(32) = pars_disjoint(2);
    TabellaConfrontiAIC.c(32) = pars_disjoint(3);
    TabellaConfrontiAIC.d(32) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(32) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(32) = "disjoint";
    TabellaConfrontiAIC.a(32) = pars_disjoint(1);
    TabellaConfrontiAIC.b(32) = pars_disjoint(2);
    TabellaConfrontiAIC.c(32) = pars_disjoint(3);
    TabellaConfrontiAIC.d(32) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(32) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(32) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(32) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(32) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(32) = "(disjoint_fsp)";
end
%% Google Parks vs Google Residential
f57=figure("Name","GoogleParks vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,3) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f57)
subplot(231)
scatter(ArrayA(:,3),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,3)) max(ArrayA(:,3))],linear(pars_linear,[min(ArrayA(:,3)) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f57)
subplot(232)
scatter(ArrayA(:,3),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,3)) x0 max(ArrayA(:,3))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,3)) x0 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f57)
subplot(233)
scatter(ArrayA(:,3),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))],piecewise(pars_piecewise,[min(ArrayA(:,3)) pars_piecewise(4) max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f57)
subplot(234)
scatter(ArrayA(:,3),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,3)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,3)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,3));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,3))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f57)
subplot(235)
scatter(ArrayA(:,3),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,3)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,3)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,3))],disjoint(pars_disjoint,[x1 max(ArrayA(:,3))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f57)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(33) = "linear";
    TabellaConfrontiAIC.a(33) = pars_linear(1);
    TabellaConfrontiAIC.b(33) = pars_linear(2);
    TabellaConfrontiAIC.c(33) = nan;
    TabellaConfrontiAIC.d(33) = nan;
    TabellaConfrontiAIC.x0(33) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(33) = "piecewise_fsp";
    TabellaConfrontiAIC.a(33) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(33) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(33) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(33) = 0;
    TabellaConfrontiAIC.c(33) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(33) = "piecewise";
    TabellaConfrontiAIC.a(33) = pars_piecewise(1);
    TabellaConfrontiAIC.b(33) = pars_piecewise(2);
    TabellaConfrontiAIC.d(33) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(33) = pars_piecewise(4);
    TabellaConfrontiAIC.c(33) = TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(33) = "disjoint_fsp";
    TabellaConfrontiAIC.a(33) = pars_disjoint(1);
    TabellaConfrontiAIC.b(33) = pars_disjoint(2);
    TabellaConfrontiAIC.c(33) = pars_disjoint(3);
    TabellaConfrontiAIC.d(33) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(33) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(33) = "disjoint";
    TabellaConfrontiAIC.a(33) = pars_disjoint(1);
    TabellaConfrontiAIC.b(33) = pars_disjoint(2);
    TabellaConfrontiAIC.c(33) = pars_disjoint(3);
    TabellaConfrontiAIC.d(33) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(33) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(33) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(33) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(33) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(33) = "(disjoint_fsp)";
end
%% Google Transit Stations vs Google Workplaces
f61=figure("Name","GoogleTransitStations vs GoogleWorkplaces");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,4) ArrayA(:,5)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f61)
subplot(231)
scatter(ArrayA(:,4),ArrayA(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,4)) max(ArrayA(:,4))],linear(pars_linear,[min(ArrayA(:,4)) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f61)
subplot(232)
scatter(ArrayA(:,4),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,4)) x0 max(ArrayA(:,4))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,4)) x0 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f61)
subplot(233)
scatter(ArrayA(:,4),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))],piecewise(pars_piecewise,[min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f61)
subplot(234)
scatter(ArrayA(:,4),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,4)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,4)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,4));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f61)
subplot(235)
scatter(ArrayA(:,4),ArrayA(:,5),'filled')
hold on
plot([min(ArrayA(:,4)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,4)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint(pars_disjoint,[x1 max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f61)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(34) = "linear";
    TabellaConfrontiAIC.a(34) = pars_linear(1);
    TabellaConfrontiAIC.b(34) = pars_linear(2);
    TabellaConfrontiAIC.c(34) = nan;
    TabellaConfrontiAIC.d(34) = nan;
    TabellaConfrontiAIC.x0(34) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(34) = "piecewise_fsp";
    TabellaConfrontiAIC.a(34) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(34) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(34) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(34) = 0;
    TabellaConfrontiAIC.c(34) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(34) = "piecewise";
    TabellaConfrontiAIC.a(34) = pars_piecewise(1);
    TabellaConfrontiAIC.b(34) = pars_piecewise(2);
    TabellaConfrontiAIC.d(34) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(34) = pars_piecewise(4);
    TabellaConfrontiAIC.c(34) = TabellaConfrontiAIC.a(7)+(TabellaConfrontiAIC.b(7)-TabellaConfrontiAIC.d(7))*TabellaConfrontiAIC.x0(7);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(34) = "disjoint_fsp";
    TabellaConfrontiAIC.a(34) = pars_disjoint(1);
    TabellaConfrontiAIC.b(34) = pars_disjoint(2);
    TabellaConfrontiAIC.c(34) = pars_disjoint(3);
    TabellaConfrontiAIC.d(34) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(34) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(34) = "disjoint";
    TabellaConfrontiAIC.a(34) = pars_disjoint(1);
    TabellaConfrontiAIC.b(34) = pars_disjoint(2);
    TabellaConfrontiAIC.c(34) = pars_disjoint(3);
    TabellaConfrontiAIC.d(34) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(34) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(34) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(34) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(34) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(34) = "(disjoint_fsp)";
end
%% Google Transit Stations vs Google Residential
f62=figure("Name","GoogleTransitStations vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,4) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f62)
subplot(231)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,4)) max(ArrayA(:,4))],linear(pars_linear,[min(ArrayA(:,4)) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f62)
subplot(232)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) x0 max(ArrayA(:,4))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,4)) x0 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f62)
subplot(233)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))],piecewise(pars_piecewise,[min(ArrayA(:,4)) pars_piecewise(4) max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f62)
subplot(234)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,4)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,4));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,4))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f62)
subplot(235)
scatter(ArrayA(:,4),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,4)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,4)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,4))],disjoint(pars_disjoint,[x1 max(ArrayA(:,4))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f62)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(35) =  "linear";
    TabellaConfrontiAIC.a(35) =  pars_linear(1);
    TabellaConfrontiAIC.b(35) =  pars_linear(2);
    TabellaConfrontiAIC.c(35) =  nan;
    TabellaConfrontiAIC.d(35) =  nan;
    TabellaConfrontiAIC.x0(35) =  nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(35) =  "piecewise_fsp";
    TabellaConfrontiAIC.a(35) =  pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(35) =  pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(35) =  pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(35) =  0;
    TabellaConfrontiAIC.c(35) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(35) =  "piecewise";
    TabellaConfrontiAIC.a(35) =  pars_piecewise(1);
    TabellaConfrontiAIC.b(35) =  pars_piecewise(2);
    TabellaConfrontiAIC.d(35) =  pars_piecewise(3);
    TabellaConfrontiAIC.x0(35) =  pars_piecewise(4);
    TabellaConfrontiAIC.c(35) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(35) =  "disjoint_fsp";
    TabellaConfrontiAIC.a(35) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(35) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(35) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(35) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(35) =  0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(35) =  "disjoint";
    TabellaConfrontiAIC.a(35) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(35) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(35) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(35) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(35) = pars_disjoint(5);
end
if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(35) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(35) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(35) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(35) = "(disjoint_fsp)";
end
%% Google Workplaces vs Google Residential
f67=figure("Name","GoogleWorkplaces vs GoogleResidential");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayA(:,5) ArrayA(:,6)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f67)
subplot(231)
scatter(ArrayA(:,5),ArrayA(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,5)) max(ArrayA(:,5))],linear(pars_linear,[min(ArrayA(:,5)) max(ArrayA(:,5))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f67)
subplot(232)
scatter(ArrayA(:,5),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,5)) x0 max(ArrayA(:,5))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,5)) x0 max(ArrayA(:,5))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f67)
subplot(233)
scatter(ArrayA(:,5),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,5)) pars_piecewise(4) max(ArrayA(:,5))],piecewise(pars_piecewise,[min(ArrayA(:,5)) pars_piecewise(4) max(ArrayA(:,5))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f67)
subplot(234)
scatter(ArrayA(:,5),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,5)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,5)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,5));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,5))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,5))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f67)
subplot(235)
scatter(ArrayA(:,5),ArrayA(:,6),'filled')
hold on
plot([min(ArrayA(:,5)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,5)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,5))],disjoint(pars_disjoint,[x1 max(ArrayA(:,5))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);

figure(f67)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off

if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(36) =  "linear";
    TabellaConfrontiAIC.a(36) =  pars_linear(1);
    TabellaConfrontiAIC.b(36) =  pars_linear(2);
    TabellaConfrontiAIC.c(36) =  nan;
    TabellaConfrontiAIC.d(36) =  nan;
    TabellaConfrontiAIC.x0(36) =  nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(36) =  "piecewise_fsp";
    TabellaConfrontiAIC.a(36) =  pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(36) =  pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(36) =  pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(36) =  0;
    TabellaConfrontiAIC.c(36) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(36) =  "piecewise";
    TabellaConfrontiAIC.a(36) =  pars_piecewise(1);
    TabellaConfrontiAIC.b(36) =  pars_piecewise(2);
    TabellaConfrontiAIC.d(36) =  pars_piecewise(3);
    TabellaConfrontiAIC.x0(36) =  pars_piecewise(4);
    TabellaConfrontiAIC.c(36) =  TabellaConfrontiAIC.a(8)+(TabellaConfrontiAIC.b(8)-TabellaConfrontiAIC.d(8))*TabellaConfrontiAIC.x0(8);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(36) =  "disjoint_fsp";
    TabellaConfrontiAIC.a(36) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(36) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(36) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(36) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(36) =  0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(36) =  "disjoint";
    TabellaConfrontiAIC.a(36) =  pars_disjoint(1);
    TabellaConfrontiAIC.b(36) =  pars_disjoint(2);
    TabellaConfrontiAIC.c(36) =  pars_disjoint(3);
    TabellaConfrontiAIC.d(36) =  pars_disjoint(4);
    TabellaConfrontiAIC.x0(36) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(36) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(36) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(36) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(36) = "(disjoint_fsp)";
end
for i=1:height(TabellaConfrontiAIC)
    if TabellaConfrontiAIC.approximation(i) == "("+TabellaConfrontiAIC.model(i)+")"
        TabellaConfrontiAIC.approximation(i) = "";
    end
end
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