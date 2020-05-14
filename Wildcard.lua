local class = require 'ext.class'
local Expression = require 'symmath.Expression'

local Wildcard = class(Expression)

--[[
args:
	index = which index slot to return in the wildcard matching
		x1, x2, x3 = expr:match(...)
		where x1 matches to the Wildcard with index==1
	dependsOn = variable that the Wildcard expression must depend on
	cannotDependOn = variable that the Wildcard expression cannot depend on
	atLeast = for + and *, which match an arbitrary subset, this is at least the number of elements to match
	atMost = for + and * this is the most number of elements to match.
set 'args' to a number to only set that index
--]]
function Wildcard:init(args)
	if type(args) == 'number' then
		self.index = args
	elseif type(args) == 'table' then
		self.index = args.index or 1
		-- use some field names that don't overlap with Expression methods like 'dependsOn'
		self.wildcardDependsOn = args.dependsOn
		self.wildcardCannotDependOn = args.cannotDependOn
		self.atLeast = args.atLeast
		self.atMost = args.atMost
		if self.atMost then
			assert(self.atMost > 0, "if atMost <= 0 then what are you trying to match?")
		end
	elseif type(args) == 'nil' then
		self.index = 1
	end
end

function Wildcard:wildcardMatches(expr)
	-- if we said 'it must depend on var x' and it doesn't, then fail
	if self.wildcardDependsOn 
	and not expr:dependsOn(self.wildcardDependsOn)
	then
		return false
	end

	-- if we said 'it must not depend on var x' and it does, then fail
	if self.wildcardCannotDependOn
	and expr:dependsOn(self.wildcardCannotDependOn)
	then
		return false
	end

	return true
end

return Wildcard
