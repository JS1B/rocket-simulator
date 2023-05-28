local Target = require "target"
local Missile = require "missile"
local suit = require "SUIT"

-- Load function in the LÖVE framework
function love.load()
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")

    -- Create new instances
    mytarget = Target:new(10, 50, 25)
    missiles = { Missile:new(20, love.graphics.getHeight() - 10, 80) }
end

-- Update function in the LÖVE framework
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)
    for _, missile in pairs(missiles) do
        missile:update(dt, mytarget, "PN") -- PN PG
    end
end

-- Draw function in the LÖVE frameworks
function love.draw()
    -- Draw the target
    mytarget:draw()
    for _, missile in pairs(missiles) do
        missile:draw()
    end
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
    elseif key == "space" then
        table.remove(missiles, 1)
        table.insert(missiles, Missile:new(20, love.graphics.getHeight() - 10, 80))
    end
end
