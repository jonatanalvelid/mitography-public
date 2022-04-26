%%% MULTIPLE HISTOGRAM PLOTTING
colors = lines(2);

h1var = mitolengthstedS./mitowidthstedS;
h2var = mitolengthstedNS./mitowidthstedNS;

boundlow1 = 0;
stepwidth1 = 1;
boundup1 = 30;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.2;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'MPS';
legendtext2 = 'Non-MPS';

titletext1 = 'N=833';
xlabeltext1 = 'Mitochondria width [µm]';

%%%,'FaceAlpha',opacity %%% If you want different opacity

mitowidfig = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
h3 = histogram([h1var;h2var],boundlow1:stepwidth1:boundup1,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)
