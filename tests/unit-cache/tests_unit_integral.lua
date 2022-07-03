{
	{code="", comment="integrate constants", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(Constant(1):integrate(x), x)",
		comment="",
		duration=0.000468,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(y:integrate(x), x * y)",
		comment="",
		duration=0.001065,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(Constant(1):integrate(x, xL, xR), (xR - xL))",
		comment="",
		duration=0.002956,
		simplifyStack={"Init", "unm:Prune:doubleNegative", "Prune", "Expand", "Prune", "+:Factor:apply", "Factor", "Prune", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="definite integral bounds:", duration=0},
	{code="", comment="simplifyAssertEq(x:integrate(x, xL, xR), ((xR^2 - xL^2)/2))\9-- hmm, the infamous minus sign factoring simplificaiton error...", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((x:integrate(x, xL, xR) - (xR^2 - xL^2)/2), Constant(0))",
		comment="instead I'll just test this ...",
		duration=0.013085,
		simplifyStack={"Init", "Integral:Prune:apply", "Integral:Prune:apply", "unm:Prune:doubleNegative", "*:Prune:factorDenominators", "unm:Prune:doubleNegative", "*:Prune:apply", "*:Prune:factorDenominators", "*:Prune:apply", "*:Prune:factorDenominators", "*:Prune:factorDenominators", "unm:Prune:doubleNegative", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "+:Prune:factorOutDivs", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "Constant:Tidy:apply", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "unm:Prune:doubleNegative", "unm:Prune:doubleNegative", "unm:Prune:doubleNegative", "*:Prune:apply", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "+:Prune:flatten", "+:Prune:factorOutDivs", "+:Prune:flatten", "Prune", "^:Expand:integerPower", "^:Expand:integerPower", "*:Expand:apply", "^:Expand:integerPower", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:apply", "*:Prune:flatten", "+:Prune:combineConstants", "*:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:apply", "*:Prune:apply", "+:Prune:flattenAddMul", "+:Prune:combineConstants", "+:Prune:flattenAddMul", "+:Prune:flatten", "/:Prune:zeroOverX", "Prune", "Factor", "Prune", "Expand", "Prune", "Factor", "Prune", "Constant:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=2.000000000002e-06},
	{code="", comment="$x^n$ integrals:", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(x:integrate(x), x^2 / 2)",
		comment="",
		duration=0.006041,
		simplifyStack={"Init", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "/:Factor:polydiv", "Factor", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "*:Prune:apply", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq((x^2):integrate(x), x^3 / 3)",
		comment="",
		duration=0.007288,
		simplifyStack={"Init", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "/:Factor:polydiv", "Factor", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "*:Prune:apply", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(((x^-2):integrate(x) - (-1/x)), Constant(0))",
		comment="",
		duration=0.003966,
		simplifyStack={"Init", "^:Prune:xToTheNegY", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq((1/x):integrate(x), log(abs(x)))",
		comment="",
		duration=0.002064,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq((x^-1):integrate(x), log(abs(x)))",
		comment="",
		duration=0.001103,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq((1/(2*x^2)):integrate(x), -(1/(2*x)))",
		comment="",
		duration=0.006974,
		simplifyStack={"Init", "*:Prune:apply", "*:Prune:factorDenominators", "unm:Prune:doubleNegative", "Prune", "Expand", "Prune", "/:Factor:polydiv", "Factor", "/:Prune:xOverMinusOne", "*:Prune:flatten", "Prune", "Constant:Tidy:apply", "*:Tidy:apply", "/:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((x^frac(1,2)):integrate(x), frac(2 * x * sqrt(x), 3))",
		comment="",
		duration=0.008422,
		simplifyStack={"Init", "sqrt:Prune:apply", "+:Prune:combineConstants", "+:Prune:factorOutDivs", "*:Prune:apply", "Prune", "Expand", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "^:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq(sqrt(x):integrate(x), frac(2 * x * sqrt(x), 3))",
		comment="",
		duration=0.008291,
		simplifyStack={"Init", "sqrt:Prune:apply", "+:Prune:combineConstants", "+:Prune:factorOutDivs", "*:Prune:apply", "Prune", "Expand", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "^:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((1/x):integrate(x), log(abs(x)))",
		comment="",
		duration=0.001099,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((2/x):integrate(x), (2*log(abs(x))))",
		comment="",
		duration=0.00246,
		simplifyStack={"Init", "*:Prune:logPow", "Prune", "^:Expand:integerPower", "log:Expand:apply", "Expand", "*:Prune:logPow", "+:Prune:flattenAddMul", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq((1/(2*x)):integrate(x), (log(abs(x))/2))",
		comment="",
		duration=0.00514,
		simplifyStack={"Init", "/:Prune:logPow", "Prune", "log:Expand:apply", "Expand", "*:Prune:apply", "/:Prune:logPow", "*:Prune:factorDenominators", "Prune", "Factor", "Prune", "^:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((1/(x*(3*x+4))):integrate(x)(), log(1 / abs( (4 + 3 * x) / x)^frac(1,4)))",
		comment="",
		duration=0.040103,
		simplifyStack={"Init", "Prune", "log:Expand:apply", "unm:Expand:apply", "log:Expand:apply", "Expand", "log:Prune:apply", "^:Prune:xToTheNegY", "*:Prune:logPow", "/:Prune:logPow", "*:Prune:factorDenominators", "+:Prune:combineConstants", "Prune", "Factor", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=2.9999999999752e-06},
	{
		code="simplifyAssertEq(f:diff(x):integrate(x)(), f)",
		comment="",
		duration=0.00028800000000001,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(f:integrate(x):diff(x)(), f)",
		comment="",
		duration=0.001017,
		simplifyStack={"Init", "Derivative:Prune:integrals", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(f:diff(x,x):integrate(x)(), f:diff(x))",
		comment="",
		duration=0.00040900000000002,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(f:integrate(x):integrate(x):diff(x)(), f:integrate(x))",
		comment="",
		duration=0.00138,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(f:integrate(x):diff(x,x)(), f:diff(x))",
		comment="",
		duration=0.00049399999999999,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(sin(x):integrate(x)(), -cos(x))",
		comment="",
		duration=0.001145,
		simplifyStack={"Init", "unm:Prune:doubleNegative", "Prune", "Expand", "Prune", "Factor", "Prune", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq(cos(x):integrate(x)(), sin(x))",
		comment="",
		duration=0.000501,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(sin(2*x):integrate(x)(), (-cos(2*x)/2))",
		comment="",
		duration=0.005112,
		simplifyStack={"Init", "unm:Prune:doubleNegative", "Prune", "Expand", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "/:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq(cos(y*x):integrate(x)(), (sin(y*x)/y))",
		comment="",
		duration=0.006567,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "/:Factor:polydiv", "Factor", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "*:Prune:apply", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((cos(x)/sin(x)):integrate(x), log(abs(sin(x))))",
		comment="",
		duration=0.00246,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=9.9999999997324e-07},
	{
		code="simplifyAssertEq((cos(x)^2):integrate(x)(), frac(1,4) * (2 * x + sin(2 * x)))",
		comment="",
		duration=0.008324,
		simplifyStack={"Init", "*:Tidy:apply", "*:Tidy:apply", "*:Prune:apply", "*:Prune:factorDenominators", "Prune", "Expand", "Prune", "+:Factor:apply", "/:Factor:polydiv", "Factor", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheNegY", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "*:Tidy:apply", "*:Tidy:apply", "*:Prune:apply", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq(sinh(x):integrate(x), cosh(x))",
		comment="",
		duration=0.00065200000000001,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{
		code="simplifyAssertEq(cosh(x):integrate(x), sinh(x))",
		comment="",
		duration=0.00045699999999999,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=9.9999999997324e-07},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="multiple integrals", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq((x * y):integrate(x), frac(1,2) * x^2 * y)",
		comment="",
		duration=0.003169,
		simplifyStack={"Init", "*:Prune:factorDenominators", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq((x * y):integrate(x)():integrate(y)(), frac(1,4) * x^2 * y^2)",
		comment="",
		duration=0.009788,
		simplifyStack={"Init", "*:Prune:factorDenominators", "Prune", "^:Expand:integerPower", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "*:Factor:combineMulOfLikePow", "/:Factor:polydiv", "Factor", "^:Prune:expandMulOfLikePow", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheNegY", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq((x * y):integrate(x):integrate(y)(), frac(1,4) * x^2 * y^2)",
		comment="",
		duration=0.010594,
		simplifyStack={"Init", "*:Prune:factorDenominators", "Prune", "^:Expand:integerPower", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "*:Factor:combineMulOfLikePow", "/:Factor:polydiv", "Factor", "^:Prune:expandMulOfLikePow", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheNegY", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq((r * cos(x)):integrate(r)():integrate(x)(), frac(1,2) * r^2 * sin(x))",
		comment="",
		duration=0.011861,
		simplifyStack={"Init", "*:Prune:factorDenominators", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq((r * cos(x)):integrate(x)():integrate(r)(), frac(1,2) * r^2 * sin(x))",
		comment="",
		duration=0.006693,
		simplifyStack={"Init", "*:Prune:factorDenominators", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "Tidy"}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertEq( ( cosh(a * x) * sinh(a * x) ):integrate(x), cosh(a * x)^2 / (2 * a) )",
		comment="",
		duration=0.008394,
		simplifyStack={"Init", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "^:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "^:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "*:Prune:apply", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "*:Tidy:apply", "Tidy"}
	},
	{
		code="simplifyAssertEq( ( cosh(a * x) * sinh(b * x) ):integrate(x), 1 / ((a + b) * (a - b)) * (-b * cosh(a*x) * cosh(b*x) + a * sinh(a*x) * sinh(b*x)) )",
		comment="",
		duration=0.114369,
		simplifyStack={"Init", "unm:Prune:doubleNegative", "unm:Prune:doubleNegative", "*:Prune:flatten", "Constant:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "*:Tidy:apply", "unm:Prune:doubleNegative", "*:Prune:apply", "*:Prune:factorDenominators", "Prune", "*:Expand:apply", "*:Expand:apply", "*:Expand:apply", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "*:Prune:apply", "+:Prune:combineConstants", "+:Prune:flattenAddMul", "+:Prune:flatten", "Prune", "+:Factor:apply", "/:Prune:xOverX", "^:Prune:xToTheOne", "/:Prune:xOverX", "^:Prune:xToTheOne", "/:Prune:xOverX", "^:Prune:xToTheOne", "/:Prune:xOverX", "^:Prune:xToTheOne", "unm:Prune:doubleNegative", "+:Factor:apply", "+:Factor:apply", "+:Factor:apply", "*:ExpandPolynomial:apply", "*:ExpandPolynomial:apply", "*:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "*:Prune:apply", "+:Prune:combineConstants", "+:Prune:flattenAddMul", "+:Prune:flatten", "*:ExpandPolynomial:apply", "*:ExpandPolynomial:apply", "*:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "+:Prune:combineConstants", "*:Prune:apply", "*:Prune:flatten", "*:Prune:apply", "+:Prune:combineConstants", "+:Prune:flattenAddMul", "+:Prune:flatten", "Factor", "Prune", "Tidy"}
	},
	{code="", comment="", duration=9.9999999997324e-07},
	{
		code="simplifyAssertEq( ( sinh(a * x)^2 * cosh(a * x) ):integrate(x), sinh(a * x)^3 / (3 * a) )",
		comment="",
		duration=0.005126,
		simplifyStack={"Init", "Prune", "^:Expand:integerPower", "Expand", "+:Prune:combineConstants", "*:Prune:apply", "Prune", "^:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "^:ExpandPolynomial:apply", "+:Prune:combineConstants", "*:Prune:apply", "/:Factor:polydiv", "Factor", "*:Prune:flatten", "*:Prune:apply", "unm:Prune:doubleNegative", "+:Prune:combineConstants", "^:Prune:xToTheZero", "/:Prune:divToPowSub", "*:Prune:factorDenominators", "Prune", "*:Tidy:apply", "*:Tidy:apply", "Tidy"}
	}
}