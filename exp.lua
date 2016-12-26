local class = require 'ext.class'
local table = require 'ext.table'
local Function = require 'symmath.Function'
local exp = class(Function)
exp.name = 'exp'
--exp.func = math.exp
exp.func = require 'symmath.complex'.exp
function exp:evaluateDerivative(...)
	local x = table.unpack(self):clone()
	local diff = require 'symmath'.diff
	return diff(x,...) * self:clone()
end
return exp
