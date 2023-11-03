local Target = require("target")
local Missile = require("missile")
local suit = require("SUIT")

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

    font = love.graphics.newFont("assets/fonts/NotoSans-Regular.ttf", 13)
    love.graphics.setFont(font)
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

    -- Print UI with details
    local buf = ""
    local UI_width = 140
	suit.layout:reset(love.graphics.getWidth() - UI_width, 60, 2)
    suit.Label("Target", {align="left"}, suit.layout:row(UI_width, love.graphics.getFont():getHeight()))
    buf = ("x: %7.1f\ty: %7.1f"):format(mytarget.position.x, mytarget.position.y)
    suit.Label(buf, {align="left"}, suit.layout:row())
    buf = ("v.x: %7.1f\tv.y: %7.1f"):format(mytarget._velocity.x, mytarget._velocity.y)
    suit.Label(buf, {align="left"}, suit.layout:row())
    buf = ("angle: %4.2f\tsp: %4.2f"):format(mytarget.angle, mytarget.speed)
    suit.Label(buf, {align="left"}, suit.layout:row())

    for i, missile in ipairs(missiles) do
        suit.Label("Missile " .. i, {align="left"}, suit.layout:row())
        buf = ("x: %7.1f\ty: %7.1f"):format(missile.position.x, missile.position.y)
        suit.Label(buf, {align="left"}, suit.layout:row())
        buf = ("v.x: %7.1f\tv.y: %7.1f"):format(missile._velocity.x, missile._velocity.y)
        suit.Label(buf, {align="left"}, suit.layout:row())
        suit.Label(("speed: %7.1f"):format(missile.speed), {align="left"}, suit.layout:row())
    end
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
	suit.draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()

    elseif key == "space" then
        table.remove(missiles, 1)
        table.insert(missiles, Missile:new(config.missile))
    end
end
