local Target = {}

-- Constructor for the Target class
function Target:new(x, y, speed)
    local self = setmetatable({}, Target)
    Target.__index = Target
    self.x = x
    self.y = y
    self.speed = speed
    return self
  end

-- Update method for the Target class
function Target:update(dt)
    -- Calculate the velocity components based on direction and speed

    -- Update the target's position based on velocity and time elapsed (dt)
    self.x = self.x + self.speed * dt

    -- Wrap position
    if self.x > love.graphics.getWidth() then
        self.x = 0
    end

    if self.y > love.graphics.getHeight() then
        self.y = 0
    end
end

-- Draw method for the Target class
function Target:draw()
    love.graphics.rectangle("fill", self.x, self.y, 14, 6)
end

return Target