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
%% Setting the parameter of the dates
startDate = datetime(cellstr(TabellaA.date(1)));
endDate = datetime(cellstr(TabellaA.date(height(TabellaA))));
date = (startDate:1:endDate);
date = datetime(date,"format","yyyy-MM-dd");
%% Setting the table used
TabellaBConfrontoGoogle = TabellaB;
for i=1:height(TabellaB)
    TabellaBConfrontoGoogle.driving(i)= TabellaBConfrontoGoogle.driving(i)-100;
    TabellaBConfrontoGoogle.walking(i)= TabellaBConfrontoGoogle.walking(i)-100;
end
TabellaGoogleApple = TabellaG;
TabellaTempConfrontoGoogle = TabellaBConfrontoGoogle(TabellaBConfrontoGoogle.date>=datetime("15-02-2020","Format","dd-MM-yyyy"),:);
lista = TabellaB.alternative_name(1:length(date):height(TabellaB));
[indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
risposta = string(lista(indx));
risposta = cellstr(risposta);
if risposta=="Piemonte"
    % Piemonte (1)
    
    TabellaPiemonte = TabellaG(TabellaG.sub_region_1=="Piedmont",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaPiemonte(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaPiemonte.date(j)
                TabellaPiemonte(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaPiemonte(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaPiemonte.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaPiemonte.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaPiemonte.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaPiemonte(:,10:15);
    MatriceA(:,7:8) = TabellaPiemonte(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaPiemonte.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaPiemonte.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Valle d'Aosta"
    % Valle d'Aosta (2)
    
    TabellaAosta = TabellaG(TabellaG.sub_region_1=="Aosta",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaAosta(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaAosta.date(j)
                TabellaAosta(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaAosta(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaAosta.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaAosta.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaAosta.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaAosta(:,10:15);
    MatriceA(:,7:8) = TabellaAosta(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaAosta.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaAosta.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Lombardia"
    % Lombardia (3)
    
    TabellaLombardia = TabellaG(TabellaG.sub_region_1=="Lombardy",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaLombardia(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaLombardia.date(j)
                TabellaLombardia(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaLombardia(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaLombardia.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaLombardia.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaLombardia.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaLombardia(:,10:15);
    MatriceA(:,7:8) = TabellaLombardia(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaLombardia.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaLombardia.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Trentino Alto Adige"
    % Trentino Alto Adige (4)
    
    TabellaTrentino = TabellaG(TabellaG.sub_region_1=="Trentino-South Tyrol",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaTrentino(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaTrentino.date(j)
                TabellaTrentino(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaTrentino(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaTrentino.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaTrentino.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaTrentino.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaTrentino(:,10:15);
    MatriceA(:,7:8) = TabellaTrentino(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaTrentino.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaTrentino.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Veneto"
    % Veneto (5)
    
    TabellaVeneto = TabellaG(TabellaG.sub_region_1=="Veneto",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaVeneto(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaVeneto.date(j)
                TabellaVeneto(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaVeneto(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaVeneto.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaVeneto.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaVeneto.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaVeneto(:,10:15);
    MatriceA(:,7:8) = TabellaVeneto(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaVeneto.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaVeneto.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Friuli venezia Giulia"
    % Friuli venezia Giulia (6)
    
    TabellaFriuli = TabellaG(TabellaG.sub_region_1=="Friuli-Venezia Giulia",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaFriuli(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaFriuli.date(j)
                TabellaFriuli(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaFriuli(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaFriuli.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaFriuli.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaFriuli.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaFriuli(:,10:15);
    MatriceA(:,7:8) = TabellaFriuli(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaFriuli.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaFriuli.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Liguria"
    % Liguria (7)
    
    TabellaLiguria = TabellaG(TabellaG.sub_region_1=="Liguria",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaLiguria(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaLiguria.date(j)
                TabellaLiguria(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaLiguria(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaLiguria.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaLiguria.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaLiguria.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaLiguria(:,10:15);
    MatriceA(:,7:8) = TabellaLiguria(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaLiguria.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaLiguria.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Emilia Romagna"
    % Emilia-Romagna (8)
    
    TabellaEmilia = TabellaG(TabellaG.sub_region_1=="Emilia-Romagna",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaEmilia(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaEmilia.date(j)
                TabellaEmilia(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaEmilia(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaEmilia.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaEmilia.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaEmilia.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaEmilia(:,10:15);
    MatriceA(:,7:8) = TabellaEmilia(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaEmilia.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaEmilia.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Toscana"
    % Toscana (9)
    
    TabellaToscana = TabellaG(TabellaG.sub_region_1=="Tuscany",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaToscana(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaToscana.date(j)
                TabellaToscana(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaToscana(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaToscana.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaToscana.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaToscana.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaToscana(:,10:15);
    MatriceA(:,7:8) = TabellaToscana(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaToscana.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaToscana.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Umbria"
    % Umbria (10)
    
    TabellaUmbria = TabellaG(TabellaG.sub_region_1=="Umbria",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaUmbria(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaUmbria.date(j)
                TabellaUmbria(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaUmbria(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaUmbria.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaUmbria.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaUmbria.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaUmbria(:,10:15);
    MatriceA(:,7:8) = TabellaUmbria(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaUmbria.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaUmbria.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Marche"
    % Marche (11)
    
    TabellaMarche = TabellaG(TabellaG.sub_region_1=="Marche",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaMarche(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaMarche.date(j)
                TabellaMarche(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaMarche(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaMarche.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaMarche.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaMarche.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaMarche(:,10:15);
    MatriceA(:,7:8) = TabellaMarche(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaMarche.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaMarche.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Lazio"
    % Lazio (12)
    
    TabellaLazio = TabellaG(TabellaG.sub_region_1=="Lazio",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaLazio(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaLazio.date(j)
                TabellaLazio(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaLazio(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaLazio.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaLazio.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaLazio.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaLazio(:,10:15);
    MatriceA(:,7:8) = TabellaLazio(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaLazio.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaLazio.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Abruzzo"
    % Abruzzo (13)
    
    TabellaAbruzzo = TabellaG(TabellaG.sub_region_1=="Abruzzo",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaAbruzzo(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaAbruzzo.date(j)
                TabellaAbruzzo(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaAbruzzo(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaAbruzzo.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaAbruzzo.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaAbruzzo.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaAbruzzo(:,10:15);
    MatriceA(:,7:8) = TabellaAbruzzo(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaAbruzzo.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaAbruzzo.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Molise"
    % Molise (14)
    
    TabellaMolise = TabellaG(TabellaG.sub_region_1=="Molise",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaMolise(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaMolise.date(j)
                TabellaMolise(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaMolise(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaMolise.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaMolise.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaMolise.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaMolise(:,10:15);
    MatriceA(:,7:8) = TabellaMolise(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaMolise.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaMolise.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Campania"
    % Campania (15)
    
    TabellaCampania = TabellaG(TabellaG.sub_region_1=="Campania",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaCampania(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaCampania.date(j)
                TabellaCampania(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaCampania(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaCampania.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaCampania.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaCampania.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaCampania(:,10:15);
    MatriceA(:,7:8) = TabellaCampania(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaCampania.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaCampania.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Puglia"
    % Puglia (16)
    
    TabellaPuglia = TabellaG(TabellaG.sub_region_1=="Apulia",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaPuglia(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaPuglia.date(j)
                TabellaPuglia(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaPuglia(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaPuglia.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaPuglia.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaPuglia.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaPuglia(:,10:15);
    MatriceA(:,7:8) = TabellaPuglia(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaPuglia.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaPuglia.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Basilicata"
    % Basilicata (17)
    
    TabellaBasilicata = TabellaG(TabellaG.sub_region_1=="Basilicata",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaBasilicata(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaBasilicata.date(j)
                TabellaBasilicata(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaBasilicata(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaBasilicata.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaBasilicata.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaBasilicata.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaBasilicata(:,10:15);
    MatriceA(:,7:8) = TabellaBasilicata(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaBasilicata.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaBasilicata.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Calabria"
    % Calabria (18)
    
    TabellaCalabria = TabellaG(TabellaG.sub_region_1=="Calabria",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaCalabria(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaCalabria.date(j)
                TabellaCalabria(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaCalabria(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaCalabria.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaCalabria.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaCalabria.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaCalabria(:,10:15);
    MatriceA(:,7:8) = TabellaCalabria(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaCalabria.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaCalabria.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Sicilia"
    % Sicilia (19)
    
    TabellaSicilia = TabellaG(TabellaG.sub_region_1=="Sicily",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaSicilia(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaSicilia.date(j)
                TabellaSicilia(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaSicilia(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaSicilia.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaSicilia.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaSicilia.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaSicilia(:,10:15);
    MatriceA(:,7:8) = TabellaSicilia(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaSicilia.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaSicilia.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
elseif risposta=="Sardegna"
    % Sardegna (20)
    
    TabellaSardegna = TabellaG(TabellaG.sub_region_1=="Sardinia",:);
    j=1;
    for i=1:height(TabellaGoogleApple)
        if TabellaTempConfrontoGoogle.alternative_name(i)==""+risposta+""
            TabellaSardegna(:,16)=TabellaTempConfrontoGoogle.alternative_name(i);
            if TabellaTempConfrontoGoogle.date(i)==TabellaSardegna.date(j)
                TabellaSardegna(j,17)=TabellaTempConfrontoGoogle(i,7);
                TabellaSardegna(j,18)=TabellaTempConfrontoGoogle(i,8);
                if i~=height(TabellaGoogleApple)
                    j=j+1;
                end
            end
        end
    end
    TabellaSardegna.Properties.VariableNames(16)=TabellaTempConfrontoGoogle.Properties.VariableNames(3);
    TabellaSardegna.Properties.VariableNames(17)=TabellaTempConfrontoGoogle.Properties.VariableNames(7);
    TabellaSardegna.Properties.VariableNames(18)=TabellaTempConfrontoGoogle.Properties.VariableNames(8);
    
    MatriceA(:,1:6) = TabellaSardegna(:,10:15);
    MatriceA(:,7:8) = TabellaSardegna(:,17:18);
    MatriceA.Properties.VariableNames(7)=TabellaSardegna.Properties.VariableNames(17);
    MatriceA.Properties.VariableNames(8)=TabellaSardegna.Properties.VariableNames(18);
    ArrayA1=table2array(MatriceA);
    ArrayA=rmmissing(ArrayA1);
end
%% Linear Regression Apple_driving vs retail
f1=figure("Name","Apple Driving vs Google categories");
tbl1 = table(MatriceA.driving,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'driving','retail'});
lm1 = fitlm(tbl1,'linear');
figure(f1);
subplot(231)
plot(lm1);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs grocery and pharmacy
tbl2 = table(MatriceA.driving,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'driving','grocery and pharmacy'});
lm2 = fitlm(tbl2,'linear');
figure(f1);
subplot(232)
plot(lm2);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs parks
tbl3 = table(MatriceA.driving,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'driving','parks'});
lm3 = fitlm(tbl3,'linear');
figure(f1);
subplot(233)
plot(lm3);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs transit stations
tbl4 = table(MatriceA.driving,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'driving','transit stations'});
lm4 = fitlm(tbl4,'linear');
figure(f1);
subplot(234)
plot(lm4);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs workplaces
tbl5 = table(MatriceA.driving,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'driving','workplaces'});
lm5 = fitlm(tbl5,'linear');
figure(f1);
subplot(235)
plot(lm5);
set(gca,'FontSize',20);
%% Linear Regression Apple_driving vs residential
tbl6 = table(MatriceA.driving,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'driving','residential'});
lm6 = fitlm(tbl6,'linear');
figure(f1);
subplot(236)
plot(lm6);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs retail
f2=figure("Name","Apple Walking vs Google categories");
tbl7 = table(MatriceA.walking,MatriceA.retail_and_recreation_percent_change_from_baseline,'VariableNames',{'walking','retail'});
lm7 = fitlm(tbl7,'linear');
figure(f2);
subplot(231)
plot(lm7);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs grocery and pharmacy
tbl8 = table(MatriceA.walking,MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'walking','grocery and pharmacy'});
lm8 = fitlm(tbl8,'linear');
figure(f2);
subplot(232)
plot(lm8);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs parks
tbl9 = table(MatriceA.walking,MatriceA.parks_percent_change_from_baseline,'VariableNames',{'walking','parks'});
lm9 = fitlm(tbl9,'linear');
figure(f2);
subplot(233)
plot(lm9);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs transit stations
tbl10 = table(MatriceA.walking,MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'walking','transit stations'});
lm10 = fitlm(tbl10,'linear');
figure(f2);
subplot(234)
plot(lm10);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs workplaces
tbl11 = table(MatriceA.walking,MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'walking','workplaces'});
lm11 = fitlm(tbl11,'linear');
figure(f2);
subplot(235)
plot(lm11);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs residential
tbl12 = table(MatriceA.walking,MatriceA.residential_percent_change_from_baseline,'VariableNames',{'walking','residential'});
lm12 = fitlm(tbl12,'linear');
figure(f2);
subplot(236)
plot(lm12);
set(gca,'FontSize',20);
%% Linear Regression Apple_walking vs Apple_driving
f4 = figure("Name","Apple categories vs Apple categories");
tbl19 = table(MatriceA.walking,MatriceA.driving,'VariableNames',{'walking','driving'});
lm19 = fitlm(tbl19,'linear');
figure(f4);
plot(lm19);
set(gca,'FontSize',20);
figure()
normplot(lm19.Residuals.Raw);
set(gca,'FontSize',20);
f3 = figure("Name","Apple categories vs Apple categories");
figure(f3)
subplot(211)
plotResiduals(lm19);
set(gca,'FontSize',20);
subplot(212)
plotResiduals(lm19,"fitted");
set(gca,'FontSize',20);
%% Linear Regression retail vs grocery
f5=figure("Name","Google categories vs Google categories");
tbl22 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.grocery_and_pharmacy_percent_change_from_baseline,'VariableNames',{'retail','grocery'});
lm22 = fitlm(tbl22,'linear');
figure(f5);
subplot(231)
plot(lm22);
set(gca,'FontSize',20);
%% Linear Regression retail vs parks
tbl23 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.parks_percent_change_from_baseline,'VariableNames',{'retail','parks'});
lm23 = fitlm(tbl23,'linear');
figure(f5);
subplot(232)
plot(lm23);
set(gca,'FontSize',20);
%% Linear Regression retail vs transit stations
tbl24 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.transit_stations_percent_change_from_baseline,'VariableNames',{'retail','transit stations'});
lm24 = fitlm(tbl24,'linear');
figure(f5);
subplot(233)
plot(lm24);
set(gca,'FontSize',20);
%% Linear Regression retail vs workplaces
tbl25 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.workplaces_percent_change_from_baseline,'VariableNames',{'retail','workplaces'});
lm25 = fitlm(tbl25,'linear');
figure(f5);
subplot(234)
plot(lm25);
set(gca,'FontSize',20);
%% Linear Regression retail vs residential
tbl26 = table(MatriceA.retail_and_recreation_percent_change_from_baseline, MatriceA.residential_percent_change_from_baseline,'VariableNames',{'retail','residential'});
lm26 = fitlm(tbl26,'linear');
figure(f5);
subplot(235)
plot(lm26);
set(gca,'FontSize',20);