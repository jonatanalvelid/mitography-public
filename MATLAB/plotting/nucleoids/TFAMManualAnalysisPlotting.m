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

MitoAreaAx = mitoallAxdiv152019(:,1);
MitoAreaDend = mitoallDenddiv152019(:,1);
MitoAreaAx = [MitoAreaAx; mitoallAxdiv15old(:,1)];
MitoAreaAx = [MitoAreaAx; mitoallAxdiv7old(:,1)];
MitoAreaAx = [MitoAreaAx; mitoallAxdiv72019(:,1)];
MitoAreaDend = [MitoAreaDend; mitoallDenddiv15old(:,1)];
MitoAreaDend = [MitoAreaDend; mitoallDenddiv72019(:,1)];
MitoAreaDend = [MitoAreaDend; mitoallDenddiv7old(:,1)];
NumNucleoidesAx = mitoallAxdiv152019(:,2);
NumNucleoidesDend = mitoallDenddiv152019(:,2);
NumNucleoidesAx = [NumNucleoidesAx; mitoallAxdiv15old(:,2)];
NumNucleoidesDend = [NumNucleoidesDend; mitoallDenddiv15old(:,2)];

%%% PLOTTING CODE
fontsize = 16;
ylabeltext1 = 'Frequency [arb.u]';
xlabeltext2 = 'Mitochondrial area [um^2]';


% Stack bar graph of number of nucleoid per mitochondria per distance bin

groups = {'Axons','Dendrites'};
numnucl = 0:14;
percmatrixnumnucleoids = nan(length(numnucl),2);

matrixrowtemp = [];
for n=1:length(numnucl)
    matrixrowtemp = [matrixrowtemp sum(NumNucleoidesAx==numnucl(n))/length(NumNucleoidesAx)];
end
percmatrixnumnucleoids(:,1) = matrixrowtemp;

matrixrowtemp = [];
for n=1:length(numnucl)
    matrixrowtemp = [matrixrowtemp sum(NumNucleoidesDend==numnucl(n))/length(NumNucleoidesDend)];
end
percmatrixnumnucleoids(:,2) = matrixrowtemp;

percmatrixnumnucleoids(:,~any(percmatrixnumnucleoids,1)) = [];

X = categorical(groups);
NucleoidStackedBarGraph = figure('rend','painters','pos',[100 100 600 400]);
hstbarnucl = bar(X,percmatrixnumnucleoids','stacked');
ylim([0 1])
% xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
% set(gca,'ytick',[]);
legend('0 nucleoids','1 nucleoids','2 nucleoids','3 nucleoids','4 nucleoids','5 nucleoids','6 nucleoids');

[h,p] = kstest2(NumNucleoidesAx,NumNucleoidesDend);
disp(p)

% Area boxplot vs num nucleoids

meanareaax = []; stdareaax = []; allareaax = nan(300,5);
for i=0:4
    if i==4
        mitodatatemp = MitoAreaAx(NumNucleoidesAx>=i);
        meanareaax(i+1) = mean(mitodatatemp);
        stdareaax(i+1) = std(mitodatatemp);
        allareaax(1:length(mitodatatemp),i+1) = mitodatatemp;     
    else
        mitodatatemp = MitoAreaAx(NumNucleoidesAx==i);
        meanareaax(i+1) = mean(mitodatatemp);
        stdareaax(i+1) = std(mitodatatemp);
        allareaax(1:length(mitodatatemp),i+1) = mitodatatemp;
    end
end
meanareadend = []; stdareadend = []; allareadend = nan(300,5);
for i=0:4
    if i==4
        mitodatatemp = MitoAreaDend(NumNucleoidesDend>=i);
        meanareadend(i+1) = mean(mitodatatemp);
        stdareadend(i+1) = std(mitodatatemp);
        allareadend(1:length(mitodatatemp),i+1) = mitodatatemp;     
    else
        mitodatatemp = MitoAreaDend(NumNucleoidesDend==i);
        meanareadend(i+1) = mean(mitodatatemp);
        stdareadend(i+1) = std(mitodatatemp);
        allareadend(1:length(mitodatatemp),i+1) = mitodatatemp;
    end
end
nuclgroups = {'0','1','2','3','4+'};

AreaErrorbarfigax = figure('rend','painters','pos',[100 100 600 400]);
hareaax = boxplot(allareaax,nuclgroups);
hold on

markersize = 5;
x1=ones(length(allareaax)).*(1+(rand(length(allareaax))-0.5)/3);
x2=ones(length(allareaax)).*(1+(rand(length(allareaax))-0.5)/6);
x3=ones(length(allareaax)).*(1+(rand(length(allareaax))-0.5)/9);
x4=ones(length(allareaax)).*(1+(rand(length(allareaax))-0.5)/12);
x5=ones(length(allareaax)).*(1+(rand(length(allareaax))-0.5)/15);
f1=scatter(x1(:,1), allareaax(:,1), markersize,'k','filled');
f1.MarkerFaceAlpha = 1;
f2=scatter(x2(:,2).*2, allareaax(:,2), markersize,'k','filled');
f2.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f3=scatter(x3(:,3).*3, allareaax(:,3), markersize,'k','filled');
f3.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f4=scatter(x4(:,4).*4, allareaax(:,4), markersize,'k','filled');
f4.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f5=scatter(x5(:,5).*5, allareaax(:,5), markersize,'k','filled');
f5.MarkerFaceAlpha = f1.MarkerFaceAlpha;

ylim([0 8])
% xlabel(ylabeltext2)
ylabel(xlabeltext2)
set(gca,'FontSize',16)
set(gca,'TickDir','out');


AreaErrorbarfigdend = figure('rend','painters','pos',[100 100 600 400]);
hareadend = boxplot(allareadend,nuclgroups);
hold on

markersize = 5;
x1=ones(length(allareadend)).*(1+(rand(length(allareadend))-0.5)/3);
x2=ones(length(allareadend)).*(1+(rand(length(allareadend))-0.5)/6);
x3=ones(length(allareadend)).*(1+(rand(length(allareadend))-0.5)/9);
x4=ones(length(allareadend)).*(1+(rand(length(allareadend))-0.5)/12);
x5=ones(length(allareadend)).*(1+(rand(length(allareadend))-0.5)/15);
f1=scatter(x1(:,1), allareadend(:,1), markersize,'k','filled');
f1.MarkerFaceAlpha = 1;
f2=scatter(x2(:,2).*2, allareadend(:,2), markersize,'k','filled');
f2.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f3=scatter(x3(:,3).*3, allareadend(:,3), markersize,'k','filled');
f3.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f4=scatter(x4(:,4).*4, allareadend(:,4), markersize,'k','filled');
f4.MarkerFaceAlpha = f1.MarkerFaceAlpha;
f5=scatter(x5(:,5).*5, allareadend(:,5), markersize,'k','filled');
f5.MarkerFaceAlpha = f1.MarkerFaceAlpha;

ylim([0 7])
% xlabel(ylabeltext2)
ylabel(xlabeltext2)
set(gca,'FontSize',16)
set(gca,'TickDir','out');


disp('KS-tests axon areas')
for n=1:4
    for m=n+1:5
        [h,p] = kstest2(allareaax(:,n),allareaax(:,m));
        disp(n)
        disp(m)
        disp(p)
    end
end

disp('KS-tests dendrite areas')
for n=1:4
    for m=n+1:5
        [h,p] = kstest2(allareadend(:,n),allareadend(:,m));
        disp(n)
        disp(m)
        disp(p)
    end
end
