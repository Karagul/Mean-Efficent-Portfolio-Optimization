function [wts_p, mu_p, sig_p] = mv_eff(m, r_mat, mu, sig, corr)
% MV_EFF  solves for the mean-variance efficient frontier
% input parameters:
% m       number of points on the efficient frontier,
%         from min variance (1) to max return (m)
% r_mat   return matrix:  rows = scenarios, columns = securities
% mu      vector of mean returns
% sig     vector of standard deviation of returns
% corr    correlation matrix of returns
% Note:   mv_eff uses either (1) r_mat, or (2) mu, sig, and corr.
%         in the second case, call mv_eff with r_mat = [].
% outputs:
% wts_p   matrix of portfolio weights of efficient portfolios
% mu_p    vector of mean returns of efficient portfolios
% sig_p   vector of std dev of returns of efficient portfolios
% sample calling sequences:
%    [wts_p, mu_p, sig_p] = mv_eff(10, [], mu, sig, corr);
%    [wts_p] = mv_eff(20, r_mat);

if (min(size(r_mat)) >= 2)
   mu    = mean(r_mat);
   sig   = std(r_mat);
   covar = cov(r_mat);
else
   covar = diag(sig)*corr*diag(sig);
end;
nsecur   = length(mu);
wts_p    = zeros(m, nsecur);
mu_p     = zeros(m, 1);
sig_p    = zeros(m, 1);

% set up variables for the call to qp
c       = zeros(1, nsecur);
A       = [];
b       = [];
Aeq     = [ones(1, nsecur)];
beq     = 1; 
vlb     = zeros(nsecur, 1);
vub     = ones(nsecur, 1);
x       = ones(nsecur, 1) / nsecur;  % guess equal weights

% first solve for minimum variance portfolio
options = optimset('display', 'off', 'largescale', 'off','algorithm', 'interior-point-convex');
x       = quadprog(covar, c, A, b, Aeq, beq, vlb, vub, x, options);

wts_p(1,:) = x';
mu_p(1)  = mu*x;
sig_p(1)  = sqrt(x'*covar*x);

mu_max = max(mu);
A      = -mu;
for i = 2 : m;
    b = -((m-i)/m*mu_p(1) + i/m*mu_max);
    x = quadprog(covar, c, A, b, Aeq, beq, vlb, vub, x, options);
    wts_p(i,:) = x';
    mu_p(i)  = mu*x;
    sig_p(i)  = sqrt(x'*covar*x);
 end;

% end of mv_eff.m