from mpmath import mp, mpf
mp.dps=50
g=lambda t:-t*t/4-t/2+4
t=mpf('1.5'); orb=[t]
for i in range(400): t=g(t); orb.append(t)
print("n=0..20:",[float(v) for v in orb[:21]])
print("last 8:",[float(v) for v in orb[-8:]])
print("max|x_n-2| over all n:",float(max(abs(v-2) for v in orb)), "min x",float(min(orb)),"max x",float(max(orb)))
c=orb[-4:]; d=1
for v in c: d*= (-v/2-mpf(1)/2)
print("4-cycle multiplier:",float(d))
# conjugacy constant c for z^2+c
a,b,dd=mpf(-1)/4,mpf(-1)/2,mpf(4)
print("conjugate c =",float(a*dd+b/2-b*b/4))
