local Target = require "target"
local Missile = require "missile"

-- Load function in the LÖVE framework
function love.load()
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")
    -- Create a new instance of the MovingTarget class
    mytarget = Target:new(0, 10, 5)
    mymissile = Missile:new(20, love.graphics.getHeight()-10, 50)
end

-- Update function in the LÖVE framework
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)
    mymissile:update(dt, mytarget.position)
end

-- Draw function in the LÖVE framework
function love.draw()
    -- Draw the target
    mytarget:draw()
    mymissile:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit(0)
    end

    
end