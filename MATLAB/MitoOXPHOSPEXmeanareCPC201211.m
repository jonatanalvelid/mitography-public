% All MDV in AA vs control experiments - OXPHOS and PEX - combined

clear all

load('E:\PhD\data_analysis\temp_pex\mdv_meanarea_percell_pex.mat')
load('E:\PhD\data_analysis\temp_oxphos\mdv_meanarea_percell_oxp.mat')
mdvpexall_area(expnum_pex==3) = [];
expnum_pex(expnum_pex==3) = [];

mdvall_area = [mdvoxpall_area mdvpexall_area];
expnum_all = [expnum_oxp expnum_pex];

% Box plots with jittered scatter of MDV mean areas
figure()
hold on
labels = {'Exp1 - AA', 'Exp1 - CTR', 'Exp2 - CTR', 'Exp3 - CTR'};
s1 = scatter(ones(size(mdvall_area(expnum_all==1))),mdvall_area(expnum_all==1),40,'kx','jitter','on','jitterAmount',0.09);
s2 = scatter(2*ones(size(mdvall_area(expnum_all==2))),mdvall_area(expnum_all==2),40,'kx','jitter','on','jitterAmount',0.09);
s3 = scatter(3*ones(size(mdvall_area(expnum_all==3))),mdvall_area(expnum_all==3),40,'kx','jitter','on','jitterAmount',0.09);
s4 = scatter(4*ones(size(mdvall_area(expnum_all==4))),mdvall_area(expnum_all==4),40,'kx','jitter','on','jitterAmount',0.09);
boxplot(mdvall_area,expnum_all,'Labels',labels)
ylabel('Area, MDVs')
ylim([0 0.1])

% T-tests for MDV mean areas between datasets
disp(' ')
for n=1:max(expnum_all)
    for m=1:max(expnum_all)
        if n ~= m && m>n
            [~,p] = ttest2(mdvall_area(expnum_all==n),mdvall_area(expnum_all==m));
            fprintf('T-test, %d v %d: %f \n', n, m, p)
        end
    end
end