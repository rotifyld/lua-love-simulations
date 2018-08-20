local CentralMeteor = {}
CentralMeteor.__index = CentralMeteor

setmetatable(CentralMeteor, {
	__index = Meteor,
	__call = function(cls, ...)
			local self = setmetatable({}, cls)
			self:new(...)
			return self
		end
	})

function CentralMeteor:new()

	Meteor.new(self)

	self.x = canvas.x / 2
	self.y = canvas.y / 2

	self.vx = 0
	self.vy = 0

	self.mass = const.centralMass

	self.r = (self.mass / const.meteorDensity) ^ (1/3)

end

return CentralMeteor