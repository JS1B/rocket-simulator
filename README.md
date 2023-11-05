# rocket-simulator
#### Video Demo <URL TODO>
#### Description
This repo contains a final project for Harvard [**CS50**](https://cs50.harvard.edu/x/) course.
The project is a rocket simulator, where the player controls a target and tries to dodge missiles that use different means of predicting the trajectory. The goal of the simulation is to showcase the different algorithms with their strengths and weaknesses.

_See the video demo for a better understanding of the project._

Showcased algorithms:
- TODO

## How to run
You need to have:
- Lua preinstalled
- c++ compiler preinstalled
- cmake preinstalled
- [LÖVE](https://github.com/love2d/love.git)

LÖVE is contained in the repo via submodules, so you can build and use it directly from the repo. To do that:
1. Clone the repo with the --recursive flag, or run `git submodule update --init --recursive` after cloning. 
2. Build it with cmake using `cmake -B build lib/love && cmake --build build`. This will create a binary file `love` in the `build` directory.
3. Run the game with `build/love .` from the root directory of the repo.

### Local configuration
To setup your local configuration file:
- Create a `config.lua` file and place the following code inside.
- You can also change the values in `default-config.lua`.

```
-- Import the default configuration
local defaultConfig = require("default-config")

-- Create a local override table
local localConfig = {
    missile = {
        y = 400, -- Adjust the initial y position of the missile
        -- You can override other missile parameters here
    },
    target = {
        speed = 8, -- Adjust the initial speed of the target
        -- You can override other target parameters here
    }
}

-- Merge the default and local configurations, giving local overrides precedence
for category, categoryConfig in pairs(localConfig) do
    print(" merging category: ", category)
    for key, value in pairs(categoryConfig) do
        print("  merging key: ", key)
        defaultConfig[category][key] = value
    end
end

-- Export the merged configuration
return defaultConfig
```