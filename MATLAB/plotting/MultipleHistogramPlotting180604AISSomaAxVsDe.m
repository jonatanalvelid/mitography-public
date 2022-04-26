%%% MULTIPLE HISTOGRAM PLOTTING
colors = lines(2);

h1var = mitowidthAISSomaAx;
h2var = mitowidthAISSomaDe;
h3var = mitoareaAISSomaAx;
h4var = mitoareaAISSomaDe;
h5var = mitolengthOnlyFitAISSomaAx;
h6var = mitolengthOnlyFitAISSomaDe;

boundlow1 = 0;
stepwidth1 = 0.0125;
boundup1 = 0.4;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.2;

boundlow2 = 0;
stepwidth2 = 0.075;
boundup2 = 3;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.3;

boundlow3 = 0;
stepwidth3 = 0.125;
boundup3 = 5;
xlimlow3 = boundlow3;
xlimup3 = boundup3;
ylimup3 = 0.2;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'Axon';
legendtext2 = 'Dendrites';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria area [µm^2]';
xlabeltext3 = 'Mitochondria length [µm]';



%%%,'FaceAlpha',opacity %%% If you want different opacity


mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)

mitoareafig = figure('rend','painters','pos',[500 100 300 300]);
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
hold on
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)

mitolenfig = figure('rend','painters','pos',[900 100 300 300]);
h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'Normalization','probability');
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
%title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)