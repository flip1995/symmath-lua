#!/usr/bin/env luajit
local env = setmetatable({}, {__index=_G})
if setfenv then setfenv(1, env) else _ENV = env end
require 'symmath.tests.unit.unit'(env, 'tests/unit/sqrt')

-- goes much slower ... I think?
symmath.simplify.debugLoops = 'rules'

timer(nil, function()

env.a = symmath.Variable('a')
env.b = symmath.Variable('b')
env.f = symmath.Variable('f')
env.g = symmath.Variable('g')
env.s = symmath.Variable('s')
env.t = symmath.Variable('t')
env.v = symmath.Variable('v')
env.x = symmath.Variable('x')
env.y = symmath.Variable('y')

-- constant simplificaiton
for _,line in ipairs(string.split(string.trim([=[

print(sqrt(-1)())
simplifyAssertEq(sqrt(-1), i)

-- make sure, when distributing sqrt()'s, that the negative signs on the inside are simplified in advance
simplifyAssertEq( ((((-x*a - x*b)))^frac(1,2)), i * (sqrt(x) * sqrt(a+b)) )
simplifyAssertEq( (-(((-x*a - x*b)))^frac(1,2)), -i * (sqrt(x) * sqrt(a+b)) )

simplifyAssertEq( ((((-x*a - x*b)*-1))^frac(1,2)), (sqrt(x) * sqrt(a+b)) )
simplifyAssertEq( (-(((-x*a - x*b)*-1))^frac(1,2)), -(sqrt(x) * sqrt(a+b)) )
-- If sqrt, -1, and mul factor run out of order then -sqrt(-x) and sqrt(-x) will end up equal.  And that isn't good for things like solve() on quadratics.
simplifyAssertEq( ((((-x*a - x*b)/-1)/y)^frac(1,2)), (sqrt(x) * sqrt(a+b)) / sqrt(y) )
simplifyAssertEq( (-(((-x*a - x*b)/-1)/y)^frac(1,2)), -(sqrt(x) * sqrt(a+b)) / sqrt(y) )


-- simplifying expressions with sqrts in them
simplifyAssertEq( 2^frac(-1,2) + 2^frac(1,2), frac(3, sqrt(2)) )
simplifyAssertEq( 2*2^frac(-1,2) + 2^frac(1,2), 2 * sqrt(2) )
simplifyAssertEq( 4*2^frac(-1,2) + 2^frac(1,2), 3 * sqrt(2) )

simplifyAssertEq( (1 + sqrt(3))^2 + (1 - sqrt(3))^2, 8 )

simplifyAssertEq( (frac(1,2)*sqrt(3))*(frac(sqrt(2),sqrt(3))) + (-frac(1,2))*(frac(1,3)*-sqrt(2)) , 2 * sqrt(2) / 3)

simplifyAssertEq( -frac(1,3)*-frac(1+sqrt(3),3) + -frac(2,3)*frac(1,3) + -frac(2,3) * frac(1-sqrt(3),3), -frac(1 - sqrt(3), 3))

simplifyAssertEq( -sqrt(3)*sqrt(2)/(2*sqrt(3)) + sqrt(2)/6, -sqrt(2)/3 )

simplifyAssertEq( 1 + 5*sqrt(5) + sqrt(5), 1 + 6*sqrt(5) )
simplifyAssertEq( 1 + 25*sqrt(5) + sqrt(5), 1 + 26*sqrt(5) )	-- powers of the sqrt sometimes get caught simplifying as merging the exponents, and don't add.
simplifyAssertEq( 1 + 5*sqrt(5) - 5*sqrt(5), 1 )

simplifyAssertEq( -(1 + sqrt(5))/(2*sqrt(3)) , frac(1,2)*(-frac(1,sqrt(3)))*(1 + sqrt(5)) ) 

simplifyAssertEq( (-(1-sqrt(3))/3)*(frac(1,3)) + ((2+sqrt(3))/6)*(-(1-sqrt(3))/3) + (-(1+2*sqrt(3))/6)*(-(1+sqrt(3))/3) , (1 + sqrt(3))/3 )

simplifyAssertEq( (-sqrt(sqrt(5) + 1) * (1 - sqrt(5))) / (4 * sqrt(sqrt(5) - 1)) , frac(1,2))

simplifyAssertNe( 6 + 6 * sqrt(3), 12)	-- ok this is hard to explain ..

simplifyAssertEq( (sqrt(5) + 1) * (sqrt(5) - 1), 4)
simplifyAssertEq( sqrt((sqrt(5) + 1) * (sqrt(5) - 1)), 2)

simplifyAssertEq( (1 + 2 / sqrt(3)) / (2 * sqrt(3)), (2 + sqrt(3)) / 6 )

simplifyAssertEq( (frac(1,3)*(-(1-sqrt(3)))) * (frac(1,3)*(-(1-sqrt(3)))) + (frac(1,6)*(2+sqrt(3))) * (frac(1,3)*(1+sqrt(3))) + (frac(1,6)*-(1+2*sqrt(3))) * frac(1,3), (4 - sqrt(3))/6 )

simplifyAssertEq( 1/sqrt(6) + 1/sqrt(6), 2/sqrt(6) )

simplifyAssertEq( (32 * sqrt(3) + 32 * sqrt(15)) / 384, (sqrt(3) + sqrt(15)) / 12 )

simplifyAssertEq( sqrt(5)/(2*sqrt(3)), sqrt(15)/6 )

simplifyAssertEq( -1/(2*sqrt(3)), -sqrt(frac(1,12)) )
simplifyAssertNe( -sqrt(frac(1,12)), sqrt(frac(1,12)) )

simplifyAssertEq( (sqrt(2)*sqrt(frac(1,3))) * -frac(1,3) + (-frac(1,2)) * (sqrt(2)/sqrt(3)) + (frac(1,2)*1/sqrt(3)) * (-sqrt(2)/3), -sqrt(2) / sqrt(3) )

simplifyAssertEq( 1 + ( -(7 - 3*sqrt(5)) / (3*(3 - sqrt(5))) )*(1 + frac(1,2)), (1 + sqrt(5))/4 )

simplifyAssertEq( (-(sqrt(5)-1)/2)/sqrt((-(sqrt(5)-1)/2)^2 + 1), -sqrt( (sqrt(5) - 1) / (2 * sqrt(5)) ))

simplifyAssertEq(sqrt(frac(15,16)) * sqrt(frac(2,3)), sqrt(5)/(2*sqrt(2)))

-- these go bad when I don't have mul/Prune/combineMulOfLikePow_mulPowAdd
simplifyAssertEq( ( sqrt(f) * (g + f * sqrt(g)) )() , sqrt(f) * sqrt(g) * (sqrt(g) + f)) 
simplifyAssertEq( ( sqrt(f) * (g + sqrt(g)) )() , sqrt(f) * sqrt(g) * (sqrt(g) + 1)) 

-- these are in simplification loops

-- start with -1 / ( (√√5 √(√5 - 1)) / √2 ) ... what mine gets now vs what mathematica gets
simplifyAssertEq( -1 / ( sqrt(sqrt(5) * (sqrt(5) - 1)) / sqrt(2) ), sqrt((5  + sqrt(5)) / 10))
simplifyAssertEq( -(sqrt( 10 * (sqrt(5) - 1) ) + sqrt(2 * (sqrt(5) - 1))) / (4 * sqrt(sqrt(5))), sqrt((5  + sqrt(5)) / 10))



]=]), '\n')) do
	env.exec(line)
end

end)
