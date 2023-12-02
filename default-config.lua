-- Define the movement configuration for both rocket and target
local cfg = {
    missile = {
        x = 10,                              -- The initial x position of the rocket
        y = 300,                             -- The initial y position of the rocket

        sprite = "assets/images/rocket.png", -- The sprite of the rocket
        spriteRotation = math.rad(90),       -- The rotation of the sprite of the rocket (in radians)
        width = 25,                          -- The width of the rocket
        height = 25,                         -- The height of the rocket

        acceleration = 1,                    -- The acceleration of the rocket

        speed = 0,                           -- The initial speed of the rocket
        maxSpeed = 80,                       -- The maximum speed of the rocket

        turnSpeed = 5,                       -- The turning speed of the rocket

        algorithm = "PG",                    -- The algorithm that the rocket will use

        trace = false,                       -- Whether the rocket will leave a trace or not
        traceLength = 100,                   -- The length of the trace
        traceColor = { 1, 1, 1, 0.5 },       -- The color of the trace
        traceFrequency = 0.5,                -- The frequency of the trace in seconds

        particle = {
            image = "assets/images/fire.png", -- The image of the particle
            size = 0.1,                       -- The size of the particle
            spread = math.rad(360),           -- The spread of the particle (in radians)
            avgLifetime = 1,                  -- The lifetime of the particle
            count = 400,                      -- The number of particles to emit
            emissionRate = 50                 -- The emission rate of the particle system
        }
    },
    target = {
        x = 10,                             -- The initial x position of the target
        y = 20,                             -- The initial y position of the target

        sprite = "assets/images/plane.png", -- The sprite of the target
        spriteRotation = math.rad(-90),     -- The rotation of the sprite of the target (in radians)
        width = 40,                         -- The width of the target
        height = 40,                        -- The height of the target

        acceleration = 5,                   -- The acceleration of the target

        speed = 5,                          -- The initial speed of the target
        maxSpeed = 80,                      -- The maximum speed of the target

        turnSpeed = 0.6,                    -- The turning speed of the target

        particle = {
            image = "assets/images/smoke4.png", -- The image of the particle
            size = 0.8,                         -- The size of the particle
            spread = math.rad(360),             -- The spread of the particle (in radians)
            avgLifetime = 1,                    -- The lifetime of the particle
            count = 10,                         -- The number of particles to emit
            emissionRate = 1,                   -- The emission rate of the particle system
            damping = 0.5                       -- The damping of the particle system
        }
    },
    ui = {
        width = 160,                                -- The width of the UI
        font = "assets/fonts/NotoSans-Regular.ttf", -- The font used by the UI
        fontSize = 13                               -- The font size used by the UI
    },
    window = {
        width = 1400,                       -- The width of the window
        height = 900,                      -- The height of the window
        icon = "assets/images/rocket.png", -- The icon of the window
        mouseVisible = true,               -- Whether the mouse is visible or not
        resizable = true,                  -- Whether the window is resizable or not
        vsync = false                      -- Whether vsync is enabled or not
    },
    controls = {
        accelerate = "w",          -- The key used to accelerate
        decelerate = "s",          -- The key used to decelerate
        left = "a",                -- The key used to turn left
        right = "d",               -- The key used to turn right
        reset = "r",               -- The key used to reset the simulation
        changeAlgorithm = "space", -- The key used to change the algorithm
        exit = "escape"            -- The key used to exit the simulation
    }
}

-- Attempt to load the local configuration
-- print("Loading local configuration...")

local success, localConfig = pcall(require, "config")

-- If the local configuration failed to load, print the error and export default configuration
if not success then
    io.write("Warning: Failed to load local configuration.\n") -- localConfig contains the error message
    return cfg
end

-- Merge the default and local configurations, giving local overrides precedence
for category, categoryConfig in pairs(localConfig) do
    -- print("Merging category: " .. category)
    for key, value in pairs(categoryConfig) do
        -- print("  Overriding key: " .. key .. " with value: " .. tostring(value))
        cfg[category][key] = value
    end
end

-- print("Local configuration loaded successfully.")

-- Export the movement configuration
return cfg
