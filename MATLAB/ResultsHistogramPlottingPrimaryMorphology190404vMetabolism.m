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

[h1var,h2var,h3var,h4var,h5var,h6var] = deal([]);

%%% VARIABLES TO MODIFY AND PLOT
% Load all separate dataset variables into the same variable.
varnames = {'mitowidth','mitoarea','mitolength'};

% DIV9 names
ctr_names = {'Control181101', 'Control190201', 'Control190221'};
gal_names = {'Galactose190220'}; 

% % DIV16 names
% ctr_names = {'ControlDIV16181121', 'ControlDIV16190120'};
% gal_names = {'GalactoseDIV16190120v2'};

for i = 1:length(ctr_names)
    h1var = [h1var; eval(char(strcat(varnames(1),ctr_names(i))))];
end

for i = 1:length(gal_names)
    h2var = [h2var; eval(char(strcat(varnames(1),gal_names(i))))];
end

for i = 1:length(ctr_names)
    h3var = [h3var; eval(char(strcat(varnames(2),ctr_names(i))))];
end

for i = 1:length(gal_names)
    h4var = [h4var; eval(char(strcat(varnames(2),gal_names(i))))];
end

for i = 1:length(ctr_names)
    h5var = [h5var; eval(char(strcat(varnames(3),ctr_names(i))))];
end

for i = 1:length(gal_names)
    h6var = [h6var; eval(char(strcat(varnames(3),gal_names(i))))];
end

stepwidth1 = 0.021;  % Bin width for the first variables plotted (mito width)
stepwidth2 = 0.09;  % Bin width for the second variables plotted (mito area)
stepwidth3 = 0.12;  % Bin width for the third variables plotted (mito length)
ylimup1 = 0.3;  % Upper y-axis bound for first variable plotted (in case you do not see the whole bins etc)
ylimup2 = 0.5;  % Upper y-axis bound for second variable plotted
ylimup3 = 0.2;  % Upper y-axis bound for third variable plotted

%%% PLOTTING CODE
colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

boundlow1 = 0;
boundup1 = 0.5;
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

legendtext1 = 'Control';
legendtext2 = 'Galactose';

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';


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

mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',darkGray);
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',colors(1,:));
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
h7 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
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
h8 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
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
h9 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow3 xlimup3])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow3:(xlimup3-xlimlow3)/12:xlimup3])
xticklabels({xlimlow3,'','',(xlimup3-xlimlow3)/4,'','',(xlimup3-xlimlow3)/2,'','',3*(xlimup3-xlimlow3)/4,'','',xlimup3})


%%% Distribution comparison, ks-tests
[h_wid,p_wid,k2stat_wid] = kstest2(h1var,h2var);
disp('Mito width p-value');
disp(p_wid)
disp(length(h1var))
disp(length(h2var))

[h_len,p_len,k2stat_len] = kstest2(h3var,h4var);
disp('Mito area p-value');
disp(p_len)
disp(length(h3var))
disp(length(h4var))

[h_area,p_area,k2stat_area] = kstest2(h5var,h6var);
disp('Mito length p-value');
disp(p_area)
disp(length(h5var))
disp(length(h6var))
