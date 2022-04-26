%%% LOG AREA HISTOGRAM PLOTTING
% Dataset: E:\PhD\Data analysis\Mitography - temp copy\200515-allMito-TMRE+MitoSOX.mat

clear all
close all
load('X:\Mitography\MitoSOX-MitographyAnalysis\200923-allMito-TMRE+MitoSOX.mat');

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];
lightGreen = [108/255 167/255 20/255];

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
mitoWidthttemp = mitoWidtht();
mitoWidthmtemp = mitoWidthm();
mitoAreattemp = mitoAreat();
mitoAreamtemp = mitoAream();
mitoLengthttemp = mitoLengtht();
mitoLengthmtemp = mitoLengthm();
mitoARttemp = mitoARt();
mitoARmtemp = mitoARm();
mitoTMREparamtemp = mitoTMREparam();
mitoMitoSOXparamtemp = mitoMitoSOXparam();
%}
%{
% All small mitos
areathresh = 0.086;
mitoWidthmtemp = mitoWidthm(mitoAream<areathresh);
mitoAreamtemp = mitoAream(mitoAream<areathresh);
mitoLengthmtemp = mitoLengthm(mitoAream<areathresh);
mitoARmtemp = mitoARm(mitoAream<areathresh);
mitoMitoSOXparamtemp = mitoMitoSOXparam(mitoAream<areathresh);
%}
%{
% All MDVs
areathresh = 0.086;
ARthresh = 0.5; 
mitoWidthmtemp = mitoWidthm(mitoARm>ARthresh & mitoAream<areathresh);
mitoAreamtemp = mitoAream(mitoARm>ARthresh & mitoAream<areathresh);
mitoLengthmtemp = mitoLengthm(mitoARm>ARthresh & mitoAream<areathresh);
mitoARmtemp = mitoARm(mitoARm>ARthresh & mitoAream<areathresh);
mitoMitoSOXparamtemp = mitoMitoSOXparam(mitoARm>ARthresh & mitoAream<areathresh);
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
hvars{1} = mitoWidthmtemp(mitoMitoSOXparamtemp == 1);  % All mito
hvars{2} = mitoWidthmtemp(mitoMitoSOXparamtemp == 0);  % All mito
hvars{3} = mitoAreamtemp(mitoMitoSOXparamtemp == 1);  % All mito
hvars{4} = mitoAreamtemp(mitoMitoSOXparamtemp == 0);  % All mito
hvars{5} = mitoLengthmtemp(mitoMitoSOXparamtemp == 1);  % All mito
hvars{6} = mitoLengthmtemp(mitoMitoSOXparamtemp == 0);  % All mito
hvars{7} = mitoARmtemp(mitoMitoSOXparamtemp == 1);  % All mito
hvars{8} = mitoARmtemp(mitoMitoSOXparamtemp == 0);  % All mito
%}
%{
% MitoSOX+ v MitoSOX- sticks
ARthresh = 0.5;
hvars{1} = mitoWidthmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp<ARthresh);  % All mito
hvars{2} = mitoWidthmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp<ARthresh);  % All mito
hvars{3} = mitoAreamtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp<ARthresh);  % All mito
hvars{4} = mitoAreamtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp<ARthresh);  % All mito
hvars{5} = mitoLengthmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp<ARthresh);  % All mito
hvars{6} = mitoLengthmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp<ARthresh);  % All mito
hvars{7} = mitoARmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp<ARthresh);  % All mito
hvars{8} = mitoARmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp<ARthresh);  % All mito
%}
%{
% MitoSOX+ v MitoSOX- MDVs
ARthresh = 0.5;
hvars{1} = mitoWidthmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp>ARthresh);  % All mito
hvars{2} = mitoWidthmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp>ARthresh);  % All mito
hvars{3} = mitoAreamtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp>ARthresh);  % All mito
hvars{4} = mitoAreamtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp>ARthresh);  % All mito
hvars{5} = mitoLengthmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp>ARthresh);  % All mito
hvars{6} = mitoLengthmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp>ARthresh);  % All mito
hvars{7} = mitoARmtemp(mitoMitoSOXparamtemp==1 & mitoARmtemp>ARthresh);  % All mito
hvars{8} = mitoARmtemp(mitoMitoSOXparamtemp==0 & mitoARmtemp>ARthresh);  % All mito
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
ylimup = [0.4, 0.3, 0.3, 0.2];

boundlowlog = 0.007;
stepwidthlog = 0.05;
bounduplog = 3;
xlimlowlog = boundlowlog;
xlimuplog = bounduplog;
ylimuplog = 0.25;

%}
%{
% For all - smaller
boundlow = [0, 0, 0, 0];
stepwidth = [0.013, 0.02, 0.05, 0.05];
boundup = [0.5, 0.5, 1, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.3, 0.3, 0.3, 0.3];
%}
%{
% For small - v1
boundlow = [0, 0, 0, 0];
stepwidth = [0.025, 0.005, 0.04, 0.05];
boundup = [0.4, 0.1, 0.6, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.5, 0.2, 0.5, 0.2];
%}
%{
% For small - v2
boundlow = [0, 0, 0, 0];
stepwidth = [0.016, 0.0066, 0.04, 0.066];
boundup = [0.4, 0.1, 1, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.4, 0.3, 0.3, 0.3];
%}


fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';
legendtexts = {'MitoSOX+','MitoSOX-'};

xlabeltext1 = 'Mitochondria width (um)';
xlabeltext2 = 'Mitochondria area (um)';
xlabeltext3 = 'Mitochondria length (um)';
xlabeltext4 = 'Mitochondria aspect ratio';


mitoarealogfig = figure('rend','painters','pos',[500 100 400 300]);
[~,edges3] = histcounts(log10(hvars{3}),16);
histogram(hvars{3},10.^edges3,'Normalization','probability','FaceColor',lightGreen)
hold on
histogram(hvars{4},10.^edges3,'Normalization','probability','FaceColor',lightGray)
xlim([xlimlowlog xlimuplog])
xlabel(xlabeltext2)
xticks([0.01 0.1 1 10])
xticklabels([0.01 0.1 1 10])
%yticks([0:ylimuplog/12:ylimuplog])
%yticklabels({0,'','',ylimuplog/4,'','',ylimuplog/2,'','',3*ylimuplog/4,'','',ylimuplog})
yticks([0:ylimuplog/5:ylimuplog])
yticklabels({0,ylimuplog/5,2*ylimuplog/5,3*ylimuplog/5,4*ylimuplog/5,ylimuplog})
ylim([0 ylimuplog])
ylabel('Norm. frequency')
%title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtexts,'location','northeast');
set(gca,'FontSize',fontsize)
set(gca, 'xscale','log')
set(gca,'TickDir','out');
%saveas(gcf,'STEDConfArea','svg')