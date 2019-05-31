function [Ifish, Imut] = fig2_CD(N, c)
% fig2_CD  Reproduce points from Figure 2C and 2D
% 
% [Ifish, Imut] = fig2_CD(N, c) calculates the mutual information and I_Fisher for:
% population size N neurons
% correlation coefficient c

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 2e-2;      % Target relative error for MC halting
maxiter = 4e5;      % MC iteration limit

tau = 1.0;          % integration time (s)
fTau = 10.0;        % variability F/tau (spikes/s^2)
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)
fbg = 10.0;         % background firing rate (spikes/s)
sigma = 30.0;       % tuning curve width parameter (degrees)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);
popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);

% Compute measures
Ifish = popNrns.Ifisher(stim);
[Imut, ImutSEM, ImutSamps] = popNrns.mi('randMC', stim, stderr, maxiter);
    
fprintf('fig2_CD.m\n')
fprintf('Parameters: N = %g neurons, c = %g\n', N, fTau)
fprintf('I_Fisher = %g bits\n', Ifish)
fprintf('I_mut = %g bits with StdErr %g bits\n', Imut, ImutSEM)
fprintf('I_mut - I_Fisher = %g bits\n', Imut - Ifish)
