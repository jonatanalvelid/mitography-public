lightGray = [0.7 0.7 0.7];
midGray = [0.4 0.4 0.4];
darkGray = [0.2 0.2 0.2];

% number densities: [tiny, big, sticks (total);(axons);(dendrites)]
ndens_gluc = [1.28 1.36 0.91;1.11 1.04 1.11;1.59 1.93 0.57]; 
% number densities: [tiny (gluc), tiny (aa); big; sticks]
ndens_tot = [1.28 5.04; 1.36 1.33; 0.91 1.01]; 

fig1 = figure('rend','painters','pos',[410 100 450 300]);
b = bar(ndens_gluc);
b(1).FaceColor = lightGray;
b(2).FaceColor = midGray;
b(3).FaceColor = darkGray;
xticks([])
xticklabels([])
legend({'Tiny','Big','Sticks'})

fig2 = figure('rend','painters','pos',[410 100 450 370]);
b = bar(ndens_tot);
b(1).FaceColor = lightGray;
b(2).FaceColor = darkGray;
xticks([])
xticklabels([])
legend({'Gluc','AA'})
ylabel('Number density (1/100 µm^{-1})')