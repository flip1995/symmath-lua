require 'ext'
local Function = require 'symmath.Function'
local sinh = class(Function)
sinh.name = 'sinh'
sinh.func = math.sinh
function sinh:diff(...)
	local x = unpack(self.xs)
	local cosh = require 'symmath.cosh'
	local diff = require 'symmath'.diff
	return diff(x,...) * cosh(x)
end
return sinh

