%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: T:\Mitography\Data and results\MATLAB data sets\AllLiveData180709-DistFitting-4.mat
% Threshold area: 0.1010 ?m^2, equal to the smallest detected
% mitochondria in the confocal images.

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% mitowidthsted = mitoWidthNP;
% mitoareasted = mitoAreaNP;
% mitolengthsted = mitoLengthNP;
% 
% locs = find(mitowidthsted>1);
% mitowidthsted(locs)=[];
% mitolengthsted(locs)=[];
% mitoareasted(locs)=[];

areathresh = 0.043;

% h1var = mitowidthsted(mitoareasted > areathresh);  % All mito
% h2var = mitowidthsted(mitoareasted < areathresh);  % All small mito, below the threshold
% h3var = mitoareasted(mitoareasted > areathresh);
% h4var = mitoareasted(mitoareasted < areathresh);
% h5var = mitolengthsted(mitoareasted > areathresh);
% h6var = mitolengthsted(mitoareasted < areathresh);
% h7var = mitowidthsted(mitoareasted > areathresh)./mitolengthsted(mitoareasted > areathresh);
% h8var = mitowidthsted(mitoareasted < areathresh)./mitolengthsted(mitoareasted < areathresh);
% h9var = h7var((mitoareasted < areathresh) & (mitolengthsted < 1));  %
% That long mitochondria should not be included

h9var = mitoAreaRaw;
% h10var = mitoAreaRL;
h10var = mitoAreaNP;

boundlow = [0, 0, 0, 0, 0];
stepwidth = [0.021, 0.09, 0.12, 0.05];
boundup = [0.7, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.3, 0.4, 0.45, 0.25];

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtext1 = sprintf('Control');
legendtext2 = sprintf('Galactose');
legendtext3 = sprintf('Galac+Amycin');
legendtext4 = sprintf('Gluc+Amycin');

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';
xlabeltext4 = 'Mitochondria AR [arb.u.]';



% %%%,'FaceAlpha',opacity %%% If you want different opacity
% mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
% n = 1;
% h1 = histogram(h1var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
% hold on
% h2 = histogram(h2var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
% xlim([xlimlow(n) xlimup(n)])
% xlabel(xlabeltext1)
% ylim([0 ylimup(n)])
% ylabel('Norm. frequency')
% %title(strcat(titletext1,', N=',num2str(length(h1var))));
% legend(legendtext1,legendtext2);
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
% xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
% yticks([0:ylimup(n)/12:ylimup(n)])
% yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
% 
% mitoareafig = figure('rend','painters','pos',[500 100 300 300]);
% n = 2;
% h3 = histogram(h3var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
% hold on
% h4 = histogram(h4var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
% xlim([xlimlow(n) xlimup(n)])
% xlabel(xlabeltext2)
% ylim([0 ylimup(n)])
% ylabel('Norm. frequency')
% %title(strcat(titletext2,', N=',num2str(length(h3var))));
% legend(legendtext1,legendtext2);
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
% xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
% yticks([0:ylimup(n)/12:ylimup(n)])
% yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
% 
% mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
% n = 3;
% h5 = histogram(h5var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
% hold on
% h6 = histogram(h6var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
% xlim([xlimlow(n) xlimup(n)])
% xlabel(xlabeltext3)
% ylim([0 ylimup(n)])
% ylabel('Norm. frequency')
% %title(strcat(titletext3,', N=',num2str(length(h5var))));
% legend(legendtext1,legendtext2);
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
% xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
% yticks([0:ylimup(n)/12:ylimup(n)])
% yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
% 
% mitoarfig = figure('rend','painters','pos',[1300 100 300 300]);
% n = 4;
% h7 = histogram(h7var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
% hold on
% h8 = histogram(h8var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
% xlim([xlimlow(n) xlimup(n)])
% xlabel(xlabeltext4)
% ylim([0 ylimup(n)])
% ylabel('Norm. frequency')
% %title(strcat(titletext3,', N=',num2str(length(h5var))));
% legend(legendtext1,legendtext2);
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
% xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
% yticks([0:ylimup(n)/12:ylimup(n)])
% yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})

mitoarealogfig = figure('rend','painters','pos',[1700 100 300 300]);
n = 5; nbins = 30;
[~,binedges] = histcounts(log10(h9var),nbins);
histogram(h9var,10.^binedges,'Normalization','probability')
hold on
[~,binedges] = histcounts(log10(h10var),nbins);
histogram(h10var,10.^binedges,'Normalization','probability')
% [~,binedges] = histcounts(log10(h11var),nbins);
% histogram(h11var,10.^binedges,'Normalization','probability')
% [~,binedges] = histcounts(log10(h12var),nbins);
% histogram(h12var,10.^binedges,'Normalization','probability')
set(gca, 'xscale','log')
ylabel('Norm. frequency')
xlabel(xlabeltext2)
%title(strcat(titletext3,', N=',num2str(length(h5var))));
% legend(legendtext1,legendtext2);
legend('Raw','RL');
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');


%{
% Box plots
hdouble = [h1var;h2var];
groupings = [zeros(1,length(h1var)),ones(1,length(h2var))];
widthboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 1;
h9 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h3var;h4var];
groupings = [zeros(1,length(h3var)),ones(1,length(h4var))];
areaboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 2;
h10 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h5var;h6var];
groupings = [zeros(1,length(h5var)),ones(1,length(h6var))];
lengthboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 3;
h11 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h7var;h8var];
groupings = [zeros(1,length(h7var)),ones(1,length(h8var))];
arboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 4;
h12 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
%}