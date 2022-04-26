clear all

dirread = strcat('E:\PhD\data_analysis\mice_NLGF_oxphos','\');
datalist = dir(fullfile(dirread,'*.mat'));

mdvoxpn_area = [];
mdvoxpp_area = [];
mdvoxp_rat = [];
posratios = [];
expnum = [1 1 1 1 1];
cellnum = [1 2 3 4 5];

area_pooled = struct;
for i=1:max(expnum)
    area_pooled(i).areasn = [];
    area_pooled(i).areasp = [];
end

figure()
for i=1:numel(datalist)
    disp(' ')
    disp(datalist(i).name)
    
    exp = expnum(i);
    cell = cellnum(i);
    
    load(strcat(datalist(i).folder,'\',datalist(i).name));
    
    idx_n = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 0;
    idx_p = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 1;
    meanarea_n = mean(mitoinfo.area(idx_n));
    meanarea_p = mean(mitoinfo.area(idx_p));
    mdvoxpn_area = [mdvoxpn_area meanarea_n];
    mdvoxpp_area = [mdvoxpp_area meanarea_p];
    mdvoxp_rat = [mdvoxp_rat sum(idx_p)/(sum(idx_p)+sum(idx_n))];
    fprintf('Mean area, -:  %f \n', meanarea_n)
    fprintf('Mean area, +:  %f \n', meanarea_p)
    
    n_n = length(mitoinfo.area(idx_n));
    n_p = length(mitoinfo.area(idx_p));
    pos_ratio = n_p/(n_p+n_n);
    posratios = [posratios pos_ratio];
    fprintf('+ ratio of MDVs:  %.3f \n', pos_ratio)
    
    area_pooled(exp).areasn = [area_pooled(exp).areasn; mitoinfo.area(idx_n)];
    area_pooled(exp).areasp = [area_pooled(exp).areasp; mitoinfo.area(idx_p)];
    try
        [~,p] = kstest2(mitoinfo.area(idx_n),mitoinfo.area(idx_p));
        fprintf('KS-test (+/-): %f \n', p)
    catch
    end
    
    subplot(max(expnum),max(cellnum),(exp-1)*max(cellnum)+cell);
    histogram(mitoinfo.area(idx_n),[0:0.01:0.1],'FaceColor',[0.3 0.3 0.3],'Normalization','probability')
    hold on
    histogram(mitoinfo.area(idx_p),[0:0.01:0.1],'FaceColor',[0 0.7 0],'Normalization','probability')
    xlim([0 0.1])
    xlabel('Area (um^2)')
    %ylim([0 1])
    ylabel('Probability (arb.u.)')
    title(sprintf('Exp: %d, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp,cell,length(mitoinfo.area(idx_p)),length(mitoinfo.area(idx_n)),p))
end

figure()
for i=1:numel(datalist)
    disp(' ')
    disp(datalist(i).name)
    
    exp = expnum(i);
    cell = cellnum(i);
    
    load(strcat(datalist(i).folder,'\',datalist(i).name));
    
    idx_n = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 0;
    idx_p = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 1;
    meanarea_n = mean(mitoinfo.area(idx_n));
    meanarea_p = mean(mitoinfo.area(idx_p));
    mdvoxpn_area = [mdvoxpn_area meanarea_n];
    mdvoxpp_area = [mdvoxpp_area meanarea_p];
    mdvoxp_rat = [mdvoxp_rat sum(idx_p)/(sum(idx_p)+sum(idx_n))];
    fprintf('Mean area, -:  %f \n', meanarea_n)
    fprintf('Mean area, +:  %f \n', meanarea_p)
    
    n_n = length(mitoinfo.area(idx_n));
    n_p = length(mitoinfo.area(idx_p));
    try
        if n_n ~= 0 && n_p ~= 0
            subplot(max(expnum),max(cellnum),(exp-1)*max(cellnum)+cell);
            hold on
            labels = {'OXPHOS+', 'OXPHOS-'};
            groups = [ones(n_p,1);2*ones(n_n,1)];
            areap = mitoinfo.area(idx_p);
            arean = mitoinfo.area(idx_n);
            boxplot([areap;arean],groups,'Labels',labels)
            s1 = scatter(ones(size(areap)),areap,10,'k.','jitter','on','jitterAmount',0.1);
            s2 = scatter(2*ones(size(arean)),arean,10,'k.','jitter','on','jitterAmount',0.1);
            [~,p] = kstest2(areap,arean);
        end
    catch
    end
    ylabel('Area (um^2)')
    ylim([0 0.1])
    title(sprintf('Exp: %d, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp,cell,length(areap),length(arean),p))
end

figure()
subplotpos = [1];
exps = [1];
titles = {'Exp: %d,\n N+=%d, N-=%d, p=%.3f'};
for i=1:max(expnum)
    subplot(1,1,subplotpos(i));
    hold on
    histogram(area_pooled(i).areasn,[0:0.005:0.1],'FaceColor',[0.3 0.3 0.3],'Normalization','probability')
    histogram(area_pooled(i).areasp,[0:0.005:0.1],'FaceColor',[0 0.7 0],'Normalization','probability')
    
    [~,p] = kstest2(area_pooled(i).areasn,area_pooled(i).areasp);
    fprintf('KS-test (+/-): %f \n', p)
    
    xlim([0 0.1])
    xlabel('Area (um^2)')
    ylim([0 0.2])
    ylabel('Probability (arb.u.)')
    title(sprintf(titles{i},exps(i),length(area_pooled(i).areasp),length(area_pooled(i).areasn),p))
end

figure()
subplotpos = [1];
exps = [1];
titles = {'Exp: %d,\n N+=%d, N-=%d, p=%.3f'};
for i=1:max(expnum)
    subplot(1,1,subplotpos(i));
    hold on
    labels = {'OXPHOS+', 'OXPHOS-'};
    areap = area_pooled(i).areasp;
    arean = area_pooled(i).areasn;
    n_n = length(arean);
    n_p = length(areap);
    groups = [ones(n_p,1);2*ones(n_n,1)];
    boxplot([areap;arean],groups,'Labels',labels)
    s1 = scatter(ones(size(areap)),areap,30,'k.','jitter','on','jitterAmount',0.1);
    s2 = scatter(2*ones(size(arean)),arean,30,'k.','jitter','on','jitterAmount',0.1);
            
    [~,p] = kstest2(areap,arean);
    fprintf('KS-test (+/-): %f \n', p)
    ylabel('Area (um^2)')
    ylim([0 0.1])
    title(sprintf(titles{i},exps(i),length(areap),length(arean),p))
end

disp(' ')
for n=1:max(expnum)
    for m=1:max(expnum)
        if n ~= m && m>n
            [~,p] = kstest2(area_pooled(n).areasp,area_pooled(m).areasp);
            fprintf('KS-test, %d v %d, (+/+): %f \n', n, m, p)
            [~,p] = kstest2(area_pooled(n).areasn,area_pooled(m).areasn);
            fprintf('KS-test, %d v %d, (-/-): %f \n', n, m, p)
        end
    end
end

% Box plots with jittered scatter of OXPHOS+ ratios
figure()
hold on
labels = {'Exp1 - NLGF'};
s1 = scatter(ones(size(posratios)),posratios,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(posratios,expnum,'Labels',labels)
ylabel('Ratio of OXPHOS+ MDVs')
ylim([0 1])
