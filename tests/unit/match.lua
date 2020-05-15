#!/usr/bin/env lua

local symmath = require 'symmath'
local W = symmath.Wildcard
local Constant = symmath.Constant
local zero = Constant(0)
local one = Constant(1)

local x = symmath.var'x'
local y = symmath.var'y'

-- [[
assert(x:match(x))
assert(x == x)
assert(x ~= y)
assert(not x:match(y))
assert((x + y) == (x + y))
assert((x + y):match(x + y))

-- add match to first term
local i = (x + y):match(W(1) + y)
assert(i == x)

-- add match to second term
local i = (x + y):match(x + W(1))
assert(i == y)

-- change order
local i = (x + y):match(y + W(1))
assert(i == x)

-- add match to zero, because nothing's left
local i = (x + y):match(x + y + W(1))
assert(i == zero)

local i = (x + y):match(W(1))
assert(i == x + y)

-- doubled-up matches should only work if they match
local i = (x + y):match(W(1) + W(1))
assert(i == false)

-- this too, this would work only if x + x and not x + y
local i = (x + x):match(W(1) + W(1))
assert(i == x)
--]]

-- this too
local i,j = (x + x):match(W{1, atMost=1} + W{2, atMost=1})
assert(i == x)
assert(j == x)

-- this should match (x+y), 0
local i,j = (x + y):match(W(1) + W(2))
assert(i == x + y)
assert(j == zero)

local i,j = (x + y):match(W{1, atMost=1} + W{2, atMost=1})
assert(i == x)
assert(j == y)

-- for these to work, I have to add the multi-wildcard stuff to the non-wildcard elements, handled in add.wildcardMatches
local i,j = x:match(W(1) + W(2))
assert(i == x)
assert(j == zero)

local i,j = (x * y):match(W(1) + W(2))
assert(i == x * y)
assert(j == zero)

-- for this to work, add.wildcardMatches must call the wildcard-capable objects' own wildcard handlers correctly (and use push/pop match states, instead of assigning to wildcard indexes directly?)
-- also, because add.wildcardMatches assigns the extra wildcards to zero, it will be assigning (W(2) * W(3)) to zero ... which means it must (a) handle mul.wildcardMatches and (b) pick who of mul's children gets the zero and who doesn't
--  it also means that a situation like add->mul->add might have problems ... x:match(W(1) + (W(2) + W(3)) * (W(4) + W(5)))
local i,j,k = x:match(W(1) + W(2) * W(3))
assert(i == x)
assert(j == zero)	-- technically only one of these two needs to be zero
assert(k == zero)

-- same with mul

local i = (x * y):match(y * W(1))
assert(i == x)

local i = (x * y):match(x * y * W(1))
assert(i == one)

local i = (x * y):match(W(1))
assert(i == x * y)

local i = (x * y):match(W(1) * W(1))
assert(i == false)

local i = (x * x):match(W(1) * W(1))
assert(i == x)

local i,j = (x * x):match(W{1, atMost=1} * W{2, atMost=1})
assert(i == x)
assert(j == x)

local i,j = (x * y):match(W(1) * W(2))
assert(i == x * y)
assert(j == one)

local i,j = (x * y):match(W{1, atMost=1} * W{2, atMost=1})
assert(i == x)
assert(j == y)
