%%% MULTIPLE HISTOGRAM PLOTTING
colors = lines(2);

h1var = actinwidthstedS;
h2var = actinwidthstedNS;
h3var = actinmitodiststedS;
h4var = actinmitodiststedNS;

boundlow1 = 0;
stepwidth1 = 0.05;
boundup1 = 1.5;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.15;

fontsize = 12;
opacity = 0.5;

boundlow2 = -1;
stepwidth2 = 0.05;
boundup2 = 0.7;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.15;

fontsize = 12;
opacity = 0.5;

legendtext1 = 'MPS';
%legendtext2 = 'Non-MPS';

%titletext1 = 'N=833';
xlabeltext1 = 'Local actin width W [µm]';
xlabeltext2 = 'Mito-actin distance D [µm]';

%%%,'FaceAlpha',opacity %%% If you want different opacity

f1 = figure('rend','painters','pos',[100 100 300 300]);
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
%hold on
%h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
legend(legendtext1);
set(gca,'FontSize',fontsize)

f2 = figure('rend','painters','pos',[100 100 300 300]);
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
%hold on
%h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'Normalization','probability');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
legend(legendtext1);
set(gca,'FontSize',fontsize)
