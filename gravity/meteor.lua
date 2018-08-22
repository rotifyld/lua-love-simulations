local Meteor = {}
Meteor.__index = Meteor

setmetatable(Meteor, 
	{
		__call = function(cls, ...)
			local self = setmetatable({}, cls)
			self:new(...)
			return self
		end
	})

function Meteor:new(central)

	self.alpha = 0
	self.omega = 0

	-- gravitational force from the rest of particles
	self.fx = 0
	self.fy = 0

	self.rgba = {love.math.random(), love.math.random(), love.math.random(), 1}
	
	-- trace & timer
	self.traces = {}
	self.timeMax = const.traceTime
	self.timeLeft = self.timeMax

end

function Meteor:getMass() return self.mass end

function Meteor:getX() return self.x end

function Meteor:getY() return self.y end

function Meteor:getVx() return self.vx end

function Meteor:getVy() return self.vy end

function Meteor:getR() return self.r end

function Meteor:getMass() return self.mass end

function Meteor:getOmega() return self.omega end

function Meteor:getRgba() return self.rgba end

function Meteor:addGravitationalForce(forceX, forceY)
	self.fx = self.fx + forceX
	self.fy = self.fy + forceY
end

function Meteor:addGravitationalInfluence(meteor)
	local dx = meteor:getX() - self.x
	local dy = meteor:getY() - self.y
	local r = (dx^2 + dy^2)^(1/2)

	if r < (self.r + meteor:getR()) then

		self:impact(meteor, dx, dy, r)
		return false

	else
		local force = (const.G * self.mass * meteor:getMass()) / (r^2)
		local forceX = force * (dx / r)
		local forceY = force * (dy / r)

		self:addGravitationalForce(forceX, forceY)
		meteor:addGravitationalForce((-1) * forceX, (-1) * forceY)
		return true
	end
end

-- simplified calculations of the angular momentum and thus outcome angular speed
function Meteor:impact(meteor, dx, dy, r)

	local totalMass = self.mass + meteor:getMass()

	-- angular momentum of the more massive body
	local Lm = 0
	if self.mass > meteor:getMass() then 
		Lm = (2/5) * self.mass * (self.r ^ 2) * self.omega
	else
		Lm = (2/5) * meteor:getMass() * (meteor:getR() ^ 2) * meteor:getOmega()
	end
	
	-- angular momentum as a result of an impact
	local Li = dx * (self.mass * self.vy - meteor:getMass() * meteor:getVy())
			 - dy * (self.mass * self.vx - meteor:getMass() * meteor:getVx())

	self.x = (self.x * self.mass + meteor:getX() * meteor:getMass()) / totalMass
	self.y = (self.y * self.mass + meteor:getY() * meteor:getMass()) / totalMass
	self.vx = (self.vx * self.mass + meteor:getVx() * meteor:getMass()) / totalMass
	self.vy = (self.vy * self.mass + meteor:getVy() * meteor:getMass()) / totalMass

	self.mass = totalMass
	self.r = (self.mass / const.meteorDensity) ^ (1/3) 

	self.omega = self.omega + (Lm + Li) / ((2/5) * self.mass * (self.r ^ 2))

	for i = 1, 3, 1 do
		self.rgba[i] = (self.rgba[i] / 2 + meteor:getRgba()[i] / 2 )
	end 
end

function Meteor:update(dt)
	
	-- trace countdown
	self.timeLeft = self.timeLeft - dt
	if self.timeLeft < 0 then
		self.timeLeft = self.timeLeft + self.timeMax
		table.insert(self.traces, Trace(self.x, self.y, self.rgba))
	end

	for i, v in pairs(self.traces) do
		if v:update(dt) then table.remove(self.traces, i) end
	end

	-- rotate
	self.alpha = self.alpha + self.omega * dt
	if self.alpha - 2 * math.pi > 0 then self.alpha = self.alpha - 2 * math.pi end 

	-- apply force to change velocity
	self.vx = self.vx + (self.fx / self.mass) * dt
	self.vy = self.vy + (self.fy / self.mass) * dt

	self.fx = 0
	self.fy = 0

	-- move
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
end

function Meteor:draw()

	for _, v in pairs(self.traces) do v:draw() end

	love.graphics.setColor(self.rgba)
	love.graphics.circle("fill", self.x, self.y, self.r)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.line(self.x - math.sin(self.alpha) * self.r / 2, self.y - math.cos(self.alpha) * self.r / 2,
					   self.x + math.sin(self.alpha) * self.r / 2, self.y + math.cos(self.alpha) * self.r / 2)	
end

return Meteor