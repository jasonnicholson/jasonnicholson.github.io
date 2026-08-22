 clc;clear; close all;
% setup polynomial function
coefficients = [1 0 0 1 -1 1];
polynomialFunction = @(z) polyval(coefficients, z);

% setup the derivative of the polynomial function
coefficients_dot = polyder(coefficients);
coefficients_ddot = polyder(coefficients_dot);
polynomialDerivativeFunction = @(z) polyval(coefficients_dot, z);
polynomialSecondDerivativeFunction = @(z) polyval(coefficients_ddot, z);

% roots of the polynomial. roots uses a eigenvalues of a companion matrix approach.
% rootsOfPolynomial = roots(coefficients);

% exact roots
rootsOfPolynomial(1) = -1i;
rootsOfPolynomial(2) =  1i;
rootsOfPolynomial(3) =  (2^(2/3)*(3^(1/3) - 3^(5/6)*1i)*(69^(1/2) + 9)^(1/3))/12 + (2^(2/3)*3^(1/3)*(9 - 69^(1/2))^(1/3))/12 + (2^(2/3)*3^(5/6)*(9 - 69^(1/2))^(1/3)*1i)/12;
rootsOfPolynomial(4) =  (2^(2/3)*(3^(1/3) + 3^(5/6)*1i)*(69^(1/2) + 9)^(1/3))/12 + (2^(2/3)*3^(1/3)*(9 - 69^(1/2))^(1/3))/12 - (2^(2/3)*3^(5/6)*(9 - 69^(1/2))^(1/3)*1i)/12;
rootsOfPolynomial(5) = -(2^(2/3)*3^(1/3)*((69^(1/2) + 9)^(1/3) + (9 - 69^(1/2))^(1/3)))/6;

% Calculate a grid of starting points using the ndgrid format. x (real part)
% follow rows (1st dimension) and y follows the columns (2nd dimension).
% ndgrid is format is transpose of meshgrid format. meshgrid format is used
% for plotting surfaces.
nStartingPointReal = 1200;
nStartingPointImaginary = 1201;
startingPointReal = linspace(-2,2,nStartingPointReal)';
startingPointImaginary = linspace(-2,2+eps(2),nStartingPointImaginary)*1i;
startingPoint = startingPointReal + startingPointImaginary; % using singleton expansion

maxIterations = 100;
functionTolerance = 1e-14;
divideByZeroTolerance = 1000; % 1000*eps(p)

% setup for iteration
isConverged = false(nStartingPointReal, nStartingPointImaginary);
isDivideByZero = false(nStartingPointReal, nStartingPointImaginary);

whileFlag = true;
iteration = 0;
z = startingPoint;

% check if the starting value was already converged.
% polynomial is less then functionTolerance.
p = polynomialFunction(z(~isConverged));
isConverged(~isConverged) = abs(p) < functionTolerance;

% begin iteration
p = polynomialFunction(z(~isConverged));
while whileFlag
    % increment iteration number
    iteration = iteration + 1;
    
    p = polynomialFunction(z(~isConverged));
    
    % Calculate the derivative of the polynomial.
    % Check for divide by 0. If p_dot is close to machine precision
    % of p, then its a divide by 0 error. 
    % Stop all further iteration.
    p_dot = polynomialDerivativeFunction(z(~isConverged));
    isDivideByZeroIteration = abs(p_dot) < divideByZeroTolerance*eps(abs(p));
    isDivideByZero(~isConverged) = isDivideByZeroIteration;
    isConverged(~isConverged) = isDivideByZeroIteration;

    % Calculate step size to take.
    % For g(z) = z - alpha * P(z) / P'(z), the derivative is
    % g'(z) = 1 - alpha * (P'^2 - P*P'') / P'^2.
    % Let q = (P'^2 - P*P'') / P'^2, so g' = 1 - alpha*q.
    % For real q, the fixed-point condition |g'| < 1 is enforced by
    % leaving alpha = 1 alone when the Newton step is already stable.
    % When q > 0 we choose alpha = 2/q to place g' at the boundary,
    % and when q < 0 we choose alpha = 1/q to keep g' near zero.
    alpha = ones(size(p)); % initialize alpha
    p_ddot = polynomialSecondDerivativeFunction(z(~isConverged));
    pq = (p_dot.^2 - p.*p_ddot)./p_dot.^2;
    g_prime = 1 - pq;
    useStandardStep = abs(g_prime) < 1;
    pq_negative = pq < 0;
    alpha(~useStandardStep & pq_negative) = 1./pq(~useStandardStep & pq_negative);
    alpha(~useStandardStep & ~pq_negative) = 2./pq(~useStandardStep & ~pq_negative);

    % calculate Newton iteration on unconverged points.
    z(~isConverged) = z(~isConverged) -alpha(~isDivideByZeroIteration).*p(~isDivideByZeroIteration)./p_dot(~isDivideByZeroIteration);
    
    % check for convergence
    p = polynomialFunction(z(~isConverged));
    isConverged(~isConverged) = abs(p) < functionTolerance;
    
    % set while flag
    % all roots have converged or reached max iterations
    whileFlag = iteration <= maxIterations || all(all(~isConverged));
end

% successful roots
isRoot = isConverged & ~isDivideByZero;

% which root did newton's method converge too?
% calculate the difference between the converged root and the roots of the polynomial
% the smallest distance corresponds to the root index
zDiff = abs(z - reshape(rootsOfPolynomial,1,1,[])); % using singelton expansion
[rootErrors,rootIndex] = min(zDiff,[],3); % minimum along 3rd dimension
rootIndex(~isRoot) = 0;

% create the fractal image
% imagesc uses the meshgrid format where 
% x is the 2nd dimension 
% y is the first dimension
% therefore, transpose rootIndex because its in the ndgrid format
figure;
imagesc(startingPointReal', imag(startingPointImaginary), rootIndex')
c = prism(numel(rootsOfPolynomial)+1);
colormap(c);
xlabel("Real Axis"); ylabel("Imaginary Axis")
ylabel(colorbar('Ticks',1:numel(rootsOfPolynomial)),"Root Index")
hold on;
plot(rootsOfPolynomial,'ko','MarkerSize',10,'LineWidth',3)
title("Newton-Raphson Convergence for z^5+z^2-z+1 with Fixed-Point Step")
