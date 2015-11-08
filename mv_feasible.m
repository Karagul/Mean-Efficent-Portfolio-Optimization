function mv_feasible(r_mat, m, rseed)
% MV_FEASIBLE  function to plot feasible portfolios in mv space
% inputs:  r_mat, m, rseed
%          where r_mat is a matrix of historical returns with
%          t rows corresponding to time and n columns to securities
%          m is the number of points in mv space
%          rseed is the random number seed
% outputs: none (a graph will be displayed)

%% Mean, SD, and Covariance of securities to be considered

n = size(r_mat,2); % No of securities in portfolio
mu = mean(r_mat); % Historical Mean of securities
sig = std(r_mat); % Historical SD of securities
covar = cov(r_mat); % Covariance matrix of securties

%% Initialization of portfolio data structures

x = zeros(m, n); % Matrix of random portfolio weights
x = transpose(x); % Portfolio defined as the transpose of security wts
mu_p = zeros(m, 1); % Vector of random portfolio means
sig_p = zeros(m, 1); % Vector of random portfolio SDs

%% Vectorized calculation of feasible portfolio space

rng(rseed); % seeding the random number generator
y = -log(rand(n, m)); % creating a matrix of uniform random numbers
normalizer = sum(y, 1); % computing the some of each row of random no
x = bsxfun(@rdivide, [y],[normalizer]); % normalizing each security wt 
% above operation has a computational cost O(nm)
sig_p = sqrt(diag(x.' * covar * x)); % computing the SD of portfolios
% above operation has a computational cost O(mnn) + O(mnm) 
mu_p = x.' * mu.'; % computing the mean return of portfolios


%% Graphing of feasible region

scatter(sig_p, mu_p, 'red', '.'); % scatter function to graph results
grid on; % set grid lines
hold on; % hold onto existing plot for further data to be displayed
scatter(sig, mu, 'blue', '+'); % scatter for unit vectors blue '+'
title('Mean-Variance Efficient Frontier'); % chart title 
xlabel('Portfolio Standard Deviation'); % axes labels
ylabel('Portfolio Mean Return');

% The overall computational cost is O((1+m+n)nm)

% end of mv_feasible.m