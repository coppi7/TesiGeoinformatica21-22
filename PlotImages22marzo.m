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
TabellaStringency = readtable("./DatabaseLocale/StringencyIndex/StringencyItaly.csv");
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
%% National data
f1 = figure('Name',"National Google's categories data");
figure(f1)
plot(TabellaF.date,MatriceA.retail_and_recreation_percent_change_from_baseline)
hold on;
plot(TabellaF.date,MatriceA.grocery_and_pharmacy_percent_change_from_baseline)
hold on;    
plot(TabellaF.date,MatriceA.parks_percent_change_from_baseline)
hold on;
plot(TabellaF.date,MatriceA.transit_stations_percent_change_from_baseline)
hold on;
plot(TabellaF.date,MatriceA.workplaces_percent_change_from_baseline)
hold on;
plot(TabellaF.date,MatriceA.residential_percent_change_from_baseline)
ylabel('Percentage of mobility','FontSize', 20);
legend('retail and recreation', 'grocery and pharmacy','parks','transit stations','workplaces','residential','FontSize', 20)
set(gca,'FontSize', 20)
%% Lockdown period (2020)
TabellaTemp = TabellaGoogleApple(TabellaGoogleApple.date>="2020-03-08",:);
TabellaTemp1 = TabellaTemp(TabellaTemp.date<="2020-05-08",:);
clear TabellaTemp;
TabellaTemp = TabellaTemp1;
clear TabellaTemp1;
cmap = hsv(9);
figure()
plot(TabellaTemp.date,TabellaTemp.retail_and_recreation_percent_change_from_baseline,"Color",cmap(1,1:3),"LineWidth",1)
hold on;
plot(TabellaTemp.date,TabellaTemp.grocery_and_pharmacy_percent_change_from_baseline,"Color",cmap(2,1:3),"LineWidth",1)
hold on;    
plot(TabellaTemp.date,TabellaTemp.parks_percent_change_from_baseline,"Color",cmap(3,1:3),"LineWidth",1)
hold on;
plot(TabellaTemp.date,TabellaTemp.transit_stations_percent_change_from_baseline,"Color",cmap(4,1:3),"LineWidth",1)
hold on;
plot(TabellaTemp.date,TabellaTemp.workplaces_percent_change_from_baseline,"Color",cmap(5,1:3),"LineWidth",1)
hold on;
plot(TabellaTemp.date,TabellaTemp.residential_percent_change_from_baseline,"Color",cmap(6,1:3),"LineWidth",1)
hold on;
plot(TabellaTemp.date,TabellaTemp.driving,"Color",cmap(7,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp.date,TabellaTemp.walking,"Color",cmap(8,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp.date,TabellaTemp.transit,"Color",cmap(9,1:3),"LineWidth",2);
legend('retail and recreation', 'grocery and pharmacy','parks','transit stations','workplaces','residential','driving', 'walking','transit','FontSize', 20)

ylabel('Percentage of mobility','FontSize', 20);
set(gca,'FontSize', 20)
MediaLockdown = [mean(TabellaTemp.retail_and_recreation_percent_change_from_baseline) mean(TabellaTemp.grocery_and_pharmacy_percent_change_from_baseline) mean(TabellaTemp.parks_percent_change_from_baseline) mean(TabellaTemp.transit_stations_percent_change_from_baseline) mean(TabellaTemp.workplaces_percent_change_from_baseline) mean(TabellaTemp.residential_percent_change_from_baseline) mean(TabellaTemp.driving) mean(TabellaTemp.walking) mean(TabellaTemp.transit)];
MediaLockdown = array2table(MediaLockdown);
MediaLockdown.Properties.VariableNames(1:9)=TabellaTemp.Properties.VariableNames(10:18);
writetable(MediaLockdown,"./DatabaseLocale/TabelleStatisticheGrafici/MediaLockdown.csv");
%% Clear temporary variables
clear TabellaTemp;
%% Comparison Estate2020 vs Estate2021
TabellaTemp2020 = TabellaGoogleApple(TabellaGoogleApple.date>="2020-06-01",:);
TabellaTemp1 = TabellaTemp2020(TabellaTemp2020.date<="2020-09-01",:);
clear TabellaTemp2020;
TabellaTemp2020 = TabellaTemp1;
clear TabellaTemp1;
TabellaTemp2021 = TabellaGoogleApple(TabellaGoogleApple.date>="2021-05-31",:);
TabellaTemp1 = TabellaTemp2021(TabellaTemp2021.date<="2021-08-31",:);
clear TabellaTemp2021;
TabellaTemp2021 = TabellaTemp1;
clear TabellaTemp1;
cmap = hsv(3);
f1 = figure("Name", "Apple Summer");
figure(f1)
subplot(211)
plot(TabellaTemp2020.date,TabellaTemp2020.driving,"Color",cmap(1,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.walking,"Color",cmap(2,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.transit,"Color",cmap(3,1:3),"LineWidth",2);
%hold on;
ylabel('Percentage of mobility','FontSize', 20);
set(gca,'FontSize', 20)
subplot(212)
plot(TabellaTemp2020.date,TabellaTemp2021.driving,"Color",cmap(1,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.walking,"Color",cmap(2,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.transit,"Color",cmap(3,1:3),"LineWidth",0.7);
%legend('driving2020','walking2020','transit2020','driving2021','walking2021','transit2021','Location','north','FontSize',20);
legend ('driving','walking','transit')
ylabel('Percentage of mobility','FontSize', 20);
set(gca,'FontSize', 20)
MediaAppleEstate2020 = [mean(TabellaTemp2020.driving); mean(TabellaTemp2020.walking); mean(TabellaTemp2020.transit)];
MediaAppleEstate2020 = array2table(MediaAppleEstate2020);
MediaEstate(:,1) = ["Driving"; "Walking"; "Transit"];
MediaEstate = array2table(MediaEstate);
MediaEstate(:,2) = MediaAppleEstate2020;
MediaAppleEstate2021 = [mean(TabellaTemp2021.driving); mean(TabellaTemp2021.walking); mean(TabellaTemp2021.transit)];
MediaAppleEstate2021 = array2table(MediaAppleEstate2021);
MediaEstate(:,3) = MediaAppleEstate2021;
MediaEstate.Properties.VariableNames(1:3) = ["Categories" "2020" "2021"];
writetable(MediaEstate,"./DatabaseLocale/TabelleStatisticheGrafici/MediaEstate.csv");
%% Clear temporary variables
clear TabellaTemp2020; clear TabellaTemp2021;
%% Google data Estate 2020 vs Estate 2021
TabellaTemp2020 = TabellaGoogleApple(TabellaGoogleApple.date>="2020-06-01",:);
TabellaTemp1 = TabellaTemp2020(TabellaTemp2020.date<="2020-09-01",:);
clear TabellaTemp2020;
TabellaTemp2020 = TabellaTemp1;
clear TabellaTemp1;
TabellaTemp2021 = TabellaGoogleApple(TabellaGoogleApple.date>="2021-05-31",:);
TabellaTemp1 = TabellaTemp2021(TabellaTemp2021.date<="2021-08-31",:);
clear TabellaTemp2021;
TabellaTemp2021 = TabellaTemp1;
clear TabellaTemp1;
cmap = hsv(6);
f2 = figure("Name", "Google Summer");
figure(f2)
subplot(211)
plot(TabellaTemp2020.date,TabellaTemp2020.retail_and_recreation_percent_change_from_baseline,"Color",cmap(1,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.grocery_and_pharmacy_percent_change_from_baseline,"Color",cmap(2,1:3),"LineWidth",2)
hold on;    
plot(TabellaTemp2020.date,TabellaTemp2020.parks_percent_change_from_baseline,"Color",cmap(3,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.transit_stations_percent_change_from_baseline,"Color",cmap(4,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.workplaces_percent_change_from_baseline,"Color",cmap(5,1:3),"LineWidth",2)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2020.residential_percent_change_from_baseline,"Color",cmap(6,1:3),"LineWidth",2)
%hold on;
ylabel('Percentage of mobility','FontSize', 20);
set(gca,'FontSize', 20)
subplot(212)
plot(TabellaTemp2020.date,TabellaTemp2021.retail_and_recreation_percent_change_from_baseline,"Color",cmap(1,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.grocery_and_pharmacy_percent_change_from_baseline,"Color",cmap(2,1:3),"LineWidth",0.7)
hold on;    
plot(TabellaTemp2020.date,TabellaTemp2021.parks_percent_change_from_baseline,"Color",cmap(3,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.transit_stations_percent_change_from_baseline,"Color",cmap(4,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.workplaces_percent_change_from_baseline,"Color",cmap(5,1:3),"LineWidth",0.7)
hold on;
plot(TabellaTemp2020.date,TabellaTemp2021.residential_percent_change_from_baseline,"Color",cmap(6,1:3),"LineWidth",0.7)
%legend('retail and recreation 2020', 'grocery and pharmacy 2020','parks 2020','transit stations 2020','workplaces 2020','residential 2020','retail and recreation 2021', 'grocery and pharmacy 2021','parks 2021','transit stations 2021','workplaces 2021','residential 2021','Location','north');
legend('retail and recreation', 'grocery and pharmacy', 'parks', 'workplaces', 'residential')
ylabel('Percentage of mobility','FontSize', 20);
set(gca,'FontSize', 20)
MediaGoogleEstate2020 = [mean(TabellaTemp2020.retail_and_recreation_percent_change_from_baseline); mean(TabellaTemp2020.grocery_and_pharmacy_percent_change_from_baseline); mean(TabellaTemp2020.parks_percent_change_from_baseline); mean(TabellaTemp2020.transit_stations_percent_change_from_baseline); mean(TabellaTemp2020.workplaces_percent_change_from_baseline); mean(TabellaTemp2020.residential_percent_change_from_baseline)];
MediaGoogleEstate2020 = array2table(MediaGoogleEstate2020);
MediaGoogleEstate2021 = [mean(TabellaTemp2021.retail_and_recreation_percent_change_from_baseline); mean(TabellaTemp2021.grocery_and_pharmacy_percent_change_from_baseline); mean(TabellaTemp2021.parks_percent_change_from_baseline); mean(TabellaTemp2021.transit_stations_percent_change_from_baseline); mean(TabellaTemp2021.workplaces_percent_change_from_baseline); mean(TabellaTemp2021.residential_percent_change_from_baseline)];
MediaGoogleEstate2021 = array2table(MediaGoogleEstate2021);
MediaGoogleEstate(:,1) = ["retail and recreation"; "grocery and pharmacy"; "parks"; "transit stations"; "workplaces"; "residential"];
MediaGoogleEstate = array2table(MediaGoogleEstate);
MediaGoogleEstate(:,2) = MediaGoogleEstate2020;
MediaGoogleEstate(:,3) = MediaGoogleEstate2021;
MediaGoogleEstate.Properties.VariableNames(1:3) = ["Categories" "2020" "2021"];
writetable(MediaGoogleEstate,"./DatabaseLocale/TabelleStatisticheGrafici/MediaGoogleEstate.csv");
%% Plotting stringency index
TabellaStringencyTemp2020 = TabellaStringency(TabellaStringency.Day>="2020-06-01",:);
TabellaStringencyTemp1 = TabellaStringencyTemp2020(TabellaStringencyTemp2020.Day<="2020-09-01",:);
clear TabellaStringencyTemp2020;
TabellaStringencyTemp2020 = TabellaStringencyTemp1;
clear TabellaStringencyTemp1;
TabellaStringencyTemp2021 = TabellaStringency(TabellaStringency.Day>="2021-05-31",:);
TabellaStringencyTemp1 = TabellaStringencyTemp2021(TabellaStringencyTemp2021.Day<="2021-08-31",:);
clear TabellaStringencyTemp2021;
TabellaStringencyTemp2021 = TabellaStringencyTemp1;
clear TabellaStringencyTemp1;
figure()
plot(TabellaStringencyTemp2020.Day,TabellaStringencyTemp2020.stringency_index,"Color",cmap(1,1:3),"LineWidth",2)
hold on;
plot(TabellaStringencyTemp2020.Day,TabellaStringencyTemp2021.stringency_index,"Color",cmap(2,1:3),"LineWidth",2)
legend('Stringency2020','Stringency2021','Location','north');

ylabel('Percentage of Stringency');
% legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
