# local error estimate |y5-y4| for a single step from (0,y0) vs h, using the script's stage formulas (copied from rungekuttafehlbergaa.jl lines 24-34)
using Printf
function est(f,t,y,h)
        k1 = h * f(t, y)
        k2 = h * f(t + h / 4, y + k1 / 4)
        k3 = h * f(t + 3h / 8, y + 3k1 / 32 + 9k2 / 32)
        k4 = h * f(t + 12h / 13, y + 1932k1 / 2197 - 7200k2 / 2197 + 7296k3 / 2197)
        k5 = h * f(t + h, y + 439k1 / 216 - 8k2 + 3680k3 / 513 - 845k4 / 4104)
        k6 = h * f(t + h / 2, y - 8k1 / 27 + 2k2 - 3544k3 / 2565 + 1859k4 / 4104 - 11k5 / 40)
        y4 = y + 25k1 / 216 + 1408k3 / 2565 + 2197k4 / 4104 - k5 / 5
        y5 = y + 16k1 / 135 + 6656k3 / 12825 + 28561k4 / 56430 - 9k5 / 50 + 2k6 / 55
        abs(y5-y4)
end
for (nm,f,t,y) in (("case1 at t=0",(t,y)->1+y^2,0.0,0.5),("case2 at t=1",(t,y)->1-t*cbrt(y),1.0,1.4421696))
  prev=NaN
  for h in (0.2,0.1,0.05,0.025,0.0125)
    e=est(f,t,big(y),big(h)); e=Float64(e)
    @printf("%s h=%.4f est=%.3e  ratio=%s\n",nm,h,e,isnan(prev) ? "-" : @sprintf("%.1f (p=%.2f)",prev/e,log2(prev/e))); prev=e
  end
end
