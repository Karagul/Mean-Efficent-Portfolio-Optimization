function mv_plot(m, r_mat, mu, sig, corr)
% MV_PLOT  plots a mean-variance efficient frontier
% input parameters:
% m       number of points on the efficient frontier,
%         from min variance (1) to max return (m)
% r_mat   return matrix:  rows = scenarios, columns = securities
% mu      vector of mean returns
% sig     vector of standard deviation of returns
% corr    correlation matrix of returns
% Note:   mv_plot uses either (1) r_mat, or (2) mu, sig, and corr.
%         in the second case, call mv_plot with r_mat = [].
% output:
% a figure
% sample calling sequences:
%    [wts_p, mu_p, sig_p] = mv_plot(10, [], mu, sig, corr);
%    [wts_p] = mv_plot(20, r_mat);

% call mv_eff to compute the efficient frontier
if (min(size(r_mat)) >= 2)
   mu    = mean(r_mat);
   sig   = std(r_mat);
  [wts_p, mu_p, sig_p] = mv_eff(m, r_mat);
else
  [wts_p, mu_p, sig_p] = mv_eff(m, r_mat, mu, sig, corr);
end;

% plot results
plot(sig_p, mu_p, sig, mu, '+'); grid;
title('Mean-Variance Efficient Frontier');
xlabel('Portfolio Standard Deviation');
ylabel('Portfolio Mean Return');

% end of mv_plot.m