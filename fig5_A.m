function [fisher, mSSI, mIsur] = fig5_A(fTau)
% fig5_A  Reproduce curves from Figure 5A
% 
% [fisher, mSSI, mIsur] = fig5_A(fTau) calculates the singleton Fisher information,
% marginal SSI and marginal specific surprise for:
% variability F/tau = fTau spikes/s^2

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 2e-2;      % Target relative error for MC halting
maxiter = 5e3;      % MC iteration limit

tau = 1.0;          % integration time (s)
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)
fbg = 10.0;         % background firing rate (spikes/s)
sigma = 30.0;       % tuning curve width parameter (degrees)
N = 4;              % population size

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];
nrn = floor(N/2)+1;

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);
popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);
singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);

% Compute measures
fisher = singleNrn.fisher('analytic', stim, 0.0);
[fullSSI, remSSI, fullIsur, remIsur, iter] = popNrns.ssiss(nrn, 'randMC', stim, [], stderr, maxiter, 1e10);
mSSI = fullSSI - remSSI;
mIsur = fullIsur - remIsur;

figure
plot(stim.ensemble, [max(mSSI).*(fisher./max(fisher)) ; mSSI ; mIsur])
legend({'Singleton Fisher (normalised)' 'mSSI' 'mI_{sur}'})
title(sprintf('fig5_A.m F/tau = %g spikes/s^2\n', fTau))
xlabel('Stimulus \theta')
ylabel('Information (bits)')
