% fig4  Reproduce Figure 4
% 
% Note: this takes a long time to run

% Stuart Yarrow s.yarrow@ed.ac.uk - 15/11/2011

tic

stderr = 2e-3;      % Target relative error for MC halting
maxiter_SSI = 5e3;  % MC iteration limits
maxiter_FI = 1e5;

N = 4;              % population size
tau = 1.0;          % integration time (s)
fbg = 0.01;         % background firing rate (spikes/s)

% Preferred stimuli
nrns = [-180 : 360/N : 180-360/N];
nrn = floor(N/2)+1;

% Define stimulus ensemble and population
stim = StimulusEnsemble('circular', 360, 360);

A = [1.0 3.0 5.0];

for i = 1 : length(A)
    add = 0.048 .* A(i);
    mult = 0.052 .* A(i);
    
    singleNrn = CosNeurons(0, fbg, tau, 'cercal', [add mult]);
    singleNrn.truncate = true;
    popNrns = CosNeurons(nrns, fbg, tau, 'cercal', [add mult]);
    popNrns.truncate = true;
    
    [ fSSI{i} rSSI{i} fIsur{i} rIsur{i} its(i) ] = popNrns.ssiss(nrn, 'randMC', stim, [], stderr, maxiter_SSI, 1e10);
    [ SNfSSI{i} SNrSSI{i} SNfIsur{i} SNrIsur{i} SNits(i) ] = singleNrn.ssiss([], 'randMC', stim, [], stderr, maxiter_SSI, 1e10);
    
    fisher{i} = popNrns.fisher('randMC', stim, stderr, maxiter_FI);
    snFI{i} = singleNrn.fisher('randMC', stim, stderr, maxiter_FI);
end

s = stim.ensemble;

set(0, 'DefaultAxesFontName', 'Helvetica')

% Low noise, A = 1

figure
p = patch([s, s(end:-1:1)], [SNfSSI{1}, fSSI{1}(end:-1:1) - rSSI{1}(end:-1:1)], [0.8 0.8 0.8], 'EdgeColor', 'none', 'LineStyle', 'none');
hold on
l = plot(s, fSSI{1}-rSSI{1}, 'b--', s, SNfSSI{1}, 'r-.');
[ax h1 h2] = plotyy(gca, s, fSSI{1}, s, snFI{1});

set(l, 'linewidth', 1.5)

box on

%set(l, 'linewidth', 1.5)
set(h1, 'linestyle', ':', 'color', 'k')
set(h2, 'linestyle', '-', 'color', 'k', 'linewidth', 1.5)

set(get(ax(1), 'xlabel'), 'string', 'Stimulus angle (deg)', 'verticalalignment', 'middle')
set(get(ax(2), 'xlabel'), 'string', '')
set(get(ax(1), 'ylabel'), 'string', 'Information (bits)')
set(get(ax(2), 'ylabel'), 'string', 'Fisher information (deg^{-2})')

set(ax(1), 'xtick', [-180 : 90 : 180], 'xlim', [-180 180])
set(ax(2), 'xtick', [], 'xlim', [-180 180])

set(ax(1), 'ytick', [0 : 1 : 6], 'ylim', [0 6], 'xcolor', 'k', 'ycolor', 'k')
set(ax(2), 'ytick', [0 : 0.05 : 0.3], 'ylim', [0 0.3], 'xcolor', 'k', 'ycolor', 'k')

set(p, 'HandleVisibility', 'off')
leg = legend({'Marginal SSI' 'Singleton SSI', 'Population SSI', 'Singleton FI'});
set(leg, 'FontSize', 6)

line([-180 180], mean(fSSI{1}) .* [1 1], 'color', 'k', 'linewidth', 0.5, 'linestyle', '--');
text(-155, mean(fSSI{1}) - 0.15, ['I_{mut} = ' num2str(mean(fSSI{1}), 3) ' bits'], 'fontsize', 6, 'vertical', 'top');

set(gca, 'ActivePositionProperty', 'OuterPosition')
set(gcf, 'Color', 'w')
set(gcf, 'Units', 'centimeters');
set(gcf, 'OuterPosition', [5 10 20 8]);
%shrinkfig(ax, 0.9)



% Medium noise, A = 3

figure
p = patch([s, s(end:-1:1)], [SNfSSI{2}, fSSI{2}(end:-1:1) - rSSI{2}(end:-1:1)], [0.8 0.8 0.8], 'EdgeColor', 'none', 'LineStyle', 'none');
hold on
l = plot(s, fSSI{2}-rSSI{2}, 'b--', s, SNfSSI{2}, 'r-.');
[ax h1 h2] = plotyy(gca, s, fSSI{2}, s, snFI{2});

set(l, 'linewidth', 1.5)

box on

%set(l, 'linewidth', 1.5)
set(h1, 'linestyle', ':', 'color', 'k')
set(h2, 'linestyle', '-', 'color', 'k', 'linewidth', 1.5)

set(get(ax(1), 'xlabel'), 'string', 'Stimulus angle (deg)', 'verticalalignment', 'middle')
set(get(ax(2), 'xlabel'), 'string', '')
set(get(ax(1), 'ylabel'), 'string', 'Information (bits)')
set(get(ax(2), 'ylabel'), 'string', 'Fisher information (deg^{-2})')

set(ax(1), 'xtick', [-180 : 90 : 180], 'xlim', [-180 180])
set(ax(2), 'xtick', [], 'xlim', [-180 180])

set(ax(1), 'ytick', [0 : 1 : 4], 'ylim', [0 4], 'xcolor', 'k', 'ycolor', 'k')
set(ax(2), 'ytick', [0 : 0.01 : 0.04], 'ylim', [0 0.04], 'xcolor', 'k', 'ycolor', 'k')

set(p, 'HandleVisibility', 'off')
%legend({'Marginal SSI' 'Singleton SSI', 'Population SSI', 'Singleton FI'})

line([-180 180], mean(fSSI{2}) .* [1 1], 'color', 'k', 'linewidth', 0.5, 'linestyle', '--');
text(-155, mean(fSSI{2}) - 0.15, ['I_{mut} = ' num2str(mean(fSSI{2}), 3) ' bits'], 'fontsize', 6, 'vertical', 'top');

set(gca, 'ActivePositionProperty', 'OuterPosition')
set(gcf, 'Color', 'w')
set(gcf, 'Units', 'centimeters');
set(gcf, 'OuterPosition', [5 10 20 8]);
%shrinkfig(ax, 0.9)


% High noise, A = 5

figure
p = patch([s, s(end:-1:1)], [SNfSSI{3}, fSSI{3}(end:-1:1) - rSSI{3}(end:-1:1)], [0.8 0.8 0.8], 'EdgeColor', 'none', 'LineStyle', 'none');
hold on
l = plot(s, fSSI{3}-rSSI{3}, 'b--', s, SNfSSI{3}, 'r-.');
[ax h1 h2] = plotyy(gca, s, fSSI{3}, s, snFI{3});

set(l, 'linewidth', 1.5)

box on

%set(l, 'linewidth', 1.5)
set(h1, 'linestyle', ':', 'color', 'k')
set(h2, 'linestyle', '-', 'color', 'k', 'linewidth', 1.5)

set(get(ax(1), 'xlabel'), 'string', 'Stimulus angle (deg)', 'verticalalignment', 'middle')
set(get(ax(2), 'xlabel'), 'string', '')
set(get(ax(1), 'ylabel'), 'string', 'Information (bits)')
set(get(ax(2), 'ylabel'), 'string', 'Fisher information (deg^{-2})')

set(ax(1), 'xtick', [-180 : 90 : 180], 'xlim', [-180 180])
set(ax(2), 'xtick', [], 'xlim', [-180 180])

set(ax(1), 'ytick', [0 : 0.5 : 3], 'ylim', [0 3], 'xcolor', 'k', 'ycolor', 'k')
set(ax(2), 'ytick', [0 : 0.01 : 0.03], 'ylim', [0 0.03], 'xcolor', 'k', 'ycolor', 'k')

set(p, 'HandleVisibility', 'off')
%legend({'Marginal SSI' 'Singleton SSI', 'Population SSI', 'Singleton FI'})

line([-180 180], mean(fSSI{3}) .* [1 1], 'color', 'k', 'linewidth', 0.5, 'linestyle', '--');
text(-155, mean(fSSI{3}) - 0.15, ['I_{mut} = ' num2str(mean(fSSI{3}), 3) ' bits'], 'fontsize', 6, 'vertical', 'top');

set(gca, 'ActivePositionProperty', 'OuterPosition')
set(gcf, 'Color', 'w')
set(gcf, 'Units', 'centimeters');
set(gcf, 'OuterPosition', [5 10 20 8]);
%shrinkfig(ax, 0.9)


% Tuning curves and variability

stim = StimulusEnsemble('circular', 360, 360);

f0 = 0.0;
tau = 1.0;

N = 4;
aArr = [1.0 3.0 5.0];

nrns = [-180 : 360 / N : 180 - 360 / N];
nrn = floor(N/2)+1;

for an = 1 : length(aArr)
    add = 0.048 .* aArr(an);
    mult = 0.052 .* aArr(an);
    
    singleNrn = CosNeurons(0, f0, tau, 'cercal', [add mult]);
    popNrns = CosNeurons(nrns, f0, tau, 'cercal', [add mult]);
        
    [stims{an} ind{an}] = sort(double(stim.ensemble));
    
    f{an} = popNrns.meanR(stim);
    rMeanCell = squeeze(mat2cell(f{an}, 4, ones(360, 1)));
    sigma{an} = popNrns.Q(rMeanCell);
    sigma{an} = cellfun(@(r) diag(r), sigma{an}, 'UniformOutput', false);
    sigma{an} = cellfun(@(r) r(nrn).^0.5, sigma{an}, 'UniformOutput', false);
    f{an} = f{an}(:,ind{an});
    sigma{an} = sigma{an}(:,ind{an});
    
    
end

s = stim.ensemble;

figure
[ax h1 h2] = plotyy(gca, 0, 0, 0, 0);
hold on
l = plot(ax(1), s, f{an}(nrn,:), 'k-', s, f{an}(nrn,:) + cell2mat(sigma{1}), 'k--', s, f{an}(nrn,:) + cell2mat(sigma{2}), 'k-.', s, f{an}(nrn,:) + cell2mat(sigma{3}), 'k:', s, f{an}([1,2,4],:), 'b-');

ylim([0 2])
%set(l, 'color', 'k')
set(l([1,2,3,4]), 'linewidth', 1.5)

set(get(ax(1), 'xlabel'), 'string', 'Stimulus angle (deg)', 'verticalalignment', 'middle')
set(get(ax(2), 'xlabel'), 'string', '')
set(get(ax(1), 'ylabel'), 'string', 'Normalised firing rate')
set(get(ax(2), 'ylabel'), 'string', '', 'color', 'w')

set(ax(1), 'xtick', [-180 : 90 : 180], 'xlim', [-180 180])
set(ax(2), 'xtick', [], 'xlim', [-180 180])

set(ax(1), 'ytick', [0 : 0.5 : 2], 'ylim', [0 2], 'xcolor', 'k', 'ycolor', 'k')
set(ax(2), 'ytick', [], 'ylim', [0 0.5], 'xcolor', 'k', 'ycolor', 'k')


set([h1 ; h2 ; l(5:6)], 'HandleVisibility', 'off')
leg = legend({'Mean firing rate', 'Mean + 1 std, A=1', 'Mean + 1 std, A=3', 'Mean + 1 std, A=5', 'Mean, other neurons'});
set(leg, 'FontSize', 6)

set(gca, 'ActivePositionProperty', 'OuterPosition')
set(gcf, 'Color', 'w')
set(gcf, 'Units', 'centimeters');
set(gcf, 'OuterPosition', [5 10 20 8]);
%shrinkfig(ax, 0.9)
