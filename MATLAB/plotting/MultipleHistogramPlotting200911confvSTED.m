%%% MULTIPLE HISTOGRAM PLOTTING

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

locs = find(mitowidthsted>1);
mitowidthsted(locs)=[];
mitolengthsted(locs)=[];
mitoareasted(locs)=[];

h1var = mitowidthsted;
h2var = mitowidthconfocal(1:100);
h3var = mitoareasted;
h4var = mitoareaconfocal;
h5var = mitolengthsted;
h6var = mitolengthconfocal;

boundlow1 = 0;
stepwidth1 = 0.02;
boundup1 = 0.7;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.3;

boundlow2 = 0;
stepwidth2 = 0.05;
boundup2 = 3;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.2;

boundlow2log = 0.01;
stepwidth2log = 0.05;
boundup2log = 20;
xlimlow2log = boundlow2log;
xlimup2log = boundup2log;
ylimup2log = 0.3;

boundlow3 = 0.1;
stepwidth3 = 0.12;
boundup3 = 20;
xlimlow3 = boundlow3;
xlimup3 = boundup3;
ylimup3 = 0.25;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'STED';
legendtext2 = 'Conf';

titletext1 = 'N=833';
titletext2 = 'N=833';
titletext3 = 'N=833';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria area [µm^2]';
xlabeltext3 = 'Mitochondria length [µm]';



%%%,'FaceAlpha',opacity %%% If you want different opacity

%{
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
%title(strcat(titletext1,', N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
%saveas(gcf,'STEDConfWid','svg')

mitoareafig = figure('rend','painters','pos',[500 100 300 300]);
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
hold on
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
%saveas(gcf,'STEDConfArea','svg')
%}

mitoarealogfig = figure('rend','painters','pos',[500 100 300 400]);
[~,edges3] = histcounts(log10(h3var),14);
histogram(h3var,10.^edges3,'Normalization','probability','FaceColor',darkGray)
hold on
histogram(h4var,10.^edges3,'Normalization','probability','FaceColor',lightGray)
xlim([xlimlow2log xlimup2log])
xlabel(xlabeltext2)
xticks([0.01 0.1 1 10])
xticklabels([0.01 0.1 1 10])
yticks([0:ylimup2log/12:ylimup2log])
yticklabels({0,'','',ylimup2log/4,'','',ylimup2log/2,'','',3*ylimup2log/4,'','',ylimup2log})
ylim([0 ylimup2log])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtext1,legendtext2,'location','northeast');
set(gca,'FontSize',fontsize)
set(gca, 'xscale','log')
set(gca,'TickDir','out');
%saveas(gcf,'STEDConfArea','svg')

%{
mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
[~,edges5] = histcounts(log10(h5var));
histogram(h5var,10.^edges5,'Normalization','probability')
%h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
hold on
[~,edges6] = histcounts(log10(h6var));
histogram(h6var,10.^edges5,'Normalization','probability')
%h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca, 'xscale','log')
%saveas(gcf,'STEDConfLen','svg')
%}
%{
% ScatterHist
widthdata = [h1var;h2var];
lengthdata = [h5var;h6var];
widthlabels = cell(length(h1var)+length(h2var),1);
widthlabels(1:length(h1var)) = {'STED'};
widthlabels(length(h1var):end) = {'Confocal'};
figure('rend','painters','pos',[100 100 400 400]);
sh1 = scatterhist(widthdata,lengthdata,'Group',widthlabels,'Kernel','on','Direction','out','Marker','...','MarkerSize',6,'LineStyle',{'-','-','-'},'LineWidth',[2,2,2]);
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 xlimup3])
ylabel(xlabeltext3)
set(gca,'FontSize',fontsize)
%saveas(gcf,'STEDConfScatterHist','svg')
%}
