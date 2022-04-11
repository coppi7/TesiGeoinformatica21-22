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
TabellaAppleRegione = TabellaB(TabellaB.date>="2020-02-15",:);
TabellaAppleSolo = TabellaB;
for i=1:height(TabellaB)
    TabellaAppleSolo.driving(i)=TabellaAppleSolo.driving(i)-100;
    TabellaAppleSolo.walking(i)=TabellaAppleSolo.walking(i)-100;
end
for i=1:height(TabellaAppleRegione)
    TabellaAppleRegione.driving(i)=TabellaAppleRegione.driving(i)-100;
    TabellaAppleRegione.walking(i)=TabellaAppleRegione.walking(i)-100;
end
for i=1:height(TabellaItaliaRegioni)
    for j=1:height(TabellaAppleRegione)
        if TabellaItaliaRegioni.DEN_REG(i)==TabellaAppleRegione.alternative_name(j)
            TabellaTemp(j,1:15)=TabellaItaliaRegioni(i,:);
            TabellaTemp(j,16:17)=TabellaAppleRegione(j,:);
        end
    end
end
%% Classification on twenty classes
map10 = [0 0 4;24 15 62;68 15 118;114 31 129;158 47 127;205 63 113;241 96 93;253 149 103;254 201 141;252 253 119]/255;
map20 = [0 0 4;7 6 28;22 14 58;41 17 90;63 15 115;85 20 125;107 28 129;127 36 129;149 44 129;171 51 125;193 58 117;214 68 109;232 83 98;244 104 92;251 129 45;254 154 106;254 180 123;254 204 143;253 229 166;252 253 191]/255;