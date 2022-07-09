{
	{code="", comment="TODO do unit tests with the RealInterval / RealSubset operators", duration=1.9999999999951e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="subsets", duration=1.000000000001e-06},
	{code="", comment="TODO don't use \":contains()\" except for element testing, as in sets-of-sets", duration=1.000000000001e-06},
	{code="", comment="instead here use isSubsetOf", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.real:isSubsetOf(set.real) == true)",
		comment="",
		duration=0.000103,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:isSubsetOf(set.real) == true)",
		comment="",
		duration=0.000298,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:isSubsetOf(set.real) == true)",
		comment="",
		duration=2.1e-05,
		simplifyStack={}
	},
	{
		code="assert(set.integer:isSubsetOf(set.real) == true)",
		comment="",
		duration=2.2999999999995e-05,
		simplifyStack={}
	},
	{
		code="assert(set.evenInteger:isSubsetOf(set.real) == true)",
		comment="",
		duration=2.9000000000001e-05,
		simplifyStack={}
	},
	{
		code="assert(set.oddInteger:isSubsetOf(set.real) == true)",
		comment="",
		duration=0.000139,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="assert(set.real:isSubsetOf(set.integer) == nil)",
		comment="",
		duration=1.5999999999995e-05,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:isSubsetOf(set.integer) == nil)",
		comment="",
		duration=1.2999999999999e-05,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:isSubsetOf(set.integer) == nil)",
		comment="",
		duration=8.0999999999998e-05,
		simplifyStack={}
	},
	{
		code="assert(set.integer:isSubsetOf(set.integer) == true)",
		comment="",
		duration=1.3000000000006e-05,
		simplifyStack={}
	},
	{
		code="assert(set.evenInteger:isSubsetOf(set.integer) == true)",
		comment="",
		duration=1.1000000000004e-05,
		simplifyStack={}
	},
	{
		code="assert(set.oddInteger:isSubsetOf(set.integer) == true)",
		comment="",
		duration=1.6000000000002e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.real:isSubsetOf(set.evenInteger) == nil)",
		comment="",
		duration=1.3000000000006e-05,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:isSubsetOf(set.evenInteger) == nil)",
		comment="",
		duration=1.3000000000006e-05,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:isSubsetOf(set.evenInteger) == nil)",
		comment="",
		duration=1.6999999999996e-05,
		simplifyStack={}
	},
	{
		code="assert(set.integer:isSubsetOf(set.evenInteger) == nil)",
		comment="",
		duration=2.0000000000006e-05,
		simplifyStack={}
	},
	{
		code="assert(set.evenInteger:isSubsetOf(set.evenInteger) == true)",
		comment="",
		duration=1.1999999999998e-05,
		simplifyStack={}
	},
	{
		code="assert(set.oddInteger:isSubsetOf(set.evenInteger) == nil)",
		comment="",
		duration=8.6000000000003e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.real:isSubsetOf(set.oddInteger) == nil)",
		comment="",
		duration=1.1999999999998e-05,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:isSubsetOf(set.oddInteger) == nil)",
		comment="",
		duration=1.0999999999997e-05,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:isSubsetOf(set.oddInteger) == nil)",
		comment="",
		duration=1.2999999999999e-05,
		simplifyStack={}
	},
	{
		code="assert(set.integer:isSubsetOf(set.oddInteger) == nil)",
		comment="",
		duration=1.2000000000005e-05,
		simplifyStack={}
	},
	{
		code="assert(set.evenInteger:isSubsetOf(set.oddInteger) == nil)",
		comment="",
		duration=1.4e-05,
		simplifyStack={}
	},
	{
		code="assert(set.oddInteger:isSubsetOf(set.oddInteger) == true)",
		comment="",
		duration=2.3999999999996e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{code="", comment="realinterval", duration=0},
	{code="", comment="", duration=9.9999999999406e-07},
	{
		code="assert(set.RealInterval(-2, -1, true, true):isSubsetOf(set.RealInterval(1, 2, true, true)) == false)",
		comment="",
		duration=2.9000000000001e-05,
		simplifyStack={}
	},
	{
		code="assert(set.RealInterval(-2, -1, true, true):isSubsetOf(set.RealInterval(-1, 2, true, true)) == nil)",
		comment="",
		duration=1.9000000000005e-05,
		simplifyStack={}
	},
	{
		code="assert(set.RealInterval(-2, -1, true, true):isSubsetOf(set.RealInterval(-2, 2, true, true)) == true)",
		comment="",
		duration=2.2999999999995e-05,
		simplifyStack={}
	},
	{
		code="assert(set.RealInterval(-2, -1, true, true):isSubsetOf(set.RealInterval(-2, 2, false, true)) == nil)",
		comment="",
		duration=1.7999999999997e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="local A = set.RealInterval(0, 1, false, true) printbr(A, 'isSubsetOf', A) assert(A:isSubsetOf(A))",
		comment="",
		duration=4.5000000000003e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="realsubset", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{
		code="local A = set.RealSubset(0, 1, false, true) printbr(A, 'isSubsetOf', A) assert(A:isSubsetOf(A))",
		comment="",
		duration=0.000119,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="local A = set.RealSubset(0, 1, false, true) local B = set.RealSubset{{-1, 0, true, false}, {0, 1, false, true}} printbr(A, 'isSubsetOf', B) assert(A:isSubsetOf(B))",
		comment="",
		duration=6.7999999999999e-05,
		simplifyStack={}
	},
	{
		code="assert(set.RealSubset(0, math.huge, false, true):isSubsetOf(set.RealSubset{{-math.huge, 0, true, false}, {0, math.huge, false, true}}))",
		comment="",
		duration=0.000114,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="containing constants", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.real:contains(inf) == true)",
		comment="TODO technically that makes set.real the extended reals.  should I distinguish between real and extended real?",
		duration=2.2000000000001e-05,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:contains(inf) == true)",
		comment="",
		duration=1.5999999999995e-05,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:contains(inf) == false)",
		comment="",
		duration=3.3999999999999e-05,
		simplifyStack={}
	},
	{
		code="assert(set.nonNegativeReal:contains(inf) == true)",
		comment="",
		duration=0.000136,
		simplifyStack={}
	},
	{
		code="assert(set.nonPositiveReal:contains(inf) == false)",
		comment="",
		duration=1.3999999999993e-05,
		simplifyStack={}
	},
	{
		code="assert(set.positiveReal:contains(-inf) == nil)",
		comment="",
		duration=5.3000000000004e-05,
		simplifyStack={}
	},
	{
		code="assert(set.negativeReal:contains(-inf) == true)",
		comment="",
		duration=0.000254,
		simplifyStack={}
	},
	{
		code="assert(set.nonNegativeReal:contains(-inf) == nil)",
		comment="",
		duration=0.000222,
		simplifyStack={}
	},
	{
		code="assert(set.nonPositiveReal:contains(-inf) == true)",
		comment="",
		duration=0.000224,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{code="", comment="containing ranges of expressions", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.real:contains(x))",
		comment="",
		duration=0.000264,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="", duration=9.9999999999406e-07},
	{code="", comment="x is in (-inf, inf).", duration=1.000000000001e-06},
	{code="", comment="is x in (0, inf)?", duration=9.9999999999406e-07},
	{code="", comment="maybe.", duration=9.9999999999406e-07},
	{code="", comment="not certainly yes (subset).", duration=1.000000000001e-06},
	{code="", comment="not certainly no (complement intersection / set subtraction is empty).", duration=1.000000000001e-06},
	{code="", comment="so return nil", duration=0},
	{code="", comment="if x's set is a subset of this set then return true", duration=1.000000000001e-06},
	{code="", comment="if x's set is an intersection of this set then return nil", duration=1.000000000001e-06},
	{code="", comment="if x's set does not intersect this set then return false", duration=0},
	{
		code="assert(set.positiveReal:contains(x) == nil)",
		comment="",
		duration=2.3000000000002e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="assert(set.real:contains(sin(x)))",
		comment="",
		duration=0.000652,
		simplifyStack={}
	},
	{
		code="assert(set.RealSubset(-1,1,true,true):contains(sin(x)))",
		comment="",
		duration=0.000175,
		simplifyStack={}
	},
	{code="", comment="", duration=9.9999999999406e-07},
	{
		code="assert(not set.positiveReal:contains(abs(x)))",
		comment="",
		duration=9.9000000000002e-05,
		simplifyStack={}
	},
	{
		code="assert(set.nonNegativeReal:contains(abs(x)))",
		comment="",
		duration=0.000133,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="assert(set.complex:contains(x))",
		comment="",
		duration=0.000101,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="(function() local x = set.RealSubset(-1,1,true,true):var'x' assert(set.real:contains(asin(x))) end)()",
		comment="",
		duration=0.000203,
		simplifyStack={}
	},
	{
		code="(function() local x = set.RealSubset(-1,1,true,true):var'x' assert(set.real:contains(acos(x))) end)()",
		comment="",
		duration=0.000567,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="print(acos(x):getRealRange())",
		comment="",
		duration=2.4000000000003e-05,
		simplifyStack={}
	},
	{
		code="(function() local x = set.RealSubset(1,math.huge,true,true):var'x' assert(not set.real:contains(acos(x))) end)()",
		comment="TODO eventually return uncertain / touches but not contains",
		duration=3.6000000000001e-05,
		simplifyStack={}
	},
	{
		code="(function() local x = set.RealSubset(1,math.huge,false,true):var'x' assert(not set.real:contains(acos(x))) end)()",
		comment="TODO return definitely false",
		duration=2.5999999999998e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=9.9999999999406e-07},
	{
		code="(function() local x = set.RealSubset(1,1,true,true):var'x' assert(set.real:contains(acos(x))) end)()",
		comment="",
		duration=0.000284,
		simplifyStack={}
	},
	{code="", comment="", duration=9.9999999999406e-07},
	{
		code="(function() local x = set.real:var'x' assert(abs(x)() == abs(x)) end)()",
		comment="",
		duration=0.000643,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=9.9999999999406e-07},
	{
		code="(function() local x = set.nonNegativeReal:var'x' assert(abs(x)() == x) end)()",
		comment="",
		duration=0.000779,
		simplifyStack={"Init", "abs:Prune:apply", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="(function() local x = set.nonNegativeReal:var'x' assert(abs(sinh(x))() == sinh(x)) end)()",
		comment="",
		duration=0.001262,
		simplifyStack={"Init", "abs:Prune:apply", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="", duration=9.9999999999406e-07},
	{code="", comment="x^2 should be positive", duration=0},
	{
		code="assert((x^2):getRealRange() == set.nonNegativeReal)",
		comment="",
		duration=0.000117,
		simplifyStack={}
	},
	{
		code="assert(set.nonNegativeReal:contains(x^2))",
		comment="",
		duration=7.7999999999995e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert((Constant(2)^2):getRealRange() == set.RealSubset(4,4,true,true))",
		comment="",
		duration=0.00013,
		simplifyStack={}
	},
	{
		code="assert((Constant(-2)^2):getRealRange() == set.RealSubset(4,4,true,true))",
		comment="",
		duration=0.00010599999999999,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert(set.nonNegativeReal:contains(exp(x)))",
		comment="",
		duration=0.000113,
		simplifyStack={}
	},
	{code="", comment="", duration=9.9999999999406e-07},
	{code="", comment="1/x should be disjoint", duration=1.000000000001e-06},
	{
		code="print((1/x):getRealRange())",
		comment="",
		duration=0.00022,
		simplifyStack={}
	},
	{
		code="assert((1/x):getRealRange():contains(0) == false)",
		comment="",
		duration=8.8999999999999e-05,
		simplifyStack={}
	},
	{
		code="assert((1/x):getRealRange():contains(1))",
		comment="",
		duration=4.4000000000002e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="assert((1/x):getRealRange():contains(set.positiveReal))",
		comment="",
		duration=0.00021,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{code="", comment="../../sin.lua:function sin:getRealRange()", duration=0},
	{code="", comment="../../sin.lua:\9local Is = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../asinh.lua:asinh.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_inc", duration=0},
	{code="", comment="../../atan.lua:atan.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_inc", duration=1.000000000001e-06},
	{code="", comment="../../cosh.lua:cosh.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_evenIncreasing", duration=1.000000000001e-06},
	{code="", comment="../../acos.lua:function acos:getRealRange()", duration=0},
	{code="", comment="../../acos.lua:\9local Is = self[1]:getRealRange()", duration=0},
	{code="", comment="../../tanh.lua:tanh.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_inc", duration=1.000000000001e-06},
	{code="", comment="../../asin.lua:asin.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_pmOneInc", duration=9.9999999999406e-07},
	{code="", comment="../../sqrt.lua:sqrt.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_posInc_negIm", duration=1.000000000001e-06},
	{code="", comment="../../log.lua:log.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_posInc_negIm", duration=0},
	{code="", comment="../../acosh.lua:function acosh:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../acosh.lua:\9local Is = x[1]:getRealRange()", duration=0},
	{code="", comment="../../atanh.lua:atanh.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_pmOneInc", duration=1.000000000001e-06},
	{code="", comment="../../tan.lua:function tan:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../tan.lua:\9local Is = self[1]:getRealRange()", duration=0},
	{code="", comment="../../cos.lua:function cos:getRealRange()", duration=0},
	{code="", comment="../../cos.lua:\9local Is = self[1]:getRealRange()", duration=0},
	{code="", comment="../../cos.lua:\9\9-- here I'm going to add pi/2 and then just copy the sin:getRealRange() code", duration=1.000000000001e-06},
	{code="", comment="../../sinh.lua:sinh.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_inc", duration=1.000000000001e-06},
	{code="", comment="../../abs.lua:abs.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_evenIncreasing", duration=9.9999999999406e-07},
	{code="", comment="", duration=0},
	{code="", comment="../../Constant.lua:function Constant:getRealRange()", duration=0},
	{code="", comment="../../Expression.lua:function Expression:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../Variable.lua:function Variable:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{code="", comment="../../op/mul.lua:function mul:getRealRange()", duration=0},
	{code="", comment="../../op/mul.lua:\9local I = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/mul.lua:\9\9local I2 = self[i]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/div.lua:function div:getRealRange()", duration=9.9999999999406e-07},
	{code="", comment="../../op/div.lua:\9local I = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/div.lua:\9local I2 = self[2]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/sub.lua:function sub:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/sub.lua:\9local I = self[1]:getRealRange()", duration=0},
	{code="", comment="../../op/sub.lua:\9\9local I2 = self[i]:getRealRange()", duration=0},
	{code="", comment="../../op/add.lua:function add:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/add.lua:\9local I = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/add.lua:\9\9local I2 = self[i]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/pow.lua:function pow:getRealRange()", duration=0},
	{code="", comment="../../op/pow.lua:\9local I = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/pow.lua:\9local I2 = self[2]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/unm.lua:function unm:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../op/unm.lua:\9local I = self[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{code="", comment="../../set/RealSubset.lua:-- commonly used versions of the Expression:getRealRange function", duration=9.9999999999406e-07},
	{code="", comment="../../set/RealSubset.lua:function RealSubset.getRealDomain_evenIncreasing(x)", duration=0},
	{code="", comment="../../set/RealSubset.lua:\9local Is = x[1]:getRealRange()", duration=0},
	{code="", comment="../../set/RealSubset.lua:function RealSubset.getRealDomain_posInc_negIm(x)", duration=1.000000000001e-06},
	{code="", comment="../../set/RealSubset.lua:\9local Is = x[1]:getRealRange()", duration=0},
	{code="", comment="../../set/RealSubset.lua:function RealSubset.getRealDomain_pmOneInc(x)", duration=1.000000000001e-06},
	{code="", comment="../../set/RealSubset.lua:\9local Is = x[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../set/RealSubset.lua:function RealSubset.getRealDomain_inc(x)", duration=1.000000000001e-06},
	{code="", comment="../../set/RealSubset.lua:\9local Is = x[1]:getRealRange()", duration=1.000000000001e-06},
	{code="", comment="../../set/RealInterval.lua:\9local I = x:getRealRange()", duration=1.000000000001e-06}
}