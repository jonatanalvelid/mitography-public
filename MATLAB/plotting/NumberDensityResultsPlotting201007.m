lightGray = [0.7 0.7 0.7];
midGray = [0.4 0.4 0.4];
darkGray = [0.2 0.2 0.2];

% Axon/dendrite split of all mdm (figure 1)
%{
% Axon/dendrite split of all mdm (figure 1)
ndens_sticks_ax = [0.85729472 0.99140157 0.87638194 4.55331937];
ndens_mdvs_ax = [0.42864736 2.37936378 3.50552778 0];
ndens_sticks_de = [2.48827401 0.30802782 0.41942702];
ndens_mdvs_de = [1.244137 1.84816693 5.03312425];
ndens_sticks_cs = [1.02957453 0.62211946 1.80619525];
ndens_mdvs_cs = [2.57393632 2.48847783 0.90309762];
ndens_sticks_tot = [1.27522962 0.8510226 0.59898281 2.65451959];
ndens_mdvs_tot = [0.63761481 2.2912147 3.35430372 0.53090392];

xplot1 = [1 4 7];
xplot2 = [2 5 8];
xplot = [1 2 4 5 7 8];
mean_all = [mean(ndens_mdvs_tot) mean(ndens_sticks_tot) mean(ndens_mdvs_ax) mean(ndens_sticks_ax) mean(ndens_mdvs_de) mean(ndens_sticks_de)];
mean_mdvs = [mean(ndens_mdvs_tot) mean(ndens_mdvs_ax) mean(ndens_mdvs_de)];
mean_sticks = [mean(ndens_sticks_tot) mean(ndens_sticks_ax) mean(ndens_sticks_de)];
std_all = [std(ndens_mdvs_tot) std(ndens_sticks_tot) std(ndens_mdvs_ax) std(ndens_sticks_ax) std(ndens_mdvs_de) std(ndens_sticks_de)];

fig1 = figure('rend','painters','pos',[410 100 450 370]);
b = bar(xplot1,mean_mdvs,0.3,'FaceColor',lightGray);
hold on
b = bar(xplot2,mean_sticks,0.3,'FaceColor',darkGray);
eb = errorbar(xplot,mean_all,std_all,std_all,'k','LineStyle','none');
xlim([0.2 8.8])
xticks([1.5 4.5 7.5])
xticklabels({'All neurites','Axons','Dendrites'})
ylim([0 6])
yticklabels({'0','','2','','4','','6','','8'})
b.CData(1,:) = lightGray;
b.CData(3,:) = lightGray;
b.CData(5,:) = lightGray;
b.CData(2,:) = darkGray;
b.CData(4,:) = darkGray;
b.CData(6,:) = darkGray;
ylabel('Number density (1/100 µm^{-1})')

[~,p] = kstest2(ndens_mdvs_tot,ndens_sticks_tot);
disp(p)
[~,p] = kstest2(ndens_mdvs_ax,ndens_sticks_ax);
disp(p)
[~,p] = kstest2(ndens_mdvs_de,ndens_sticks_de);
disp(p)
%}

%{
% Per cell, big/small, no ax/dend/soma/unknown (figure 3) - gluc
ndens_tmdvs_gl = [0.31880741 1.4401921 1.5573553 0.53090392];
ndens_bmdvs_gl = [0.31880741 0.8510226 1.79694842 0];
ndens_sticks_gl = [1.27522962 0.8510226 0.59898281 2.65451959];

% Per cell, big/small, no ax/dend (figure 3) - AA
ndens_tmdvs_aa = [5.71614876 7.28460419 4.56588372 3.13366655 1.46875949 1.65390746 3.32505569 7.38144103 1.26339461];
ndens_bmdvs_aa = [1.69367371 2.38405228 1.38961678 0.42731817 0.97917299 0.6202153 1.05001759 1.30260724 1.05282885];
ndens_sticks_aa = [0.63512764 1.72181554 0.99258342 0.71219694 2.44793248 0.72358451 1.57502638 0.86840483 0.42113154];

% number densities: [tiny (gluc), tiny (aa), big,, sticks,]
xplot1 = [1 4 7];
xplot2 = [2 5 8];
mean_all1 = [mean(ndens_tmdvs_gl) mean(ndens_bmdvs_gl) mean(ndens_sticks_gl)];
mean_all2 = [mean(ndens_tmdvs_aa) mean(ndens_bmdvs_aa) mean(ndens_sticks_aa)];
std_all = [std(ndens_tmdvs_gl) std(ndens_tmdvs_aa) std(ndens_bmdvs_gl) std(ndens_bmdvs_aa) std(ndens_sticks_gl) std(ndens_sticks_aa)];

fig2 = figure('rend','painters','pos',[410 100 450 370]);
b = bar(xplot1,mean_all1,0.3,'FaceColor',lightGray);
hold on
b = bar(xplot2,mean_all2,0.3,'FaceColor',darkGray);
eb = errorbar(xplot,mean_all,std_all,std_all,'k','LineStyle','none');
xlim([0.2 8.8])
xticks([1.5 4.5 7.5])
xticklabels({'Tiny MDVs','Big MDVs','Sticks'})
ylim([0 8])
yticklabels({'0','','2','','4','','6','','8'})
b.CData(1,:) = lightGray;
b.CData(3,:) = lightGray;
b.CData(5,:) = lightGray;
b.CData(2,:) = darkGray;
b.CData(4,:) = darkGray;
b.CData(6,:) = darkGray;
ylabel('Number density (1/100 µm^{-1})')

[~,p] = kstest2(ndens_tmdvs_gl,ndens_tmdvs_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_gl,ndens_bmdvs_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_gl,ndens_sticks_aa);
disp(p)
%}

% Axon/dendrite, big/small, OXPHOS+/-, gluc/aa (figure 4)
% - plot in groups of ves/sticks+stize+condition
%{
% Axon/dendrite, big/small, OXPHOS+/-, gluc/aa (figure 4)
ndens_sticks_oxp_ax_gluc = [0.85729472 0.79312126];
ndens_sticks_oxn_ax_gluc = [0 0.19828031];
ndens_tmdvs_oxp_ax_gluc = [0.42864736 0.29742047];
ndens_tmdvs_oxn_ax_gluc = [0 0.99140157];
ndens_bmdvs_oxp_ax_gluc = [0 0.89226142];
ndens_bmdvs_oxn_ax_gluc = [0 0.19828031];

ndens_sticks_oxp_de_gluc = [2.48827401 0];
ndens_sticks_oxn_de_gluc = [0 0.30802782];
ndens_tmdvs_oxp_de_gluc = [0 0];
ndens_tmdvs_oxn_de_gluc = [0 1.54013911];
ndens_bmdvs_oxp_de_gluc = [1.244137 0.30802782];
ndens_bmdvs_oxn_de_gluc = [0 0];

ndens_sticks_oxp_ax_aa = [0 0.98613981 0.37285747 0.74390648];
ndens_sticks_oxn_ax_aa = [0 0 0 0];
ndens_tmdvs_oxp_ax_aa = [3.82445741 6.90297864 1.86428734 2.23171943];
ndens_tmdvs_oxn_ax_aa = [1.43417153 0.98613981 0.74571494 1.48781295];
ndens_bmdvs_oxp_ax_aa = [0.47805718 1.47920971 1.86428734 0];
ndens_bmdvs_oxn_ax_aa = [0 0.4930699 0 0];

ndens_sticks_oxp_de_aa = [0.75997659 1.88564061 0.23083919];
ndens_sticks_oxn_de_aa = [0 0.23570508 0.46167839];
ndens_tmdvs_oxp_de_aa = [4.17987126 7.30685737 2.30839193];
ndens_tmdvs_oxn_de_aa = [1.89994148 0.70711523 0.46167839];
ndens_bmdvs_oxp_de_aa = [2.27992978 2.59275584 0.69251758];
ndens_bmdvs_oxn_de_aa = [0 0 0];

xplot1 = [1 2 3 4];
xplot2 = [6 7 8 9];
xplot3 = [11 12 13 14];
xplot4 = [16 17 18 19];
xplot5 = [21 22 23 24];
xplot6 = [26 27 28 29];
xplot = [xplot1 xplot2 xplot3 xplot4 xplot5 xplot6];
%mean_all = [mean(ndens_mdvs_tot) mean(ndens_sticks_tot) mean(ndens_mdvs_ax) mean(ndens_sticks_ax) mean(ndens_mdvs_de) mean(ndens_sticks_de)];
mean_tmdvs_gluc = [mean(ndens_tmdvs_oxp_ax_gluc) mean(ndens_tmdvs_oxn_ax_gluc) mean(ndens_tmdvs_oxp_de_gluc) mean(ndens_tmdvs_oxn_de_gluc)];
mean_bmdvs_gluc = [mean(ndens_bmdvs_oxp_ax_gluc) mean(ndens_bmdvs_oxn_ax_gluc) mean(ndens_bmdvs_oxp_de_gluc) mean(ndens_bmdvs_oxn_de_gluc)];
mean_sticks_gluc = [mean(ndens_sticks_oxp_ax_gluc) mean(ndens_sticks_oxn_ax_gluc) mean(ndens_sticks_oxp_de_gluc) mean(ndens_sticks_oxn_de_gluc)];
mean_tmdvs_aa = [mean(ndens_tmdvs_oxp_ax_aa) mean(ndens_tmdvs_oxn_ax_aa) mean(ndens_tmdvs_oxp_de_aa) mean(ndens_tmdvs_oxn_de_aa)];
mean_bmdvs_aa = [mean(ndens_bmdvs_oxp_ax_aa) mean(ndens_bmdvs_oxn_ax_aa) mean(ndens_bmdvs_oxp_de_aa) mean(ndens_bmdvs_oxn_de_aa)];
mean_sticks_aa = [mean(ndens_sticks_oxp_ax_aa) mean(ndens_sticks_oxn_ax_aa) mean(ndens_sticks_oxp_de_aa) mean(ndens_sticks_oxn_de_aa)];
mean_all = [mean_tmdvs_gluc mean_tmdvs_aa mean_bmdvs_gluc mean_bmdvs_aa mean_sticks_gluc mean_sticks_aa];

std_all = [std(ndens_tmdvs_oxp_ax_gluc) std(ndens_tmdvs_oxn_ax_gluc) std(ndens_tmdvs_oxp_de_gluc) std(ndens_tmdvs_oxn_de_gluc)...
    std(ndens_tmdvs_oxp_ax_aa) std(ndens_tmdvs_oxn_ax_aa) std(ndens_tmdvs_oxp_de_aa) std(ndens_tmdvs_oxn_de_aa)...
    std(ndens_bmdvs_oxp_ax_gluc) std(ndens_bmdvs_oxn_ax_gluc) std(ndens_bmdvs_oxp_de_gluc) std(ndens_bmdvs_oxn_de_gluc)...
    std(ndens_bmdvs_oxp_ax_aa) std(ndens_bmdvs_oxn_ax_aa) std(ndens_bmdvs_oxp_de_aa) std(ndens_bmdvs_oxn_de_aa)...
    std(ndens_sticks_oxp_ax_gluc) std(ndens_sticks_oxn_ax_gluc) std(ndens_sticks_oxp_de_gluc) std(ndens_sticks_oxn_de_gluc)...
    std(ndens_sticks_oxp_ax_aa) std(ndens_sticks_oxn_ax_aa) std(ndens_sticks_oxp_de_aa) std(ndens_sticks_oxn_de_aa)];

fig1 = figure('rend','painters','pos',[410 100 450 370]);
b_tmdvs_gluc = bar(xplot1,mean_tmdvs_gluc,0.5);%,'FaceColor',lightGray);
hold on
b_bmdvs_gluc = bar(xplot3,mean_bmdvs_gluc,0.5);%,'FaceColor',darkGray);
b_sticks_gluc = bar(xplot5,mean_sticks_gluc,0.5);%,'FaceColor',darkGray);
b_tmdvs_aa = bar(xplot2,mean_tmdvs_aa,0.5);%,'FaceColor',darkGray);
b_bmdvs_aa = bar(xplot4,mean_bmdvs_aa,0.5);%,'FaceColor',darkGray);
b_sticks_aa = bar(xplot6,mean_sticks_aa,0.5);%,'FaceColor',darkGray);
eb = errorbar(xplot,mean_all,std_all,std_all,'k','LineStyle','none');
xlim([0.2 29.8])
xticks([2.5 7.5 12.5 17.5 22.5 27.5])
xticklabels({'tiny gluc','tiny aa','big gluc','big aa','sticks gluc','sticks aa'})
ylim([0 8])
yticklabels({'0','','2','','4','','6','','8'})
b.CData(1,:) = lightGray;
b.CData(3,:) = lightGray;
b.CData(5,:) = lightGray;
b.CData(2,:) = darkGray;
b.CData(4,:) = darkGray;
b.CData(6,:) = darkGray;
ylabel('Number density (1/100 µm^{-1})')

%{
[~,p] = kstest2(ndens_mdvs_tot,ndens_sticks_tot);
disp(p)
[~,p] = kstest2(ndens_mdvs_ax,ndens_sticks_ax);
disp(p)
[~,p] = kstest2(ndens_mdvs_de,ndens_sticks_de);
disp(p)
%}
%}

% Axon/dendrite, big/small, OXPHOS+/-, gluc/aa (figure 4)
% - plot in groups of condition
%{
% Axon/dendrite, big/small, OXPHOS+/-, gluc/aa (figure 4)
ndens_sticks_oxp_ax_gluc = [0.85729472 0.79312126];
ndens_sticks_oxn_ax_gluc = [0 0.19828031];
ndens_tmdvs_oxp_ax_gluc = [0.42864736 0.29742047];
ndens_tmdvs_oxn_ax_gluc = [0 0.99140157];
ndens_bmdvs_oxp_ax_gluc = [0 0.89226142];
ndens_bmdvs_oxn_ax_gluc = [0 0.19828031];

ndens_sticks_oxp_de_gluc = [2.48827401 0];
ndens_sticks_oxn_de_gluc = [0 0.30802782];
ndens_tmdvs_oxp_de_gluc = [0 0];
ndens_tmdvs_oxn_de_gluc = [0 1.54013911];
ndens_bmdvs_oxp_de_gluc = [1.244137 0.30802782];
ndens_bmdvs_oxn_de_gluc = [0 0];

ndens_sticks_oxp_ax_aa = [0 0.98613981 0.37285747 0.74390648];
ndens_sticks_oxn_ax_aa = [0 0 0 0];
ndens_tmdvs_oxp_ax_aa = [3.82445741 6.90297864 1.86428734 2.23171943];
ndens_tmdvs_oxn_ax_aa = [1.43417153 0.98613981 0.74571494 1.48781295];
ndens_bmdvs_oxp_ax_aa = [0.47805718 1.47920971 1.86428734 0];
ndens_bmdvs_oxn_ax_aa = [0 0.4930699 0 0];

ndens_sticks_oxp_de_aa = [0.75997659 1.88564061 0.23083919];
ndens_sticks_oxn_de_aa = [0 0.23570508 0.46167839];
ndens_tmdvs_oxp_de_aa = [4.17987126 7.30685737 2.30839193];
ndens_tmdvs_oxn_de_aa = [1.89994148 0.70711523 0.46167839];
ndens_bmdvs_oxp_de_aa = [2.27992978 2.59275584 0.69251758];
ndens_bmdvs_oxn_de_aa = [0 0 0];

xplot1 = [1 2];
xplot2 = [3 4];
xplot3 = [6 7];
xplot4 = [8 9];
xplot5 = [11 12];
xplot6 = [13 14];
xplot7 = [16 17];
xplot8 = [18 19];
xplot9 = [21 22];
xplot10 = [23 24];
xplot11 = [26 27];
xplot12 = [28 29];
xplot = [xplot1 xplot2 xplot3 xplot4 xplot5 xplot6 xplot7 xplot8 xplot9 xplot10 xplot11 xplot12];
mean_tmdvs_oxp_ax = [mean(ndens_tmdvs_oxp_ax_gluc) mean(ndens_tmdvs_oxp_ax_aa)];
mean_tmdvs_oxp_de = [mean(ndens_tmdvs_oxp_de_gluc) mean(ndens_tmdvs_oxp_de_aa)];
mean_tmdvs_oxn_ax = [mean(ndens_tmdvs_oxn_ax_gluc) mean(ndens_tmdvs_oxn_ax_aa)];
mean_tmdvs_oxn_de = [mean(ndens_tmdvs_oxn_de_gluc) mean(ndens_tmdvs_oxn_de_aa)];

mean_bmdvs_oxp_ax = [mean(ndens_bmdvs_oxp_ax_gluc) mean(ndens_bmdvs_oxp_ax_aa)];
mean_bmdvs_oxp_de = [mean(ndens_bmdvs_oxp_de_gluc) mean(ndens_bmdvs_oxp_de_aa)];
mean_bmdvs_oxn_ax = [mean(ndens_bmdvs_oxn_ax_gluc) mean(ndens_bmdvs_oxn_ax_aa)];
mean_bmdvs_oxn_de = [mean(ndens_bmdvs_oxn_de_gluc) mean(ndens_bmdvs_oxn_de_aa)];

mean_sticks_oxp_ax = [mean(ndens_sticks_oxp_ax_gluc) mean(ndens_sticks_oxp_ax_aa)];
mean_sticks_oxp_de = [mean(ndens_sticks_oxp_de_gluc) mean(ndens_sticks_oxp_de_aa)];
mean_sticks_oxn_ax = [mean(ndens_sticks_oxn_ax_gluc) mean(ndens_sticks_oxn_ax_aa)];
mean_sticks_oxn_de = [mean(ndens_sticks_oxn_de_gluc) mean(ndens_sticks_oxn_de_aa)];

mean_all = [mean_tmdvs_oxp_ax mean_tmdvs_oxp_de mean_tmdvs_oxn_ax mean_tmdvs_oxn_de...
    mean_bmdvs_oxp_ax mean_bmdvs_oxp_de mean_bmdvs_oxn_ax mean_bmdvs_oxn_de...
    mean_sticks_oxp_ax mean_sticks_oxp_de mean_sticks_oxn_ax mean_sticks_oxn_de];

std_all = [std(ndens_tmdvs_oxp_ax_gluc) std(ndens_tmdvs_oxp_ax_aa)...
    std(ndens_tmdvs_oxp_de_gluc) std(ndens_tmdvs_oxp_de_aa)...
    std(ndens_tmdvs_oxn_ax_gluc) std(ndens_tmdvs_oxn_ax_aa)...
    std(ndens_tmdvs_oxn_de_gluc) std(ndens_tmdvs_oxn_de_aa)...
    std(ndens_bmdvs_oxp_ax_gluc) std(ndens_bmdvs_oxp_ax_aa)...
    std(ndens_bmdvs_oxp_de_gluc) std(ndens_bmdvs_oxp_de_aa)...
    std(ndens_bmdvs_oxn_ax_gluc) std(ndens_bmdvs_oxn_ax_aa)...
    std(ndens_bmdvs_oxn_de_gluc) std(ndens_bmdvs_oxn_de_aa)...
    std(ndens_sticks_oxp_ax_gluc) std(ndens_sticks_oxp_ax_aa)...
    std(ndens_sticks_oxp_de_gluc) std(ndens_sticks_oxp_de_aa)...
    std(ndens_sticks_oxn_ax_gluc) std(ndens_sticks_oxn_ax_aa)...
    std(ndens_sticks_oxn_de_gluc) std(ndens_sticks_oxn_de_aa)];

fig1 = figure('rend','painters','pos',[410 100 650 370]);
b_tmdvs_oxp_ax = bar(xplot1,mean_tmdvs_oxp_ax,0.8);%,'FaceColor',lightGray);
hold on
b_tmdvs_oxp_de = bar(xplot2,mean_tmdvs_oxp_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_ax = bar(xplot3,mean_tmdvs_oxn_ax,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_de = bar(xplot4,mean_tmdvs_oxn_de,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_ax = bar(xplot5,mean_bmdvs_oxp_ax,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_de = bar(xplot6,mean_bmdvs_oxp_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxp_ax = bar(xplot7,mean_bmdvs_oxn_ax,0.8);%,'FaceColor',lightGray);
b_tmdvs_oxp_de = bar(xplot8,mean_bmdvs_oxn_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_ax = bar(xplot9,mean_sticks_oxp_ax,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_de = bar(xplot10,mean_sticks_oxp_de,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_ax = bar(xplot11,mean_sticks_oxn_ax,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_de = bar(xplot12,mean_sticks_oxn_de,0.8);%,'FaceColor',darkGray);
eb = errorbar(xplot,mean_all,std_all,std_all,'k','LineStyle','none');
xlim([0.2 29.8])
xticks([2.5 7.5 12.5 17.5 22.5 27.5])
xticklabels({'Tiny MDVs, OXP+','Tiny MDVs, OXP-','Big MDVs, OXP+','Big MDVs, OXP-','Sticks, OXP+','Sticks, OXP-'})
ylim([0 8])
yticklabels({'0','','2','','4','','6','','8'})
b.CData(1,:) = lightGray;
b.CData(3,:) = lightGray;
b.CData(5,:) = lightGray;
b.CData(2,:) = darkGray;
b.CData(4,:) = darkGray;
b.CData(6,:) = darkGray;
ylabel('Number density (1/100 µm^{-1})')

%{
[~,p] = kstest2(ndens_tmdvs_oxp_ax_gluc,ndens_tmdvs_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxp_de_gluc,ndens_tmdvs_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxn_ax_gluc,ndens_tmdvs_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxn_de_gluc,ndens_tmdvs_oxn_de_aa);
disp(p)

[~,p] = kstest2(ndens_bmdvs_oxp_ax_gluc,ndens_bmdvs_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxp_de_gluc,ndens_bmdvs_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxn_ax_gluc,ndens_bmdvs_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxn_de_gluc,ndens_bmdvs_oxn_de_aa);
disp(p)

[~,p] = kstest2(ndens_sticks_oxp_ax_gluc,ndens_sticks_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxp_de_gluc,ndens_sticks_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxn_ax_gluc,ndens_sticks_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxn_de_gluc,ndens_sticks_oxn_de_aa);
disp(p)
%}

%}

% Axon/dendrite, big/small, PEX+/-, gluc/aa (figure 5)
% - plot in groups of condition
%%{
% Axon/dendrite, big/small, PEX+/-, gluc/aa (figure 5)
% It is PEX data, even if it is called 'oxp' and 'oxn' below
ndens_sticks_oxp_ax_gluc = [0.87638194 4.55331937];
ndens_sticks_oxn_ax_gluc = [0 0];
ndens_tmdvs_oxp_ax_gluc = [0.43819097 0];
ndens_tmdvs_oxn_ax_gluc = [0.87638194 0];
ndens_bmdvs_oxp_ax_gluc = [1.75276389 0];
ndens_bmdvs_oxn_ax_gluc = [0.43819097 0];

ndens_sticks_oxp_de_gluc = [0.41942702];
ndens_sticks_oxn_de_gluc = [0];
ndens_tmdvs_oxp_de_gluc = [1.04856755];
ndens_tmdvs_oxn_de_gluc = [0.83885404];
ndens_bmdvs_oxp_de_gluc = [2.30684861];
ndens_bmdvs_oxn_de_gluc = [0.83885404];

ndens_sticks_oxp_ax_aa = [0 0.54982364];
ndens_sticks_oxn_ax_aa = [0 0.27491182];
ndens_tmdvs_oxp_ax_aa = [0 3.57385369];
ndens_tmdvs_oxn_ax_aa = [0 7.14770737];
ndens_bmdvs_oxp_ax_aa = [0 0.54982364];
ndens_bmdvs_oxn_ax_aa = [0 0.27491182];

ndens_sticks_oxp_de_aa = [0.3529117 1.13899541 0.91695729];
ndens_sticks_oxn_de_aa = [0 0 0];
ndens_tmdvs_oxp_de_aa = [1.41164679 3.03732108 2.75087187];
ndens_tmdvs_oxn_de_aa = [0.3529117 0 0.91695729];
ndens_bmdvs_oxp_de_aa = [1.05873509 0.37966514 1.52826215];
ndens_bmdvs_oxn_de_aa = [0 0.37966514 0.30565243];

xplot1 = [1 2];
xplot2 = [3 4];
xplot3 = [6 7];
xplot4 = [8 9];
xplot5 = [11 12];
xplot6 = [13 14];
xplot7 = [16 17];
xplot8 = [18 19];
xplot9 = [21 22];
xplot10 = [23 24];
xplot11 = [26 27];
xplot12 = [28 29];
xplot = [xplot1 xplot2 xplot3 xplot4 xplot5 xplot6 xplot7 xplot8 xplot9 xplot10 xplot11 xplot12];
mean_tmdvs_oxp_ax = [mean(ndens_tmdvs_oxp_ax_gluc) mean(ndens_tmdvs_oxp_ax_aa)];
mean_tmdvs_oxp_de = [mean(ndens_tmdvs_oxp_de_gluc) mean(ndens_tmdvs_oxp_de_aa)];
mean_tmdvs_oxn_ax = [mean(ndens_tmdvs_oxn_ax_gluc) mean(ndens_tmdvs_oxn_ax_aa)];
mean_tmdvs_oxn_de = [mean(ndens_tmdvs_oxn_de_gluc) mean(ndens_tmdvs_oxn_de_aa)];

mean_bmdvs_oxp_ax = [mean(ndens_bmdvs_oxp_ax_gluc) mean(ndens_bmdvs_oxp_ax_aa)];
mean_bmdvs_oxp_de = [mean(ndens_bmdvs_oxp_de_gluc) mean(ndens_bmdvs_oxp_de_aa)];
mean_bmdvs_oxn_ax = [mean(ndens_bmdvs_oxn_ax_gluc) mean(ndens_bmdvs_oxn_ax_aa)];
mean_bmdvs_oxn_de = [mean(ndens_bmdvs_oxn_de_gluc) mean(ndens_bmdvs_oxn_de_aa)];

mean_sticks_oxp_ax = [mean(ndens_sticks_oxp_ax_gluc) mean(ndens_sticks_oxp_ax_aa)];
mean_sticks_oxp_de = [mean(ndens_sticks_oxp_de_gluc) mean(ndens_sticks_oxp_de_aa)];
mean_sticks_oxn_ax = [mean(ndens_sticks_oxn_ax_gluc) mean(ndens_sticks_oxn_ax_aa)];
mean_sticks_oxn_de = [mean(ndens_sticks_oxn_de_gluc) mean(ndens_sticks_oxn_de_aa)];

mean_all = [mean_tmdvs_oxp_ax mean_tmdvs_oxp_de mean_tmdvs_oxn_ax mean_tmdvs_oxn_de...
    mean_bmdvs_oxp_ax mean_bmdvs_oxp_de mean_bmdvs_oxn_ax mean_bmdvs_oxn_de...
    mean_sticks_oxp_ax mean_sticks_oxp_de mean_sticks_oxn_ax mean_sticks_oxn_de];

std_all = [std(ndens_tmdvs_oxp_ax_gluc) std(ndens_tmdvs_oxp_ax_aa)...
    std(ndens_tmdvs_oxp_de_gluc) std(ndens_tmdvs_oxp_de_aa)...
    std(ndens_tmdvs_oxn_ax_gluc) std(ndens_tmdvs_oxn_ax_aa)...
    std(ndens_tmdvs_oxn_de_gluc) std(ndens_tmdvs_oxn_de_aa)...
    std(ndens_bmdvs_oxp_ax_gluc) std(ndens_bmdvs_oxp_ax_aa)...
    std(ndens_bmdvs_oxp_de_gluc) std(ndens_bmdvs_oxp_de_aa)...
    std(ndens_bmdvs_oxn_ax_gluc) std(ndens_bmdvs_oxn_ax_aa)...
    std(ndens_bmdvs_oxn_de_gluc) std(ndens_bmdvs_oxn_de_aa)...
    std(ndens_sticks_oxp_ax_gluc) std(ndens_sticks_oxp_ax_aa)...
    std(ndens_sticks_oxp_de_gluc) std(ndens_sticks_oxp_de_aa)...
    std(ndens_sticks_oxn_ax_gluc) std(ndens_sticks_oxn_ax_aa)...
    std(ndens_sticks_oxn_de_gluc) std(ndens_sticks_oxn_de_aa)];

fig1 = figure('rend','painters','pos',[410 100 650 370]);
b_tmdvs_oxp_ax = bar(xplot1,mean_tmdvs_oxp_ax,0.8);%,'FaceColor',lightGray);
hold on
b_tmdvs_oxp_de = bar(xplot2,mean_tmdvs_oxp_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_ax = bar(xplot3,mean_tmdvs_oxn_ax,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_de = bar(xplot4,mean_tmdvs_oxn_de,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_ax = bar(xplot5,mean_bmdvs_oxp_ax,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_de = bar(xplot6,mean_bmdvs_oxp_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxp_ax = bar(xplot7,mean_bmdvs_oxn_ax,0.8);%,'FaceColor',lightGray);
b_tmdvs_oxp_de = bar(xplot8,mean_bmdvs_oxn_de,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_ax = bar(xplot9,mean_sticks_oxp_ax,0.8);%,'FaceColor',darkGray);
b_tmdvs_oxn_de = bar(xplot10,mean_sticks_oxp_de,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_ax = bar(xplot11,mean_sticks_oxn_ax,0.8);%,'FaceColor',darkGray);
b_bmdvs_oxp_de = bar(xplot12,mean_sticks_oxn_de,0.8);%,'FaceColor',darkGray);
eb = errorbar(xplot,mean_all,std_all,std_all,'k','LineStyle','none');
xlim([0.2 29.8])
xticks([2.5 7.5 12.5 17.5 22.5 27.5])
xticklabels({'Tiny MDVs, PEX+','Tiny MDVs, PEX-','Big MDVs, PEX+','Big MDVs, PEX-','Sticks, PEX+','Sticks, PEX-'})
ylim([0 9])
yticklabels({'0','','2','','4','','6','','8'})
b.CData(1,:) = lightGray;
b.CData(3,:) = lightGray;
b.CData(5,:) = lightGray;
b.CData(2,:) = darkGray;
b.CData(4,:) = darkGray;
b.CData(6,:) = darkGray;
ylabel('Number density (1/100 µm^{-1})')

%%{
[~,p] = kstest2(ndens_tmdvs_oxp_ax_gluc,ndens_tmdvs_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxp_de_gluc,ndens_tmdvs_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxn_ax_gluc,ndens_tmdvs_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_tmdvs_oxn_de_gluc,ndens_tmdvs_oxn_de_aa);
disp(p)

[~,p] = kstest2(ndens_bmdvs_oxp_ax_gluc,ndens_bmdvs_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxp_de_gluc,ndens_bmdvs_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxn_ax_gluc,ndens_bmdvs_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_bmdvs_oxn_de_gluc,ndens_bmdvs_oxn_de_aa);
disp(p)

[~,p] = kstest2(ndens_sticks_oxp_ax_gluc,ndens_sticks_oxp_ax_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxp_de_gluc,ndens_sticks_oxp_de_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxn_ax_gluc,ndens_sticks_oxn_ax_aa);
disp(p)
[~,p] = kstest2(ndens_sticks_oxn_de_gluc,ndens_sticks_oxn_de_aa);
disp(p)
%}

%}