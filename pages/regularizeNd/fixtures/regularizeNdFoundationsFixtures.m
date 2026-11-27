function report = regularizeNdFoundationsFixtures(options)
% Reproducible numerical fixtures for the regularizeNd foundations series.
%
%   report = regularizeNdFoundationsFixtures()
%   report = regularizeNdFoundationsFixtures(Verbose=false)
%
% Every fixture is assembled here directly from the equations, then checked
% against a second reference built a different way. If regularizeNdMatrices
% and regularizeNd are on the MATLAB path, the fixtures are also compared
% with the package; otherwise that comparison is reported as skipped.

arguments
  options.Verbose (1,1) logical = true
end

report.oneD = oneDFixture();
report.surface = surfaceFixture();
report.packageCheck = packageCrossCheck(report);

if options.Verbose
  printReport(report);
end
end

%% One-dimensional fixture (Foundations 1-5)

function fx = oneDFixture
fx.x = [0.35; 1.00; 1.80; 2.70; 3.65];
fx.y = [1.0; 1.4; 0.4; 1.2; 0.2];
fx.grid = [0; 1; 2; 2.5; 3; 4];
fx.smoothness = 0.01;

fx.system = assemble1D(fx.grid, fx.x, fx.y, fx.smoothness, true);
fx.reference = reference1D(fx.grid, fx.x, fx.y, fx.smoothness);
fx.projection = projection1D(fx.system, fx.x, fx.y, fx.grid);
fx.storage = storageCounts(fx.grid, fx.x, fx.y, fx.smoothness);
fx.resolution = resolutionStudy(fx.grid, fx.x, fx.y, fx.smoothness);

sys = fx.system;
assert(max(abs(full(sum(sys.fidelity, 2)) - 1)) < 1e-12, 'fidelity rows must sum to one');
assert(nnz(sys.fidelity(2, :)) == 1, 'exact-node sample must have one nonzero weight');
assert(max(abs(full(sys.d2 * fx.grid))) < 1e-12, 'second-difference rows must annihilate linear data');
assert(max(abs(full(sys.d2 * ones(size(fx.grid))))) < 1e-12, 'second-difference rows must annihilate constants');
assert(max(abs(full(sys.fidelity - fx.reference.fidelity)), [], 'all') < 1e-12);
assert(max(abs(full(sys.d2 - fx.reference.d2)), [], 'all') < 1e-12);
assert(max(abs(sys.solution - fx.reference.solution)) < 1e-12);
end

function sys = assemble1D(grid, x, y, smoothness, normalizeByRows)
nSamples = numel(x);
nNodes = numel(grid);
nRows = nNodes - 2;

rows = zeros(2*nSamples, 1); cols = rows; vals = rows;
for i = 1:nSamples
  lower = min(find(grid <= x(i), 1, 'last'), nNodes - 1);
  t = (x(i) - grid(lower)) / (grid(lower + 1) - grid(lower));
  rows(2*i-1:2*i) = i;
  cols(2*i-1:2*i) = [lower; lower + 1];
  vals(2*i-1:2*i) = [1 - t; t];
end
fidelity = sparse(rows, cols, vals, nSamples, nNodes);

d2 = secondDerivativeRows1D(grid);
rowFactor = 1;
if normalizeByRows
  rowFactor = sqrt(nSamples / nRows);
end
multiplier = smoothness * rowFactor * (grid(end) - grid(1))^2;
regularization = multiplier * d2;

system = [fidelity; regularization];
rhs = [y; zeros(nRows, 1)];
solution = system \ rhs;
residual = system * solution - rhs;

sys.fidelity = fidelity;
sys.d2 = d2;
sys.rowFactor = rowFactor;
sys.rangeFactor = (grid(end) - grid(1))^2;
sys.multiplier = multiplier;
sys.regularization = regularization;
sys.system = system;
sys.rhs = rhs;
sys.solution = solution;
sys.residual = residual;
sys.fidelityResidual = residual(1:nSamples);
sys.regularizationResidual = residual(nSamples+1:end);
sys.fidelitySSE = sum(sys.fidelityResidual.^2);
sys.regularizationSSE = sum(sys.regularizationResidual.^2);
sys.fittedAtSamples = fidelity * solution;
end

function d2 = secondDerivativeRows1D(grid)
% Three-point second derivative from the parabola through each node triple.
n = numel(grid);
left = grid(1:end-2); center = grid(2:end-1); right = grid(3:end);
w = [2 ./ ((left - center) .* (left - right)), ...
     2 ./ ((center - left) .* (center - right)), ...
     2 ./ ((right - left) .* (right - center))];
r = (1:n-2)';
d2 = sparse([r r r], [r r+1 r+2], w, n - 2, n);
end

function ref = reference1D(grid, x, y, smoothness)
% Independent construction: interpolate identity basis vectors and solve a
% Vandermonde system for each second-derivative stencil.
n = numel(grid);
ref.fidelity = interp1(grid, eye(n), x, 'linear');
ref.d2 = zeros(n - 2, n);
for r = 1:n-2
  nodes = grid(r:r+2);
  V = [ones(1, 3); nodes'; (nodes').^2];
  ref.d2(r, r:r+2) = (V \ [0; 0; 2])';
end
multiplier = smoothness * sqrt(numel(x) / (n - 2)) * (grid(end) - grid(1))^2;
A = [ref.fidelity; multiplier * ref.d2];
ref.solution = A \ [y; zeros(n - 2, 1)];
end

function proj = projection1D(sys, x, y, grid)
% Normal-equation pieces assembled two ways: by matrix products and by
% accumulating each row's outer product without forming the stacked matrix.
Af = sys.fidelity;
L = sys.regularization;
proj.AfTAf = Af' * Af;
proj.LTL = L' * L;
proj.AfTy = Af' * y;
proj.normalMatrix = proj.AfTAf + proj.LTL;

n = numel(grid);
accumulated = zeros(n);
accumulatedRhs = zeros(n, 1);
for i = 1:size(Af, 1)
  [~, c, w] = find(Af(i, :));
  accumulated(c, c) = accumulated(c, c) + w' * w;
  accumulatedRhs(c) = accumulatedRhs(c) + y(i) * w';
end
for r = 1:size(L, 1)
  [~, c, w] = find(L(r, :));
  accumulated(c, c) = accumulated(c, c) + w' * w;
end
proj.accumulationDifference = max(abs(accumulated - full(proj.normalMatrix)), [], 'all');
proj.accumulationRhsDifference = max(abs(accumulatedRhs - full(proj.AfTy)));

tracedSample = 3;
[~, c, w] = find(Af(tracedSample, :));
proj.tracedSample.index = tracedSample;
proj.tracedSample.x = x(tracedSample);
proj.tracedSample.y = y(tracedSample);
proj.tracedSample.columns = c;
proj.tracedSample.weights = w;
proj.tracedSample.normalContribution = w' * w;
proj.tracedSample.rhsContribution = y(tracedSample) * w';

tracedRow = 2;
[~, c, w] = find(L(tracedRow, :));
proj.tracedRegularizationRow.index = tracedRow;
proj.tracedRegularizationRow.columns = c;
proj.tracedRegularizationRow.unscaledWeights = full(sys.d2(tracedRow, c));
proj.tracedRegularizationRow.scaledWeights = w;
proj.tracedRegularizationRow.normalContribution = w' * w;

[i, j] = find(proj.normalMatrix);
proj.bandwidth = max(abs(i - j));
R = chol(proj.normalMatrix);
proj.choleskySolution = R \ (R' \ proj.AfTy);
proj.choleskyDifference = max(abs(proj.choleskySolution - sys.solution));
[i, j] = find(R);
proj.choleskyUpperBandwidth = max(j - i);

assert(proj.accumulationDifference < 1e-12);
assert(proj.accumulationRhsDifference < 1e-12);
assert(proj.bandwidth == 2, 'normal matrix must be pentadiagonal');
assert(proj.choleskyUpperBandwidth == 2, 'Cholesky factor must keep the band');
assert(proj.choleskyDifference < 1e-10);
end

function counts = storageCounts(grid0, x, y, smoothness)
counts = struct('nodes', {}, 'stackedRows', {}, 'stackedDenseEntries', {}, ...
  'stackedNonzeros', {}, 'normalDenseEntries', {}, 'normalNonzeros', {});
for factor = [1 2000]
  grid = refineGrid(grid0, factor);
  sys = assemble1D(grid, x, y, smoothness, true);
  N = sys.system' * sys.system;
  counts(end+1) = struct( ...
    'nodes', numel(grid), ...
    'stackedRows', size(sys.system, 1), ...
    'stackedDenseEntries', numel(sys.system), ...
    'stackedNonzeros', nnz(sys.system), ...
    'normalDenseEntries', numel(grid)^2, ...
    'normalNonzeros', nnz(N)); %#ok<AGROW>
end
end

function study = resolutionStudy(grid0, x, y, smoothness)
referenceFactor = 1024;
referenceGrid = refineGrid(grid0, referenceFactor);
reference = assemble1D(referenceGrid, x, y, smoothness, true);

factors = [1 4 16 64 256];
study.referenceNodes = numel(referenceGrid);
study.factors = factors;
study.nodes = zeros(size(factors));
study.normalized = zeros(numel(factors), 3);
study.withoutRowFactor = zeros(numel(factors), 3);
for k = 1:numel(factors)
  grid = refineGrid(grid0, factors(k));
  a = assemble1D(grid, x, y, smoothness, true);
  b = assemble1D(grid, x, y, smoothness, false);
  target = interp1(referenceGrid, reference.solution, grid);
  study.nodes(k) = numel(grid);
  study.normalized(k, :) = [a.fidelitySSE, a.regularizationSSE, max(abs(a.solution - target))];
  study.withoutRowFactor(k, :) = [b.fidelitySSE, b.regularizationSSE, max(abs(b.solution - target))];
end

lineFit = [x, ones(size(x))] \ y;
study.straightLineSSE = sum(([x, ones(size(x))] * lineFit - y).^2);

assert(all(diff(study.normalized(:, 3)) < 0), 'normalized fit must converge under refinement');
assert(all(diff(study.withoutRowFactor(:, 1)) > 0), 'without the row factor the fit must drift');
end

function grid = refineGrid(grid0, factor)
grid = zeros(factor * (numel(grid0) - 1) + 1, 1);
for i = 1:numel(grid0) - 1
  t = linspace(grid0(i), grid0(i + 1), factor + 1)';
  grid((i - 1)*factor + (1:factor)) = t(1:end-1);
end
grid(end) = grid0(end);
end

%% Two-dimensional-input fixture (Foundations 6-7)

function fx = surfaceFixture
fx.xGrid = [0; 1; 2; 4];
fx.yGrid = [-1; 2; 5];
fx.samples = [0 -1; 0 0.5; 0.25 3.5; 2 2; 3.5 0.2; 4 5];
fx.values = [0.8; 0.4; 1.6; 1.1; 1.0; 1.2];
fx.cases = ["exact corner node"; "edge (x on boundary)"; "cell interior"; ...
  "exact interior node"; "cell interior"; "exact corner node"];
fx.smoothness = 0.03;

nx = numel(fx.xGrid); ny = numel(fx.yGrid);
gridSize = [nx, ny];
nNodes = nx * ny;
nSamples = size(fx.samples, 1);
fx.gridSize = gridSize;
fx.indexTable = reshape(1:nNodes, gridSize);

rows = []; cols = []; vals = [];
fx.sampleColumns = cell(nSamples, 1);
fx.sampleWeights = cell(nSamples, 1);
for s = 1:nSamples
  [ix, tx] = locate(fx.xGrid, fx.samples(s, 1));
  [iy, ty] = locate(fx.yGrid, fx.samples(s, 2));
  wx = [1 - tx, tx]; wy = [1 - ty, ty];
  c = []; w = [];
  for b = 1:2
    for a = 1:2
      weight = wx(a) * wy(b);
      if weight ~= 0
        c(end+1) = sub2ind(gridSize, ix + a - 1, iy + b - 1); %#ok<AGROW>
        w(end+1) = weight; %#ok<AGROW>
      end
    end
  end
  fx.sampleColumns{s} = c;
  fx.sampleWeights{s} = w;
  rows = [rows, repmat(s, 1, numel(c))]; %#ok<AGROW>
  cols = [cols, c]; %#ok<AGROW>
  vals = [vals, w]; %#ok<AGROW>
end
fx.fidelity = sparse(rows, cols, vals, nSamples, nNodes);

fx.d2x = directionalRows(fx.xGrid, gridSize, 1);
fx.d2y = directionalRows(fx.yGrid, gridSize, 2);
fx.rowCountFormula = [(nx - 2) * ny, nx * (ny - 2)];
fx.rowCounts = [size(fx.d2x, 1), size(fx.d2y, 1)];
fx.rowFactors = sqrt(nSamples ./ fx.rowCounts);
fx.rangeFactors = [(fx.xGrid(end) - fx.xGrid(1))^2, (fx.yGrid(end) - fx.yGrid(1))^2];
fx.multipliers = fx.smoothness .* fx.rowFactors .* fx.rangeFactors;
fx.combinedRowFactor = sqrt(nSamples / sum(fx.rowCounts));

fx.system = [fx.fidelity; fx.multipliers(1) * fx.d2x; fx.multipliers(2) * fx.d2y];
fx.rhs = [fx.values; zeros(sum(fx.rowCounts), 1)];
fx.solution = fx.system \ fx.rhs;
fx.table = reshape(fx.solution, gridSize);
residual = fx.system * fx.solution - fx.rhs;
fx.fidelitySSE = sum(residual(1:nSamples).^2);
fx.regularizationSSE = sum(residual(nSamples+1:end).^2);
fx.fittedAtSamples = fx.fidelity * fx.solution;
fx.rank = rank(full(fx.system));
normal = fx.system' * fx.system;
fx.normalDifference = max(abs(normal \ (fx.system' * fx.rhs) - fx.solution));

% Independent construction: interpolate each basis table with
% griddedInterpolant and build directional operators with Kronecker products.
refFidelity = zeros(nSamples, nNodes);
for k = 1:nNodes
  basis = zeros(gridSize); basis(k) = 1;
  F = griddedInterpolant({fx.xGrid, fx.yGrid}, basis, 'linear');
  refFidelity(:, k) = F(fx.samples);
end
refD2x = kron(speye(ny), secondDerivativeRows1D(fx.xGrid));
refD2y = kron(secondDerivativeRows1D(fx.yGrid), speye(nx));
refSystem = [refFidelity; fx.multipliers(1) * refD2x; fx.multipliers(2) * refD2y];
fx.referenceSolution = refSystem \ fx.rhs;
fx.referenceDifference = max(abs(fx.referenceSolution - fx.solution));

assert(max(abs(full(sum(fx.fidelity, 2)) - 1)) < 1e-12);
assert(max(abs(full(fx.fidelity) - refFidelity), [], 'all') < 1e-12);
assert(max(abs(full(fx.d2x - refD2x)), [], 'all') < 1e-12);
assert(max(abs(full(fx.d2y - refD2y)), [], 'all') < 1e-12);
assert(isequal(fx.rowCounts, fx.rowCountFormula));
assert(fx.rank == nNodes);
assert(fx.referenceDifference < 1e-12);
assert(fx.normalDifference < 1e-10);
for i = 1:nx
  for j = 1:ny
    assert(fx.table(i, j) == fx.solution(i + (j - 1) * nx));
  end
end
end

function [lower, t] = locate(grid, value)
lower = min(find(grid <= value, 1, 'last'), numel(grid) - 1);
t = (value - grid(lower)) / (grid(lower + 1) - grid(lower));
end

function rows = directionalRows(axisGrid, gridSize, axis)
% Second-derivative rows along one axis, ordered like regularizeNdMatrices:
% the first grid index varies fastest.
stencil = full(secondDerivativeRows1D(axisGrid));
nRowsAxis = numel(axisGrid) - 2;
nx = gridSize(1); ny = gridSize(2);
if axis == 1
  nRows = nRowsAxis * ny;
else
  nRows = nx * nRowsAxis;
end
r = zeros(3*nRows, 1); c = r; v = r;
row = 0;
if axis == 1
  for j = 1:ny
    for i = 1:nRowsAxis
      row = row + 1;
      idx = 3*row-2:3*row;
      r(idx) = row;
      c(idx) = sub2ind(gridSize, i:i+2, [j j j]);
      v(idx) = stencil(i, i:i+2);
    end
  end
else
  for j = 1:nRowsAxis
    for i = 1:nx
      row = row + 1;
      idx = 3*row-2:3*row;
      r(idx) = row;
      c(idx) = sub2ind(gridSize, [i i i], j:j+2);
      v(idx) = stencil(j, j:j+2);
    end
  end
end
rows = sparse(r, c, v, nRows, prod(gridSize));
end

%% Optional comparison with the regularizeNd package

function check = packageCrossCheck(report)
check.status = "skipped: regularizeNdMatrices is not on the MATLAB path";
if exist('regularizeNdMatrices', 'file') ~= 2 || exist('regularizeNd', 'file') ~= 2
  return
end

one = report.oneD;
[Af, L] = regularizeNdMatrices(one.x, {one.grid}, one.smoothness, 'linear');
check.oneDFidelity = max(abs(full(Af - one.system.fidelity)), [], 'all');
check.oneDRegularization = max(abs(full(L{1} - one.system.regularization)), [], 'all');
z = regularizeNd(one.x, one.y, {one.grid}, one.smoothness, 'linear', '\');
check.oneDSolution = max(abs(z - one.system.solution));

srf = report.surface;
[Af, L] = regularizeNdMatrices(srf.samples, {srf.xGrid, srf.yGrid}, srf.smoothness, 'linear');
check.surfaceFidelity = max(abs(full(Af - srf.fidelity)), [], 'all');
check.surfaceRegularization = max( ...
  max(abs(full(L{1} - srf.multipliers(1) * srf.d2x)), [], 'all'), ...
  max(abs(full(L{2} - srf.multipliers(2) * srf.d2y)), [], 'all'));
Z = regularizeNd(srf.samples, srf.values, {srf.xGrid, srf.yGrid}, srf.smoothness, 'linear', '\');
check.surfaceSolution = max(abs(Z - srf.table), [], 'all');
check.surfaceOutputSize = size(Z);

worst = max([check.oneDFidelity, check.oneDRegularization, check.oneDSolution, ...
  check.surfaceFidelity, check.surfaceRegularization, check.surfaceSolution]);
assert(worst < 1e-12, 'fixture disagrees with regularizeNd');
assert(isequal(check.surfaceOutputSize, srf.gridSize));
check.status = sprintf("passed: max difference %.3g against %s", worst, which('regularizeNdMatrices'));
end

%% Printing

function printReport(report)
one = report.oneD; sys = one.system; proj = one.projection;
fprintf('\n=== 1D fixture (Foundations 1-5) ===\n');
printVector('sample x', one.x);
printVector('sample y', one.y);
printVector('output grid', one.grid);
fprintf('smoothness = %g\n', one.smoothness);
printMatrix('fidelity matrix A_f', full(sys.fidelity));
printMatrix('unscaled second-derivative rows D', full(sys.d2));
fprintf('row factor sqrt(%d/%d) = %.12g, range factor = %g, multiplier = %.12g\n', ...
  numel(one.x), numel(one.grid) - 2, sys.rowFactor, sys.rangeFactor, sys.multiplier);
printVector('solution z', sys.solution);
printVector('fitted values at samples', sys.fittedAtSamples);
printVector('fidelity residuals', sys.fidelityResidual);
printVector('regularization residuals', sys.regularizationResidual);
fprintf('fidelity SSE = %.12g, regularization SSE = %.12g\n', sys.fidelitySSE, sys.regularizationSSE);
fprintf('independent reference solution difference = %.3g\n', ...
  max(abs(sys.solution - one.reference.solution)));

fprintf('\n--- projection (Foundation 5) ---\n');
printMatrix('A_f''A_f', full(proj.AfTAf));
printMatrix('L''L', full(proj.LTL));
printVector('A_f''y', full(proj.AfTy));
t = proj.tracedSample;
fprintf('traced sample %d (x=%g, y=%g): columns %s, weights %s\n', t.index, t.x, t.y, ...
  mat2str(t.columns), mat2str(full(t.weights), 12));
printMatrix('  contribution to A_f''A_f', full(t.normalContribution));
printVector('  contribution to A_f''y', full(t.rhsContribution));
t = proj.tracedRegularizationRow;
fprintf('traced regularization row %d: columns %s, unscaled %s, scaled %s\n', t.index, ...
  mat2str(t.columns), mat2str(t.unscaledWeights, 12), mat2str(full(t.scaledWeights), 12));
printMatrix('  contribution to L''L', full(t.normalContribution));
fprintf('row-accumulation vs matrix-product difference = %.3g (rhs %.3g)\n', ...
  proj.accumulationDifference, proj.accumulationRhsDifference);
fprintf('normal-matrix bandwidth = %d, Cholesky upper bandwidth = %d, Cholesky vs QR difference = %.3g\n', ...
  proj.bandwidth, proj.choleskyUpperBandwidth, proj.choleskyDifference);

fprintf('\n--- storage counts (Foundation 4) ---\n');
for c = one.storage
  fprintf(['nodes=%6d stacked %d rows: dense entries=%d nonzeros=%d | ' ...
    'normal: dense entries=%d nonzeros=%d\n'], c.nodes, c.stackedRows, ...
    c.stackedDenseEntries, c.stackedNonzeros, c.normalDenseEntries, c.normalNonzeros);
end

fprintf('\n--- resolution study (Foundation 3), reference %d nodes ---\n', one.resolution.referenceNodes);
fprintf('%6s | %-34s | %-34s\n', 'nodes', 'with row factor: fidSSE regSSE maxdev', ...
  'without row factor: fidSSE regSSE maxdev');
for k = 1:numel(one.resolution.nodes)
  fprintf('%6d | %10.6f %10.6f %10.6f | %10.6f %10.6f %10.6f\n', one.resolution.nodes(k), ...
    one.resolution.normalized(k, :), one.resolution.withoutRowFactor(k, :));
end
fprintf('least-squares straight-line SSE = %.12g\n', one.resolution.straightLineSSE);

srf = report.surface;
fprintf('\n=== 2D-input fixture (Foundations 6-7) ===\n');
printVector('x grid', srf.xGrid);
printVector('y grid', srf.yGrid);
fprintf('smoothness = %g\n', srf.smoothness);
printMatrix('ndgrid linear-index table reshape(1:%d,[%d %d])', srf.indexTable, ...
  numel(srf.indexTable), srf.gridSize(1), srf.gridSize(2));
for s = 1:size(srf.samples, 1)
  fprintf('sample %d (%g, %g) value %g [%s]: columns %s weights %s\n', s, srf.samples(s, :), ...
    srf.values(s), srf.cases(s), mat2str(srf.sampleColumns{s}), mat2str(srf.sampleWeights{s}, 12));
end
printMatrix('unscaled x-direction rows D_x', full(srf.d2x));
printMatrix('unscaled y-direction rows D_y', full(srf.d2y));
fprintf('row counts [x y] = %s (formula %s)\n', mat2str(srf.rowCounts), mat2str(srf.rowCountFormula));
fprintf('row factors = %s, range factors = %s, multipliers = %s\n', ...
  mat2str(srf.rowFactors, 12), mat2str(srf.rangeFactors), mat2str(srf.multipliers, 12));
fprintf('combined-count row factor sqrt(%d/%d) = %.12g\n', size(srf.samples, 1), ...
  sum(srf.rowCounts), srf.combinedRowFactor);
printVector('solution vector z', srf.solution);
printMatrix('ndgrid table Z = reshape(z,[%d %d])', srf.table, srf.gridSize(1), srf.gridSize(2));
printVector('fitted values at samples', srf.fittedAtSamples);
fprintf('fidelity SSE = %.12g, regularization SSE = %.12g, rank = %d of %d\n', ...
  srf.fidelitySSE, srf.regularizationSSE, srf.rank, numel(srf.solution));
fprintf('independent reference difference = %.3g, normal-equation difference = %.3g\n', ...
  srf.referenceDifference, srf.normalDifference);

fprintf('\n=== package cross-check ===\n%s\n', report.packageCheck.status);
end

function printVector(name, v)
fprintf('%s: [%s]\n', name, strjoin(compose('%.10g', full(v(:))'), ', '));
end

function printMatrix(name, M, varargin)
fprintf([name ':\n'], varargin{:});
for i = 1:size(M, 1)
  fprintf('  %s\n', strjoin(compose('%10.6g', M(i, :)), ' '));
end
end
