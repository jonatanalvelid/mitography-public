%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: \\X:\TestaLab\Mitography\TMR-MitographyAnalysis\mitoData-RL-200317.mat

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

%{
% Swap width and length for those where it is in the wrong order
% A test makes it seems like this is not necessary, not adjusting the whole
population distributions too much, just very slightly
widlenswap = mitoWidtht > mitoLengtht;
for i = widlenswap
    [mitoWidtht(i), mitoLengtht(i)] = deal(mitoLengtht(i),mitoWidtht(i));
end
widlenswap = mitoWidthm > mitoLengthm;
for i = widlenswap
    [mitoWidthm(i), mitoLengthm(i)] = deal(mitoLengthm(i),mitoWidthm(i));
end
%}

%%{
% All mitos
mitoWidthttemp = mitoWidtht();  % All mito
mitoWidthmtemp = mitoWidthm();  % All mito
mitoAreattemp = mitoAreat();  % All mito
mitoAreamtemp = mitoAream();  % All mito
mitoLengthttemp = mitoLengtht();  % All mito
mitoLengthmtemp = mitoLengthm();  % All mito
mitoARttemp = mitoARt();  % All mito
mitoARmtemp = mitoARm();  % All mito
mitoTMREparamtemp = mitoTMREparamt();  % All mito
mitoMitoSOXparamtemp = mitoMitoSOXparamm();  % All mito
%}
%{
% All MDVs
areathresh = 0.086;
ARthresh = 0.5;
mitoWidthttemp = mitoWidtht(mitoARt>ARthresh & mitoAreat<areathresh);  % 
mitoWidthmtemp = mitoWidthm(mitoARm>ARthresh & mitoAream<areathresh);  % 
mitoAreattemp = mitoAreat(mitoARt>ARthresh & mitoAreat<areathresh);  % 
mitoAreamtemp = mitoAream(mitoARm>ARthresh & mitoAream<areathresh);  %
mitoLengthttemp = mitoLengtht(mitoARt>ARthresh & mitoAreat<areathresh);  % 
mitoLengthmtemp = mitoLengthm(mitoARm>ARthresh & mitoAream<areathresh);  %
mitoARttemp = mitoARt(mitoARt>ARthresh & mitoAreat<areathresh);  % 
mitoARmtemp = mitoARm(mitoARm>ARthresh & mitoAream<areathresh);  %
mitoTMREparamtemp = mitoTMREparam(mitoARt>ARthresh & mitoAreat<areathresh);  % All area-small AR-small mito
mitoMitoSOXparamtemp = mitoMitoSOXparam(mitoARm>ARthresh & mitoAream<areathresh);  % All area-small AR-small mito
%}
%{
mitoWidthttemp = mitoWidthm;  % 
mitoWidthmtemp = mitoWidtht;  % 
mitoAreattemp = mitoAream;  % 
mitoAreamtemp = mitoAreat;  %
mitoLengthttemp = mitoLengthm;  % 
mitoLengthmtemp = mitoLengtht;  %
mitoARttemp = mitoARm;  % 
mitoARmtemp = mitoARt;  % 
%}

%%{
% All mitos
hvars{1} = mitoWidthttemp();  % All mito
hvars{2} = mitoWidthmtemp();  % All mito
hvars{3} = mitoAreattemp();  % All mito
hvars{4} = mitoAreamtemp();  % All mito
hvars{5} = mitoLengthttemp();  % All mito
hvars{6} = mitoLengthmtemp();  % All mito
hvars{7} = mitoARttemp();  % All mito
hvars{8} = mitoARmtemp();  % All mito
%}
%{
% Split small-small and small-big mitos
areathresh1 = 0.04;
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
ARthresh1 = 0.5;
mitoWidthtsmall = mitoWidthttemp(mitoARttemp<ARthresh1);
mitoWidthtbig = mitoWidthttemp(mitoARttemp>ARthresh1);
mitoLengthtsmall = mitoLengthttemp(mitoARttemp<ARthresh1);
mitoLengthtbig = mitoLengthttemp(mitoARttemp>ARthresh1);
mitoAreatsmall = mitoAreattemp(mitoARttemp<ARthresh1);
mitoAreatbig = mitoAreattemp(mitoARttemp>ARthresh1);
mitoARtsmall = mitoARttemp(mitoARttemp<ARthresh1);
mitoARtbig = mitoARttemp(mitoARttemp>ARthresh1);

mitoWidthmsmall = mitoWidthmtemp(mitoARmtemp<ARthresh1);
mitoWidthmbig = mitoWidthmtemp(mitoARmtemp>ARthresh1);
mitoLengthmsmall = mitoLengthmtemp(mitoARmtemp<ARthresh1);
mitoLengthmbig = mitoLengthmtemp(mitoARmtemp>ARthresh1);
mitoAreamsmall = mitoAreamtemp(mitoARmtemp<ARthresh1);
mitoAreambig = mitoAreamtemp(mitoARmtemp>ARthresh1);
mitoARmsmall = mitoARmtemp(mitoARmtemp<ARthresh1);
mitoARmbig = mitoARmtemp(mitoARmtemp>ARthresh1);
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
%{
h1var = mitoWidthtsmall;  % Small TMRE- mito
h2var = mitoWidthmsmall;  % Small MitoSOX- mito
h3var = mitoAreatsmall;  % Small TMRE- mito
h4var = mitoAreamsmall;  % Small MitoSOX- mito
h5var = mitoLengthtsmall;  % Small TMRE- mito
h6var = mitoLengthmsmall;  % Small MitoSOX- mito
h7var = mitoARtsmall;  % Small TMRE- mito
h8var = mitoARmsmall;  % Small MitoSOX- mito
%}
%{
h1var = mitoWidthtbig;  % Big TMRE- mito
h2var = mitoWidthmbig;  % Big MitoSOX- mito
h3var = mitoAreatbig;  % Big TMRE- mito
h4var = mitoAreambig;  % Big MitoSOX- mito
h5var = mitoLengthtbig;  % Big TMRE- mito
h6var = mitoLengthmbig;  % Big MitoSOX- mito
h7var = mitoARtbig;  % Big TMRE- mito
h8var = mitoARmbig;  % Big MitoSOX- mito
%}
%{
% All TMRE+ and MitoSOX-
h1var = mitoWidthttemp(mitoTMREparamtemp==1);  % All TMRE+ MDVs below conf lim
h2var = mitoWidthmtemp(mitoMitoSOXparamtemp==0);  % All MitoSOX- MDVs below conf lim
h3var = mitoAreattemp(mitoTMREparamtemp==1);  % All TMRE+ MDVs below conf lim
h4var = mitoAreamtemp(mitoMitoSOXparamtemp==0);  % All MitoSOX- MDVs below conf lim
h5var = mitoLengthttemp(mitoTMREparamtemp==1);  % All TMRE+ MDVs below conf lim
h6var = mitoLengthmtemp(mitoMitoSOXparamtemp==0);  % All MitoSOX- MDVs below conf lim
h7var = mitoARttemp(mitoTMREparamtemp==1);  % All TMRE+ MDVs below conf lim
h8var = mitoARmtemp(mitoMitoSOXparamtemp==0);  % All MitoSOX- MDVs below conf lim
%}

%%{
% For all
boundlow = [0, 0, 0, 0];
stepwidth = [0.013, 0.06, 0.1, 0.05];
boundup = [0.5, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.2, 0.4, 0.2, 0.2];
%}
%{
% For all - smaller
boundlow = [0, 0, 0, 0];
stepwidth = [0.013, 0.02, 0.05, 0.05];
boundup = [0.5, 0.5, 1, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.2, 0.2, 0.16, 0.2];
%}
%{
% For small
boundlow = [0, 0, 0, 0];
stepwidth = [0.025, 0.009, 0.04, 0.066];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.5, 0.4, 0.4, 0.5];
%}

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtexts = {'TMRE','MitoSOX'};

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';
xlabeltext4 = 'Mitochondria aspect ratio [arb.u.]';


%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
n = 1;
h1 = histogram(hvars{1},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h2 = histogram(hvars{2},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext1)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext1,', N=',num2str(length(h1var))));
legend(legendtexts);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(hvars{1}))
disp(mean(hvars{2}))
disp(median(hvars{1}))
disp(median(hvars{2}))
[h,p] = kstest2(hvars{1}',hvars{2}');
disp(p)
disp(' ')

mitoareafig = figure('rend','painters','pos',[410 100 300 300]);
n = 2;
h3 = histogram(hvars{3},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h4 = histogram(hvars{4},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext2)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtexts);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(hvars{3}))
disp(mean(hvars{4}))
disp(median(hvars{3}))
disp(median(hvars{4}))
[h,p] = kstest2(hvars{3},hvars{4});
disp(p)
disp(' ')

mitolenfig = figure('rend','painters','pos',[410 500 300 300]);
n = 3;
h5 = histogram(hvars{5},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h6 = histogram(hvars{6},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext3)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtexts);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(hvars{5}))
disp(mean(hvars{6}))
disp(median(hvars{5}))
disp(median(hvars{6}))
[h,p] = kstest2(hvars{5},hvars{6});
disp(p)
disp(' ')

mitoARfig = figure('rend','painters','pos',[100 500 300 300]);
n = 4;
h7 = histogram(hvars{7},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',lightGray);
hold on
h8 = histogram(hvars{8},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',darkGray);
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext4)
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtexts);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})
disp(mean(hvars{7}))
disp(mean(hvars{8}))
disp(median(hvars{7}))
disp(median(hvars{8}))
[h,p] = kstest2(hvars{7},hvars{8});
disp(p)
disp(' ')

%%{
h1var = mitoMitoSOXm(mitoAream>0.086);
h2var = mitoMitoSOXm(mitoAream<0.086);
% h1var = mitoTMREt(mitoAreat>0.086);
% h2var = mitoTMREt(mitoAreat<0.086);
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
