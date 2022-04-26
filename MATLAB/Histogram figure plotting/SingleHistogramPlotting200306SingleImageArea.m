%%% SINGLE HISTOGRAM PLOTTING
% Dataset: \\storage.ad.scilifelab.se\TestaLab\Mitography\Data and results\Main dataset\191024 - allMito\MATLAB analysis
% Plot the area log plot one image by one, to see where I have all these
% super small mitochondria.

% Read data

fileNum = 27;

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));
masterFolderPath = '\\storage.ad.scilifelab.se\TestaLab\Mitography\Data and results\Main dataset\191024 - allMito\MATLAB analysis\';
filenameAnalysis = '_MitoAnalysisFull.txt';

if fileNum < 10
    filename = strcat('Image_00',int2str(fileNum),filenameAnalysis);
else
    filename = strcat('Image_0',int2str(fileNum),filenameAnalysis);
end
filepath = strcat(masterFolderPath,filename);

try
    data = dlmread(filepath);
    areaMito = data(1:end,4);
    widthMito = data(1:end,8);
    areaMito(widthMito == 0) = NaN; 
    areaMito = areaMito(~isnan(areaMito));
catch err
end




%Plot data

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

areathresh = 0.043;

h1var = areaMito;
% h2var = mitoAreaRaw;

boundlow = [0, 0, 0, 0, 0];
stepwidth = [0.021, 0.09, 0.12, 0.05];
boundup = [0.7, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = 0.5;

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtext1 = sprintf('Raw');
legendtext2 = sprintf('RL');

xlabeltext1 = 'Mitochondria area [um^2]';


mitoarealogfig = figure('rend','painters','pos',[1400 100 600 600]);
n = 5; nbins = 30;
[~,binedges] = histcounts(log10(h1var),nbins);
histogram(h1var,10.^binedges,'Normalization','probability')
% hold on
% [~,binedges] = histcounts(log10(h10var),nbins);
% histogram(h10var,10.^binedges,'Normalization','probability')
set(gca, 'xscale','log')
ylabel('Norm. frequency')
xlabel(xlabeltext1)
xlim([1E-3 1E2]);
title(strcat('N=',num2str(length(h1var))));
legend(legendtext2, legendtext1);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');

