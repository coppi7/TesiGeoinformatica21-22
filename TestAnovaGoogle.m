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

%% Test ANOVA Google
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
figure()
set(gca,'FontSize',20);
[P,ANOVATAB,STATS] = anova1([MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.grocery_and_pharmacy_percent_change_from_baseline, MatriceA.parks_percent_change_from_baseline,MatriceA.transit_stations_percent_change_from_baseline,MatriceA.workplaces_percent_change_from_baseline,MatriceA.residential_percent_change_from_baseline],{'retail and recreation','grocery and pharmacy','parks','transit stations','workplaces','residential'});
set(gca,'FontSize',20);
figure()
set(gca,'FontSize',20);
[c,u] = multcompare(STATS);% Criterio Tukey
set(gca,'FontSize',20);
IpotesiZero = kstest(res/sqrt(ANOVATAB{3,4})); % Kolmogorov-Smirnov
if IpotesiZero==0
    fprintf("Non si può rifiutare l'ipotesi nulla! \n");
else
    fprintf("Si rifiuta l'ipotesi nulla! \n");
end