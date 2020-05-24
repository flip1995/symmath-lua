#!/usr/bin/env lua
local lfs = require 'lfs'
require 'ext'
local function exec(cmd)
	print('>'..cmd)
	return os.execute(cmd)
end
for f in io.dir'.' do
	if f:sub(-4) == '.lua' then
		local target = 'output/'..f:sub(1,-5)..'.html'
		local fileattr = lfs.attributes(f)
		local targetattr = lfs.attributes(target)
		if fileattr and targetattr then
			print('comparing '..os.date(nil, targetattr.change)..' vs '..os.date(nil, fileattr.change))
		end
		if not targetattr or targetattr.change < fileattr.change then
			if not io.isdir'output' then exec'mkdir output' end
			exec('"./'..f..'" > "'..target..'"')
		else
			print(f..' is up-to-date.')
		end
	end
end
