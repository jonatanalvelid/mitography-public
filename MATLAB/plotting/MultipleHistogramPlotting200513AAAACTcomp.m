%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: X:\Mitography\NEW\Antimycin Treatments_April2020\6h_5nM AA\200513-allMito-xxx-xxx.mat

colors = lines(4);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% Swap width and length for those where it is in the wrong order
widlenswap = mitoWidthaaoxp > mitoLengthaaoxp;
for i = widlenswap
    widtemp = mitoWidthaaoxp(i);
    lentemp = mitoLengthaaoxp(i);
    mitoWidthaaoxp(i) = lentemp;
    mitoLengthaaoxp(i) = widtemp;
end
widlenswap = mitoWidthaapex > mitoLengthaapex;
for i = widlenswap
    widtemp = mitoWidthaapex(i);
    lentemp = mitoLengthaapex(i);
    mitoWidthaapex(i) = lentemp;
    mitoLengthaapex(i) = widtemp;
end
widlenswap = mitoWidthctoxp > mitoLengthctoxp;
for i = widlenswap
    widtemp = mitoWidthctoxp(i);
    lentemp = mitoLengthctoxp(i);
    mitoWidthctoxp(i) = lentemp;
    mitoLengthctoxp(i) = widtemp;
end
widlenswap = mitoWidthctpex > mitoLengthctpex;
for i = widlenswap
    widtemp = mitoWidthctpex(i);
    lentemp = mitoLengthctpex(i);
    mitoWidthctpex(i) = lentemp;
    mitoLengthctpex(i) = widtemp;
end

% All mito
%{
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
hvars{1} = mitoWidthaaoxp();  % All AA oxphos mitos
hvars{2} = mitoWidthaapex();  % All AA pex mitos
hvars{3} = mitoWidthctoxp();  % All control oxphos mitos
hvars{4} = mitoWidthctpex();  % All control pex mitos
hvars{5} = mitoAreaaaoxp();  % All AA oxphos mitos
hvars{6} = mitoAreaaapex();  % All AA pex mitos
hvars{7} = mitoAreactoxp();  % All control oxphos mitos
hvars{8} = mitoAreactpex();  % All control pex mitos
hvars{9} = mitoLengthaaoxp();  % All AA oxphos mitos
hvars{10} = mitoLengthaapex();  % All AA pex mitos
hvars{11} = mitoLengthctoxp();  % All control oxphos mitos
hvars{12} = mitoLengthctpex();  % All control pex mitos
hvars{13} = mitoARaaoxp();  % All AA oxphos mitos
hvars{14} = mitoARaapex();  % All AA pex mitos
hvars{15} = mitoARctoxp();  % All control oxphos mitos
hvars{16} = mitoARctpex();  % All control pex mitos
%}
%{
% Only small mitos
areathresh = 0.03;
hvars{1} = mitoWidthaaoxp(mitoAreaaaoxp<areathresh);  % All AA oxphos mitos
hvars{2} = mitoWidthaapex(mitoAreaaapex<areathresh);  % All AA pex mitos
hvars{3} = mitoWidthctoxp(mitoAreactoxp<areathresh);  % All control oxphos mitos
hvars{4} = mitoWidthctpex(mitoAreactpex<areathresh);  % All control pex mitos
hvars{5} = mitoAreaaaoxp(mitoAreaaaoxp<areathresh);  % All AA oxphos mitos
hvars{6} = mitoAreaaapex(mitoAreaaapex<areathresh);  % All AA pex mitos
hvars{7} = mitoAreactoxp(mitoAreactoxp<areathresh);  % All control oxphos mitos
hvars{8} = mitoAreactpex(mitoAreactpex<areathresh);  % All control pex mitos
hvars{9} = mitoLengthaaoxp(mitoAreaaaoxp<areathresh);  % All AA oxphos mitos
hvars{10} = mitoLengthaapex(mitoAreaaapex<areathresh);  % All AA pex mitos
hvars{11} = mitoLengthctoxp(mitoAreactoxp<areathresh);  % All control oxphos mitos
hvars{12} = mitoLengthctpex(mitoAreactpex<areathresh);  % All control pex mitos
hvars{13} = mitoARaaoxp(mitoAreaaaoxp<areathresh);  % All AA oxphos mitos
hvars{14} = mitoARaapex(mitoAreaaapex<areathresh);  % All AA pex mitos
hvars{15} = mitoARctoxp(mitoAreactoxp<areathresh);  % All control oxphos mitos
hvars{16} = mitoARctpex(mitoAreactpex<areathresh);  % All control pex mitos
%}
%%{
% Only MDVs
areathresh = 0.03;
ARthresh = 0.5;
hvars{1} = mitoWidthaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{2} = mitoWidthaapex(mitoAreaaapex<areathresh & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{3} = mitoWidthctoxp(mitoAreactoxp<areathresh & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{4} = mitoWidthctpex(mitoAreactpex<areathresh & mitoARctpex>ARthresh);  % All control pex mitos
hvars{5} = mitoAreaaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{6} = mitoAreaaapex(mitoAreaaapex<areathresh & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{7} = mitoAreactoxp(mitoAreactoxp<areathresh & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{8} = mitoAreactpex(mitoAreactpex<areathresh & mitoARctpex>ARthresh);  % All control pex mitos
hvars{9} = mitoLengthaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{10} = mitoLengthaapex(mitoAreaaapex<areathresh & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{11} = mitoLengthctoxp(mitoAreactoxp<areathresh & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{12} = mitoLengthctpex(mitoAreactpex<areathresh & mitoARctpex>ARthresh);  % All control pex mitos
hvars{13} = mitoARaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{14} = mitoARaapex(mitoAreaaapex<areathresh & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{15} = mitoARctoxp(mitoAreactoxp<areathresh & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{16} = mitoARctpex(mitoAreactpex<areathresh & mitoARctpex>ARthresh);  % All control pex mitos
%}
%{
% Only big MDVs
areathresh1 = 0.086;
areathresh2 = 0.03;
ARthresh = 0.5;
hvars{1} = mitoWidthaaoxp(mitoAreaaaoxp<areathresh1 & mitoAreaaaoxp>areathresh2 & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{2} = mitoWidthaapex(mitoAreaaapex<areathresh1 & mitoAreaaapex>areathresh2 & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{3} = mitoWidthctoxp(mitoAreactoxp<areathresh1 & mitoAreactoxp>areathresh2 & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{4} = mitoWidthctpex(mitoAreactpex<areathresh1 & mitoAreactpex>areathresh2 & mitoARctpex>ARthresh);  % All control pex mitos
hvars{5} = mitoAreaaaoxp(mitoAreaaaoxp<areathresh1 & mitoAreaaaoxp>areathresh2 & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{6} = mitoAreaaapex(mitoAreaaapex<areathresh1 & mitoAreaaapex>areathresh2 & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{7} = mitoAreactoxp(mitoAreactoxp<areathresh1 & mitoAreactoxp>areathresh2 & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{8} = mitoAreactpex(mitoAreactpex<areathresh1 & mitoAreactpex>areathresh2 & mitoARctpex>ARthresh);  % All control pex mitos
hvars{9} = mitoLengthaaoxp(mitoAreaaaoxp<areathresh1 & mitoAreaaaoxp>areathresh2 & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{10} = mitoLengthaapex(mitoAreaaapex<areathresh1 & mitoAreaaapex>areathresh2 & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{11} = mitoLengthctoxp(mitoAreactoxp<areathresh1 & mitoAreactoxp>areathresh2 & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{12} = mitoLengthctpex(mitoAreactpex<areathresh1 & mitoAreactpex>areathresh2 & mitoARctpex>ARthresh);  % All control pex mitos
hvars{13} = mitoARaaoxp(mitoAreaaaoxp<areathresh1 & mitoAreaaaoxp>areathresh2 & mitoARaaoxp>ARthresh);  % All AA oxphos mitos
hvars{14} = mitoARaapex(mitoAreaaapex<areathresh1 & mitoAreaaapex>areathresh2 & mitoARaapex>ARthresh);  % All AA pex mitos
hvars{15} = mitoARctoxp(mitoAreactoxp<areathresh1 & mitoAreactoxp>areathresh2 & mitoARctoxp>ARthresh);  % All control oxphos mitos
hvars{16} = mitoARctpex(mitoAreactpex<areathresh1 & mitoAreactpex>areathresh2 & mitoARctpex>ARthresh);  % All control pex mitos
%}
%{
% Only sticks
areathresh = 0.086;
ARthresh = 0.5;
hvars{1} = mitoWidthaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp<ARthresh);  % All AA oxphos mitos
hvars{2} = mitoWidthaapex(mitoAreaaapex<areathresh & mitoARaapex<ARthresh);  % All AA pex mitos
hvars{3} = mitoWidthctoxp(mitoAreactoxp<areathresh & mitoARctoxp<ARthresh);  % All control oxphos mitos
hvars{4} = mitoWidthctpex(mitoAreactpex<areathresh & mitoARctpex<ARthresh);  % All control pex mitos
hvars{5} = mitoAreaaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp<ARthresh);  % All AA oxphos mitos
hvars{6} = mitoAreaaapex(mitoAreaaapex<areathresh & mitoARaapex<ARthresh);  % All AA pex mitos
hvars{7} = mitoAreactoxp(mitoAreactoxp<areathresh & mitoARctoxp<ARthresh);  % All control oxphos mitos
hvars{8} = mitoAreactpex(mitoAreactpex<areathresh & mitoARctpex<ARthresh);  % All control pex mitos
hvars{9} = mitoLengthaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp<ARthresh);  % All AA oxphos mitos
hvars{10} = mitoLengthaapex(mitoAreaaapex<areathresh & mitoARaapex<ARthresh);  % All AA pex mitos
hvars{11} = mitoLengthctoxp(mitoAreactoxp<areathresh & mitoARctoxp<ARthresh);  % All control oxphos mitos
hvars{12} = mitoLengthctpex(mitoAreactpex<areathresh & mitoARctpex<ARthresh);  % All control pex mitos
hvars{13} = mitoARaaoxp(mitoAreaaaoxp<areathresh & mitoARaaoxp<ARthresh);  % All AA oxphos mitos
hvars{14} = mitoARaapex(mitoAreaaapex<areathresh & mitoARaapex<ARthresh);  % All AA pex mitos
hvars{15} = mitoARctoxp(mitoAreactoxp<areathresh & mitoARctoxp<ARthresh);  % All control oxphos mitos
hvars{16} = mitoARctpex(mitoAreactpex<areathresh & mitoARctpex<ARthresh);  % All control pex mitos
%}

hvarscomb{1} = [hvars{1};hvars{2}];
hvarscomb{2} = [hvars{3};hvars{4}];
hvarscomb{3} = [hvars{5};hvars{6}];
hvarscomb{4} = [hvars{7};hvars{8}];
hvarscomb{5} = [hvars{9};hvars{10}];
hvarscomb{6} = [hvars{11};hvars{12}];
hvarscomb{7} = [hvars{13};hvars{14}];
hvarscomb{8} = [hvars{15};hvars{16}];


%%% Mitochondria occurence frequencies
smallaa = length(hvarscomb{1})/length([mitoWidthaaoxp;mitoWidthaapex]);
smallct = length(hvarscomb{2})/length([mitoWidthctoxp;mitoWidthctpex]);
mdvaa = length(hvarscomb{1})/length([mitoWidthaaoxp;mitoWidthaapex]);
mdvct = length(hvarscomb{2})/length([mitoWidthctoxp;mitoWidthctpex]);
stickaa = length(hvarscomb{1})/length([mitoWidthaaoxp;mitoWidthaapex]);
stickct = length(hvarscomb{2})/length([mitoWidthctoxp;mitoWidthctpex]);
disp(smallaa)
disp(smallct)


%% Plotting
%{
%%% For all
boundlow = [0, 0, 0, 0];
stepwidth = [0.013, 0.06, 0.15, 0.05];
boundup = [0.5, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.2, 0.6, 0.4, 0.2];
%}
%%{
%%% For small
boundlow = [0, 0, 0, 0];
stepwidth = [0.01, 0.005, 0.03, 0.05];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.2, 0.2, 0.2, 0.2];
%}

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtexts = {'AA','CT'};

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';
xlabeltext4 = 'Mitochondria aspect ratio [arb.u.]';


%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
n = 1;
h1 = histogram(hvarscomb{1},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h2 = histogram(hvarscomb{2},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
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

[h,p] = kstest2(hvarscomb{1},hvarscomb{2});
disp(p)
disp(mean(hvarscomb{1}))
disp(mean(hvarscomb{2}))
disp('')


mitoareafig = figure('rend','painters','pos',[410 100 300 300]);
n = 2;
h5 = histogram(hvarscomb{3},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h6 = histogram(hvarscomb{4},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
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

[h,p] = kstest2(hvarscomb{3},hvarscomb{4});
disp(p)
disp(mean(hvarscomb{3}))
disp(mean(hvarscomb{4}))
disp('')


mitolenfig = figure('rend','painters','pos',[410 500 300 300]);
n = 3;
h9 = histogram(hvarscomb{5},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h10 = histogram(hvarscomb{6},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
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

[h,p] = kstest2(hvarscomb{5},hvarscomb{6});
disp(p)
disp(mean(hvarscomb{5}))
disp(mean(hvarscomb{6}))
disp('')


mitoARfig = figure('rend','painters','pos',[100 500 300 300]);
n = 4;
h13 = histogram(hvarscomb{7},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h14 = histogram(hvarscomb{8},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
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

[h,p] = kstest2(hvarscomb{7},hvarscomb{8});
disp(p)
disp(mean(hvarscomb{7}))
disp(mean(hvarscomb{8}))
disp('')

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
