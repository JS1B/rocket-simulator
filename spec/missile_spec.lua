---@diagnostic disable: undefined-field, undefined-global
local Missile = require("missile")

describe("Missile", function()
    local config = {
        x = 0,
        y = 0,
        acceleration = 100,
        speed = 100,
        maxSpeed = 200,
        turnSpeed = 5,
        algorithm = "PG",
        trace = true,
        traceLength = 10,
        traceColor = { 1, 0, 0, 1},
        traceFrequency = 0.1
    }

    local target = {
        position = { x = 100, y = 100 },
        _velocity = { x = 0, y = 0 }
    }

    local missile

    before_each(function()
        missile = Missile:new(config)
    end)

    it("should have a valid initial configuration", function()
        assert.is_table(missile.position)
        assert.is_number(missile.position.x)
        assert.is_number(missile.position.y)
        assert.is_number(missile.acceleration)
        assert.is_number(missile.speed)
        assert.is_number(missile.maxSpeed)
        assert.is_number(missile.turnSpeed)
        assert.is_string(missile.algorithm)
        assert.is_boolean(missile.trace.enabled)
        assert.is_number(missile.trace.length)
        assert.is_table(missile.trace.color)
        assert.is_number(missile.trace.frequency)
    end)

    it("should update its position", function()
        local initialX = missile.position.x
        local initialY = missile.position.y
        missile:update(1, target)
        assert.is_not.equal(initialX, missile.position.x)
        assert.is_not.equal(initialY, missile.position.y)
    end)

    -- it("should draw itself", function()
    --     assert.has_no.errors(function() missile:draw() end)
    -- end)

    it("should change its algorithm", function()
        local initialAlgorithm = missile.algorithm
        missile:changeAlgorithm()
        assert.is_not.equal(initialAlgorithm, missile.algorithm)
    end)

    it("should reset itself", function()
        assert.has_no.errors(function() missile:reset() end)
    end)
end)