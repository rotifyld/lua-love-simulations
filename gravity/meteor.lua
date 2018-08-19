local Meteor = {}
Meteor.__index = Meteor

setmetatable(Meteor, { __call = function(_, ...) return Meteor.new(...) end })

local function distance(x1, y1, x2, y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function Meteor.new(central)
	local self = setmetatable({}, Meteor)
	
	if central then
		self.x = canvas.x / 2
		self.y = canvas.y / 2

		self.vx = 0
		self.vy = 0

		self.mass = const.centralMass
	else
		local r = love.math.random() * canvas.y / 2 + 50
		local phi = love.math.random() * 2 * math.pi

		self.x = r * math.cos(phi) + canvas.x / 2
		self.y = r * math.sin(phi) + canvas.y / 2

		self.mass = const.meteorMinStartMass + love.math.random() * (const.meteorMaxStartMass - const.meteorMinStartMass)
		
		if const.central then 	-- if there is a central mass, initial velocity = orbital speed
			local r = distance(self.x, self.y, canvas.x / 2, canvas.y / 2)
			local v = ((const.G * const.centralMass) / r) * const.meteorWithCentralSpeed
			self.vx = (-1) * v * (self.y - (canvas.y/2)) / r
			self.vy = v * (self.x - (canvas.x/2)) / r
		else
			self.vx = (love.math.random() - 0.5) * const.meteorSpeed
			self.vy = (love.math.random() - 0.5) * const.meteorSpeed
		end
	end

	self.r = (self.mass / const.meteorDensity) ^ (1/5)

	self.alpha = 0
	self.omega = 0

	self.fx = 0-- gravitational force from the rest of particles
	self.fy = 0

	self.rgba = {love.math.random(), love.math.random(), love.math.random(), 1} -- todo
	
	-- trace timer
	self.traces = {}
	self.timeMax = const.traceTime
	self.timeLeft = self.timeMax

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
		self.r = (self.mass / const.meteorDensity) ^ (1/5) 

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