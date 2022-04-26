%%% MULTIPLE HISTOGRAM PLOTTING
h1var = mitowidthsted;
h2var = mitowidthconfocal;
h3var = mitoareasted;
h4var = mitoareaconfocal;
h5var = mitolengthsted;
h6var = mitolengthconfocal;

boundlow1 = 0;
stepwidth1 = 0.03;
boundup1 = 0.7;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.3;

boundlow2 = 0;
stepwidth2 = 0.15;
boundup2 = 2;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.3;

boundlow3 = 0;
stepwidth3 = 0.25;
boundup3 = 4;
xlimlow3 = boundlow3;
xlimup3 = boundup3;
ylimup3 = 0.2;

fontsize = 16;
opacity = 0.4;

legendtext1 = 'STED';
legendtext2 = 'Confocal';

titletext1 = 'N=833';
titletext2 = 'N=833';
titletext3 = 'N=833';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria area [µm^2]';
xlabeltext3 = 'Mitochondria length [µm]';

mitowidlenareafig = figure('rend','painters','pos',[100 100 2400 1700]);

subplot(1,3,1)
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
title(strcat(titletext1,', N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)

subplot(1,3,2)
h3 = histogram(h3var,boundlow2:stepwidth2:boundup2,'FaceAlpha',opacity,'Normalization','probability');
hold on
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
title(strcat(titletext2,', N=',num2str(length(h3var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)

subplot(1,3,3)
h5 = histogram(h5var,boundlow3:stepwidth3:boundup3,'FaceAlpha',opacity,'Normalization','probability');
hold on
h6 = histogram(h6var,boundlow3:stepwidth3:boundup3,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
title(strcat(titletext3,', N=',num2str(length(h5var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)