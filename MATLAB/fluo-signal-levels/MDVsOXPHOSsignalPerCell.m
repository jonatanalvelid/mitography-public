%%%
% OXPHOS signal levels per cell - plotting
%
% @jonatanalvelid
%%%

clear

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(filename))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);
datafolder = fullfile(doubleparentfolder{1},'example-data');

%%%
% Parameters
% data folder
masterFolderPath = fullfile(datafolder,'fluo-signal-levels','oxphos\');
%%%

dirread = masterFolderPath;
datalist = dir(fullfile(dirread,'*.mat'));
datalist_thresh = dir(fullfile(dirread,'*thresh.txt'));

expnum = [1 1 1 2 2 2];
cellnum = [1 2 3 1 2 3];
nocells = [3 3];

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
    disp(i)
    disp(exp)
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
