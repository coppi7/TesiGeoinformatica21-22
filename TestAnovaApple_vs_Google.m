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
%% Test ANOVA Apple
MatriceApple = TabellaA(:,7:9);
ArrayApple1=table2array(MatriceApple);
ArrayApple=rmmissing(ArrayApple1);
for i=1:3
    mediaApple(:,i)=mean(ArrayApple(:,i))*ones(length(ArrayApple),1);
end
appoggioApple=ArrayApple-mediaApple;
resApple=[];
for i=1:3 
    resApple=[resApple;appoggioApple(:,i)]; 
end
figure();
normplot(resApple);
set(gca,'FontSize',20);
figure()
[P_Apple,ANOVATAB_Apple,STATS_Apple] = anova1([MatriceApple.driving,MatriceApple.walking,MatriceApple.transit],{'driving','walking','transit'});
set(gca,'FontSize',20);
figure()
[c_Apple,u_Apple] = multcompare(STATS_Apple);
set(gca,'FontSize',20);
IpotesiZeroApple = kstest(resApple/sqrt(ANOVATAB_Apple{3,4}));
if IpotesiZeroApple==0
    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
else
    fprintf("Si rifiuta l'ipotesi nulla! \n");
end

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
%% Test ANOVA tabella composta Google-Apple
for i=1:9
    media(:,i)=mean(ArrayA(:,i))*ones(length(ArrayA),1);
end
appoggio=ArrayA-media;
res=[];
for i=1:9 
    res=[res;appoggio(:,i)]; 
end
figure();
normplot(res);
set(gca,'FontSize',20);
[P,ANOVATAB,STATS] = anova1([MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.grocery_and_pharmacy_percent_change_from_baseline, MatriceA.parks_percent_change_from_baseline,MatriceA.transit_stations_percent_change_from_baseline,MatriceA.workplaces_percent_change_from_baseline,MatriceA.residential_percent_change_from_baseline,MatriceA.driving,MatriceA.walking,MatriceA.transit],{'retail and recreation percent change from baseline','grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','driving','walking','transit'});
[c,u] = multcompare(STATS); % Criterio Tukey
IpotesiZero = kstest(res/sqrt(ANOVATAB{3,4})); % Kolmogorov-Smirnov
if IpotesiZero==0
    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
else
    fprintf("Si rifiuta l'ipotesi nulla! \n");
end
%% Linear Regression Apple_driving vs retail
tbl1 = table(MatriceA.driving,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'driving','retail'});
lm1 = fitlm(tbl1,'linear');
figure();
plot(lm1);
%% Linear Regression Apple_driving vs grocery and pharmacy
tbl2 = table(MatriceA.driving,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'driving','grocery and pharmacy'});
lm2 = fitlm(tbl2,'linear');
figure();
plot(lm2);
%% Linear Regression Apple_driving vs parks
tbl3 = table(MatriceA.driving,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'driving','parks'});
lm3 = fitlm(tbl3,'linear');
figure();
plot(lm3);
%% Linear Regression Apple_driving vs transit stations
tbl4 = table(MatriceA.walking,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'driving','transit stations'});
lm4 = fitlm(tbl4,'linear');
figure();
plot(lm4);
%% Linear Regression Apple_driving vs workplaces
tbl5 = table(MatriceA.walking,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'driving','workplaces'});
lm5 = fitlm(tbl5,'linear');
figure();
plot(lm5);
%% Linear Regression Apple_walking vs residential
tbl6 = table(MatriceA.walking,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'driving','residential'});
lm6 = fitlm(tbl6,'linear');
figure();
plot(lm6);
%% Linear Regression Apple_walking vs retail
tbl7 = table(MatriceA.walking,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'walking','retail'});
lm7 = fitlm(tbl7,'linear');
figure();
plot(lm7);
%% Linear Regression Apple_walking vs grocery and pharmacy
tbl8 = table(MatriceA.walking,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'walking','grocery and pharmacy'});
lm8 = fitlm(tbl8,'linear');
figure();
plot(lm8);
%% Linear Regression Apple_walking vs parks
tbl9 = table(MatriceA.walking,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'walking','parks'});
lm9 = fitlm(tbl9,'linear');
figure();
plot(lm9);
%% Linear Regression Apple_walking vs transit stations
tbl10 = table(MatriceA.walking,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'walking','transit stations'});
lm10 = fitlm(tbl10,'linear');
figure();
plot(lm10);
%% Linear Regression Apple_walking vs workplaces
tbl11 = table(MatriceA.walking,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'walking','workplaces'});
lm11 = fitlm(tbl11,'linear');
figure();
plot(lm11);
%% Linear Regression Apple_walking vs residential
tbl12 = table(MatriceA.walking,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'walking','residential'});
lm12 = fitlm(tbl12,'linear');
figure();
plot(lm12);
%% Test ANOVA Apple serie temporali
    listaAnno = ["2020" "2021"];
    [indx0,tf0] = listdlg('PromptString','Select the year on which to do ANOVA test', 'ListString', listaAnno, "SelectionMode", "single");
    risposta0 = string(listaAnno(indx0));
    risposta0 = cellstr(risposta0);
    if risposta0=="2020"
        listaPeriodo = ["Winter" "Spring" "Summer" "Autumn"];
        [indx1,tf1] = listdlg('PromptString','Select the period you want to do ANOVA test', 'ListString', listaPeriodo, "SelectionMode", "single");
        risposta1 = string(listaPeriodo(indx1));
        risposta1 = cellstr(risposta1);
        if risposta1=="Spring"
                MatriceApplePeriodo = TabellaA(49:140,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Winter"
                MatriceApplePeriodo = TabellaA(1:48,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Summer"
                MatriceApplePeriodo = TabellaA(141:232,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Autumn"
                MatriceApplePeriodo = TabellaA(233:323,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        end
    elseif risposta0=="2021"
        listaPeriodo = ["Winter" "Spring" "Summer" "Autumn"];
        [indx1,tf1] = listdlg('PromptString','Select the period you want to do ANOVA test', 'ListString', listaPeriodo, "SelectionMode", "single");
        risposta1 = string(listaPeriodo(indx1));
        risposta1 = cellstr(risposta1);
        if risposta1=="Spring"
                MatriceApplePeriodo = TabellaA(414:505,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Winter"
                MatriceApplePeriodo = TabellaA(324:413,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Summer"
                MatriceApplePeriodo = TabellaA(506:597,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Autumn"
                MatriceApplePeriodo = TabellaA(598:688,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                set(gca,'FontSize',20);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo);
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        end
    end
    %%
for i=1:6
   mediaGoogle(:,i)=mean(ArrayA(:,i))*ones(length(ArrayA),1);
end
appoggioGoogle=ArrayA(:,1:6)-mediaGoogle(:,1:6);
resGoogle=[];
for i=1:6 
   resGoogle=[resGoogle;appoggioGoogle(:,i)]; 
end
figure();
normplot(resGoogle);
set(gca,'FontSize',20);
figure()
[P_Google,ANOVATAB_Google,STATS_Google] = anova1([MatriceA.retail_and_recreation_percent_change_from_baseline,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,MatriceA.parks_percent_change_from_baseline, MatriceA.transit_stations_percent_change_from_baseline,MatriceA.workplaces_percent_change_from_baseline,MatriceA.residential_percent_change_from_baseline],{'retail','grocery','parks','transit stations','workplaces','residential'});
figure()
[c_Google,u_Google] = multcompare(STATS_Google);
