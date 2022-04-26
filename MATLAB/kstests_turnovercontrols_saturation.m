% KS-tests for turnover controls - saturation
% for COX, OMP and SEC data

[h,p] = kstest2(cox_1,cox_2);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(cox_1,cox_3);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(cox_2,cox_3);
fprintf('KS-test result: %.10f\n',p)

[h,p] = kstest2(omp_1,omp_2);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(omp_1,omp_3);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(omp_2,omp_3);
fprintf('KS-test result: %.10f\n',p)

[h,p] = kstest2(sec_1,sec_2);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(sec_1,sec_3);
fprintf('KS-test result: %.10f\n',p)
[h,p] = kstest2(sec_2,sec_3);
fprintf('KS-test result: %.10f\n',p)