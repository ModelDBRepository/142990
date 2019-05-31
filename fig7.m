function [Imut, Ifisher, fisher, mSSI, mSSIfisher, dI, dmSSI] = fig7(N, fTau, fbg, c, corrType)
% fig7  Reproduce points/curves from Figure 7
% 
% [fisher, mSSI, mSSIfisher, dI, dmSSI] = fig7(N, fTau, fbg, c, corrType) calculates the
% singleton Fisher information, marginal SSI, marginalSSI_Fisher, delta_Inf
% and delta_mSSI for:
% population size N
% variability F/tau = fTau spikes/s^2
% background activity f_bg = fbg spikes/s
% noise correlation coefficient or max correlation coefficient c
% independent noise (corrType = 'ind'), uniform (corrType = 'uni') or
% localised (corrType = 'loc') noise correlations

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 5e-3;      % Target relative error for MC halting
maxiter = 5e3;      % MC iteration limit

tau = 1.0;          % integration time (s)
F = fTau .* tau;    % Fano factor
alpha = 0.5;        % variability exponent
fmax = 50.0;        % peak firing rate (spikes/s)
sigma = 30.0;       % tuning curve width parameter (degrees)
rho = 30.0;         % correlation range parameter (degrees)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];
nrn = floor(N/2)+1;

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);

switch corrType
case 'ind'
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);
    singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-independent', [F alpha]);
    corrTypeStr = 'independent noise';
case 'uni'
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
    singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-uniform', [F alpha c]);
    corrTypeStr = 'uniform noise correlations';
case 'loc'
    popNrns = CircGaussNeurons(nrns, sigma, fmax, fbg, tau, 'Gaussian-exponential', [F alpha c rho]);
    singleNrn = CircGaussNeurons(0.0, sigma, fmax, fbg, tau, 'Gaussian-exponential', [F alpha c rho]);
    corrTypeStr = 'localised noise correlations';
otherwise
    error('argument 5 (corrType) must be ''ind'', ''uni'' or ''loc''')
end

% Compute measures
fisher = singleNrn.fisher('analytic', stim, 0.0);
Ifisher = popNrns.Ifisher(stim);
mSSIfisher =  popNrns.SSIfisher(nrn, 'analytic', stim, 0.0);
[ fSSI rSSI fIsur rIsur its Issi Isur IssiMarg IsurMarg ] = popNrns.ssiss(nrn, 'randMC', stim, [], stderr, maxiter, 1e10);

mSSI = fSSI - rSSI;
mSSI_samps = Issi.samples - IssiMarg.samples;
mSSIerr = sqrt(var(mSSI_samps, 1) ./ size(mSSI_samps,1));

Imut = mean(Issi.samples(:));
ImutErr = sqrt(var(Issi.samples(:)) / length(Issi.samples(:)));

% Compute delta measures
dI =  abs(Imut - Ifisher) ./ Imut;
dIerr = Ifisher .* ImutErr ./ Imut.^2;

rms = @(in) sqrt(mean(in.^2, 2));
dmSSI = rms(mSSI - mSSIfisher) ./ rms(mSSI);
mSSIferr = zeros(size(mSSIfisher));
dmSSIerr = bootstrapErrorProp(@(a,b) (rms(a-b)) ./ rms(a), {mSSI mSSIfisher}, {mSSIerr mSSIferr}, 10^4);

% Report results
fprintf('fig7.m\n')
fprintf('Parameters: N = %d, F/tau = %g spikes/s^2, f_bg = %g spikes/s, c = %g, %s\n', N, fTau, fbg, c, corrTypeStr)
fprintf('dI = %g with StdErr %g\n', dI, dIerr)
fprintf('dmSSI = %g with StdErr %g\n', dmSSI, dmSSIerr)
