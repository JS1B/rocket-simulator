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

    self.algorithm = config.algorithm

    -- private variables
    self._velocity = { x = 0, y = 0 }
    self._points = { { self.position.x, self.position.y } }
    self._lastTime = 0.0
    return self
end

-- Update method for the Missile class
function Missile:update(dt, target)
    local LOS_vector = { x = target.position.x - self.position.x, y = target.position.y - self.position.y }
    local distance = math.sqrt(LOS_vector.x ^ 2 + LOS_vector.y ^ 2)

    -- Simple Pursuit Guidance
    if self.algorithm == "PG" then
        local time_to_intercept = distance / self.maxSpeed
        local predicted_target_position = {
            x = target.position.x + target._velocity.x * time_to_intercept,
            y = target.position.y + target._velocity.y * time_to_intercept
        }

        LOS_vector.x = predicted_target_position.x - self.position.x
        LOS_vector.y = predicted_target_position.y - self.position.y

        local magnitude = math.sqrt(LOS_vector.x ^ 2 + LOS_vector.y ^ 2)
        if magnitude > 0 then
            LOS_vector.x = LOS_vector.x / magnitude
            LOS_vector.y = LOS_vector.y / magnitude
        end

        -- Update Missile's velocity
        self._velocity.x = self._velocity.x + LOS_vector.x * self.acceleration * dt
        self._velocity.y = self._velocity.y + LOS_vector.y * self.acceleration * dt

        -- local angle = math.atan2(LOS_vector.y, LOS_vector.x) - math.atan2(self._velocity.y, self._velocity.x)
        -- if angle > math.pi then
        --     angle = angle - 2 * math.pi
        -- elseif angle then
        --     angle = angle + 2 * math.pi
        -- end

        -- Proportional Navigation Guidance
    elseif self.algorithm == "PN" then
        local los_rate = (LOS_vector.x * target._velocity.y -
                LOS_vector.y * target._velocity.x) /
            (LOS_vector.x ^ 2 + LOS_vector.y ^ 2)
        local acceleration_vector = {
            x = self.acceleration * los_rate * LOS_vector.x,
            y = self.acceleration * los_rate * LOS_vector.y
        }

        self._velocity.x = self._velocity.x + acceleration_vector.x * dt
        self._velocity.y = self._velocity.y + acceleration_vector.y * dt
    else
        print("Wrong algorithm selected: ", self.algorithm)
    end

    -- Cap at max speed
    self.speed = math.sqrt(self._velocity.x ^ 2 + self._velocity.y ^ 2)
    if self.speed > self.maxSpeed then
        self._velocity.x = self._velocity.x * self.maxSpeed / self.speed
        self._velocity.y = self._velocity.y * self.maxSpeed / self.speed
    end
    self.speed = math.sqrt(self._velocity.x ^ 2 + self._velocity.y ^ 2)

    -- Update the Missile's position based on velocity and time elapsed (dt)
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

return Missile
