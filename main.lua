local Target
local Missile
local UI
local config
local backgroundImages = {}

-- Load function in the LÖVE framework
function love.load()
    Target = require("target")
    Missile = require("missile")
    UI = require("suitUI")
    config = require("default-config")

    -- Set the window properties
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle(config.window.title)
    love.window.setMode(config.window.width, config.window.height, { resizable = config.window.resizable })
    love.window.setFullscreen(config.window.fullscreen)
    love.window.setVSync(config.window.vsync)
    love.mouse.setVisible(config.window.mouseVisible)

    ---- Load assets ----
    -- Load window icon
    love.window.setIcon(love.image.newImageData(config.window.icon))

    -- Load background images
    for _, bgImage in ipairs(config.window.backgroundImages) do
        table.insert(backgroundImages, { image = love.graphics.newImage(bgImage.image), x = 0, depth = bgImage.depth })
    end

    local targetImage = love.graphics.newImage(config.target.sprite)
    local tagetSpriteBatch = love.graphics.newSpriteBatch(targetImage)
    local missileImage = love.graphics.newImage(config.missile.sprite)
    local missileSpriteBatch = love.graphics.newSpriteBatch(missileImage)

    local missileParticleImage = love.graphics.newImage(config.missile.particle.image)
    local missileParticleSystem = love.graphics.newParticleSystem(missileParticleImage, config.missile.particle.count)
    missileParticleSystem:setParticleLifetime(config.missile.particle.avgLifetime)
    missileParticleSystem:setSizes(config.missile.particle.size, 0)

    local targetParticleImage = love.graphics.newImage(config.target.particle.image)
    local targetParticleImages = {}
    for yy = 0, 2 do
        for xx = 0, 2 do
            table.insert(targetParticleImages,
                love.graphics.newQuad(xx * config.target.particle.textureWidth + 1,
                    yy * config.target.particle.textureHeight + 1,
                    config.target.particle.textureWidth,
                    config.target.particle.textureHeight,
                    targetParticleImage:getDimensions()))
        end
        if #targetParticleImages >= config.target.particle.textureCount then
            break
        end
    end

    local targetParticleSystem = love.graphics.newParticleSystem(targetParticleImage, config.target.particle.count)
    targetParticleSystem:setParticleLifetime(config.target.particle.lifetime)
    targetParticleSystem:setSizes(config.target.particle.size)
    targetParticleSystem:setLinearDamping(config.target.particle.damping)
    targetParticleSystem:setEmissionRate(config.target.particle.emissionRate)
    targetParticleSystem:setQuads(targetParticleImages)

    -- Create new instances
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

    -- Update background images
    for _, bgImage in ipairs(backgroundImages) do
        bgImage.x = -target.position.x / bgImage.depth
    end
end

-- Draw function in the LÖVE frameworks
function love.draw()
    -- Draw background images, the depth is used to determine the speed of the background
    for _, bgImage in ipairs(backgroundImages) do
        love.graphics.draw(bgImage.image,
            bgImage.x,
            0, 0,
            love.graphics.getWidth() * (1 + (config.window.scaleX - 1) / bgImage.depth) / bgImage.image:getWidth(),
            love.graphics.getHeight() / bgImage.image:getHeight())
    end

    -- Draw target and missiles
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

function love.resize(width, height)
    ui:resize(width, height)
end
