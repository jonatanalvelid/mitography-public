clear all

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_results-exp145','\');
datalist = dir(fullfile(dirread,'*.mat'));

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_results-exp145','\');
datalist_thresh = dir(fullfile(dirread,'*thresh.txt'));

expnum = [1 1 1 1 2 2 3 3 3 3 3 4 4 4 4 4 4 4 4 5 5 5 5 5 5 5 5 5 5 5 5 5 6 6 6 6 6];
cellnum = [1 2 3 4 1 2 1 2 3 4 5 1 2 3 4 5 6 7 8 1 2 3 4 5 6 7 8 9 10 11 12 13 1 2 3 4 5];
nocells = [4 2 5 8 13 5];

for i=1:max(expnum)
    figure('Name',sprintf('Experiment %d - Boxplots',i),'Position', [10 100 1800 400])
end
for i=1:max(expnum)
    figure('Name',sprintf('Experiment%d - Histograms',i),'Position', [10 100 1800 300])
end
% Mito OXPHOS signal per cell
for i=1:numel(datalist)
    exp = expnum(i);
    cell = cellnum(i);
    
    thresh_exp = load(strcat(datalist_thresh(exp).folder,'\',datalist_thresh(exp).name));
    thresh_cell = thresh_exp(cell,2);
    meanbkg_cell = thresh_cell/(log(4)+1.5*log(3));
    
    load(strcat(datalist(i).folder,'\',datalist(i).name));
    oxphos_signal = mitoinfo.oxphos;
    
    n_mito = length(mitoinfo.oxphos);
    try
        if n_mito ~= 0
            figure(exp)
            subplot(1,nocells(exp),cell);
            hold on
            groups = [ones(n_mito)];
            boxplot(oxphos_signal,groups,'Labels',{sprintf('Cell %d',cell)},'Symbol','')
            s1 = scatter(ones(size(oxphos_signal)),oxphos_signal,10,'k.','jitter','on','jitterAmount',0.1);
            yline(thresh_cell,'r--','Th')
            yline(meanbkg_cell,'r--','Bkg')
            ylabel('OXPHOS signal (cnts)')
            ylim([0 30])
            title(sprintf('Exp: %d, Cell: %d,\n N=%d',exp,cell,n_mito))
            
            figure(max(expnum)+exp)
            subplot(1,nocells(exp),cell);
            hold on
            binwidth = round(min(2,max(oxphos_signal)/sqrt(n_mito)));
            histogram(oxphos_signal,'BinWidth',binwidth)
            xline(thresh_cell,'r--','Th')
            xline(meanbkg_cell,'r--','Bkg')
            xlabel('OXPHOS signal (cnts)')
            xlim([0 30])
            title(sprintf('Exp: %d, Cell: %d,\n N=%d',exp,cell,n_mito))
        end
    catch
    end
end
