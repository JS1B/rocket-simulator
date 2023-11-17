local Target = {}

-- Constructor for the Target class
function Target:new(config)
    local self = setmetatable({}, Target)
    Target.__index = Target

    self.position = { x = config.x, y = config.y }
    self.angle = 0 -- radians

    self.speed = config.speed
    self.maxSpeed = config.maxSpeed

    self.turnSpeed = config.turnSpeed

    self.acceleration = config.acceleration

    -- Private variables
    self._velocity = { x = 0, y = 0 }
    return self
end

-- Turn method for the Target class
function Target:turn(dt, direction)
    self.angle = self.angle + direction * self.turnSpeed * dt
end

-- Accelerate method for the Target class
function Target:accelerate(dt, direction)
    self.speed = self.speed + direction * self.acceleration * dt
    if self.speed < 0 then
        self.speed = 0
    elseif self.speed > self.maxSpeed then
        self.speed = self.maxSpeed
    end
end

-- Update method for the Target class
function Target:update(dt)
    -- Calculate the velocity and position components
    self._velocity.x = math.cos(self.angle) * self.speed
    self._velocity.y = math.sin(self.angle) * self.speed
    self.position.x = self.position.x + self._velocity.x * dt
    self.position.y = self.position.y + self._velocity.y * dt
end

-- Draw method for the Target class
function Target:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
end

-- Reset method for the Target class
function Target:reset()
    -- Reset the Target's speed
    if self.speed > self.maxSpeed / 10 then
        self.speed = self.maxSpeed / 10
    end
end

return Target
