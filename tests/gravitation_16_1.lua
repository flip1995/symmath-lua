--[[

    File: gravitation_16_1.lua

    Copyright (C) 2000-2013 Christopher Moore (christopher.e.moore@gmail.com)
	  
    This software is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
  
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
  
    You should have received a copy of the GNU General Public License along
    with this program; if not, write the Free Software Foundation, Inc., 51
    Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

--]]



local tensor = require 'symmath.tensor'

--this is a halfway step between pure symmath code and symmath+tensor code

Phi = symmath.Variable('Phi', nil, true)
rho = symmath.Variable('rho', nil, true)
P = symmath.Variable('P', nil, true)
t = symmath.Variable('t', nil, true)
x = symmath.Variable('x', nil, true)
y = symmath.Variable('y', nil, true)
z = symmath.Variable('z', nil, true)
coords = {t, x, y, z}

function cond(expr, ontrue, onfalse)
	if expr then return ontrue end
	return onfalse
end

tensor.coords{coords}

tensor.assign[[delta_$u_$v = symmath.Constant(cond($u==$v, 1, 0))]]
tensor.assign[[eta_$u_$v = symmath.simplify(delta_$u_$v * symmath.Constant(cond($u==t, -1, 1)))]]
tensor.assign[[gLL_$u_$v = symmath.simplify(eta_$u_$v - delta_$u_$v * symmath.Constant(2) * Phi)]]
-- assume diagonal matrix
tensor.assign[[gUU_$u_$v = symmath.simplify(cond($u==$v, 1/gLL_$u_$v, symmath.Constant(0)))]]
tensor.assign[[gLLL_$u_$v_$w = symmath.simplify(symmath.diff(gLL_$u_$v, $w))]]
tensor.assign[[connectionLLL_$u_$v_$w = symmath.simplify((1/2) * (gLLL_$u_$v_$w + gLLL_$u_$w_$v - gLLL_$v_$w_$u))]]
tensor.assign[[connectionULL_$u_$v_$w = gUU_$u_$r * connectionLLL_$r_$v_$w]]
print('let Phi ~ 0, but keep dPhi')
tensor.assign[[
	connectionULL_$u_$v_$w = symmath.replace(
		connectionULL_$u_$v_$w, Phi, symmath.Constant(0), function(v) return v:isa(symmath.Derivative) end
	)
]]

tensor.assign[[uU_$u = symmath.Variable('uU_$u', nil, true)]]
tensor.assign[[vU_$u = cond($u==t, symmath.Constant(1), symmath.Variable('vU_$u', nil, true))]]
print('matter stress-energy tensor')
tensor.assign[[TUU_$u_$v = (rho + P) * uU_$u * uU_$v]]

print('low velocity relativistic approximation')
for vars in tensor.rank{'u','v','w'} do
	local u,v,w = unpack(vars)
	tensor.exec([[TUU_$u_$v = symmath.replace(TUU_$u_$v, uU_$w, vU_$w)]],{u=u,v=v,w=w})
end
tensor.assign[[TUU_$u_$v = TUU_$u_$v]]

print('matter constraint')
tensor.assign[[constraint_$u = symmath.simplify(symmath.diff(TUU_$u_$v, $v) + connectionULL_$u_$a_$v * TUU_$a_$v + connectionULL_$v_$a_$v * TUU_$u_$a)]]
