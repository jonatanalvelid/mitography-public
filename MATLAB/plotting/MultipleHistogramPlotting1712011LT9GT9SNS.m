%%% MULTIPLE HISTOGRAM PLOTTING
h1var = mitolengthSLT9./mitowidthSLT9;
h2var = mitolengthNSLT9./mitowidthNSLT9;
h3var = mitolengthSGT9./mitowidthSGT9;
h4var = mitolengthNSGT9./mitowidthNSGT9;
h5var = [mitolengthSLT9;mitolengthNSLT9]./[mitowidthSLT9;mitowidthNSLT9];
h6var = [mitolengthSGT9;mitolengthNSGT9]./[mitowidthSGT9;mitowidthNSGT9];

% s1var = mitolengthSLT9;
% s2var = mitowidthSLT9;
% s3var = mitolengthNSLT9;
% s4var = mitowidthNSLT9;
% s5var = mitolengthSGT9;
% s6var = mitowidthSGT9;
% s7var = mitolengthNSGT9;
% s8var = mitowidthNSGT9;

boundlow1 = 0.5;
stepwidth1 = 1;
boundup1 = 19.5;
xlimlow1 = boundlow1-0.5;
xlimup1 = boundup1+0.5;
ylimup1 = 0.25;

boundlow2 = 0;
boundup2 = 0.5;
xlimlow2 = boundlow2;
xlimup2 = boundup2;
ylimup2 = 4;

fontsize = 16;
opacity = 0.4;

legendtext1 = 'DIV<9, stripes';
legendtext2 = 'DIV<9, non-stripes';
legendtext3 = 'DIV>9, stripes';
legendtext4 = 'DIV>9, non-stripes';
legendtext5 = 'DIV<9';
legendtext6 = 'DIV>9';

titletext1 = 'Mitochondria width';
titletext2 = 'Mitochondria length/width';
titletext3 = 'Mitochondria length';

xlabeltext1 = 'Mitochondria width [µm]';
xlabeltext2 = 'Mitochondria length/width [arb.u.]';
xlabeltext3 = 'Mitochondria length [µm]';

figure('rend','painters','pos',[100 100 2400 1200]);
subplot(1,2,1)
h1 = histogram(h1var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
hold on
h2 = histogram(h2var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
%h3 = histogram(h3var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
%h4 = histogram(h4var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext2)
ylim([0 ylimup1])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h1var))));
legend(legendtext1,legendtext2);
set(gca,'FontSize',fontsize)

subplot(1,2,2)
h5 = histogram(h5var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
hold on
h6 = histogram(h6var,boundlow1:stepwidth1:boundup1,'FaceAlpha',opacity,'Normalization','probability');
xlim([xlimlow1 xlimup1])
xlabel(xlabeltext2)
ylim([0 ylimup1])
ylabel('Norm. frequency')
title(strcat('N=',num2str(length(h1var))));
legend(legendtext5,legendtext6);
set(gca,'FontSize',fontsize)
set(gca,'FontSize',fontsize)
