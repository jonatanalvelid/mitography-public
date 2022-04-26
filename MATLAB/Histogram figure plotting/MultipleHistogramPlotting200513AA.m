%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: X:\Mitography\NEW\Antimycin Treatments_April2020\6h_5nM AA\200513-allMito-xxx-xxx.mat

colors = lines(4);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

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

boundlow = [0, 0, 0, 0];
stepwidth = [0.025, 0.009, 0.04, 0.066];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.5, 0.4, 0.4, 0.5];

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtexts = {'AA OXP','AA PEX','CT OXP','CT PEX'};

xlabeltext1 = 'Mitochondria width [um]';
xlabeltext2 = 'Mitochondria area [um^2]';
xlabeltext3 = 'Mitochondria length [um]';
xlabeltext4 = 'Mitochondria aspect ratio [arb.u.]';


%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
n = 1;
h1 = histogram(hvars{1},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h2 = histogram(hvars{2},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
h3 = histogram(hvars{3},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(3,:));
h4 = histogram(hvars{4},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(4,:));
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

hmatwid = nan(4,4);
pmatwid = nan(4,4);
for n = 1:4
    for m = n+1:4
        [h,p] = kstest2(hvars{n},hvars{m});
        hmatwid(n,m) = h;
        pmatwid(n,m) = p;
    end
end


mitoareafig = figure('rend','painters','pos',[410 100 300 300]);
n = 2;
h5 = histogram(hvars{5},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h6 = histogram(hvars{6},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
h7 = histogram(hvars{7},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(3,:));
h8 = histogram(hvars{8},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(4,:));
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

hmatare = nan(4,4);
pmatare = nan(4,4);
for n = 1:4
    for m = n+1:4
        [h,p] = kstest2(hvars{n+4},hvars{m+4});
        hmatare(n,m) = h;
        pmatare(n,m) = p;
    end
end


mitolenfig = figure('rend','painters','pos',[410 500 300 300]);
n = 3;
h9 = histogram(hvars{9},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h10 = histogram(hvars{10},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
h11 = histogram(hvars{11},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(3,:));
h12 = histogram(hvars{12},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(4,:));
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

hmatlen = nan(4,4);
pmatlen = nan(4,4);
for n = 1:4
    for m = n+1:4
        [h,p] = kstest2(hvars{n+8},hvars{m+8});
        hmatlen(n,m) = h;
        pmatlen(n,m) = p;
    end
end


mitoARfig = figure('rend','painters','pos',[100 500 300 300]);
n = 4;
h13 = histogram(hvars{13},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h14 = histogram(hvars{14},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
h15 = histogram(hvars{15},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(3,:));
h16 = histogram(hvars{16},boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(4,:));
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

hmatar = nan(4,4);
pmatar = nan(4,4);
for n = 1:4
    for m = n+1:4
        [h,p] = kstest2(hvars{n+12},hvars{m+12});
        hmatar(n,m) = h;
        pmatar(n,m) = p;
    end
end

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
