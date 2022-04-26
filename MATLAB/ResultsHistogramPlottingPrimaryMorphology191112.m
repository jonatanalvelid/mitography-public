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

[h1var,h2var,h3var,h4var,h5var,h6var,h7var,h8var,h9var,h10var,h11var,h12var] = deal([]);

%%% VARIABLES TO MODIFY AND PLOT
% Load all separate dataset variables into the same variable.
varnames = {'wid','are','len'};

% DIV9 names
ctr_names = {'Control'};
gal_names = {'Galac5'};
galamy_names = {'Galac5Amycin10'};
gluamy_names = {'GlucAmycin10'}; 

h1var = eval(char(strcat(varnames(1),ctr_names(1))));
h2var = eval(char(strcat(varnames(2),ctr_names(1))));
h3var = eval(char(strcat(varnames(3),ctr_names(1))));
h4var = eval(char(strcat(varnames(1),gal_names(1))));
h5var = eval(char(strcat(varnames(2),gal_names(1))));
h6var = eval(char(strcat(varnames(3),gal_names(1))));
h7var = eval(char(strcat(varnames(1),galamy_names(1))));
h8var = eval(char(strcat(varnames(2),galamy_names(1))));
h9var = eval(char(strcat(varnames(3),galamy_names(1))));
h10var = eval(char(strcat(varnames(1),gluamy_names(1))));
h11var = eval(char(strcat(varnames(2),gluamy_names(1))));
h12var = eval(char(strcat(varnames(3),gluamy_names(1))));

stepwidth1 = 0.021;  % Bin width for the first variables plotted (mito width)
stepwidth2 = 0.09;  % Bin width for the second variables plotted (mito area)
stepwidth3 = 0.12;  % Bin width for the third variables plotted (mito length)
ylimup1 = 0.3;  % Upper y-axis bound for first variable plotted (in case you do not see the whole bins etc)
ylimup2 = 0.5;  % Upper y-axis bound for second variable plotted
ylimup3 = 0.22;  % Upper y-axis bound for third variable plotted

%%% PLOTTING CODE
colors = lines(3);
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
legendtext3 = 'GalactoseAntimycin';
legendtext4 = 'GlucoseAntimycin';

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';


%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 500 500]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',darkGray);
hold on
h4 = histogram(h4var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',colors(1,:));
h7 = histogram(h7var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',colors(2,:));
h10 = histogram(h10var,boundlow1:stepwidth1:boundup1,'Normalization','probability','FaceColor',colors(3,:));
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2,legendtext3,legendtext4);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0:ylimup1/12:ylimup1])
yticklabels({0,'','',ylimup1/4,'','',ylimup1/2,'','',3*ylimup1/4,'','',ylimup1})

mitoareafig = figure('rend','painters','pos',[500 100 500 500]);
h2 = histogram(h2var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',darkGray);
hold on
h5 = histogram(h5var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',colors(1,:));
h8 = histogram(h8var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',colors(2,:));
h11 = histogram(h11var,boundlow2:stepwidth2:boundup2,'Normalization','probability','FaceColor',colors(3,:));
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2,legendtext3,legendtext4);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow2:(xlimup2-xlimlow2)/12:xlimup2])
xticklabels({xlimlow2,'','',(xlimup2-xlimlow2)/4,'','',(xlimup2-xlimlow2)/2,'','',3*(xlimup2-xlimlow2)/4,'','',xlimup2})
yticks([0:ylimup2/12:ylimup2])
yticklabels({0,'','',ylimup2/4,'','',ylimup2/2,'','',3*ylimup2/4,'','',ylimup2})

mitolenfig = figure('rend','painters','pos',[900 100 500 500]);
h3 = histogram(h3var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',darkGray);
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',colors(1,:));
h9 = histogram(h9var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',colors(2,:));
h12 = histogram(h12var,boundlow3:stepwidth3:boundup3,'Normalization','probability','FaceColor',colors(3,:));
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2,legendtext3,legendtext4);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow3:(xlimup3-xlimlow3)/12:xlimup3])
xticklabels({xlimlow3,'','',(xlimup3-xlimlow3)/4,'','',(xlimup3-xlimlow3)/2,'','',3*(xlimup3-xlimlow3)/4,'','',xlimup3})
yticks([0:ylimup3/12:ylimup3])
yticklabels({0,'','',ylimup3/4,'','',ylimup3/2,'','',3*ylimup3/4,'','',ylimup3})

% Box plots
hdouble = [h1var;h4var;h7var;h10var];
groupings = [zeros(1,length(h1var)),ones(1,length(h4var)),ones(1,length(h7var))*2,ones(1,length(h10var))*3];
widthboxplots = figure('rend','painters','pos',[100 100 800 300]);
h7 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:);colors(2,:);colors(3,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow1 xlimup1])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})

hdouble = [h2var;h5var;h8var;h11var];
groupings = [zeros(1,length(h2var)),ones(1,length(h5var)),ones(1,length(h8var))*2,ones(1,length(h11var))*3];
areaboxplots = figure('rend','painters','pos',[100 100 800 300]);
h8 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:);colors(2,:);colors(3,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow2 xlimup2])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow2:(xlimup2-xlimlow2)/12:xlimup2])
xticklabels({xlimlow2,'','',(xlimup2-xlimlow2)/4,'','',(xlimup2-xlimlow2)/2,'','',3*(xlimup2-xlimlow2)/4,'','',xlimup2})

hdouble = [h3var;h6var;h9var;h12var];
groupings = [zeros(1,length(h3var)),ones(1,length(h6var)),ones(1,length(h9var))*2,ones(1,length(h12var))*3];
lengthboxplots = figure('rend','painters','pos',[100 100 800 300]);
h9 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',[darkGray;colors(1,:);colors(2,:);colors(3,:)],'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow3 xlimup3])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow3:(xlimup3-xlimlow3)/12:xlimup3])
xticklabels({xlimlow3,'','',(xlimup3-xlimlow3)/4,'','',(xlimup3-xlimlow3)/2,'','',3*(xlimup3-xlimlow3)/4,'','',xlimup3})


%%% Distribution comparison, ks-tests

%%% Width
[h_wid1,p_wid1,k2stat_wid1] = kstest2(h1var,h4var);
disp('Mito width - ctrl-galac5 p-value');
disp(p_wid1)
disp(length(h1var))
disp(length(h4var))

[h_wid2,p_wid2,k2stat_wid2] = kstest2(h1var,h7var);
disp('Mito width - ctrl-galac5amycin10 p-value');
disp(p_wid2)
disp(length(h1var))
disp(length(h7var))

[h_wid3,p_wid3,k2stat_wid3] = kstest2(h1var,h10var);
disp('Mito width - ctrl-glucamycin10 p-value');
disp(p_wid3)
disp(length(h1var))
disp(length(h10var))

%%% Area
[h_are1,p_are1,k2stat_are1] = kstest2(h2var,h5var);
disp('Mito area - ctrl-galac5 p-value');
disp(p_are1)
disp(length(h2var))
disp(length(h5var))

[h_are2,p_are2,k2stat_are2] = kstest2(h2var,h8var);
disp('Mito area - ctrl-galac5amycin10 p-value');
disp(p_are2)
disp(length(h2var))
disp(length(h8var))

[h_are3,p_are3,k2stat_are3] = kstest2(h2var,h11var);
disp('Mito area - ctrl-glucamycin10 p-value');
disp(p_are3)
disp(length(h2var))
disp(length(h11var))

%%% Length
[h_len1,p_len1,k2stat_len1] = kstest2(h3var,h6var);
disp('Mito length - ctrl-galac5 p-value');
disp(p_len1)
disp(length(h3var))
disp(length(h6var))

[h_len2,p_len2,k2stat_len2] = kstest2(h3var,h9var);
disp('Mito length - ctrl-galac5amycin10 p-value');
disp(p_len2)
disp(length(h3var))
disp(length(h9var))

[h_len3,p_len3,k2stat_len3] = kstest2(h3var,h12var);
disp('Mito length - ctrl-glucamycin10 p-value');
disp(p_len3)
disp(length(h3var))
disp(length(h12var))