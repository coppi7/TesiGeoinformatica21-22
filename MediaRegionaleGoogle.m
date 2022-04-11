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
end
TabellaGoogleApple = TabellaF;
TabellaTempConfrontoGoogle = TabellaAConfrontoGoogle(TabellaAConfrontoGoogle.date>=datetime("15-02-2020","Format","dd-MM-yyyy"),:);
TabellaGoogleApple(:,16:17)=TabellaTempConfrontoGoogle(:,7:8);
TabellaGoogleApple.Properties.VariableNames(16:17)=TabellaA.Properties.VariableNames(7:8);
MatriceA = TabellaGoogleApple(:,10:17);
ArrayA1=table2array(MatriceA);
ArrayA=rmmissing(ArrayA1);

LocalMinWorkplaces = islocalmin(TabellaGoogleApple.workplaces_percent_change_from_baseline);
LocalMaxWorkplaces = islocalmax(TabellaGoogleApple.workplaces_percent_change_from_baseline);
j=0;
for i=1:height(TabellaGoogleApple)
    if LocalMinWorkplaces(i)
        j=j+1;
        TabellaMediaMinWorkplaces(j)= TabellaGoogleApple.workplaces_percent_change_from_baseline(i);
    end
end
MediaMinWorkplaces = mean(TabellaMediaMinWorkplaces);
j=0;
for i=1:height(TabellaGoogleApple)
    if LocalMaxWorkplaces(i)
        j=j+1;
        TabellaMediaMaxWorkplaces(j)= TabellaGoogleApple.workplaces_percent_change_from_baseline(i);
    end
end
MediaMaxWorkplaces = mean(TabellaMediaMaxWorkplaces);
MediaWorkplaces = mean(ArrayA(:,5));
% legend('Workplaces and recreation percent change from baseline', 'Workplaces and pharmacy percent change from baseline','Workplaces percent change from baseline','transit stations percent change from baseline','Workplaces percent change from baseline','Workplaces percent change from baseline','Location','north');
