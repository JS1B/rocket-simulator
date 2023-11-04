-- Define the movement configuration for both rocket and target
local cfg = {
    missile = {
        x = 10, -- The initial x position of the rocket
        y = 300, -- The initial y position of the rocket

        acceleration = 1, -- The acceleration of the rocket

        speed = 0, -- The initial speed of the rocket
        maxSpeed = 80, -- The maximum speed of the rocket

        turnSpeed = 5, -- The turning speed of the rocket
        
        algorithms = { "PG", "PN" }, -- The algorithms that the rocket can use
        algorithm = "PG" -- The algorithm that the rocket will use
    },
    target = {
        x = 10, -- The initial x position of the target
        y = 20, -- The initial y position of the target

        acceleration = 0.5, -- The acceleration of the target

        speed = 5, -- The initial speed of the target
        maxSpeed = 50, -- The maximum speed of the target

        turnSpeed = 2 -- The turning speed of the target
    },
    ui = {
        width = 140, -- The width of the UI
        font = "assets/fonts/NotoSans-Regular.ttf", -- The font used by the UI
        fontSize = 13 -- The font size used by the UI
    }
}

-- Export the movement configuration
return cfg
