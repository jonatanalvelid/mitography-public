%%% MULTIPLE HISTOGRAM PLOTTING
colormap(lines);
colors = lines(5);
color = colors(5,:);

h1var = mitopatchoverlapPliveActinSinglePeak;
h2var = mitopatchoverlapNPliveActinNonSinglePeak;

boundlow1 = 0;
stepwidth1 = 0.05;
boundup1 = 1;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.1;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'Actin SP';
legendtext2 = 'Actin MP';

xlabeltext1 = 'Mito-patch overlap AO [arb.u.]';

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
