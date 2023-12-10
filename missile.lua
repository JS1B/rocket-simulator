local Missile = {}
---@diagnostic disable-next-line: deprecated
local utils = require("utils")

-- Constructor for the Missile class
function Missile:new(config)
    -- Define the Missile class
    local self = setmetatable({}, Missile)
    Missile.__index = Missile

    self.position = { x = config.x, y = config.y }
    self.size = { width = config.width, height = config.height }
    self.spriteImage = nil
    self.spriteBatch = nil
    self.spriteRotation = config.spriteRotation

    self.angle = 0 -- radians

    self.speed = config.speed
    self.maxSpeed = config.maxSpeed

    self.turnSpeed = config.turnSpeed

    self.acceleration = config.acceleration

    self.algorithms = require("algorithms")
    self.algorithm = config.algorithm

    self.trace = {
        enabled = config.trace,
        length = config.traceLength,
        color = { utils.unpack(config.traceColor) }, -- Copy the table
        frequency = config.traceFrequency,
        _lastTime = 0,
        _points = {}
    }

    self.particleSystem = nil
    self.particle = config.particle

    -- Private variables
    self._velocity = { x = 0, y = 0 }

    self:appendPoint()

    return self
end

-- Load assets for the Missile class
function Missile:load(spriteImage, spriteBatch, particleSystem)
    -- Load the Missile's sprite
    self.spriteImage = spriteImage
    self.spriteBatch = spriteBatch
    self.spriteImage:setFilter("nearest", "nearest")

    -- Create a new particle system for the missile
    self.particleSystem = particleSystem
end

-- Update method for the Missile class
function Missile:update(dt, target)
    -- Calculate the Line Of Sight (LOS) vector
    local LOS_vector = { x = target.position.x - self.position.x, y = target.position.y - self.position.y }

    -- Select the algorithm
    local algorithm = self.algorithms[self.algorithm]
    if algorithm then
        algorithm(self, LOS_vector, target, dt)
    else
        self.algorithm = next(self.algorithms)
        print("Wrong algorithm selected: ", self.algorithm)
    end

    -- Cap at max speed
    self.speed = math.sqrt(self._velocity.x ^ 2 + self._velocity.y ^ 2)
    if self.speed > self.maxSpeed then
        self._velocity.x = self._velocity.x * self.maxSpeed / self.speed
        self._velocity.y = self._velocity.y * self.maxSpeed / self.speed
    end
    self.speed = math.sqrt(self._velocity.x ^ 2 + self._velocity.y ^ 2)

    -- Utilize small step integration
    local small_dt = 0.01 -- Use a small time step
    local remaining_dt = dt
    while remaining_dt > 0 do
        local current_dt = math.min(remaining_dt, small_dt)
        self.position.x = self.position.x + self._velocity.x * current_dt
        self.position.y = self.position.y + self._velocity.y * current_dt
        remaining_dt = remaining_dt - current_dt
    end
    self.angle = math.atan2(self._velocity.y, self._velocity.x)

    -- Update the particle system
    self.particleSystem:setPosition(self.position.x, self.position.y)
    self.particleSystem:setDirection(self.angle + math.pi)
    self.particleSystem:setSpeed(self.speed * 0.5, self.speed * 1.5)
    self.particleSystem:setSpread(utils.map(self.speed, 0, self.maxSpeed,
        self.particle.minSpeedSpread, self.particle.maxSpeedSpread))
    self.particleSystem:setEmissionRate(utils.map(self.speed, 0, self.maxSpeed,
        self.particle.minSpeedEmissionRate, self.particle.maxSpeedEmissionRate))
    self.particleSystem:update(dt)
end

-- Draw method for the Missile class
function Missile:draw()
    -- Draw the particle system
    love.graphics.draw(self.particleSystem, 0, 0)

    -- Draw the Missile and its trace
    self:triggerPointsDraw()
    if self.trace.enabled then
        love.graphics.points(self.trace._points)
    end

    local x = self.position.x
    local y = self.position.y
    local scaleX = self.size.width / self.spriteImage:getWidth()
    local scaleY = self.size.height / self.spriteImage:getHeight()

    self.spriteBatch:clear()
    self.spriteBatch:add(x, y, self.angle + self.spriteRotation, scaleX, scaleY, self.spriteImage:getWidth() / 2,
        self.spriteImage:getHeight() * 3 / 4)
    love.graphics.draw(self.spriteBatch)
end

function Missile:triggerPointsDraw()
    if not self.trace.enabled then
        return
    end

    local currentTime = love.timer.getTime()
    if currentTime - self.trace._lastTime <= self.trace.frequency then
        return
    end

    self.trace._lastTime = currentTime
    self:appendPoint()
    if #self.trace._points > self.trace.length then
        table.remove(self.trace._points, 1)
    end
end

function Missile:appendPoint()
    table.insert(self.trace._points, { self.position.x, self.position.y, utils.unpack(self.trace.color) })
end

function Missile:changeAlgorithm()
    -- Roll over the algorithms
    self.algorithm = next(self.algorithms, self.algorithm)
    if not self.algorithm then
        self.algorithm = next(self.algorithms)
    end
end

-- Reset method for the Missile class
function Missile:reset(ScreenWidth, ScreenHeight)
    -- Reset the Missile's velocity and randomize its position
    self.position = {
        x = math.random(0, ScreenWidth),
        y = math.random(0, ScreenHeight)
    }
    self._velocity = { x = 0, y = 0 }
    self.speed = 0
    self.trace._points = {}
    self.trace._lastTime = 0
    -- self.algorithm = next(self.algorithms)
end

return Missile
