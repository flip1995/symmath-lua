require 'ext'
local Function = require 'symmath.Function'
local asin = class(Function)
asin.name = 'asin'
asin.func = math.asin
function asin:diff(...)
	local x = unpack(self.xs)
	local sqrt = require 'symmath.sqrt'
	local diff = require 'symmath'.diff
	return diff(x,...) / sqrt(1 - x^2)
end
return asin

