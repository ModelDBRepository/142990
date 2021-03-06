function pfr = fig5_C(fTau, c)
% fig5_C  Reproduce points from Figure 5C
% 
% pfr = fig5_C(fTau, c) calculates the peak-flank ratio (SSI_peak/SSI_flank), for:
% variability F/tau = fTau spikes/s^2
% correlation coefficient c

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
popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);

% Compute measures
fisher = singleNrn.fisher('analytic', stim, 0.0);
[dummy, ord1] = max(fisher(1:180));
[dummy, ord2] = max(fisher(181:end));
ords = [ord1 180 ord2+180];

ssi = popNrns.ssiss(nrn, 'randMC', stim, ords, stderr, maxiter, 1e10);
pfr = ssi(2) ./ mean(ssi([1 3]));

fprintf('fig5_C.m\n')
fprintf('Parameters: F/tau = %g spikes/s^2, c = %g\n', fTau, c)
fprintf('SSI_peak / SSI_flank = %g\n', pfr)
