function [fisher, ssi, SSIfisher] = fig8(N, beta, sigma_mod, sigma)
% fig8  Reproduce curves from Figure 8
% 
% [fisher, ssi, SSIfisher] = fig8(N, adapt, sigma_adapt, sigma) calculates the
% population Fisher information, SSI and SSI_Fisher for:
% population size N
% adaptation modulation factor beta (in range [0,1])
% adaptation width sigma_mod (degrees)
% tuning curve width sigma (degrees)

% Stuart Yarrow s.yarrow@ed.ac.uk - 18/11/2011

tic

stderr = 5e-3;      % Target relative error for MC halting
maxiter = 2e3;      % MC iteration limit

fTau = 5.0;         % variability F/tau (spikes/s^2)
tau = 1.0;          % integration time (s)
F = fTau .* tau;    % Fano factor
fbg = 10.0;         % background activity (spikes/s)
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);
popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);

% Apply gain modulation
popNrns = popNrns.gainadapt(sigma_mod, beta, 0.0);

% Compute measures
fisher = popNrns.fisher('analytic', stim, 0.0);
SSIfisher =  popNrns.SSIfisher([], 'analytic', stim, 0.0);
ssi = popNrns.ssiss([], 'randMC', stim, [], stderr, maxiter, 1e10);

% Report results
figure
plot(stim.ensemble, fisher./max(fisher), 'r--', stim.ensemble, ssi./max(ssi), 'k-', stim.ensemble, SSIfisher./max(SSIfisher), 'b:')
title(sprintf('fig8.m\nParameters: N = %d, \\beta = %g, \\sigma_{mod} = %g^\\circ, \\sigma = %g^\\circ\n', N, beta, sigma_mod, sigma))
xlabel('Stimulus angle \theta')
ylabel('Information (normalised)')
legend({'Fisher information' 'SSI' ' SSI_{Fisher}'})