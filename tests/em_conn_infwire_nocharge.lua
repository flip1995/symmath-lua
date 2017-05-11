#! /usr/bin/env luajit
require 'ext'
local _ENV = _ENV or getfenv()
require 'symmath'.setup{env=_ENV, implicitVars=true}
require 'symmath.tostring.MathJax'.setup{env=_ENV, usePartialLHSForDerivative=true}

local RiemannExpr = Gamma'^a_bd,c' - Gamma'^a_bc,d' 
	+ Gamma'^a_ec' * Gamma'^e_bd' - Gamma'^a_ed' * Gamma'^e_bc'
	- Gamma'^a_be' * (Gamma'^e_dc' - Gamma'^e_cd')

Tensor.coords{
	{variables={t,r,phi,z}},
	{symbols='ijklmn', variables={r,phi,z}},
	{symbols='t', variables={t}},
	{symbols='r', variables={r}},
	{symbols='phi', variables={phi}},
	{symbols='z', variables={z}},
}

local Conn = Tensor'^a_bc'

--[[
Conn[2][1][1] = var('a',{r})
Conn[1][2][1] = var('b',{r})
Conn[1][1][2] = var('b',{r})
Conn[2][3][3] = var('c',{r})
Conn[2][4][4] = var('d',{r})
--]]
-- -db/dr - b^2 = 4 I^2 / r^2
-- let b = exp(int p(r))
-- db/dr = p(r) exp(int p(r))
-- -p(r) b - b^2 = q(r)
-- b^2 + p(r) b + q(r) = 0
-- b = (-p +- sqrt(p^2 - 4 q)) / 2
-- let p = 2 sqrt(q), so p^2 = 4 q and the denominator goes away
-- b = -p / 2 = -2 sqrt(q) / 2 = -sqrt(q) = -2 I / r
-- [[
Conn[2][1][1] = var('a',{r})
Conn[1][2][1] = -2 * I / r
Conn[1][1][2] = -2 * I / r
Conn[2][3][3] = var('c',{r})
Conn[2][4][4] = var('d',{r})
--]]

--[[
Conn[2][1][1] = -frac(4,3) * I^2 / r^3
Conn[1][2][1] = a
Conn[1][1][2] = a
Conn[2][3][3] = -4 * I^2 / r^2
Conn[2][4][4] = 4 * I^2 / r^4
--Conn[3][2][2] = 4 * phi * I^2 / r^4
--]]

--[[ this works, but I want to get rid of C^t_tt
Conn[2][1][1] = -frac(4,3) * I^2 / r^3		-- R_tt
Conn[1][1][1] = Constant(1)										-- R_pp, R_zz
Conn[1][3][3] = -4 * I^2 / r^2					-- R_pp
Conn[1][4][4] = 4 * I^2 / r^4 				-- R_zz
Conn[3][2][2] = 4 * phi * I^2 / r^4			-- R_rr
--]]

printbr'manual connection:'
Conn:printElem'\\Gamma'
printbr()

local RiemannForConn = Tensor'^a_bcd'
RiemannForConn['^a_bcd'] = RiemannExpr:replace(Gamma, Conn)()
local RicciForConn = RiemannForConn'^c_acb'()
printbr'Ricci from connection:'
RicciForConn:print'R'
printbr()

-- stress energy of EM field around an infinite wire
-- looking at the case where there is no charge in the wire (lambda = 0), but there is a current (I != 0)
-- taken from em_conn_infwire.lua
local RicciEM = (Tensor('_ab', table.unpack(Matrix.diagonal(1, 1, -r^2, 1))) * 4 * I^2 / r^4)()
print'vs $8 \\pi \\times$ EM stress-energy tensor = Ricci tensor'
RicciEM:print'R' 
printbr()




printbr'now the same thing for no-current only-charge'




local Conn = Tensor'^a_bc'

-- [[ works, but looks ugly, but works
--Conn[2][1][1] = -a / r
--Conn[1][2][1] = b / r
--Conn[1][1][2] = b / r
--Conn[2][3][3] = c * r
--Conn[2][4][4] = d / r
-- b (1 - b) = -4 lambda^2
-- b - b^2 = -4 lambda^2
-- b^2 - b - 4 lambda^2 = 0
-- b = (1 +- sqrt(1 + 16 lambda^2)) / 2
local b = ((1 + sqrt(1 + 16 * lambda^2)) / 2)()
-- a (1 + b) = 4 lambda^2
local a = (4 * lambda^2 / (1 + b))()
-- c (1 + b) = 4 * lambda^2
local c = a
-- d (b - 1) = 4 * lambda^2
local d = (4 * lambda^2 / (b - 1))()
Conn[2][1][1] = -a / r
Conn[1][2][1] = b / r
Conn[1][1][2] = b / r
Conn[2][3][3] = c * r
Conn[2][4][4] = d / r
Conn = Conn()
--]]

--[[ works but I don't like the C^t_tt term
Conn[2][1][1] = - 4 * lambda^2 / r		-- R_tt
Conn[1][1][1] = Constant(1)										-- R_pp, R_zz
Conn[1][3][3] = 4 * lambda^2					-- R_pp
Conn[1][4][4] = 4 * lambda^2 / r^2				-- R_zz
Conn[3][2][2] = -4 * phi * lambda^2 / r^2			-- R_rr
--]]

printbr'manual connection:'
Conn:printElem'\\Gamma'
printbr()

local RiemannForConn = Tensor'^a_bcd'
RiemannForConn['^a_bcd'] = RiemannExpr:replace(Gamma, Conn)()
local RicciForConn = RiemannForConn'^c_acb'()
printbr'Ricci from connection:'
RicciForConn:print'R'
printbr()

-- stress energy of EM field around an infinite wire
-- looking at the case where there is no current in the wire (I = 0), but there is a chage (lambda != 0)
-- taken from em_conn_infwire.lua
local RicciEM = (Tensor('_ab', table.unpack(Matrix.diagonal(1, -1, r^2, 1))) * 4 * lambda^2 / r^2)()
print'vs $8 \\pi \\times$ EM stress-energy tensor = Ricci tensor'
RicciEM:print'R' 
printbr()
