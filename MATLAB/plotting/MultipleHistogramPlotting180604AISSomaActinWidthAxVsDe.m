%%% MULTIPLE HISTOGRAM PLOTTING
h1var = actinwidthAISSomaAx;
h2var = actinwidthAISSomaDe;

boundlow1 = 0;
stepwidth1 = 0.05;
boundup1 = 1.5;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.15;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'Axon';
legendtext2 = 'Dendrites';

xlabeltext1 = 'Local actin width W [µm]';
xlabeltext2 = 'Mito-actin distance D [µm]';

%%%,'FaceAlpha',opacity %%% If you want different opacity

f1 = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
