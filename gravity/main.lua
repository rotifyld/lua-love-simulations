--[[ 02.08.2018 ~ 
author: Dawid Borys
 email: dawidborys98@gmail.com
github: https://github.com/rotifyld
]]

--[[ todo

 dt -> fixed update time
 trace (?)


]]

function love.conf(t)
	t.identity = "save"
	t.console = true
end

function love.load()

	Meteor = require("meteor")
	Trace = require("trace")

	-- nice results: {number = 1000, meteorSpeed = 1000, meteorMinStartMass = 1, meteorMaxStartMass = 1, meteorDensity = 0.1, G = 10000
	const = {number = 1000, meteorSpeed = 1000, meteorMinStartMass = 1, meteorMaxStartMass = 1,
			 meteorDensity = 0.1, G = 300, central = true, centralMass = 30000, meteorWithCentralSpeed = 0.004,
			 traceTime = 0.2, traceLifespan = 1, traceR = 0.2}

	canvas = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
	meteors  = {}

	-- create central meteor
	if const.central then
		table.insert(meteors, Meteor(true))
	end

	-- create meteors
	for i=1,const.number,1 do
		table.insert(meteors, Meteor())
	end

end

function love.keypressed(k)
	if k == "0" then love.graphics.captureScreenshot("screenshot.png") end
end

function love.update(dt)

	for i, v in pairs(meteors) do
		for j, u in pairs(meteors) do
			if i < j then
				if not v:addGravitationalInfluence(u) then
					table.remove(meteors, j)
				end
			end
		end
	end

	for _, v in pairs(meteors) do
		v:update(0.01)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)

	for _, v in pairs(meteors) do
		v:draw()
	end
end