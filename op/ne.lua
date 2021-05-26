local class = require 'ext.class'
local Equation = require 'symmath.op.Equation'

local ne = class(Equation)

ne.name = '≠'
ne.nameForExporterTable = {}
ne.nameForExporterTable.LaTeX = '\\ne'
ne.nameForExporterTable.Language = '!='
ne.nameForExporterTable.Lua = '~='
ne.nameForExporterTable.SymMath = 'ne'

function ne:switch()
	local a,b = table.unpack(self)
	return b:ne(a)
end

function ne:isTrue()
	return self[1] ~= self[2]
end

return ne
