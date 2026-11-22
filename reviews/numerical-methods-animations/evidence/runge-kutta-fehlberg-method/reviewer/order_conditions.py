# Check the Butcher tableau transcribed from the script (lines 24-32 of rungekuttafehlbergaa.jl)
# against the rooted-tree order conditions, generated automatically (no memorised formulas).
import sympy as sp
from sympy import Rational as R
c = [0, R(1,4), R(3,8), R(12,13), 1, R(1,2)]
A = [[],
     [R(1,4)],
     [R(3,32), R(9,32)],
     [R(1932,2197), R(-7200,2197), R(7296,2197)],
     [R(439,216), -8, R(3680,513), R(-845,4104)],
     [R(-8,27), 2, R(-3544,2565), R(1859,4104), R(-11,40)]]
b4 = [R(25,216), 0, R(1408,2565), R(2197,4104), R(-1,5), 0]
b5 = [R(16,135), 0, R(6656,12825), R(28561,56430), R(-9,50), R(2,55)]
s=6
Am = sp.zeros(s,s)
for i in range(s):
    for j,a in enumerate(A[i]): Am[i,j]=a
print("row sums == c:", [sp.simplify(sum(A[i])-c[i])==0 for i in range(s)])
# rooted trees as nested tuples; generate all trees up to order 6
from itertools import combinations_with_replacement
from functools import lru_cache
def trees(n):
    # trees of order n: root with children multiset of trees with total order n-1
    if n==1: return [()]
    res=set()
    def parts(m, maxk):
        # multisets of trees summing to m
        if m==0: yield (); return
        for k in range(1, m+1):
            for t in trees(k):
                for rest in parts(m-k, None):
                    yield tuple(sorted((t,)+rest))
    for p in parts(n-1,None): res.add(p)
    return sorted(res)
import math
def order(t): return 1+sum(order(ch) for ch in t)
def gamma(t): return order(t)*math.prod(gamma(ch) for ch in t)
def Phi_vec(t):
    # stage vector: for tree t with children ch, Phi_i = prod_ch (A Phi(ch))_i
    v = sp.ones(s,1)
    for ch in t:
        w = Am*Phi_vec(ch)
        v = v.multiply_elementwise(w)
    return v
for name,b in (("b4",b4),("b5",b5)):
    bv = sp.Matrix(b)
    for p in range(1,7):
        ts = trees(p)
        res = [sp.nsimplify((bv.T*Phi_vec(t))[0] - R(1,gamma(t))) for t in ts]
        ok = all(r==0 for r in res)
        print(name, "order", p, "trees", len(ts), "all satisfied" if ok else "VIOLATED", "" if ok else [str(r) for r in res])
print("sum(b5-b4) =", sum(b5)-sum(b4))
