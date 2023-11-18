---@diagnostic disable: undefined-field, undefined-global
local Missile = require("missile")

describe("Missile", function()
    local config = require("default-config")
    local algorithms = require("algorithms")

    local target = {
        position = { x = 1000, y = 1000 },
        _velocity = { x = 0, y = 0 }
    }

    for algorithmName, _ in pairs(algorithms) do
        local missile = Missile:new(config.missile)
        config.missile.algorithm = algorithmName
        missile = Missile:new(config.missile)

        describe("(" .. missile.algorithm .. ")", function()
            before_each(function()
                missile = Missile:new(config.missile)
            end)

            it("has a valid initial configuration", function()
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

            it("updates its position", function()
                local initialX = missile.position.x
                local initialY = missile.position.y
                missile:update(1, target)
                -- print(initialX, missile.position.x)
                -- print(initialY, missile.position.y)
                assert.is_not.equal(initialX, missile.position.x)
                assert.is_not.equal(initialY, missile.position.y)
            end)

            it("changes algorithm", function()
                local initialAlgorithm = missile.algorithm
                missile:changeAlgorithm()
                assert.is_not.equal(initialAlgorithm, missile.algorithm)
            end)

            it("resets itself", function()
                missile:reset(config.window.width, config.window.height)
                assert.is_table(missile.position)
                assert.is_number(missile.position.x)
                assert.is_number(missile.position.y)
                assert.is_number(missile.speed)
                assert.is_number(missile.trace._lastTime)
                assert.is_table(missile.trace._points)
                assert.is_equal(0, #missile.trace._points)
            end)
        end)
    end
end)
