%%
clc; clear; close all;
rng(2025);

% --- scatter data ---
N = 4000;
x1 = rand(N,1);           % [0, 1]   — fast oscillation
x2 = 5*rand(N,1);         % [0, 5]   — moderate variation
x3 = 10*rand(N,1).^2;     % [0, 10]  — nonlinear fill (denser near 0)
x4 = 100 + 50*rand(N,1);  % [100,150] — slow ramp

noise = 0.05 * randn(N,1);
w = sin(2*pi*x1) .* cos(pi*x2/5) + 0.4*(x3/10).^2 + 0.1*(x4-100)/50 + noise;

% --- inspect each input marginal ---
figure("Name","Input Variable Distribution")
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact')

inputs  = {x1, x2, x3, x4, w};
iLabels = {'x_1', 'x_2', 'x_3', 'x_4', 'w (response)'};
for k = 1:5
  nexttile
  histogram(inputs{k}, 30)
  xlabel(iLabels{k}); grid on
end

nexttile
scatter3(x1, x2, x3, 12, w, 'filled')
xlabel('x_1'); ylabel('x_2'); zlabel('x_3')
h = colorbar; ylabel(h, 'w')
title('3-D projection coloured by w')

%%
x1GridCoarse = linspace(0,   1,   8);
x2GridCoarse = linspace(0,   5,   9);
x3GridCoarse = linspace(0,  10,   10);   % uniform for now
x4GridCoarse = linspace(100,150,  6);
xGridCoarse = {x1GridCoarse, x2GridCoarse, x3GridCoarse, x4GridCoarse};

% per-dimension smoothness:
%   x1 has fast oscillation → small smoothness
%   x2 moderate              → moderate
%   x3 slow quadratic        → larger smoothness is fine
%   x4 very slow ramp        → largest smoothness
smoothness = [1e-3, 1e-3, 1e-2, 2e-2];

tic
wGridCoarse = regularizeNd([x1,x2,x3,x4], w, xGridCoarse, smoothness);
fprintf('Coarse grid  (%d nodes)  solve time: %.2f s\n', numel(wGridCoarse), toc)

wFuncCoarse = griddedInterpolant(xGridCoarse, wGridCoarse);

%%
plotSlices(xGridCoarse, wGridCoarse, 'coarse grid', 1:numel(xGridCoarse{4}));

%%
% --- moderate grid: refine x1 and x2 where variation is fastest ---
x1GridMedium = linspace(0,   1,  16);
x2GridMedium = linspace(0,   5,  14);
x3GridMedium = [0, 1, 2, 3, 4, 5, 7, 10];   % denser near 0 to match data fill
x4GridMedium = linspace(100,150,  6);
gridMedium = {x1GridMedium, x2GridMedium, x3GridMedium, x4GridMedium};

fprintf('Medium grid node count: %d\n', prod(cellfun(@numel,gridMedium)))

tic
wGridMedium = regularizeNd([x1,x2,x3,x4], w, gridMedium, smoothness);
fprintf('Medium grid  (%d nodes)  solve time: %.2f s\n', numel(wGridMedium), toc)

wFuncMedium = griddedInterpolant(gridMedium, wGridMedium);

%%
plotSlices(gridMedium, wGridMedium, 'medium grid', 1:numel(gridMedium{4}));

%%

resid = w - wFuncMedium(x1, x2, x3, x4);

figure("Name", "Residuals")
tiledlayout('TileSpacing', 'compact', 'Padding', 'compact')

nexttile
scatter(x1, resid,"x");
xlabel('x_1'); ylabel('Residual')
nexttile
scatter(x2, resid,"x");
xlabel('x_2'); ylabel('Residual')
nexttile
scatter(x3, resid,"x  ");
xlabel('x_3'); ylabel('Residual')
nexttile
scatter(x4, resid,"x");
xlabel('x_4'); ylabel('Residual')
nexttile([1,2])
scatter(w, resid,"x");
xlabel('w (true)'); ylabel('Residual')

%%

smoothnessValues = {
  [1e-3, 1e-3, 1e-2, 2e-2];   % baseline
  [1e-2, 1e-2, 1e-1, 2e-1];   % 10× smoother
  [1e-4, 1e-4, 1e-3, 2e-3];   % 10× tighter
  };
labels = {'baseline (1e-3 …)', 'smooth (1e-2 …)', 'tight (1e-4 …)'};


for k = 1:3
  wG = regularizeNd([x1,x2,x3,x4], w, gridMedium, smoothnessValues{k});
  plotSlices(gridMedium, wG, labels{k}, numel(gridMedium{4}));
end

%%

function plotSlices(xGrid, wGrid, gridName, x4Slices)
  % --- 2-D slice: vary x1 and x2, fix x3 and x4 ---
  
  % Preallocate
  onesMatrix = ones(numel(xGrid{1}), numel(xGrid{2}))';
  zlimits = nan(numel(x4Slices), 2);
  axesCoarseGrid = gobjects(numel(x4Slices), 1);

  % Loop over x4 and x3 to plot slices
  counter = 0;
  for i = x4Slices
    counter = counter + 1;
    for j = 1:numel(xGrid{3})
      wSlice = squeeze(wGrid(:,:,j,i))';
      
      if j == 1
        % first slice: create figure
        titleStr = sprintf("Slice at x_4 = %g, %s", xGrid{4}(i), gridName);
        figure("Name", titleStr);
        surf(xGrid{1}, xGrid{2}, wSlice, xGrid{3}(j)*onesMatrix);
        axesCoarseGrid(counter) = gca;
        hold on;
        ylabel(colorbar,"x_3");
        xlabel('x_1');
        ylabel('x_2');
        title(titleStr);
      else
        surf(xGrid{1}, xGrid{2}, wSlice, xGrid{3}(j)*onesMatrix);
      end

      zlimits(counter,:) = zlim;
    end
  end

  % set all coarse grid slice axes to the same z limits
  zMin = min(zlimits(:,1));
  zMax = max(zlimits(:,2));
  for i = 1:numel(axesCoarseGrid)
    zlim(axesCoarseGrid(i), [zMin zMax]);
  end

end