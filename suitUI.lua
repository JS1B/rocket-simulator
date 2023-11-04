local Suit = require("lib/suit")

SuitUI = {}

function SuitUI:new(config)
    -- Define SuitUI class
    local self = setmetatable({}, SuitUI)
    SuitUI.__index = SuitUI

    self.UI_width = config.width

    self.suit = Suit --.new()
    self.font = love.graphics.newFont(config.font, config.fontSize)
    -- self.suit.theme.font = self.font
    love.graphics.setFont(self.font)
    return self
end

function SuitUI:update(dt, target, missiles)
    self.suit.layout:reset(love.graphics.getWidth() - self.UI_width, 60, 2)
    self:displayTargetInfo(target)
    self:displayMissileInfo(missiles)
    self:displayFPS(dt)
end

function SuitUI:displayTargetInfo(target)
    self.suit.Label("Target Info:", {align = "left"}, self.suit.layout:row(self.UI_width, love.graphics.getFont():getHeight()))
    local buf = ("x: %7.1f\ty: %7.1f"):format(target.position.x, target.position.y)
    self.suit.Label(buf, {align="left"}, self.suit.layout:row())
    buf = ("v.x: %7.1f\tv.y: %7.1f"):format(target._velocity.x, target._velocity.y)
    self.suit.Label(buf, {align="left"}, self.suit.layout:row())
    buf = ("angle: %4.2f\tsp: %4.2f"):format(target.angle, target.speed)
    self.suit.Label(buf, {align="left"}, self.suit.layout:row())
end

function SuitUI:displayMissileInfo(missiles)
    for i, missile in ipairs(missiles) do
        self.suit.Label("Missile " .. i, {align="left"}, self.suit.layout:row())
        buf = ("x: %7.1f\ty: %7.1f"):format(missile.position.x, missile.position.y)
        self.suit.Label(buf, {align="left"}, self.suit.layout:row())
        buf = ("v.x: %7.1f\tv.y: %7.1f"):format(missile._velocity.x, missile._velocity.y)
        self.suit.Label(buf, {align="left"}, self.suit.layout:row())
        self.suit.Label(("speed: %7.1f"):format(missile.speed), {align="left"}, self.suit.layout:row())
    end
end

function SuitUI:displayFPS(dt)
    self.suit.Label("FPS: " .. love.timer.getFPS(), {align="right"}, self.suit.layout:row())
end

function SuitUI:draw()
    self.suit.draw()
end

return SuitUI