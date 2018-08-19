local Trace = {}
Trace.__index = Trace

setmetatable(Trace, { __call = function(_, ...) return Trace.new(...) end })

function Trace.new(x, y, rgba)
	local self = setmetatable({}, Trace)

	self.x = x
	self.y = y
	self.rgba = rgba
	self.timeLeft = const.traceLifespan

	return self
end

function Trace:update(dt)

	self.timeLeft = self.timeLeft - dt
	if self.timeLeft < 0 then return true end
	
end

function Trace:draw()

--	self.rgba[4] = self.rgba[4] * (self.timeLeft / const.traceLifespan)

	love.graphics.setColor(self.rgba)
	love.graphics.circle("line", self.x, self.y, const.traceR)
	
end

return Trace