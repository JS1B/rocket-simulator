---@diagnostic disable: undefined-field, undefined-global
-- Import the module to test
local config = require("default-config")

-- Start a suite of tests
describe("Default Config", function()

    -- Test the missile configuration
    it("should have a valid missile configuration", function()
        assert.is_table(config.missile)
        assert.is_number(config.missile.x)
        assert.is_number(config.missile.y)
        -- Add more assertions for each property of config.missile
    end)

    -- Test the target configuration
    it("should have a valid target configuration", function()
        assert.is_table(config.target)
        assert.is_number(config.target.x)
        assert.is_number(config.target.y)
        -- Add more assertions for each property of config.target
    end)

    -- Add more tests as needed
end)