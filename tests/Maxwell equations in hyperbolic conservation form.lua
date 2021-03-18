#!/usr/bin/env luajit
require 'ext'
local env = setmetatable({}, {__index=_G})
if setfenv then setfenv(1, env) else _ENV = env end
require 'symmath'.setup{env=env, MathJax={title='Maxwell hyperbolic conservation law'}}

local A = var'A'
local B = var'B'
local D = var'D'
local F = var'F'
local J = var'J'
local S = var'S'
local U = var'U'
local V = var'V'
local g = var'g'
local n = var'n'
local x = var'x'
local t = var't'
local epsilon = var'\\epsilon'
local epsilonBar = var'\\bar{\\epsilon}'
local mu = var'\\mu'

printbr'state variables:'
printbr()

printbr((U'^I'):eq(Matrix{D'^i', B'^i'}:T()))
printbr()

printbr'hyperbolic balance law:'
printbr()

printbr(Integral((U'^I':diff(t) + F'^I':diff(x)), x'^4'):eq(Integral(S'^I', x'^4')))
printbr()

printbr'separating state variables:'
printbr()

printbr((D'^i_,t' - (frac(1,mu) * epsilon'^ijk' * B'_k')'_,j'):eq(0))
printbr((B'^i_,t' + (frac(1,epsilon) * epsilon'^ijk' * D'_k')'_,j'):eq(J'^i'))
printbr()

printbr((D'^i_,t' - (frac(1,mu) * epsilon'^ijk' * g'_kl' * B'^l')'_,j'):eq(0))
printbr((B'^i_,t' + (frac(1,epsilon) * epsilon'^ijk' * g'_kl' * D'^l')'_,j'):eq(J'^i'))
printbr()

printbr((D'^i_,t' 
	+ frac(1,mu^2) * mu'_,j' * epsilon'^ijk' * g'_kl' * B'^l'
	- frac(1,mu) * epsilon'^ijk_,j' * g'_kl' * B'^l'
	- frac(1,mu) * epsilon'^ijk' * g'_kl,j' * B'^l'
	- frac(1,mu) * epsilon'^ijk' * g'_kl' * B'^l_,j'
):eq(0))
printbr((B'^i_,t' 
	- frac(1,epsilon^2) * epsilon'_,j' * epsilon'^ijk' * g'_kl' * D'^l'
	+ frac(1,epsilon) * epsilon'^ijk_,j' * g'_kl' * D'^l'
	+ frac(1,epsilon) * epsilon'^ijk' * g'_kl,j' * D'^l'
	+ frac(1,epsilon) * epsilon'^ijk' * g'_kl' * D'^l_,j'
):eq(J'^i'))
printbr()

printbr((D'^i_,t' 
	+ frac(1,mu^2) * mu'_,j' * epsilon'^ijk' * g'_kl' * B'^l'
	- frac(1,mu) * (1/sqrt(g))'_,j' * epsilonBar'^ijk' * g'_kl' * B'^l'
	- frac(1,mu) * epsilon'^ijk' * g'_kl,j' * B'^l'
	- frac(1,mu) * epsilon'^ijk' * g'_kl' * B'^l_,j'
):eq(0))
printbr((B'^i_,t' 
	- frac(1,epsilon^2) * epsilon'_,j' * epsilon'^ijk' * g'_kl' * D'^l'
	+ frac(1,epsilon) * (1/sqrt(g))'_,j' * epsilonBar'^ijk' * g'_kl' * D'^l'
	+ frac(1,epsilon) * epsilon'^ijk' * g'_kl,j' * D'^l_,j'
	+ frac(1,epsilon) * epsilon'^ijk' * g'_kl' * D'^l_,j'
):eq(J'^i'))
printbr()

printbr((D'^i_,t' 
	- frac(1,mu) * epsilon'^ijk' * g'_kl' * B'^l_,j'
):eq(
	- frac(1,mu^2) * mu'_,j' * epsilon'^ijk' * g'_kl' * B'^l'
	- frac(1,mu) * frac(sqrt(g)'_,j', sqrt(g)) * epsilon'^ijk' * g'_kl' * B'^l'
	+ frac(1,mu) * epsilon'^ijk' * g'_kl,j' * B'^l'
))
printbr((B'^i_,t' 
	+ frac(1,epsilon) * epsilon'^ijk' * g'_kl' * D'^l_,j'
):eq(
	J'^i'
	+ frac(1,epsilon^2) * epsilon'_,j' * epsilon'^ijk' * g'_kl' * D'^l'
	+ frac(1,epsilon) * frac(sqrt(g)'_,j', sqrt(g)) * epsilon'^ijk' * g'_kl' * D'^l'
	- frac(1,epsilon) * epsilon'^ijk' * g'_kl,j' * D'^l_,j'
))
printbr()


printbr'Conserved quantities:'

printbr(U'^I':eq(Matrix{D'^i', B'^i'}:T()))
printbr()

printbr'Flux:'

printbr(F'^I':eq(Matrix{
	- (frac(1,mu) * epsilon'^ijk' * B'_k')'_,j',
	(frac(1,epsilon) * epsilon'^ijk' * D'_k')'_,j'
}:T()))
printbr()


printbr(
	(
		Matrix{D'^i', B'^i'}:T()'_,t'
		+ Matrix(
			{ 0, -frac(1,mu) * epsilon'^ilk' },
			{ frac(1,epsilon) * epsilon'^ilk', 0}
		) * Matrix{D'_k', B'_k'}:T()'_,j' * n'_l' * n'^j'
	):eq(
		Matrix{J'^i', 0}:T()
	)
)
printbr()

printbr'neglecting normal gradient (which should emerge as an extra extrinsic curvature source term):'
printbr()

printbr(
	(
		Matrix{D'^i', B'^i'}:T()'_,t'
		+ Matrix(
			{ 0, -frac(1,mu) * g'^im' * epsilon'_mlk' * n'^l' },
			{ frac(1,epsilon) * g'^im' * epsilon'_mlk' * n'^l', 0}
		) * Matrix{D'^k', B'^k'}:T()'_,j' * n'^j'
	):eq(
		Matrix{J'^i', 0}:T()
	)
)
printbr()

local U_def = Matrix{D'_i', B'_i'}:T()

local dF_dU_def = Matrix(
	{ 0, -frac(1,mu) * g'_im' * epsilon'^mlj' * n'_l' },
	{ frac(1,epsilon) * g'_im' * epsilon'^mlj' * n'_l', 0}
)

local S_def = Matrix{J'^i', 0}:T()

printbr'or in lowered form:'
printbr(
	(
		U_def'_,t'
		+ dF_dU_def 
		* U_def:reindex{i='j'}'_,k' * n'^k'
	):eq(
		S_def
	)
)
printbr()

-- letters don't matter so long as there are 3 of them
local xs = table{'x', 'y', 'z'}
Tensor.coords{{variables=xs}}

local D_dense = Tensor('_i', function(i) return D('_'..i) end)
local B_dense = Tensor('_i', function(i) return B('_'..i) end)
local n_l_dense = Tensor('_i', function(i) return var'(n_1)'('_'..i) end)
local n_u_dense = Tensor('^i', function(i) return var'(n_1)'('^'..i) end)

local U_dense = Matrix(
	table(D_dense):append(B_dense)
):T()

local delta = Tensor:deltaSymbol()	-- Kronecher delta

local function expandMatrix2to6(A)
	return Matrix:lambda({6,6}, function(i,j)
		local remap = {1,1,1,2,2,2}
		local replace = {1,2,3, 1,2,3}
		return A[remap[i]][remap[j]]:map(function(x)
			if x == delta'^i_j' then
				return i == j and 1 or 0
			end
		end):map(function(x)
			if TensorIndex:isa(x) then
				if x.symbol == 'i' then
					x = x:clone()
					x.symbol = assert(replace[i])
					return x
				elseif x.symbol == 'j' then
					x = x:clone()
					x.symbol = assert(replace[j])
					return x
				end
			-- TODO consider tensor rank
			elseif Tensor:isa(x) and #x:dim() == 2 then
				return assert(x[replace[i]][replace[j]])
			end
		end)()
	end)
end

local g_ll_dense = Tensor('_ab', function(i,j)
	if i > j then i,j = j,i end
	return g('_'..i..j)
end)

local sqrt_det_g = var'\\sqrt{|g|}'

local epsilon_uuu_dense = (require 'symmath.tensor.LeviCivita'():permute'^abc' / sqrt_det_g)()

local dF_dU_dense = 
	dF_dU_def
		:replace(g, g_ll_dense)
		:map(function(x)
			local a,b,c = x:match(TensorRef(epsilon, Wildcard(1), Wildcard(2), Wildcard(3))) 
			if a then
				return TensorRef(epsilon_uuu_dense, a,b,c)
			end
		end)
		--:replace(epsilon, epsilon_uuu_dense)	-- don't replace 1/epsilon used by our relative permeability
		:replace(n, n_l_dense)
		:simplify()
dF_dU_dense = expandMatrix2to6(dF_dU_dense)

printbr(F'^I':diff(U'^J'):eq(dF_dU_dense))
printbr()

printbr'with a Cartesian metric:'
dF_dU_dense = dF_dU_dense:map(function(x)
		if x == sqrt_det_g then return 1 end
		local a,b = x:match(TensorRef(g, Wildcard(1), Wildcard(2)))
		if a then
			return a.symbol == b.symbol and 1 or 0
		end
	end)()
printbr(F'^I':diff(U'^J'):eq(dF_dU_dense))
printbr()

printbr'with the normal aligned to the x-axis:'
dF_dU_dense = dF_dU_dense
	:replace(n_l_dense[1], 1)
	:replace(n_l_dense[2], 0)
	:replace(n_l_dense[3], 0)
	:simplify()
printbr(F'^I':diff(U'^J'):eq(dF_dU_dense))
printbr()

printbr[[
I think my formulation is wrong, and that's why I am getting $|n|^2 = \Sigma_i (n_i)^2$ instead of $(n_i n^i)$.
]]

local nLen = var'|n|'
--local nSq_def = (nLen^2):eq(n_l_dense'_i' * n_u_dense'^i')()
local nSq_def = (nLen^2):eq(n_l_dense'_i' * n_l_dense'_i')()	-- TODO FIXME
printbr(nSq_def)
printbr()

local eig = dF_dU_dense:eigen{dontCalcL=true}

eig.Lambda = eig.Lambda:subst(nSq_def:switch())
eig.R = eig.R:subst(nSq_def:switch())
--[[ no need for this if we aren't using normals
eig.R = (eig.R * Matrix.diagonal(
	n_l_dense[3],
	n_l_dense[3],
	n_l_dense[1] * nLen * sqrt(mu),
	n_l_dense[1] * nLen * sqrt(mu),
	n_l_dense[1] * nLen * sqrt(mu),
	n_l_dense[1] * nLen * sqrt(mu)
))()
--]]
eig.R = eig.R
	:replace(n_l_dense[1]^2 + n_l_dense[2]^2, nLen^2 - n_l_dense[3]^2)
	:replace(n_l_dense[1]^2 + n_l_dense[3]^2, nLen^2 - n_l_dense[2]^2)
	:replace(n_l_dense[2]^2 + n_l_dense[3]^2, nLen^2 - n_l_dense[1]^2)
eig.R = eig.R()

eig.L = eig.R:inverse()
eig.L = eig.L:subst(nSq_def:switch())
--eig.L = eig.L:subst((nSq_def^2)():switch())
eig.L = eig.L:subst((nSq_def * (n_l_dense[1]^2 + n_l_dense[2]^2))():switch())
eig.L = eig.L:subst((nSq_def * (n_l_dense[1]^2 + n_l_dense[3]^2))():switch())
eig.L = eig.L:subst((nSq_def * (n_l_dense[2]^2 + n_l_dense[3]^2))():switch())
eig.L = eig.L:subst((nSq_def * n_l_dense[1]^2 + n_l_dense[2]^2 * n_l_dense[3]^2)():switch())
eig.L = eig.L:subst((n_l_dense[2]^2 + n_l_dense[3]^2 - nSq_def)())
eig.L = eig.L()

local P = Matrix(table{5,6,1,2,3,4}:mapi(function(i) 
	return range(6):mapi(function(j) return i==j and 1 or 0 end)
end):unpack())

eig.R = (eig.R * P:T())()
eig.Lambda = (P * eig.Lambda * P:T())()
eig.L = (P * eig.L)()

printbr(F'^I':diff(U'^J'):eq(eig.R * eig.Lambda * eig.L))
printbr()

printbr(F'^I':diff(U'^J'):eq((eig.R * eig.Lambda * eig.L)()))
printbr()

printbr[[now in the frame of the normal:]]

local n2_l_dense = Tensor('_i', function(i) return var'(n_2)'('_'..i) end)
local n2_u_dense = Tensor('^i', function(i) return var'(n_2)'('^'..i) end)
local n3_l_dense = Tensor('_i', function(i) return var'(n_3)'('_'..i) end)
local n3_u_dense = Tensor('^i', function(i) return var'(n_3)'('^'..i) end)

local nls = table{n_l_dense, n2_l_dense, n3_l_dense}
local nus = table{n_u_dense, n2_u_dense, n3_u_dense}

local Nl = Matrix:lambda({6,6}, function(i,j)
	local u = math.floor((i-1)/3)+1
	local v = math.floor((j-1)/3)+1
	if u ~= v then return 0 end
	i = ((i-1)%3)+1
	j = ((j-1)%3)+1
	return nls[j][i]
end)

local Nu = Matrix:lambda({6,6}, function(i,j)
	local u = math.floor((i-1)/3)+1
	local v = math.floor((j-1)/3)+1
	if u ~= v then return 0 end
	i = ((i-1)%3)+1
	j = ((j-1)%3)+1
	return nus[j][i]
end)

-- if I am not lowering eps^ijk then how about I just multiply by n_i instead of n^i?
-- so multiply lower on left and right of the eigensystem
eig.R = Nl:T() * eig.R
eig.L = eig.L * Nl
eig.Lambda = (eig.Lambda * Matrix.diagonal(range(6):mapi(function() return 1/sqrt_det_g end):unpack()))()

printbr(F'^I':diff(U'^J'):eq(eig.R * eig.Lambda * eig.L))
printbr()

eig.R = eig.R()
eig.L = eig.L()

printbr(F'^I':diff(U'^J'):eq(eig.R * eig.Lambda * eig.L))
printbr()

printbr(F'^I':diff(U'^J'):eq((eig.R * eig.Lambda * eig.L)()))
printbr()


local n = #dF_dU_dense
local vs = range(0,n-1):map(function(i) return var('v_'..i) end)
local evrxform = (eig.R * Matrix:lambda({n,1}, function(i) return vs[i] end)):simplifyAddMulDiv():tidy()
local evlxform = (eig.L * Matrix:lambda({n,1}, function(i) return vs[i] end)):simplifyAddMulDiv():tidy()
printbr('R(v) = ', evrxform)
printbr('L(v) = ', evlxform)

local args = table(vs)
	:append(table.mapi(nls[1], function(xi,i) return {['n_l.'..xs[i]] = xi} end))
	:append(table.mapi(nls[2], function(xi,i) return {['n2_l.'..xs[i]] = xi} end))
	:append(table.mapi(nls[3], function(xi,i) return {['n3_l.'..xs[i]] = xi} end))
	:append(table.mapi(nus[1], function(xi,i) return {['n_u.'..xs[i]] = xi} end))
	:append(table.mapi(nus[2], function(xi,i) return {['n2_u.'..xs[i]] = xi} end))
	:append(table.mapi(nus[3], function(xi,i) return {['n3_u.'..xs[i]] = xi} end))
	:append{
		{sqrt_epsilon = sqrt(epsilon)},
		{sqrt_mu = sqrt(mu)},
		{sqrt_det_g  =  sqrt_det_g},
	}
local evrcode = export.C:toCode{output={evrxform}, input=args}
local evlcode = export.C:toCode{output={evlxform}, input=args}
printbr'right transform code:'
printbr('<pre>'..evrcode..'</pre>')
printbr'left transform code:'
printbr('<pre>'..evlcode..'</pre>')
