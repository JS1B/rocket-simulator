local Missile = {}
---@diagnostic disable-next-line: deprecated
local unpack = table.unpack or unpack

-- Constructor for the Missile class
function Missile:new(config)
    -- Define the Missile class
    local self = setmetatable({}, Missile)
    Missile.__index = Missile

    self.position = { x = config.x, y = config.y }

    self.speed = config.speed
    self.maxSpeed = config.maxSpeed

    self.turnSpeed = config.turnSpeed

    self.acceleration = config.acceleration

    self.algorithms = require("algorithms")
    self.algorithm = config.algorithm

    self.trace = {
        enabled = config.trace,
        length = config.traceLength,
        color = { unpack(config.traceColor) }, -- Copy the table
        frequency = config.traceFrequency,
        _lastTime = 0,
        _points = {}
    }

    -- Private variables
    self._velocity = { x = 0, y = 0 }

    self:appendPoint()

    return self
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
end

-- Draw method for the Missile class
function Missile:draw()
    -- Draw the Missile and its trace

    self:triggerPointsDraw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
    if self.trace.enabled then
        love.graphics.points(self.trace._points)
    end
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
    table.insert(self.trace._points, { self.position.x, self.position.y, unpack(self.trace.color) })
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
