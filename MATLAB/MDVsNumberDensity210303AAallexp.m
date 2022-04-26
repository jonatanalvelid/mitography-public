clear all

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_numberdensity','\');
datalist = dir(fullfile(dirread,'*.csv'));

% 010 = sticks, -
% 011 = sticks, +
% 100 = tiny mdvs, -
% 101 = tiny mdvs, +
% 110 = big mdvs, -
% 111 = big mdvs, +

numden_aa_010 = [];
numden_aa_011 = [];
numden_aa_100 = [];
numden_aa_101 = [];
numden_aa_110 = [];
numden_aa_111 = [];

numden_ct_010 = [];
numden_ct_011 = [];
numden_ct_100 = [];
numden_ct_101 = [];
numden_ct_110 = [];
numden_ct_111 = [];

for i=1:numel(datalist)
    filename = datalist(i).name;
    filename_split = split(filename,'_');
    filename_split2 = split(filename_split(4),'.');
    type = char(filename_split2(1));
    exp = filename_split(2);
    exp = str2num(exp{1}(4));
    treat = char(filename_split(3));

    %disp(' ')
    %disp(filename)
    
    data = load(strcat(datalist(i).folder,'\',filename));
    %disp(length(data))
    if type == '010'
        if treat == 'gl'
            numden_ct_010 = [numden_ct_010; data];
        elseif treat == 'aa'
            numden_aa_010 = [numden_aa_010; data];
        end
    elseif type == '011'
        if treat == 'gl'
            numden_ct_011 = [numden_ct_011; data];
        elseif treat == 'aa'
            numden_aa_011 = [numden_aa_011; data];
        end
    elseif type == '100'
        if treat == 'gl'
            numden_ct_100 = [numden_ct_100; data];
        elseif treat == 'aa'
            numden_aa_100 = [numden_aa_100; data];
        end
    elseif type == '101'
        if treat == 'gl'
            numden_ct_101 = [numden_ct_101; data];
        elseif treat == 'aa'
            numden_aa_101 = [numden_aa_101; data];
        end
    elseif type == '110'
        if treat == 'gl'
            numden_ct_110 = [numden_ct_110; data];
        elseif treat == 'aa'
            numden_aa_110 = [numden_aa_110; data];
        end
    elseif type == '111'
        if treat == 'gl'
            numden_ct_111 = [numden_ct_111; data];
        elseif treat == 'aa'
            numden_aa_111 = [numden_aa_111; data];
        end
    end
end

% 010 = sticks, -
% 011 = sticks, +
% 100 = tiny mdvs, -
% 101 = tiny mdvs, +
% 110 = big mdvs, -
% 111 = big mdvs, +

%{
mean_gl = [mean(numden_ct_101); mean(numden_ct_100); mean(numden_ct_111); mean(numden_ct_110); mean(numden_ct_011); mean(numden_ct_010)];
std_gl = [std(numden_ct_101); std(numden_ct_100); std(numden_ct_111); std(numden_ct_110); std(numden_ct_011); std(numden_ct_010)];
mean_aa = [mean(numden_aa_101); mean(numden_aa_100); mean(numden_aa_111); mean(numden_aa_110); mean(numden_aa_011); mean(numden_aa_010)];
std_aa = [std(numden_aa_101); std(numden_aa_100); std(numden_aa_111); std(numden_aa_110); std(numden_aa_011); std(numden_aa_010)];

figure()
hold on
errorbar([1:length(mean_gl)]-0.05,mean_gl,std_gl,'.')
errorbar([1:length(mean_aa)]+0.05,mean_aa,std_aa,'.')
xticks([1:length(mean_gl)])
xticklabels({'Tin, O+','Tin, O-','Big, O+','Big, O-','Sti, O+','Sti, O-'})
ylabel('Number density (/100 µm)')
legend({'Glucose','AA'})
%}

%{
% Box plots with jittered scatter of MDV number densities for different
% types of MDVs - control
allvalues = [numden_ct_101; numden_ct_100; numden_ct_111; numden_ct_110; numden_ct_011; numden_ct_010];
grouping = [ones(size(numden_ct_101));2*ones(size(numden_ct_100));3*ones(size(numden_ct_111));4*ones(size(numden_ct_110));5*ones(size(numden_ct_011));6*ones(size(numden_ct_010))];

figure('Position', [10 100 850 400])
hold on
labels = {'Tin, O+','Tin, O-','Big, O+','Big, O-','Sti, O+','Sti, O-'};
s1 = scatter(1*ones(size(numden_ct_101)),numden_ct_101,40,'kx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(numden_ct_100)),numden_ct_100,40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(numden_ct_111)),numden_ct_111,40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(numden_ct_110)),numden_ct_110,40,'kx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(numden_ct_011)),numden_ct_011,40,'kx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(numden_ct_010)),numden_ct_010,40,'kx','jitter','on','jitterAmount',0.09);
boxplot(allvalues,grouping,'Labels',labels)
ylabel('Number density (/100 µm)')
%ylim([0 0.1])
%}

% Box plots with jittered scatter of MDV number densities for different
% types of MDVs - control and aa
all_ct = numden_ct_101+numden_ct_100+numden_ct_111+numden_ct_110;
all_aa = numden_aa_101+numden_aa_100+numden_aa_111+numden_aa_110;
allvalues = [numden_ct_101; numden_aa_101; numden_ct_100; numden_aa_100; numden_ct_111; numden_aa_111; numden_ct_110; numden_aa_110; numden_ct_011; numden_aa_011; numden_ct_010; numden_aa_010];
grouping = [ones(size(numden_ct_101));2*ones(size(numden_aa_101));3*ones(size(numden_ct_100));4*ones(size(numden_aa_100));5*ones(size(numden_ct_111));6*ones(size(numden_aa_111));7*ones(size(numden_ct_110));8*ones(size(numden_aa_110));9*ones(size(numden_ct_011));10*ones(size(numden_aa_011));11*ones(size(numden_ct_010));12*ones(size(numden_aa_010))];

figure('Position', [10 100 850 500])
hold on
labels = {'T+, gl','T+, aa','T-, gl','T-, aa','B+, gl','B+, aa','B-, gl','B-, aa','S+, gl','S+, aa','S-, gl','S-, aa'};
s1 = scatter(1*ones(size(numden_ct_101)),numden_ct_101,40,'kx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(numden_aa_101)),numden_aa_101,40,'rx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(numden_ct_100)),numden_ct_100,40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(numden_aa_100)),numden_aa_100,40,'rx','jitter','on','jitterAmount',0.09);
s5 = scatter(5*ones(size(numden_ct_111)),numden_ct_111,40,'kx','jitter','on','jitterAmount',0.09);
s6 = scatter(6*ones(size(numden_aa_111)),numden_aa_111,40,'rx','jitter','on','jitterAmount',0.09);
s7 = scatter(7*ones(size(numden_ct_110)),numden_ct_110,40,'kx','jitter','on','jitterAmount',0.09);
s8 = scatter(8*ones(size(numden_aa_110)),numden_aa_110,40,'rx','jitter','on','jitterAmount',0.09);
s9 = scatter(9*ones(size(numden_ct_011)),numden_ct_011,40,'kx','jitter','on','jitterAmount',0.09);
s10 = scatter(10*ones(size(numden_aa_011)),numden_aa_011,40,'rx','jitter','on','jitterAmount',0.09);
s11 = scatter(11*ones(size(numden_ct_010)),numden_ct_010,40,'kx','jitter','on','jitterAmount',0.09);
s12 = scatter(12*ones(size(numden_aa_010)),numden_aa_010,40,'rx','jitter','on','jitterAmount',0.09);
boxplot(allvalues,grouping,'Labels',labels, 'symbol', '')
ylabel('Number density (/100 µm)')
ylim([0 8])

% all vesicles together
all_all = [all_ct;all_aa];
groups = [ones(size(all_ct));2*ones(size(all_aa))];
figure('Position', [10 100 850 500])
hold on
labels = {'gl','aa'};
s1 = scatter(1*ones(size(all_ct)),all_ct,40,'kx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(all_aa)),all_aa,40,'rx','jitter','on','jitterAmount',0.09);
boxplot(all_all,groups,'Labels',labels, 'symbol', '')
ylabel('Number density (/100 µm)')
ylim([0 25])

disp(' ')
[~,p] = ttest2(all_ct,all_aa);
fprintf('T-test, all: %f \n', p)

% 010 = sticks, -
% 011 = sticks, +
% 100 = tiny mdvs, -
% 101 = tiny mdvs, +
% 110 = big mdvs, -
% 111 = big mdvs, +

% T-tests for AA and gl mean number densities for different types of MDVs
disp(' ')
[~,p] = ttest2(numden_ct_101,numden_aa_101);
fprintf('T-test, %s: %f \n', 'tiny mdvs +', p)
[~,p] = ttest2(numden_ct_100,numden_aa_100);
fprintf('T-test, %s: %f \n', 'tiny mdvs -', p)
[~,p] = ttest2(numden_ct_111,numden_aa_111);
fprintf('T-test, %s: %f \n', 'big mdvs +', p)
[~,p] = ttest2(numden_ct_110,numden_aa_110);
fprintf('T-test, %s: %f \n', 'big mdvs -', p)
[~,p] = ttest2(numden_ct_011,numden_aa_011);
fprintf('T-test, %s: %f \n', 'sticks +', p)
[~,p] = ttest2(numden_ct_010,numden_aa_010);
fprintf('T-test, %s: %f \n', 'sticks -', p)
