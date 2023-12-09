-- Define the movement configuration for both rocket and target
local cfg = {
    missile = {
        x = 10,                              -- The initial x position of the rocket
        y = 300,                             -- The initial y position of the rocket

        sprite = "assets/images/rocket.png", -- The sprite of the rocket
        spriteRotation = math.rad(90),       -- The rotation of the sprite of the rocket (in radians)
        width = 25,                          -- The width of the rocket
        height = 25,                         -- The height of the rocket

        acceleration = 10,                   -- The acceleration of the rocket

        speed = 0,                           -- The initial speed of the rocket
        maxSpeed = 200,                      -- The maximum speed of the rocket

        turnSpeed = 5,                       -- The turning speed of the rocket

        algorithm = "PG",                    -- The algorithm that the rocket will use initially

        trace = false,                       -- Whether the rocket will leave a trace or not
        traceLength = 100,                   -- The length of the trace
        traceColor = { 1, 1, 1, 0.5 },       -- The color of the trace
        traceFrequency = 0.5,                -- The frequency of the trace in seconds

        particle = {
            image = "assets/images/fire.png", -- The image of the particle
            size = 0.1,                       -- The size of the particle
            minSpeedSpread = math.rad(90),    -- The minimum speed spread of the particle (in radians)
            maxSpeedSpread = math.rad(22),    -- The maximum speed spread of the particle (in radians)
            avgLifetime = 1,                  -- The average lifetime of the particle
            count = 400,                      -- The number of particles to emit
            minSpeedEmissionRate = 30,        -- The emission rate of the particle system
            maxSpeedEmissionRate = 120        -- The emission rate of the particle system
        }
    },
    explosion = {
        image = "assets/images/explosion.png", -- The image of the particle
        size = 0.5,                            -- The size of the particle
        quadsTiles = { 5, 5, 5, 5 },           -- The number of quads in the sprite per row
        animationSpeed = 20                    -- The speed of the animation per second
    },
    target = {
        x = 10,                             -- The initial x position of the target
        y = 20,                             -- The initial y position of the target

        sprite = "assets/images/plane.png", -- The sprite of the target
        spriteRotation = math.rad(-90),     -- The rotation of the sprite of the target (in radians)
        width = 40,                         -- The width of the target
        height = 40,                        -- The height of the target

        acceleration = 16,                  -- The acceleration of the target

        speed = 5,                          -- The initial speed of the target
        maxSpeed = 120,                     -- The maximum speed of the target

        turnSpeed = 2,                      -- The turning speed of the target

        lives = 3,                          -- The number of lives of the target

        particle = {
            image = "assets/images/smoke.png", -- The images of the particle animation
            quadsTiles = { 3, 3, 1 },          -- The number of images in the particle animation
            size = 0.5,                        -- The size of the particle
            spread = math.rad(10),             -- The spread of the particle (in radians)
            spreadOffset = math.rad(45),       -- The spread offset of the particle (in radians)
            lifetime = 1.4,                    -- The lifetime of the particle
            count = 100,                       -- The number of particles to emit
            emissionRate = 4,                  -- The emission rate of the particle system
            damping = 0.8                      -- The damping of the particle system
        }
    },
    collectible = {
        sprite = "assets/images/coin.png", -- The sprite of the collectible
        quadsTiles = { 6 },                -- The number of quads in the sprite per row
        animationSpeed = 20                -- The speed of the animation per second
    },
    ui = {
        width = 160,                                -- The width of the UI
        font = "assets/fonts/NotoSans-Regular.ttf", -- The font used by the UI
        fontSize = 13                               -- The font size used by the UI
    },
    window = {
        title = "Rocket simulator",                                              -- The title of the window
        fullscreen = false,                                                      -- Whether the window is fullscreen or not
        width = 1400,                                                            -- The width of the window
        height = 900,                                                            -- The height of the window
        icon = "assets/images/rocket.png",                                       -- The icon of the window
        mouseVisible = true,                                                     -- Whether the mouse is visible or not
        resizable = true,                                                        -- Whether the window is resizable or not
        vsync = false,                                                           -- Whether vsync is enabled or not
        backgroundImages = { { image = "assets/images/bg/Sky.png", depth = 30 }, -- The background images of the window
            { image = "assets/images/bg/Sky Gradient.png", depth = 30 },         -- The background images of the window
            { image = "assets/images/bg/Clouds.png",       depth = 18 },         -- The background images of the window
            { image = "assets/images/bg/Hills 5.png",      depth = 14 },         -- The background images of the window
            { image = "assets/images/bg/Hills 4.png",      depth = 12 },         -- The background image of the window
            { image = "assets/images/bg/Hills 3.png",      depth = 10 },         -- The background images of the window
            { image = "assets/images/bg/Hills 2.png",      depth = 8 },          -- The background images of the window
            { image = "assets/images/bg/Hills 1.png",      depth = 7 },          -- The background images of the window
            { image = "assets/images/bg/Trees.png",        depth = 7 }           -- The background images of the window
        },
        scaleX = 2.0                                                             -- The scale of the window on the x axis
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
