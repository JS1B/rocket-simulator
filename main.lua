local Target = require "target"
local Missile = require "missile"

-- Load function in the LÖVE framework
function love.load()
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")
    -- Create a new instance of the MovingTarget class
    mytarget = Target:new(10, 50, 25)
    mymissile = Missile:new(20, love.graphics.getHeight()-10, 50)
end

-- Update function in the LÖVE framework

local lastTime = 0.0
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)
    mymissile:update(dt, mytarget, "PG")

    -- Trigger points/dots draw
    local curTime = love.timer.getTime()
    if lastTime + 0.5 < curTime then
        mymissile:appendPoint()
        lastTime = curTime
    end
end

-- Draw function in the LÖVE framework
function love.draw()
    -- Draw the target
    mytarget:draw()
    mymissile:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end