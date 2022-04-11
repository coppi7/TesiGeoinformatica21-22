clearvars;
% close all;

addpath('./DatabaseLocale/');
addpath('./TabelleDateGoogle/');

TabellaConfrontiAIC = readtable("./DatabaseLocale/TabelleAIC/TabellaConfrontiAIC.csv");
TabellaDiffPendenze= abs(TabellaConfrontiAIC.b-TabellaConfrontiAIC.d);
TabellaDiffPendenze = array2table(TabellaDiffPendenze);
TabellaDiffPendenze.Properties.VariableNames(1)= "Slope difference";
TabellaDiffPendenze(:,2) = TabellaConfrontiAIC(:,1);
TabellaDiffPendenze.Properties.VariableNames(2)= TabellaConfrontiAIC.Properties.VariableNames(1);
j=0;
sz = [36 3];
VarTypes = ["string" "double" "double"];
VarNames = ["comparison" "dy" "Slope difference"];
TabellaDiffOrdinate = table('Size',sz, 'VariableTypes',VarTypes,'VariableNames',VarNames);
for i=1:height(TabellaConfrontiAIC)
    if TabellaConfrontiAIC.model(i)=="piecewise"
        j=j+1;
        y1 = TabellaConfrontiAIC.b(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.a(i);
        y2 = TabellaConfrontiAIC.d(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.c(i);
        TabellaDiffOrdinate.comparison(j) = TabellaConfrontiAIC.Comparison(i);
        TabellaDiffOrdinate.dy(j) = abs(y1 - y2);
    elseif TabellaConfrontiAIC.model(i)=="piecewise_fsp"
        j=j+1;
        y1 = TabellaConfrontiAIC.b(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.a(i);
        y2 = TabellaConfrontiAIC.d(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.c(i);
        TabellaDiffOrdinate.comparison(j) = TabellaConfrontiAIC.Comparison(i);
        TabellaDiffOrdinate.dy(j) = abs(y1 - y2);
    elseif TabellaConfrontiAIC.model(i)=="disjoint_fsp"
        j=j+1;
        y1 = TabellaConfrontiAIC.b(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.a(i);
        y2 = TabellaConfrontiAIC.d(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.c(i);
        TabellaDiffOrdinate.comparison(j) = TabellaConfrontiAIC.Comparison(i);
        TabellaDiffOrdinate.dy(j) = abs(y1 - y2);
    elseif TabellaConfrontiAIC.model(i)=="disjoint"
        j=j+1;
        y1 = TabellaConfrontiAIC.b(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.a(i);
        y2 = TabellaConfrontiAIC.d(i)*TabellaConfrontiAIC.x0(i)+TabellaConfrontiAIC.c(i);
        TabellaDiffOrdinate.comparison(j) = TabellaConfrontiAIC.Comparison(i);
        TabellaDiffOrdinate.dy(j) = abs(y1 - y2);
    end
end
TabellaDiffOrdinate(:,3)= TabellaDiffPendenze(:,1);