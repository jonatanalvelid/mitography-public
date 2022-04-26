%%% Test PCA analysis on TMRE- mito data, to try to separate stick-like
%%% mitos, MDVs, and other mito shapes and sizes.
% Dataset: \\X:\TestaLab\Mitography\TMR-MitographyAnalysis\mitoData-RL-200317.mat

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% % All mito
areathresh = 0.086;
% h1var = mitoWidtht(mitoTMREparam==1);  % All TMRE+ mito
mitoWidthtemp = mitoWidtht(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
% h3var = mitoAreat(mitoTMREparam==1);  % All TMRE+ mito
mitoAreatemp = mitoAreat(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
% h5var = mitoLengtht(mitoTMREparam==1);  % All TMRE+ mito
mitoLengthtemp = mitoLengtht(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito

mitoARt = mitoWidtht./mitoLengtht;
% If AR is >1, just invert it, as the axises have been mixed up
for i=1:length(mitoARt)
    if mitoARt(i) > 1
        mitoARt(i) = 1/mitoARt(i);
    end
end
mitoARtemp = mitoARt(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito

% take log of all params
mitoWidthpca = normalize(log(mitoWidtht));
mitoLengthpca = normalize(log(mitoLengtht));
mitoAreapca = normalize(log(mitoAreat));
mitoARpca = normalize(log(mitoARt));


% PCA analysis
alldata = [mitoWidthpca mitoLengthpca mitoAreapca mitoARpca];
[coeff,scores] = pca(alldata);
figure()
scatter3(scores(:,1),scores(:,2),scores(:,3))
% scatter(scores(:,3),scores(:,4))
hold on
x = -4:0.1:4;
y = -0.018*x.^2+0.06*x-0.01;
plot(x,y)

group1 = [];
group2 = [];
for i=1:length(alldata)
    score1 = scores(i,1);
    score3 = scores(i,3);
    score3lim = -0.018*score1^2 + 0.06*score1 - 0.01;
    if score3 > score3lim
        group1 = [group1;i];
    else
        group2 = [group2;i];
    end
end


%{
% Plotting the results of the PCA split

h1var = mitoWidthtemp(group1);  % 
h2var = mitoWidthtemp(group2);  % 
h3var = mitoAreatemp(group1);  % 
h4var = mitoAreatemp(group2);  %
h5var = mitoLengthtemp(group1);  % 
h6var = mitoLengthtemp(group2);  % 
h7var = mitoARtemp(group1);  % 
h8var = mitoARtemp(group2);  % 

boundlow = [0, 0, 0, 0];
stepwidth = [0.015, 0.005, 0.03, 0.04];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.3, 0.35, 0.2, 0.2];

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtext1 = sprintf('"Small"');
legendtext2 = sprintf('"Big"');

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';
xlabeltext4 = 'Mitochondria aspect ratio [arb.u.]';


%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
n = 1;
h1 = histogram(h1var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h2 = histogram(h2var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext1)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext1,', N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(h1var))
disp(mean(h2var))
disp(median(h1var))
disp(median(h2var))
disp(' ')

mitoareafig = figure('rend','painters','pos',[500 100 300 300]);
n = 2;
h3 = histogram(h3var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h4 = histogram(h4var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext2)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(h3var))
disp(mean(h4var))
disp(median(h3var))
disp(median(h4var))
disp(' ')

mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
n = 3;
h5 = histogram(h5var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h6 = histogram(h6var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext3)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(h5var))
disp(mean(h6var))
disp(median(h5var))
disp(median(h6var))
disp(' ')

mitoARfig = figure('rend','painters','pos',[100 500 300 300]);
n = 4;
h5 = histogram(h7var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h6 = histogram(h8var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext4)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(h7var))
disp(mean(h8var))
disp(median(h7var))
disp(median(h8var))
disp(' ')
%}