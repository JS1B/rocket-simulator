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
        print("Warning: Failed to load window icon: " .. imageData) -- imageData contains the error message
    end

    -- Create new instances
    local targetImage = love.graphics.newImage(config.target.sprite)
    local tagetSpriteBatch = love.graphics.newSpriteBatch(targetImage)
    local missileImage = love.graphics.newImage(config.missile.sprite)
    local missileSpriteBatch = love.graphics.newSpriteBatch(missileImage)

    local missileParticleImage = love.graphics.newImage(config.missile.particle.image)
    local missileParticleSystem = love.graphics.newParticleSystem(missileParticleImage, config.missile.particle.count)
    missileParticleSystem:setParticleLifetime(config.missile.particle.avgLifetime / 2,
        config.missile.particle.avgLifetime * 3 / 2)
    missileParticleSystem:setSizes(config.missile.particle.size, 0)
    missileParticleSystem:setEmissionRate(config.missile.particle.emissionRate)

    -- local targetSmokeFrames = {}
    -- for i = 1, 7 do
    --     targetSmokeFrames[i] = "assets/images/smoke" .. i .. ".png"
    -- end
    -- local targetParticleImage = love.graphics.newArrayImage(targetSmokeFrames)
    local targetParticleImage = love.graphics.newImage(config.target.particle.image)
    local targetParticleSystem = love.graphics.newParticleSystem(targetParticleImage, config.target.particle.count)
    targetParticleSystem:setParticleLifetime(config.target.particle.avgLifetime / 2,
        config.target.particle.avgLifetime * 3 / 2)
    targetParticleSystem:setSizes(config.target.particle.size, 0)
    targetParticleSystem:setLinearDamping(config.target.particle.damping, 1)
    targetParticleSystem:setEmissionRate(config.target.particle.emissionRate)

    target = Target:new(config.target)
    target:load(targetImage, tagetSpriteBatch, targetParticleSystem)
    missiles = { Missile:new(config.missile) }
    missiles[1]:load(missileImage, missileSpriteBatch, missileParticleSystem)
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
        local windowWidth, windowHeight = love.graphics.getDimensions()
        target:reset(windowWidth, windowHeight)
        for _, missile in pairs(missiles) do
            missile:reset(windowWidth, windowHeight)
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
