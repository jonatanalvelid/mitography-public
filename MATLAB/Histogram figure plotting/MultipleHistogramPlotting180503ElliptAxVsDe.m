%%% MULTIPLE HISTOGRAM PLOTTING
h1var = mitolengthOnlyFitBigFOVDIV17Ax./mitowidthBigFOVDIV17Ax;
h2var = mitolengthOnlyFitBigFOVDIV17De./mitowidthBigFOVDIV17De;
% h1var = mitolengthOnlyFitBigFOVDIV3Ax./mitowidthBigFOVDIV3Ax;
% h2var = mitolengthOnlyFitBigFOVDIV3De./mitowidthBigFOVDIV3De;

boundlow1 = 0;
stepwidth1 = 0.5;
boundup1 = 25;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.15;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'Axon';
legendtext2 = 'Dendrites';

xlabeltext1 = 'Ellipticity, L/W_m [arb.u.]';

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
