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
%% Setting the parameter of the dates
startDate = datetime(cellstr(TabellaA.date(1)));
endDate = datetime(cellstr(TabellaA.date(height(TabellaA))));
date = (startDate:1:endDate);
date = datetime(date,"format","yyyy-MM-dd");
%% Setting the table used
TabellaBConfrontoGoogle = TabellaB;
for i=1:height(TabellaB)
    TabellaBConfrontoGoogle.driving(i)= TabellaBConfrontoGoogle.driving(i)-100;
    TabellaBConfrontoGoogle.walking(i)= TabellaBConfrontoGoogle.walking(i)-100;
end
TabellaGoogleApple = TabellaG;
TabellaTempConfrontoGoogle = TabellaBConfrontoGoogle(TabellaBConfrontoGoogle.date>=datetime("15-02-2020","Format","dd-MM-yyyy"),:);
    % Lombardia (3)
    
    TabellaLombardia = TabellaG(TabellaG.sub_region_1=="Lombardy",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)=="Lombardia"
            TabellaLombardia(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaLombardia.date(j)
                TabellaLombardia(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaLombardia(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaLombardia.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaLombardia.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaLombardia.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceLombardia(:,1:6) = TabellaLombardia(:,10:15);
    MatriceLombardia(:,7:8) = TabellaLombardia(:,17:18);
    MatriceLombardia.Properties.VariableNames(7)=TabellaLombardia.Properties.VariableNames(17);
    MatriceLombardia.Properties.VariableNames(8)=TabellaLombardia.Properties.VariableNames(18);
    ArrayLombardia1=table2array(MatriceLombardia);
    ArrayLombardia=rmmissing(ArrayLombardia1);
    % Veneto (5)
    
    TabellaVeneto = TabellaG(TabellaG.sub_region_1=="Veneto",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)=="Veneto"
            TabellaVeneto(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaVeneto.date(j)
                TabellaVeneto(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaVeneto(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaVeneto.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaVeneto.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaVeneto.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceVeneto(:,1:6) = TabellaVeneto(:,10:15);
    MatriceVeneto(:,7:8) = TabellaVeneto(:,17:18);
    MatriceVeneto.Properties.VariableNames(7)=TabellaVeneto.Properties.VariableNames(17);
    MatriceVeneto.Properties.VariableNames(8)=TabellaVeneto.Properties.VariableNames(18);
    ArrayVeneto1=table2array(MatriceVeneto);
    ArrayVeneto=rmmissing(ArrayVeneto1);
%% Preallocation of table to save parameters of interest
sz = [8 8];
VarTypes = ["string" "double" "double" "double" "double" "double" "string" "string"];
VarNamesConfronti = ["Comparison" "a" "b" "c" "d" "x0" "model" "approximation"];
VarCategoriesConfronti = ["walking Lombardy vs walking Veneto" "driving Lombardy vs driving Veneto" "retail Lombardy vs retail Veneto"...
    "grocery Lombardy vs grocery Veneto" "parks Lombardy vs parks Veneto" "TransitStations Lombardy vs TransitStations Veneto"...
    "workplaces Lombardy vs workplaces Veneto" "residential Lombardy vs residential Veneto"];
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
%% Apple Walking vs Apple Walking
f1=figure("Name","AppleWalking: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,8) ArrayVeneto(:,8)];
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
scatter(ArrayLombardia(:,8),ArrayVeneto(:,8),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,8)) max(ArrayLombardia(:,8))],linear(pars_linear,[min(ArrayLombardia(:,8)) max(ArrayLombardia(:,8))]),'Color',col,'LineWidth',2)
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

figure(f1)
subplot(232)
scatter(ArrayLombardia(:,8),ArrayVeneto(:,8),'filled')
hold on
plot([min(ArrayLombardia(:,8)) x0 max(ArrayLombardia(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,8)) x0 max(ArrayLombardia(:,8))],x0),'Color',col,'LineWidth',2)
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

figure(f1)
subplot(233)
scatter(ArrayLombardia(:,8),ArrayVeneto(:,8),'filled')
hold on
plot([min(ArrayLombardia(:,8)) pars_piecewise(4) max(ArrayLombardia(:,8))],piecewise(pars_piecewise,[min(ArrayLombardia(:,8)) pars_piecewise(4) max(ArrayLombardia(:,8))]),'Color',col,'LineWidth',2)
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

figure(f1)
subplot(234)
scatter(ArrayLombardia(:,8),ArrayVeneto(:,8),'filled')
hold on
plot([min(ArrayLombardia(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,8))],x0),'Color',col,'LineWidth',2)
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

figure(f1)
subplot(235)
scatter(ArrayLombardia(:,8),ArrayVeneto(:,8),'filled')
hold on
plot([min(ArrayLombardia(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,8))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,8))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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

figure(f1)
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
%% Apple driving vs Apple driving
f2=figure("Name","AppleDriving: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,7) ArrayVeneto(:,7)];
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
scatter(ArrayLombardia(:,7),ArrayVeneto(:,7),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,7)) max(ArrayLombardia(:,7))],linear(pars_linear,[min(ArrayLombardia(:,7)) max(ArrayLombardia(:,7))]),'Color',col,'LineWidth',2)
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

figure(f2)
subplot(232)
scatter(ArrayLombardia(:,7),ArrayVeneto(:,7),'filled')
hold on
plot([min(ArrayLombardia(:,7)) x0 max(ArrayLombardia(:,7))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,7)) x0 max(ArrayLombardia(:,7))],x0),'Color',col,'LineWidth',2)
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

figure(f2)
subplot(233)
scatter(ArrayLombardia(:,7),ArrayVeneto(:,7),'filled')
hold on
plot([min(ArrayLombardia(:,7)) pars_piecewise(4) max(ArrayLombardia(:,7))],piecewise(pars_piecewise,[min(ArrayLombardia(:,7)) pars_piecewise(4) max(ArrayLombardia(:,7))]),'Color',col,'LineWidth',2)
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

figure(f2)
subplot(234)
scatter(ArrayLombardia(:,7),ArrayVeneto(:,7),'filled')
hold on
plot([min(ArrayLombardia(:,7)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,7)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,7));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,7))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,7))],x0),'Color',col,'LineWidth',2)
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

figure(f2)
subplot(235)
scatter(ArrayLombardia(:,7),ArrayVeneto(:,7),'filled')
hold on
plot([min(ArrayLombardia(:,7)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,7)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,7))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,7))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(2) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(2) = "piecewise";
    TabellaConfrontiAIC.a(2) = pars_piecewise(1);
    TabellaConfrontiAIC.b(2) = pars_piecewise(2);
    TabellaConfrontiAIC.d(2) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(2) = pars_piecewise(4);
    TabellaConfrontiAIC.c(2) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f2)
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
%% Google retail vs Google Retail
f3=figure("Name","Google Retail: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,1) ArrayVeneto(:,1)];
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
scatter(ArrayLombardia(:,1),ArrayVeneto(:,1),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,1)) max(ArrayLombardia(:,1))],linear(pars_linear,[min(ArrayLombardia(:,1)) max(ArrayLombardia(:,1))]),'Color',col,'LineWidth',2)
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

figure(f3)
subplot(232)
scatter(ArrayLombardia(:,1),ArrayVeneto(:,1),'filled')
hold on
plot([min(ArrayLombardia(:,1)) x0 max(ArrayLombardia(:,1))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,1)) x0 max(ArrayLombardia(:,1))],x0),'Color',col,'LineWidth',2)
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

figure(f3)
subplot(233)
scatter(ArrayLombardia(:,1),ArrayVeneto(:,1),'filled')
hold on
plot([min(ArrayLombardia(:,1)) pars_piecewise(4) max(ArrayLombardia(:,1))],piecewise(pars_piecewise,[min(ArrayLombardia(:,1)) pars_piecewise(4) max(ArrayLombardia(:,1))]),'Color',col,'LineWidth',2)
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

figure(f3)
subplot(234)
scatter(ArrayLombardia(:,1),ArrayVeneto(:,1),'filled')
hold on
plot([min(ArrayLombardia(:,1)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,1)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,1));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,1))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,1))],x0),'Color',col,'LineWidth',2)
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

figure(f3)
subplot(235)
scatter(ArrayLombardia(:,1),ArrayVeneto(:,1),'filled')
hold on
plot([min(ArrayLombardia(:,1)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,1)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,1))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,1))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(3) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(3) = "piecewise";
    TabellaConfrontiAIC.a(3) = pars_piecewise(1);
    TabellaConfrontiAIC.b(3) = pars_piecewise(2);
    TabellaConfrontiAIC.d(3) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(3) = pars_piecewise(4);
    TabellaConfrontiAIC.c(3) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f3)
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
%% Google grocery vs Google grocery
f4=figure("Name","Google grocery: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,2) ArrayVeneto(:,2)];
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
scatter(ArrayLombardia(:,2),ArrayVeneto(:,2),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,2)) max(ArrayLombardia(:,2))],linear(pars_linear,[min(ArrayLombardia(:,2)) max(ArrayLombardia(:,2))]),'Color',col,'LineWidth',2)
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

figure(f4)
subplot(232)
scatter(ArrayLombardia(:,2),ArrayVeneto(:,2),'filled')
hold on
plot([min(ArrayLombardia(:,2)) x0 max(ArrayLombardia(:,2))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,2)) x0 max(ArrayLombardia(:,2))],x0),'Color',col,'LineWidth',2)
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

figure(f4)
subplot(233)
scatter(ArrayLombardia(:,2),ArrayVeneto(:,2),'filled')
hold on
plot([min(ArrayLombardia(:,2)) pars_piecewise(4) max(ArrayLombardia(:,2))],piecewise(pars_piecewise,[min(ArrayLombardia(:,2)) pars_piecewise(4) max(ArrayLombardia(:,2))]),'Color',col,'LineWidth',2)
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

figure(f4)
subplot(234)
scatter(ArrayLombardia(:,2),ArrayVeneto(:,2),'filled')
hold on
plot([min(ArrayLombardia(:,2)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,2)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,2));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,2))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,2))],x0),'Color',col,'LineWidth',2)
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

figure(f4)
subplot(235)
scatter(ArrayLombardia(:,2),ArrayVeneto(:,2),'filled')
hold on
plot([min(ArrayLombardia(:,2)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,2)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,2))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,2))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(4) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(4) = "piecewise";
    TabellaConfrontiAIC.a(4) = pars_piecewise(1);
    TabellaConfrontiAIC.b(4) = pars_piecewise(2);
    TabellaConfrontiAIC.d(4) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(4) = pars_piecewise(4);
    TabellaConfrontiAIC.c(4) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f4)
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
%% Google parks vs Google parks
f5=figure("Name","Google parks: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,3) ArrayVeneto(:,3)];
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
scatter(ArrayLombardia(:,3),ArrayVeneto(:,3),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,3)) max(ArrayLombardia(:,3))],linear(pars_linear,[min(ArrayLombardia(:,3)) max(ArrayLombardia(:,3))]),'Color',col,'LineWidth',2)
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

figure(f5)
subplot(232)
scatter(ArrayLombardia(:,3),ArrayVeneto(:,3),'filled')
hold on
plot([min(ArrayLombardia(:,3)) x0 max(ArrayLombardia(:,3))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,3)) x0 max(ArrayLombardia(:,3))],x0),'Color',col,'LineWidth',2)
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

figure(f5)
subplot(233)
scatter(ArrayLombardia(:,3),ArrayVeneto(:,3),'filled')
hold on
plot([min(ArrayLombardia(:,3)) pars_piecewise(4) max(ArrayLombardia(:,3))],piecewise(pars_piecewise,[min(ArrayLombardia(:,3)) pars_piecewise(4) max(ArrayLombardia(:,3))]),'Color',col,'LineWidth',2)
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

figure(f5)
subplot(234)
scatter(ArrayLombardia(:,3),ArrayVeneto(:,3),'filled')
hold on
plot([min(ArrayLombardia(:,3)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,3)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,3));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,3))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,3))],x0),'Color',col,'LineWidth',2)
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

figure(f5)
subplot(235)
scatter(ArrayLombardia(:,3),ArrayVeneto(:,3),'filled')
hold on
plot([min(ArrayLombardia(:,3)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,3)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,3))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,3))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(5) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(5) = "piecewise";
    TabellaConfrontiAIC.a(5) = pars_piecewise(1);
    TabellaConfrontiAIC.b(5) = pars_piecewise(2);
    TabellaConfrontiAIC.d(5) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(5) = pars_piecewise(4);
    TabellaConfrontiAIC.c(5) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f5)
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
%% Google TransitStations vs Google TransitStations
f6=figure("Name","Google TransitStations: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,4) ArrayVeneto(:,4)];
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
scatter(ArrayLombardia(:,4),ArrayVeneto(:,4),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,4)) max(ArrayLombardia(:,4))],linear(pars_linear,[min(ArrayLombardia(:,4)) max(ArrayLombardia(:,4))]),'Color',col,'LineWidth',2)
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

figure(f6)
subplot(232)
scatter(ArrayLombardia(:,4),ArrayVeneto(:,4),'filled')
hold on
plot([min(ArrayLombardia(:,4)) x0 max(ArrayLombardia(:,4))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,4)) x0 max(ArrayLombardia(:,4))],x0),'Color',col,'LineWidth',2)
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

figure(f6)
subplot(233)
scatter(ArrayLombardia(:,4),ArrayVeneto(:,4),'filled')
hold on
plot([min(ArrayLombardia(:,4)) pars_piecewise(4) max(ArrayLombardia(:,4))],piecewise(pars_piecewise,[min(ArrayLombardia(:,4)) pars_piecewise(4) max(ArrayLombardia(:,4))]),'Color',col,'LineWidth',2)
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

figure(f6)
subplot(234)
scatter(ArrayLombardia(:,4),ArrayVeneto(:,4),'filled')
hold on
plot([min(ArrayLombardia(:,4)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,4)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,4));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,4))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,4))],x0),'Color',col,'LineWidth',2)
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

figure(f6)
subplot(235)
scatter(ArrayLombardia(:,4),ArrayVeneto(:,4),'filled')
hold on
plot([min(ArrayLombardia(:,4)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,4)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,4))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,4))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(6) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(6) = "piecewise";
    TabellaConfrontiAIC.a(6) = pars_piecewise(1);
    TabellaConfrontiAIC.b(6) = pars_piecewise(2);
    TabellaConfrontiAIC.d(6) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(6) = pars_piecewise(4);
    TabellaConfrontiAIC.c(6) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f6)
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
%% Google workplaces vs Google workplaces
f7=figure("Name","Google workplaces: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,5) ArrayVeneto(:,5)];
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
scatter(ArrayLombardia(:,5),ArrayVeneto(:,5),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,5)) max(ArrayLombardia(:,5))],linear(pars_linear,[min(ArrayLombardia(:,5)) max(ArrayLombardia(:,5))]),'Color',col,'LineWidth',2)
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

figure(f7)
subplot(232)
scatter(ArrayLombardia(:,5),ArrayVeneto(:,5),'filled')
hold on
plot([min(ArrayLombardia(:,5)) x0 max(ArrayLombardia(:,5))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,5)) x0 max(ArrayLombardia(:,5))],x0),'Color',col,'LineWidth',2)
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

figure(f7)
subplot(233)
scatter(ArrayLombardia(:,5),ArrayVeneto(:,5),'filled')
hold on
plot([min(ArrayLombardia(:,5)) pars_piecewise(4) max(ArrayLombardia(:,5))],piecewise(pars_piecewise,[min(ArrayLombardia(:,5)) pars_piecewise(4) max(ArrayLombardia(:,5))]),'Color',col,'LineWidth',2)
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

figure(f7)
subplot(234)
scatter(ArrayLombardia(:,5),ArrayVeneto(:,5),'filled')
hold on
plot([min(ArrayLombardia(:,5)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,5)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,5));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,5))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,5))],x0),'Color',col,'LineWidth',2)
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

figure(f7)
subplot(235)
scatter(ArrayLombardia(:,5),ArrayVeneto(:,5),'filled')
hold on
plot([min(ArrayLombardia(:,5)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,5)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,5))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,5))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(7) = "linear";
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
    TabellaConfrontiAIC.c(7) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(7) = "piecewise";
    TabellaConfrontiAIC.a(7) = pars_piecewise(1);
    TabellaConfrontiAIC.b(7) = pars_piecewise(2);
    TabellaConfrontiAIC.d(7) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(7) = pars_piecewise(4);
    TabellaConfrontiAIC.c(7) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f7)
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
%% Google residential vs Google residential
f8=figure("Name","Google residential: Lombardy vs Veneto");
% `true' parameters
a=0;
b=1;
d=1;
x0=0;
c=a+(b-d)*x0;

data = [ArrayLombardia(:,6) ArrayVeneto(:,6)];
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
scatter(ArrayLombardia(:,6),ArrayVeneto(:,6),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayLombardia(:,6)) max(ArrayLombardia(:,6))],linear(pars_linear,[min(ArrayLombardia(:,6)) max(ArrayLombardia(:,6))]),'Color',col,'LineWidth',2)
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

figure(f8)
subplot(232)
scatter(ArrayLombardia(:,6),ArrayVeneto(:,6),'filled')
hold on
plot([min(ArrayLombardia(:,6)) x0 max(ArrayLombardia(:,6))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayLombardia(:,6)) x0 max(ArrayLombardia(:,6))],x0),'Color',col,'LineWidth',2)
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

figure(f8)
subplot(233)
scatter(ArrayLombardia(:,6),ArrayVeneto(:,6),'filled')
hold on
plot([min(ArrayLombardia(:,6)) pars_piecewise(4) max(ArrayLombardia(:,6))],piecewise(pars_piecewise,[min(ArrayLombardia(:,6)) pars_piecewise(4) max(ArrayLombardia(:,6))]),'Color',col,'LineWidth',2)
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

figure(f8)
subplot(234)
scatter(ArrayLombardia(:,6),ArrayVeneto(:,6),'filled')
hold on
plot([min(ArrayLombardia(:,6)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayLombardia(:,6)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayLombardia(:,6));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayLombardia(:,6))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayLombardia(:,6))],x0),'Color',col,'LineWidth',2)
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

figure(f8)
subplot(235)
scatter(ArrayLombardia(:,6),ArrayVeneto(:,6),'filled')
hold on
plot([min(ArrayLombardia(:,6)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayLombardia(:,6)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayLombardia(:,6))],disjoint(pars_disjoint,[x1 max(ArrayLombardia(:,6))]),'Color',col,'LineWidth',2)
set(gca,'FontSize',20);
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
    TabellaConfrontiAIC.c(8) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(8) = "piecewise";
    TabellaConfrontiAIC.a(8) = pars_piecewise(1);
    TabellaConfrontiAIC.b(8) = pars_piecewise(2);
    TabellaConfrontiAIC.d(8) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(8) = pars_piecewise(4);
    TabellaConfrontiAIC.c(8) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
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

figure(f8)
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