#!/usr/bin/env luajit
--[[

    File: polar_geodesic.lua 

    Copyright (C) 2000-2014 Christopher Moore (christopher.e.moore@gmail.com)
	  
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

local table = require 'ext.table'
local symmath = require 'symmath'
local MathJax = require 'symmath.tostring.MathJax'
symmath.tostring = MathJax
print(MathJax.header)
local printbr = MathJax.print

local Tensor = symmath.Tensor
local var = symmath.var
local vars = symmath.vars

local t,x,y,z = vars('t','x','y','z')
local r,phi,theta = vars('r','\\phi','\\theta')

local alpha = var('\\alpha', {r})
local omega = var('\\omega', {t, r})

-- I need a better way of (1) defining functions, and (2) keeping track of their derivatives
local class = require 'ext.class'

local delta2 = symmath.Matrix({1,0}, {0,1})
local delta3 = symmath.Matrix({1,0,0}, {0,1,0}, {0,0,1})
local eta3 = symmath.Matrix({-1,0,0}, {0,1,0}, {0,0,1})
local eta4 = symmath.Matrix({-1,0,0,0}, {0,1,0,0}, {0,0,1,0}, {0,0,0,1})

for _,info in ipairs{
	{
		title = 'polar',
		coords = {r,phi},
		embedded = {x,y},
		flatMetric = delta2,
		chart = function() 
			return Tensor('^I', r * symmath.cos(phi), r * symmath.sin(phi))
		end,
	},
	{
		title = 'polar, anholonomic, normalized',
		coords = {r,phi},
		embedded = {x,y},
		flatMetric = delta2,
		chart = function()
			return Tensor('^I', r * symmath.cos(phi), r * symmath.sin(phi))
		end,
		basis = function(self, x, i)
			return ({
				function(x) return x:diff(r) end,
				function(x) return x:diff(phi) / r end,
			})[i](x)
		end,
	},
	{
		title = 'cylinder surface',
		coords = {phi,z},
		embedded = {x,y,z},
		flatMetric = delta3,
		chart = function()
			return Tensor('^I', r * symmath.cos(phi), r * symmath.sin(phi), z)
		end,
	},
	{
		title = 'cylinder',
		coords = {r,phi,z},
		embedded = {x,y,z},
		flatMetric = delta3,
		chart = function()
			return Tensor('^I', r * symmath.cos(phi), r * symmath.sin(phi), z)
		end,
	},
	{
		title = 'spiral',
		coords = {r,phi},
		embedded = {x,y},
		flatMetric = delta2,
		chart = function()
			return Tensor('^I',
				r * symmath.cos(phi + symmath.log(r)),
				r * symmath.sin(phi + symmath.log(r))
			)
		end,
	},
	{
		title = 'polar and time, constant rotation',
		coords = {t,r,phi},
		embedded = {t,x,y},
		flatMetric = eta3,
		chart = function()
			return Tensor('^I', 
				t,
				r * symmath.cos(phi + t),
				r * symmath.sin(phi + t))
		end,
	},
	{
		title = 'polar and time, lapse varying in radial',
		coords = {t,r,phi},
		embedded = {t,x,y},
		flatMetric = eta3,
		chart = function()
			return Tensor('^I',
				t * alpha,
				r * symmath.cos(phi),
				r * symmath.sin(phi))
		end,
	},
--[[
	{
		title = 'polar and time, lapse varying in radial, rotation varying in time and radial',
		coords = {t,r,phi},
		embedded = {t,x,y},
		flatMetric = eta3,
		chart = function()
			return Tensor('^I', 
				t,
				r * symmath.cos(phi + omega),
				r * symmath.sin(phi + omega)
			)
		end,
	},
--]]
	{
		title = 'spherical',
		coords = {r,theta,phi},
		embedded = {x,y,z},
		flatMetric = delta3,
		chart = function()
			return Tensor('^I', 
				r * symmath.sin(theta) * symmath.cos(phi),
				r * symmath.sin(theta) * symmath.sin(phi),
				r * symmath.cos(theta))
		end,
	},
	{
		title = 'spherical and time',
		coords = {t,r,theta,phi},
		embedded = {t,x,y,z},
		flatMetric = eta4,
		chart = function()
			return Tensor('^I', 
				t,
				r * symmath.sin(theta) * symmath.cos(phi),
				r * symmath.sin(theta) * symmath.sin(phi),
				r * symmath.cos(theta))
		end,
	},
	{
		title = 'spherical and time, lapse varying in radial',
		coords = {t,r,theta,phi},
		embedded = {t,x,y,z},
		flatMetric = eta4,
		chart = function()
			return Tensor('^I', 
				t * alpha,
				r * symmath.sin(theta) * symmath.cos(phi),
				r * symmath.sin(theta) * symmath.sin(phi),
				r * symmath.cos(theta))
		end,
	},
--[[ this is schwarzschild, for alpha = 1/sqrt(1 - R/r)
	{
		title = 'spherical and time, lapse varying in radial',
		coords = {t,r,theta,phi},
		embedded = {t,x,y,z},
		flatMetric = eta4,
		chart = function()
			return Tensor('^I', 
				t * alpha,
				r/alpha * symmath.sin(theta) * symmath.cos(phi),
				r/alpha * symmath.sin(theta) * symmath.sin(phi),
				r/alpha * symmath.cos(theta))
		end,
	},
--]]
} do
	print('<h3>'..info.title..'</h3>')

	Tensor.coords{
		{variables=info.coords},
		{variables=info.embedded, symbols='IJKLMN', metric=info.flatMetric}
	}

	printbr('coordinates:', table.unpack(info.coords))
	printbr('embedding:', table.unpack(info.embedded))

	local eta = Tensor('_IJ', unpack(info.flatMetric))
	printbr'flat metric:'
	printbr(var'\\eta''_IJ':eq(eta'_IJ'()))
	printbr()

	local u = info.chart()
	printbr'coordinate chart:'
	printbr(var'u''^I':eq(u'^I'()))
	printbr()

	local e = Tensor'_u^I'
	if info.basis then
		printbr'anholonomic embedded:'
		for i,ui in ipairs(info.coords) do
			local e_i = info:basis(u,i)()
			--[[
			-- sure is messy to just put a phi in the index ...
			local TensorIndex = reqire 'symmath.tensor.TensorIndex'
			-- you can't just __call with TensorIndex, because then it checks variance (before simplify() even)
			local TensorRef = reqire 'symmath.tensor.TensorRef'
			printbr(TensorRef(var'e',TensorIndex{lower=true, symbol=ui.name},TensorIndex{lower=false, symbol='I'}):eq(e_i))
			--]]
			-- assumes e internal structure is e_u^I
			-- e['_i^I'] = e_i'^I' 
			for I=1,#info.embedded do
				e[i][I] = e_i[I]
			end
		end
		printbr(var'e''_u^I':eq(e'_u^I'()))
	else
		printbr'holonomic embedded:'
		e['_u^I'] = u'^I_,u'()
		printbr(var'e''_u^I':eq(var'u''^I_,u'):eq(u'^I_,u'()):eq(e'_u^I'()))
	end
	printbr()

	local c
	if info.basis then
		c = Tensor'_ab^c'
		printbr()
		printbr'commutation coefficients:'
		for i,ui in ipairs(info.coords) do
			for j,uj in ipairs(info.coords) do
				local psi = var('\\psi', info.coords)
				local diff = info:basis(info:basis(psi,i),j) - info:basis(info:basis(psi,j),i)
				printbr('$[',ui.name,',',uj.name,'] =$',diff:eq(diff()))
				diff = diff()
				--printbr('factor division',diff)
				local dpsi = table.map(info.coords, function(uk) return psi:diff(uk) end)
				--printbr('dpsi', dpsi:unpack())
				local A,b = symmath.factorLinearSystem({diff}, dpsi)
				-- now extract psi:diff(uk)
				-- ... and divide by e_k to get the correct coefficient
				-- TODO pray that the anholonomic basis isn't a linear combination of coordinates ...
				assert(b[1][1] == symmath.Constant(0))
				for k in ipairs(info.coords) do
					local coeff = (A[1][k] * dpsi[k] / info:basis(psi, k))()
					-- assert dphi is nowhere in coeff ...
					c[i][j][k] = coeff 
				end
			end
		end
		printbr(var'c''_ab^c':eq(c))
	end

	local g = (e'_u^I' * e'_v^J' * eta'_IJ')()
	
	-- TODO automatically do this ...
	g = g:map(function(expr)
		if symmath.powOp.is(expr)
		and expr[2] == symmath.Constant(2)
		and symmath.cos.is(expr[1])
		then
			return 1 - symmath.sin(expr[1][1]:clone())^2
		end
	end)()
	
	local props = require 'symmath.diffgeom'(g, nil, c)
	printbr(var'g''_uv':eq(var'e''_u^I' * var'e''_v^J' * var'\\eta''_IJ'))
	printbr(var'\\Gamma''_abc':eq(symmath.divOp(1,2)*(var'g''_ab,c' + var'g''_ac,b' - var'g''_bc,a' + var'c''_abc' + var'c''_acb' - var'c''_bca')))
	props:print(printbr)
	local Gamma = props.Gamma

	local dx = Tensor('^u', function(u)
		return var('\\dot{' .. info.coords[u].name .. '}')
	end)
	local d2x = Tensor('^u', function(u)
		return var('\\ddot{' .. info.coords[u].name .. '}')
	end)
	printbr'geodesic:'
	-- TODO unravel equaliy, or print individual assignments
	printbr(((d2x'^a' + Gamma'^a_bc' * dx'^b' * dx'^c'):eq(Tensor'^u'))())
	printbr()
end

print(MathJax.footer)
