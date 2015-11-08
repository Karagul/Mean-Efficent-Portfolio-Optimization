% mv_feasible_test.m
% script to test mv, mv_eff, and mv_plot routines

% set test parameters
r_mat  = [ 0.35  0.23  0.09
          -0.09  0.18 -0.05
           0.20 -0.14  0.13
          -0.10  0.21  0.29
           0.26  0.08  0.12 ];

% call mv_eff to compute the entire efficient frontier
[wts_p, mu_p, sig_p] = mv_eff(8, r_mat);
disp('mv_eff with r_mat: optimal portfolio weights on the efficient frontier');
disp(wts_p);

% plot results
figure(1); mv_plot(20, r_mat);
set(gcf,'color','white');

% call mv_feas to illustrate the set of feasible mean-variance points
m = 1000;
rseed = 567;
figure(2); 
tic
mv_feasible(r_mat, m, rseed);
toc
set(gcf,'color','white');

% end of mv_feasible_test.m