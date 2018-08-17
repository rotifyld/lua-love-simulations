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

	const = {number = 10000, meteorSpeed = 1000, meteorMinStartMass = 1, meteorMaxStartMass = 3,
			 meteorDensity = 0.5, G = 10000, traceTime = 0.1, minMergeDistance = 5}

	canvas = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
	meteors  = {}

	-- create meteors
	for i=1,const.number,1 do
		table.insert(meteors, Meteor())
	end

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
	love.graphics.setBackgroundColor(1, 1, 1)

	for _, v in pairs(meteors) do
		v:draw()
	end
end