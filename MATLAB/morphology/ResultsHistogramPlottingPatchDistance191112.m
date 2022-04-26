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

h1var = patchdistPControl;  % Small mitochondria, area <0.5 um2
h2var = patchdistNPControl;  % Larger mitochondria, area >0.5 um2
h3var = patchoverlapPControl;  % Small mitochondria, area <0.5 um2
h4var = patchoverlapNPControl;  % Larger mitochondria, area >0.5 um2


stepwidth1 = 0.06;  % Bin width for the first variables plotted (mito patch dist)
stepwidth2 = 0.06;  % Bin width for the second variables plotted (mito patch overlap)
ylimup1 = 0.14;  % Upper y-axis bound for first variable plotted (in case you do not see the whole bins etc)
ylimup2 = 0.95;  % Upper y-axis bound for second variable plotted (in case you do not see the whole bins etc)

%%% PLOTTING CODE
colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

boundlow1 = 0;
boundup1 = 10;
xlimlow1 = boundlow1;
xlimup1 = boundup1;

boundlow2 = 0;
boundup2 = 1;
xlimlow2 = boundlow2;
xlimup2 = boundup2;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'Area <0.5 um2';
legendtext2 = 'Area >0.5 um2';

xlabeltext1 = 'Mitochondria patch distance [um]';
xlabeltext2 = 'Mitochondria patch overlap';


% Histogram plot
%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',darkGray);
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',colors(1,:));
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
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',darkGray);
hold on
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',colors(1,:));
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

% Box plot
hdouble = [h1var;h2var];
groupings = [zeros(1,length(h1var)),ones(1,length(h2var))];
widthboxplots = figure('rend','painters','pos',[100 100 300 150]);
h7 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow2 xlimup1])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow2:(xlimup1-xlimlow2)/12:xlimup1])
xticklabels({xlimlow2,'','',(xlimup1-xlimlow2)/4,'','',(xlimup1-xlimlow2)/2,'','',3*(xlimup1-xlimlow2)/4,'','',xlimup1})


%%% Distribution comparison, ks-tests
[h_wid,p_wid,k2stat_wid] = kstest2(h1var,h2var);
disp('Mito patch dist, small mito, p-value');
disp(p_wid)
disp(length(h1var))
disp(length(h2var))
disp(length(h3var))
disp(length(h4var))
