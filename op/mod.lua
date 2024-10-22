local table = require 'ext.table'
local Binary = require 'symmath.op.Binary'

local mod = Binary:subclass()

mod.precedence = 3

mod.name = '%'
mod.nameForExporterTable = {}
mod.nameForExporterTable.LaTeX = '\\mod'

mod.rules = {
	Prune = {
		{apply = function(prune, expr)
			symmath = symmath or require 'symmath'
			local mul = symmath.op.mul
			local pow = symmath.op.pow
			local Constant = symmath.Constant

			local denomBase = expr[2]
			local denomPower = Constant(1)
			if pow:isa(expr[2]) then
				denomBase, denomPower = table.unpack(expr[2])
			end
			-- print('denomBase=', denomBase)
			-- print('denomPower=', denomPower)

			local nums
			if mul:isa(expr[1]) then
				nums = table(expr[1])
			else
				nums = table{expr[1]}
			end

			-- print('nums=', nums)
			local numBases = table()
			local numPowers = table()
			for i=1,#nums do
				local x = nums[i]
				local base, power
				if pow:isa(x) then
					base, power = table.unpack(x)
				else
					base, power = x, Constant(1)
				end
				numBases[i] = assert(base)
				numPowers[i] = assert(power)
			end

			for i=1,#numBases do
				-- print('numBases[' .. i .. ']=', numBases[i])
				-- print('numPowers[' .. i .. ']=', numPowers[i])
				-- print('const power = ', Constant:isa(numPowers[i]))
				if numBases[i] == denomBase
				and Constant:isa(numPowers[i])
				and Constant:isa(denomPower)
				and numPowers[i].value >= denomPower.value
				then
					return Constant(0)
				end

				if Constant:isa(numBases[i])
				and Constant:isa(denomBase)
				then
					assert(numPowers[i] == Constant(1))
					assert(denomPower == Constant(1))
					if numBases[i].value % denomBase.value == 0 then
						return Constant(0)
					end
				end
			end
		end},
	},
}

--[[
d/dx[a%b] is da/dx, except when a = b * k for some integer k
--]]
function mod:evaluateDerivative(deriv, ...)
	local a, b = table.unpack(self)
	a = a:clone()
	return deriv(a, ...)
end

return mod
