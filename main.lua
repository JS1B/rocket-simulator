local Target
local MissileController
local Collectible
local ExplosionFactory
local UI
local config
local backgroundImages = {}
local utils = require("utils")
local gameParams

-- Load function in the LÖVE framework
function love.load()
    Target = require("target")
    MissileController = require("missileController")
    Collectible = require("collectible")
    ExplosionFactory = require("explosionFactory")
    UI = require("suitUI")
    config = require("default-config")
    gameParams = {
        gameOver = false,
        difficulty = 1,
        score = 0,
        lives = config.game.lives
    }

    -- Set the window properties
    love.graphics.setBackgroundColor(20 / 255, 20 / 255, 20 / 255, 0)
    love.window.setTitle(config.window.title)
    love.window.setMode(config.window.width, config.window.height, { resizable = config.window.resizable })
    love.window.setFullscreen(config.window.fullscreen)
    love.window.setVSync(config.window.vsync)
    love.mouse.setVisible(config.window.mouseVisible)
    math.randomseed(os.time())
    love.math.setRandomSeed(os.time())

    ---- Load assets ----
    -- Load window icon
    love.window.setIcon(love.image.newImageData(config.window.icon))

    -- Load background images
    for _, bgImageData in ipairs(config.window.backgroundImages) do
        local bgImage = love.graphics.newImage(bgImageData.image)
        bgImage:setFilter("linear", "linear")
        table.insert(backgroundImages, { image = bgImage, x = 0, depth = bgImageData.depth, scaleX = nil, scaleY = nil }) -- Add background image to the list
    end

    -- Load sprites and particle systems
    local missileImage = love.graphics.newImage(config.missile.sprite)
    local missileSpriteBatch = love.graphics.newSpriteBatch(missileImage)
    local missileParticleImage = love.graphics.newImage(config.missile.particle.image)
    local missileParticleSystem = love.graphics.newParticleSystem(missileParticleImage, config.missile.particle.count)
    missileParticleSystem:setParticleLifetime(config.missile.particle.avgLifetime)
    missileParticleSystem:setSizes(config.missile.particle.size, 0)

    -- Load explosion sprites
    local explosionImage = love.graphics.newImage(config.explosion.image)
    local explosionBatch = love.graphics.newSpriteBatch(explosionImage)
    local explosionQuadWidth = explosionImage:getWidth() / config.explosion.quadsTiles[1]
    local explosionQuadHeight = explosionImage:getHeight() / #config.explosion.quadsTiles
    local explosionQuads = utils.loadQuads(explosionImage, explosionQuadWidth, explosionQuadHeight,
        config.explosion.quadsTiles)

    -- Load target sprites and particle system
    local targetParticleImage = love.graphics.newImage(config.target.particle.image)
    local targetParticleQuadWidth = targetParticleImage:getWidth() / config.target.particle.quadsTiles[1]
    local targetParticleQuadHeight = targetParticleImage:getHeight() / #config.target.particle.quadsTiles
    local targetParticleImages = utils.loadQuads(targetParticleImage, targetParticleQuadWidth,
        targetParticleQuadHeight, config.target.particle.quadsTiles)

    local targetImage = love.graphics.newImage(config.target.sprite)
    local tagetSpriteBatch = love.graphics.newSpriteBatch(targetImage)
    local targetParticleSystem = love.graphics.newParticleSystem(targetParticleImage, config.target.particle.count)
    targetParticleSystem:setParticleLifetime(config.target.particle.lifetime)
    targetParticleSystem:setSizes(config.target.particle.size)
    targetParticleSystem:setLinearDamping(config.target.particle.damping)
    targetParticleSystem:setEmissionRate(config.target.particle.emissionRate)
    targetParticleSystem:setQuads(targetParticleImages)

    -- Load collectible sprites
    local collectibleImage = love.graphics.newImage(config.collectible.sprite)
    local collectibleSpriteBatch = love.graphics.newSpriteBatch(collectibleImage)
    local collectibleQuadWidth = collectibleImage:getWidth() / config.collectible.quadsTiles[1]
    local collectibleQuadHeight = collectibleImage:getHeight() / #config.collectible.quadsTiles
    local collectibleQuads = utils.loadQuads(collectibleImage, collectibleQuadWidth, collectibleQuadHeight,
        config.collectible.quadsTiles)

    -- Create new instances
    target = Target:new(config.target)
    target:load(targetImage, tagetSpriteBatch, targetParticleSystem)
    missileController = MissileController:new(config.missile, missileSpriteBatch, missileParticleSystem)
    explosionFactory = ExplosionFactory:new(config.explosion)
    explosionFactory:load(explosionBatch, explosionQuads)
    collectible = Collectible:new(config.collectible)
    collectible:load(collectibleSpriteBatch, collectibleQuads, { width = collectibleQuadWidth, height = collectibleQuadHeight })
    ui = UI:new(config.ui)
    ui:setDebug(config.debug)

    -- Resize elements
    love.resize(love.graphics.getDimensions())
    missileController:spawnMissile(1)

    collectible:reset()

    -- Request attention once loaded
    love.window.requestAttention(false)
end

-- Update function in the LÖVE framework
function love.update(dt)
    if gameParams.gameOver then
        return
    end

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
    explosionFactory:update(dt)

    missileController:update(dt, target)

    local w, h = love.graphics.getDimensions()
    local hits = missileController:checkCollision(target)
    for i, hit in ipairs(hits) do
        if hit then
            explosionFactory:startExplosion(target.position)
            missileController:reset(w, h, i)
            gameParams.lives = gameParams.lives - 1
            target:reset(love.graphics.getDimensions())
            if gameParams.lives <= 0 then
                gameParams.gameOver = true
                return
            end
        end
    end

    if utils.checkCollision(target, collectible) then
        collectible:reset()
        gameParams.score = gameParams.score + 1
        if gameParams.score % 3 == 0 then
            gameParams.difficulty = gameParams.difficulty + 1
            missileController:spawnMissile(2^gameParams.difficulty)
        end
    end

    collectible:update(dt)
    ui:update(dt, target, missileController.missiles, collectible, gameParams)

    -- Update background images
    for _, bgImage in ipairs(backgroundImages) do
        bgImage.x = -target.position.x / bgImage.depth
    end
end

-- Draw function in the LÖVE frameworks
function love.draw()
    -- Draw background images, the depth is used to determine the speed of the background
    for _, bgImage in ipairs(backgroundImages) do
        love.graphics.draw(bgImage.image, bgImage.x, 0, 0, bgImage.scaleX, bgImage.scaleY)
    end

    if gameParams.gameOver then
        ui:drawGameOver()
        ui:draw()
        return
    end

    collectible:draw()

    -- Draw target and missiles
    target:draw()
    missileController:draw()
    explosionFactory:draw()

    ui:draw()
end

function love.keypressed(key)
    if key == config.controls.exit then
        love.event.quit()
        return
    end
    if key == config.controls.reset then
        local windowWidth, windowHeight = love.graphics.getDimensions()
        collectible:reset()
        target:reset(windowWidth, windowHeight)
        missileController:reset(windowWidth, windowHeight)
    end
    if key == config.controls.changeAlgorithm then
        missileController:changeAlgorithm()
    end
end

function love.resize(width, height)
    -- Resize background images
    for _, bgImageData in ipairs(backgroundImages) do
        bgImageData.scaleX = love.graphics.getWidth() * (1 + (config.window.scaleX - 1) / bgImageData.depth) /
            bgImageData.image:getWidth()
        bgImageData.scaleY = love.graphics.getHeight() / bgImageData.image:getHeight()
    end

    missileController:resize(width, height)
    collectible:resize(width, height)
    ui:resize(width, height)
end
