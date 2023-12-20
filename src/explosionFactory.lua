local ExplosionFactory = {}
local utils = require("src.utils")

function ExplosionFactory:new(config)
    local self = setmetatable({}, ExplosionFactory)
    ExplosionFactory.__index = ExplosionFactory

    self.explosion = {
        position = { x = nil, y = nil },
        animationSpeed = config.animationSpeed,
        currentQuadIdx = 1
    }
    self.explosions = {}

    self.size = config.size
    self.spriteBatch = nil
    self.quads = nil

    return self
end

function ExplosionFactory:load(spriteBatch, quads)
    self.spriteBatch = spriteBatch
    self.quads = quads
end

function ExplosionFactory:startExplosion(position)
    local explosion = utils.copyTable(self.explosion)
    explosion.position.x = position.x
    explosion.position.y = position.y
    table.insert(self.explosions, explosion)
end

function ExplosionFactory:draw()
    local _, _, w, h = self.quads[1]:getViewport()
    self.spriteBatch:clear()

    for _, explosion in ipairs(self.explosions) do
        local x = explosion.position.x
        local y = explosion.position.y
        local quad = self.quads[math.floor(explosion.currentQuadIdx)]

        self.spriteBatch:add(quad, x, y, 0, self.size, self.size, w / 2, h / 2)
    end

    love.graphics.draw(self.spriteBatch)
end

function ExplosionFactory:update(dt)
    local toRemove = {}

    for i, explosion in ipairs(self.explosions) do
        explosion.currentQuadIdx = explosion.currentQuadIdx + dt * explosion.animationSpeed

        if explosion.currentQuadIdx > #self.quads + 1 then
            table.insert(toRemove, i)
        end
    end

    for i = #toRemove, 1, -1 do
        table.remove(self.explosions, toRemove[i])
    end
end

return ExplosionFactory
