# Description claim: Pade stays accurate on larger intervals than the Taylor polynomial of the same total order
import mpmath as mp, json, os
mp.mp.dps = 30
D = os.path.dirname(os.path.abspath(__file__)); EX = json.load(open(os.path.join(D, "exact_coeffs.json")))
def R(a, L, M, z):
    p, q = mp.pade(a, L, M); return mp.polyval(p[::-1], z)/mp.polyval(q[::-1], z)
for cid, f, c, xs in [("01", mp.sqrt, 1, [5, 10.5]), ("07", lambda t: mp.log(1+t), 0, [1.0, 1.5]), ("13", mp.exp, 0, [3.0]), ("16", mp.atan, 0, [1.5, 2.0])]:
    a = [mp.mpf(s) for s in EX[cid]["num"]]
    for x in xs:
        z = mp.mpf(x)-c
        print(cid, "x=", x, " |f-[10/0]|=", mp.nstr(abs(f(x)-mp.polyval(a[::-1], z)), 3), " |f-[5/5]|=", mp.nstr(abs(f(x)-R(a, 5, 5, z)), 3))
