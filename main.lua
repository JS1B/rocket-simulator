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

    font = love.graphics.newFont("assets/fonts/NotoSans-Regular.ttf", 13)
    love.graphics.setFont(font)
end

-- Update function in the LÖVE framework
function love.update(dt)
    -- Update the target's position
    mytarget:update(dt)

    -- Update every missile position
    for _, missile in pairs(missiles) do
        missile:update(dt, mytarget, "PN") -- PN PG
    end

    -- Print UI with details
    local buf = ""
    local UI_width = 140
	suit.layout:reset(love.graphics.getWidth() - UI_width, 60, 2)
    suit.Label("Target", {align="left"}, suit.layout:row(UI_width, love.graphics.getFont():getHeight()))
    buf = ("x: %7.1f\ty: %7.1f"):format(mytarget.position.x, mytarget.position.y)
    suit.Label(buf, {align="left"}, suit.layout:row())
    buf = ("v.x: %7.1f\tv.y: %7.1f"):format(mytarget.velocity.x, mytarget.velocity.y)
    suit.Label(buf, {align="left"}, suit.layout:row())

    for i, missile in ipairs(missiles) do
        suit.Label("Missile " .. i, {align="left"}, suit.layout:row())
        buf = ("x: %7.1f\ty: %7.1f"):format(missile.position.x, missile.position.y)
        suit.Label(buf, {align="left"}, suit.layout:row())
        buf = ("v.x: %7.1f\tv.y: %7.1f"):format(missile.velocity.x, missile.velocity.y)
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
    suit.keypressed(key)
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
