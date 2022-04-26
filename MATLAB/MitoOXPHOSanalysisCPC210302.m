clear all

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_results','\');
datalist = dir(fullfile(dirread,'*.mat'));

mdvoxpn_area = [];
mdvoxpp_area = [];
mdvoxpall_area = [];
mdvoxp_rat = [];
posratios = [];
expnum = [1 1 1 1 2 2 3 3 3 3 4 4 4 4 4 4 4 5 5 5 5 5 6 6 6 6 6 6 6 6 7 7 7 7 7 7 7 7 7 7 7 7 7 8 8 8 8 8];
cellnum = [1 2 3 4 1 2 1 2 3 4 1 2 3 4 5 6 7 1 2 3 4 5 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 9 10 11 12 13 1 2 3 4 5];

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
    meanarea_all = mean(mitoinfo.area(idx_n | idx_p));
    mdvoxpn_area = [mdvoxpn_area meanarea_n];
    mdvoxpp_area = [mdvoxpp_area meanarea_p];
    mdvoxpall_area = [mdvoxpall_area meanarea_all];
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
    
    subplot(8,13,(exp-1)*13+cell);
    %histogram(mitoinfo.area(idx_n),[0:0.01:0.1],'FaceColor',[0.3 0.3 0.3],'Normalization','probability')
    hold on
    %histogram(mitoinfo.area(idx_p),[0:0.01:0.1],'FaceColor',[0 0.7 0],'Normalization','probability')
    histogram(mitoinfo.area(idx_n | idx_p),[0:0.01:0.1],'FaceColor',[0.7 0 0],'Normalization','probability')
    xlim([0 0.1])
    xlabel('Area (um^2)')
    %ylim([0 1])
    ylabel('Probability (arb.u.)')
    if exp == 1 || exp == 5 || exp == 7
        %title(sprintf('Exp: %d - AA, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp,cell,length(mitoinfo.area(idx_p)),length(mitoinfo.area(idx_n)),p))
        title(sprintf('Exp: %d - AA, Cell: %d,\n mean=%.3f',exp,cell,meanarea_all))
    else
        %title(sprintf('Exp: %d - CTR, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp-1,cell,length(mitoinfo.area(idx_p)),length(mitoinfo.area(idx_n)),p))
        title(sprintf('Exp: %d - CTR, Cell: %d,\n mean=%.3f',exp-1,cell,meanarea_all))
    end
end

figure()
for i=1:numel(datalist)
    %disp(' ')
    %disp(datalist(i).name)
    
    exp = expnum(i);
    cell = cellnum(i);
    
    load(strcat(datalist(i).folder,'\',datalist(i).name));
    
    idx_n = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 0;
    idx_p = mitoinfo.area<0.086 & mitoinfo.oxphosparam == 1;
    %meanarea_n = mean(mitoinfo.area(idx_n));
    %meanarea_p = mean(mitoinfo.area(idx_p));
    %mdvoxpn_area = [mdvoxpn_area meanarea_n];
    %mdvoxpp_area = [mdvoxpp_area meanarea_p];
    mdvoxp_rat = [mdvoxp_rat sum(idx_p)/(sum(idx_p)+sum(idx_n))];
    %fprintf('Mean area, -:  %f \n', meanarea_n)
    %fprintf('Mean area, +:  %f \n', meanarea_p)
    
    n_n = length(mitoinfo.area(idx_n));
    n_p = length(mitoinfo.area(idx_p));
    try
        if n_n ~= 0 && n_p ~= 0
            subplot(8,13,(exp-1)*13+cell);
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
    if exp == 1 || exp == 5 || exp == 7
        title(sprintf('Exp: %d - AA, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp,cell,length(areap),length(arean),p))
    else
        title(sprintf('Exp: %d - CTR, Cell: %d,\n N+=%d, N-=%d, p=%.3f',exp-1,cell,length(areap),length(arean),p))
    end
end

figure('Position', [10 100 850 400])
subplotpos = [1 6 7 8 2 9 3 10];
exps = [1 1 2 3 4 4 5 5];
titles = {'Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f'};
for i=1:max(expnum)
    subplot(2,5,subplotpos(i));
    hold on
    histogram(area_pooled(i).areasn,[0:0.01:0.1],'FaceColor',[0.3 0.3 0.3],'Normalization','probability')
    histogram(area_pooled(i).areasp,[0:0.01:0.1],'FaceColor',[0 0.7 0],'Normalization','probability')
    
    [~,p] = kstest2(area_pooled(i).areasn,area_pooled(i).areasp);
    fprintf('KS-test (+/-): %f \n', p)
    
    xlim([0 0.1])
    xlabel('Area (um^2)')
    ylim([0 0.4])
    ylabel('Probability (arb.u.)')
    title(sprintf(titles{i},exps(i),length(area_pooled(i).areasp),length(area_pooled(i).areasn),p))
end

figure('Position', [10 100 850 400])
subplotpos = [1 6 7 8 2 9 3 10];
exps = [1 1 2 3 4 4 5 5];
titles = {'Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f','Exp: %d - AA,\n N+=%d, N-=%d, p=%.3f','Exp: %d - CTR,\n N+=%d, N-=%d, p=%.3f'};
for i=1:max(expnum)
    subplot(2,5,subplotpos(i));
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
figure('Position', [10 100 850 400])
hold on
labels = {'Exp1 - AA', 'Exp1 - CTR', 'Exp2 - CTR', 'Exp3 - CTR', 'Exp4 - AA', 'Exp4 - CTR', 'Exp5 - AA', 'Exp5 - CTR'};
s1 = scatter(1*ones(size(posratios(expnum==1))),posratios(expnum==1),40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(posratios(expnum==2))),posratios(expnum==2),40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(posratios(expnum==3))),posratios(expnum==3),40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(posratios(expnum==4))),posratios(expnum==4),40,'kx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(posratios(expnum==5))),posratios(expnum==5),40,'rx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(posratios(expnum==6))),posratios(expnum==6),40,'kx','jitter','on','jitterAmount',0.09);
s7 = scatter(7*ones(size(posratios(expnum==7))),posratios(expnum==7),40,'rx','jitter','on','jitterAmount',0.09);
s8 = scatter(8*ones(size(posratios(expnum==8))),posratios(expnum==8),40,'kx','jitter','on','jitterAmount',0.09);
boxplot(posratios,expnum,'Labels',labels)
ylabel('Ratio of OXPHOS+ MDVs')

% Box plots with jittered scatter of OXPHOS+ ratios - all exp together
figure('Position', [10 100 300 400])
hold on
labels = {'AA', 'CTR'};
posratios_all_aa = [posratios(expnum==1) posratios(expnum==5) posratios(expnum==7)];
posratios_all_ct = [posratios(expnum==2) posratios(expnum==3) posratios(expnum==4) posratios(expnum==6) posratios(expnum==8)];
posratios_all = [posratios_all_aa posratios_all_ct];
groupnum = [ones(size(posratios_all_aa)) 2*ones(size(posratios_all_ct))];
s1 = scatter(1*ones(size(posratios_all_aa)),posratios_all_aa,40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(posratios_all_ct)),posratios_all_ct,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(posratios_all,groupnum,'Labels',labels)
ylabel('Ratio of OXPHOS+ MDVs')

% T-tests for OXPHOS+ ratios between datasets
disp(' ')
for n=1:max(expnum)
    for m=1:max(expnum)
        if n ~= m && m>n
            [~,p] = ttest2(posratios(expnum==n),posratios(expnum==m));
            fprintf('T-test, OXPHOS+ ratio, %d v %d: %f \n', n, m, p)
        end
    end
end

% T-tests for OXPHOS+ ratios between conditions
disp(' ')
[~,p] = ttest2(posratios_all_aa,posratios_all_ct);
fprintf('T-test, OXPHOS+ ratio, %s v %s: %f \n', 'aa', 'ct', p)

% Box plots with jittered scatter of OXPHOS+ mean areas
figure('Position', [10 100 850 400])
hold on
labels = {'Exp1 - AA', 'Exp1 - CTR', 'Exp2 - CTR', 'Exp3 - CTR', 'Exp4 - AA', 'Exp4 - CTR', 'Exp5 - AA', 'Exp5 - CTR'};
s1 = scatter(1*ones(size(mdvoxpp_area(expnum==1))),mdvoxpp_area(expnum==1),40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpp_area(expnum==2))),mdvoxpp_area(expnum==2),40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(mdvoxpp_area(expnum==3))),mdvoxpp_area(expnum==3),40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(mdvoxpp_area(expnum==4))),mdvoxpp_area(expnum==4),40,'kx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(mdvoxpp_area(expnum==5))),mdvoxpp_area(expnum==5),40,'rx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(mdvoxpp_area(expnum==6))),mdvoxpp_area(expnum==6),40,'kx','jitter','on','jitterAmount',0.09);
s7 = scatter(7*ones(size(mdvoxpp_area(expnum==7))),mdvoxpp_area(expnum==7),40,'rx','jitter','on','jitterAmount',0.09);
s8 = scatter(8*ones(size(mdvoxpp_area(expnum==8))),mdvoxpp_area(expnum==8),40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpp_area,expnum,'Labels',labels)
ylabel('Area, OXPHOS+ MDVs')
ylim([0 0.1])

% Box plots with jittered scatter of OXPHOS+ mean areas - all exp together
figure('Position', [10 100 300 400])
hold on
labels = {'AA', 'CTR'};
mdvoxpp_area_all_aa = [mdvoxpp_area(expnum==1) mdvoxpp_area(expnum==5) mdvoxpp_area(expnum==7)];
mdvoxpp_area_all_ct = [mdvoxpp_area(expnum==2) mdvoxpp_area(expnum==3) mdvoxpp_area(expnum==4) mdvoxpp_area(expnum==6) mdvoxpp_area(expnum==8)];
mdvoxpp_area_all = [mdvoxpp_area_all_aa mdvoxpp_area_all_ct];
groupnum = [ones(size(mdvoxpp_area_all_aa)) 2*ones(size(mdvoxpp_area_all_ct))];
s1 = scatter(1*ones(size(mdvoxpp_area_all_aa)),mdvoxpp_area_all_aa,40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpp_area_all_ct)),mdvoxpp_area_all_ct,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpp_area_all,groupnum,'Labels',labels)
ylabel('Area, OXPHOS+ MDVs')
ylim([0 0.1])

% Box plots with jittered scatter of OXPHOS- mean areas
figure('Position', [10 100 850 400])
hold on
labels = {'Exp1 - AA', 'Exp1 - CTR', 'Exp2 - CTR', 'Exp3 - CTR', 'Exp4 - AA', 'Exp4 - CTR', 'Exp5 - AA', 'Exp5 - CTR'};
s1 = scatter(1*ones(size(mdvoxpn_area(expnum==1))),mdvoxpn_area(expnum==1),40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpn_area(expnum==2))),mdvoxpn_area(expnum==2),40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(mdvoxpn_area(expnum==3))),mdvoxpn_area(expnum==3),40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(mdvoxpn_area(expnum==4))),mdvoxpn_area(expnum==4),40,'kx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(mdvoxpn_area(expnum==5))),mdvoxpn_area(expnum==5),40,'rx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(mdvoxpn_area(expnum==6))),mdvoxpn_area(expnum==6),40,'kx','jitter','on','jitterAmount',0.09);
s7 = scatter(7*ones(size(mdvoxpn_area(expnum==7))),mdvoxpn_area(expnum==7),40,'rx','jitter','on','jitterAmount',0.09);
s8 = scatter(8*ones(size(mdvoxpn_area(expnum==8))),mdvoxpn_area(expnum==8),40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpn_area,expnum,'Labels',labels)
ylabel('Area, OXPHOS- MDVs')
ylim([0 0.1])

% Box plots with jittered scatter of OXPHOS- mean areas - all exp together
figure('Position', [10 100 300 400])
hold on
labels = {'AA', 'CTR'};
mdvoxpn_area_all_aa = [mdvoxpn_area(expnum==1) mdvoxpn_area(expnum==5) mdvoxpn_area(expnum==7)];
mdvoxpn_area_all_ct = [mdvoxpn_area(expnum==2) mdvoxpn_area(expnum==3) mdvoxpn_area(expnum==4) mdvoxpn_area(expnum==6) mdvoxpn_area(expnum==8)];
mdvoxpn_area_all = [mdvoxpn_area_all_aa mdvoxpn_area_all_ct];
groupnum = [ones(size(mdvoxpn_area_all_aa)) 2*ones(size(mdvoxpn_area_all_ct))];
s1 = scatter(1*ones(size(mdvoxpn_area_all_aa)),mdvoxpn_area_all_aa,40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpn_area_all_ct)),mdvoxpn_area_all_ct,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpn_area_all,groupnum,'Labels',labels)
ylabel('Area, OXPHOS- MDVs')
ylim([0 0.1])

% T-tests for OXPHOS- and OXPHOS+ mean areas between datasets
disp(' ')
for n=1:max(expnum)
    for m=1:max(expnum)
        if n ~= m && m>n
            [~,p] = ttest2(mdvoxpp_area(expnum==n),mdvoxpp_area(expnum==m));
            fprintf('T-test, %d v %d, (+/+): %f \n', n, m, p)
            [~,p] = ttest2(mdvoxpn_area(expnum==n),mdvoxpn_area(expnum==m));
            fprintf('T-test, %d v %d, (-/-): %f \n', n, m, p)
        end
    end
end

% T-tests for OXPHOS- and OXPHOS+ mean areas between conditions
disp(' ')
[~,p] = ttest2(mdvoxpp_area_all_aa,mdvoxpp_area_all_ct);
fprintf('T-test, %s v %s: %f \n', 'aa', 'ct', p)
[~,p] = ttest2(mdvoxpn_area_all_aa,mdvoxpn_area_all_ct);
fprintf('T-test, %s v %s: %f \n', 'aa', 'ct', p)

% Box plots with jittered scatter of MDV mean areas
figure('Position', [10 100 850 400])
hold on
labels = {'Exp1 - AA', 'Exp1 - CTR', 'Exp2 - CTR', 'Exp3 - CTR', 'Exp4 - AA', 'Exp4 - CTR', 'Exp5 - AA', 'Exp5 - CTR'};
s1 = scatter(1*ones(size(mdvoxpall_area(expnum==1))),mdvoxpall_area(expnum==1),40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpall_area(expnum==2))),mdvoxpall_area(expnum==2),40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(mdvoxpall_area(expnum==3))),mdvoxpall_area(expnum==3),40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(mdvoxpall_area(expnum==4))),mdvoxpall_area(expnum==4),40,'kx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(mdvoxpall_area(expnum==5))),mdvoxpall_area(expnum==5),40,'rx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(mdvoxpall_area(expnum==6))),mdvoxpall_area(expnum==6),40,'kx','jitter','on','jitterAmount',0.09);
s7 = scatter(7*ones(size(mdvoxpall_area(expnum==7))),mdvoxpall_area(expnum==7),40,'rx','jitter','on','jitterAmount',0.09);
s8 = scatter(8*ones(size(mdvoxpall_area(expnum==8))),mdvoxpall_area(expnum==8),40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpall_area,expnum,'Labels',labels)
ylabel('Area, MDVs')
ylim([0 0.1])

% T-tests for MDV mean areas between datasets
disp(' ')
for n=1:max(expnum)
    for m=1:max(expnum)
        if n ~= m && m>n
            [~,p] = ttest2(mdvoxpall_area(expnum==n),mdvoxpall_area(expnum==m));
            fprintf('T-test, %d v %d: %f \n', n, m, p)
        end
    end
end

% Box plots with jittered scatter of MDV mean areas - all exp together
figure('Position', [10 100 300 400])
hold on
labels = {'AA', 'CTR'};
mdvoxpall_area_all_aa = [mdvoxpall_area(expnum==1) mdvoxpall_area(expnum==5) mdvoxpall_area(expnum==7)];
mdvoxpall_area_all_ct = [mdvoxpall_area(expnum==2) mdvoxpall_area(expnum==3) mdvoxpall_area(expnum==4) mdvoxpall_area(expnum==6) mdvoxpall_area(expnum==8)];
mdvoxpall_area_all = [mdvoxpall_area_all_aa mdvoxpall_area_all_ct];
groupnum = [ones(size(mdvoxpall_area_all_aa)) 2*ones(size(mdvoxpall_area_all_ct))];
s1 = scatter(1*ones(size(mdvoxpall_area_all_aa)),mdvoxpall_area_all_aa,40,'rx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvoxpall_area_all_ct)),mdvoxpall_area_all_ct,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvoxpall_area_all,groupnum,'Labels',labels)
ylabel('Area, MDVs')
ylim([0 0.1])

% T-tests for MDV mean areas between conditions
disp(' ')
[~,p] = ttest2(mdvoxpall_area_all_aa,mdvoxpall_area_all_ct);
fprintf('T-test, %s v %s: %f \n', 'aa', 'ct', p)
