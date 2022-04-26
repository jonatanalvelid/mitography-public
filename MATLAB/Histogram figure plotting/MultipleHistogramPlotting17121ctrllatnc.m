%%% MULTIPLE HISTOGRAM PLOTTING
h1var = mitowidthcontrol;
h2var = mitowidthnc;
h3var = mitowidthlat;
h4var = mitoareacontrol;
h5var = mitoareanc;
h6var = mitoarealat;
h7var = mitolengthcontrol;
h8var = mitolengthnc;
h9var = mitolengthlat;

boundlow1 = 0;
stepwidth1 = 0.025;
boundup1 = 0.5;
xlimlow1 = boundlow1;
xlimup1 = boundup1;
ylimup1 = 0.35;

boundlow2 = 0;
stepwidth2 = 0.05;
boundup2 = 1;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 0.35;

boundlow3 = 0;
stepwidth3 = 0.2;
boundup3 = 4;
xlimlow3 = boundlow3;
xlimup3 = boundup3;
ylimup3 = 0.35;

fontsize = 16;
opacity = 0.4;

legendtext1 = 'Control';
legendtext2 = 'Nocodazole';
legendtext3 = 'Latrunculin';

titletext1 = 'N=833';
titletext2 = 'N=833';
titletext3 = 'N=833';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria area [µm^2]';
xlabeltext3 = 'Mitochondria length [µm]';

mitowidlenareafig = figure('rend','painters','pos',[100 100 2400 1500]);

subplot(1,3,1)
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
h3 = histogram(h3var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext1)
ylim([0 ylimup1])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h1var))));
legend(legendtext1,legendtext2,legendtext3);
set(gca,'FontSize',fontsize)

subplot(1,3,2)
h4 = histogram(h4var,boundlow2:stepwidth2:boundup2,'FaceAlpha',opacity,'Normalization','probability');
hold on
h5 = histogram(h5var,boundlow2:stepwidth2:boundup2,'FaceAlpha',opacity,'Normalization','probability');
h6 = histogram(h6var,boundlow2:stepwidth2:boundup2,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow2 xlimup2])
xlabel(xlabeltext2)
ylim([0 ylimup2])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h4var))));
legend(legendtext1,legendtext2,legendtext3);
set(gca,'FontSize',fontsize)

subplot(1,3,3)
h7 = histogram(h7var,boundlow3:stepwidth3:boundup3,'FaceAlpha',opacity,'Normalization','probability');
hold on
h8 = histogram(h8var,boundlow3:stepwidth3:boundup3,'FaceAlpha',opacity,'Normalization','probability');
h9 = histogram(h9var,boundlow3:stepwidth3:boundup3,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow3 xlimup3])
xlabel(xlabeltext3)
ylim([0 ylimup3])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h7var))));
legend(legendtext1,legendtext2,legendtext3);
set(gca,'FontSize',fontsize)