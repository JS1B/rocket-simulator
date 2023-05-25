local Missile = {}

-- Constructor for the Missile class
function Missile:new(x, y, maxSpeed)
    -- Define the Missile class
    local self = setmetatable({}, Missile)
    Missile.__index = Missile
    self.position = {x = x, y = y}
    self.velocity = {x = 0, y = 0}
    self.acceleration = 0.2
    self.maxSpeed = maxSpeed
    return self
  end

-- Update method for the Missile class
function Missile:update(dt, target_position)
    local direction = {x = target_position.x - self.position.x, y = target_position.y - self.position.y}
    local magnitude = math.sqrt(direction.x ^ 2 + direction.y ^ 2)

    if magnitude > 0 then
        direction.x = direction.x / magnitude
        direction.y = direction.y / magnitude
    end

    local angle = math.atan2(direction.y, direction.x) - math.atan2(self.velocity.y, self.velocity.x)

    if angle > math.pi then
        angle = angle - 2 * math.pi
    elseif angle then
        angle = angle + 2 * math.pi
    end
    
    self.velocity.x = self.velocity.x + direction.x * self.acceleration
    self.velocity.y = self.velocity.y + direction.y * self.acceleration

    -- Cap at max speed
    local speed = (self.velocity.x ^ 2 + self.velocity.y ^ 2) ^ 0.5
    if speed > self.maxSpeed then
        self.velocity.x = self.velocity.x * self.maxSpeed / speed
        self.velocity.y = self.velocity.y * self.maxSpeed / speed
    end

    -- Update the Missile's position based on velocity and time elapsed (dt)
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

-- Draw method for the Missile class
function Missile:draw()
    love.graphics.rectangle("fill", self.position.x, self.position.y, 14, 6)
end

return Missile