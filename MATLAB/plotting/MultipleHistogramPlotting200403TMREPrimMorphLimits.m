%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: \\X:\TestaLab\Mitography\TMR-MitographyAnalysis\mitoData-RL-200403-doublepeakAR.mat

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% % All mito
%{
areathresh = 0.086;
% h1var = mitoWidtht(mitoTMREparam==1);  % All TMRE+ mito
mitoWidthtemp = mitoWidtht(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
% h3var = mitoAreat(mitoTMREparam==1);  % All TMRE+ mito
mitoAreatemp = mitoAreat(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
% h5var = mitoLengtht(mitoTMREparam==1);  % All TMRE+ mito
mitoLengthtemp = mitoLengtht(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
% h5var = mitoARt(mitoTMREparam==1);  % All TMRE+ mito
mitoARtemp = mitoARt(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
mitodoublepeakparamtemp = mitodoublepeakparamt(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
%}
%%{
areathresh = 0.086;
ARthresh1 = 0.5;
% h1var = mitoWidtht(mitoTMREparam==1);  % All TMRE+ mito
mitoWidthtemp = mitoWidtht(mitoAreat<areathresh & mitoARt > ARthresh1);  % All area-small AR-small mito
% h3var = mitoAreat(mitoTMREparam==1);  % All TMRE+ mito
mitoAreatemp = mitoAreat(mitoAreat<areathresh & mitoARt > ARthresh1);  % All area-small AR-small mito
% h5var = mitoLengtht(mitoTMREparam==1);  % All TMRE+ mito
mitoLengthtemp = mitoLengtht(mitoAreat<areathresh & mitoARt > ARthresh1);  % All area-small AR-small mito
% h5var = mitoARt(mitoTMREparam==1);  % All TMRE+ mito
mitoARtemp = mitoARt(mitoAreat<areathresh & mitoARt > ARthresh1);  % All area-small AR-small mito
mitoTMREparamtemp = mitoTMREparam(mitoAreat<areathresh & mitoARt > ARthresh1);  % All area-small AR-small mito

%}
%{
%%% NOT NEEDED ANYMORE, DO THIS IN RESULTS SCRIPT INSTEAD
% mitoARt = mitoWidtht./mitoLengtht;
% % If AR is >1, just invert it, as the axises have been mixed up
% for i=1:length(mitoARt)
%     if mitoARt(i) > 1
%         mitoARt(i) = 1/mitoARt(i);
%     end
% end
% mitoARtemp = mitoARt(mitoTMREparam==0 & mitoAreat<areathresh);  % All TMRE- and small mito
%}
%{
%areathresh1 = 0.04;
areathresh2 = 0.086;
mitoWidthsmall = mitoWidthtemp(mitoAreatemp<areathresh1);
mitoWidthbig = mitoWidthtemp(mitoAreatemp>areathresh1 & mitoAreatemp<areathresh2);
mitoLengthsmall = mitoLengthtemp(mitoAreatemp<areathresh1);
mitoLengthbig = mitoLengthtemp(mitoAreatemp>areathresh1 & mitoAreatemp<areathresh2);
mitoAreasmall = mitoAreatemp(mitoAreatemp<areathresh1);
mitoAreabig = mitoAreatemp(mitoAreatemp>areathresh1 & mitoAreatemp<areathresh2);
mitoARsmall = mitoARtemp(mitoAreatemp<areathresh1);
mitoARbig = mitoARtemp(mitoAreatemp>areathresh1 & mitoAreatemp<areathresh2);
%}
%{
% Split small-ARsmall and small-ARbig mitos
mitoWidthsmall = mitoWidthtemp(mitoARtemp<ARthresh1);
mitoWidthbig = mitoWidthtemp(mitoARtemp>ARthresh1);
mitoLengthsmall = mitoLengthtemp(mitoARtemp<ARthresh1);
mitoLengthbig = mitoLengthtemp(mitoARtemp>ARthresh1);
mitoAreasmall = mitoAreatemp(mitoARtemp<ARthresh1);
mitoAreabig = mitoAreatemp(mitoARtemp>ARthresh1);
mitoARsmall = mitoARtemp(mitoARtemp<ARthresh1);
mitoARbig = mitoARtemp(mitoARtemp>ARthresh1);
%}
%%{
% Split TMRE- and TMRE+ mitos
mitoWidthsmall = mitoWidthtemp(mitoTMREparamtemp==0);
mitoWidthbig = mitoWidthtemp(mitoTMREparamtemp==1);
mitoLengthsmall = mitoLengthtemp(mitoTMREparamtemp==0);
mitoLengthbig = mitoLengthtemp(mitoTMREparamtemp==1);
mitoAreasmall = mitoAreatemp(mitoTMREparamtemp==0);
mitoAreabig = mitoAreatemp(mitoTMREparamtemp==1);
mitoARsmall = mitoARtemp(mitoTMREparamtemp==0);
mitoARbig = mitoARtemp(mitoTMREparamtemp==1);
%}
%{
% Split all mito into smaller and bigger than thresh
mitoWidthsmall = mitoWidtht(mitoAreat<areathresh);
mitoWidthbig = mitoWidtht(mitoAreat>areathresh);
mitoLengthsmall = mitoLengtht(mitoAreat<areathresh);
mitoLengthbig = mitoLengtht(mitoAreat>areathresh);
mitoAreasmall = mitoAreat(mitoAreat<areathresh);
mitoAreabig = mitoAreat(mitoAreat>areathresh);
mitoARsmall = mitoARt(mitoAreat<areathresh);
mitoARbig = mitoARt(mitoAreat>areathresh);
%}
%{
% Split small-mitodoublepeak (1) and small-mitosinglepeak (0) mitos
mitoWidthsmall = mitoWidtht(mitodoublepeakparamt==0);
mitoWidthbig = mitoWidtht(mitodoublepeakparamt==1);
mitoLengthsmall = mitoLengtht(mitodoublepeakparamt==0);
mitoLengthbig = mitoLengtht(mitodoublepeakparamt==1);
mitoAreasmall = mitoAreat(mitodoublepeakparamt==0);
mitoAreabig = mitoAreat(mitodoublepeakparamt==1);
mitoARsmall = mitoARt(mitodoublepeakparamt==0);
mitoARbig = mitoARt(mitodoublepeakparamt==1);
%}
h1var = mitoWidthsmall;
h2var = mitoWidthbig;
h3var = mitoAreasmall;
h4var = mitoAreabig;
h5var = mitoLengthsmall;
h6var = mitoLengthbig;
h7var = mitoARtemp;
h8var = mitoARbig;

%{
% All mito
boundlow = [0, 0, 0, 0];
stepwidth = [0.025, 0.086, 0.1, 0.075];
boundup = [0.6, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.4, 0.4, 0.4, 0.4];
%}
%%{
% Small mito
boundlow = [0, 0, 0, 0];
stepwidth = [0.02, 0.009, 0.04, 0.05];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.4, 0.4, 0.4, 0.4];
%}

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtext1 = sprintf('TMRE-');
legendtext2 = sprintf('TMRE+');

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

mitoareafig = figure('rend','painters','pos',[410 100 300 300]);
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

mitolenfig = figure('rend','painters','pos',[410 500 300 300]);
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

mitoARfig = figure('rend','painters','pos',[100 500 600 300]);
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

%{
% h1var = mitoMitoSOX(mitoLengthm>0.250);
% h2var = mitoMitoSOX(mitoLengthm<0.250);
h1var = mitoTMRE(mitoAreat>0.086);
h2var = mitoTMRE(mitoAreat<0.086);
[h,p]=kstest2(h1var,h2var);
disp(p)

x1=ones(length(h1var)).*(1+(rand(length(h1var))-0.5)/3);
x2=ones(length(h2var)).*(1+(rand(length(h2var))-0.5)/6);
markersize = 3;

% Box plots
hdouble = [h1var;h2var];
groupings = [zeros(1,length(h1var)),ones(1,length(h2var))];
widthboxplots = figure('rend','painters','pos',[100 100 300 400]);
n = 1;
h9 = boxplot(hdouble,groupings,'BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','','Widths',0.8);
hold on
f1=scatter(x1(:,1), h1var, markersize,'k','filled');
f1.MarkerFaceAlpha = 1;
f2=scatter(x2(:,2).*2, h2var, markersize,'k','filled');
f2.MarkerFaceAlpha = f1.MarkerFaceAlpha;
% xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
% xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
%}
