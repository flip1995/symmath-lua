local class = require 'ext.class'
local table = require 'ext.table'
local Binary = require 'symmath.op.Binary'

local mul = class(Binary)
mul.implicitName = true
mul.precedence = 3
mul.name = '*'

function mul:init(...)
	mul.super.init(self, ...)

	-- auto flatten any muls
	for i=#self,1,-1 do
		if mul.is(self[i]) then
			local x = table.remove(self, i)
			for j=#x,1,-1 do
				table.insert(self, i, x[j])
			end
		end
	end
end

function mul:evaluateDerivative(deriv, ...)
	local add = require 'symmath.op.add'
	local sums = table()
	for i=1,#self do
		local terms = table()
		for j=1,#self do
			if i == j then
				terms:insert(deriv(self[j]:clone(), ...))
			else
				terms:insert(self[j]:clone())
			end
		end
		if #terms == 1 then
			sums:insert(terms[1])
		else
			sums:insert(mul(terms:unpack()))
		end
	end
	if #sums == 1 then
		return sums[1]
	else
		return add(sums:unpack())
	end
end

mul.removeIfContains = require 'symmath.commutativeRemove'

-- now that we've got matrix multilpication, this becomes more difficult...
-- non-commutative objects (matrices) need to be compared in-order
-- commutative objects can be compared in any order
function mul.match(a, b, matches)
	local Wildcard = require 'symmath.Wildcard'
	local Constant = require 'symmath.Constant'
local SingleLine = require 'symmath.export.SingleLine'

	matches = matches or table()
	if b.wildcardMatches then
		if not b:wildcardMatches(a, matches) then return false end
--print("matching entire expr index "..b.index.." to "..SingleLine(a))	
		return (matches[1] or true), table.unpack(matches, 2, table.maxn(matches))
	else
		if not mul.is(a) or not mul.is(b) then return false end
	end	
	
	local a = table(a)
	local b = table(b)
	
	-- compare things order-independent, remove as you go
	-- skip wildcards, do those last
	for i=#a,1,-1 do
		local ai = a[i]
		-- non-commutative compare...
		if not ai.mulNonCommutative then
			-- table.find uses == uses __eq which ... should ... only pick j if it is mulNonCommutative as well (crossing fingers, it's based on the equality implementation)
			--local j = b:find(ai)
			local j
			for _j=1,#b do
				local bj = b[_j]
				if not Wildcard.is(bj)
				-- if bj does match then this will fill in the appropriate match and return 'true'
				-- if it fails to match then it won't fill in the match and will return false
				and bj:match(ai, matches)
				then
					j = _j
					break
				end
			end
			if j then
				a:remove(i)
				b:remove(j)
			end
		end
	end

--[[
local SingleLine = require 'symmath.export.SingleLine'
--print("what's left after matching commutative non-wildcards:")
--print('a', a:mapi(SingleLine):concat', ')
--print('b', b:mapi(SingleLine):concat', ')
--]]

	-- now compare what's left in-order (since it's non-commutative)
	-- skip wildcards, do those last
	local function checkMatch(a,b, matches)
		matches = matches or table()
		a = table(a)
		b = table(b)
		
--print("checking match of what's left with "..#a.." elements")

		if #a == 0 and #b == 0 then 
--print("matches - returning true")
			return matches[1] or true, table.unpack(matches, 2, table.maxn(matches))
		end
		
		-- #a == 0 is fine if b is full of nothing but wildcards
		if #b == 0 and #a > 0 then
--print("has remaining elements -- returning false")
			return false 
		end
		
		-- TODO bi isn't necessarily a wildcard -- it could be an 'mulNonCommutative' term (though nothing does this for mulition yet)
		if #a == 0 and #b ~= 0 then
			-- TODO verify that the matches are equal
			for _,bi in ipairs(b) do
				if not Wildcard.is(bi) then
--print("expected bi to be a Wildcard, found "..SingleLine(bi))
					return false
				end
				if bi.atLeast and bi.atLeast > 0 then
--print("remaining Wildcard expected an expression when none are left, failing")
					return false
				end
				if matches[bi.index] then
--print("matches["..bi.index.."] tried to set to Constant(1), but it already exists as "..SingleLine(matches[bi.index]).." -- failing")
					if matches[bi.index] ~= Constant(1) then return false end
				else
--print("setting matches["..bi.index.."] to Constant(1)")
					matches[bi.index] = Constant(1)
				end
			end
		end
		if not Wildcard.is(b[1]) then
			local a1 = a:remove(1)
			local b1 = b:remove(1)

--print"isn't a wildcard -- recursive call of match on what's left"
			-- hmm, what if there's a sub-expression that has wildcard
			-- then we need matches
			-- then we need to push/pop matches
		
			local firstsubmatch = table()
			if not a1:match(b1, firstsubmatch) then
--print("first match didn't match - failing")				
				return false 
			end
		
			for i=1,table.maxn(firstsubmatch) do
				if firstsubmatch[i] ~= nil then
					if matches[i] ~= nil then
						if matches[i] ~= firstsubmatch[i] then 
--print("first submatches don't match previous matches - index "..i.." "..SingleLine(matches[i]).." vs "..SingleLine(firstsubmatch[i]).." - failing")
							return false 
						end
					else
--print("matching mul subexpr from first match "..SingleLine(a1).." index "..b.index.." to "..SingleLine(a))	
						matches[i] = firstsubmatch[i]
					end
				end
			end


			local restsubmatch = table()
			if not checkMatch(a, b, restsubmatch) then
--print("first match didn't match - failing")				
				return false 
			end

			for i=1,table.maxn(restsubmatch) do
				if restsubmatch[i] ~= nil then
					if matches[i] ~= nil then
						if matches[i] ~= restsubmatch[i] then 
--print("first submatches don't match previous matches - index "..i.." "..SingleLine(matches[i]).." vs "..SingleLine(firstsubmatch[i]).." - failing")
							return false 
						end
					else
--print("matching mul subexpr from first match "..SingleLine(a1).." index "..b.index.." to "..SingleLine(a))	
						matches[i] = restsubmatch[i]
					end
				end
			end


			-- overlay match matches on what we have already matched so far
			-- TODO what about verifying overlapping wildcard indexes are still equal?
			return matches
		end

--print("before checking remaining terms, our matches is: "..table.mapi(matches, SingleLine):concat', ')

		-- now if we have a wildcard ... try all 0-n possible matches of it
		local b1 = b:remove(1)
		for matchSize=math.min(#a, b1.atMost or math.huge),(b1.atLeast or 0),-1 do
--print("checking match size "..matchSize.." based on a terms: "..table.mapi(a, SingleLine):concat', ')
			local b1match = matchSize == 0 and Constant(1)
				or matchSize == 1 and a[1]
				or setmetatable(table.sub(a, 1, matchSize), mul)
--print("b1match "..SingleLine(b1match))			
			local matchesForThisSize = table(matches)
--print("matchesForThisSize["..b1.index.."] was "..(matchesForThisSize[b1.index] and SingleLine(matchesForThisSize[b1.index]) or 'nil'))
			if not matchesForThisSize[b1.index] 
			or (
				matchesForThisSize[b1.index] 
				and matchesForThisSize[b1.index] == b1match 
			) then
				matchesForThisSize[b1.index] = b1match
--print("matchesForThisSize["..b1.index.."] is now "..SingleLine(matchesForThisSize[b1.index]))
				local suba = table.sub(a, matchSize+1)
--print("calling recursively on "..#suba.." terms: "..table.mapi(suba, SingleLine):concat', ')			
				local results = table{checkMatch(suba, b, matchesForThisSize)}
--print("returned results from the sub-checkMatch : "..table.mapi(results, SingleLine):concat', ')
				if results[1] then
--print("returning that list for matchSize="..matchSize.."...")
					return table.unpack(results, 1, table.maxn(results))
				end
--print("continuing...")
			else
--print("the next wildcard had already been matched to "..SingleLine(matchesForThisSize[b1.index]).." when we tried to match it to "..SingleLine(b1match))
			end
			-- otherwise keep checking
		end
		
		-- all sized matches failed? return false
--print("all sized matches failed - failing")	
		return false
	end
	
	-- now what's left in b[i] should all be wildcards
	-- we just have to assign them between the a's
	-- but if we want mul match to return wildcards of +0 then we can't just rely on a 1-or-more rule
	-- for that reason, 
	
	return checkMatch(a,b, matches)
	--return (matches[1] or true), table.unpack(matches, 2, table.maxn(matches))
end

function mul:reverse(soln, index)
	-- y = a_1 * ... * a_j(x) * ... * a_n
	-- => a_j(x) = y / (a_1 * ... * a_j-1 * a_j+1 * ... * a_n)
	for k=1,#self do
		if k ~= index then
			soln = soln / self[k]:clone()
		end
	end
	return soln
end

function mul:getRealDomain()
	local I = self[1]:getRealDomain()
	if I == nil then return nil end
	for i=2,#self do
		local I2 = self[i]:getRealDomain()
		if I2 == nil then return nil end
		I = I * I2
	end
	return I
end

function mul:flatten()
	for i=#self,1,-1 do
		local ch = self[i]
		if mul.is(ch) then
			local expr = {table.unpack(self)}
			table.remove(expr, i)
			for j=#ch,1,-1 do
				local chch = ch[j]
				table.insert(expr, i, chch)
			end
			return mul(table.unpack(expr))
		end
	end
end

--[[
a * (b + c) * d * e becomes
(a * b * d * e) + (a * c * d * e)
--]]
function mul:distribute()
	local add = require 'symmath.op.add'
	local sub = require 'symmath.op.sub'
	for i,ch in ipairs(self) do
		if add.is(ch) or sub.is(ch) then
			local terms = table()
			for j,chch in ipairs(ch) do
				local term = self:clone()
				term[i] = chch:clone()
				terms:insert(term)
			end
			return getmetatable(ch)(table.unpack(terms))
		end
	end
end

mul.rules = {
	Eval = {
		{apply = function(eval, expr)
			local result = 1
			for _,x in ipairs(expr) do
				result = result * eval:apply(x)
			end
			return result
		end},
	},

	Expand = {
		{apply = function(expand, expr)
			local dstr = expr:distribute()
			if dstr then return expand:apply(dstr) end
		end},
	},

	FactorDivision = {
		{apply = function(factorDivision, expr)
			local Constant = require 'symmath.Constant'
			local div = require 'symmath.op.div'
			
			-- first time processing we want to simplify()
			--  to remove powers and divisions
			--expr = expr:simplify()
			-- but not recursively ... hmm ...
			
			-- flatten multiplications
			local flat = expr:flatten()
			if flat then return factorDivision:apply(flat) end

			-- distribute multiplication
			local dstr = expr:distribute()
			if dstr then return factorDivision:apply(dstr) end

			-- [[ same as Prune:

			-- push all fractions to the left
			for i=#expr,2,-1 do
				if div.is(expr[i])
				and Constant.is(expr[i][1])
				and Constant.is(expr[i][2])
				then
					table.insert(expr, 1, table.remove(expr, i))
				end
			end

			-- push all Constants to the lhs, sum as we go
			local cval = 1
			for i=#expr,1,-1 do
				if Constant.is(expr[i]) then
					cval = cval * table.remove(expr, i).value
				end
			end
			
			-- if it's all constants then return what we got
			if #expr == 0 then 
				return Constant(cval) 
			end
			
			if cval == 0 then 
				return Constant(0) 
			end
			
			if cval ~= 1 then
				table.insert(expr, 1, Constant(cval))
			else
				if #expr == 1 then 
					return factorDivision:apply(expr[1]) 
				end
			end
			
			--]]	
		end},
	},

	Prune = {
		{apply = function(prune, expr)	
			local Constant = require 'symmath.Constant'
			local pow = require 'symmath.op.pow'
			local div = require 'symmath.op.div'
			
			-- flatten multiplications
			local flat = expr:flatten()
			if flat then return prune:apply(flat) end
			
			-- move unary minuses up
			--[[ pruning unm immediately
			do
				local unm = require 'symmath.op.unm'
				local unmCount = 0
				for i=1,#expr do
					local ch = expr[i]
					if unm.is(ch) then
						unmCount = unmCount + 1
						expr[i] = ch[1]
					end
				end
				if unmCount % 2 == 1 then
					return -prune:apply(expr)	-- move unm outside and simplify what's left
				elseif unmCount ~= 0 then
					return prune:apply(expr)	-- got an even number?  remove it and simplify this
				end
			end
			--]]

			-- push all fractions to the left
			for i=#expr,2,-1 do
				if div.is(expr[i])
				and Constant.is(expr[i][1])
				and Constant.is(expr[i][2])
				then
					table.insert(expr, 1, table.remove(expr, i))
				end
			end

			
			-- [[ and now for Matrix*Matrix multiplication ...
			-- do this before the c * 0 = 0 rule
			for i=#expr,2,-1 do
				local rhs = expr[i]
				local lhs = expr[i-1]
			
				local result
				if lhs.pruneMul then
					result = lhs.pruneMul(lhs, rhs)
				elseif rhs.pruneMul then
					result = rhs.pruneMul(lhs, rhs)
				end
				if result then
					table.remove(expr, i)
					expr[i-1] = result
					if #expr == 1 then expr = expr[1] end
					return prune:apply(expr)
				end
			end
			--]]



			-- push all Constants to the lhs, sum as we go
			local cval = 1
			for i=#expr,1,-1 do
				if Constant.is(expr[i]) then
					cval = cval * table.remove(expr, i).value
				end
			end
			
			-- if it's all constants then return what we got
			if #expr == 0 then 
				return Constant(cval) 
			end
			
			if cval == 0 then 
				return Constant(0) 
			end
			
			if cval ~= 1 then
				table.insert(expr, 1, Constant(cval))
			else
				if #expr == 1 then 
					return prune:apply(expr[1]) 
				end
			end

			-- [[ a^m * a^n => a^(m + n)
			do
				local modified = false
				local i = 1
				while i <= #expr do
					local x = expr[i]
					local base
					local power
					if pow.is(x) then
						base = x[1]
						power = x[2]
					else
						base = x
						power = Constant(1)
					end
					
					if base then
						local j = i + 1
						while j <= #expr do
							local x2 = expr[j]
							local base2
							local power2
							if pow.is(x2) then
								base2 = x2[1]
								power2 = x2[2]
							else
								base2 = x2
								power2 = Constant(1)
							end
							if base2 == base then
								modified = true
								table.remove(expr, j)
								j = j - 1
								power = power + power2
							end
							j = j + 1
						end
						if modified then
							expr[i] = base ^ power
						end
					end
					i = i + 1
				end
				if modified then
					if #expr == 1 then expr = expr[1] end
					return prune:apply(expr)
				end
			end
			--]]
			
			-- [[ factor out denominators
			-- a * b * (c / d) => (a * b * c) / d
			--  generalization:
			-- a^m * b^n * (c/d)^p = (a^m * b^n * c^p) / d^p
			do
				local uniqueDenomIndexes = table()
				
				local denoms = table()
				local powers = table()
				local bases = table()
				
				for i=1,#expr do
					-- decompose expressions of the form 
					--  (base / denom) ^ power
					local base = expr[i]
					local power = Constant(1)
					local denom = Constant(1)

					if pow.is(base) then
						base, power = table.unpack(base)
					end
					if div.is(base) then
						base, denom = table.unpack(base)
					end
					if not Constant.isValue(denom, 1) then
						uniqueDenomIndexes:insert(i)
					end

					denoms:insert(denom)
					powers:insert(power)
					bases:insert(base)
				end
				
				if #uniqueDenomIndexes > 0 then	
					
					local num
					if #bases == 1 then
						num = bases[1]
						if not Constant.isValue(powers[1], 1) then
							num = num ^ powers[1]
						end
					else
						num = bases:map(function(base,i)
							if Constant.isValue(powers[i], 1) then
								return base
							else
								return base ^ powers[i]
							end
						end)
						assert(#num > 0)
						if #num == 1 then
							num = num[1]
						else
							num = mul(num:unpack())
						end
					end
					
					local denom
					if #uniqueDenomIndexes == 1 then
						local i = uniqueDenomIndexes[1]
						denom = denoms[i]
						if not Constant.isValue(powers[i], 1) then
							denom = denom^powers[i]
						end
					elseif #denoms > 1 then
						denom = mul(table.unpack(uniqueDenomIndexes:map(function(i)
							if Constant.isValue(powers[i], 1) then
								return denoms[i]
							else
								return denoms[i]^powers[i]
							end
						end)))
					end
					
					local expr = num
					if not Constant.isValue(denom, 1) then
						expr = expr / denom
					end
					return prune:apply(expr)
				end
			end
			--]]
		end},
	
		{logPow = function(prune, expr)
			local symmath = require 'symmath'
			-- b log(a) => log(a^b)
			-- I would like to push this to prevent x log(y) => log(y^x)
			-- but I would like to keep -1 * log(y) => log(y^-1)
			-- so I'll make a separate rule for that ...
			for i=1,#expr do
				if symmath.log.is(expr[i]) then
					expr = expr:clone()
					local a = table.remove(expr,i)
					if #expr == 1 then expr = expr[1] end
					return prune:apply(symmath.log(a[1] ^ expr))
				end
			end	
		end},

		{negLog = function(prune, expr)
			local symmath = require 'symmath'
			-- -1*log(a) => log(1/a)
			if #expr == 2
			and expr[1] == symmath.Constant(-1)
			and symmath.log.is(expr[2])
			then
				return prune:apply(symmath.log(1/expr[2][1]))
			end	
		end},
	},

	Tidy = {
		{apply = function(tidy, expr)
			local unm = require 'symmath.op.unm'
			local Constant = require 'symmath.Constant'
			
			-- -x * y * z => -(x * y * z)
			-- -x * y * -z => x * y * z
			do
				local unmCount = 0
				for i=1,#expr do
					local ch = expr[i]
					if unm.is(ch) then
						unmCount = unmCount + 1
						expr[i] = ch[1]
					end
				end
				assert(#expr > 1)
				if unmCount % 2 == 1 then
					return -tidy:apply(expr)	-- move unm outside and simplify what's left
				elseif unmCount ~= 0 then
					return tidy:apply(expr)	-- got an even number?  remove it and simplify this
				end
			end
			
			-- (has to be solved post-prune() because tidy's Constant+unm will have made some new ones)
			-- 1 * x => x 	
			local first = expr[1]
			if Constant.is(first) and first.value == 1 then
				table.remove(expr, 1)
				if #expr == 1 then
					expr = expr[1]
				end
				return tidy:apply(expr)
			end
		end},
	},
}
-- ExpandPolynomial inherits from Expand
mul.rules.ExpandPolynomial = mul.rules.Expand

return mul
