local class = require 'ext.class'
local table = require 'ext.table'
local range = require 'ext.range'
local Function = require 'symmath.Function'

local cos = class(Function)

cos.name = 'cos'
cos.realFunc = math.cos
cos.cplxFunc = require 'symmath.complex'.cos

function cos:evaluateDerivative(deriv, ...)
	local x = table.unpack(self):clone()
	local sin = require 'symmath.sin'
	return -deriv(x,...) * sin(x)
end

function cos:reverse(soln, index)
	return require 'symmath.acos'(soln)
end

function cos:getRealDomain()
	local RealDomain = require 'symmath.set.RealDomain'
	-- (-inf,inf) => (-1,1)
	local Is = self[1]:getRealDomain()
	if Is == nil then return nil end
	return RealDomain(table.mapi(Is, function(I)
		if I.start == -math.huge or I.finish == math.huge then return RealDomain(-1, 1, true, true) end
		-- here I'm going to add pi/2 and then just copy the sin:getRealDomain() code
		I.start = I.start + math.pi/2
		I.finish = I.finish + math.pi/2
		-- map by quadrant
		local startQ = math.floor(I.start / (math.pi/2))
		local finishQ = math.floor(I.finish / (math.pi/2))
		local startQmod4 = startQ % 4
		local finishQmod4 = finishQ % 4
		local behavior
		if startQ == finishQ then
			if startQmod4 == 0 or startQmod4 == 3 then
				behavior = 0	-- all inc
			elseif startQmod4 == 1 or startQmod4 == 2 then
				behavior = 1	-- all dec
			else
				error'here'
			end
		elseif startQ + 1 == finishQ then
			if startQmod4 == 3 then
				behavior = 0	-- all inc
			elseif startQmod4 == 0 then	
				behavior = 2	-- inc dec
			elseif startQmod4 == 1 then	-- so finishQmod4 == 2
				behavior = 1	-- all dec
			elseif startQmod4 == 2 then
				behavior = 3	-- dec inc
			else
				error'here'
			end
		elseif startQ + 2 == finishQ then
			if startQmod4 == 3 or startQmod4 == 0 then
				behavior = 2	-- inc dec
			elseif startQmod4 == 1 or startQmod4 == 2 then
				behavior = 3	-- dec inc
			else
				error'here'
			end
		elseif startQ + 3 >= finishQ then
			return RealDomain(-1, 1, true, true)
		end
		if behavior == 0 then
			-- all increasing
			return RealDomain(math.sin(I.start), math.sin(I.finish), I.includeStart, I.includeFinish)
		elseif behavior == 1 then
			-- all decreasing
			return RealDomain(math.sin(I.finish), math.sin(I.start), I.includeFinish, I.includeStart)
		elseif behavior == 2 then
			-- increasing then decreasing
			return RealDomain(
				math.min(math.sin(I.start), math.sin(I.finish)), math.sin(math.pi/2),
				I.includeStart or I.includeFinish, true)	
		elseif behavior == 3 then
			-- decreasing then increasing
			return RealDomain(
				math.sin(3*math.pi/2), math.max(math.sin(I.start), math.sin(I.finish)),
				true, I.includeStart or I.includeFinish)
		else
			error'here'
		end
		return RealDomain(-1, 1, true, true)
	end))
end

-- assume irreducible form, so there exists no prime k such that k divides p and k divides q
-- lookup[denom][num] = cos(denom * π / num)
-- excluding cos((0 * π) / q) = 1 and cos((q * π) / q) = -1
-- and cos(((q + k) π) / q) = cos(((q - k) π) / q)
-- and for even q, cos( ((q/2) π) / q) = 0
-- https://en.wikipedia.org/wiki/Trigonometric_constants_expressed_in_real_radicals
-- TODO generate from half-angles and third-angles?
local frac = require 'symmath.op.div'
local sqrt = require 'symmath.sqrt'
cos.lookup = {
	[3] = {
		[1] = frac(1,2),							-- cos(π/3) = sin(π/6)
	},
	[4] = {
		[1] = frac(1,sqrt(2)),						-- cos(π/4) = sin(π/4)
	},
	[5] = {
		[1] = (sqrt(5) + 1) / 4,					-- cos(π/5) = sin(3π/10)
		[2] = (sqrt(5) - 1) / 4,					-- cos(2π/5) = sin(π/10)
	},
	[6] = {
		[1] = frac(sqrt(3),2),						-- cos(π/6) = sin(π/3)
	},
	[8] = {
		[1] = frac(1,2) * sqrt(2 + sqrt(2)),		-- cos(π/8) = sin(3π/8)
		[3] = frac(1,2) * sqrt(2 - sqrt(2)),		-- cos(3π/8) = sin(π/8)
	},
	[10] = {
		[1] = frac(1,4) * sqrt(10 + 2 * sqrt(5)),	-- sin(2π/5) = cos(π/10)
		[3] = frac(1,4) * sqrt(10 - 2 * sqrt(5)),	-- sin(π/5) = cos(3π/10)
	},
}

cos.rules = {
	Prune = {
		{apply = function(prune, expr)
			local symmath = require 'symmath'
			local Constant = symmath.Constant
			local Variable = symmath.Variable
			local unm = symmath.op.unm
			local mul = symmath.op.mul
			local div = symmath.op.div
		
			local theta = expr[1]

			-- cos(-x) = cos(x)
			if unm:isa(theta) then
				return cos(theta[1])
			end
				
			-- cos(pi) => -1
			if theta == symmath.pi then return Constant(-1) end

			if Constant:isa(theta) then
				-- cos(0) => 1
				if theta.value == 0 then return Constant(1) end
			
				-- cos(-c) = cos(c)
				if theta.value < 0 then return cos(Constant(-theta.value)) end
			elseif mul:isa(theta) then
				if #theta == 2 
				and theta[2] == symmath.pi 
				then
					-- cos(k * pi) for even k => 1
					if symmath.set.evenInteger:contains(theta[1]) then return Constant(1) end
					-- cos(k * pi) for odd k => -1
					if symmath.set.oddInteger:contains(theta[1]) then return Constant(-1) end
				end
			
				-- cos(-c x y z) => cos(c x y z)
				if Constant:isa(theta[1])
				and theta[1].value < 0
				then
					local mulArgs = range(#theta):map(function(i)
						return theta[i]:clone()
					end)
					local c = -mulArgs:remove(1).value
					local rest = #mulArgs == 1 and mulArgs[1] or mul(mulArgs:unpack()) 
					return prune:apply(c == 1 and cos(rest) or cos(c * rest))
				end
			elseif div:isa(theta) then
				local function handleFrac(p,q)
					p = p % (2 * q)

					if p == q then return Constant(-1) end
					if p > q then
						p = 2 * q - p
					end
					
					local neg
					if p == q/2 then return Constant(0) end
					if p > q/2 then
						neg = true
						p = q - p
					end
					
					if p == 0 then return Constant(1) end

					local lookupq = cos.lookup[q]
					if lookupq then
						local lookuppq = lookupq[p]
						if lookuppq then
							return neg and -lookuppq or lookuppq
						end
					end
				end

				if Constant:isa(theta[2])
				and symmath.set.integer:contains(theta[2])
				then
					local q = theta[2].value
					-- cos(pi / q)
					if theta[1] == symmath.pi then 
						local result = handleFrac(1,q) 
						if result then return result end
					else
						-- cos((k * pi) / q)
						if mul:isa(theta[1])
						and #theta[1] == 2
						and Constant:isa(theta[1][1])
						and symmath.set.integer:contains(theta[1][1])
						and theta[1][2] == symmath.pi
						then
							local result = handleFrac(theta[1][1].value, q)
							if result then return result end
						end
					end
				end
			end
		end},
	},
}

return cos
