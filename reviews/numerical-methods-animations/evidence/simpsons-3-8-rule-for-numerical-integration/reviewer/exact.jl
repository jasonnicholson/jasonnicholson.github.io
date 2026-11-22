# degree-of-precision and order check using the script's own simpson38_sum with f redefined
include_string(Main, replace(read("check.jl", String), r"using Printf.*"s => ""))
using Printf
for (k) in 0:5
    @eval f(x) = x^$k
    for n in (3, 6, 9)
        S = simpson38_sum(n); I = (2.0^(k+1))/(k+1)
        @printf("x^%d n=%d S=%.15f exact=%.15f err=%.3e\n", k, n, S, I, S - I)
    end
end
@eval f(x) = exp(x)
I = exp(2.0) - 1
for n in (6, 12, 24, 48, 96)
    e1 = simpson38_sum(n) - I; e2 = simpson38_sum(2n) - I
    @printf("exp: n=%d err=%.3e ratio=%.3f log2=%.3f\n", n, e1, e1/e2, log2(e1/e2))
end
