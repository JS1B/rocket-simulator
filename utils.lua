-- This module contains utility functions for the rocket simulator.

local Utils = {}

-- Copy a table
function Utils.copyTable(t)
    --[[
    Creates a shallow copy of a table.
    
    Parameters:
        t (table): The table to be copied.
    
    Returns:
        table: The copied table.
    ]]
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

-- Check if two rectangles are colliding
function Utils.checkCollision(a, b)
    --[[
    Checks if two rectangles are colliding.
    
    Parameters:
        a (table): The first rectangle.
        b (table): The second rectangle.
    
    Returns:
        boolean: True if the rectangles are colliding, false otherwise.
    ]]
    return a.position.x - a.size.width / 2 < b.position.x + b.size.width / 2 and
        a.position.x + a.size.width / 2 > b.position.x - b.size.width / 2 and
        a.position.y - a.size.height / 2 < b.position.y + b.size.height / 2 and
        a.position.y + a.size.height / 2 > b.position.y - b.size.height / 2
end

-- Map a value from one range to another
function Utils.map(value, inMin, inMax, outMin, outMax)
    --[[
    Maps a value from one range to another.
    
    Parameters:
        value (number): The value to be mapped.
        inMin (number): The minimum value of the input range.
        inMax (number): The maximum value of the input range.
        outMin (number): The minimum value of the output range.
        outMax (number): The maximum value of the output range.
    
    Returns:
        number: The mapped value.
    ]]
    local t = (value - inMin) / (inMax - inMin)
    return (1 - t) * outMin + t * outMax
end

-- Sum all the values in a table
function Utils.sum(t)
    --[[
    Calculates the sum of all the values in a table.
    
    Parameters:
        t (table): The table containing numeric values.
    
    Returns:
        number: The sum of the values in the table.
    ]]
    local sum = 0
    for _, v in pairs(t) do
        sum = sum + v
    end
    return sum
end

-- Load quads from an image
function Utils.loadQuads(image, width, height, quadTiles)
    --[[
    Loads quads from an image.
    
    Parameters:
        image (Image): The image containing the quads.
        width (number): The width of each quad.
        height (number): The height of each quad.
        quadTiles (table): A table specifying the number of quads in each row.
    
    Returns:
        table: A table containing the loaded quads.
    ]]
    local quads = {}
    for yy = 1, #quadTiles do
        for xx = 1, quadTiles[yy] do
            table.insert(quads,
                love.graphics.newQuad((xx - 1) * width,
                    (yy - 1) * height,
                    width,
                    height,
                    image:getDimensions()))
        end
        if #quads >= Utils.sum(quadTiles) then
            break
        end
    end
    return quads
end

-- Unpack a table
function Utils.unpack(t)
    --[[
    Unpacks a table.
    
    Parameters:
        t (table): The table to be unpacked.
    
    Returns:
        any: The unpacked table.
    ]]
---@diagnostic disable-next-line: deprecated
    local unpack = table.unpack or unpack
    return unpack(t)
end

return Utils
