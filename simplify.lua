local table = require 'ext.table'

local simplifyObj = {}

local function simplify(x, ...)
	-- I'm suspicious that arrays are getting into simplify loops because of them simplifying all expressions simultaneously ... 
	-- this doesn't make sense, but maybe it's true
	local Array = require 'symmath.Array'
	if Array.is(x) then
		x = x:clone()
		for i in x:iter() do
			x[i] = simplify(x[i])
		end
		return x
	end
	
	local symmath = require 'symmath'
	local debugSimplifyLoops = symmath.debugSimplifyLoops
	local simplifyMaxIter = symmath.simplifyMaxIter or 10

	local expand = symmath.expand
	local prune = symmath.prune
	local factor = symmath.factor
	local tidy = symmath.tidy
	local Invalid = symmath.Invalid
	local lastx
	
	local clone, stack
	if debugSimplifyLoops then
		-- [[ with stack trace on loop  
		clone = symmath.clone
		stack = table()
	end
	if stack then stack:insert(clone(x)) end
	x = prune(x, ...)
	if stack then stack:insert(clone(x)) end
	local i = 0
	repeat
		lastx = x	-- lastx = x invokes the simplification loop.  that means one of the next few commands operates in-place.
		
		x = expand(x, ...)	-- TODO only expand powers of sums if they are summed themselves  (i.e. only expand add -> power -> add)
		if stack then stack:insert(clone(x)) end
		x = prune(x, ...)
		if stack then stack:insert(clone(x)) end
		x = factor(x)
		if stack then stack:insert(clone(x)) end
		x = prune(x)
		if stack then stack:insert(clone(x)) end


		-- trigonometric
		-- where to put this, since doing one or the other means the other or the one missing out on div etc simplifications
		
		if x.map then
			local sin = symmath.sin
			local cos = symmath.cos
			local Constant = symmath.Constant
			local found
			x = x:map(function(expr)
				if cos.is(expr[1])
				and Constant.is(expr[2])
				then
					local n = expr[2].value
					if n >= 2
					and n <= 10
					and n == math.floor(n)
					then
						local th = expr[1][1]
						found = true
						return (1 - sin(th:clone())^2) * cos(th:clone())^(n-2)
					end
				end
			end)
			if found then
				x = expand(x, ...)
				x = prune(x, ...)
				x = factor(x, ...)
				x = prune(x, ...)
			end

			found = false
			x = x:map(function(expr)
				-- TODO this isn't being called
				-- where to put sin^2(theta) -> 1 - cos^2(theta) ...
				if sin.is(expr[1])
				and Constant.is(expr[2])
				then
					local n = expr[2].value
					if n >= 2
					and n <= 10
					and n == math.floor(n)
					then
						local th = expr[1][1]
						found = true
						return (1 - cos(th:clone())^2) * sin(th:clone())^(n-2)
					end
				end		
			end)
			if found then
				x = expand(x, ...)
				x = prune(x, ...)
				x = factor(x, ...)
				x = prune(x, ...)
			end
		end



		--do break end -- calling expand() again after this breaks things ...
		i = i + 1
	until i == simplifyMaxIter or x == lastx or getmetatable(x) == Invalid
	-- [[ debugging simplify loop stack trace
	if i == simplifyMaxIter then
		if stack then 
			for i,xi in ipairs(stack) do
				io.stderr:write('simplify stack #'..i..'\n'..xi..'\n')
			end
		end
		io.stderr:write("simplification loop\n")
	end
	--]]
	
	x = tidy(x, ...)

	simplifyObj.stack = stack

	return x
end

setmetatable(simplifyObj, {
	__call = function(_, ...)
		return simplify(...)
	end
})

return simplifyObj
