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
%% Plot Driving of cities
figure('Name','Driving complete cities');
k=1;
z=1;
g=1;
for i=1:height(TabellaC)
    if i==height(TabellaC)
        TabellaTemp(i) = TabellaC.driving(i);
        if string(TabellaC.alternative_name(i))=='<undefined>'
            Contatore(z) = TabellaC.name(i);
        else
            Contatore(z) = TabellaC.alternative_name(i);
        end
        j=i;
        TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
        legend(Contatore(1:z),'Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
        set(TabellaGrafico,{'color'}, num2cell(jet((length(TabellaTemp)/height(TabellaA))),2));
    else
        if string(TabellaC.alternative_name(i))=='<undefined>'
            if string(TabellaC.name(i))==string(TabellaC.name(i+1))
                TabellaTemp(i) = TabellaC.driving(i);
            else
                TabellaTemp(i) = TabellaC.driving(i);
                Contatore(z) = TabellaC.name(i);
                z = z+1;
                j=i;
                TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
                k=i+1;
                g=g+1;
                hold on;
            end
        else
            if string(TabellaC.alternative_name(i))==string(TabellaC.alternative_name(i+1))
                TabellaTemp(i) = TabellaC.driving(i);
            else
                TabellaTemp(i) = TabellaC.driving(i);
                Contatore(z) = TabellaC.alternative_name(i);
                z = z+1;
                j=i;
                TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
                k=i+1;
                g=g+1;
                hold on;
            end
        end
    end
end

j=1;
z=0;
contatore=0;
for k=1:length(date):length(TabellaTemp)
    if (k-1==z*length(date))
        figure('Name','Driving cities');
        z=z+2;
        tiledlayout(2,1);
        nexttile;
    end
    contatore=contatore+1;
    plot(date,TabellaTemp(k:(k+length(date)-1)));
    
    ylabel('Percentage of mobility','FontSize', 20);
    set(gca,'Fontsize',20);
    if string(TabellaC.alternative_name(j))=='<undefined>'
        title(TabellaC.name(j));
        j=j+length(date);
    else
        title(TabellaC.alternative_name(j));
        j=j+length(date);
    end
    if (contatore~=2)
        nexttile;
    else
        contatore=0;
    end
end
%% Plot walking cities
figure('Name','Walking complete cities');
k=1;
z=1;
g=1;
for i=1:height(TabellaC)
    if i==height(TabellaC)
        TabellaTemp(i) = TabellaC.walking(i);
        if string(TabellaC.alternative_name(i))=='<undefined>'
            Contatore(z) = TabellaC.name(i);
        else
            Contatore(z) = TabellaC.alternative_name(i);
        end
        j=i;
        TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
        legend(Contatore(1:z),'Location','north');
        set(TabellaGrafico,{'color'}, num2cell(jet((length(TabellaTemp)/height(TabellaA))),2));
    else
        if string(TabellaC.alternative_name(i))=='<undefined>'
            if string(TabellaC.name(i))==string(TabellaC.name(i+1))
                TabellaTemp(i) = TabellaC.walking(i);
            else
                TabellaTemp(i) = TabellaC.walking(i);
                Contatore(z) = TabellaC.name(i);
                z = z+1;
                j=i;
                TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
                k=i+1;
                g=g+1;
                hold on;
            end
        else
            if string(TabellaC.alternative_name(i))==string(TabellaC.alternative_name(i+1))
                TabellaTemp(i) = TabellaC.walking(i);
            else
                TabellaTemp(i) = TabellaC.walking(i);
                Contatore(z) = TabellaC.alternative_name(i);
                z = z+1;
                j=i;
                TabellaGrafico(g) = plot(date,TabellaTemp(k:j));
                
                ylabel('Percentage of walking mobility');
                k=i+1;
                g=g+1;
                hold on;
            end
        end
    end
end

j=1;
z=0;
contatore=0;
for k=1:length(date):length(TabellaTemp)
    if (k-1==z*length(date))
        figure('Name','Walking cities');
        z=z+2;
        tiledlayout(2,1);
        nexttile;
    end
    contatore=contatore+1;
    plot(date,TabellaTemp(k:(k+length(date)-1)));
    
    ylabel('Percentage of walking mobility');
    if string(TabellaC.alternative_name(i))=='<undefined>'
        title(TabellaC.name(j));
        j=j+length(date);
    else
        title(TabellaC.alternative_name(j));
        j=j+length(date);
    end
    if (contatore~=2)
        nexttile;
    else
        contatore=0;
    end
end
%% Clear temporary variables
clear TabellaTemp; clear Contatore; clear contatore;
clear i; clear j; clear k; clear z; clear g; clear TabellaGrafico;

%% Plot GoogleData

figure('Name','National Data Google');
plot(dateGoogle,TabellaF.retail_and_recreation_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.grocery_and_pharmacy_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.parks_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.transit_stations_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.workplaces_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.residential_percent_change_from_baseline);
legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');

ylabel('Percentage of mobility','FontSize', 20);
%% Plot data of regions of Google
figure('Name','Mobility Google regions');
k=1;
for i=1:height(TabellaG)
    if i==height(TabellaG)
        TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
        TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
        TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
        TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
        TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
        TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
        j=i;
        plot(dateGoogle,TabellaTemp1(k:j),'c');
        hold on;
        plot(dateGoogle,TabellaTemp2(k:j),'y');
        hold on;
        plot(dateGoogle,TabellaTemp3(k:j),'r');
        hold on;
        plot(dateGoogle,TabellaTemp4(k:j),'g');
        hold on;
        plot(dateGoogle,TabellaTemp5(k:j),'b');
        hold on;
        plot(dateGoogle,TabellaTemp6(k:j),'k');
        legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
    else
        if string(TabellaG.sub_region_1(i))==string(TabellaG.sub_region_1(i+1))
            TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
        else
            TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
            j=i;
            plot(dateGoogle,TabellaTemp1(k:j),'c');
            hold on;
            plot(dateGoogle,TabellaTemp2(k:j),'y');
            hold on;
            plot(dateGoogle,TabellaTemp3(k:j),'r');
            hold on;
            plot(dateGoogle,TabellaTemp4(k:j),'g');
            hold on;
            plot(dateGoogle,TabellaTemp5(k:j),'b');
            hold on;
            plot(dateGoogle,TabellaTemp6(k:j),'k');
            k=i+1;
            hold on;
            legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
        end
    end
end
j=1;
z=0;
contatore=0;
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
    
    ylabel('Percentage of mobility','FontSize', 20);
    j=j+length(dateGoogle);
    if (contatore~=4)
        nexttile;
    else
        contatore=0;
    end
end
%% Clear temporary variables
clear TabellaTemp1; clear TabellaTemp2; clear TabellaTemp3;
clear TabellaTemp4; clear TabellaTemp5; clear TabellaTemp6;
clear Contatore; clear i; clear j; clear k; clear z; clear g; clear contatore;
%% Plot data of Cities of Google
figure('Name','Mobility Google cities');
k=1;
for i=1:height(TabellaH)
    if i==height(TabellaH)
        TabellaTemp1(i,:) = TabellaH.retail_and_recreation_percent_change_from_baseline(i);
        TabellaTemp2(i,:) = TabellaH.grocery_and_pharmacy_percent_change_from_baseline(i);
        TabellaTemp3(i,:) = TabellaH.parks_percent_change_from_baseline(i);
        TabellaTemp4(i,:) = TabellaH.transit_stations_percent_change_from_baseline(i);
        TabellaTemp5(i,:) = TabellaH.workplaces_percent_change_from_baseline(i);
        TabellaTemp6(i,:) = TabellaH.residential_percent_change_from_baseline(i);
        j=i;
        plot(dateGoogle,TabellaTemp1(k:j),'c');
        hold on;
        plot(dateGoogle,TabellaTemp2(k:j),'y');
        hold on;
        plot(dateGoogle,TabellaTemp3(k:j),'r');
        hold on;
        plot(dateGoogle,TabellaTemp4(k:j),'g');
        hold on;
        plot(dateGoogle,TabellaTemp5(k:j),'b');
        hold on;
        plot(dateGoogle,TabellaTemp6(k:j),'k');
        hold on;
        k=i+1;
        legend('retail and recreation percent change from baseline','grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
    else
        if string(TabellaH.sub_region_2(i))==string(TabellaH.sub_region_2(i+1))
            TabellaTemp1(i,:) = TabellaH.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaH.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaH.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaH.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaH.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaH.residential_percent_change_from_baseline(i);
        else
            TabellaTemp1(i,:) = TabellaH.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaH.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaH.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaH.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaH.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaH.residential_percent_change_from_baseline(i);
            j=i;
            plot(dateGoogle,TabellaTemp1(k:j),'c');
            hold on;
            plot(dateGoogle,TabellaTemp2(k:j),'y');
            hold on;
            plot(dateGoogle,TabellaTemp3(k:j),'r');
            hold on;
            plot(dateGoogle,TabellaTemp4(k:j),'g');
            hold on;
            plot(dateGoogle,TabellaTemp5(k:j),'b');
            hold on;
            plot(dateGoogle,TabellaTemp6(k:j),'k');
            hold on;
            k=i+1;
        end
    end
end
%% Clear temporary variables
clear TabellaTemp1; clear TabellaTemp2; clear TabellaTemp3;
clear TabellaTemp4; clear TabellaTemp5; clear TabellaTemp6;
clear Contatore; clear i; clear j; clear k;
%% Plot the cities decided by the user
i=1;
while i>0
    lista = TabellaH.sub_region_2(1:length(dateGoogle):height(TabellaH));
    [indx,tf] = listdlg('PromptString','Select the city to be represented', 'ListString',lista, "SelectionMode","single");
    risposta = string(lista(indx));
    risposta = cellstr(risposta);
    TabellaCitta = TabellaH(TabellaH.sub_region_2==""+risposta+"",:);
    TabellaTemp = TabellaCitta(:,10:15);
        TabellaTemp = table2array(TabellaTemp);
        figure('Name',"Mobility of "+risposta+"");
        plot(dateGoogle,TabellaTemp(:,1:6));
        legend('retail and recreation percent change from baseline','grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
    risposta = inputdlg('Do you want to represent another city? Y/N','Plot the Google mobility data of a city',[1 50]);
    risposta2=risposta{1};
    if risposta2=="Y"
    else
        i=0;
    end
end
%% Clear temporary variables
clear TabellaTemp; clear TabellaCitta;
clear i; clear domanda; clear risposta; clear risposta2; clear indx; 
clear tf; clear lista;
%% Plot the comparison between periods
for i=1:length(Estate2020)
    TabellaTemp2020(i,:) = TabellaA(TabellaA.date==Estate2020(i),:);
    TabellaTemp2021(i,:) = TabellaA(TabellaA.date==Estate2021(i),:);
end
ArrayTemp2020 = table2array(TabellaTemp2020(:,7:9));
ArrayTemp2021 = table2array(TabellaTemp2021(:,7:9));
MediaEstate2020=mean(ArrayTemp2020);
MediaEstate2021=mean(ArrayTemp2021);
figure('Name', "Summer2020 vs Summer2021");
plot(Estate2020,ArrayTemp2020(:,1:3));
hold on;
plot(Estate2020,ArrayTemp2021(:,1:3));
legend('Driving2020','Walking2020','Transit2020','Driving2021','Walking2021','Transit2021');

ylabel('Percentage of mobility','FontSize', 20);
%% Clear temporary variables
clear ArrayTemp2020; clear ArrayTemp2021; clear TabellaTemp2021; clear TabellaTemp2020;
%% Mean of spring days'
for i=1:length(Primavera2020)
    TabellaPrimavera2020(i,:) = TabellaA(TabellaA.date==Primavera2020(i),:);
    TabellaPrimavera2021(i,:) = TabellaA(TabellaA.date==Primavera2021(i),:);
end
ArrayPrimavera2020 = table2array(TabellaPrimavera2020(:,7:9));
ArrayPrimavera2021 = table2array(TabellaPrimavera2021(:,7:9));
a=1;
c=1;
for i=1:length(ArrayPrimavera2020)
    if isnan(ArrayPrimavera2020(i,:))
    else
        ArrayMediaPrimavera2020(a,:) = ArrayPrimavera2020(i,:);
        a=a+1;
    end
    if isnan(ArrayPrimavera2021(i,:))
    else
        ArrayMediaPrimavera2021(c,:) = ArrayPrimavera2021(i,:);
        c=c+1;
    end
end
MediaPrimavera2020=mean(ArrayMediaPrimavera2020);
MediaPrimavera2021=mean(ArrayMediaPrimavera2021);
%% Clear temporary variables
clear a; clear c;
%% Plot data
figure('Name', "Spring2020 vs Spring2021");
plot(Primavera2020,ArrayPrimavera2020(:,1:3));
hold on;
plot(Primavera2020,ArrayPrimavera2021(:,1:3));
legend('Driving2020','Walking2020','Transit2020','Driving2021','Walking2021','Transit2021');

ylabel('Percentage of mobility','FontSize', 20);

for i=1:length(Autunno2020)
    TabellaAutunno2020(i,:) = TabellaA(TabellaA.date==Autunno2020(i),:);
    TabellaAutunno2021(i,:) = TabellaA(TabellaA.date==Autunno2021(i),:);
end
ArrayAutunno2020 = table2array(TabellaAutunno2020(:,7:9));
ArrayAutunno2021 = table2array(TabellaAutunno2021(:,7:9));
figure('Name', "Autumn2020 vs Autumn2021");
plot(Autunno2020,ArrayAutunno2020(:,1:3));
hold on;
plot(Autunno2020,ArrayAutunno2021(:,1:3));
legend('Driving2020','Walking2020','Transit2020','Driving2021','Walking2021','Transit2021');

ylabel('Percentage of mobility','FontSize', 20);

%% Google temporal data
GoogleInverno2020 = readtable("./TabelleDateGoogle/TabellaGoogleInverno2020.csv");
GooglePrimavera2020 = readtable("./TabelleDateGoogle/TabellaGooglePrimavera2020.csv");
GoogleEstate2020 = readtable("./TabelleDateGoogle/TabellaGoogleEstate2020.csv");
GoogleAutunno2020 = readtable("./TabelleDateGoogle/TabellaGoogleAutunno2020.csv");
GoogleInverno2021 = readtable("./TabelleDateGoogle/TabellaGoogleInverno2021.csv");
GooglePrimavera2021 = readtable("./TabelleDateGoogle/TabellaGooglePrimavera2021.csv");
GoogleEstate2021 = readtable("./TabelleDateGoogle/TabellaGoogleEstate2021.csv");
GoogleAutunno2021 = readtable("./TabelleDateGoogle/TabellaGoogleAutunno2021.csv");
i=1;
while i>0
    listaPeriodo = ["Winter" "Spring" "Summer" "Autumn"];
    [indx1,tf1] = listdlg('PromptString','Select the period', 'ListString', listaPeriodo, "SelectionMode", "single");
    risposta1 = string(listaPeriodo(indx1));
    risposta1 = cellstr(risposta1);
    if risposta1=="Autumn"
        lista = GoogleAutunno2020.sub_region_1(1:length(Autunno2020):height(GoogleAutunno2020));
        [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
        risposta = string(lista(indx));
        risposta = cellstr(risposta);
        AutunnoRegioni2020 = GoogleAutunno2020(GoogleAutunno2020.sub_region_1==""+risposta+"",:);
        AutunnoRegioni2021 = GoogleAutunno2021(GoogleAutunno2021.sub_region_1==""+risposta+"",:);
        TabellaTemp2020 = AutunnoRegioni2020(:,10:15);
        TabellaTemp2021 = AutunnoRegioni2021(:,10:15);
        TabellaTemp2020 = table2array(TabellaTemp2020);
        TabellaTemp2021 = table2array(TabellaTemp2021);
        figure('Name',"Mobility of "+risposta+"");
        plot(Autunno2020,TabellaTemp2020(:,1),'b*',Autunno2020,TabellaTemp2020(:,2),'g*',Autunno2020,TabellaTemp2020(:,3),'r*',Autunno2020,TabellaTemp2020(:,4),'c*',Autunno2020,TabellaTemp2020(:,5),'m*',Autunno2020,TabellaTemp2020(:,6),'y*');
        hold on;
        plot(Autunno2020,TabellaTemp2021(:,1),'b',Autunno2020,TabellaTemp2021(:,2),'g',Autunno2020,TabellaTemp2021(:,3),'r',Autunno2020,TabellaTemp2021(:,4),'c',Autunno2020,TabellaTemp2021(:,5),'m',Autunno2020,TabellaTemp2021(:,6),'y');
        legend('retail and recreation percent change from baseline 2020','grocery and pharmacy percent change from baseline 2020','parks percent change from baseline 2020','transit stations percent change from baseline 2020','workplaces percent change from baseline 2020','residential percent change from baseline 2020','retail and recreation percent change from baseline 2021','grocery and pharmacy percent change from baseline 2021','parks percent change from baseline 2021','transit stations percent change from baseline 2021','workplaces percent change from baseline 2021','residential percent change from baseline 2021','Location','north');
        
        ylabel('Percentage of mobility','FontSize', 20);
        risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
        risposta2=risposta{1};
        if risposta2=="Y"
        else
            i=0;
        end
    end
        if risposta1=="Winter"
            lista = GoogleInverno2020.sub_region_1(1:length(Inverno2020ConfrontoGoogle):height(GoogleInverno2020));
            [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
            risposta = string(lista(indx));
            risposta = cellstr(risposta);
            InvernoRegioni2020 = GoogleInverno2020(GoogleInverno2020.sub_region_1==""+risposta+"",:);
            InvernoRegioni2021 = GoogleAutunno2021(GoogleInverno2021.sub_region_1==""+risposta+"",:);
            TabellaTemp2020 = InvernoRegioni2020(:,10:15);
            TabellaTemp2021 = InvernoRegioni2021(:,10:15);
            TabellaTemp2020 = table2array(TabellaTemp2020);
            TabellaTemp2021 = table2array(TabellaTemp2021);
            figure('Name',"Mobility of "+risposta+"");
            plot(Inverno2020ConfrontoGoogle,TabellaTemp2020(:,1),'b*',Inverno2020ConfrontoGoogle,TabellaTemp2020(:,2),'g*',Inverno2020ConfrontoGoogle,TabellaTemp2020(:,3),'r*',Inverno2020ConfrontoGoogle,TabellaTemp2020(:,4),'c*',Inverno2020ConfrontoGoogle,TabellaTemp2020(:,5),'m*',Inverno2020ConfrontoGoogle,TabellaTemp2020(:,6),'y*');
            hold on;
            plot(Inverno2020ConfrontoGoogle,TabellaTemp2021(:,1),'b',Inverno2020ConfrontoGoogle,TabellaTemp2021(:,2),'g',Inverno2020ConfrontoGoogle,TabellaTemp2021(:,3),'r',Inverno2020ConfrontoGoogle,TabellaTemp2021(:,4),'c',Inverno2020ConfrontoGoogle,TabellaTemp2021(:,5),'m',Inverno2020ConfrontoGoogle,TabellaTemp2021(:,6),'y');
            legend('retail and recreation percent change from baseline 2020','grocery and pharmacy percent change from baseline 2020','parks percent change from baseline 2020','transit stations percent change from baseline 2020','workplaces percent change from baseline 2020','residential percent change from baseline 2020','retail and recreation percent change from baseline 2021','grocery and pharmacy percent change from baseline 2021','parks percent change from baseline 2021','transit stations percent change from baseline 2021','workplaces percent change from baseline 2021','residential percent change from baseline 2021','Location','north');
            
            ylabel('Percentage of mobility','FontSize', 20);
            risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
            risposta2=risposta{1};
            if risposta2=="Y"
            else
                i=0;
            end
        end
            if risposta1=="Spring"
                lista = GooglePrimavera2020.sub_region_1(1:length(Primavera2020):height(GooglePrimavera2020));
                [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
                risposta = string(lista(indx));
                risposta = cellstr(risposta);
                PrimaveraRegioni2020 = GooglePrimavera2020(GooglePrimavera2020.sub_region_1==""+risposta+"",:);
                PrimaveraRegioni2021 = GooglePrimavera2021(GooglePrimavera2021.sub_region_1==""+risposta+"",:);
                TabellaTemp2020 = PrimaveraRegioni2020(:,10:15);
                TabellaTemp2021 = PrimaveraRegioni2021(:,10:15);
                TabellaTemp2020 = table2array(TabellaTemp2020);
                TabellaTemp2021 = table2array(TabellaTemp2021);
                figure('Name',"Mobility of "+risposta+"");
                plot(Primavera2020,TabellaTemp2020(:,1),'b*',Primavera2020,TabellaTemp2020(:,2),'g*',Primavera2020,TabellaTemp2020(:,3),'r*',Primavera2020,TabellaTemp2020(:,4),'c*',Primavera2020,TabellaTemp2020(:,5),'m*',Primavera2020,TabellaTemp2020(:,6),'y*');
                hold on;
                plot(Primavera2020,TabellaTemp2021(:,1),'b',Primavera2020,TabellaTemp2021(:,2),'g',Primavera2020,TabellaTemp2021(:,3),'r',Primavera2020,TabellaTemp2021(:,4),'c',Primavera2020,TabellaTemp2021(:,5),'m',Primavera2020,TabellaTemp2021(:,6),'y');
                legend('retail and recreation percent change from baseline 2020','grocery and pharmacy percent change from baseline 2020','parks percent change from baseline 2020','transit stations percent change from baseline 2020','workplaces percent change from baseline 2020','residential percent change from baseline 2020','retail and recreation percent change from baseline 2021','grocery and pharmacy percent change from baseline 2021','parks percent change from baseline 2021','transit stations percent change from baseline 2021','workplaces percent change from baseline 2021','residential percent change from baseline 2021','Location','north');
                
                ylabel('Percentage of mobility','FontSize', 20);
                risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
                risposta2=risposta{1};
                if risposta2=="Y"
                else
                    i=0;
                end
            end
            if risposta1=="Summer"
                lista = GoogleEstate2020.sub_region_1(1:length(Estate2020):height(GoogleEstate2020));
                [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
                risposta = string(lista(indx));
                risposta = cellstr(risposta);
                EstateRegioni2020 = GoogleEstate2020(GoogleEstate2020.sub_region_1==""+risposta+"",:);
                EstateRegioni2021 = GoogleEstate2021(GoogleEstate2021.sub_region_1==""+risposta+"",:);
                TabellaTemp2020 = EstateRegioni2020(:,10:15);
                TabellaTemp2021 = EstateRegioni2021(:,10:15);
                TabellaTemp2020 = table2array(TabellaTemp2020);
                TabellaTemp2021 = table2array(TabellaTemp2021);
                figure('Name',"Mobility of "+risposta+"");
                plot(Estate2020,TabellaTemp2020(:,1),'b*',Estate2020,TabellaTemp2020(:,2),'g*',Estate2020,TabellaTemp2020(:,3),'r*',Estate2020,TabellaTemp2020(:,4),'c*',Estate2020,TabellaTemp2020(:,5),'m*',Estate2020,TabellaTemp2020(:,6),'y*');
                hold on;
                plot(Estate2020,TabellaTemp2021(:,1),'b',Estate2020,TabellaTemp2021(:,2),'g',Estate2020,TabellaTemp2021(:,3),'r',Estate2020,TabellaTemp2021(:,4),'c',Estate2020,TabellaTemp2021(:,5),'m',Estate2020,TabellaTemp2021(:,6),'y');
                legend('retail and recreation percent change from baseline 2020','grocery and pharmacy percent change from baseline 2020','parks percent change from baseline 2020','transit stations percent change from baseline 2020','workplaces percent change from baseline 2020','residential percent change from baseline 2020','retail and recreation percent change from baseline 2021','grocery and pharmacy percent change from baseline 2021','parks percent change from baseline 2021','transit stations percent change from baseline 2021','workplaces percent change from baseline 2021','residential percent change from baseline 2021','Location','north');
                
                ylabel('Percentage of mobility','FontSize', 20);
                risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
                risposta2=risposta{1};
                if risposta2=="Y"
                else
                    i=0;
                end
            end
end
%% Clear temporary variables
clear a1; clear a2; clear b1; clear b2; clear c1; clear c2; clear d1; clear d2;
clear i; clear TabellaTemp2020; clear TabellaTemp2021;
clear lista; clear indx; clear tf; clear risposta; clear risposta2;