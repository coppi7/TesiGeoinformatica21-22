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
