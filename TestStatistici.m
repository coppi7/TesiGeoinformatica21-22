clearvars;
close all;
addpath('./DatabaseLocale/');
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
    %% Regression linear model for region Apple data
g=1;
while g>0
    lista = TabellaB.alternative_name(1:length(date):height(TabellaB));
    [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
    risposta = string(lista(indx));
    risposta = cellstr(risposta);
    TabellaTemp = TabellaB(TabellaB.alternative_name==""+risposta+"",:);
    MatriceB = table(TabellaTemp.driving,TabellaTemp.walking);
    MatriceB.Properties.VariableNames(1)=TabellaB.Properties.VariableNames(7);
    MatriceB.Properties.VariableNames(2)=TabellaB.Properties.VariableNames(8);
    ArrayB1=table2array(MatriceB);
    ArrayB=rmmissing(ArrayB1);
    %% Plot the cities of the region, if present
    TabellaTempC = TabellaC(TabellaC.region==string(TabellaTemp.name(1)),:);
    MatriceC = table(TabellaTempC.driving,TabellaTempC.walking);
    MatriceC.Properties.VariableNames(1)=TabellaC.Properties.VariableNames(7);
    MatriceC.Properties.VariableNames(2)=TabellaC.Properties.VariableNames(8);
    ArrayC0=table2array(MatriceC);
    ArrayC=rmmissing(ArrayC0);

    if isempty(ArrayB)
        fprintf("Non sono presenti sufficienti dati per la regione \n");
        risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
        risposta2=risposta{1};
        if risposta2=="Y"
            %% Clear Temporary variables
            clear TabellaTemp; clear MatriceB; clear ArrayB1; clear ArrayB;
            clear lm; clear tbl; % Parameters of linear model
            clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
            clear appoggio; clear res; clear media;% Parameters of ANOVA - part 2
        else
            g=0;
            %% Clear Temporary variables
            clear TabellaTemp; clear MatriceB; clear ArrayB1; clear ArrayB;
            clear lm; clear tbl; % Parameters of linear model
            clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
            clear appoggio; clear res; clear media;% Parameters of ANOVA - part 2
        end
    else
        tbl = table(MatriceB.driving,MatriceB.walking,'VariableNames',{'driving','walking'});
        lm = fitlm(tbl,'linear');
        figure();
        plot(lm);
        if height(TabellaTempC)~=0
            if height(TabellaTempC)>length(date)
                j=1;
                for i=1:length(date)
                    Tabella1(i,:)=TabellaTempC(i,:);
                end
                for i=length(date)+1:height(TabellaTempC)
                    Tabella2(j,:)=TabellaTempC(i,:);
                    j=j+1;
                end
                MatriceC1 = table(Tabella1.driving,Tabella1.walking);
                MatriceC1.Properties.VariableNames(1)=TabellaC.Properties.VariableNames(7);
                MatriceC1.Properties.VariableNames(2)=TabellaC.Properties.VariableNames(8);
                MatriceC2 = table(Tabella2.driving,Tabella2.walking);
                MatriceC2.Properties.VariableNames(1)=TabellaC.Properties.VariableNames(7);
                MatriceC2.Properties.VariableNames(2)=TabellaC.Properties.VariableNames(8);
                tbl1 = table(MatriceC1.driving,MatriceC1.walking,'VariableNames',{'driving','walking'});
                lm1 = fitlm(tbl1,'linear');
                figure(); 
                plot(lm1);
                tbl2 = table(MatriceC2.driving,MatriceC2.walking,'VariableNames',{'driving','walking'});
                lm2 = fitlm(tbl2,'linear');
                figure();
                plot(lm2);
            else
                MatriceC = table(TabellaTempC.driving,TabellaTempC.walking);
                MatriceC.Properties.VariableNames(1)=TabellaC.Properties.VariableNames(7);
                MatriceC.Properties.VariableNames(2)=TabellaC.Properties.VariableNames(8);
                ArrayC0=table2array(MatriceC);
                ArrayC=rmmissing(ArrayC0);
                tbl0 = table(MatriceC.driving,MatriceC.walking,'VariableNames',{'driving','walking'});
                lm0 = fitlm(tbl0,'linear');
                figure();
                plot(lm0);
            end
        end
        clear j;
        risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
        risposta2=risposta{1};
        if risposta2=="Y"
            %% Clear Temporary variables
            clear TabellaTemp; clear MatriceB; clear ArrayB1; clear ArrayB;
            clear lm; clear tbl; clear lm0; clear tbl0; clear lm1; clear tbl1; clear lm2; clear tbl2; % Parameters of linear model
            clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
            clear appoggio; clear res; clear media;% Parameters of ANOVA - part 2
        else
            g=0;
            %% Clear Temporary variables
            clear TabellaTemp; clear MatriceB; clear ArrayB1; clear ArrayB;
            clear lm; clear tbl; clear lm0; clear tbl0; clear lm1; clear tbl1; clear lm2; clear tbl2; % Parameters of linear model
            clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
            clear appoggio; clear res; clear media;% Parameters of ANOVA - part 2
        end
    end
end
%% Test ANOVA per Google
g=1;
while g>0
    listaPeriodo = ["categorie" "2020vs2021"];
    [indx1,tf1] = listdlg('PromptString','Select which comparison you want', 'ListString', listaPeriodo, "SelectionMode", "single");
    risposta1 = string(listaPeriodo(indx1));
    risposta1 = cellstr(risposta1);
    if risposta1=="categorie"
        lista = TabellaG.sub_region_1(1:length(dateGoogle):height(TabellaG));
        [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
        risposta = string(lista(indx));
        risposta = cellstr(risposta);
        TabellaTemp = TabellaG(TabellaG.sub_region_1==""+risposta+"",:);
        MatriceG = TabellaTemp(:,10:15);
        MatriceG.Properties.VariableNames(1)=TabellaG.Properties.VariableNames(10);
        MatriceG.Properties.VariableNames(2)=TabellaG.Properties.VariableNames(11);
        MatriceG.Properties.VariableNames(3)=TabellaG.Properties.VariableNames(12);
        MatriceG.Properties.VariableNames(4)=TabellaG.Properties.VariableNames(13);
        MatriceG.Properties.VariableNames(5)=TabellaG.Properties.VariableNames(14);
        MatriceG.Properties.VariableNames(6)=TabellaG.Properties.VariableNames(15);
        ArrayG1=table2array(MatriceG);
        ArrayG=rmmissing(ArrayG1);
        for i=1:6
                media(:,i)=mean(ArrayG(:,i))*ones(length(ArrayG),1);
        end
        appoggio=ArrayG-media;
        res=[];
        for i=1:6 
            res=[res;appoggio(:,i)]; 
        end
        figure();
        normplot(res);
        [P,ANOVATAB,STATS] = anova1([MatriceG.retail_and_recreation_percent_change_from_baseline, MatriceG.grocery_and_pharmacy_percent_change_from_baseline, MatriceG.parks_percent_change_from_baseline,MatriceG.transit_stations_percent_change_from_baseline,MatriceG.workplaces_percent_change_from_baseline,MatriceG.residential_percent_change_from_baseline],{'retail and recreation percent change from baseline','grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline'});
        [c,u] = multcompare(STATS);
         IpotesiZero = kstest(res/sqrt(ANOVATAB{3,4}));
        if IpotesiZero==0
            fprintf("Non si può rifiutare l'ipotesi nulla! \n");
        else
            fprintf("Si rifiuta l'ipotesi nulla! \n");
        end
        risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
        risposta2=risposta{1};
        if risposta2=="Y"
                %% Clear Temporary variables
                clear TabellaTemp; clear MatriceG; clear ArrayG1; clear ArrayG;
                clear lm; clear tbl; % Parameters of linear model
                clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
                clear appoggio; clear res; clear media; % Parameters of ANOVA - part 2
        else
                g=0;
                %% Clear Temporary variables
                clear TabellaTemp; clear MatriceG; clear ArrayG1; clear ArrayG;
                clear lm; clear tbl; % Parameters of linear model
                clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
                clear appoggio; clear res; clear media; % Parameters of ANOVA - part 2
        end
    else
        if risposta1=="2020vs2021"
            lista = TabellaG.sub_region_1(1:length(dateGoogle):height(TabellaG));
            [indx,tf] = listdlg('PromptString','Select one region to be represented','ListString',lista, "SelectionMode","single");
            risposta = string(lista(indx));
            risposta = cellstr(risposta);
            TabellaTemp = TabellaG(TabellaG.sub_region_1==""+risposta+"",:);
            for i=1:length(GiorniGoogle2020)
                TabellaTemp1(i,:) = TabellaTemp(TabellaTemp.date==GiorniGoogle2020(i),:);
                TabellaTemp2(i,:) = TabellaTemp(TabellaTemp.date==GiorniGoogle2021Confronto(i),:);
            end
            TabellaTemp = [TabellaTemp1; TabellaTemp2];
            MatriceG = TabellaTemp(:,10:15);
            MatriceG.Properties.VariableNames(1)=TabellaG.Properties.VariableNames(10);
            MatriceG.Properties.VariableNames(2)=TabellaG.Properties.VariableNames(11);
            MatriceG.Properties.VariableNames(3)=TabellaG.Properties.VariableNames(12);
            MatriceG.Properties.VariableNames(4)=TabellaG.Properties.VariableNames(13);
            MatriceG.Properties.VariableNames(5)=TabellaG.Properties.VariableNames(14);
            MatriceG.Properties.VariableNames(6)=TabellaG.Properties.VariableNames(15);
            ArrayG1=table2array(MatriceG);
            ArrayG=rmmissing(ArrayG1);
            for i=1:6
                    media(:,i)=mean(ArrayG(:,i))*ones(length(ArrayG),1);
            end
            appoggio=ArrayG-media;
            res=[];
            for i=1:6 
                res=[res;appoggio(:,i)]; 
            end
            figure();
            normplot(res);
            [P,ANOVATAB,STATS] = anova1([MatriceG.retail_and_recreation_percent_change_from_baseline, MatriceG.grocery_and_pharmacy_percent_change_from_baseline, MatriceG.parks_percent_change_from_baseline,MatriceG.transit_stations_percent_change_from_baseline,MatriceG.workplaces_percent_change_from_baseline,MatriceG.residential_percent_change_from_baseline],{'retail and recreation percent change from baseline','grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline'});
            [c,u] = multcompare(STATS);
             IpotesiZero = kstest(res/sqrt(ANOVATAB{3,4}));
            if IpotesiZero==0
                fprintf("Non si può rifiutare l'ipotesi nulla! \n");
            else
                fprintf("Si rifiuta l'ipotesi nulla! \n");
            end
            risposta = inputdlg('Do you want to represent another region? Y/N','Plot the Google mobility data of a region',[1 50]);
            risposta2=risposta{1};
            if risposta2=="Y"
                    %% Clear Temporary variables
                    clear TabellaTemp; clear MatriceG; clear ArrayG1; clear ArrayG;
                    clear lm; clear tbl; % Parameters of linear model
                    clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
                    clear appoggio; clear res; clear media; % Parameters of ANOVA - part 2
            else
                    g=0;
                    %% Clear Temporary variables
                    clear TabellaTemp; clear MatriceG; clear ArrayG1; clear ArrayG;
                    clear lm; clear tbl; % Parameters of linear model
                    clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
                    clear appoggio; clear res; % Parameters of ANOVA - part 2
            end
        end
    end
end
%% Clear Temporary variables
            clear TabellaTemp; clear MatriceG; clear ArrayG1; clear ArrayG;
            clear lm; clear tbl; % Parameters of linear model
            clear P; clear ANOVATAB; clear STATS; clear c; clear u; % Parameters of ANOVA - part 1
            clear appoggio; clear res; % Parameters of ANOVA - part 2