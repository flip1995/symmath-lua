#!/usr/bin/env lua
local lfs = require 'lfs'
require 'ext'
local function recurse(dir)
	for f in file[dir]() do
		local fn = dir..'/'..f
		if io.isdir(fn) then
			recurse(fn)
		elseif f:sub(-4) == '.lua' then
			local target = 'output/'..fn:sub(1,-5)..'.html'
			if not io.fileexists(target) 
			or lfs.attributes(target).change < lfs.attributes(fn).change 
			then
				os.execute('mkdir output/'..dir)
				os.execute('"'..fn..'" > "'..target..'"')
			else
				print(fn..' is up-to-date.')
			end
		end
	end
end
recurse'.'
