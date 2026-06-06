# montecarlopiaa.jl
# Monte Carlo Pi animation: increasing sample sizes in quarter-unit-disk test
# Produces: montecarlopiaa.gif

using Random
using Plots
gr()

n_seq = [100, 400, 1600, 6400, 10000]
max_n = maximum(n_seq)

Random.seed!(12345)
xs = rand(max_n)
ys = rand(max_n)
inside = xs .^ 2 .+ ys .^ 2 .<= 1.0

theta = range(0, pi / 2, length=400)
arcx = cos.(theta)
arcy = sin.(theta)

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 630), xlims=(0.0, 1.0), ylims=(0.0, 1.0),
         xlabel="", ylabel="", title="Monte Carlo Estimation of pi",
         legend=false, grid=false, framestyle=:box,
         background_color=:white, aspect_ratio=:equal)

    plot!(arcx, arcy; color=:black, lw=2)
    plot!([0.0, 1.0], [0.0, 0.0]; color=:black, lw=1)
    plot!([0.0, 0.0], [0.0, 1.0]; color=:black, lw=1)
    plot!([1.0, 1.0], [0.0, 1.0]; color=:black, lw=1)
    plot!([0.0, 1.0], [1.0, 1.0]; color=:black, lw=1)

    if n > 0
        idx = 1:n
        inside_idx = idx[inside[idx]]
        outside_idx = idx[.!inside[idx]]

        scatter!(xs[inside_idx], ys[inside_idx]; color=:forestgreen, ms=2.1, markerstrokewidth=0.0)
        scatter!(xs[outside_idx], ys[outside_idx]; color=:darkorange, ms=2.1, markerstrokewidth=0.0)

        m = length(inside_idx)
        pi_hat = 4 * m / n
        err = abs(pi - pi_hat)

        annotate!(0.62, 0.95, text("n = $n", :black, 10))
        annotate!(0.62, 0.90, text("inside m = $m", :black, 10))
        annotate!(0.62, 0.85, text("outside k = $(n - m)", :black, 10))
        annotate!(0.62, 0.80, text("pi_hat = $(round(pi_hat; digits=6))", :black, 10))
        annotate!(0.62, 0.75, text("|pi - pi_hat| = $(round(err; digits=6))", :black, 10))
        annotate!(0.62, 0.70, text("1/sqrt(n) = $(round(1 / sqrt(n); digits=6))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "montecarlopiaa.gif"); fps=2)
println("Saved: montecarlopiaa.gif")
