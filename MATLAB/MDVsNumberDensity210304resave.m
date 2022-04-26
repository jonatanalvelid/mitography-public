clear all

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_numberdensity-axde-1oxppex','\');
datalist = dir(fullfile(dirread,'*.csv'));

% 010 = sticks, -
% 011 = sticks, +
% 100 = tiny mdvs, -
% 101 = tiny mdvs, +
% 110 = big mdvs, -
% 111 = big mdvs, +

for exp_main=1:5
    data_exp = struct();
    numden_aa_010_0 = [];
    numden_aa_011_0 = [];
    numden_aa_100_0 = [];
    numden_aa_101_0 = [];
    numden_aa_110_0 = [];
    numden_aa_111_0 = [];

    numden_ct_010_0 = [];
    numden_ct_011_0 = [];
    numden_ct_100_0 = [];
    numden_ct_101_0 = [];
    numden_ct_110_0 = [];
    numden_ct_111_0 = [];

    numden_aa_010_1 = [];
    numden_aa_011_1 = [];
    numden_aa_100_1 = [];
    numden_aa_101_1 = [];
    numden_aa_110_1 = [];
    numden_aa_111_1 = [];

    numden_ct_010_1 = [];
    numden_ct_011_1 = [];
    numden_ct_100_1 = [];
    numden_ct_101_1 = [];
    numden_ct_110_1 = [];
    numden_ct_111_1 = [];
    disp(' ')
    disp(exp_main)
    for i=1:numel(datalist)
        loc = '0';
        filename = datalist(i).name;
        filename_split = split(filename,'_');
        filename_split_type = split(filename_split(4),'.');
        try
            filename_split_loc = split(filename_split(5),'.');
            loc = char(filename_split_loc(1));
        catch
        end
        type = char(filename_split_type(1));
        exp = filename_split(2);
        exp = str2num(exp{1}(4));
        treat = char(filename_split(3));
        if exp == exp_main
            disp(filename)
            data = load(strcat(datalist(i).folder,'\',filename));
            %disp(length(data))
            if loc == '0'
                if type == '010'
                    if treat == 'gl'
                        numden_ct_010_0 = [numden_ct_010_0; data];
                    elseif treat == 'aa'
                        numden_aa_010_0 = [numden_aa_010_0; data];
                    end
                elseif type == '011'
                    if treat == 'gl'
                        numden_ct_011_0 = [numden_ct_011_0; data];
                    elseif treat == 'aa'
                        numden_aa_011_0 = [numden_aa_011_0; data];
                    end
                elseif type == '100'
                    if treat == 'gl'
                        numden_ct_100_0 = [numden_ct_100_0; data];
                    elseif treat == 'aa'
                        numden_aa_100_0 = [numden_aa_100_0; data];
                    end
                elseif type == '101'
                    if treat == 'gl'
                        numden_ct_101_0 = [numden_ct_101_0; data];
                    elseif treat == 'aa'
                        numden_aa_101_0 = [numden_aa_101_0; data];
                    end
                elseif type == '110'
                    if treat == 'gl'
                        numden_ct_110_0 = [numden_ct_110_0; data];
                    elseif treat == 'aa'
                        numden_aa_110_0 = [numden_aa_110_0; data];
                    end
                elseif type == '111'
                    if treat == 'gl'
                        numden_ct_111_0 = [numden_ct_111_0; data];
                    elseif treat == 'aa'
                        numden_aa_111_0 = [numden_aa_111_0; data];
                    end
                end
            elseif loc == '1'
                if type == '010'
                    if treat == 'gl'
                        numden_ct_010_1 = [numden_ct_010_1; data];
                    elseif treat == 'aa'
                        numden_aa_010_1 = [numden_aa_010_1; data];
                    end
                elseif type == '011'
                    if treat == 'gl'
                        numden_ct_011_1 = [numden_ct_011_1; data];
                    elseif treat == 'aa'
                        numden_aa_011_1 = [numden_aa_011_1; data];
                    end
                elseif type == '100'
                    if treat == 'gl'
                        numden_ct_100_1 = [numden_ct_100_1; data];
                    elseif treat == 'aa'
                        numden_aa_100_1 = [numden_aa_100_1; data];
                    end
                elseif type == '101'
                    if treat == 'gl'
                        numden_ct_101_1 = [numden_ct_101_1; data];
                    elseif treat == 'aa'
                        numden_aa_101_1 = [numden_aa_101_1; data];
                    end
                elseif type == '110'
                    if treat == 'gl'
                        numden_ct_110_1 = [numden_ct_110_1; data];
                    elseif treat == 'aa'
                        numden_aa_110_1 = [numden_aa_110_1; data];
                    end
                elseif type == '111'
                    if treat == 'gl'
                        numden_ct_111_1 = [numden_ct_111_1; data];
                    elseif treat == 'aa'
                        numden_aa_111_1 = [numden_aa_111_1; data];
                    end
                end
            end
        end
    end
        
    data_exp.t_p_aa_ax = numden_aa_101_0;
    data_exp.t_p_aa_de = numden_aa_101_1;
    data_exp.t_n_aa_ax = numden_aa_100_0;
    data_exp.t_n_aa_de = numden_aa_100_1;
    data_exp.b_p_aa_ax = numden_aa_111_0;
    data_exp.b_p_aa_de = numden_aa_111_1;
    data_exp.b_n_aa_ax = numden_aa_110_0;
    data_exp.b_n_aa_de = numden_aa_110_1;
    data_exp.s_p_aa_ax = numden_aa_011_0;
    data_exp.s_p_aa_de = numden_aa_011_1;
    data_exp.s_n_aa_ax = numden_aa_010_0;
    data_exp.s_n_aa_de = numden_aa_010_1;
    data_exp.t_p_ct_ax = numden_ct_101_0;
    data_exp.t_p_ct_de = numden_ct_101_1;
    data_exp.t_n_ct_ax = numden_ct_100_0;
    data_exp.t_n_ct_de = numden_ct_100_1;
    data_exp.b_p_ct_ax = numden_ct_111_0;
    data_exp.b_p_ct_de = numden_ct_111_1;
    data_exp.b_n_ct_ax = numden_ct_110_0;
    data_exp.b_n_ct_de = numden_ct_110_1;
    data_exp.s_p_ct_ax = numden_ct_011_0;
    data_exp.s_p_ct_de = numden_ct_011_1;
    data_exp.s_n_ct_ax = numden_ct_010_0;
    data_exp.s_n_ct_de = numden_ct_010_1;
    
    savename = sprintf('exp%d_mdvdens.mat',exp_main);
    save(savename, 'data_exp')
end

% 010 = sticks, -
% 011 = sticks, +
% 100 = tiny mdvs, -
% 101 = tiny mdvs, +
% 110 = big mdvs, -
% 111 = big mdvs, +
