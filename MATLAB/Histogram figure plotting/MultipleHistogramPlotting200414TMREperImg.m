%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: \\X:\Mitography\MitoSOX-MitographyAnalysis\mitoData-RL-200414-perImg.mat

colors = lines(24);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

n = 2;

if n==1
    % Take all mitos - Width
    mitotempvar = mitoWidth;
elseif n==2
    % Take all mitos - Area
    mitotempvar = mitoArea;
elseif n==3
    % Take all mitos - Length
    mitotempvar = mitoLength;
elseif n==4
    % Take all mitos - AR
    mitotempvar = mitoAR;
end
h1var = mitotempvar.(sprintf('Image%d',1));  % All mito
h2var = mitotempvar.(sprintf('Image%d',2));  % All mito
h3var = mitotempvar.(sprintf('Image%d',3));  % All mito
h4var = mitotempvar.(sprintf('Image%d',4));  % All mito
h5var = mitotempvar.(sprintf('Image%d',5));  % All mito
h6var = mitotempvar.(sprintf('Image%d',6));  % All mito
h9var = mitotempvar.(sprintf('Image%d',9));  % All mito
h10var = mitotempvar.(sprintf('Image%d',10));  % All mito
h11var = mitotempvar.(sprintf('Image%d',11));  % All mito
h12var = mitotempvar.(sprintf('Image%d',12));  % All mito
h13var = mitotempvar.(sprintf('Image%d',13));  % All mito
h14var = mitotempvar.(sprintf('Image%d',14));  % All mito
h15var = mitotempvar.(sprintf('Image%d',15));  % All mito
h16var = mitotempvar.(sprintf('Image%d',16));  % All mito
h17var = mitotempvar.(sprintf('Image%d',17));  % All mito
h18var = mitotempvar.(sprintf('Image%d',18));  % All mito
h19var = mitotempvar.(sprintf('Image%d',19));  % All mito
h20var = mitotempvar.(sprintf('Image%d',20));  % All mito
h21var = mitotempvar.(sprintf('Image%d',21));  % All mito
h22var = mitotempvar.(sprintf('Image%d',22));  % All mito
h23var = mitotempvar.(sprintf('Image%d',23));  % All mito
h24var = mitotempvar.(sprintf('Image%d',24));  % All mito

%{
% Only take small mitos
areathresh = 0.086;
mitoWidthsmall = mitoWidthm(mitoAream<areathresh);
mitoWidthbig = mitoWidthm(mitoAream>areathresh);
mitoLengthsmall = mitoLengthm(mitoAream<areathresh);
mitoLengthbig = mitoLengthm(mitoAream>areathresh);
mitoAreasmall = mitoAream(mitoAream<areathresh);
mitoAreabig = mitoAream(mitoAream>areathresh);
mitoARsmall = mitoARm(mitoAream<areathresh);
mitoARbig = mitoARm(mitoAream>areathresh);
mitoMitoSOXparamsmall = mitoMitoSOXparam(mitoAream<areathresh);
mitoMitoSOXparambig = mitoMitoSOXparam(mitoAream>areathresh);

h1var = mitoWidthsmall(mitoMitoSOXparamsmall==1);  % Small MitoSOX+ mito
h2var = mitoWidthsmall(mitoMitoSOXparamsmall==0);  % Small MitoSOX- mito
h3var = mitoAreasmall(mitoMitoSOXparamsmall==1);  % Small MitoSOX+ mito
h4var = mitoAreasmall(mitoMitoSOXparamsmall==0);  % Small MitoSOX- mito
h5var = mitoLengthsmall(mitoMitoSOXparamsmall==1);  % Small MitoSOX+ mito
h6var = mitoLengthsmall(mitoMitoSOXparamsmall==0);  % Small MitoSOX- mito
h7var = mitoARsmall(mitoMitoSOXparamsmall==1);  % Small MitoSOX+ mito
h8var = mitoARsmall(mitoMitoSOXparamsmall==0);  % Small MitoSOX- mito
%}

%[1=Width, 2=Area, 3=Length, 4=AR]
boundlow = [0, 0, 0, 0];
stepwidth = [0.03, 0.1, 0.2, 0.05];
boundup = [0.4, 3, 5, 1];
xlimlow = boundlow;
xlimup = boundup;
ylimup = [0.5, 0.7, 0.5, 0.5];

fontsize = 12;
opacity = 0.5;

% legendtext1 = 'All mito';

xlabeltext = {'Mitochondria width [um]','Mitochondria area [um^2]','Mitochondria length [um]','Mitochondria aspect ratio [arb.u.]'};

%%%,'FaceAlpha',opacity %%% If you want different opacity
mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(1,:));
hold on
h2 = histogram(h2var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(2,:));
h3 = histogram(h3var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(3,:));
h4 = histogram(h4var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(4,:));
h5 = histogram(h5var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(5,:));
h6 = histogram(h6var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(6,:));
h9 = histogram(h9var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(9,:));
h10 = histogram(h10var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(10,:));
h11 = histogram(h11var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(11,:));
h12 = histogram(h12var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(12,:));
h13 = histogram(h13var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(13,:));
h14 = histogram(h14var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(14,:));
h15 = histogram(h15var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(15,:));
h16 = histogram(h16var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(16,:));
h17 = histogram(h17var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(17,:));
h18 = histogram(h18var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(18,:));
h19 = histogram(h19var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(19,:));
h20 = histogram(h20var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(20,:));
h21 = histogram(h21var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(21,:));
h22 = histogram(h22var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(22,:));
h23 = histogram(h23var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(23,:));
h24 = histogram(h24var,boundlow(n):stepwidth(n):boundup(n),'Normalization','probability','FaceColor',colors(24,:));
xlim([xlimlow(n) xlimup(n)])
xlabel(xlabeltext(n))
ylim([0 ylimup(n)])
ylabel('Norm. frequency')
%title(strcat(titletext1,', N=',num2str(length(h1var))));
% legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
yticks([0:ylimup(n)/12:ylimup(n)])
yticklabels({0,'','',ylimup(n)/4,'','',ylimup(n)/2,'','',3*ylimup(n)/4,'','',ylimup(n)})

hmat = nan(24,24);
pmat = nan(24,24);
for n = [1:6,9:24]
    for m = [1:6,9:24]
        [h,p] = kstest2(eval(sprintf('h%dvar',n)),eval(sprintf('h%dvar',m)));
        hmat(n,m) = h;
        pmat(n,m) = p;
    end
end

figure()
bar3(hmat)

%{
% mitoarealogfig = figure('rend','painters','pos',[1700 100 300 300]);
% n = 5; nbins = 30;
% [~,binedges] = histcounts(log10(h9var),nbins);
% histogram(h9var,10.^binedges,'Normalization','probability')
% hold on
% [~,binedges] = histcounts(log10(h10var),nbins);
% histogram(h10var,10.^binedges,'Normalization','probability')
% % [~,binedges] = histcounts(log10(h11var),nbins);
% % histogram(h11var,10.^binedges,'Normalization','probability')
% % [~,binedges] = histcounts(log10(h12var),nbins);
% % histogram(h12var,10.^binedges,'Normalization','probability')
% set(gca, 'xscale','log')
% ylabel('Norm. frequency')
% xlabel(xlabeltext2)
% %title(strcat(titletext3,', N=',num2str(length(h5var))));
% % legend(legendtext1,legendtext2);
% legend('Raw','RL');
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');


% Box plots
hdouble = [h1var;h2var];
groupings = [zeros(1,length(h1var)),ones(1,length(h2var))];
widthboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 1;
h9 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h3var;h4var];
groupings = [zeros(1,length(h3var)),ones(1,length(h4var))];
areaboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 2;
h10 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h5var;h6var];
groupings = [zeros(1,length(h5var)),ones(1,length(h6var))];
lengthboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 3;
h11 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})

hdouble = [h7var;h8var];
groupings = [zeros(1,length(h7var)),ones(1,length(h8var))];
arboxplots = figure('rend','painters','pos',[100 100 300 150]);
n = 4;
h12 = boxplot(hdouble,groupings,'orientation','horizontal','BoxStyle','outline','Colors',colors,'OutlierSize',4,'Symbol','k+','Widths',0.8);
xlim([xlimlow(n) xlimup(n)])
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
set(gca,'yticklabel',[])
set(gca,'ytick',[])
xticks([xlimlow(n):(xlimup(n)-xlimlow(n))/12:xlimup(n)])
xticklabels({xlimlow(n),'','',(xlimup(n)-xlimlow(n))/4,'','',(xlimup(n)-xlimlow(n))/2,'','',3*(xlimup(n)-xlimlow(n))/4,'','',xlimup(n)})
%}