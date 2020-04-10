local class = require 'ext.class'
local table = require 'ext.table'
local Heaviside = require 'symmath.Heaviside'
local Function = require 'symmath.Function'

local abs = class(Function)
abs.name = 'abs'
abs.realFunc = math.abs
abs.cplxFunc = require 'symmath.complex'.abs

function abs:evaluateDerivative(deriv, ...)
	local x = self[1]
	return (Heaviside(x) - Heaviside(-x)) * deriv(x, ...)
end

function abs:reverse(soln, index)
	-- y = |x| => x = y, x = -y
	return soln, -soln
end

abs.getRealDomain = require 'symmath.set.RealInterval'.getRealDomain_evenIncreasing

abs.rules = {
	Prune = {
		{apply = function(prune, expr)
			-- unm's are converted to -1 * 's
			local mul = require 'symmath.op.mul'
			local Constant = require 'symmath.Constant'
			
			local x = expr[1]	-- abs(x)
			
			if mul.is(x) 
			and Constant.is(x[1])
			and x[1].value < 0
			then
				return prune:apply(
					mul(
						Constant(math.abs(x[1].value)),
						table.unpack(x, 2)
					)
				)
			end
		
			if Constant.is(x)
			and x.value < 0
			then
				return prune:apply(Constant(math.abs(x.value)))
			end
		
			if require 'symmath.set.set'.nonNegativeReal:contains(x) then
				return x
			end
		end},
	},
}

return abs
