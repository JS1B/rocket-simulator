local MissileController = {}
local Missile = require("src.missile")
local utils = require("src.utils")

function MissileController:new(config, spriteBatch, particleSystem)
    local self = setmetatable({}, MissileController)
    MissileController.__index = MissileController

    self.config = config

    self.windowSize = { width = nil, height = nil }

    self.spriteBatch = spriteBatch
    self.particleSystem = particleSystem

    self.missiles = {}

    return self
end

function MissileController:update(dt, target)
    for _, missile in pairs(self.missiles) do
        missile:update(dt, target)
    end
end

function MissileController:draw()
    for _, missile in pairs(self.missiles) do
        missile:draw()
    end
end

function MissileController:reset(windowWidth, windowHeight, n)
    if n then
        self.missiles[n]:reset(windowWidth, windowHeight)
        return
    end

    for _, missile in pairs(self.missiles) do
        missile:reset(windowWidth, windowHeight)
    end
end

function MissileController:changeAlgorithm()
    for _, missile in pairs(self.missiles) do
        missile:changeAlgorithm()
    end
end

function MissileController:checkCollision(target)
    local hit = {}
    for _, missile in pairs(self.missiles) do
        if utils.checkCollision(missile, target) then
            table.insert(hit, true)
        else
            table.insert(hit, false)
        end
    end

    return hit
end

function MissileController:spawnMissile(n)
    for _ = 1, n do
        local missile = Missile:new(self.config)
        missile:reset(self.windowSize.width, self.windowSize.height)
        missile:load(self.spriteBatch, self.particleSystem)
        table.insert(self.missiles, missile)
    end
end

function MissileController:resize(width, height)
    self.windowSize.width = width
    self.windowSize.height = height
    -- for _, missile in pairs(self.missiles) do
    --     missile:reset(width, height)
    -- end
end

return MissileController