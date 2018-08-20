
require("util")

camera = {}
camera.x = 0
camera.y = 0
camera.vx = 0
camera.vy = 0
camera.zoom = 1
camera.vzoom = 0

function camera:set()
	love.graphics.push()
	love.graphics.scale(self.zoom, self.zoom)
	love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
	love.graphics.pop()
end

function camera:update(dt)
	local x = 0	-- horizontal
	local y = 0 -- vertical
	if love.keyboard.isDown("right") then x = x + 1 end 
	if love.keyboard.isDown("left") then x = x - 1 end 
	if love.keyboard.isDown("down") then y = y + 1 end
	if love.keyboard.isDown("up") then y = y - 1 end 

	if x ~= 0 then
		self.vx = middle(-const.cameraMaxVelocity, self.vx + x * const.cameraAcceleration * dt, const.cameraMaxVelocity)
	elseif self.vx ~= 0 then
		local sign = (self.vx > 0 and 1 or -1)
		self.vx = self.vx + -sign * const.cameraAcceleration * dt
		if sign > 0 and self.vx < 0 or sign < 0 and self.vx > 0 then self.vx = 0 end 
	end

	if y ~= 0 then
		self.vy = middle(-const.cameraMaxVelocity, self.vy + y * const.cameraAcceleration * dt, const.cameraMaxVelocity)
	elseif self.vy ~= 0 then
		local sign = (self.vy > 0 and 1 or -1)
		self.vy = self.vy + -sign * const.cameraAcceleration * dt
		if sign > 0 and self.vy < 0 or sign < 0 and self.vy > 0 then self.vy = 0 end 
	end

	self:move(self.vx * dt, self.vy * dt)
	
end

function camera:move(dx, dy)
	self.x = self.x + (dx or 0)
	self.y = self.y + (dy or 0)
end

function camera:scale(ds)
	self.zoom = self.zoom * ds

	-- self.x = self.x + canvas.x * (1 - self.zoom) / 2 -- fixme
	-- self.y = self.y + canvas.y * (1 - self.zoom) / 2
end

function camera:setPosition(x, y)
	self.x = x or self.x
	self.y = y or self.y
end

function camera:setScale(s)
	self.zoom = s
end