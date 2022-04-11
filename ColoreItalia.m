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
ValGrocReg = linspace(min(TabellaG.workplaces_percent_change_from_baseline),max(TabellaG.workplaces_percent_change_from_baseline),21);
%% Classification on twenty classes
map10 = [0 0 4;24 15 62;68 15 118;114 31 129;158 47 127;205 63 113;241 96 93;253 149 103;254 201 141;252 253 119]/255;
map20 = [0 0 4;7 6 28;22 14 58;41 17 90;63 15 115;85 20 125;107 28 129;127 36 129;149 44 129;171 51 125;193 58 117;214 68 109;232 83 98;244 104 92;251 129 45;254 154 106;254 180 123;254 204 143;253 229 166;252 253 191]/255;
for i=1:height(TabellaLom)
    % Valle d'Aosta (1)
    if (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(1),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(1),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(1),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(1),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(1),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(1),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(1),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(1),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(1),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(1),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(1),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(1),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(1),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(1),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(1),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(1),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(1),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(1),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(1),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaAosta.workplaces_percent_change_from_baseline(i)) && (TabellaAosta.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(1),'FaceColor',map20(20,:));
        hold on;
    end
    % Piemonte (2)
    if (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(2),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(2),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(2),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(2),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(2),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(2),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(2),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(2),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(2),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(2),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(2),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(2),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(2),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(2),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(2),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(2),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(2),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(2),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(2),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaPiemonte.workplaces_percent_change_from_baseline(i)) && (TabellaPiemonte.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(2),'FaceColor',map20(20,:));
        hold on;
    end
    % Lombardia (3)
    if (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(3),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(3),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(3),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(3),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(3),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(3),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(3),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(3),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(3),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(3),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(3),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(3),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(3),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(3),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(3),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(3),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(3),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(3),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(3),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaLom.workplaces_percent_change_from_baseline(i)) && (TabellaLom.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(3),'FaceColor',map20(20,:));
        hold on;
    end
    % Trentino (4)
    if (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(4),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(4),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(4),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(4),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(4),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(4),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(4),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(4),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(4),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(4),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(4),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(4),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(4),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(4),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(4),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(4),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(4),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(4),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(4),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaTrentino.workplaces_percent_change_from_baseline(i)) && (TabellaTrentino.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(4),'FaceColor',map20(20,:));
        hold on;
    end
    % Veneto (5)
    if (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(5),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(5),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(5),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(5),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(5),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(5),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(5),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(5),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(5),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(5),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(5),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(5),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(5),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(5),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(5),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(5),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(5),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(5),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(5),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaVeneto.workplaces_percent_change_from_baseline(i)) && (TabellaVeneto.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(5),'FaceColor',map20(20,:));
        hold on;
    end
    % Friuli (6)
    if (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(6),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(6),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(6),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(6),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(6),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(6),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(6),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(6),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(6),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(6),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(6),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(6),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(6),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(6),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(6),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(6),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(6),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(6),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(6),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaFriuli.workplaces_percent_change_from_baseline(i)) && (TabellaFriuli.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(6),'FaceColor',map20(20,:));
        hold on;
    end
    % Liguria(7)
    if (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(7),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(7),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(7),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(7),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(7),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(7),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(7),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(7),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(7),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(7),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(7),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(7),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(7),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(7),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(7),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(7),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(7),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(7),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(7),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaLiguria.workplaces_percent_change_from_baseline(i)) && (TabellaLiguria.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(7),'FaceColor',map20(20,:));
        hold on;
    end
    % Emilia (8)
    if (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(8),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(8),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(8),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(8),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(8),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(8),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(8),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(8),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(8),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(8),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(8),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(8),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(8),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(8),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(8),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(8),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(8),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(8),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(8),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaEmilia.workplaces_percent_change_from_baseline(i)) && (TabellaEmilia.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(8),'FaceColor',map20(20,:));
        hold on;
    end
    % Toscana (9)
    if (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(9),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(9),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(9),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(9),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(9),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(9),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(9),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(9),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(9),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(9),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(9),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(9),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(9),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(9),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(9),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(9),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(9),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(9),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(9),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaToscana.workplaces_percent_change_from_baseline(i)) && (TabellaToscana.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(9),'FaceColor',map20(20,:));
        hold on;
    end
     % Umbria (10)
    if (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(10),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(10),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(10),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(10),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(10),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(10),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(10),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(10),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(10),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(10),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(10),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(10),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(10),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(10),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(10),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(10),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(10),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(10),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(10),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaUmbria.workplaces_percent_change_from_baseline(i)) && (TabellaUmbria.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(10),'FaceColor',map20(20,:));
        hold on;
    end
    % Marche (11)
    if (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(11),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(11),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(11),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(11),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(11),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(11),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(11),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(11),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(11),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(11),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(11),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(11),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(11),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(11),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(11),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(11),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(11),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(11),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(11),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaMarche.workplaces_percent_change_from_baseline(i)) && (TabellaMarche.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(11),'FaceColor',map20(20,:));
        hold on;
    end
    % Lazio (12)
    if (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(12),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(12),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(12),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(12),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(12),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(12),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(12),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(12),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(12),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(12),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(12),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(12),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(12),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(12),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(12),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(12),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(12),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(12),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(12),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaLazio.workplaces_percent_change_from_baseline(i)) && (TabellaLazio.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(12),'FaceColor',map20(20,:));
        hold on;
    end
    % Abruzzo (13)
    if (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(4),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(13),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(13),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(13),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(13),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(13),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(13),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(13),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(13),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(13),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(13),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(13),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(13),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(13),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(13),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(13),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(13),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(13),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(13),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaAbruzzo.workplaces_percent_change_from_baseline(i)) && (TabellaAbruzzo.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(13),'FaceColor',map20(20,:));
        hold on;
    end
    % Molise (14)
    if (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(14),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(14),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(14),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(14),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(14),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(14),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(14),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(14),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(14),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(14),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(14),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(14),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(14),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(14),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(14),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(14),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(14),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(14),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(14),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaMolise.workplaces_percent_change_from_baseline(i)) && (TabellaMolise.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(14),'FaceColor',map20(20,:));
        hold on;
    end
    % Campania (15)
    if (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(15),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(15),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(15),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(15),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(15),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(15),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(15),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(15),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(15),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(15),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(15),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(15),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(15),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(15),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(15),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(15),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(15),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(15),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(15),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaCampania.workplaces_percent_change_from_baseline(i)) && (TabellaCampania.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(15),'FaceColor',map20(20,:));
        hold on;
    end
    % Puglia (16)
    if (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(16),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(16),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(16),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(16),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(16),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(16),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(16),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(16),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(16),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(16),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(16),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(16),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(16),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(16),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(16),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(16),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(16),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(16),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(16),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaPuglia.workplaces_percent_change_from_baseline(i)) && (TabellaPuglia.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(16),'FaceColor',map20(20,:));
        hold on;
    end
    % Basilicata (17)
    if (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(17),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(17),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(17),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(17),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(17),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(17),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(17),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(17),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(17),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(17),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(17),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(17),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(17),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(17),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(17),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(17),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(17),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(17),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(17),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaBasilicata.workplaces_percent_change_from_baseline(i)) && (TabellaBasilicata.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(17),'FaceColor',map20(20,:));
        hold on;
    end
    % Calabria (18)
    if (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(18),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(18),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(18),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(18),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(18),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(18),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(18),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(18),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(18),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(18),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(18),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(18),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(18),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(18),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(18),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(18),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(18),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(18),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(18),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaCalabria.workplaces_percent_change_from_baseline(i)) && (TabellaCalabria.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(18),'FaceColor',map20(20,:));
        hold on;
    end
    % Sicilia (19)
    if (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(19),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(19),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(19),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(19),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(19),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(19),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(19),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(19),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(19),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(19),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(19),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(19),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(19),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(19),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(19),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(19),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(19),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(19),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(19),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaSicilia.workplaces_percent_change_from_baseline(i)) && (TabellaSicilia.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(19),'FaceColor',map20(20,:));
        hold on;
    end
        % Sardegna (20)
    if (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(2))
        mapshow(I(20),'FaceColor',map20(1,:));
        hold on;
    elseif((ValGrocReg(2)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(3)))
        mapshow(I(20),'FaceColor',map20(2,:));
        hold on;
    elseif((ValGrocReg(3)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(4)))
        mapshow(I(20),'FaceColor',map20(3,:));
        hold on;
    elseif((ValGrocReg(4)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(5)))
        mapshow(I(20),'FaceColor',map20(4,:));
        hold on;
    elseif((ValGrocReg(5)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(6)))
        mapshow(I(20),'FaceColor',map20(5,:));
        hold on;
    elseif((ValGrocReg(6)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(7)))
        mapshow(I(20),'FaceColor',map20(6,:));
        hold on;
    elseif((ValGrocReg(7)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(8)))
        mapshow(I(20),'FaceColor',map20(7,:));
        hold on;
    elseif((ValGrocReg(8)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(9)))
        mapshow(I(20),'FaceColor',map20(8,:));
        hold on;
    elseif((ValGrocReg(9)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(10)))
        mapshow(I(20),'FaceColor',map20(9,:));
        hold on;
    elseif((ValGrocReg(10)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(11)))
        mapshow(I(20),'FaceColor',map20(10,:));
        hold on;
    elseif((ValGrocReg(11)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(12)))
        mapshow(I(20),'FaceColor',map20(11,:));
        hold on;
    elseif((ValGrocReg(12)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(13)))
        mapshow(I(20),'FaceColor',map20(12,:));
        hold on;
    elseif((ValGrocReg(13)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(14)))
        mapshow(I(20),'FaceColor',map20(13,:));
        hold on;
    elseif((ValGrocReg(14)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(15)))
        mapshow(I(20),'FaceColor',map20(14,:));
        hold on;
    elseif((ValGrocReg(15)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(16)))
        mapshow(I(20),'FaceColor',map20(15,:));
        hold on;
    elseif((ValGrocReg(16)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(17)))
        mapshow(I(20),'FaceColor',map20(16,:));
        hold on;
    elseif((ValGrocReg(17)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(18)))
        mapshow(I(20),'FaceColor',map20(17,:));
        hold on;
    elseif((ValGrocReg(18)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(19)))
        mapshow(I(20),'FaceColor',map20(18,:));
        hold on;
    elseif((ValGrocReg(19)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<ValGrocReg(20)))
        mapshow(I(20),'FaceColor',map20(19,:));
        hold on;
    elseif((ValGrocReg(20)<=TabellaSardegna.workplaces_percent_change_from_baseline(i)) && (TabellaSardegna.workplaces_percent_change_from_baseline(i)<=ValGrocReg(21)))
        mapshow(I(20),'FaceColor',map20(20,:));
        hold on;
    end
    axis off;
    saveas(gcf,"./ImmaginiItaliaCompleta/ItaliaWorkplaces/ItaliaWorkplaces.jpg");
    filename = sprintf('./ImmaginiItaliaCompleta/ItaliaWorkplaces/ItaliaWorkplaces.jpg');
    thisimage = imread(filename);
    imwrite(thisimage,sprintf('./ImmaginiItaliaCompleta/ItaliaWorkplaces/ItaliaWorkplaces%d.jpg',i));
end
writerObj = VideoWriter('ItaliaWorkplaces.avi');
open(writerObj);
for K = 1 : 686
  filename = sprintf('./ImmaginiItaliaCompleta/ItaliaWorkplaces/ItaliaWorkplaces%d.jpg', K);
  thisimage = imread(filename);
  writeVideo(writerObj, thisimage);
end
close(writerObj);
 % load the video.
obj = VideoReader('ItaliaWorkplaces.avi' );  
  
% Write in new variable
obj2= VideoWriter('ItaliaWorkplaces.mp4','MPEG-4');    
  
% decrease framerate 
obj2.FrameRate = 10;              
open(obj2);
  
% for reading frames one by one
while hasFrame(obj)              
    k = readFrame(obj); 
  
    % write the frames in obj2.         
    obj2.writeVideo(k);          
end
  
close(obj2);
outputFolder = pwd; % Current folder.
	outputFileName = fullfile(outputFolder, 'ItaliaWorkplaces.mp4');
	writerObj = VideoWriter(outputFileName, 'MPEG-4');
	open(writerObj);
    close(writerObj);

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
mapshow(I(14),'Facecolor',map20(14,:));
mapshow(I(15),'Facecolor',map20(15,:));
mapshow(I(16),'Facecolor',map20(16,:));
mapshow(I(17),'Facecolor',map20(17,:));
mapshow(I(18),'Facecolor',map20(18,:));
mapshow(I(19),'Facecolor',map20(19,:));
mapshow(I(20),'Facecolor',map20(20,:));