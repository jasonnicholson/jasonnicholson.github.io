# laurent_animations_all.jl
# Laurent-series animations: when a Laurent series reduces to a Taylor series, and when
# its negative powers follow vertical and horizontal asymptotes that a polynomial cannot.
# Each frame draws f, a partial sum of the Laurent series for the stated region and, in
# the asymptote cases, a Taylor polynomial with the same number of terms about a regular
# point. Output GIFs are saved next to this script via @__DIR__.

using Plots
using Printf

gr()

# --- Truncated Taylor-series arithmetic (coefficients of t^0 ... t^n) ---

series_mul(a, b) = [sum(a[j + 1] * b[k - j + 1] for j in 0:k) for k in 0:(length(a) - 1)]

# sin(c + t)
taylor_sin(c, n) = [sin(c + k * pi / 2) / factorial(big(k)) for k in 0:n] .|> Float64

# (c + t)^(-p)
taylor_inv_pow(c, p, n) =
    [Float64((-1)^k * binomial(big(p + k - 1), big(k)) * big(c)^(-(p + k))) for k in 0:n]

# exp(h(t)), from k g_k = sum_{j=1}^{k} j h_j g_{k-j}
function taylor_exp_of(h)
    g = zeros(length(h))
    g[1] = exp(h[1])
    for k in 1:(length(h) - 1)
        g[k + 1] = sum(j * h[j + 1] * g[k - j + 1] for j in 1:k) / k
    end
    return g
end

# 4/((x - 1)(x + 3)) = 1/(x - 1) - 1/(x + 3), the two-pole function of cases 05-07,
# about a regular point r
two_pole_taylor(r, n) = taylor_inv_pow(r - 1, 1, n) .- taylor_inv_pow(r + 3, 1, n)

# (x^2+1)/(x^2-1) = 1 + 1/(x-1) - 1/(x+1) about x = 3
function case04_taylor(n)
    a = taylor_inv_pow(2.0, 1, n) .- taylor_inv_pow(4.0, 1, n)
    a[1] += 1.0
    return a
end

# --- Case table ---

struct LaurentCase
    id::String
    title::String
    f::Function
    xlims::Tuple{Float64, Float64}
    ylims::Tuple{Float64, Float64}
    regions::Vector{Tuple{Float64, Float64}}  # where the series converges, on the real line
    poles::Vector{Float64}                    # f is broken here
    vasym::Vector{Float64}
    hasym::Vector{Float64}
    coef::Function                            # k -> a_k, the coefficient of x^k
    frames::Vector{Vector{Int}}               # powers included in each frame
    reduces_to_taylor::Bool
    ref::Union{Nothing, Float64}              # regular point of the polynomial comparison
    ref_coefs::Union{Nothing, Function}       # degree -> Taylor coefficients about ref
end

sinc_f(x) = x == 0 ? 1.0 : sin(x) / x
two_pole(x) = 4 / ((x - 1) * (x + 3))
exp_inv(x) = x == 0 ? NaN : exp(1 / x)

const CASES = LaurentCase[
    LaurentCase("01", "sin(x)/x about 0: every negative power vanishes", sinc_f,
        (-14.0, 14.0), (-1.0, 1.6), [(-14.0, 14.0)], Float64[], Float64[], [0.0],
        k -> (k >= 0 && iseven(k)) ? (-1.0)^(k / 2) / Float64(factorial(big(k + 1))) : 0.0,
        [collect(0:2:(2m)) for m in 0:13], true, nothing, nothing),

    LaurentCase("02", "1/(1+x^2) about 0: Taylor series, |x| < 1", x -> 1 / (1 + x^2),
        (-2.0, 2.0), (-0.6, 1.6), [(-1.0, 1.0)], Float64[], Float64[], [0.0],
        k -> (k >= 0 && iseven(k)) ? (-1.0)^(k / 2) : 0.0,
        [collect(0:2:(2m)) for m in 0:11], true, nothing, nothing),

    LaurentCase("03", "sin(x)/x^3 about 0: pole at 0, region 0 < |x|", x -> x == 0 ? NaN : sin(x) / x^3,
        (-6.0, 6.0), (-1.0, 5.0), [(-6.0, 0.0), (0.0, 6.0)], [0.0], [0.0], [0.0],
        k -> (k >= -2 && iseven(k)) ? (-1.0)^((k + 2) / 2) / Float64(factorial(big(k + 3))) : 0.0,
        [collect(-2:2:(2m - 2)) for m in 0:9], false, 1.0,
        d -> series_mul(taylor_sin(1.0, d), taylor_inv_pow(1.0, 3, d))),

    LaurentCase("04", "(x^2+1)/(x^2-1) in powers of 1/x, region |x| > 1",
        x -> abs(x) == 1 ? NaN : (x^2 + 1) / (x^2 - 1),
        (-10.0, 10.0), (-3.0, 5.0), [(-10.0, -1.0), (1.0, 10.0)], [-1.0, 1.0], [-1.0, 1.0], [1.0],
        k -> k == 0 ? 1.0 : (k < 0 && iseven(k)) ? 2.0 : 0.0,
        [collect(-2m:2:0) for m in 0:9], false, 3.0,
        case04_taylor),

    LaurentCase("05", "4/((x-1)(x+3)), disk |x| < 1: Taylor series", two_pole,
        (-7.0, 7.0), (-4.0, 4.0), [(-1.0, 1.0)], [-3.0, 1.0], [-3.0, 1.0], [0.0],
        k -> k >= 0 ? -1.0 - (-1.0)^k / 3.0^(k + 1) : 0.0,
        [collect(0:n) for n in 0:13], true, nothing, nothing),

    LaurentCase("06", "4/((x-1)(x+3)), annulus 1 < |x| < 3", two_pole,
        (-7.0, 7.0), (-4.0, 4.0), [(-3.0, -1.0), (1.0, 3.0)], [-3.0, 1.0], [-3.0, 1.0], [0.0],
        k -> k >= 0 ? -(-1.0)^k / 3.0^(k + 1) : 1.0,
        [collect(-n:n) for n in 1:12], false, 2.0,
        d -> two_pole_taylor(2.0, d)),

    LaurentCase("07", "4/((x-1)(x+3)), exterior |x| > 3", two_pole,
        (-12.0, 12.0), (-4.0, 4.0), [(-12.0, -3.0), (3.0, 12.0)], [-3.0, 1.0], [-3.0, 1.0], [0.0],
        k -> k <= -2 ? 1.0 - (-3.0)^(-k - 1) : 0.0,
        [collect(-n:-2) for n in 2:13], false, 5.0,
        d -> two_pole_taylor(5.0, d)),

    LaurentCase("08", "exp(1/x) about 0: infinitely many negative powers", exp_inv,
        (-4.0, 6.0), (-2.0, 8.0), [(-4.0, 0.0), (0.0, 6.0)], [0.0], [0.0], [1.0],
        k -> k <= 0 ? 1 / Float64(factorial(big(-k))) : 0.0,
        [collect(-n:0) for n in 0:11], false, 1.0,
        d -> taylor_exp_of([(-1.0)^k for k in 0:d])),
]

# --- Evaluation ---

finite_or_nan(y) = isfinite(y) ? y : NaN

# Partial sum of a_k x^k over the given powers. NaN at x = 0 when a negative power is present.
partial_sum(case, powers, x) = finite_or_nan(sum(case.coef(k) * x^k for k in powers))

function taylor_eval(a, t)
    v = a[end]
    for i in (length(a) - 1):-1:1
        v = v * t + a[i]
    end
    return v
end

function powers_label(powers)
    lo, hi = extrema(powers)
    lo == hi && return "power $(lo)"
    step_two = length(powers) > 1 && all(diff(powers) .== 2)
    return "powers $(lo) to $(hi)" * (step_two ? ", even" : "")
end

terms_label(n) = n == 1 ? "1 term" : "$(n) terms"

# --- Rendering ---

function render_case(case::LaurentCase)
    grid = collect(range(case.xlims[1], case.xlims[2], length=2401))
    xs = sort(unique(vcat(grid, case.poles, [0.0])))
    yf = [x in case.poles ? NaN : finite_or_nan(case.f(x)) for x in xs]
    anim = Animation()

    for powers in case.frames
        p = plot(size=(840, 600), xlims=case.xlims, ylims=case.ylims,
                 xlabel="x", ylabel="y", title="Case $(case.id): $(case.title)",
                 titlefontsize=11, legend=:outerbottom, legendcolumns=2,
                 legendfontsize=8, grid=true, framestyle=:box, background_color=:white)

        for (i, (a, b)) in enumerate(case.regions)
            vspan!(p, [a, b]; color=:seagreen, alpha=0.13, lw=0,
                   label=i == 1 ? "region of convergence (real x)" : "")
        end

        asym_label = "asymptote of f"
        for v in case.vasym
            vline!(p, [v]; color=:black, ls=:dash, lw=1.1, label=asym_label)
            asym_label = ""
        end
        for h in case.hasym
            hline!(p, [h]; color=:black, ls=:dash, lw=1.1, label=asym_label)
            asym_label = ""
        end

        plot!(p, xs, yf; color=:magenta, lw=2.6, label="y = f(x)")

        nterms = count(k -> case.coef(k) != 0, powers)
        name = case.reduces_to_taylor ? "Laurent = Taylor" : "Laurent"
        ysum = [partial_sum(case, powers, x) for x in xs]
        plot!(p, xs, ysum; color=:steelblue, lw=2.1,
              label="$(name), $(powers_label(powers)) ($(terms_label(nterms)))")

        if case.ref !== nothing
            a = case.ref_coefs(nterms - 1)
            ypoly = [taylor_eval(a, x - case.ref) for x in xs]
            plot!(p, xs, ypoly; color=:darkorange, lw=1.8,
                  label=@sprintf("Taylor about x = %g, degree %d (%s)",
                                 case.ref, nterms - 1, terms_label(nterms)))
        end

        frame(anim, p)
    end

    out_name = "laurent$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=2)
    println("Saved: " * out_name)
end

if abspath(PROGRAM_FILE) == @__FILE__
    for case in CASES
        render_case(case)
    end
    println("Generated $(length(CASES)) GIFs.")
end
