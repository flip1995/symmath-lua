{
	{
		code="local x=a'i' \9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false})",
		comment="upper by default",
		duration=5.4999999999999e-05,
		simplifyStack={}
	},
	{
		code="local x=a'^i' \9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false})",
		comment="",
		duration=5.6e-05,
		simplifyStack={}
	},
	{
		code="local x=a'_i' \9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true})",
		comment="",
		duration=7.0999999999998e-05,
		simplifyStack={}
	},
	{
		code="local x=a'ij' \9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false} and x[3]==Tensor.Index{symbol='j', lower=false})",
		comment="",
		duration=9.6000000000002e-05,
		simplifyStack={}
	},
	{
		code="local x=a'i_j' \9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false} and x[3]==Tensor.Index{symbol='j', lower=true})",
		comment="",
		duration=7.3999999999998e-05,
		simplifyStack={}
	},
	{
		code="local x=a'^ij' \9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false} and x[3]==Tensor.Index{symbol='j', lower=false})",
		comment="",
		duration=7.1000000000002e-05,
		simplifyStack={}
	},
	{
		code="local x=a'^i_j'\9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false} and x[3]==Tensor.Index{symbol='j', lower=true})",
		comment="",
		duration=8.5999999999999e-05,
		simplifyStack={}
	},
	{
		code="local x=a'_i^j'\9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true} and x[3]==Tensor.Index{symbol='j', lower=false})",
		comment="",
		duration=5.8000000000002e-05,
		simplifyStack={}
	},
	{
		code="local x=a'_ij' \9print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true} and x[3]==Tensor.Index{symbol='j', lower=true})",
		comment="",
		duration=4.3000000000001e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=9.9999999999753e-07},
	{code="", comment="multi-char", duration=9.9999999999753e-07},
	{
		code="local x=a' i' \9\9\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false})",
		comment="upper by default",
		duration=0.00012,
		simplifyStack={}
	},
	{
		code="local x=a' \\\\mu' \9\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='\\\\mu', lower=false})",
		comment="upper by default",
		duration=3.6000000000001e-05,
		simplifyStack={}
	},
	{
		code="local x=a' ^\\\\mu' \9\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='\\\\mu', lower=false})",
		comment="",
		duration=5.6e-05,
		simplifyStack={}
	},
	{
		code="local x=a' _\\\\mu' \9\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='\\\\mu', lower=true})",
		comment="",
		duration=0.000109,
		simplifyStack={}
	},
	{
		code="local x=a' \\\\mu \\\\nu' print(x)\9assert(#x==3 and x[1]==a and x[2]==Tensor.Index{symbol='\\\\mu', lower=false} and x[3]==Tensor.Index{symbol='\\\\nu', lower=false})",
		comment="",
		duration=0.000106,
		simplifyStack={}
	},
	{code="", comment="", duration=1.9999999999985e-06},
	{
		code="local x=a',i'\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true, derivative=','})",
		comment="commas are lower by default",
		duration=0.000107,
		simplifyStack={}
	},
	{
		code="local x=a',^i'\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false, derivative=','})",
		comment="",
		duration=7.3e-05,
		simplifyStack={}
	},
	{
		code="local x=a',_i'\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true, derivative=','})",
		comment="",
		duration=6.4999999999999e-05,
		simplifyStack={}
	},
	{
		code="local x=a'^,i'\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=false, derivative=','})",
		comment="",
		duration=7.9000000000003e-05,
		simplifyStack={}
	},
	{
		code="local x=a'_,i'\9print(x)\9assert(#x==2 and x[1]==a and x[2]==Tensor.Index{symbol='i', lower=true, derivative=','})",
		comment="",
		duration=6.5000000000003e-05,
		simplifyStack={}
	},
	{code="", comment="", duration=1.000000000001e-06},
	{code="", comment="TODO multiple indexes with commas mixed", duration=0},
	{code="", comment="TODO multiple indexes with commas mixed with multiple chars", duration=1.000000000001e-06},
	{code="", comment="", duration=1.000000000001e-06},
	{
		code="simplifyAssertNe(a'^,i', a'_,i')",
		comment="",
		duration=0.001253,
		simplifyStack={"Init", "Prune", "Expand", "Prune", "Factor", "Prune", "Tidy"}
	}
}