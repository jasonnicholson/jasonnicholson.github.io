# Newton run past the script's 22 iterations, expanded f exactly as in the scripts, Float64
using Printf
for (nm,f,df,x0,p) in (("case1", x->x^3-3x+2, x->3x^2-3, 2.0, 1.0),
                       ("case2", x->(x^2-2)*sin(x^2-2), x->2x*(sin(x^2-2)+(x^2-2)*cos(x^2-2)), 1.0, sqrt(2.0)),
                       ("case3", x->x^6-7x^4+15x^2-9, x->6x^5-28x^3+30x, 1.5, sqrt(3.0)))
    x = x0; best = abs(x-p); kbest = 0
    for k in 1:200
        d = df(x); (d == 0 || !isfinite(d)) && break
        x -= f(x)/d
        e = abs(x-p); if e < best; best = e; kbest = k; end
    end
    @printf("%s: smallest Newton error in 200 its = %.2e at k=%d; final x err = %.2e\n", nm, best, kbest, abs(x-p))
end
@printf("halvings from 1 to 1e-16: %.1f\n", log(1e-16)/log(0.5))
