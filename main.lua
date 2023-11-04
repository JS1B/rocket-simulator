local Target = require("target")
local Missile = require("missile")
local UI = require("suitUI")

-- Attempt to load the local configuration
local success, config = pcall(require, "config")

-- If the local configuration failed to load, use the default configuration
if not success then
    config = require("default-config")
end

-- Load function in the LÖVE framework
function love.load()
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")

    -- Create new instances
    mytarget = Target:new(config.target)
    missiles = { Missile:new(config.missile) }
    ui = UI:new(config.ui)
end

-- Update function in the LÖVE framework
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)

    -- Update every missile position
    for _, missile in pairs(missiles) do
        missile:update(dt, mytarget)
    end

    local accDirection = 0 -- No acceleration
    if love.keyboard.isDown("w") then
        accDirection = -1 -- Slow down
    elseif love.keyboard.isDown("s") then
        accDirection = 1 -- Accelerate
    end
    mytarget:accelerate(dt, accDirection)

    local turnDirection = 0 -- No turn
    if love.keyboard.isDown("a") then
        turnDirection = -1 -- Left
    elseif love.keyboard.isDown("d") then
        turnDirection = 1 -- Right
    end
    mytarget:turn(dt, turnDirection)

    ui:update(dt, mytarget, missiles)
end

-- Draw function in the LÖVE frameworks
function love.draw()
    -- Draw the target
    mytarget:draw()

    -- Draw all the missiles
    for _, missile in pairs(missiles) do
        missile:draw()
    end

    -- draw the gui
	ui:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()

    elseif key == "space" then
        table.remove(missiles, 1)
        table.insert(missiles, Missile:new(config.missile))
    end
end
