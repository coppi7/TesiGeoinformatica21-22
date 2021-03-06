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
%% Test ANOVA Apple serie temporali
    listaAnno = ["2020" "2021"];
    [indx0,tf0] = listdlg('PromptString','Select the year on which to do ANOVA test', 'ListString', listaAnno, "SelectionMode", "single");
    risposta0 = string(listaAnno(indx0));
    risposta0 = cellstr(risposta0);
    if risposta0=="2020"
        listaPeriodo = ["Winter" "Spring" "Summer" "Autumn"];
        [indx1,tf1] = listdlg('PromptString','Select the period you want to do ANOVA test', 'ListString', listaPeriodo, "SelectionMode", "single");
        risposta1 = string(listaPeriodo(indx1));
        risposta1 = cellstr(risposta1);
        if risposta1=="Spring"
                MatriceApplePeriodo = TabellaA(49:140,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Winter"
                MatriceApplePeriodo = TabellaA(1:48,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Summer"
                MatriceApplePeriodo = TabellaA(141:232,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Autumn"
                MatriceApplePeriodo = TabellaA(233:323,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        end
    elseif risposta0=="2021"
        listaPeriodo = ["Winter" "Spring" "Summer" "Autumn"];
        [indx1,tf1] = listdlg('PromptString','Select the period you want to do ANOVA test', 'ListString', listaPeriodo, "SelectionMode", "single");
        risposta1 = string(listaPeriodo(indx1));
        risposta1 = cellstr(risposta1);
        if risposta1=="Spring"
                MatriceApplePeriodo = TabellaA(414:505,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Winter"
                MatriceApplePeriodo = TabellaA(324:413,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Summer"
                MatriceApplePeriodo = TabellaA(506:597,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        elseif risposta1=="Autumn"
                MatriceApplePeriodo = TabellaA(598:688,7:9);
                ArrayApplePeriodo1 = table2array(MatriceApplePeriodo);
                ArrayApplePeriodo = rmmissing(ArrayApplePeriodo1);
                for i=1:3
                    mediaApplePeriodo(:,i)=mean(ArrayApplePeriodo(:,i))*ones(length(ArrayApplePeriodo),1);
                end
                appoggioApplePeriodo=ArrayApplePeriodo-mediaApplePeriodo;
                resApplePeriodo=[];
                for i=1:3 
                    resApplePeriodo=[resApplePeriodo;appoggioApplePeriodo(:,i)]; 
                end
                figure();
                normplot(resApplePeriodo);
                [P_ApplePeriodo,ANOVATAB_ApplePeriodo,STATS_ApplePeriodo] = anova1([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
                [c_ApplePeriodo,u_ApplePeriodo] = multcompare(STATS_ApplePeriodo,"CType","bonferroni");
                IpotesiZeroApplePeriodo = kstest(resApplePeriodo/sqrt(ANOVATAB_ApplePeriodo{3,4}));
                if IpotesiZeroApplePeriodo==0
                    fprintf("Non si pu?? rifiutare l'ipotesi nulla! \n");
                else
                    fprintf("Si rifiuta l'ipotesi nulla! \n");
                end
        end
    end
    %% Test di Kruskal
    [pkrus,tblkrus,statkrus] = kruskalwallis([MatriceApplePeriodo.driving,MatriceApplePeriodo.walking,MatriceApplePeriodo.transit],{'driving','walking','transit'});
    [c_krus,u_krus] = multcompare(statkrus,"CType","bonferroni");