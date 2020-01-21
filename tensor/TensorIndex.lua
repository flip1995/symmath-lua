-- TensorIndex represents an entry in the Tensor.variance list
local class = require 'ext.class'
local TensorIndex = class()

TensorIndex.name = 'TensorIndex'

function TensorIndex:init(args)
	self.lower = args.lower or false
	self.derivative = args.derivative
	self.symbol = args.symbol
	assert(type(self.symbol) == 'string' or type(self.symbol) == 'number' or type(self.symbol) == 'nil')
end

function TensorIndex.clone(...)
	return TensorIndex(...)	-- convert our type(x) from 'table' to 'function'
end

function TensorIndex.__eq(a,b)
	return a.lower == b.lower
	and a.derivative == b.derivative
	and a.symbol == b.symbol
end

function TensorIndex:__tostring()
	local s = ''
	if self.derivative == 'covariant' then
		s = ';' .. s
	elseif self.derivative then
		s = ',' .. s
	end
	if self.lower then s = '_' .. s else s = '^' .. s end
	if self.symbol then
		local name = self.symbol
		if type(name) == 'string' and require 'symmath'.fixVariableNames then
			name = symmath.tostring:fixVariableName(name)
		end
		return s .. name
	else
		error("TensorIndex expected a symbol or a number")
	end
end

function TensorIndex.__concat(a,b)
	return tostring(a) .. tostring(b)
end

return TensorIndex
