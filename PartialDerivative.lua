local class = require 'ext.class'
local table = require 'ext.table'
local Derivative = require 'symmath.Derivative'

local PartialDerivative = class(Derivative)

PartialDerivative.name = 'PartialDerivative'
PartialDerivative.nameForExporterTable = table(PartialDerivative.nameForExporterTable)
PartialDerivative.nameForExporterTable.Console = '∂'
PartialDerivative.nameForExporterTable.LaTeX = '\\partial'

PartialDerivative.isPartial = true

return PartialDerivative
