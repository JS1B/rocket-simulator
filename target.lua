local Target = {}

-- Constructor for the Target class
function Target:new(x, y, speed)
    local self = setmetatable({}, Target)
    Target.__index = Target
    self.position = { x = x, y = y }
    self.velocity = { x = speed, y = 0 }
    return self
end

-- Update method for the Target class
function Target:update(dt)
    -- Calculate the velocity components based on direction and speed

    -- Update the target's position based on velocity and time elapsed (dt)
    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt

    -- Wrap position
    if self.position.x > love.graphics.getWidth() then
        self.position.x = 0
    end

    if self.position.y > love.graphics.getHeight() then
        self.position.y = 0
    end
end

-- Draw method for the Target class
function Target:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
end

return Target
