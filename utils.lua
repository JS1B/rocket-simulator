local utils = {}

function utils.copyTable(t)
    -- Copy a table
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end

function utils.checkCollision(a, b)
    -- Check if two rectangles are colliding
    return a.position.x - a.size.width / 2 < b.position.x + b.size.width / 2 and
        a.position.x + a.size.width / 2 > b.position.x - b.size.width / 2 and
        a.position.y - a.size.height / 2 < b.position.y + b.size.height / 2 and
        a.position.y + a.size.height / 2 > b.position.y - b.size.height / 2
end

function utils.map(value, inMin, inMax, outMin, outMax)
    -- Map a value from one range to another
    local t = (value - inMin) / (inMax - inMin)
    return (1 - t) * outMin + t * outMax
end

function utils.sum(t)
    -- Sum all the values in a table
    local sum = 0
    for _, v in pairs(t) do
        sum = sum + v
    end
    return sum
end

function utils.loadQuads(image, width, height, quadTiles)
    -- Load quads from an image
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
        if #quads >= utils.sum(quadTiles) then
            break
        end
    end
    return quads
end

return utils
