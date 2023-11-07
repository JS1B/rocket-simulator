-- Define the movement configuration for both rocket and target
local cfg = {
    missile = {
        x = 10,                      -- The initial x position of the rocket
        y = 300,                     -- The initial y position of the rocket

        acceleration = 1,            -- The acceleration of the rocket

        speed = 0,                   -- The initial speed of the rocket
        maxSpeed = 80,               -- The maximum speed of the rocket

        turnSpeed = 5,               -- The turning speed of the rocket

        algorithm = "PG"             -- The algorithm that the rocket will use
    },
    target = {
        x = 10,             -- The initial x position of the target
        y = 20,             -- The initial y position of the target

        acceleration = 0.5, -- The acceleration of the target

        speed = 5,          -- The initial speed of the target
        maxSpeed = 50,      -- The maximum speed of the target

        turnSpeed = 2       -- The turning speed of the target
    },
    ui = {
        width = 140,                                -- The width of the UI
        font = "assets/fonts/NotoSans-Regular.ttf", -- The font used by the UI
        fontSize = 13                               -- The font size used by the UI
    },
    window = {
        width = 800,                       -- The width of the window
        height = 600,                      -- The height of the window
        icon = "assets/images/rocket.png", -- The icon of the window
        mouseVisible = true                -- Whether the mouse is visible or not
    },
    controls = {
        accelerate = "w", -- The key used to accelerate
        decelerate = "s", -- The key used to decelerate
        left = "a",       -- The key used to turn left
        right = "d",       -- The key used to turn right
        reset = "r",       -- The key used to reset the simulation
        changeAlgorithm = "space", -- The key used to change the algorithm
        exit = "escape"    -- The key used to exit the simulation
    }
}

-- Export the movement configuration
return cfg
