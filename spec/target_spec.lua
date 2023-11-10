---@diagnostic disable: undefined-field, undefined-global
local Target = require("target")

describe("Target", function()
    local config = {
        x = 0,
        y = 0,
        acceleration = 100,
        speed = 0,
        maxSpeed = 500,
        turnSpeed = math.pi -- 180 degrees per second
    }

    local target

    before_each(function()
        target = Target:new(config)
    end)

    it("should have a valid initial configuration", function()
        assert.is_table(target.position)
        assert.is_number(target.position.x)
        assert.is_number(target.position.y)
        assert.is_number(target.speed)
        assert.is_number(target.maxSpeed)
        assert.is_number(target.turnSpeed)
        assert.is_number(target.acceleration)
    end)

    it("should turn left when direction is negative", function()
        local initialAngle = target.angle
        target:turn(1, -1)
        assert.is_true(target.angle < initialAngle)
    end)

    it("should turn right when direction is positive", function()
        local initialAngle = target.angle
        target:turn(1, 1)
        assert.is_true(target.angle > initialAngle)
    end)

    it("should accelerate when direction is positive", function()
        local initialSpeed = target.speed
        target:accelerate(1, 1)
        assert.is_true(target.speed > initialSpeed)
    end)

    it("should decelerate when direction is negative", function()
        target.speed = 100
        local initialSpeed = target.speed
        target:accelerate(1, -1)
        assert.is_true(target.speed < initialSpeed)
    end)

    it("should not exceed max speed when accelerating", function()
        target.speed = 400
        target:accelerate(1, 1)
        assert.is_true(target.speed == target.maxSpeed)
    end)

    it("should not go below zero speed when decelerating", function()
        target.speed = 100
        target:accelerate(1, -1)
        assert.is_true(target.speed == 0)
    end)

    it("should update position based on velocity", function()
        target.speed = 100
        target.angle = math.pi / 2 -- 90 degrees
        target:update(1)
        assert.is_true(target.position.x < 0.0001 and target.position.x > 0)
        assert.is_true(target.position.y == 100)
    end)
end)