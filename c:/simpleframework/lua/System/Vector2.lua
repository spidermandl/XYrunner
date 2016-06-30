--------------------------------------------------------------------------------
--      Copyright (c) 2015 , 蒙占志(topameng) topameng@gmail.com
--      All rights reserved.
--
--      Use, modification and distribution are subject to the "New BSD License"
--      as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.
--------------------------------------------------------------------------------

local sqrt = math.sqrt
local setmetatable = setmetatable
local rawset = rawset
local rawget = rawget

Vector2 = 
{
--[[	x = 0,
	y = 0,		
	
	class = "Vector2",--]]
}

setmetatable(Vector2, Vector2)

local fields = {}

Vector2.__index = function(t,k)
	local var = rawget(Vector2, k)
	
	if var == nil then							
		var = rawget(fields, k)
		
		if var ~= nil then
			return var(t)
		end
	end
	
	return var
end

function Vector2.New(x, y)
	local v = {x = x or 0, y = y or 0}
	setmetatable(v, Vector2)	
	return v
end

function Vector2:Set(x,y)
	self.x = x or 0
	self.y = y or 0	
end

function Vector2:Get()
	return self.x, self.y
end

function Vector2:SqrMagnitude()
	return self.x * self.x + self.y * self.y
end

function Vector2:Clone()
	return Vector2.New(self.x, self.y)
end

function Vector2:Normalize()
	local v = self:Clone()
	return v:SetNormalize()	
end

function Vector2:SetNormalize()
	local num = self:Magnitude()	
	
	if num == 1 then
		return self
    elseif num > 1e-05 then    
        self:Div(num)
    else    
        self:Set(0,0)
	end 

	return self
end

function Vector2.Dot(lhs, rhs)
	return lhs.x * rhs.x + lhs.y * rhs.y
end

function Vector2.Angle(from, to)
	return acos(clamp(Vector2.dot(from:Normalize(), to:Normalize()), -1, 1)) * 57.29578
end


function Vector2.Magnitude(v2)
	return sqrt(v2.x * v2.x + v2.y * v2.y)
end

function Vector2:Div(d)
	self.x = self.x / d
	self.y = self.y / d	
	
	return self
end

function Vector2:Mul(d)
	self.x = self.x * d
	self.y = self.y * d
	
	return self
end

function Vector2:Add(b)
	self.x = self.x + b.x
	self.y = self.y + b.y
	
	return self
end

function Vector2:Sub(b)
	self.x = self.x - b.x
	self.y = self.y - b.y
	
	return
end

Vector2.__tostring = function(self)
	return string.format("[%f,%f]", self.x, self.y)
end

Vector2.__div = function(va, d)
	return Vector2.New(va.x / d, va.y / d)
end

Vector2.__mul = function(va, d)
	return Vector2.New(va.x * d, va.y * d)
end

Vector2.__add = function(va, vb)
	return Vector2.New(va.x + vb.x, va.y + vb.y)
end

Vector2.__sub = function(va, vb)
	return Vector2.New(va.x - vb.x, va.y - vb.y)
end

Vector2.__unm = function(va)
	return Vector2.New(-va.x, -va.y)
end

Vector2.__eq = function(va,vb)
	return va.x == vb.x and va.y == vb.y
end

fields.up 		= function() return Vector2.New(0,1) end
fields.right	= function() return Vector2.New(1,0) end
fields.zero		= function() return Vector2.New(0,0) end
fields.one		= function() return Vector2.New(1,1) end

fields.magnitude 	= Vector2.Magnitude
fields.normalized 	= Vector2.Normalize
fields.sqrMagnitude = Vector2.SqrMagnitude