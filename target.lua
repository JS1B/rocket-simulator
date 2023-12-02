local Target = {}

-- Constructor for the Target class
function Target:new(config)
    local self = setmetatable({}, Target)
    Target.__index = Target

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

    self.particleSystem = nil
    self.particle = config.particle

    -- Private variables
    self._velocity = { x = 0, y = 0 }
    return self
end

-- Load assets for the Target class
function Target:load(spriteImage, spriteBatch, particleSystem)
    -- Load the Missile's sprite
    self.spriteImage = spriteImage
    self.spriteBatch = spriteBatch
    self.spriteImage:setFilter("nearest", "nearest")

    -- Create a new particle system for the missile
    self.particleSystem = particleSystem
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

    -- Utilize small step integration
    local small_dt = 0.01
    local remaining_dt = dt
    while remaining_dt > 0 do
        local current_dt = math.min(small_dt, remaining_dt)
        self.position.x = self.position.x + self._velocity.x * current_dt
        self.position.y = self.position.y + self._velocity.y * current_dt
        remaining_dt = remaining_dt - current_dt
    end

    -- Update the particle system
    self.particleSystem:setPosition(self.position.x, self.position.y)
    self.particleSystem:setDirection(self.angle + math.pi)
    self.particleSystem:setSpeed(self.speed * 0.2, self.speed * 0.5)
    self.particleSystem:setSpread(self.particle.spread)
    self.particleSystem:update(dt)
end

-- Draw method for the Target class
function Target:draw()
    -- Draw the particle system
    love.graphics.draw(self.particleSystem, 0, 0)

    local x = self.position.x
    local y = self.position.y
    local scaleX = self.size.width / self.spriteImage:getWidth()
    local scaleY = self.size.height / self.spriteImage:getHeight()

    self.spriteBatch:clear()
    self.spriteBatch:add(x, y, self.angle + self.spriteRotation, scaleX, scaleY, self.spriteImage:getWidth() / 2,
        self.spriteImage:getHeight() * 5 / 8)
    love.graphics.draw(self.spriteBatch)
end

-- Reset method for the Target class
function Target:reset(ScreenWidth, ScreenHeight)
    -- Reset the Target's speed
    self.position = {
        x = math.random(0, ScreenWidth),
        y = math.random(0, ScreenHeight)
    }
    if self.speed > self.maxSpeed / 10 then
        self.speed = self.maxSpeed / 10
    end
end

return Target
