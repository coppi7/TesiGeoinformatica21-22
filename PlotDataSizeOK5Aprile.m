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


%% Plot the graphs

figure('Name','National Italy mobility Apple');
plot(date,TabellaA.driving);
hold on;
plot(date,TabellaA.walking);
hold on;
plot(date,TabellaA.transit);
ylabel('Percentage of mobility','FontSize', 20);
legend(""+TabellaA.Properties.VariableNames(7)+"",""+TabellaA.Properties.VariableNames(8)+"",""+TabellaA.Properties.VariableNames(9)+"",'Location','north','FontSize', 16);
set(gca,'FontSize', 20)

figure('Name','Driving complete regions');
k=1;
z=1;
g=1;
for i=1:height(TabellaB)
    if i==height(TabellaB)
        TabellaTemp(i) = TabellaB.driving(i);
        Contatore(z) = TabellaB.alternative_name(i);
        j=i;
        TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
        legend(Contatore(1:z),'Location','north');

        ylabel('Percentage of mobility','FontSize',20);
        set(TabellaGrafico,{'color'}, num2cell(jet((length(TabellaTemp)/height(TabellaA))),2));
        set(gca,'FontSize', 20)
    else
        if string(TabellaB.alternative_name(i))==string(TabellaB.alternative_name(i+1))
            TabellaTemp(i) = TabellaB.driving(i);
        else
            TabellaTemp(i) = TabellaB.driving(i);
            Contatore(z) = TabellaB.alternative_name(i);
            z = z+1;
            j=i;
            TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
            k=i+1;
            g=g+1;
            hold on;
        end
    end
end
j=1;
z=0;
contatore=0;
for k=1:length(date):length(TabellaTemp)
    if (k-1==z*length(date))
        figure('Name','Driving regions');
        z=z+4;
        tiledlayout(2,2);
        
        ylabel('Percentage of mobility','FontSize', 20);
        nexttile;
    end
    contatore=contatore+1;
    plot(date,TabellaTemp(k:(k+length(date)-1)));
    title(TabellaB.alternative_name(j));
    j=j+length(date);
    if (contatore~=4)
        nexttile;
    else
        contatore=0;
    end
end
figure('Name','Walking complete regions');
k=1;
z=1;
g=1;
for i=1:height(TabellaB)
    if i==height(TabellaB)
        TabellaTemp(i) = TabellaB.walking(i);
        Contatore(z) = TabellaB.alternative_name(i);
        j=i;
        TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
        legend(Contatore(1:z),'Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
        set(TabellaGrafico,{'color'}, num2cell(jet((length(TabellaTemp)/height(TabellaA))),2));
        set(gca,'FontSize',20)
    else
        if string(TabellaB.alternative_name(i))==string(TabellaB.alternative_name(i+1))
            TabellaTemp(i) = TabellaB.walking(i);
        else
            TabellaTemp(i) = TabellaB.walking(i);
            Contatore(z) = TabellaB.alternative_name(i);
            z = z+1;
            j=i;
            TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
            k=i+1;
            g=g+1;
            hold on;
        end
    end
end
j=1;
z=0;
contatore=0;
for k=1:length(date):length(TabellaTemp)
    if (k-1==z*length(date))
        figure('Name','Walking regions');
        
        ylabel('Percentage of mobility','FontSize', 20);
        z=z+4;
        tiledlayout(2,2);
        nexttile;
    end
    contatore=contatore+1;
    plot(date,TabellaTemp(k:(k+length(date)-1)));
    title(TabellaB.alternative_name(j));
    j=j+length(date);
    if (contatore~=4)
        nexttile;
    else
        contatore=0;
    end
end
%% Clear temporary variables
clear TabellaTemp;
clear Contatore;
clear TabellaGrafico;