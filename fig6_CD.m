function [mSSI, pfr] = fig6_CD(N, c, corrType)
% fig6_CD  Reproduce points/curves from Figures 6C and 6D
% 
% [mSSI, pfr] = fig6_CD(N, c, corrType) calculates the marginal SSI
% and peak/flank ratio mSSI_peak / mSSI_flank for:
% population size N
% noise correlation coefficient or max correlation coefficient c
% uniform (corrType = 'uni') or localised (corrType = 'loc') noise correlations

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011


tic

stderr = 5e-3;      % Target relative error for MC halting
maxiter = 5e3;      % MC iteration limit

fTau = 10.0;        % variability F/tau (spikes/s^2)
tau = 1.0;          % integration time (s)
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)
fbg = 10.0;         % background firing rate (spikes/s)
sigma = 30.0;       % tuning curve width parameter (degrees)
rho = 30.0;         % correlation range parameter (degrees)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];
nrn = floor(N/2)+1;

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);

switch corrType
case 'uni'
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
    singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
    corrTypeStr = 'uniform';
case 'loc'
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-exponential', [F alpha c rho]);
    singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-exponential', [F alpha c rho]);
    corrTypeStr = 'localised';
otherwise
    error('argument 3 (corrType) must be ''uni'' or ''loc''')
end

% Compute measures
fisher = singleNrn.fisher('analytic', stim, 0.0);
[dummy, ord1] = max(fisher(1:180));
[dummy, ord2] = max(fisher(181:end));
ords = [ord1 180 ord2+180];

mSSI = popNrns.ssiss(nrn, 'randMC', stim, [], stderr, maxiter, 1e10);
pfr = mSSI(ords(2)) ./ mean(mSSI(ords([1 3])));


fprintf('fig6_CD.m\n')
fprintf('Parameters: N = %d, c = %g, %s noise correlations\n', N, c, corrTypeStr)
fprintf('SSI_peak / SSI_flank = %g\n', pfr)
