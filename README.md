# rocket-simulator

To setup your local configuration file:
1. Create a config.lua file
2. Place the following code inside. It will allow you to override every value locally.

```
-- Import the default configuration
local defaultConfig = require("default-config")

-- Create a local override table
local localConfig = {
    missile = {
        y = 500, -- Adjust the initial y position of the missile
        algorithm = defaultConfig.algorithms[2], -- Adjust the algorithm used by the missile
        -- You can override other missile parameters here
    },
    target = {
        speed = 8, -- Adjust the initial speed of the target
        -- You can override other target parameters here
    }
}

-- Merge the default and local configurations, giving local overrides precedence
for category, categoryConfig in pairs(localConfig) do
    for key, value in pairs(categoryConfig) do
        defaultConfig[category][key] = value
    end
end

-- Export the merged configuration
return defaultConfig
```