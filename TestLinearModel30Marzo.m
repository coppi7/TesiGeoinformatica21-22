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
[P_Apple,ANOVATAB_Apple,STATS_Apple] = anova1([MatriceApple.driving,MatriceApple.walking,MatriceApple.transit],{'driving','walking','transit'});
[c_Apple,u_Apple] = multcompare(STATS_Apple);
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

%% Linear Regression Apple_driving vs retail
f1=figure("Name","Apple Driving vs Google categories");
tbl1 = table(MatriceA.driving,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'driving','retail'});
lm1 = fitlm(tbl1,'linear');
figure(f1);
subplot(231)
plot(lm1);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs grocery and pharmacy
tbl2 = table(MatriceA.driving,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'driving','grocery and pharmacy'});
lm2 = fitlm(tbl2,'linear');
figure(f1);
subplot(232)
plot(lm2);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs parks
tbl3 = table(MatriceA.driving,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'driving','parks'});
lm3 = fitlm(tbl3,'linear');
figure(f1);
subplot(233)
plot(lm3);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs transit stations
tbl4 = table(MatriceA.driving,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'driving','transit stations'});
lm4 = fitlm(tbl4,'linear');
figure(f1);
subplot(234)
plot(lm4);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs workplaces
tbl5 = table(MatriceA.driving,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'driving','workplaces'});
lm5 = fitlm(tbl5,'linear');
figure(f1);
subplot(235)
plot(lm5);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs residential
tbl6 = table(MatriceA.driving,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'driving','residential'});
lm6 = fitlm(tbl6,'linear');
figure(f1);
subplot(236)
plot(lm6);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs retail
f2=figure("Name","Apple Walking vs Google categories");
tbl7 = table(MatriceA.walking,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'walking','retail'});
lm7 = fitlm(tbl7,'linear');
figure(f2);
subplot(231)
plot(lm7);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs grocery and pharmacy
tbl8 = table(MatriceA.walking,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'walking','grocery and pharmacy'});
lm8 = fitlm(tbl8,'linear');
figure(f2);
subplot(232)
plot(lm8);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs parks
tbl9 = table(MatriceA.walking,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'walking','parks'});
lm9 = fitlm(tbl9,'linear');
figure(f2);
subplot(233)
plot(lm9);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs transit stations
tbl10 = table(MatriceA.walking,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'walking','transit stations'});
lm10 = fitlm(tbl10,'linear');
figure(f2);
subplot(234)
plot(lm10);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs workplaces
tbl11 = table(MatriceA.walking,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'walking','workplaces'});
lm11 = fitlm(tbl11,'linear');
figure(f2);
subplot(235)
plot(lm11);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs residential
tbl12 = table(MatriceA.walking,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'walking','residential'});
lm12 = fitlm(tbl12,'linear');
figure(f2);
subplot(236)
plot(lm12);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs retail
f3=figure("Name","Apple Transit vs Google categories");
tbl13 = table(MatriceA.transit,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'transit','retail'});
lm13 = fitlm(tbl13,'linear');
figure(f3);
subplot(231)
plot(lm13);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs grocery and pharmacy
tbl14 = table(MatriceA.transit,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'transit','grocery and pharmacy'});
lm14 = fitlm(tbl14,'linear');
figure(f3);
subplot(232)
plot(lm14);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs parks
tbl15 = table(MatriceA.transit,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'transit','parks'});
lm15 = fitlm(tbl15,'linear');
figure(f3);
subplot(233)
plot(lm15);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs transit stations
tbl16 = table(MatriceA.transit,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'transit','transit stations'});
lm16 = fitlm(tbl16,'linear');
figure(f3);
subplot(234)
plot(lm16);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs workplaces
tbl17 = table(MatriceA.transit,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'transit','workplaces'});
lm17 = fitlm(tbl17,'linear');
figure(f3);
subplot(235)
plot(lm17);
set(gca,'FontSize',20);
%% Linear Regression Apple_transit vs residential
tbl18 = table(MatriceA.transit,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'transit','residential'});
lm18 = fitlm(tbl18,'linear');
figure(f3);
subplot(236)
plot(lm18);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs Apple_driving
f4 = figure("Name","Apple categories vs Apple categories");
tbl19 = table(MatriceA.walking,MatriceA.driving,'VariableNames',{'walking','driving'});
lm19 = fitlm(tbl19,'linear');
figure(f4);
subplot(221)
plot(lm19);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs Apple_transit
tbl20 = table(MatriceA.walking,MatriceA.transit,'VariableNames',{'walking','transit'});
lm20 = fitlm(tbl20,'linear');
figure(f4);
subplot(222)
plot(lm20);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs Apple_transit
tbl21 = table(MatriceA.driving,MatriceA.transit,'VariableNames',{'driving','transit'});
lm21 = fitlm(tbl21,'linear');
figure(f4);
subplot(223)
plot(lm21);
set(gca,'FontSize',20);
%% Linear Regression retail vs grocery
f5=figure("Name","Google categories vs Google categories");
tbl22 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'retail','grocery'});
lm22 = fitlm(tbl22,'linear');
figure(f5);
subplot(231)
plot(lm22);
set(gca,'FontSize',20);
%% Linear Regression retail vs parks
tbl23 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.parks_percent_change_from_baseline,'VariableNames',{'retail','parks'});
lm23 = fitlm(tbl23,'linear');
figure(f5);
subplot(232)
plot(lm23);
set(gca,'FontSize',20);
%% Linear Regression retail vs transit stations
tbl24 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'retail','transit stations'});
lm24 = fitlm(tbl24,'linear');
figure(f5);
subplot(233)
plot(lm24);
set(gca,'FontSize',20);
%% Linear Regression retail vs workplaces
tbl25 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'retail','workplaces'});
lm25 = fitlm(tbl25,'linear');
figure(f5);
subplot(234)
plot(lm25);
set(gca,'FontSize',20);
%% Linear Regression retail vs residential
tbl26 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.residential_percent_change_from_baseline,'VariableNames',{'retail','residential'});
lm26 = fitlm(tbl26,'linear');
figure(f5);
subplot(235)
plot(lm26);
set(gca,'FontSize',20);