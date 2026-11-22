# Same partial sums as legendrepolybb.jl but with exact coefficients c_n=(2n+1)(-1)^(n/2) j_n(pi/2), and with trapezoid npts variations
using SpecialFunctions, Printf
include_string(Main, join(readlines("/home/jason/workspaces/jasonnicholson.github.io/pages/numerical-methods/legendre-polynomials/legendrepolybb.jl")[10:36], "\n"))
f(x) = cos(π * x / 2)
x = range(-1.0, 1.0, length=500); fx = f.(x)
cex = [isodd(n) ? 0.0 : (2n+1)*(-1)^(n÷2)*sphericalbesselj(n, π/2) for n in 0:8]
for npts in (1000, 10000, 100000)
  c = [legendre_coeff(f, n; npts=npts) for n in 0:8]
  @printf("npts=%d  c_8=%.6e  (exact %.6e)\n", npts, c[9], cex[9])
end
for n in 0:8
  S = zeros(500); for k in 0:n; S .+= cex[k+1] .* legendre(k, x); end
  @printf("exact-coeff S_%d max err = %.3g\n", n, maximum(abs.(S .- fx)))
end
# Julia legendre vs explicit polynomials on fine grid
xx = collect(range(-1,1,length=2001))
P = [x->1.0, x->x, x->(3x^2-1)/2, x->(5x^3-3x)/2, x->(35x^4-30x^2+3)/8, x->(63x^5-70x^3+15x)/8]
for n in 0:5; @printf("max |legendre(%d) - explicit| = %.2e\n", n, maximum(abs.(legendre(n,xx) .- P[n+1].(xx)))); end
