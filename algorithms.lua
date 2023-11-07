local algorithms = {
    PG = function(self, LOS_vector, target, distance, dt)
        -- Simple Pursuit Guidance
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

    PN = function(self, LOS_vector, target, dt)
        -- Proportional Navigation Guidance
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
