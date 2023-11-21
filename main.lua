local Target
local Missile
local UI
local config

-- Load function in the LÖVE framework
function love.load()
    Target = require("target")
    Missile = require("missile")
    UI = require("suitUI")
    config = require("default-config")

    -- Set the window properties
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle("Rocket simulator")
    love.window.setMode(config.window.width, config.window.height, { resizable = config.window.resizable })
    love.window.setVSync(config.window.vsync)
    love.mouse.setVisible(config.window.mouseVisible)

    local success, imageData = pcall(love.image.newImageData, config.window.icon)
    if success then
        love.window.setIcon(imageData)
    else
        print("Warning: Failed to load window icon: " .. imageData)  -- imageData contains the error message
    end

    -- Create new instances
    local targetImage = love.graphics.newImage(config.target.sprite)
    local tagetSpriteBatch = love.graphics.newSpriteBatch(targetImage)
    local missileImage = love.graphics.newImage(config.missile.sprite)
    local missileSpriteBatch = love.graphics.newSpriteBatch(missileImage)

    target = Target:new(config.target)
    target:load(targetImage, tagetSpriteBatch)
    missiles = { Missile:new(config.missile) }
    missiles[1]:load(missileImage, missileSpriteBatch)
    ui = UI:new(config.ui)
end

-- Update function in the LÖVE framework
function love.update(dt)
    local accDirection = 0 -- No acceleration
    if love.keyboard.isDown(config.controls.decelerate) then
        accDirection = -1  -- Slow down
    elseif love.keyboard.isDown(config.controls.accelerate) then
        accDirection = 1   -- Accelerate
    end
    target:accelerate(dt, accDirection)

    local turnDirection = 0 -- No turn
    if love.keyboard.isDown(config.controls.left) then
        turnDirection = -1  -- Left
    elseif love.keyboard.isDown(config.controls.right) then
        turnDirection = 1   -- Right
    end
    target:turn(dt, turnDirection)

    target:update(dt)
    for _, missile in pairs(missiles) do
        missile:update(dt, target)
    end
    ui:update(dt, target, missiles)
end

-- Draw function in the LÖVE frameworks
function love.draw()
    target:draw()
    for _, missile in pairs(missiles) do
        missile:draw()
    end
    ui:draw()
end

function love.keypressed(key)
    if key == config.controls.exit then
        love.event.quit()
        return
    end
    if key == config.controls.reset then
        target:reset()
        for _, missile in pairs(missiles) do
            missile:reset(love.graphics.getWidth(), love.graphics.getHeight())
        end
    end
    if key == config.controls.changeAlgorithm then
        for _, missile in pairs(missiles) do
            missile:changeAlgorithm()
        end
    end
    -- if key == "space" then
    --     table.remove(missiles, 1) -- Comment this line to allow multiple missiles
    --     table.insert(missiles, Missile:new(config.missile))
    -- end
end
