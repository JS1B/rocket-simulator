local Target = require "target"
local Missile = require "missile"
local suit = require "SUIT"

-- Load function in the LÖVE framework
function love.load()
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")
    -- Create a new instance of the MovingTarget class
    mytarget = Target:new(10, 50, 25)
    mymissile = Missile:new(20, love.graphics.getHeight()-10, 80)
end

-- Update function in the LÖVE framework
local lastTime = 0.0
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)
    mymissile:update(dt, mytarget, "PG") -- PN PG

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
    local speed = 10
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        mytarget.velocity.y = mytarget.velocity.y - speed
    elseif key == "s" then
        mytarget.velocity.y = mytarget.velocity.y + speed
    elseif key == "a" then
        mytarget.velocity.x = mytarget.velocity.x - speed
    elseif key == "d" then
        mytarget.velocity.x = mytarget.velocity.x + speed
    end
end