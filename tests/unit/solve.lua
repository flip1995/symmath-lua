#!/usr/bin/env luajit
local env = setmetatable({}, {__index=_G})
if setfenv then setfenv(1, env) else _ENV = env end
require 'symmath.tests.unit.unit'(env, 'solve')

env.x = var'x'

--[[ 
I'm having trouble deciding which to use.
only return a single value if it is duplicated? 
or is multiplicity important? 
what does the eigenvalue solver think of this?
NOTICE for now I will return without multiplicity
this is for maximum compatability: (x^40):eq(0):solve(x) would be impractical to return 40x of x:eq(0), and sin(x):eq(0):solve(x) would be impossible
for now I will instead have eigen() use the nullspace dim to determine multiplicity, so no checks
however, if you want to add checks back in, and also add support for x^40 or sin(x), how about letting solve() return a 'mult' field instead of doing this separately in symmath/multiplicity.lua?
hmm, but if we don't let solve() return multiplicity, then how can eigen() determine a defective system?
and what about (x^expr):eq(0):solve(x), which would be x:eq(0) with multiplicity expr?
--]]

local solveReturnsMultiplicity = [=[
print((x^2):eq(0):solve(x))
asserteq(#{(x^2):eq(0):solve(x)}, 2)
asserteq((x^2):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x^2):eq(0):solve(x)), x:eq(0))

-- same with 3 ...
print((x^3):eq(0):solve(x))
asserteq(#{(x^3):eq(0):solve(x)}, 3)
asserteq((x^3):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x^3):eq(0):solve(x)), x:eq(0))
asserteq(select(3, (x^3):eq(0):solve(x)), x:eq(0))

-- same with 4 ...
print((x^4):eq(0):solve(x))
asserteq(#{(x^4):eq(0):solve(x)}, 4)
asserteq((x^4):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x^4):eq(0):solve(x)), x:eq(0))
asserteq(select(3, (x^4):eq(0):solve(x)), x:eq(0))
asserteq(select(4, (x^4):eq(0):solve(x)), x:eq(0))

-- distinguish between x*(x^2 + 2x + 1) and (x^3 + 2x^2 + x) , because the solver handles one but not the other
printbr( (x * (x^2 + 2*x + 1)):eq(0):solve(x)  )
asserteq(#{(x * (x^2 + 2*x + 1)):eq(0):solve(x)}, 3)
asserteq((x * (x^2 + 2*x + 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))
asserteq(select(3, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))

printbr( (x^3 + 2*x^2 + x):eq(0):solve(x) )
asserteq(#{(x^3 + 2*x^2 + x):eq(0):solve(x)}, 3)
asserteq((x * (x^2 + 2*x + 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))
asserteq(select(3, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))

-- same with x^3 + x^2 - x
printbr( (x * (x^2 + x - 1)):eq(0):solve(x)  )
asserteq(#{(x * (x^2 + x - 1)):eq(0):solve(x)}, 3)
asserteq((x * (x^2 + x - 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + x - 1)):eq(0):solve(x)), x:eq( -(1 - sqrt(5))/2 ))
asserteq(select(3, (x * (x^2 + x - 1)):eq(0):solve(x)), x:eq( -(1 + sqrt(5))/2 ))

printbr( (x^3 + x^2 - x):eq(0):solve(x) )
asserteq(#{(x^3 + x^2 - x):eq(0):solve(x)}, 3)
asserteq((x * (x^2 + x - 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + x - 1)):eq(0):solve(x)), x:eq( -(1 - sqrt(5))/2 ))
asserteq(select(3, (x * (x^2 + x - 1)):eq(0):solve(x)), x:eq( -(1 + sqrt(5))/2 ))



]=]

local solveDoesntReturnMultiplicity = [=[
print((x^2):eq(0):solve(x))
asserteq(#{(x^2):eq(0):solve(x)}, 1)
asserteq((x^2):eq(0):solve(x), x:eq(0))

-- same with 3 ...
print((x^3):eq(0):solve(x))
asserteq(#{(x^3):eq(0):solve(x)}, 1)
asserteq((x^3):eq(0):solve(x), x:eq(0))

-- same with 4 ...
print((x^4):eq(0):solve(x))
asserteq(#{(x^4):eq(0):solve(x)}, 1)
asserteq((x^4):eq(0):solve(x), x:eq(0))

-- distinguish between x*(x^2 + 2x + 1) and (x^3 + 2x^2 + x) , because the solver handles one but not the other
printbr( (x * (x^2 + 2*x + 1)):eq(0):solve(x)  )
asserteq(#{(x * (x^2 + 2*x + 1)):eq(0):solve(x)}, 2)
asserteq((x * (x^2 + 2*x + 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))
printbr( (x^3 + 2*x^2 + x):eq(0):solve(x) )
asserteq(#{(x^3 + 2*x^2 + x):eq(0):solve(x)}, 2)
asserteq((x * (x^2 + 2*x + 1)):eq(0):solve(x), x:eq(0))
asserteq(select(2, (x * (x^2 + 2*x + 1)):eq(0):solve(x)), x:eq(-1))
]=]



for _,line in ipairs(string.split(string.trim([=[

asserteq(#{x:eq(0):solve(x)}, 1)
asserteq(x:eq(0):solve(x), x:eq(0))

asserteq(#{x:eq(1):solve(x)}, 1)
asserteq(x:eq(1):solve(x), x:eq(1))

asserteq(#{(x+1):eq(0):solve(x)}, 1)
asserteq((x+1):eq(0):solve(x), x:eq(-1))

asserteq(#{(x^2):eq(1):solve(x)}, 2)
asserteq((x^2):eq(1):solve(x), x:eq(1))
asserteq(select(2, (x^2):eq(1):solve(x)), x:eq(-1))

asserteq(#{(x^2):eq(-1):solve(x)}, 2)
asserteq((x^2):eq(-1):solve(x), x:eq(i))
asserteq(select(2, (x^2):eq(-1):solve(x)), x:eq(-i))

]=]
.. solveReturnsMultiplicity
--.. solveDoesntReturnMultiplicity 
), '\n')) do
	env.exec(line)
end
