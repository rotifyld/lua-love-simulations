local Meteor = {}
Meteor.__index = Meteor

setmetatable(Meteor, { __call = function(_, ...) return Meteor.new(...) end })

function Meteor.new()
	local self = setmetatable({}, Meteor)
	self.x = love.math.random() * canvas.x
	self.y = love.math.random() * canvas.y

	self.alpha = 0
	self.omega = 0

	self.vx = (love.math.random() - 0.5) * const.meteorSpeed
	self.vy = (love.math.random() - 0.5) * const.meteorSpeed

	self.mass = const.meteorMinStartMass + love.math.random() * (const.meteorMaxStartMass - const.meteorMinStartMass)
	self.r = (self.mass / const.meteorDensity) ^ (1/3)

	self.fx = 0-- gravitational force from the rest of particles
	self.fy = 0

	--[[ trace timer
	self.timeMax = const.traceTime
	self.timeLeft = self.timeMax]]

	self.rgba = {0, 0, 0, 1} -- todo

	return self
end

function Meteor:getMass()
	return self.mass
end

function Meteor:getX()
	return self.x
end

function Meteor:getY()
	return self.y
end

function Meteor:getVx()
	return self.vx
end

function Meteor:getVy()
	return self.vy
end

function Meteor:getR()
	return self.r
end

function Meteor:getMass()
	return self.mass
end

function Meteor:getOmega()
	return self.omega
end

function Meteor:addGravitationalForce(forceX, forceY)
	self.fx = self.fx + forceX
	self.fy = self.fy + forceY
end



function Meteor:addGravitationalInfluence(meteor)
	local dx = meteor:getX() - self.x
	local dy = meteor:getY() - self.y
	local r = (dx^2 + dy^2)^(1/2)

	if r < (self.r + meteor:getR()) then
		local totalMass = self.mass + meteor:getMass()

		local L1 = (2/5) * self.mass * (self.r ^ 2) * self.omega
		local L2 = (2/5) * meteor:getMass() * (meteor:getR() ^ 2) * meteor:getOmega()
		local L = dx * (self.mass * self.vy - meteor:getMass() * meteor:getVy()) -
				  dy * (self.mass * self.vx - meteor:getMass() * meteor:getVx())

		self.x = (self.x * self.mass + meteor:getX() * meteor:getMass()) / totalMass
		self.y = (self.y * self.mass + meteor:getY() * meteor:getMass()) / totalMass
		self.vx = (self.vx * self.mass + meteor:getVx() * meteor:getMass()) / totalMass
		self.vy = (self.vy * self.mass + meteor:getVy() * meteor:getMass()) / totalMass

		self.mass = totalMass
		self.r = (self.mass / const.meteorDensity) ^ (1/3) 

		self.omega = (L1 + L2 + L) / ((2/5) * self.mass * (self.r ^ 2))

		return false
	else
		local force = (const.G * self.mass * meteor:getMass()) / (r^2)
		local forceX = force * (dx / r)
		local forceY = force * (dy / r)

	--	print("dx = " .. dx .. "\ndy = "..dy.."\n r = "..r.."\n f = "..force.."\nfx = "..forceX.."\nfy = "..forceY)--debug

		self:addGravitationalForce(forceX, forceY)
		meteor:addGravitationalForce((-1) * forceX, (-1) * forceY)
		return true
	end
end

function Meteor:update(dt)
	-- trace countdown todo

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
	love.graphics.setColor(self.rgba)
	love.graphics.circle("fill", self.x, self.y, self.r)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.line(self.x - math.sin(self.alpha) * self.r / 2, self.y - math.cos(self.alpha) * self.r / 2,
					   self.x + math.sin(self.alpha) * self.r / 2, self.y + math.cos(self.alpha) * self.r / 2)	
end

return Meteor