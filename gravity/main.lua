--[[ 02.08.2018 ~ 
author: Dawid Borys
 email: dawidborys98@gmail.com
github: https://github.com/rotifyld
]]

function love.conf(t)
	t.identity = "save"
	t.console = true
end

function love.load()

	Meteor = require("meteor")

	const = {number = 10, meteorSpeed = 10, meteorR = 5, meteorMass = 10, G = 100000, traceTime = 0.1}

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
				v:addGravitationalInfluence(u)
				u:addGravitationalInfluence(v)
				end
		end
	end

	for _, v in pairs(meteors) do
		v:update(dt)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(1, 1, 1)

	for _, v in pairs(meteors) do
		v:draw()
	end
end