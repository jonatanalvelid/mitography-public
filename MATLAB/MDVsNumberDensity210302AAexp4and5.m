mean4gl = [1.34 3.48 1.59 0.93 0.98 1.86];
mean4aa = [0.66 2.23 2.96 2.11 1.04 0.70];
std4gl = [1.09 2.07 1.17 1.58 0.72 2.07];
std4aa = [0.55 1.27 1.8 2.6 1.3 0.9];

mean5gl = [0.93 1.69 0.65 0.37 0.26 0.36];
mean5aa = [0.28 4.14 0.13 2.59 0.12 1.76];
std5gl = [0.5 0.65 0.62 0.35 0.17 0.29];
std5aa = [0.42 1.85 0.24 1.64 0.18 1.9];

figure()
hold on
errorbar([1:length(mean4gl)]-0.05,mean4gl,std4gl,'.')
errorbar([1:length(mean4aa)]+0.05,mean4aa,std4aa,'.')
xticks([1:length(mean4gl)])
xticklabels({'Tin, O+','Tin, O-','Big, O+','Big, O-','Sti, O+','Sti, O-'})
ylabel('Number density (/100 µm)')
legend({'Glucose','AA'})

figure()
hold on
errorbar([1:length(mean5gl)]-0.05,mean5gl,std5gl,'.')
errorbar([1:length(mean5aa)]+0.05,mean5aa,std5aa,'.')
xticks([1:length(mean5gl)])
xticklabels({'Tin, O+','Tin, O-','Big, O+','Big, O-','Sti, O+','Sti, O-'})
ylabel('Number density (/100 µm)')
legend({'Glucose','AA'})