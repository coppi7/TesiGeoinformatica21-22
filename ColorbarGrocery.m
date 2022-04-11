clearvars;
close all;

addpath('./DatabaseLocale/');
addpath('./Limiti01012021/');
addpath('./ImmaginiVideoRegione/');
addpath('./Limiti01012021_g/');

TabellaA = readtable("./DatabaseLocale/TabellaAppleItalia.csv");
TabellaB = readtable("./DatabaseLocale/TabellaAppleRegioni.csv");
TabellaC = readtable("./DatabaseLocale/TabellaAppleCitta.csv");
TabellaD = readtable("./DatabaseLocale/TabellaAppleMobilityItalia.csv");
TabellaE = readtable("./DatabaseLocale/TabellaGoogleItaliaCompleta.csv");
TabellaF = readtable("./DatabaseLocale/TabellaGoogleNazionaleItalia.csv");
TabellaG = readtable("./DatabaseLocale/TabellaGoogleRegionaleItalia.csv");
TabellaH = readtable("./DatabaseLocale/TabellaGoogleCittaItalia.csv");

startDateGoogle = datetime(cellstr(TabellaF.date(1)), "format","yyyy-MM-dd");
endDateGoogle = datetime(cellstr(TabellaF.date(height(TabellaF))), "format","yyyy-MM-dd");
dateGoogle = (startDateGoogle:1:endDateGoogle);
dateGoogle = datetime(dateGoogle,"format","yyyy-MM-dd");

P = shaperead('./Limiti01012021_g/ProvCM01012021_g/ProvCM01012021_g_WGS84.shp');
C = struct2table(P);
I = shaperead('./Limiti01012021_g/Reg01012021_g/Reg01012021_g_WGS84.shp');
j=1;
for i=1:height(C)
    if C.COD_REG(i)==3
        ProvinceLom(j,:)=C(i,:);
        j=j+1;
    end
end
B = struct2table(I);
% Piemonte (1)
TabellaPiemonte = TabellaG(TabellaG.sub_region_1=="Piedmont",:);
for i=1:height(TabellaPiemonte)
    TabellaPiemonte(i,16:24)=B(1,1:9);
end
TabellaPiemonte.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Valle d'aosta (2)
TabellaAosta = TabellaG(TabellaG.sub_region_1=="Aosta",:);
for i=1:height(TabellaAosta)
    TabellaAosta(i,16:24)=B(2,1:9);
end
TabellaAosta.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Lombardia (3)
TabellaLom = TabellaG(TabellaG.sub_region_1=="Lombardy",:);
for i=1:height(TabellaLom)
    TabellaLom(i,16:24)=B(3,1:9);
end
TabellaLom.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Trentino-Alto-Adige (4)
TabellaTrentino = TabellaG(TabellaG.sub_region_1=="Trentino-South Tyrol",:);
for i=1:height(TabellaTrentino)
    TabellaTrentino(i,16:24)=B(4,1:9);
end
TabellaTrentino.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Veneto (5)
TabellaVeneto = TabellaG(TabellaG.sub_region_1=="Veneto",:);
for i=1:height(TabellaVeneto)
    TabellaVeneto(i,16:24)=B(5,1:9);
end
TabellaVeneto.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Friuli-Venezia Giulia (6)
TabellaFriuli = TabellaG(TabellaG.sub_region_1=="Friuli-Venezia Giulia",:);
for i=1:height(TabellaFriuli)
    TabellaFriuli(i,16:24)=B(6,1:9);
end
TabellaFriuli.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Liguria (7)
TabellaLiguria = TabellaG(TabellaG.sub_region_1=="Liguria",:);
for i=1:height(TabellaLiguria)
    TabellaLiguria(i,16:24)=B(7,1:9);
end
TabellaLiguria.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Emilia-Romagna (8)
TabellaEmilia = TabellaG(TabellaG.sub_region_1=="Emilia-Romagna",:);
for i=1:height(TabellaEmilia)
    TabellaEmilia(i,16:24)=B(8,1:9);
end
TabellaEmilia.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Toscana (9)
TabellaToscana = TabellaG(TabellaG.sub_region_1=="Tuscany",:);
for i=1:height(TabellaToscana)
    TabellaToscana(i,16:24)=B(9,1:9);
end
TabellaToscana.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Umbria (10)
TabellaUmbria = TabellaG(TabellaG.sub_region_1=="Umbria",:);
for i=1:height(TabellaUmbria)
    TabellaUmbria(i,16:24)=B(10,1:9);
end
TabellaUmbria.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Marche (11)
TabellaMarche = TabellaG(TabellaG.sub_region_1=="Marche",:);
for i=1:height(TabellaMarche)
    TabellaMarche(i,16:24)=B(11,1:9);
end
TabellaMarche.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Lazio (12)
TabellaLazio = TabellaG(TabellaG.sub_region_1=="Lazio",:);
for i=1:height(TabellaLazio)
    TabellaLazio(i,16:24)=B(12,1:9);
end
TabellaLazio.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Abruzzo (13)
TabellaAbruzzo = TabellaG(TabellaG.sub_region_1=="Abruzzo",:);
for i=1:height(TabellaAbruzzo)
    TabellaAbruzzo(i,16:24)=B(13,1:9);
end
TabellaAbruzzo.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Molise (14)
TabellaMolise = TabellaG(TabellaG.sub_region_1=="Molise",:);
for i=1:height(TabellaMolise)
    TabellaMolise(i,16:24)=B(14,1:9);
end
TabellaMolise.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Campania (15)
TabellaCampania = TabellaG(TabellaG.sub_region_1=="Campania",:);
for i=1:height(TabellaCampania)
    TabellaCampania(i,16:24)=B(15,1:9);
end
TabellaCampania.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Puglia (16)
TabellaPuglia = TabellaG(TabellaG.sub_region_1=="Apulia",:);
for i=1:height(TabellaPuglia)
    TabellaPuglia(i,16:24)=B(16,1:9);
end
TabellaPuglia.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Basilicata (17)
TabellaBasilicata = TabellaG(TabellaG.sub_region_1=="Basilicata",:);
for i=1:height(TabellaBasilicata)
    TabellaBasilicata(i,16:24)=B(17,1:9);
end
TabellaBasilicata.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Calabria (18)
TabellaCalabria = TabellaG(TabellaG.sub_region_1=="Calabria",:);
for i=1:height(TabellaCalabria)
    TabellaCalabria(i,16:24)=B(18,1:9);
end
TabellaCalabria.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Sicilia (19)
TabellaSicilia = TabellaG(TabellaG.sub_region_1=="Sicily",:);
for i=1:height(TabellaSicilia)
    TabellaSicilia(i,16:24)=B(19,1:9);
end
TabellaSicilia.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
% Sardegna (20)
TabellaSardegna = TabellaG(TabellaG.sub_region_1=="Sardinia",:);
for i=1:height(TabellaSardegna)
    TabellaSardegna(i,16:24)=B(20,1:9);
end
TabellaSardegna.Properties.VariableNames(16:24)=B.Properties.VariableNames(1:9);
TabellaItaliaRegioni = [TabellaPiemonte; TabellaAosta; TabellaLom; TabellaTrentino; TabellaVeneto; ...
    TabellaFriuli; TabellaLiguria; TabellaEmilia; TabellaToscana; TabellaUmbria; TabellaMarche; TabellaLazio; ...
    TabellaAbruzzo; TabellaMolise; TabellaCampania; TabellaPuglia; TabellaBasilicata; TabellaCalabria; TabellaSicilia; TabellaSardegna];
ValGrocReg = linspace(min(TabellaG.grocery_and_pharmacy_percent_change_from_baseline),max(TabellaG.grocery_and_pharmacy_percent_change_from_baseline),21);
%% Classification on twenty classes
map10 = [0 0 4;24 15 62;68 15 118;114 31 129;158 47 127;205 63 113;241 96 93;253 149 103;254 201 141;252 253 119]/255;
map20 = [0 0 4;7 6 28;22 14 58;41 17 90;63 15 115;85 20 125;107 28 129;127 36 129;149 44 129;171 51 125;193 58 117;214 68 109;232 83 98;244 104 92;251 129 45;254 154 106;254 180 123;254 204 143;253 229 166;252 253 191]/255;
mapshow(I(1),'Facecolor',map20(1,:));
mapshow(I(2),'Facecolor',map20(2,:));
mapshow(I(3),'Facecolor',map20(3,:));
mapshow(I(4),'Facecolor',map20(4,:));
mapshow(I(5),'Facecolor',map20(5,:));
mapshow(I(6),'Facecolor',map20(6,:));
mapshow(I(7),'Facecolor',map20(7,:));
mapshow(I(8),'Facecolor',map20(8,:));
mapshow(I(9),'Facecolor',map20(9,:));
mapshow(I(10),'Facecolor',map20(10,:));
mapshow(I(11),'Facecolor',map20(11,:));
mapshow(I(12),'Facecolor',map20(12,:));
mapshow(I(13),'Facecolor',map20(13,:));
mapshow(I(14),'Facecolor',map20(13,:));
mapshow(I(15),'Facecolor',map20(13,:));
mapshow(I(16),'Facecolor',map20(13,:));
mapshow(I(17),'Facecolor',map20(13,:));
mapshow(I(18),'Facecolor',map20(13,:));
mapshow(I(19),'Facecolor',map20(13,:));
mapshow(I(20),'Facecolor',map20(13,:));
colormap(map20);
cb = colorbar('southoutside');
min = min(TabellaG.grocery_and_pharmacy_percent_change_from_baseline);
max = max(TabellaG.grocery_and_pharmacy_percent_change_from_baseline);
caxis([min(TabellaG.grocery_and_pharmacy_percent_change_from_baseline) max(TabellaG.grocery_and_pharmacy_percent_change_from_baseline)]);
Marzo2020 = TabellaG(TabellaG.date == "2020-03-15",:);
Marzo2020Groc = Marzo2020.grocery_and_pharmacy_percent_change_from_baseline;
Aprile2020 = TabellaG(TabellaG.date == "2020-04-15",:);
Aprile2020Groc = Aprile2020.grocery_and_pharmacy_percent_change_from_baseline;
Maggio2020 = TabellaG(TabellaG.date == "2020-05-15",:);
Maggio2020Groc = Maggio2020.grocery_and_pharmacy_percent_change_from_baseline;
Giugno2020 = TabellaG(TabellaG.date == "2020-06-15",:);
Giugno2020Groc = Giugno2020.grocery_and_pharmacy_percent_change_from_baseline;

Marzo2021 = TabellaG(TabellaG.date == "2021-03-15",:);
Marzo2021Groc = Marzo2021.grocery_and_pharmacy_percent_change_from_baseline;
Aprile2021 = TabellaG(TabellaG.date == "2021-04-15",:);
Aprile2021Groc = Aprile2021.grocery_and_pharmacy_percent_change_from_baseline;
Maggio2021 = TabellaG(TabellaG.date == "2021-05-15",:);
Maggio2021Groc = Maggio2021.grocery_and_pharmacy_percent_change_from_baseline;
Giugno2021 = TabellaG(TabellaG.date == "2021-06-15",:);
Giugno2021Groc = Giugno2021.grocery_and_pharmacy_percent_change_from_baseline;
