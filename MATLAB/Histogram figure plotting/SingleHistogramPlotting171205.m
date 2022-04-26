%%% MULTIPLE HISTOGRAM PLOTTING
h1var = mitodisplS;
h2var = mitodisplNS;

boundlow1 = 0;
stepwidth1 = 0.03;
boundup1 = 0.7;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.15;

fontsize = 16;

legendtext1 = 'Stripes';
legendtext2 = 'Non-stripes';

xlabeltext1 = 'Mitochondria-actin membrane distance [µm]';

mitowidlenareafig = figure('rend','painters','pos',[100 100 1200 1000]);

h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceAlpha',0.4,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'FaceAlpha',0.4,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)