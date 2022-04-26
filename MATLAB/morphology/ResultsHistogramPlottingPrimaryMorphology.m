%%%
% MULTIPLE HISTOGRAM PLOTTING FOR PRIMARY MORPHOLOGY
%
% Instructions:
% Change the name of the variables by h1var, h2var, h3var... to whatever
% variable names you have for the parameters, for example
% "h1var=mitoWidthControl", "h2var=mitoWidthTreated" and so on. Then run
% the script, and histograms comparing the two datasets will be plotted.
%
%%%

%%% VARIABLES TO MODIFY AND PLOT
h1var = mitolengthGT4NS_C;
h2var = mitolengthGT4NS_Gal;
% h3var = mitoWidth_Gal5mM;
% h4var = mitoArea10uM;
% h5var = mitoLengthControl;
% h6var = mitoLength10uM;
stepwidth1 = 0.021;  % Bin width for the first variables plotted (mito width)
stepwidth2 = 0.09;  % Bin width for the second variables plotted (mito area)
stepwidth3 = 0.12;  % Bin width for the third variables plotted (mito length)
ylimup1 = 0.25;  % Upper y-axis bound for first variable plotted (in case you do not see the whole bins etc)
ylimup2 = 0.3;  % Upper y-axis bound for second variable plotted
ylimup3 = 0.15;  % Upper y-axis bound for third variable plotted

%%% PLOTTING CODE
colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

boundlow1 = 0;
boundup1 = 0.7;
xlimlow1 = boundlow1;
xlimup1 = boundup1;

boundlow2 = 0;
boundup2 = 3;
xlimlow2 = boundlow2;
xlimup2 = boundup2;

boundlow3 = 0;
boundup3 = 5;
xlimlow3 = boundlow3;
xlimup3 = boundup3;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'STED';
legendtext2 = 'Confocal';

titletext1 = 'N=833';
titletext2 = 'N=833';
titletext3 = 'N=833';

xlabeltext1 = 'Mitochondria width [?m]';
xlabeltext2 = 'Mitochondria area [?m^2]';
xlabeltext3 = 'Mitochondria length [?m]';



%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',colors(1,1:end));
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
%title(strcat(titletext1,', N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0:ylimup1/12:ylimup1])
yticklabels({0,'','',ylimup1/4,'','',ylimup1/2,'','',3*ylimup1/4,'','',ylimup1})

mitoareafig = figure('rend','painters','pos',[500 100 300 300]);
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',colors(1,1:end));
hold on
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow2:(xlimup2-xlimlow2)/12:xlimup2])
xticklabels({xlimlow2,'','',(xlimup2-xlimlow2)/4,'','',(xlimup2-xlimlow2)/2,'','',3*(xlimup2-xlimlow2)/4,'','',xlimup2})
yticks([0:ylimup2/12:ylimup2])
yticklabels({0,'','',ylimup2/4,'','',ylimup2/2,'','',3*ylimup2/4,'','',ylimup2})

mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',colors(1,1:end));
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow3:(xlimup3-xlimlow3)/12:xlimup3])
xticklabels({xlimlow3,'','',(xlimup3-xlimlow3)/4,'','',(xlimup3-xlimlow3)/2,'','',3*(xlimup3-xlimlow3)/4,'','',xlimup3})
yticks([0:ylimup3/12:ylimup3])
yticklabels({0,'','',ylimup3/4,'','',ylimup3/2,'','',3*ylimup3/4,'','',ylimup3})

% Box plots
hdouble = [h1var;h2var];
groupings = [zeros(1,length(h1var)),ones(1,length(h2var))];
widthboxplots = figure('rend','painters','pos',[100 100 300 150]);
h7 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[colors(1,1:end);darkGray],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow1 xlimup1])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})

hdouble = [h3var;h4var];
groupings = [zeros(1,length(h3var)),ones(1,length(h4var))];
areaboxplots = figure('rend','painters','pos',[100 100 300 150]);
h8 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[colors(1,1:end);darkGray],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow2 xlimup2])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow2:(xlimup2-xlimlow2)/12:xlimup2])
xticklabels({xlimlow2,'','',(xlimup2-xlimlow2)/4,'','',(xlimup2-xlimlow2)/2,'','',3*(xlimup2-xlimlow2)/4,'','',xlimup2})

hdouble = [h5var;h6var];
groupings = [zeros(1,length(h5var)),ones(1,length(h6var))];
lengthboxplots = figure('rend','painters','pos',[100 100 300 150]);
h9 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[colors(1,1:end);darkGray],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow3 xlimup3])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow3:(xlimup3-xlimlow3)/12:xlimup3])
xticklabels({xlimlow3,'','',(xlimup3-xlimlow3)/4,'','',(xlimup3-xlimlow3)/2,'','',3*(xlimup3-xlimlow3)/4,'','',xlimup3})