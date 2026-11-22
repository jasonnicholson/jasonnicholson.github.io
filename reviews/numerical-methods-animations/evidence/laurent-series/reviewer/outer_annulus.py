# Laurent coefficients a_k of the pole cases in the annulus just OUTSIDE the nearest pole,
# i.e. the region of the plotted interval the Taylor (disc) series cannot reach.
import mpmath as mp
mp.mp.dps = 30
def coef(f, c, k, r, M=512):
    s = 0
    for j in range(M):
        w = r*mp.expj(2*mp.pi*j/M); s += f(c+w)*w**(-k)
    return s/M
for name, f, c, r, note in [("12 tan, x0=0, annulus pi/2<|z|<3pi/2", mp.tan, 0, 2.5, "poles at ±pi/2"),
                            ("22 gamma, x0=1, annulus 1<|z-1|<2", mp.gamma, 1, 1.5, "pole at 0"),
                            ("23 gamma, x0=2, annulus 2<|z-2|<3", mp.gamma, 2, 2.5, "poles at 0,1? no: pole 0 at dist 2, pole -1 at dist 3")]:
    print(name)
    for k in range(-4, 3):
        v = coef(f, mp.mpf(c), k, r)
        print(f"   a_{k:+d} = {mp.nstr(v.real, 10):>16}   (imag {mp.nstr(abs(v.imag),2)})")
