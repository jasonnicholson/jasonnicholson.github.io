# curvefitaa.jl
# Nonlinear Curve Fitting animation: data linearization for the exponential fit
# y = c e^(a x) of Mathews' Example 1, data (0,1.5), (1,2.5), (2,3.5), (3,5.0), (4,7.5).
# The change of variables X = x, Y = ln y turns the curve into the line Y = A X + B
# with a = A, c = e^B. Every frame draws a line through the centroid (Xbar, Ybar) of
# the transformed points, so that the second normal equation, B = Ybar - A Xbar, holds,
# and sweeps its slope A from 0 up to 0.8 and back down to the least-squares slope,
# where the first normal equation holds too.
#   top left:  the XY-plane, the transformed points, the line and its deviations;
#   top right: the xy-plane, the data and the curve c e^(a x) the line maps back to,
#              with its residuals f(x_k) - y_k;
#   bottom:    S(A), the sum of the squared deviations in the XY-plane, a parabola
#              whose minimum is the least-squares line.
# Mathews' two plots of this example (the line in the XY-plane and the curve in the
# xy-plane) are lost, so the windows are chosen here.
# Produces: curvefitaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmtA(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))      # the exact sweep slopes
fmt(x)  = x == 0 ? "0" : um(@sprintf("%#.4g", x))     # computed values, 4 s.f.
fmt6(x) = x == 0 ? "0" : um(@sprintf("%#.6g", x))     # the fit, 6 s.f. (as on the page)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Parameters (Mathews' Example 1) ---
gif_name = "curvefitaa.gif"
xd = [0.0, 1.0, 2.0, 3.0, 4.0]
yd = [1.5, 2.5, 3.5, 5.0, 7.5]
Xd = xd                      # X = x
Yd = log.(yd)                # Y = ln y
model(x, c, a) = c * exp(a * x)

XYlims = (-0.3, 4.3, -0.5, 3.0)     # (Xmin, Xmax, Ymin, Ymax)
xylims = (-0.3, 4.3, 0.0, 10.0)
Asweep = vcat(0.0:0.05:0.8, 0.75:-0.05:0.45)   # then the least-squares slope
n_hold = 4                                      # frames held on the fit
title_str = "Data linearization, Mathews' Example 1:  y = c eᵃˣ  →  ln y = a x + ln c,  " *
            "X = x,  Y = ln y,  Y = AX + B"

# --- Least-squares line by the normal equations (formula (2) on the page) ---
n = length(Xd)
Sx, Sy, Sxx, Sxy = sum(Xd), sum(Yd), sum(Xd .^ 2), sum(Xd .* Yd)
Δ = n * Sxx - Sx^2
Astar = (n * Sxy - Sx * Sy) / Δ
Bstar = (Sxx * Sy - Sx * Sxy) / Δ
Xbar, Ybar = Sx / n, Sy / n
@assert abs(Astar - 0.391202) < 5e-7 && abs(exp(Bstar) - 1.57991) < 5e-6   # page values

Bof(A) = Ybar - A * Xbar                    # line through the centroid
S(A) = sum((A .* Xd .+ Bof(A) .- Yd) .^ 2)  # squared deviations in the XY-plane
E(A) = sum((model.(xd, exp(Bof(A)), A) .- yd) .^ 2)   # squared residuals in y
@printf("A* = %.9f  B* = %.9f  c* = %.9f  S(A*) = %.9g  E(A*) = %.9g\n",
        Astar, Bstar, exp(Bstar), S(Astar), E(Astar))
@printf("S(A) range on the sweep: %.6g .. %.6g\n", minimum(S.(Asweep)), maximum(S.(Asweep)))

frames = vcat([(A, false) for A in Asweep], [(Astar, true) for _ in 1:n_hold])

# --- Backdrop ---
Xplot = range(XYlims[1], XYlims[2], length=200)
xplot = range(xylims[1], xylims[2], length=400)
Agrid = range(minimum(Asweep), maximum(Asweep), length=400)
Slims = (0.0, 1.1 * maximum(S.(Agrid)))

function draw_frame(A, isfit)
    B = Bof(A); c = exp(B)
    f1 = isfit ? fmt6 : fmt
    fA = isfit ? fmt6 : fmtA
    col = isfit ? :red : :royalblue
    lbl = isfit ? "least-squares line" : "line through the centroid"

    # XY-plane
    p1 = plot(xlims=XYlims[1:2], ylims=XYlims[3:4], framestyle=:box, grid=true,
              xlabel="X = x", ylabel="Y = ln y", legend=:topleft, legendfontsize=8,
              titlefontsize=10)
    for k in 1:n
        plot!(p1, [Xd[k], Xd[k]], [Yd[k], A * Xd[k] + B]; color=:darkorange, lw=1.5,
              label=k == 1 ? "deviations AXₖ + B − Yₖ" : "")
    end
    plot!(p1, Xplot, ydraw.(A .* Xplot .+ B, Ref(XYlims[3:4])); color=col, lw=2.5, label=lbl)
    scatter!(p1, Xd, Yd; color=:black, ms=5, label="(Xₖ, Yₖ) = (xₖ, ln yₖ)")
    scatter!(p1, [Xbar], [Ybar]; color=:white, markerstrokecolor=:black, ms=6,
             marker=:diamond, label="centroid (X̄, Ȳ)")
    title!(p1, "XY-plane:  Y = AX + B,  A = $(fA(A)),  B = Ȳ − A X̄ = $(f1(B))\n" *
                "S = Σ(AXₖ + B − Yₖ)² = $(f1(S(A)))")

    # xy-plane
    p2 = plot(xlims=xylims[1:2], ylims=xylims[3:4], framestyle=:box, grid=true,
              xlabel="x", ylabel="y", legend=:topleft, legendfontsize=8, titlefontsize=10)
    yfit = model.(xd, c, A)
    for k in 1:n
        plot!(p2, [xd[k], xd[k]], [yd[k], ydraw(yfit[k], xylims[3:4])]; color=:darkorange,
              lw=1.5, label=k == 1 ? "residuals f(xₖ) − yₖ" : "")
    end
    plot!(p2, xplot, ydraw.(model.(xplot, c, A), Ref(xylims[3:4])); color=col, lw=2.5,
          label="f(x) = c eᵃˣ,  a = A,  c = eᴮ")
    scatter!(p2, xd, yd; color=:black, ms=5, label="data (xₖ, yₖ)")
    title!(p2, "xy-plane:  f(x) = $(f1(c)) e^($(fA(A)) x)\n" *
                "E = Σ(f(xₖ) − yₖ)² = $(f1(E(A)))")

    # S(A)
    p3 = plot(xlims=extrema(Agrid), ylims=Slims, framestyle=:box, grid=true,
              xlabel="slope A (line through the centroid)", ylabel="S(A)",
              legend=:top, legendfontsize=8, titlefontsize=10)
    plot!(p3, Agrid, S.(Agrid); color=:gray40, lw=2, label="S(A) = Σ(AXₖ + B − Yₖ)²")
    vline!(p3, [Astar]; color=:red, ls=:dash, lw=1.5,
           label="minimum: A = $(fmt6(Astar)),  S = $(fmt6(S(Astar)))")
    scatter!(p3, [A], [S(A)]; color=col, ms=7, label="")
    title!(p3, isfit ? "the least-squares line minimises S: both normal equations hold" :
                       "every line through the centroid satisfies the second normal equation")

    l = @layout [a b; c{0.32h}]
    plot(p1, p2, p3; layout=l, size=(1150, 820), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for (A, isfit) in frames
    draw_frame(A, isfit)
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=3)
println("Saved: ", gif_name, " (", length(frames), " frames)")
