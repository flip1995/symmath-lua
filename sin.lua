local class = require 'ext.class'
local table = require 'ext.table'
local range = require 'ext.range'
local Function = require 'symmath.Function'

local sin = class(Function)
sin.name = 'sin'
sin.realFunc = math.sin
sin.cplxFunc = require 'symmath.complex'.sin

function sin:evaluateDerivative(deriv, ...)
	local x = table.unpack(self):clone()
	local cos = require 'symmath.cos'
	return deriv(x, ...) * cos(x)
end

function sin:reverse(soln, index)
	return require 'symmath.asin'(soln)
end

function sin:getRealDomain()
	local RealDomain = require 'symmath.set.RealDomain'
	-- (-inf,inf) => (-1,1)
	local Is = self[1]:getRealDomain()
	if Is == nil then return nil end
	return RealDomain(table.mapi(Is, function(I)	
		if I.start == -math.huge or I.finish == math.huge then return RealDomain(-1, 1, true, true) end
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

local frac = require 'symmath.op.div'
local sqrt = require 'symmath.sqrt'
sin.lookup = {
	[3] = {
		[1] = frac(sqrt(3),2),						-- cos(π/6) = sin(π/3)
	},
	[4] = {
		[1] = frac(1,sqrt(2)),						-- cos(π/4) = sin(π/4)
	},
	[5] = {
		[1] = frac(1,4) * sqrt(10 - 2 * sqrt(5)),	-- cos(3π/10) = sin(π/5)
		[2] = frac(1,4) * sqrt(10 + 2 * sqrt(5)),	-- cos(π/10) = sin(2π/5)
	},
	[6] = {
		[1] = frac(1,2),							-- cos(π/3) = sin(π/6)
	},
	[8] = {
		[1] = frac(1,2) * sqrt(2 - sqrt(2)),		-- cos(3π/8) = sin(π/8)
		[3] = frac(1,2) * sqrt(2 + sqrt(2)),		-- cos(π/8) = sin(3π/8)
	},
	[10] = {
		[1] = (sqrt(5) - 1) / 4,					-- cos(2π/5) = sin(π/10)
		[3] = (sqrt(5) + 1) / 4,					-- cos(π/5) = sin(3π/10)
	},
}

sin.rules = {
	Prune = {
		{apply = function(prune, expr)
			local symmath = require 'symmath'
			local Constant = symmath.Constant
			local Variable = symmath.Variable
			local unm = symmath.op.unm
			local mul = symmath.op.mul
			local div = symmath.op.div
		
			local theta = expr[1]

			-- sin(-x) = -sin(x)
			if unm.is(theta) then
				return -sin(theta[1])
			end
			
			-- sin(pi) => 0
			if theta == symmath.pi then return Constant(0) end

			if Constant.is(theta) then
				-- sin(0) => 0
				if theta.value == 0 then return Constant(0) end
			
				-- sin(-c) = -sin(c)
				if theta.value < 0 then return -sin(Constant(-theta.value)) end
			elseif mul.is(theta) then
				if #theta == 2 
				and theta[2] == symmath.pi 
				then
					-- sin(k * pi) => 0
					if Constant.is(theta[1]) then return Constant(0) end
				end
			
				-- sin(-c x y z) => -sin(c x y z)
				if Constant.is(theta[1])
				and theta[1].value < 0
				then
					local mulArgs = range(#theta):map(function(i)
						return theta[i]:clone()
					end)
					local c = -mulArgs:remove(1).value
					local rest = #mulArgs == 1 and mulArgs[1] or mul(mulArgs:unpack()) 
					return prune:apply(c == 1 and -sin(rest) or -sin(c * rest))
				end
			elseif div.is(theta) then
				local function handleFrac(p,q)
					p = p % (2 * q)
				
					local neg
					if p == q then return Constant(0) end
					if p > q then
						p = 2 * q - p
						neg = true
					end

					if p == q/2 then 
						return neg and Constant(-1) or Constant(1)
					end
					if p > q/2 then
						p = q - p
					end

					if p == 0 then return Constant(0) end
					
					local lookupq = sin.lookup[q]
					if lookupq then
						local lookuppq = lookupq[p]
						if lookuppq then
							return neg and -lookuppq or lookuppq
						end
					end
				end
				
				if Constant.is(theta[2])
				and symmath.set.integer:contains(theta[2])
				then
					local q = theta[2].value
					-- sin(pi / q)
					if theta[1] == symmath.pi then 
						local result = handleFrac(1,q)
						if result then return result end
					else
						-- cos((k * pi) / q)
						if mul.is(theta[1])
						and #theta[1] == 2
						and Constant.is(theta[1][1])
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

return sin
