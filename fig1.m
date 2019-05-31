function [Ifish, Imut] = fig1(fTau, fbg)
% fig1  Reproduce points from Figure 1
% 
% [Ifish, Imut] = fig1(fTau, fbg) calculates the mutual information and I_Fisher for:
% variability F/tau = fTau spikes/s^2
% background activity f_bg = fbg spikes/s

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 2e-2;      % Target relative error for MC halting
maxiter = 1e5;      % MC iteration limit

tau = 1.0;          % integration time
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate
sigma = 30.0;       % tuning curve width parameter
N = 4;              % population size

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);
popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);

% Compute measures
Ifish = popNrns.Ifisher(stim);
[Imut, ImutSEM, ImutSamps] = popNrns.mi('randMC', stim, stderr, maxiter);

fprintf('fig1.m\n')
fprintf('Parameters: F/tau = %g spikes/s^2, f_bg = %g spikes/s\n', fTau, fbg)
fprintf('I_Fisher = %g bits\n', Ifish)
fprintf('I_mut = %g bits with StdErr %g bits\n', Imut, ImutSEM)
fprintf('I_mut - I_Fisher = %g bits\n', Imut - Ifish)