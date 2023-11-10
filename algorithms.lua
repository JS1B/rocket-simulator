--- 
--- 'algorithms.lua' file contains a table of guidance algorithms
---
--- ## Overview
--- This module contains different guidance algorithms for a missile to follow a target.
--- Each algorithm is a function that takes in the missile object, a LOS vector, the target object and the time step (dt).
--- The function updates the missile's velocity based on the chosen guidance algorithm.
--- ## Usage
--- ```lua_createtable
--- local algorithms = require("algorithms")
--- local algorithmFunction = algorithms[algorithmName]
--- algorithmFunction(missile, LOS_vector, target, dt)
--- ```
local algorithms = {
    -- Simple Pursuit Guidance
    PG = function(self, LOS_vector, target, dt)
        local distance = math.sqrt(LOS_vector.x ^ 2 + LOS_vector.y ^ 2)
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
    end,

    -- Proportional Navigation Guidance
    PN = function(self, LOS_vector, target, dt)
        local los_rate = (LOS_vector.x * target._velocity.y - LOS_vector.y * target._velocity.x) /
            (LOS_vector.x ^ 2 + LOS_vector.y ^ 2)
        local acceleration_vector = {
            x = self.acceleration * los_rate * LOS_vector.x,
            y = self.acceleration * los_rate * LOS_vector.y
        }

        self._velocity.x = self._velocity.x + acceleration_vector.x * dt
        self._velocity.y = self._velocity.y + acceleration_vector.y * dt
    end,

    -- Pure Pursuit Guidance
    P = function(self, LOS_vector, target, dt)
        local time_to_intercept = math.sqrt((target.position.x - self.position.x) ^ 2 +
            (target.position.y - self.position.y) ^ 2) / self.maxSpeed
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
    end,

    -- Proportional Pursuit Guidance
    PP = function(self, LOS_vector, target, dt)
        local time_to_intercept = math.sqrt((target.position.x - self.position.x) ^ 2 +
            (target.position.y - self.position.y) ^ 2) / self.maxSpeed
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
    end,

    -- Proportional Plus Navigation Guidance
    PPN = function(self, LOS_vector, target, dt)
        local time_to_intercept = math.sqrt((target.position.x - self.position.x) ^ 2 +
            (target.position.y - self.position.y) ^ 2) / self.maxSpeed
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

        local los_rate = (LOS_vector.x * target._velocity.y - LOS_vector.y * target._velocity.x) /
            (LOS_vector.x ^ 2 + LOS_vector.y ^ 2)
        local acceleration_vector = {
            x = self.acceleration * los_rate * LOS_vector.x,
            y = self.acceleration * los_rate * LOS_vector.y
        }

        self._velocity.x = self._velocity.x + acceleration_vector.x * dt
        self._velocity.y = self._velocity.y + acceleration_vector.y * dt
    end
}

return algorithms
