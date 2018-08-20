require("util")

local NonCentralMeteor = {}
NonCentralMeteor.__index = NonCentralMeteor

setmetatable(NonCentralMeteor, {
	__index = Meteor,
	__call = function(cls, ...)
			local self = setmetatable({}, cls)
			self:new(...)
			return self
		end
	})

function NonCentralMeteor:new()

	Meteor.new(self)


	local r = love.math.random() * canvas.y / 2 + 50
	local phi = love.math.random() * 2 * math.pi

	self.x = r * math.cos(phi) + canvas.x / 2
	self.y = r * math.sin(phi) + canvas.y / 2

	self.mass = const.meteorMinStartMass + love.math.random() * (const.meteorMaxStartMass - const.meteorMinStartMass)
	
	if const.central then 
		local r = distance(self.x, self.y, canvas.x / 2, canvas.y / 2)
		local v = ((const.G * const.centralMass) / r) * const.meteorSpeedIfCentral
		self.vx = (-1) * v * (self.y - (canvas.y/2)) / r
		self.vy = v * (self.x - (canvas.x/2)) / r
	else
		self.vx = (love.math.random() - 0.5) * const.meteorSpeedIfNCentral
		self.vy = (love.math.random() - 0.5) * const.meteorSpeedIfNCentral
	end

	self.r = (self.mass / const.meteorDensity) ^ (1/3)

end

return NonCentralMeteor