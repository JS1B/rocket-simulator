SuitUI = {}

function SuitUI:new(config)
    -- Define SuitUI class
    local self = setmetatable({}, SuitUI)
    SuitUI.__index = SuitUI

    self.UI_width = config.width
    self.windowSize = { width = nil, height = nil }

    self.suit = require("lib/suit")
    self.font = love.graphics.newFont(config.font, config.fontSize)
    love.graphics.setFont(self.font)
    return self
end

function SuitUI:update(dt, target, missiles, collectible)
    self.suit.layout:reset(self.windowSize.width - self.UI_width, 60)
    self:displayTargetInfo(target)
    self:displayMissileInfo(missiles)
    self:displayCollectibleInfo(collectible)

    self:displayFPS()
end

function SuitUI:displayTargetInfo(target)
    self.suit.Label("Target Info:", { align = "left" },
        self.suit.layout:row(self.UI_width, love.graphics.getFont():getHeight()))
    local buf = ("x: %7.1f\ty: %7.1f"):format(target.position.x, target.position.y)
    self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
    buf = ("v.x: %7.1f\tv.y: %7.1f"):format(target._velocity.x, target._velocity.y)
    self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
    buf = ("angle: %4.2f\tsp: %4.2f"):format(target.angle, target.speed)
    self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
    self.suit.Label(("lives: %d"):format(target.lives), { align = "left" }, self.suit.layout:row())
end

function SuitUI:displayMissileInfo(missiles)
    for i, missile in ipairs(missiles) do
        self.suit.Label(("Missile %d - %s"):format(i, missile.algorithm), { align = "left" }, self.suit.layout:row())
        local buf = ("x: %7.1f\ty: %7.1f"):format(missile.position.x, missile.position.y)
        self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
        buf = ("v.x: %7.1f\tv.y: %7.1f"):format(missile._velocity.x, missile._velocity.y)
        self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
        self.suit.Label(("speed: %7.1f"):format(missile.speed), { align = "left" }, self.suit.layout:row())
    end
end

function SuitUI:displayCollectibleInfo(collectible)
    self.suit.Label("Collectible Info:", { align = "left" },
        self.suit.layout:row(self.UI_width, love.graphics.getFont():getHeight()))
    local buf = ("x: %7.1f\ty: %7.1f"):format(collectible.position.x, collectible.position.y)
    self.suit.Label(buf, { align = "left" }, self.suit.layout:row())
    self.suit.Label(("score: %d"):format(collectible.score), { align = "left" }, self.suit.layout:row())
end

function SuitUI:displayFPS()
    self.suit.Label("FPS: " .. love.timer.getFPS(), { align = "right" }, self.suit.layout:row())
end

function SuitUI:drawGameOver()
    self.suit.layout:reset(self.windowSize.width / 2 - 50, self.windowSize.height / 2 - 50)
    self.suit.Label("Game Over", { align = "center" }, self.suit.layout:row(100, 100))
end

function SuitUI:draw()
    self.suit.draw()
end

function SuitUI:resize(width, height)
    self.windowSize.width = width
    self.windowSize.height = height
    self.suit.layout:reset(width - self.UI_width, 60)
end

return SuitUI
