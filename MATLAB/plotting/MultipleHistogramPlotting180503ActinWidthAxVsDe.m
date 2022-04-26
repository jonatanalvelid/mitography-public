%%% MULTIPLE HISTOGRAM PLOTTING
h1var = actinwidthBigFOVDIV17Ax;
h2var = actinwidthBigFOVDIV17De;
% h1var = actinwidthBigFOVDIV3Ax;
% h2var = actinwidthBigFOVDIV3De;

boundlow1 = 0;
stepwidth1 = 0.0375;
boundup1 = 1.5;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.2;

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
