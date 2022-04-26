%%%
% Mitography - TFAM analysis - summarize data
% Summarize the data and group based on axon distance.
%----------------------------
% Version: 200310
% Last updated features: Added mito area plotting against number of
% nucleoids.
%
% @jonatanalvelid
%%%

groups = [2.5 7.5 15 30 50 70 90];
AxonDistGroup = [];

AxonDistance = mitodata(:,1);
NumNucleotides = mitodata(:,2);
for i = 1:length(AxonDistance)
    [~,closestIdx] = min(abs(AxonDistance(i)-groups));
    AxonDistGroup(i) = groups(closestIdx);
end
% AxonDistGroup = ceil(AxonDistance/groupsize)*groupsize;
% AxonDistGroup(AxonDistGroup>300) = 300;  % The group for all distant mitos
% AxonDistGroup(AxonDistGroup==100) = 80;
AxonDistGroup = AxonDistGroup';
mitodatatable = table(AxonDistance,AxonDistGroup,NumNucleotides);

stats = grpstats(mitodatatable,'AxonDistGroup',{'mean','sem','std'},'DataVars','NumNucleotides');

meannucl = table2array(stats(:,'mean_NumNucleotides'));
stdnucl = table2array(stats(:,'std_NumNucleotides'));
axondist = table2array(stats(:,'AxonDistGroup'));
numempty = [];
numtot = [];
% Check percentage of group elements that are 0
% groups = groupsize:groupsize:300;
for i = 1:length(groups)
    numempty(i) = sum(NumNucleotides(AxonDistGroup==groups(i))==0);
    numtot(i) = length(NumNucleotides(AxonDistGroup==groups(i)));
    disp(groups(i))
    disp(numempty(i)/numtot(i))
end

%{
scatter(groups, numempty./numtot)
ylim([0 1])
xlabel('Axonal distance from soma [um]')
ylabel('Ratio of mito with 0 nucleotides')
set(gca,'FontSize',14)
%}

%%% PLOTTING CODE

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

xlimlow1 = 0;
xlimup1 = 300;
ylimup1 = 2;

xlimlow2 = 0;
xlimup2 = 4;
ylimup2 = 7;

fontsize = 20;

ylabeltext1 = 'Frequency [arb.u]';
xlabeltext1 = 'Axonal distance from soma [um]';

ylabeltext2 = 'Number of nucleoids';
xlabeltext2 = 'Mitochondrial area [um^2]';

%{
TFAMfig = figure('rend','painters','pos',[100 100 600 400]);
h1 = errorbar(axondist,meannucl,stdnucl);
xlim([xlimlow1 xlimup1])
ylim([0 ylimup1])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
% xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
% xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
% yticks([0:ylimup1/12:ylimup1])
% yticklabels({0,'','',ylimup1/4,'','',ylimup1/2,'','',3*ylimup1/4,'','',ylimup1})

% 
% % Area vs num nucleoids scatter plot
% 
% AreaScatterfig = figure('rend','painters','pos',[100 100 600 400]);
% h2 = scatter(MitoArea,NumNucleotides);
% xlim([xlimlow2 xlimup2])
% ylim([0 ylimup2])
% xlabel(xlabeltext2)
% ylabel(ylabeltext2)
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% % xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
% % xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
% % yticks([0:ylimup1/12:ylimup1])
% % yticklabels({0,'','',ylimup1/4,'','',ylimup1/2,'','',3*ylimup1/4,'','',ylimup1})
%}

meanarea = []; stdarea = []; allarea = nan(300,5);
for i=0:4
    if i==4
        mitodatatemp = mitodata(mitodata(:,2)==i | mitodata(:,2)==i+1 | mitodata(:,2)==i+2,3);
        meanarea(i+1) = mean(mitodatatemp);
        stdarea(i+1) = std(mitodatatemp);
        allarea(1:length(mitodatatemp),i+1) = mitodatatemp;     
    else
        mitodatatemp = mitodata(mitodata(:,2)==i,3);
        meanarea(i+1) = mean(mitodatatemp);
        stdarea(i+1) = std(mitodatatemp);
        allarea(1:length(mitodatatemp),i+1) = mitodatatemp;
    end
end
nuclgroups = {'0','1','2','3','4+'};


% Area boxplot vs num nucleoids with data points jittered

AreaErrorbarfig = figure('rend','painters','pos',[100 100 600 400]);
areaerrorplot = boxplot(allarea,nuclgroups);
hold on

markersize = 5;
x1=ones(length(allarea)).*(1+(rand(length(allarea))-0.5)/3);
x2=ones(length(allarea)).*(1+(rand(length(allarea))-0.5)/6);
x3=ones(length(allarea)).*(1+(rand(length(allarea))-0.5)/9);
x4=ones(length(allarea)).*(1+(rand(length(allarea))-0.5)/12);
x5=ones(length(allarea)).*(1+(rand(length(allarea))-0.5)/15);
f1=scatter(x1(:,1), allarea(:,1), markersize,'k','filled');
f1.MarkerFaceAlpha = 1;
f2=scatter(x2(:,2).*2, allarea(:,2), markersize,'k','filled');
f2.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f3=scatter(x3(:,3).*3, allarea(:,3), markersize,'k','filled');
f3.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f4=scatter(x4(:,4).*4, allarea(:,4), markersize,'k','filled');
f4.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f5=scatter(x5(:,5).*5, allarea(:,5), markersize,'k','filled');
f5.MarkerFaceAlpha = f1.MarkerFaceAlpha;

ylim([0 5])
xlabel(ylabeltext2)
ylabel(xlabeltext2)
set(gca,'FontSize',16)
set(gca,'TickDir','out');


% Stack bar graph of number of nucleoid per mitochondria per distance bin

mitodatatablesort = sortrows(mitodatatable,1);
axondistgroupsort = mitodatatablesort.AxonDistGroup;
numnucleoidsort = mitodatatablesort.NumNucleotides;
boxplotgroups = [];
percmatrixnumnucleoids = [];
numtotcum = cumsum(numtot);
startposcum = [0 numtotcum];
numnucl = 0:6;
allnumnucleoids = nan(200,length(groups));

for i=1:length(groups)
    gtemp = repmat({num2str(groups(i))},numtot(i),1);
    numnucleoidtemp = numnucleoidsort(startposcum(i)+1:startposcum(i+1));
    boxplotgroups = [boxplotgroups;gtemp];
    matrixrowtemp = [];
    for n=1:length(numnucl)
        matrixrowtemp = [matrixrowtemp sum(numnucleoidtemp==numnucl(n))/numtot(i)];
    end
    percmatrixnumnucleoids(:,i) = matrixrowtemp;
    allnumnucleoids(1:length(numnucleoidtemp),i) = numnucleoidtemp;
end
% percmatrixnumnucleoids(:,~any(percmatrixnumnucleoids,1)) = [];
allnumnucleoids(:,~any(allnumnucleoids,1)) = [];

% X = categorical({'0-20','20-40','40-60','60-83','100+'});
% X = reordercats(X,{'0-20','20-40','40-60','60-83','100+'});
% X = categorical({'0-10','10-20','20-30','30-40','40-50','50-60','60-70','70-83','100+'});
% X = reordercats(X, {'0-10','10-20','20-30','30-40','40-50','50-60','60-70','70-83','100+'});
NucleoidStackedBarGraph = figure('rend','painters','pos',[100 100 2000 1000]);
% h3 = bar(X,percmatrixnumnucleoids','stacked');
h1 = bar(percmatrixnumnucleoids','stacked');
ylim([0 1])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
% set(gca,'ytick',[]);
legend('0 nucleoids','1 nucleoids','2 nucleoids','3 nucleoids','4 nucleoids','5 nucleoids','6 nucleoids');


%{
% % Box plot of number of nucleoid per mitochondria per distance bin
% 
% NucleoidStackedBarGraph = figure('rend','painters','pos',[100 100 600 400]);
% h6 = boxplot(allnumnucleoids);
% ylim([0 6])
% xlabel(xlabeltext1)
% ylabel(ylabeltext2)
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% % set(gca,'ytick',[]);
% % legend('0 nucleoids','1 nucleoids','2 nucleoids','3 nucleoids','4 nucleoids','5 nucleoids','6 nucleoids');
%}