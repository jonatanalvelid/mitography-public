%%% SINGLE HISTOGRAM PLOTTING
% Dataset: \\storage.ad.scilifelab.se\TestaLab\Mitography\Data and results\MATLAB data sets

%Plot data

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

areathresh = 0.043;

% h1var = mitoAreaNP;
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

