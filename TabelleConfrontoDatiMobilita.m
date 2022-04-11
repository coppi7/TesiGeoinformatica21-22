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

j=0;
k=0;
for i=1:height(TabellaG)
    if(TabellaG.sub_region_1(i)=="Lombardy")
        j=j+1;
        TabellaLombardia(j,:) = TabellaG(i,:);
    end
    if(TabellaG.sub_region_1(i)=="Lazio")
        k=k+1;
        TabellaLazio(k,:) = TabellaG(i,:);
    end
end
figure()
plot(TabellaLombardia.date,TabellaLombardia.retail_and_recreation_percent_change_from_baseline,'c');
hold on;
plot(TabellaLombardia.date,TabellaLombardia.grocery_and_pharmacy_percent_change_from_baseline,'y');
hold on;
plot(TabellaLombardia.date,TabellaLombardia.parks_percent_change_from_baseline,'r');
hold on;
plot(TabellaLombardia.date,TabellaLombardia.transit_stations_percent_change_from_baseline,'g');
hold on;
plot(TabellaLombardia.date,TabellaLombardia.workplaces_percent_change_from_baseline,'b');
hold on;
plot(TabellaLombardia.date,TabellaLombardia.residential_percent_change_from_baseline,'k');

figure()
plot(TabellaLazio.date,TabellaLazio.retail_and_recreation_percent_change_from_baseline,'c');
hold on;
plot(TabellaLazio.date,TabellaLazio.grocery_and_pharmacy_percent_change_from_baseline,'y');
hold on;
plot(TabellaLazio.date,TabellaLazio.parks_percent_change_from_baseline,'r');
hold on;
plot(TabellaLazio.date,TabellaLazio.transit_stations_percent_change_from_baseline,'g');
hold on;
plot(TabellaLazio.date,TabellaLazio.workplaces_percent_change_from_baseline,'b');
hold on;
plot(TabellaLazio.date,TabellaLazio.residential_percent_change_from_baseline,'k');

for k=1:length(dateGoogle):length(TabellaTemp1)
    if (k-1==z*length(dateGoogle))
        figure('Name','Google mobility of Regions');
        z=z+4;
        tiledlayout(2,2);
        nexttile;
    end
    contatore=contatore+1;
    plot(dateGoogle,TabellaTemp1(k:(k+length(dateGoogle)-1)),'c');
    hold on;
    plot(dateGoogle,TabellaTemp2(k:(k+length(dateGoogle)-1)),'y');
    hold on;
    plot(dateGoogle,TabellaTemp3(k:(k+length(dateGoogle)-1)),'r');
    hold on;
    plot(dateGoogle,TabellaTemp4(k:(k+length(dateGoogle)-1)),'g');
    hold on;
    plot(dateGoogle,TabellaTemp5(k:(k+length(dateGoogle)-1)),'b');
    hold on;
    plot(dateGoogle,TabellaTemp6(k:(k+length(dateGoogle)-1)),'k');
    title(TabellaG.sub_region_1(j));
    legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
    xlabel('Dates');
    ylabel('Percentage of mobility');
    j=j+length(dateGoogle);
end