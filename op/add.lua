local class = require 'ext.class'
local table = require 'ext.table'
local math = require 'ext.math'
local tableCommutativeEqual = require 'symmath.tableCommutativeEqual'
local Binary = require 'symmath.op.Binary'

local add = class(Binary)
add.precedence = 2
add.name = '+'

function add:init(...)
	add.super.init(self, ...)

	-- auto flatten any adds ...?
	-- I don't think anyone depends on nested adds ... 
	-- and flattening here will make the API easier, requiring less simplify's for matching and == 
	for i=#self,1,-1 do
		if add.is(self[i]) then
			local x = table.remove(self, i)
			for j=#x,1,-1 do
				table.insert(self, i, x[j])
			end
		end
	end
end

function add:evaluateDerivative(deriv, ...)
	local result = table()
	for i=1,#self do
		result[i] = deriv(self[i]:cloneIfMutable(), ...)
	end
	return add(result:unpack())
end


--[[
TODO since add() and mul() can have 'n' children
here we should match wildcards across children, greedy 1-or-more
and allow returning either a[i]'s, or sums-of-a[i]'s, or even 0
and somehow work around 'addNonCommutative' or don't since I just now added it and nothing yet uses it, though mul will have to worry about that eventually.
how to accomplish this:
	1) match children only when not against wildcards
	2) collect said wildcards
	3) with what hasn't been matched, try to match it 1-1 with wildcards...
		might get errors if you match least-to-most restrictive wildcards, where less-restrictive wildcards take matches that more-restrictive wildcards don't
		you should probably always pass wildcards to add() or mul() as most-to-least restrictive
		of coures to be certain to match all, might have to try all possible combinations =(
		so iterate over permutations of non-matched order-independent terms.  if all match then go with it.
--]]
function add.match(a, b, matches)
	local Wildcard = require 'symmath.Wildcard'
	local Constant = require 'symmath.Constant'
--local SingleLine = require 'symmath.export.SingleLine'
--local Verbose = require 'symmath.export.Verbose'
--print("add.match(a="..Verbose(a)..", b="..Verbose(b)..", matches={"..(matches or table()):mapi(Verbose):concat', '..'}) begin')

	matches = matches or table()
	-- if 'b' is an add then fall through 
	-- this part is only for wildcard matching of the whole expression
	if not add.is(b) 	-- if the wildcard is a add then we want to test it here
	and b.wildcardMatches 
	then
		if not b:wildcardMatches(a, matches) then return false end
--print("matching entire expr "..SingleLine(b).." to "..SingleLine(a))	
		return (matches[1] or true), table.unpack(matches, 2, table.maxn(matches))
	end	
	if getmetatable(a) ~= getmetatable(b) then return false end


	local a = table(a)
	local b = table(b)
	
	-- compare things order-independent, remove as you go
	-- skip wildcards, do those last
	for i=#a,1,-1 do
		local ai = a[i]
		-- non-commutative compare...
		if not ai.addNonCommutative then
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
--print('removing...')				
--print(a[i])
--print(b[j])
				a:remove(i)
				b:remove(j)
			end
		end
	end

--print("what's left after matching commutative non-wildcards:")
--print('a:', a:mapi(SingleLine):concat', ')
--print('b:', b:mapi(SingleLine):concat', ')

	-- now compare what's left in-order (since it's non-commutative)
	-- skip wildcards, do those last
	local function checkMatch(a,b, matches)
		-- save the original here
		-- upon success, merge the new matches back into the original argument
		local origMatches = matches
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
		
		-- TODO bi isn't necessarily a wildcard -- it could be an 'addNonCommutative' term (though nothing does this for addition yet)
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
--print("matches["..bi.index.."] tried to set to Constant(0), but it already exists as "..SingleLine(matches[bi.index]).." -- failing")
					if matches[bi.index] ~= Constant(0) then return false end
				else
--print("setting matches["..bi.index.."] to Constant(0)")
					matches[bi.index] = Constant(0)
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
--print("matching add subexpr from first match "..SingleLine(a1).." index "..b.index.." to "..SingleLine(a))	
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
--print("matching add subexpr from first match "..SingleLine(a1).." index "..b.index.." to "..SingleLine(a))	
						matches[i] = restsubmatch[i]
					end
				end
			end


			-- overlay match matches on what we have already matched so far
			-- also write them back to the original argument since we are returning true
			if origMatches then
				for k,v in pairs(matches) do origMatches[k] = v end
			end
			return matches
		end

--print("before checking remaining terms, our matches is: "..table.mapi(matches, SingleLine):concat', ')

		-- now if we have a wildcard ... try all 0-n possible matches of it
		local b1 = b:remove(1)
		for matchSize=math.min(#a, b1.atMost or math.huge),(b1.atLeast or 0),-1 do
--print("checking match size "..matchSize.." based on a terms: "..table.mapi(a, SingleLine):concat', ')
			local b1match = matchSize == 0 and Constant(0)
				or matchSize == 1 and a[1]
				or setmetatable(table.sub(a, 1, matchSize), add)
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
					-- also write them back to the original argument since we are returning true
					if origMatches then
						for k,v in pairs(matchesForThisSize) do origMatches[k] = v end
					end
					return matchesForThisSize[1] or true, table.unpack(matchesForThisSize, 2, table.maxn(matchesForThisSize))
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
	-- but if we want add match to return wildcards of +0 then we can't just rely on a 1-or-more rule
	-- for that reason, 
	
	return checkMatch(a,b, matches)
	--return (matches[1] or true), table.unpack(matches, 2, table.maxn(matches))
end

--[[
alright, what if we want to match Constant(0):match(Wildcard(1) + Wildcard(2) ?
add needs its own 'wildcardMatches' function for that to happen
... and that function needs to fall when it encounters adds 
and if it doesn't ... 
then it needs to look through its children and see if it has all-but-1...

... if it has no non-wildcards then make sure we are matching against Constant(0), and match the wildcards with Constant(0)
... if we have all-but-1 wildcards then make sure we are matching against the remaining non-wildcard, and match the wildcards with Constant(0)
... if we have all-but-2 wildcards then fail

TODO consider addNonCommutative operators
--]]
function add:wildcardMatches(a, matches)
	local Constant = require 'symmath.Constant'
--local Verbose = require 'symmath.export.Verbose'
--print("add.wildcardMatches(self="..Verbose(self)..", a="..Verbose(a)..", matches={"..matches:mapi(Verbose):concat', '..'}')

	local Wildcard = require 'symmath.Wildcard'	
	-- TODO move this to Expression
	local function find(expr, lookfor)
		if lookfor(expr) then return true end
		local found
		expr:map(function(x)
			if lookfor(x) then
				found = true
			end
		end)
		return found
	end
	
	-- 'a' is the 'a' in Expression.match(a,b)
	-- 'b' is 'self'
	local nonWildcards = table()
	local wildcards = table()
	for _,w in ipairs(self) do
		if w.wildcardMatches 
		and find(w, function(x) return Wildcard.is(x) end)
		then
			wildcards:insert(w)
		else
			nonWildcards:insert(w)
		end
	end

--print("add children: "..table.mapi(self, Verbose):concat', ')
--print("add wildcard children: "..table.mapi(wildcards, Verbose):concat', ')
--print("add non-wildcard children: "..table.mapi(nonWildcards, Verbose):concat', ')
	if #nonWildcards > 1 then
		return false
	end

	local defaultValue = Constant(0)
	local matchExpr = a
	if #nonWildcards == 1 then
		-- TODO what if we are doing x:match(W{1,atLeast=1} + W{2}) ?
		if not a:match(nonWildcards[1], matches) then
--print("single remaining add sub-term didn't match first non-wildcard - failing")
			return false
		end
		-- a matches nonWildcards[1]
		matchExpr = defaultValue
	end

	-- if any of these wildcards needed a term then fail
	-- (that will be handled in the add.match fallthrough
	--  which is why add.match should not call this -- only other non-add Expressions' .match())			
	local totalAtLeast = 0
	for _,w in ipairs(wildcards) do
		if w.atLeast and w.atLeast > 0 then
			totalAtLeast = totalAtLeast + w.atLeast
			if totalAtLeast > 1 then 
				return false
			end
		end
	end

	-- when matching wildcards, make sure to match any with 'atLeast' first
	if totalAtLeast == 1 then
		for i,w in ipairs(wildcards) do
			-- TODO make this work for sub-expressions?
			if w.atLeast and w.atLeast > 0 then
				if i > 1 then
--print("moving wildcard with 'atleast' from "..i.." to 1")				
					table.remove(wildcards, i)
					table.insert(wildcards, 1, w)
				end
				break
			end
		end
	end

	local Wildcard = require 'symmath.Wildcard'
	local mul = require 'symmath.op.mul'
	-- match all wildcards to zero
	-- test first, so we don't half-set the 'matches' before failing (TODO am I doing this elsewhere in :match()?)
	-- TODO w.index IS NOT GUARANTEED, if we have (x):match(W(1) + W(2) * W(3)) and add and mul have wildcardMatches
	-- in that case, you need to handle all possible sub-wildcardMatches specifically
--print("testing against previous matches table...")	
	for i,w in ipairs(wildcards) do
		local cmpExpr = i == 1 and matchExpr or defaultValue
--print("comparing lhs "..Verbose(cmpExpr))
		if Wildcard.is(w) then
			if matches[w.index] 
			and matches[w.index] ~= cmpExpr
			then 
				return false 
			end
		-- elseif add.is shouldn't happen if all adds are flattened upon construction
		elseif mul.is(w) then
--print("found a add(mul()), comparing with "..Verbose(w))
			-- check before going through with it
			if not cmpExpr:match(w, table(matches)) then
--print("add(mul()) didn't match - failing")				
				return false
			end
--print(" - success")		
		elseif add.is(w) then
			error"match() doesn't work with unflattened add's"
		else
			error("found match(add(unknown))")
		end
	end
	-- finally set all matches to zero and return 'true'
	for i,w in ipairs(wildcards) do
		local cmpExpr = i == 1 and matchExpr or defaultValue
		if Wildcard.is(w) then
--print('add.wildcarddMatches setting '..w.index..' to '..require 'symmath.export.SingleLine'(i == 1 and matchExpr or defaultValue))
			matches[w.index] = cmpExpr
		-- elseif add.is shouldn't happen if all adds are flattened upon construction
		elseif mul.is(w) then
			-- use the state this time, so it does modify "matches"
			cmpExpr:match(w, matches)
		elseif add.is(w) then
			error"match() doesn't work with unflattened add's"
		end
	end
	return (matches[1] or true), table.unpack(matches, 1, table.maxn(matches))
end

add.removeIfContains = require 'symmath.commutativeRemove'

function add:reverse(soln, index)
	-- y = a_1 + ... + a_j(x) + ... + a_n
	-- => a_j(x) = y - a_1 - ... - a_j-1 - a_j+1 - ... a_n
	for k=1,#self do
		if k ~= index then
			soln = soln - self[k]:cloneIfMutable()
		end
	end
	return soln
end

function add:getRealDomain()
	local I = self[1]:getRealDomain()
	if I == nil then return nil end
	for i=2,#self do
		local I2 = self[i]:getRealDomain()
		if I2 == nil then return nil end
		I = I + I2
	end
	return I
end


--[[
this is a single term^power
--]]
local ProdTerm = class()

function ProdTerm:init(args)
	self.term = args.term
	self.power = args.power
end


--[[
this is a multiplied collection of a1^b1 * a2^b2 * ...
--]]
local ProdList = class()

ProdList.insert = table.insert
ProdList.mapi = table.mapi
ProdList.find = table.find


function ProdList:toExpr()
	local Constant = require 'symmath.Constant'
	local Verbose = require 'symmath.export/Verbose'
	local list = table.mapi(self, function(x)
		if Constant.isValue(x.power, 1) then
			return x.term
		else
			return x.term ^ x.power:simplify()
		end
	end)

	list = list:filter(function(x)
		return not Constant.isValue(x, 1)
	end)

	if #list == 0 then return Constant(1) end
	if #list == 1 then return list[1] end
	list = list:sort(function(a,b)
		local sa = Verbose(a)
		local sb = Verbose(b)
		if #sa ~= #sb then return #sa < #sb end
		return sa < sb 
	end)
	
	return setmetatable(list, require 'symmath.op.mul')
end



-- pass it an element of the product list
-- returns true if all the powers are even (and positive?)
-- I'm not using this yet, but for the sake of generalizing, it would be good to switch to this
function ProdList:isSquare()
	local symmath = require 'symmath'
	local Constant = symmath.Constant
	for i,pi in ipairs(self) do
		if 
		-- [[ exclude any constants, especially the -1's
		Constant.is(pi.term)
		--]]
		--[[ if power is 1 then treat 1^1 as an even power (i.e. anything^0)
		(
			Constant.isValue(pi.term, 1)
			and Constant.isValue(pi.power, 1)
		) 
		--]]
		or (
			Constant.is(pi.power)
			-- TODO positiveEvenInteger:contains
			and symmath.set.evenInteger:contains(pi.power)
			and pi.power.value > 0	-- I don't think any power==0's exist at this point
		) then
			-- we're an even power
		else
			return false
		end
	end
	return true
end


-- for the i'th child of an add ...
-- return a list of {term=term, power=power}
function getProductList(x)
	local symmath = require 'symmath'
	local mul = symmath.op.mul
	local pow = symmath.op.pow
	local Constant = symmath.Constant

	-- get products or individual terms
	local prodList
	if mul.is(x) then
		prodList = table(x)
	else
		prodList = table{x}
	end
	
	-- pick out any exponents in any of the products
	prodList = prodList:mapi(function(ch)
		if pow.is(ch) then
			return ProdTerm{
				term = ch[1],
				power = assert(ch[2]),
			}
		else
			return ProdTerm{
				term = ch,
				power = Constant(1),
			}
		end
	end)

	local newProdList = ProdList()
	for k,x in ipairs(prodList) do
		if Constant.is(x.term) then
			local c = x.term.value
			if c == 1 then
				-- do nothing -- remove any 1's
			elseif c == 0 then
				newProdList:insert(x)
			else
				if c < 0 then
					-- if it's a negative constant then split out the minus
					newProdList:insert(ProdTerm{
						term = Constant(-1),
						power = x.power,
					})
					c = -c
				end
				
				--if symmath.set.positiveInteger:contains(list[i])
				if c == math.floor(c) then
					local ppow = {}
					for _,p in ipairs(math.primeFactorization(c)) do
						ppow[p] = (ppow[p] or 0) + 1
					end
					for p,power in pairs(ppow) do
						if power == 1 then
							newProdList:insert(ProdTerm{
								term = Constant(p),
								power = x.power,
							})
						else
							newProdList:insert(ProdTerm{
								term = Constant(p),
								power = x.power * power,
							})
						end
					end
				else
					newProdList:insert(ProdTerm{
						term = Constant(c),
						power = x.power,
					})
				end
			end
		else
			newProdList:insert(x)	-- add the new term
		end
	end
	prodList = newProdList

	return prodList
end

--[[
this is a summed collection p1 + p2 + ... 
where each pi is a ProdList above a1^b1 * a2^b2 * ...
--]]
local ProdLists = class()

function ProdLists:init(expr)
	for i,x in ipairs(expr) do
		self[i] = getProductList(x)
	end
end

function ProdLists:sort()
	local Constant = require 'symmath.Constant'
	local Verbose = require 'symmath.export.Verbose'
	local function sortstr(list)
		if #list == 0 then return '' end
		if #list == 1 and Constant.is(list[1].term) then return '' end
		return table.mapi(list, function(x,_,t)
			if Constant.is(x.term) then return end
			return Verbose(x.term), #t+1
		end):concat(',')
	end
	-- sort the sum terms from shortest to longest
	table.sort(self, function(a,b)
		local sa = sortstr(a)
		local sb = sortstr(b)
		return sa < sb 
	end)
end

function ProdLists:toExpr()
	local expr = table.mapi(self, function(prodList) 
		return prodList:toExpr() 
	end)
	return #expr == 1 
		and expr[1]
		or setmetatable(expr, add)
end


add.rules = {
	Eval = {
		{apply = function(eval, expr)
			local result = 0
			for _,x in ipairs(expr) do
				result = result + eval:apply(x)
			end
			return result
		end},
	},

	Factor = {
		{apply = function(factor, expr, factors)
			assert(#expr > 1)
			
			local symmath = require 'symmath'
			local mul = symmath.op.mul
			local pow = symmath.op.pow
			local Constant = symmath.Constant
			local Verbose = symmath.export.Verbose


			-- [[ x*a + x*b => x * (a + b)
			-- the opposite of this is in mul:prune's applyDistribute
			-- don't leave both of them uncommented or you'll get deadlock


			-- TODO make this a part of add's interface
			-- an iterator / length operator for what terms and what powers are available.
			-- have it return constants and cache low Constant() values
			

			-- 1) get all terms and powers
			local prodLists = ProdLists(expr)
			-- sort by prodLists[i].term, excluding all constants
			prodLists:sort()


			-- TODO where to put quadratic / polynomial division
			-- I should do this somewhere else, but I'll do it here for now
			-- a^2 - b^2 => (a+b) (a-b)

			--[[ searching prodLists
			if #prodLists == 2 then
				if one of the two has a -1 Constant in its product list
				if both are considered squares (i.e. other than constants, all have even powers)
				then replace them with (x + y)(x - y)
			end
			--]]
			-- [[ searching expr 
			if #expr == 2 then
				if symmath.op.pow.is(expr[1])
				and symmath.set.evenInteger:contains(expr[1][2])
				and symmath.op.mul.is(expr[2])
				and #expr[2] == 2
				and Constant.isValue(expr[2][1], -1)
				and symmath.op.pow.is(expr[2][2])
				and symmath.set.evenInteger:contains(expr[2][2][2])
				then
					local a = (expr[1][1] ^ (expr[1][2]/2))
					local b = (expr[2][2][1] ^ (expr[2][2][2]/2))
					return (a + b) * (a - b)
				end
			end
			-- TODO factoring higher polys ... this is just one specific case
			--]]
			-- [[ this is duplicated in sqrt.Prune
			local function isSquarePow(x)
				return pow.is(x) and Constant.isValue(x[2], 2)
			end
			if #expr == 3 then
				local squares = table()
				local notsquares = table()
				for i,xi in ipairs(expr) do
					(isSquarePow(xi) and squares or notsquares):insert(i)
				end
				if #squares == 2 then
					assert(#notsquares == 1)
					local a,c = expr[squares[1]], expr[squares[2]]
					local b = expr[notsquares[1]]
					if b == symmath.op.mul(2, a[1], c[1]) then
						return (a[1] + c[1]) * (a[1] + c[1])
					end
					if b == symmath.op.mul(Constant(-2), a[1], c[1]) then
						return (a[1] - c[1]) * (a[1] - c[1])
					end
				end
			end
			--]]


			-- rebuild exprs accordingly
			assert(#prodLists == #expr)
			expr = prodLists:toExpr()
			assert(#expr > 1)

	
-- without this (y-x)/(x-y) doesn't simplify to -1
-- [=[
			-- instead of only factoring the -1 out of the constant
			-- also add double the -1 to the rest of the terms (which should equate to being positive)
			-- so that signs don't mess with simplifying division
			-- ex: -1+x => (-1)*1+(-1)*(-1)*x => -1*(1+(-1)*x) => -1*(1-x)
			for i=1,#expr do
				if (
					--if expr[i] has a leading negative constant
					#prodLists[i] > 0
				-- [[ old - expect a leading constant
				and Constant.is(prodLists[i][1].term) 
				and prodLists[i][1].term.value < 0 
				--]]
				--[[ new - look through all constants
				-- TODO enabling this breaks things, but the code above is inserting Constant(-1) not in front, so the old check would miss it?
				and prodLists[i]:find(nil, function(x) return Constant.isValue(x, -1) end)
				--]]
				)
				--and symmath.set.negativeReal:contains(expr)
				--and not symmath.set.positiveReal:contains(expr)
				then
					for j=i+1,#expr do
						local index = prodLists[j]:find(nil, function(x)
							return Constant.isValue(x.term, -1)
						end)
						if index then
							prodLists[j][index].power = (prodLists[j][index].power + 2):simplify()
						else
							-- insert two copies so that one can be factored out
							-- TODO, instead of squaring it, raise it to 2x the power of the constant's separated -1^x
							prodLists[j]:insert{
								term = Constant(-1),
								power = Constant(2),
							}
						end
					end
				end
			end
--]=]
			
			
			-- 2) find smallest set of common terms
			
			local minProds = prodLists[1]:mapi(function(prod) return prod.term end)
			for i=2,#prodLists do
				local otherProds = prodLists[i]:mapi(function(prod) return prod.term end)
				for j=#minProds,1,-1 do
					local found = false
					for k=1,#otherProds do
						if minProds[j] == otherProds[k] then
							found = true
							break
						end
					end
					if not found then
						minProds:remove(j)
					end
				end
			end


			if #minProds == 0 then return end
				
			local prune = symmath.prune

			local minPowers = {}
			for i,minProd in ipairs(minProds) do
				-- 3) find abs min power of all terms
				local minPower
				local foundNonConstMinPower
				for i=1,#prodLists do
					for j=1,#prodLists[i] do
						if prodLists[i][j].term == minProd then
							if Constant.is(prodLists[i][j].power) then
								if minPower == nil then
									minPower = prodLists[i][j].power.value
								else
									minPower = math.min(minPower, prodLists[i][j].power.value)
								end
							else	-- if it is variable then ... just use the ... first?
								minPower = prodLists[i][j].power
								foundNonConstMinPower = true
								break
							end
						end
					end
					if foundNonConstMinPower then break end
				end
				minPowers[i] = minPower
				-- 4) factor them out
				for i=1,#prodLists do
					for j=1,#prodLists[i] do
						if prodLists[i][j].term == minProd then
							prodLists[i][j].power = prodLists[i][j].power - minPower
							prodLists[i][j].power = prune(prodLists[i][j].power) or prodLists[i][j].power
						end
					end
				end
			end

			-- start with all the factored-out terms
			-- [[ old
			local terms = minProds:mapi(function(minProd,i) return minProd ^ minPowers[i] end)
			--]]
			--[[ new ... causes simplification loops
			local terms = table()
			for i=1,#minProds do
				if type(minPowers[i]) == 'number'
				and minPowers[i] > 0 
				then
					terms:insert(minProds[i] ^ minPowers[i])
				end
			end
			--]]
	
			-- [[
			-- remove any product lists that are to the zero power
			-- NOTICE this will put prodLists[] out of sync with expr[]
			for i=#prodLists,1,-1 do	-- here's our adds
				local pli = prodLists[i]
				for j=#pli,1,-1 do		-- here's our muls
					local plij = pli[j]
					if Constant.isValue(plij.power, 0) then
						table.remove(pli,j)
					end
				end
			end
			--]]

			-- then add what's left of the original sum
			local lastTerm = prodLists:toExpr()

			-- [[
			-- if anything was factored out then try the quadratic rules on what's left
			if #terms > 0 then
				-- prune is still needed here -- it looks like only to recombine constants (and move them to the left of the muls) before the quadratic testing at the top of Factor is run
				lastTerm = prune(lastTerm)
				lastTerm = factor(lastTerm)
			end
			--]]

			terms:insert(lastTerm)
		
			local result = #terms == 1 and terms[1] or mul(terms:unpack())
			
			return prune(result)
		end},
	},

	Prune = {
		{apply = function(prune, expr, ...)
			local tableCommutativeEqual = require 'symmath.tableCommutativeEqual'
			local Constant = require 'symmath.Constant'
			local div = require 'symmath.op.div'
			local mul = require 'symmath.op.mul'
			local pow = require 'symmath.op.pow'
	
--[=[ old version
			-- flatten additions
			-- (x + y) + z => x + y + z
			for i=#expr,1,-1 do
				local ch = expr[i]
				if add.is(ch) then
					expr = expr:clone()
					-- this looks like a job for splice ...
					table.remove(expr, i)
					for j=#ch,1,-1 do
						local chch = assert(ch[j])
						table.insert(expr, i, chch)
					end
					return prune:apply(expr)
				end
			end
--]=]
-- [=[ new version
			-- flatten additions
			-- (x + y) + z => x + y + z
			local flattenArgs
			for i,ch in ipairs(expr) do
				if add.is(ch) then
					if not flattenArgs then
						flattenArgs = table.sub(expr, 1, i-1)
					end
					flattenArgs:append(ch)
				else
					if flattenArgs then
						flattenArgs:insert(ch)
					--else it will get appended in the table.sub
					-- ... or never, if no add->add's exist
					end
				end
			end
			if flattenArgs then
				return prune:apply(setmetatable(flattenArgs, add))
			end
--]=]


-- [=[ old version
			-- c1 + x1 + c2 + x2 => (c1+c2) + x1 + x2
			local cval = 0
			for i=#expr,1,-1 do
				if Constant.is(expr[i]) then
					cval = cval + table.remove(expr, i).value
				end
			end
			
			-- if it's all constants then return what we got
			if #expr == 0 then 
				return Constant(cval) 
			end
			
			-- re-insert if we have a Constant
			if cval ~= 0 then
				table.insert(expr, 1, Constant(cval))
			else
				-- if cval is zero and we're not re-inserting a constant
				-- then see if we have only one term ...
				if #expr == 1 then 
					return prune:apply(expr[1]) 
				end
			end
--]=]
--[=[ halfway version
-- the only difference between this and old version is that we make shallowCopy()'s before modifying 'expr'
-- TODO FIXME THIS DEPENDS ON MODIFICATION IN-PLACE (WHY?!?!?!)	
			-- c1 + x1 + c2 + x2 => (c1+c2) + x1 + x2
			local cval = 0
			for i=#expr,1,-1 do
				if Constant.is(expr[i]) then
					expr = expr:shallowCopy()
					cval = cval + table.remove(expr, i).value
				end
			end
			
			-- if it's all constants then return what we got
			if #expr == 0 then 
				return Constant(cval) 
			end
			
			-- re-insert if we have a Constant
			if cval ~= 0 then
				expr = expr:shallowCopy()
				table.insert(expr, 1, Constant(cval))
			else
				-- if cval is zero and we're not re-inserting a constant
				-- then see if we have only one term ...
				if #expr == 1 then 
					return prune:apply(expr[1]) 
				end
			end
--]=]
--[=[ new version
			-- c1 + x1 + c2 + x2 => (c1+c2) + x1 + x2
			local needToRearrangeConsts = Constant.isValue(expr[i], 0)
			if not needToRearrangeConsts then
				for i=2,#expr do
					if Constant.is(expr[i]) then
						needToRearrangeConsts = true
						break
					end
				end
			end
			if needToRearrangeConsts then
				local cval = 0
				local result = table()
				for i,x in ipairs(expr) do
					if Constant.is(x) then
						cval = cval + x.value
					else
						result:insert(x)
					end
				end
				if cval ~= 0 then
					result:insert(1, Constant(cval))
				end
				if #result == 0 then return Constant(0) end
				if #result == 1 then return prune:apply(result[1]) end
				return prune:apply(setmetatable(result, add))
			end
--]=]


--[=[ old version		
			-- any overloaded subclass simplification
			-- specifically used for vector/matrix addition
			-- only operate on neighboring elements - don't assume commutativitiy, and that we can exchange elements to be arbitrary neighbors
			for i=#expr,2,-1 do
				local rhs = expr[i]
				local lhs = expr[i-1]
				
				local result
				if lhs.pruneAdd then
					result = lhs.pruneAdd(lhs, rhs)
				elseif rhs.pruneAdd then
					result = rhs.pruneAdd(lhs, rhs)
				end
				if result then
					table.remove(expr, i)
					expr[i-1] = result
					if #expr == 1 then
						expr = expr[1]
					end
					return prune:apply(expr)
				end
			end
--]=]
-- :[=[ new version
			-- any overloaded subclass simplification
			-- specifically used for vector/matrix addition
			-- only operate on neighboring elements - don't assume commutativitiy, and that we can exchange elements to be arbitrary neighbors
			for i=#expr,2,-1 do
				local rhs = expr[i]
				local lhs = expr[i-1]
				
				local result
				if lhs.pruneAdd then
					result = lhs.pruneAdd(lhs, rhs)
				elseif rhs.pruneAdd then
					result = rhs.pruneAdd(lhs, rhs)
				end
				if result then
					expr = expr:shallowCopy()
					table.remove(expr, i)
					expr[i-1] = result
					if #expr == 1 then
						expr = expr[1]
					end
					return prune:apply(expr)
				end
			end
--]=] 


			-- [[ x * c1 + x * c2 => x * (c1 + c2) ... for constants
			do
				local muls = table()
				local nonMuls = table()
				for i,x in ipairs(expr) do
					if mul.is(x) then
						muls:insert(x)
					else
						nonMuls:insert(x)
					end
				end
				if #muls > 1 then	-- we have more than one multiplication going on ... see if we can combine them
					local baseConst = 0
					local baseTerms
					local didntFind
					for _,mul in ipairs(muls) do
						local nonConstTerms = table.filter(mul, function(x,k) 
							if type(k) ~= 'number' then return end
							return not Constant.is(x)
						end)
						if not baseTerms then
							baseTerms = nonConstTerms
						else
							if not tableCommutativeEqual(baseTerms, nonConstTerms) then
								didntFind = true
								break
							end
						end
						local constTerms = table.filter(mul, function(x,k) 
							if type(k) ~= 'number' then return end
							return Constant.is(x)
						end)

						local thisConst = 1
						for _,const in ipairs(constTerms) do
							thisConst = thisConst * const.value
						end
						
						baseConst = baseConst + thisConst
					end
					if not didntFind then
						local terms = table{baseConst, baseTerms:unpack()}
						assert(#terms > 0)	-- at least baseConst should exist
						if #terms == 1 then
							terms = terms[1]
						else
							terms = mul(terms:unpack())
						end

						local expr
						if #nonMuls == 0 then
							expr = terms
						else
							expr = add(terms, nonMuls:unpack())
						end

						return prune:apply(expr)
					end
				end
			end
			--]]

			-- TODO shouldn't this be regardless of the outer add ?
			-- turn any a + (b * (c + d)) => a + (b * c) + (b * d)
			-- [[ if any two children are muls,
			--    and they have all children in common (with the exception of any constants)
			--  then combine them, and combine their constants
			-- x * c1 + x * c2 => x * (c1 + c2) (for c1,c2 constants)
			for i=1,#expr-1 do
				local xI = expr[i]
				local termsI
				if mul.is(xI) then
					termsI = table(xI)
				else
					termsI = table{xI}
				end
				for j=i+1,#expr do
					local xJ = expr[j]
					local termsJ
					if mul.is(xJ) then
						termsJ = table(xJ)
					else
						termsJ = table{xJ}
					end

					local fail
					
					local commonTerms = table()

					local constI
					for _,ch in ipairs(termsI) do
						if not termsJ:find(ch) then
							if Constant.is(ch) then
								if not constI then
									constI = Constant(ch.value)
								else
									constI.value = constI.value * ch.value
								end
							else
								fail = true
								break
							end
						else
							commonTerms:insert(ch)
						end
					end
					if not constI then constI = Constant(1) end
					
					local constJ
					if not fail then
						for _,ch in ipairs(termsJ) do
							if not termsI:find(ch) then
								if Constant.is(ch) then
									if not constJ then
										constJ = Constant(ch.value)
									else
										constJ.value = constJ.value * ch.value
									end
								else
									fail = true
									break
								end
							end
						end
					end
					if not constJ then constJ = Constant(1) end
					
					if not fail then
						expr = expr:shallowCopy()
						table.remove(expr, j)
						if #commonTerms == 0 then
							expr[i] = Constant(constI.value + constJ.value)
						else
							expr[i] = mul(Constant(constI.value + constJ.value), table.unpack(commonTerms))
						end
						if #expr == 1 then expr = expr[1] end
						return prune:apply(expr)
					end
				end
			end
			--]]
			
			--[[ factor out divs ...
			local denom
			local denomIndex
			for i,x in ipairs(expr) do
				if not div.is(x) then
					denom = nil
					break
				else
					if not denom then
						denom = x[2]
						denomIndex = i
					else
						if x[2] ~= denom then
							denom = nil
							break
						end
					end
				end
			end
			if denom then
				table.remove(expr, denomIndex)
				return prune:apply(expr / denom)
			end
			--]]

			-- [[ divs: c + a/b => (c * b + a) / b
			for i,x in ipairs(expr) do
				if div.is(x) then
					assert(#x == 2)
					local a,b = table.unpack(x)
					expr = expr:shallowCopy()
					table.remove(expr, i)
					if #expr == 1 then expr = expr[1] end
					expr = (expr * b + a) / b
					return prune:apply(expr)
				end
			end
			--]]
			--[[ divs all at once: a/b + c/d + e => (d*a + b*d + b*d*e) / (b*d)
			do
				local denom 
				for i,x in ipairs(expr) do
					if div.is(x) then
						denom = denom or table()
						denom:insert(x[2])
					end
				end
				if denom then
					denom = #denom == 1 and denom[1] or mul(denom:unpack())
					local nums = table()
					for i,x in ipairs(expr) do
						local num = table()
						for j,y in ipairs(expr) do
							if div.is(y) and i ~= j then num:insert(y[2]) end
						end				
						if div.is(x) then
							num:insert(1, x[1])
							num = #num == 1 and num[1] or mul(num:unpack()) 
							nums:insert(num)
						else
							num:insert(1, x)
							num = #num == 1 and num[1] or mul(num:unpack())
							nums:insert(num)
						end
					end
					nums = #nums == 1 and nums[1] or add(nums:unpack())
					return prune:apply(nums / denom)
				end
			end
			--]]


			--[=[ trigonometry identities
			-- cos(theta)^2 + sin(theta)^2 => 1
			-- TODO first get a working factor() function
			-- then replace all nodes of cos^2 + sin^2 with 1
			-- ... or of cos^2 with 1 - sin^2 and let the rest cancel out  (best to operate on one function rather than two)
			--  (that 2nd step possibly in a separate simplifyTrig() function of its own?)
			do
				local cos = require 'symmath.cos'
				local sin = require 'symmath.sin'
				local Function = require 'symmath.Function'
			
				local function checkAdd(ch)
					local cosAngle, sinAngle
					local cosIndex, sinIndex
					for i,x in ipairs(ch) do
						
						if pow.is(x)
						and Function.is(x[1])
						and Constant.isValue(x[2], 2)
						then
							if cos.is(x[1]) then
								if sinAngle then
									if sinAngle == x[1][1] then
										-- then remove sine and cosine and replace with a '1' and set modified
										table.remove(expr, i)	-- remove largest index first
										expr[sinIndex] = Constant(1)
										if #expr == 1 then expr = expr[1] end
										return expr
									end
								else
									cosIndex = i
									cosAngle = x[1][1]
								end
							elseif sin.is(x[1]) then
								if cosAngle then
									if cosAngle == x[1][1] then
										table.remove(expr, i)
										expr[cosIndex] = Constant(1)
										if #expr == 1 then expr = expr[1] end
										return expr
									end
								else
									sinIndex = i
									sinAngle = x[1][1]
								end
							end
						end
					end
				end

				--[[ not sure what this special case was doing here ...
				do
					local cos = require 'symmath.cos'
					local sin = require 'symmath.sin'
					local Function = require 'symmath.Function'

					-- using factor outright causes simplification loops ...
					-- how about only using it if we find a cos or a sin in our tree?
					local foundTrig = false
					require 'symmath.map'(expr, function(node)
						if cos.is(node) or sin.is(node) then
							foundTrig = true
						end
					end)

					if foundTrig then
						local result = checkAdd(expr)
						if result then
							return prune:apply(result) 
						end

						-- this is factoring ... and pruning ... 
						-- such that it is recursively calling this function for its simplification
						local f = require 'symmath.factor'(expr)
						if f then
							return f
						end
					end	
				end	
				--]]
				--[[ 
				if mul.is(f) then	-- should always be a mul unless there was nothing to factor
					for _,ch in ipairs(f) do
						if add.is(ch) then
							local result = checkAdd(ch)
							if result then 
								return prune:apply(result) 
							end
						end
					end
				end
				--]]
			end
			--]=]
		end},
	
		-- log(a) + log(b) = log(ab)
		{logMul = function(prune, expr)
			local symmath = require 'symmath'
			local found
			local log = symmath.log
			for i=#expr-1,1,-1 do
				local a = expr[i]
				for j=#expr,i+1,-1 do
					local b = expr[j]
					if log.is(a) and log.is(b) then
						if not found then
							expr = expr:shallowCopy()
							found = true
						end
						table.remove(expr, j)
						expr[i] = log(a[1] * b[1])
					end
				end
			end
			if #expr == 1 then expr = expr[1] end
			if found then return expr end
		end},
	},

	Tidy = {
		{apply = function(tidy, expr)
			local unm = require 'symmath.op.unm'
			for i=1,#expr-1 do
				-- x + -y => x - y
				if unm.is(expr[i+1]) then
--[=[ old					
					local a = table.remove(expr, i)
					local b = table.remove(expr, i)[1]
					assert(a)
					assert(b)
					table.insert(expr, i, a - b)
					
					assert(#expr > 0)
					if #expr == 1 then
						expr = expr[1]
					end
					assert(#expr > 1)
					return tidy:apply(expr)
--]=]
-- [=[ new
					expr = expr:shallowCopy()
					local a = table.remove(expr, i)
					assert(a)
					local b = table.remove(expr, i)[1]
					assert(b)
					table.insert(expr, i, a - b)
					assert(#expr > 0)
					if #expr == 1 then
						return expr[1]
					end
					assert(#expr > 1)
					return tidy:apply(expr)
--]=]
				end
			end
		end},
	
		-- can't seem to catch this at the right place 
		--[[
		{trig = function(tidy, expr)
			local Constant = require 'symmath.Constant'
			local pow = require 'symmath.op.pow'
			local cos = require 'symmath.cos'
			if #self == 1
			and Constant.is(self[1]) 
			and self[1].value == 1
			and mul.is(self[2])
			and Constant.is(self[2][1])
			and self[2][1].value == -1
			and pow.is(self[2][2])
			and cos.is(self[2][2][1])
			and Constant.is(self[2][2][2])
			and self[2][2][2].value == 2
			then
				local sin = require 'symmath.sin'
				return sin(x[2][2][1][1])^2
			end
		end},
		--]]
	},
}

return add
