{
	{
		code="x = var'x'",
		comment="",
		duration=3.6000000000001e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=0},
	{
		code="y = func('y', {x}, x^2)",
		comment="",
		duration=7.4999999999999e-05,
		simplifyStack={}
	},
	{code="", comment="TODO what to display...", duration=1.000000000001e-06},
	{code="", comment="y = x", duration=0},
	{code="", comment="y(x) = x", duration=9.9999999999406e-07},
	{code="", comment="y(x) := x", duration=1.000000000001e-06},
	{
		code="print(y(x))",
		comment="",
		duration=5.4999999999999e-05,
		simplifyStack={}
	},
	{
		code="print(y(x)())",
		comment="",
		duration=0.002442,
		simplifyStack={"Init", "y:Prune:apply", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="printbr(y:defeq())",
		comment="",
		duration=0.0002,
		simplifyStack={}
	},
	{
		code="assert(UserFunction.registeredFunctions.y == y)",
		comment="",
		duration=1.2999999999999e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="if UserFunction is not a Variable then this is invalid", duration=0},
	{code="", comment="because you cannot have Functions as Variables in the arg list", duration=1.000000000001e-06},
	{code="", comment="f = func('f', {x, y}, x*y)", duration=0},
	{code="", comment="print(f:defeq())", duration=1.000000000001e-06},
	{code="", comment="assert(UserFunction.registeredFunctions.f == f)", duration=0},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="instead, if UserFunction returns Functions, this is what you would see", duration=9.9999999999406e-07},
	{code="", comment="and with this the derivative evaluation is obvious", duration=1.000000000001e-06},
	{
		code="f = func('f', {x}, x*y(x))",
		comment="",
		duration=0.000319,
		simplifyStack={}
	},
	{
		code="print(f:defeq())",
		comment="",
		duration=0.000303,
		simplifyStack={}
	},
	{
		code="assert(UserFunction.registeredFunctions.f == f)",
		comment="",
		duration=1.9999999999999e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.6999999999996e-05},
	{code="", comment="diff() is partial derivative", duration=1.000000000001e-06},
	{code="", comment="totalDiff() is total derivative", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="total derivative evaluation", duration=1.000000000001e-06},
	{code="", comment="substitute chain rule for all terms", duration=1.000000000001e-06},
	{code="", comment="df/dx, when simplified, does not go anywhere, because f is dependent on x", duration=0},
	{code="", comment="for that reason, I can just build the equality f:eq(f.def) and apply :diff() to the whole thing:", duration=0},
	{
		code="print(f:defeq():diff(x):prune())",
		comment="",
		duration=0.005127,
		simplifyStack={"f:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "Derivative:Prune:self", "Derivative:Prune:eval", "Derivative:Prune:self", "Derivative:Prune:eval", "Derivative:Prune:eval"}
	},
	{code="", comment="but TODO wrt total derivatives ... diff(y) ...", duration=1.000000000001e-06},
	{code="", comment="y(x) above is a UserFunction subclass", duration=0},
	{code="", comment="which means it isn't a Variable", duration=1.000000000001e-06},
	{code="", comment="which means you can't diff(y) ...", duration=1.000000000001e-06},
	{code="", comment="though you could diff(y(x)) ...", duration=1.000000000001e-06},
	{code="", comment="but that would be diff'ing wrt expressions, which I don't have support for", duration=1.000000000001e-06},
	{
		code="print(f:defeq():diff(y):prune())",
		comment="",
		duration=0.005532,
		simplifyStack={"f:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "Derivative:Prune:other", "*:Prune:apply", "Derivative:Prune:eval", "Derivative:Prune:other", "*:Prune:apply", "Derivative:Prune:eval", "Derivative:Prune:eval"}
	},
	{
		code="print(f:defeq():diff(y(x)):prune())",
		comment="",
		duration=0.00232,
		simplifyStack={"f:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "y:Prune:apply", "y:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "Derivative:Prune:other", "*:Prune:apply", "Derivative:Prune:eval", "Derivative:Prune:other", "*:Prune:apply", "Derivative:Prune:eval", "Derivative:Prune:eval"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="s = var's'",
		comment="",
		duration=1.9999999999999e-05,
		simplifyStack={}
	},
	{
		code="t = var't'",
		comment="",
		duration=1.5000000000001e-05,
		simplifyStack={}
	},
	{
		code="x = func('x', {s,t})",
		comment="",
		duration=9.1000000000001e-05,
		simplifyStack={}
	},
	{
		code="y = func('y', {s,t})",
		comment="",
		duration=7.3999999999998e-05,
		simplifyStack={}
	},
	{
		code="f = func('f', {x,y})",
		comment="",
		duration=0.000119,
		error="/home/chris/Projects/lua/symmath/UserFunction.lua:141: args must be a table of Variables\nstack traceback:\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:238: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:237>\n\9[C]: in function 'assert'\n\9/home/chris/Projects/lua/symmath/UserFunction.lua:141: in function 'func'\n\9[string \"f = func('f', {x,y})\"]:1: in main chunk\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:230: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:229>\n\9[C]: in function 'xpcall'\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:229: in function 'exec'\n\9func.lua:65: in function 'cb'\n\9/home/chris/Projects/lua/ext/timer.lua:49: in function 'timer'\n\9func.lua:6: in main chunk\n\9[C]: at 0x55ccd58202f0",
		simplifyStack={}
	},
	{
		code="print(f:diff(x):prune())",
		comment="∂f/∂x",
		duration=0.00048400000000001,
		error="/home/chris/Projects/lua/symmath/Expression.lua:40: attempt to call a table value\nstack traceback:\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:238: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:237>\n\9/home/chris/Projects/lua/symmath/Expression.lua:40: in function 'clone'\n\9/home/chris/Projects/lua/symmath/Derivative.lua:328: in function 'func'\n\9/home/chris/Projects/lua/symmath/visitor/Visitor.lua:217: in function 'prune'\n\9[string \"print(f:diff(x):prune())\"]:1: in main chunk\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:230: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:229>\n\9[C]: in function 'xpcall'\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:229: in function 'exec'\n\9func.lua:65: in function 'cb'\n\9/home/chris/Projects/lua/ext/timer.lua:49: in function 'timer'\n\9func.lua:6: in main chunk\n\9[C]: at 0x55ccd58202f0",
		simplifyStack={}
	},
	{
		code="print(f:diff(y):prune())",
		comment="∂f/∂y",
		duration=0.000488,
		error="/home/chris/Projects/lua/symmath/Expression.lua:40: attempt to call a table value\nstack traceback:\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:238: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:237>\n\9/home/chris/Projects/lua/symmath/Expression.lua:40: in function 'clone'\n\9/home/chris/Projects/lua/symmath/Derivative.lua:328: in function 'func'\n\9/home/chris/Projects/lua/symmath/visitor/Visitor.lua:217: in function 'prune'\n\9[string \"print(f:diff(y):prune())\"]:1: in main chunk\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:230: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:229>\n\9[C]: in function 'xpcall'\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:229: in function 'exec'\n\9func.lua:65: in function 'cb'\n\9/home/chris/Projects/lua/ext/timer.lua:49: in function 'timer'\n\9func.lua:6: in main chunk\n\9[C]: at 0x55ccd58202f0",
		simplifyStack={}
	},
	{
		code="print(f:diff(s):prune())",
		comment="∂f/∂x ∂x/∂s + ∂f/∂y ∂y/∂s",
		duration=0.000356,
		error="/home/chris/Projects/lua/symmath/Expression.lua:40: attempt to call a table value\nstack traceback:\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:238: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:237>\n\9/home/chris/Projects/lua/symmath/Expression.lua:40: in function 'clone'\n\9/home/chris/Projects/lua/symmath/Derivative.lua:328: in function 'func'\n\9/home/chris/Projects/lua/symmath/visitor/Visitor.lua:217: in function 'prune'\n\9[string \"print(f:diff(s):prune())\"]:1: in main chunk\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:230: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:229>\n\9[C]: in function 'xpcall'\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:229: in function 'exec'\n\9func.lua:65: in function 'cb'\n\9/home/chris/Projects/lua/ext/timer.lua:49: in function 'timer'\n\9func.lua:6: in main chunk\n\9[C]: at 0x55ccd58202f0",
		simplifyStack={}
	},
	{
		code="print(f:diff(t):prune())",
		comment="∂f/∂x ∂x/∂t + ∂f/∂y ∂y/∂t",
		duration=0.000343,
		error="/home/chris/Projects/lua/symmath/Expression.lua:40: attempt to call a table value\nstack traceback:\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:238: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:237>\n\9/home/chris/Projects/lua/symmath/Expression.lua:40: in function 'clone'\n\9/home/chris/Projects/lua/symmath/Derivative.lua:328: in function 'func'\n\9/home/chris/Projects/lua/symmath/visitor/Visitor.lua:217: in function 'prune'\n\9[string \"print(f:diff(t):prune())\"]:1: in main chunk\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:230: in function </home/chris/Projects/lua/symmath/tests/unit/unit.lua:229>\n\9[C]: in function 'xpcall'\n\9/home/chris/Projects/lua/symmath/tests/unit/unit.lua:229: in function 'exec'\n\9func.lua:65: in function 'cb'\n\9/home/chris/Projects/lua/ext/timer.lua:49: in function 'timer'\n\9func.lua:6: in main chunk\n\9[C]: at 0x55ccd58202f0",
		simplifyStack={}
	},
	{code="", comment="TODO I need something to represent ∂/∂x \"the def of f\", rather than ∂/∂x \"f\", which is zero.", duration=9.9999999999406e-07},
	{code="", comment="in contrast ∂/∂x \"the def of f\" would be a placeholder (in absense of f's provided definition)", duration=1.000000000001e-06}
}