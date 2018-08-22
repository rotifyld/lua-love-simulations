--[[ 02.08.2018 ~ 
author: Dawid Borys
 email: dawidborys98@gmail.com
github: https://github.com/rotifyld
]]

--[[ possible future expantions

[x] camera movement
[ ] ifCentral -> velocity(radius) curve
[~] improve trace & color mixing
[ ] implement real values (Sun-Earth, Galaxy)?
[ ] user API

[x] fix problems with angular momentum
]]

function love.conf(t)
	t.identity = "save"
	t.console = true
end

function love.load()

	love.window.setMode(0,0, {})


	Meteor = require("meteor")
	CentralMeteor = require("centralMeteor")
	NonCentralMeteor = require("nonCentralMeteor")
	Trace = require("trace")
	require("camera")


	--[[ nice results: {number = 1000, G = 10000, meteorDensity = 0.1, meteorMinStartMass = 1, meteorMaxStartMass = 1,
						central = false, meteorSpeedIfNCentral = 1000]]
	const = 
	{
		updateStep = 0.01,
		number = 1000, G = 10000, meteorDensity = 0.1, meteorMinStartMass = 1, meteorMaxStartMass = 1,
		traceTime = 0.2, traceLifespan = 1, traceR = 0.2, cameraAcceleration = 1000, cameraMaxVelocity = 500, zoom = 2,
		central = true, 
		--[[if central == true ]] centralMass = 3000, meteorSpeedIfCentral = 0.0025,
		--[[if central == false]] meteorSpeedIfNCentral = 1000,
	}

	canvas = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
	meteors  = {}

	recording = false
	shot = 0

	-- create central meteor
	if const.central then
		table.insert(meteors, CentralMeteor())
	end

	-- create meteors
	for i = 1, const.number, 1 do
		table.insert(meteors, NonCentralMeteor())
	end

end

function love.keypressed(k)
	
	if k == "9" then recording = not recording end

	if k == "0" then love.graphics.captureScreenshot(os.time() .. ".png") end

	if k == "w" then camera:scale(const.zoom) end
	if k == "s" then camera:scale(1 / const.zoom) end

end

function love.update(dt)

	camera:update(const.updateStep)

	if recording then 
		love.graphics.captureScreenshot(shot .. ".png")
		shot = shot + 1
	end

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
		v:update(const.updateStep)
	end
end

function love.draw()
	love.graphics.setBackgroundColor(0, 0, 0)

  	camera:set()
	for _, v in pairs(meteors) do
		v:draw()
	end
	camera:unset()
end