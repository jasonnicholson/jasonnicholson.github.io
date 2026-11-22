using Printf
f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))
x0 = 1.0
hs = [0.6, 0.4, 0.25, 0.15, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.001]
for h in hs
    xl = x0-h; xr = x0+h
    skip = xl < 0.0 || xr > pi
    msec = (f(xr)-f(xl))/(2h); mtan = fp(x0)
    # offset between drawn line (through (x0,f(x0))) and true secant line (through stencil points) at x0
    off = (f(xl)+f(xr))/2 - f(x0)
    @printf("h=%-6g skip=%s msec=%.10f title=%s mtan=%.10f title=%s err=%.3e  secant-line offset at x0=%.5f\n",
        h, skip, msec, string(round(msec;digits=6)), mtan, string(round(mtan;digits=6)), msec-mtan, off)
end
