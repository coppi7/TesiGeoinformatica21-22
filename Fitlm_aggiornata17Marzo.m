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
%% Preallocation of table to save parameters of interest
sz = [28 8];
VarTypes = ["string" "double" "double" "double" "double" "double" "string" "string"];
VarNamesConfronti = ["Comparison" "a" "b" "c" "d" "x0" "model" "approximation"];
VarCategoriesConfronti = ["walking vs driving" "walking vs retail" "walking vs groc_and_pharm"...
    "walking vs parks" "walking vs transit stations" "walking vs workplaces" "walking vs residential" ...
    "driving vs retail" "driving vs groc_and_pharm" "driving vs parks" ...
    "driving vs transit stations" "driving vs workplaces" "driving vs residential" ...
    "retail vs groc_and_pharm" "retail vs parks" "retail vs transit stations" ...
    "retail vs workplaces" "retail vs residential" "groc_and_pharm vs parks" "groc_and_pharm vs transit stations"...
    "groc_and_pharm vs workplaces" "groc_and_pharm vs residential" "parks vs transit stations" "parks vs workplaces"...
    "parks vs residential" "transit stations vs workplaces" "transit stations vs residential" "workplaces vs residential"];
TabellaConfrontiAIC = table('Size',sz, 'VariableTypes',VarTypes,'VariableNames',VarNamesConfronti);
for i=1:height(TabellaConfrontiAIC)
    TabellaConfrontiAIC.Comparison(i)= VarCategoriesConfronti(i);
end
%% Apple Walking vs Apple Driving
f21=figure("Name","Apple Walking vs Apple Driving");
% 'true' parameters
a=0; a_lo=-100; a_hi=100; 
b=1; b_lo=-10; b_hi=10;
d=1; d_lo=-10; d_hi=10;
x0=0; x0_lo=-100; x0_hi=100;
c=a+(b-d)*x0; c_lo=-100; c_hi=100; 
niter=57;
np=683;

data = [ArrayA(:,8) ArrayA(:,7)];
% fit a linear model
fun=@(pars)eval_linear(pars,data);
p0=[a b];
lb=[a_lo b_lo];
ub=[a_hi b_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_linear,RSS_linear]=run(ms,problem,niter);
AIC_linear=2*(numel(pars_linear)+1)+np*log(RSS_linear);

figure(f21)
subplot(231)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
colormap=lines(2); 
col=colormap(2,:);
plot([min(ArrayA(:,8)) max(ArrayA(:,8))],linear(pars_linear,[min(ArrayA(:,8)) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit a piece-wise linear model with fixed splitting point
fun=@(pars)eval_piecewise_fsp(pars,data,x0);
p0=[a b d];
lb=[a_lo b_lo d_lo];
ub=[a_hi b_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise_fsp,RSS_piecewise_fsp]=run(ms,problem,niter);
AIC_piecewise_fsp=2*(numel(pars_piecewise_fsp)+1)+np*log(RSS_piecewise_fsp);

figure(f21)
subplot(232)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) x0 max(ArrayA(:,8))],piecewise_fsp(pars_piecewise_fsp,[min(ArrayA(:,8)) x0 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit a piece-wise linear model
fun=@(pars)eval_piecewise(pars,data);
p0=[a b d x0];
lb=[a_lo b_lo d_lo x0_lo];
ub=[a_hi b_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_piecewise,RSS_piecewise]=run(ms,problem,niter);
AIC_piecewise=2*(numel(pars_piecewise)+1)+np*log(RSS_piecewise);

figure(f21)
subplot(233)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))],piecewise(pars_piecewise,[min(ArrayA(:,8)) pars_piecewise(4) max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% fit two disjoint linear models with fixed splitting point
fun=@(pars)eval_disjoint_fsp(pars,data,x0);
p0=[a b c d];
lb=[a_lo b_lo c_lo d_lo];
ub=[a_hi b_hi c_hi d_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint_fsp,RSS_disjoint_fsp]=run(ms,problem,niter);
AIC_disjoint_fsp=2*(numel(pars_disjoint_fsp)+1)+np*log(RSS_disjoint_fsp);

figure(f21)
subplot(234)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) x0],disjoint_fsp(pars_disjoint_fsp,[min(ArrayA(:,8)) x0],x0),'Color',col,'LineWidth',2)
xs=sort(ArrayA(:,8));
x1=xs(find(xs>x0,1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint_fsp(pars_disjoint_fsp,[x1 max(ArrayA(:,8))],x0),'Color',col,'LineWidth',2)

% fit two disjoint linear models
fun=@(pars)eval_disjoint(pars,data);
p0=[a b c d x0];
lb=[a_lo b_lo c_lo d_lo x0_lo];
ub=[a_hi b_hi c_hi d_hi x0_hi];
problem=createOptimProblem('fmincon','objective',fun,'x0',p0,'lb',lb,'ub',ub);
ms=MultiStart;
[pars_disjoint,RSS_disjoint]=run(ms,problem,niter);
AIC_disjoint=2*(numel(pars_disjoint)+1)+np*log(RSS_disjoint);

figure(f21)
subplot(235)
scatter(ArrayA(:,8),ArrayA(:,7),'filled')
hold on
plot([min(ArrayA(:,8)) pars_disjoint(5)],disjoint(pars_disjoint,[min(ArrayA(:,8)) pars_disjoint(5)]),'Color',col,'LineWidth',2)
x1=xs(find(xs>pars_disjoint(5),1,'first'));
plot([x1 max(ArrayA(:,8))],disjoint(pars_disjoint,[x1 max(ArrayA(:,8))]),'Color',col,'LineWidth',2)

% evaluate Delta_AIC scores
AIC=[AIC_linear AIC_piecewise_fsp AIC_piecewise AIC_disjoint_fsp AIC_disjoint];
Delta_AIC=AIC-min(AIC);
if Delta_AIC(1)==0
    TabellaConfrontiAIC.model(16) = "linear";
    TabellaConfrontiAIC.a(16) = pars_linear(1);
    TabellaConfrontiAIC.b(16) = pars_linear(2);
    TabellaConfrontiAIC.c(16) = nan;
    TabellaConfrontiAIC.d(16) = nan;
    TabellaConfrontiAIC.x0(16) = nan;
elseif Delta_AIC(2)==0
    TabellaConfrontiAIC.model(16) = "piecewise_fsp";
    TabellaConfrontiAIC.a(16) = pars_piecewise_fsp(1);
    TabellaConfrontiAIC.b(16) = pars_piecewise_fsp(2);
    TabellaConfrontiAIC.d(16) = pars_piecewise_fsp(3);
    TabellaConfrontiAIC.x0(16) = 0;
    TabellaConfrontiAIC.c(16) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(3)==0
    TabellaConfrontiAIC.model(16) = "piecewise";
    TabellaConfrontiAIC.a(16) = pars_piecewise(1);
    TabellaConfrontiAIC.b(16) = pars_piecewise(2);
    TabellaConfrontiAIC.d(16) = pars_piecewise(3);
    TabellaConfrontiAIC.x0(16) = pars_piecewise(4);
    TabellaConfrontiAIC.c(16) = TabellaConfrontiAIC.a(1)+(TabellaConfrontiAIC.b(1)-TabellaConfrontiAIC.d(1))*TabellaConfrontiAIC.x0(1);
elseif Delta_AIC(4)==0
    TabellaConfrontiAIC.model(16) = "disjoint_fsp";
    TabellaConfrontiAIC.a(16) = pars_disjoint(1);
    TabellaConfrontiAIC.b(16) = pars_disjoint(2);
    TabellaConfrontiAIC.c(16) = pars_disjoint(3);
    TabellaConfrontiAIC.d(16) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(16) = 0;
elseif Delta_AIC(5)==0
    TabellaConfrontiAIC.model(16) = "disjoint";
    TabellaConfrontiAIC.a(16) = pars_disjoint(1);
    TabellaConfrontiAIC.b(16) = pars_disjoint(2);
    TabellaConfrontiAIC.c(16) = pars_disjoint(3);
    TabellaConfrontiAIC.d(16) = pars_disjoint(4);
    TabellaConfrontiAIC.x0(16) = pars_disjoint(5);
end

if Delta_AIC(1)<=2
    TabellaConfrontiAIC.approximation(16) = "(linear)";
elseif Delta_AIC(2)<=2
    TabellaConfrontiAIC.approximation(16) = "(piecewise_fsp)";
elseif Delta_AIC(3)<=2
    TabellaConfrontiAIC.approximation(16) = "(piecewise)";
elseif Delta_AIC(4)<=2
    TabellaConfrontiAIC.approximation(16) = "(disjoint_fsp)";
end

figure(f21)
subplot(236)
bar(log2(Delta_AIC))
dmin=floor(min(log2(Delta_AIC(Delta_AIC>0))));
dmax=ceil(max(log2(Delta_AIC)));
set(gca,'XTickLabels',{'linear','piecewise-fsp','piecewise','disjoint-fsp','disjoint'})
set(gca,'YLim',[dmin dmax],'YTick',dmin:dmax,'YTickLabels',2.^(dmin:dmax))
ylabel('\DeltaAIC')
grid on
box off
c_piecewise=pars_piecewise(1)+(pars_piecewise(2)-pars_piecewise(3))*pars_piecewise(4);
%% Linear Regression Apple Walking vs Apple Driving
tbl1 = table(MatriceA.walking,MatriceA.driving,'VariableNames',{'walking','driving'});
lm1 = fitlm(tbl1,'linear');
figure();
plot(lm1);
hold on;
plot(ArrayA(:,7),pars_piecewise(2)*ArrayA(:,7)+pars_piecewise(1));
hold on;
plot(ArrayA(:,7),pars_piecewise(3)*ArrayA(:,7)+c_piecewise);
figure();
plot(lm1);
hold on;
plot(ArrayA(:,7),pars_disjoint(2)*ArrayA(:,7)+pars_disjoint(1));
hold on;
plot(ArrayA(:,7),pars_disjoint(4)*ArrayA(:,7)+pars_disjoint(3));
y1 = pars_disjoint(2)*pars_disjoint(5)+pars_disjoint(1);
y2 = pars_disjoint(4)*pars_disjoint(5)+pars_disjoint(3);
%%
function RSS=eval_linear(pars,data)
    x=data(:,1);
    y=data(:,2);

    y_hat=linear(pars,x);
    
    RSS=sum((y-y_hat).^2);

%     figure(101)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=linear(pars,x)
    a=pars(1);
    b=pars(2);
    
    y_hat=a+b*x;
end

function RSS=eval_piecewise_fsp(pars,data,x0)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=piecewise_fsp(pars,x,x0);

    RSS=sum((y-y_hat).^2);

%     figure(102)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=piecewise_fsp(pars,x,x0)
    a=pars(1);
    b=pars(2);
    d=pars(3);
    c=a+(b-d)*x0;
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_piecewise(pars,data)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=piecewise(pars,x);

    RSS=sum((y-y_hat).^2);

%     figure(103)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=piecewise(pars,x)
    a=pars(1);
    b=pars(2);
    d=pars(3);
    x0=pars(4);
    c=a+(b-d)*x0;
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_disjoint_fsp(pars,data,x0)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=disjoint_fsp(pars,x,x0);

    RSS=sum((y-y_hat).^2);

%     figure(104)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=disjoint_fsp(pars,x,x0)
    a=pars(1);
    b=pars(2);
    c=pars(3);
    d=pars(4);
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end

function RSS=eval_disjoint(pars,data)
    x=data(:,1);
    y=data(:,2);
      
    y_hat=disjoint(pars,x);

    RSS=sum((y-y_hat).^2);

%     figure(105)
%     scatter(x,y,'filled')
%     hold on
%     scatter(x,y_hat,'filled')
%     hold off
%     drawnow
end

function y_hat=disjoint(pars,x)
    a=pars(1);
    b=pars(2);
    c=pars(3);
    d=pars(4);
    x0=pars(5);
    
    y_hat=nan(size(x));
    mask=x<=x0;
    y_hat(mask)=a+b*x(mask);
    mask=x>x0;
    y_hat(mask)=c+d*x(mask);
end