local Target = {}

-- Constructor for the Target class
function Target:new(x, y, speed)
    local self = setmetatable({}, Target)
    Target.__index = Target
    self.position = { x = x, y = y }
    self.angle = 0 -- radians
    self.speed = speed
    self._velocity = { x = 0, y = 0 }
    return self
end

-- Update method for the Target class
function Target:update(dt)
    -- Calculate the velocity components based on direction and speed

    -- Update the target's position based on velocity and time elapsed (dt)
    self._velocity.x = math.cos(self.angle) * self.speed
    self._velocity.y = math.sin(self.angle) * self.speed
    self.position.x = self.position.x + self._velocity.x * dt
    self.position.y = self.position.y + self._velocity.y * dt
end

-- Draw method for the Target class
function Target:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
end

return Target
