{
	{
		code="printbr(T)",
		comment="",
		duration=0.000263,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="writing apparently does", duration=1.000000000001e-06},
	{code="", comment="", duration=0},
	{
		code="printbr(T'_ij':prune())\9\9assertEq(T'_ij':prune(), T)",
		comment="",
		duration=0.001987,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_xx':prune())\9\9assertEq(T'_xx':prune(), T[1][1])",
		comment="",
		duration=0.00205,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_xy':prune())\9\9assertEq(T'_xy':prune(), T[1][2])",
		comment="",
		duration=0.001599,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_xz':prune())\9\9assertEq(T'_xz':prune(), T[1][3])",
		comment="",
		duration=0.001439,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_yx':prune())\9\9assertEq(T'_yx':prune(), T[2][1])",
		comment="",
		duration=0.001528,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_yy':prune())\9\9assertEq(T'_yy':prune(), T[2][2])",
		comment="",
		duration=0.002169,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_yz':prune())\9\9assertEq(T'_yz':prune(), T[2][3])",
		comment="",
		duration=0.001636,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_zx':prune())\9\9assertEq(T'_zx':prune(), T[3][1])",
		comment="",
		duration=0.001028,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_zy':prune())\9\9assertEq(T'_zy':prune(), T[3][2])",
		comment="",
		duration=0.001048,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_zz':prune())\9\9assertEq(T'_zz':prune(), T[3][3])",
		comment="",
		duration=0.00081800000000001,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_xp':prune())\9\9assertEq(T'_xp':prune(), Tensor('_p', T[1][2], T[1][3]))",
		comment="",
		duration=0.001403,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_yp':prune())\9\9assertEq(T'_yp':prune(), Tensor('_p', T[2][2], T[2][3]))",
		comment="",
		duration=0.002063,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_zp':prune())\9\9assertEq(T'_zp':prune(), Tensor('_p', T[3][2], T[3][3]))",
		comment="",
		duration=0.002008,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_px':prune())\9\9assertEq(T'_px':prune(), Tensor('_p', T[2][1], T[3][1]))",
		comment="",
		duration=0.002592,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_py':prune())\9\9assertEq(T'_py':prune(), Tensor('_p', T[2][2], T[3][2]))",
		comment="",
		duration=0.001856,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_pz':prune())\9\9assertEq(T'_pz':prune(), Tensor('_p', T[2][3], T[3][3]))",
		comment="",
		duration=0.001167,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{
		code="printbr(T'_pq':prune())\9\9assertEq(T'_pq':prune(), Tensor('_pq', {T[2][2], T[2][3]}, {T[3][2], T[3][3]}))",
		comment="",
		duration=0.001412,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy", "Tensor.Ref:Prune:apply"}
	},
	{code="", comment="", duration=0},
	{code="", comment="reading by __index doesn't work?", duration=1.000000000001e-06},
	{code="", comment="I guess only writing by __index does for now", duration=1.000000000001e-06},
	{code="", comment="but why bother read by __index when you can just use the __call operator with strings?", duration=0},
	{code="", comment="printbr(T['_ij'])\9\9assertEq(T['_ij'], T)", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_xx'])\9\9assertEq(T['_xx'], T[1][1])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_xy'])\9\9assertEq(T['_xy'], T[1][2])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_xz'])\9\9assertEq(T['_xz'], T[1][3])", duration=0},
	{code="", comment="printbr(T['_yx'])\9\9assertEq(T['_yx'], T[2][1])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_yy'])\9\9assertEq(T['_yy'], T[2][2])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_yz'])\9\9assertEq(T['_yz'], T[2][3])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_zx'])\9\9assertEq(T['_zx'], T[3][1])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_zy'])\9\9assertEq(T['_zy'], T[3][2])", duration=0},
	{code="", comment="printbr(T['_zz'])\9\9assertEq(T['_zz'], T[3][3])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_xp'])\9\9assertEq(T['_xp'])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_yp'])\9\9assertEq(T['_yp'])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_zp'])\9\9assertEq(T['_zp'])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_px'])\9\9assertEq(T['_px'])", duration=9.9999999998712e-07},
	{code="", comment="printbr(T['_py'])\9\9assertEq(T['_py'])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_pz'])\9\9assertEq(T['_pz'])", duration=1.000000000001e-06},
	{code="", comment="printbr(T['_pq'])\9\9assertEq(T['_pq'])", duration=1.000000000001e-06}
}