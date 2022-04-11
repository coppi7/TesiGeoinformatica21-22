clearvars;
close all;

addpath('./DatabaseLocale/');
addpath('./TabelleDateGoogle/');
%% Read the available table for the analysis
TabellaVeneto = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Veneto.csv");
TabellaUmbria = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Umbria.csv");
TabellaTrentino = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Trentino Alto Adige.csv");
TabellaToscana = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Toscana.csv");
TabellaSicilia = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Sicilia.csv");
TabellaSardegna = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Sardegna.csv");
TabellaPuglia = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Puglia.csv");
TabellaPiemonte = readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Piemonte.csv");
TabellaMarche =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Marche.csv");
TabellaLombardia =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Lombardia.csv");
TabellaLiguria =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Liguria.csv");
TabellaLazio =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Lazio.csv");
TabellaFriuli =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Friuli venezia Giulia.csv");
TabellaEmilia =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Emilia Romagna.csv");
TabellaCampania =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Campania.csv");
TabellaCalabria =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Calabria.csv");
TabellaAbruzzo =  readtable("./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabellaAIC_Abruzzo.csv");

TabellaItaliaRegioni = [TabellaPiemonte(1:28,1:7); TabellaLombardia(1:28,1:7); TabellaTrentino(1:28,1:7); TabellaVeneto(1:28,1:7); ...
    TabellaFriuli(1:28,1:7); TabellaLiguria(1:28,1:7); TabellaEmilia(1:28,1:7); TabellaToscana(1:28,1:7); TabellaUmbria(1:28,1:7); TabellaMarche(1:28,1:7); TabellaLazio(1:28,1:7); ...
    TabellaAbruzzo(1:28,1:7); TabellaCampania(1:28,1:7); TabellaPuglia(1:28,1:7); TabellaCalabria(1:28,1:7); TabellaSicilia(1:28,1:7); TabellaSardegna(1:28,1:7)];
TabellaItaliaApprossimazioni = [TabellaPiemonte; TabellaLombardia; TabellaTrentino; TabellaVeneto; ...
    TabellaFriuli; TabellaLiguria; TabellaEmilia; TabellaToscana; TabellaUmbria; TabellaMarche; TabellaLazio; ...
    TabellaAbruzzo; TabellaCampania; TabellaPuglia; TabellaCalabria; TabellaSardegna];
NomeRegione = ["Piemonte" "Lombardia" "Trentino" "Veneto" ...
    "Friuli" "Liguria" "Emilia" "Toscana" "Umbria" "Marche" "Lazio" ...
    "Abruzzo" "Campania" "Puglia" "Calabria" "Sardegna"];
NomeRegione = array2table(NomeRegione);
j=1;
for i=1:height(TabellaPiemonte):height(TabellaItaliaApprossimazioni)
    TabellaItaliaApprossimazioni(i:j*height(TabellaPiemonte),9) = NomeRegione(:,j);
    j=j+1;
end
TabellaItaliaApprossimazioni.Properties.VariableNames(9)= "Regione";
j=0;
for i=1:height(TabellaItaliaApprossimazioni)
    if TabellaItaliaApprossimazioni.approximation(i)=="(piecewise)" || TabellaItaliaApprossimazioni.approximation(i)=="(piecewise_fsp)"
        j=j+1;
        TabellaTemp(j,:)=TabellaItaliaApprossimazioni(i,:);
    end
end
for i=1:height(TabellaTemp)
    TabellaDifferenze(i,1)=abs((TabellaTemp.b(i)*TabellaTemp.x0(i)+TabellaTemp.a(i))-(TabellaTemp.d(i)*TabellaTemp.x0(i)+TabellaTemp.c(i)));
end
TabellaDifferenze = array2table(TabellaDifferenze);
TabellaDifferenze(:,2)= TabellaTemp(:,1);
TabellaDifferenze(:,3)= TabellaTemp(:,9);
TabellaDifferenze.Properties.VariableNames(1)= "Differenze";
TabellaDifferenze.Properties.VariableNames(2)= "Comparison";
TabellaDifferenze.Properties.VariableNames(3)= "Regione";
writetable(TabellaDifferenze,'./DatabaseLocale/TabelleAIC/TabelleRegionaliAIC/TabelleDifferenze/TabellaDifferenzaOrdinata.csv');