local class = require 'ext.class'
local table = require 'ext.table'
local Language = require 'symmath.tostring.Language'
local C = class(Language)

--[[
this is really being used for OpenCL
hence all the redundant real type casts
TODO provide the type instead of using 'real'
also TODO - merge common stuff between this and tostring.Lua into the Language class
also TODO - fix differences with compile() and generate()
--]]

C.lookupTable = {
	[require 'symmath.Constant'] = function(self, expr, vars)
		local s = tostring(expr.value)
		if not s:find'e' then
			if not s:find'%.' then s = s .. '.' end
		end
		return {s}
	end,
	[require 'symmath.Invalid'] = function(self, expr, vars)
		return {'NAN'}
	end,
	[require 'symmath.Function'] = function(self, expr, vars)
		local predefs = table()
		local s = table()
		for i,x in ipairs(expr) do
			local sx = self:apply(x, vars)
			s:insert(sx[1])
			predefs = table(predefs, sx[2])
		end
		s = s:concat(', ')
		
		local funcName
		if not expr.code then
			funcName = expr.name
		else
			funcName = expr.name
			predefs['real '..funcName..'(real x) {'..expr.code..'}'] = true
		end
		return {funcName .. '(' .. s .. ')', predefs}
	end,
	[require 'symmath.unmOp'] = function(self, expr, vars)
		local sx = self:apply(expr[1], vars)
		return {'(-'..sx[1]..')', sx[2]}
	end,
	[require 'symmath.powOp'] = function(self, expr, vars)
		local predefs = table()
		local s = table()
		for i,x in ipairs(expr) do
			local sx = self:apply(x, vars)
			s:insert('(real)'..sx[1])
			predefs = table(predefs, sx[2])
		end
		s = s:concat(', ')
		
		return {'(real)pow(' .. s .. ')', predefs}	
	end,
	[require 'symmath.BinaryOp'] = function(self, expr, vars)
		local predefs = table()
		local s = table()
		for i,x in ipairs(expr) do
			local sx = self:apply(x, vars)
			s:insert(sx[1])
			predefs = table(predefs, sx[2])
		end
		s = s:concat(' '..expr.name..' ')
		return {'('..s..')', predefs}
	end,
	[require 'symmath.Variable'] = function(self, expr, vars)
		if table.find(vars, nil, function(var) 
			return expr.name == var.name 
		end) then
			return {expr.name}
		end
		error("tried to compile variable "..expr.name.." that wasn't in your function argument variable list!\n"
		..(require 'symmath.tostring.MultiLine')(expr))
	end,
	[require 'symmath.Derivative'] = function(self, expr) 
		error("can't compile differentiation.  replace() your diff'd content first!\n"
		..(require 'symmath.tostring.MultiLine')(expr))
	end,
	[require 'symmath.Array'] = function(self, expr, vars)
		error("can't compile arrays in C.  replace() your diff'd content first!\n"
		..(require 'symmath.tostring.MultiLine')(expr))
	end,
}

function C:compile(expr, paramInputs)
	local expr, vars = self:prepareForCompile(expr, paramInputs)
	local info = self:apply(expr, vars)
	local body = info[1]
	local predefs = info[2]
	local code = (predefs and #predefs > 0) and (table.keys(predefs):concat'\n'..'\n') or ''
	return code..'('..
		vars:map(function(var) 	
			return 'real '..var.name
		end):concat(', ')
	..') { return '..body..'; }'
end

function C:__call(...)
	return self:apply(...)[1]
end

return C()	-- singleton
