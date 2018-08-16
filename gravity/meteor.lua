local Meteor = {}
Meteor.__index = Meteor

setmetatable(Meteor, { __call = function(_, ...) return Meteor.new(...) end })

function Meteor.new()
	local self = setmetatable({}, Meteor)
	self.pos = {}
	self.pos.x = love.math.random() * canvas.x
	self.pos.y = love.math.random() * canvas.y
	self.v = {}
	self.v.x = (love.math.random() - 0.5) * const.meteorSpeed
	self.v.y = (love.math.random() - 0.5) * const.meteorSpeed

	self.r = const.meteorR
	self.mass = love.math.random() * const.meteorMass

	self.f = {x = 0, y = 0}	-- gravitational force from the rest of particles

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
	return self.pos.x
end

function Meteor:getY()
	return self.pos.y
end

function Meteor:addGravitationalInfluence(meteor)

	local dx = meteor:getX() - self.pos.x
	local dy = meteor:getY() - self.pos.y
	local r = (dx^2 + dy^2)^(1/2)
	local force = (const.G * self.mass * meteor:getMass()) / r^2
	self.f.x = self.f.x + force * (dx / r)
	self.f.y = self.f.y + force * (dy / r)

end

function Meteor:update(dt)
	-- trace countdown todo

	-- apply force to change velocity
	self.v.x = self.v.x + (self.f.x / self.mass) * dt
	self.v.y = self.v.y + (self.f.y / self.mass) * dt

	self.f.x = 0
	self.f.y = 0

	-- move
	self.pos.x = self.pos.x + self.v.x * dt
	self.pos.y = self.pos.y + self.v.y * dt
end

function Meteor:draw()
	love.graphics.setColor(self.rgba)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.r)
	
end

return Meteor