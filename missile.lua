local Missile = {}

-- Constructor for the Missile class
function Missile:new(x, y, speed, direction, maxSpeed)
    -- Define the Missile class
    local self = setmetatable({}, Missile)
    Missile.__index = Missile
    self.x = x
    self.y = y
    self.speed = speed
    self.direction = direction
    self.maxSpeed = maxSpeed
    return self
  end

-- Update method for the Missile class
function Missile:update(dt)
    -- Calculate the velocity components based on direction and speed
    local vx = self.speed * math.cos(self.direction)
    local vy = self.speed * math.sin(self.direction)

    -- Update the Missile's position based on velocity and time elapsed (dt)
    self.x = self.x + vx * dt
    self.y = self.y + vy * dt

    -- Limit the Missile's speed to the maximum speed saturation
    local currentSpeed = math.sqrt(vx ^ 2 + vy ^ 2)
    if currentSpeed > self.maxSpeed then
        local scale = self.maxSpeed / currentSpeed
        self.x = self.x + (vx * scale - vx) * dt
        self.y = self.y + (vy * scale - vy) * dt
    end

    -- Wrap position
    if self.x > love.graphics.getWidth() then
        self.x = 0
    end

    if self.y > love.graphics.getHeight() then
        self.y = 0
    end
end

-- Draw method for the Missile class
function Missile:draw()
    love.graphics.rectangle("fill", self.x, self.y, 14, 6)
end

function Missile:fire()
    ;
end

return Missile