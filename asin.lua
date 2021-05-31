local class = require 'ext.class'
local Function = require 'symmath.Function'
local symmath

local asin = class(Function)
asin.name = 'asin'
asin.realFunc = math.asin
asin.cplxFunc = require 'symmath.complex'.asin

function asin:evaluateDerivative(deriv, ...)
	local x = table.unpack(self):clone()
	symmath = symmath or require 'symmath'
	return deriv(x, ...) / symmath.sqrt(1 - x^2)
end

function asin:reverse(soln, index)
	symmath = symmath or require 'symmath'
	return symmath.sin(soln)
end

asin.getRealRange = require 'symmath.set.RealSubset'.getRealDomain_pmOneInc

asin.evaluateLimit = require 'symmath.Limit'.evaluateLimit_plusMinusOne_to_plusMinusInf

asin.rules = {
	Prune = {
		{apply = function(prune, expr)
			symmath = symmath or require 'symmath'
			local Constant = symmath.Constant

			local x = expr[1]

			if Constant.isValue(x, 0) then
				return Constant(0)
			end
			
			if symmath.set.RealSubset(-math.huge, -1, false, true):contains(x) then
				return symmath.invalid
			end
			
			if symmath.set.RealSubset(1, math.huge, true, false):contains(x) then
				return symmath.invalid
			end
		end},
	},
}

return asin
