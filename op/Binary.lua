local class = require 'ext.class'
local Expression = require 'symmath.Expression'

local Binary = class(Expression)

function Binary:init(...)
	Binary.super.init(self, ...)
	if self[1] == nil or self[2] == nil then	
		local Verbose = require 'symmath.tostring.Verbose'
		error("tried to initialize a binary operation without two expressions: "..Verbose(self[1]).." and "..Verbose(self[2]))
	end
end

function Binary:getSepStr()
	local sep = self.name
	if self.implicitName then 
		sep = ' '
	elseif not self.omitSpace then 
		sep = ' ' .. sep .. ' ' 
	end
	return sep
end

return Binary