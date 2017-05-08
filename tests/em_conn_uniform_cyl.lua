#! /usr/bin/env luajit
require 'ext'
local symmath = require 'symmath'
local MathJax = require 'symmath.tostring.MathJax'
symmath.tostring = MathJax
print(MathJax.header)
local printbr = MathJax.print
MathJax.usePartialLHSForDerivative = true

for k,v in pairs(symmath) do
	if k ~= 'tostring' then _G[k] = v end
end

local t,x,y,z = vars('t', 'x', 'y', 'z')
local r = var('r', {x,y})
local phi = var('\\phi', {x,y})

Tensor.coords{
	{variables={t,r,phi,z}},
	{symbols='ABCDEF', variables={t,x,y,z}},
-- hmm something is going wrong when I include these
--	{symbols='IJKLMN', variables={x,y,z}},
--	{symbols='ijklmn', variables={r,phi,z}},
	{symbols='t', variables={t}},
	{symbols='x', variables={x}},
	{symbols='y', variables={y}},
	{symbols='r', variables={r}},
	{symbols='p', variables={phi}},
	{symbols='z', variables={z}},
}

local u = Tensor('^A', t, r * cos(phi), r * sin(phi), z)
printbr'coordinate chart'
u:print'u'
printbr()

printbr(var'u''^A_,a':eq(u'^A_,a'()))

local e = Tensor'_a^A'
e['_a^A'] = u'^A_,a'()

printbr'cartesian to cylindrical'
e:print'e'
printbr()

local eU = Tensor('^a_A', table.unpack(Matrix(table.unpack(e)):inverse():transpose()))
	:replace( (1 - sin(phi)^2) / cos(phi), cos(phi) )	-- TODO this automatically, either in :simplify() or make a new :trigSimp()
printbr'cylindrical to cartesian'
eU:print'e'
printbr()

printbr((e'_a^A' * eU'^b_A')())
printbr((e'_a^A' * eU'^a_B')())

local E = var'E'
local Ricci_flat = Tensor('_AB', table.unpack(Matrix.diagonal(E^2, E^2, E^2, -E^2))) 
printbr'cartesian Ricci tensor'
Ricci_flat:print'R' 
printbr()

local Ricci_cyl = (Ricci_flat'_AB' * e'_a^A' * e'_b^B')()
printbr'cylindrical Ricci tensor'
Ricci_cyl:print'R' 
printbr()

local Conn_flat = Tensor'^A_BC'
Conn_flat[2][1][1] = -E	-- only scales R_tt
Conn_flat[1][2][1] = E	-- scales R_xx and affects terms of R_tt
Conn_flat[1][1][2] = E	-- affects terms of R_tt
Conn_flat[2][3][3] = E	-- scales R_yy
Conn_flat[2][4][4] = E	-- scales R_zz
printbr'cartesian connection that gives rise to cartesian Ricci of EM stress-energy tensor:'
Conn_flat:print'\\Gamma'
printbr()

local Riemann_flat = Tensor'^A_BCD'
Riemann_flat['^A_BCD'] = (Conn_flat'^A_BD,C' - Conn_flat'^A_BC,D' 
	+ Conn_flat'^A_EC' * Conn_flat'^E_BD' - Conn_flat'^A_ED' * Conn_flat'^E_BC'
	- Conn_flat'^A_BE' * (Conn_flat'^E_DC' - Conn_flat'^E_CD'))()
--printbr'cartesian Riemann'
--Riemann_flat:print'R'
--printbr()

local Ricci_flat = Riemann_flat'^C_ACB'() 
printbr'cartesian Ricci'
Ricci_flat:print'R'
printbr()

printbr'partial of change of coordinate'
local de = Tensor'_b^A_c'
de['_b^A_c'] = e'_b^A_,c'()
de:print'\\partial e'
printbr()

local Conn_cyl = Tensor'^a_bc'
--Conn_cyl = (Conn_flat'^A_BC' * eU'^a_A' * e'_b^B' * e'_c^C' + eU'^a_A' * e'_b^A_,c')()
for a=1,4 do
	for b=1,4 do
		for c=1,4 do
			local sum = 0
			for A=1,4 do
				for B=1,4 do
					for C=1,4 do
						sum = (sum + (Conn_flat[A][B][C] * eU[a][A] * e[b][B] * e[c][C])())()
					end
				end
			
				sum = (sum + (eU[a][A] * de[b][A][c])())()
			end
			Conn_cyl[a][b][c] = sum()
		end
	end
end
printbr'cyl connection - via transformation'
Conn_cyl:print'\\Gamma'
printbr()

local Riemann_cyl_from_xform_conn = Tensor'^a_bcd'
Riemann_cyl_from_xform_conn['^a_bcd'] =  (Conn_cyl'^a_bd,c' - Conn_cyl'^a_bc,d' 
	+ Conn_cyl'^a_ec' * Conn_cyl'^e_bd' - Conn_cyl'^a_ed' * Conn_cyl'^e_bc'
	- Conn_cyl'^a_be' * (Conn_cyl'^e_dc' - Conn_cyl'^e_cd'))()
--printbr'cylindrical Riemann'
--Riemann_cyl_from_xform_conn:print'R'
--printbr()

local Ricci_cyl_from_xform_conn = Riemann_cyl_from_xform_conn'^c_acb'()
printbr'cylindrical Ricci from cylindrical connections transformed from cartesian connections'
Ricci_cyl_from_xform_conn:print'R'
printbr()

-- cos^2 + sin^2 = 1 => 1 - sin^2 = cos^2, 1 - 2 sin^2 = 1 - sin^2 - sin^2 = cos^2 - sin^2 = cos(2 phi)
