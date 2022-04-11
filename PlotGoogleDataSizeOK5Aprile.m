%% Plot GoogleData

figure('Name','National Data Google');
plot(dateGoogle,TabellaF.retail_and_recreation_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.grocery_and_pharmacy_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.parks_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.transit_stations_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.workplaces_percent_change_from_baseline);
hold on;
plot(dateGoogle,TabellaF.residential_percent_change_from_baseline);
legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');

ylabel('Percentage of mobility','FontSize', 20);
%% Plot data of regions of Google
f1 = figure('Name','Mobility Google regions');
k=1;
for i=1:height(TabellaG)
    if i==height(TabellaG)
        TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
        TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
        TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
        TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
        TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
        TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
        j=i;
        figure(f1)
        subplot(231)
        plot(dateGoogle,TabellaTemp1(k:j),'c');
        hold on;
        set(gca,'FontSize',18)
        subplot(232)
        plot(dateGoogle,TabellaTemp2(k:j),'y');
        hold on;
        set(gca,'FontSize',18)
        subplot(233)
        plot(dateGoogle,TabellaTemp3(k:j),'r');
        hold on;
        set(gca,'FontSize',18)
        subplot(234)
        plot(dateGoogle,TabellaTemp4(k:j),'g');
        hold on;
        set(gca,'FontSize',18)
        subplot(235)
        plot(dateGoogle,TabellaTemp5(k:j),'b');
        hold on;
        set(gca,'FontSize',18)
        subplot(236)
        plot(dateGoogle,TabellaTemp6(k:j),'k');
        %legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
        
        %ylabel('Percentage of mobility','FontSize', 20);
        set(gca,'FontSize',18)
    else
        if string(TabellaG.sub_region_1(i))==string(TabellaG.sub_region_1(i+1))
            TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
        else
            TabellaTemp1(i,:) = TabellaG.retail_and_recreation_percent_change_from_baseline(i);
            TabellaTemp2(i,:) = TabellaG.grocery_and_pharmacy_percent_change_from_baseline(i);
            TabellaTemp3(i,:) = TabellaG.parks_percent_change_from_baseline(i);
            TabellaTemp4(i,:) = TabellaG.transit_stations_percent_change_from_baseline(i);
            TabellaTemp5(i,:) = TabellaG.workplaces_percent_change_from_baseline(i);
            TabellaTemp6(i,:) = TabellaG.residential_percent_change_from_baseline(i);
            j=i;
            figure(f1)
            subplot(231)
            plot(dateGoogle,TabellaTemp1(k:j),'c');
            hold on;
            set(gca,'FontSize',18)
            subplot(232)
            plot(dateGoogle,TabellaTemp2(k:j),'y');
            hold on;
            set(gca,'FontSize',18)
            subplot(233)
            plot(dateGoogle,TabellaTemp3(k:j),'r');
            hold on;
            set(gca,'FontSize',18)
            subplot(234)
            plot(dateGoogle,TabellaTemp4(k:j),'g');
            hold on;
            set(gca,'FontSize',18)
            subplot(235)
            plot(dateGoogle,TabellaTemp5(k:j),'b');
            hold on;
            set(gca,'FontSize',18)
            subplot(236)
            plot(dateGoogle,TabellaTemp6(k:j),'k');
            k=i+1;
            hold on;
            %legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
            set(gca,'FontSize',18)
        end
    end
end
legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');

j=1;
z=0;
contatore=0;
for k=1:length(dateGoogle):length(TabellaTemp1)
    if (k-1==z*length(dateGoogle))
        figure('Name','Google mobility of Regions');
        z=z+4;
        tiledlayout(2,2);
        nexttile;
    end
    contatore=contatore+1;
    plot(dateGoogle,TabellaTemp1(k:(k+length(dateGoogle)-1)),'c');
    hold on;
    plot(dateGoogle,TabellaTemp2(k:(k+length(dateGoogle)-1)),'y');
    hold on;
    plot(dateGoogle,TabellaTemp3(k:(k+length(dateGoogle)-1)),'r');
    hold on;
    plot(dateGoogle,TabellaTemp4(k:(k+length(dateGoogle)-1)),'g');
    hold on;
    plot(dateGoogle,TabellaTemp5(k:(k+length(dateGoogle)-1)),'b');
    hold on;
    plot(dateGoogle,TabellaTemp6(k:(k+length(dateGoogle)-1)),'k');
    title(TabellaG.sub_region_1(j));
    legend('retail and recreation percent change from baseline', 'grocery and pharmacy percent change from baseline','parks percent change from baseline','transit stations percent change from baseline','workplaces percent change from baseline','residential percent change from baseline','Location','north');
    
    ylabel('Percentage of mobility','FontSize', 20);
    j=j+length(dateGoogle);
    if (contatore~=4)
        nexttile;
    else
        contatore=0;
    end
end
%% Clear temporary variables
clear TabellaTemp1; clear TabellaTemp2; clear TabellaTemp3;
clear TabellaTemp4; clear TabellaTemp5; clear TabellaTemp6;
clear Contatore; clear i; clear j; clear k; clear z; clear g; clear contatore;