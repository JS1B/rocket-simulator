local Missile = {}

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

    -- Private variables
    self._velocity = { x = 0, y = 0 }
    self._points = { { self.position.x, self.position.y } }
    self._lastTime = 0.0
    return self
end

-- Update method for the Missile class
function Missile:update(dt, target)
    -- Calculate the Line Of Sight (LOS) vector
    local LOS_vector = { x = target.position.x - self.position.x, y = target.position.y - self.position.y }
    local distance = math.sqrt(LOS_vector.x ^ 2 + LOS_vector.y ^ 2)

    -- Select the algorithm
    local algorithm = self.algorithms[self.algorithm]
    if algorithm then
        algorithm(self, LOS_vector, target, distance, dt)
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

    -- Update the Missile's position
    self.position.x = self.position.x + self._velocity.x * dt
    self.position.y = self.position.y + self._velocity.y * dt

    -- Trigger points/dots draw
    local curTime = love.timer.getTime()
    if self._lastTime + 0.5 < curTime then
        self:appendPoint()
        self._lastTime = curTime
    end
end

-- Draw method for the Missile class
function Missile:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
    love.graphics.points(self._points)
end

function Missile:appendPoint()
    table.insert(self._points, { self.position.x, self.position.y })
end

function Missile:changeAlgorithm()
    -- Roll over the algorithms
    self.algorithm = next(self.algorithms, self.algorithm)
    if not self.algorithm then
        self.algorithm = next(self.algorithms)
    end
end

-- Reset method for the Missile class
function Missile:reset()
    print("TODO: Implement Missile:reset()")
end

return Missile
