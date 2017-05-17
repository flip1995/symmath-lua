local class = require 'ext.class'
local Function = require 'symmath.Function'

local tanh = class(Function)
tanh.name = 'tanh'
tanh.func = math.tanh

function tanh:evaluateDerivative(deriv, ...)
	local x = table.unpack(self)
	local cosh = require 'symmath.cosh'
	return deriv(x, ...) / cosh(x)^2
end

function tanh:reverse(soln, index)
	return require 'symmath.atanh'(soln)
end

return tanh
