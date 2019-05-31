function [Ifish, Imut] = fig3(rho)
% fig3  Reproduce points from Figure 3
% 
% [Ifish, Imut] = fig3(rho) calculates the mutual information and I_Fisher for:
% correlation range parameter rho, which can be numeric (>= 0) or the string 'inf'

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 2e-2;      % Target relative error for MC halting
maxiter = 1e5;      % MC iteration limit

N = 128;            % population size
c = 0.3;            % max correlation coefficient
tau = 1.0;          % integration time (s)
fTau = 5.0;         % variability F/tau (spikes/s^2)
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)
fbg = 10.0;         % background firing rate (spikes/s)
sigma = 30.0;       % tuning curve width parameter (degrees)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);

switch rho
case 0      % independent noise
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);
case 'inf'  % uniform correlation
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
otherwise   % localised correlation
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-exponential', [F alpha c rho]);
end

% Compute measures
Ifish = popNrns.Ifisher(stim);
[Imut, ImutSEM, ImutSamps] = popNrns.mi('randMC', stim, stderr, maxiter);
    
fprintf('fig3.m\n')
fprintf('Parameters: N = %d neurons, c = %g\n', N, fTau)
fprintf('I_Fisher = %g bits\n', Ifish)
fprintf('I_mut = %g bits with StdErr %g bits\n', Imut, ImutSEM)
