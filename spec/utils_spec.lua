---@diagnostic disable: undefined-field, undefined-global
local utils = require("utils")

describe("Utils", function()
    describe("copyTable", function()
        it("should create a shallow copy of a table", function()
            local original = {a = 1, b = 2, c = 3}
            local copy = utils.copyTable(original)
            assert.are.same(original, copy)
            assert.is_not.equal(original, copy)
        end)
    end)

    describe("checkCollision", function()
        it("should return true if two rectangles are colliding", function()
            local a = {position = {x = 0, y = 0}, size = {width = 10, height = 10}}
            local b = {position = {x = 5, y = 5}, size = {width = 10, height = 10}}
            assert.is_true(utils.checkCollision(a, b))
        end)

        it("should return false if two rectangles are not colliding", function()
            local a = {position = {x = 0, y = 0}, size = {width = 10, height = 10}}
            local b = {position = {x = 20, y = 20}, size = {width = 10, height = 10}}
            assert.is_false(utils.checkCollision(a, b))
        end)
    end)

    describe("map", function()
        it("should map a value from one range to another", function()
            local value = 5
            local inMin = 0
            local inMax = 10
            local outMin = 0
            local outMax = 100
            local mappedValue = utils.map(value, inMin, inMax, outMin, outMax)
            assert.are.equal(50, mappedValue)
        end)
    end)

    describe("sum", function()
        it("should calculate the sum of all values in a table", function()
            local t = {1, 2, 3, 4, 5}
            local sum = utils.sum(t)
            assert.are.equal(15, sum)
        end)
    end)
end)