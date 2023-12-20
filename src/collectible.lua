local Collectible = {}

-- Constructor for the Collectible class
function Collectible:new(config)
    -- Define the Collectible class
    local self = setmetatable({}, Collectible)
    Collectible.__index = Collectible

    self.windowSize = { width = nil, height = nil }
    self.position = { x = 0, y = 0 }
    self.size = { width = nil, height = nil }
    self.animationSpeed = config.animationSpeed

    self.spriteBatch = nil
    self.spriteQuads = nil
    self.currentQuadIdx = 1

    self.particleSystem = nil
    self.particle = config.particle

    return self
end

-- Load assets for the Collectible class
function Collectible:load(spriteBatch, spriteQuads, size)
    -- Load the Collectible's sprite
    self.spriteBatch = spriteBatch
    self.spriteBatch:getTexture():setFilter("nearest", "nearest")

    self.spriteQuads = spriteQuads
    self.size.width = size.width
    self.size.height = size.height
end

-- Draw method for the Collectible class
function Collectible:draw()
    -- Draw the Collectible's sprite
    local x = self.position.x - self.size.width / 2
    local y = self.position.y - self.size.height / 2
    local quad = self.spriteQuads[math.floor(self.currentQuadIdx)]

    self.spriteBatch:clear()
    self.spriteBatch:add(quad, x, y)
    love.graphics.draw(self.spriteBatch)
end

-- Update method for the Collectible class
function Collectible:update(dt)
    self.currentQuadIdx = self.currentQuadIdx + dt * self.animationSpeed
    if self.currentQuadIdx > #self.spriteQuads + 1 then
        self.currentQuadIdx = 1
    end
end

-- Reset method for the Collectible class
function Collectible:reset()
    -- Reset the Collectible's position
    self.position.x = math.random(self.size.width / 2, self.windowSize.width - self.size.width / 2)
    self.position.y = math.random(self.size.height / 2, self.windowSize.height - self.size.height / 2)
end

function Collectible:resize(windowWidth, windowHeight)
    self.windowSize.width = windowWidth
    self.windowSize.height = windowHeight

    if self.position.x + self.size.width > windowWidth then
        self.position.x = windowWidth - self.size.width
    end

    if self.position.y + self.size.height > windowHeight then
        self.position.y = windowHeight - self.size.height
    end
end

return Collectible
