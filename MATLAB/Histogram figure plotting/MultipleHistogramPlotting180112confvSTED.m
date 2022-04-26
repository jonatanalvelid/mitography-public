%%% MULTIPLE HISTOGRAM PLOTTING
colors = lines(2);

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
stepwidth1 = 0.021;
boundup1 = 0.7;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.25;

boundlow2 = 0;
stepwidth2 = 0.09;
boundup2 = 3;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.25;

boundlow3 = 0;
stepwidth3 = 0.12;
boundup3 = 4;
xlimlow3 = boundlow3;
xlimup3 = boundup3;
ylimup3 = 0.15;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'STED';
legendtext2 = 'Confocal';

titletext1 = 'N=833';
titletext2 = 'N=833';
titletext3 = 'N=833';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria area [µm^2]';
xlabeltext3 = 'Mitochondria length [µm]';



%%%,'FaceAlpha',opacity %%% If you want different opacity


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

mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
%saveas(gcf,'STEDConfLen','svg')


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
