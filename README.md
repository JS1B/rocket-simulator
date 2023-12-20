rocket-simulator
================

- [rocket-simulator](#rocket-simulator)
      - [Video Demo](#video-demo)
      - [Description](#description)
  - [Running the game](#running-the-game)
  - [Local configuration](#local-configuration)

#### Description
This repo contains a final project for Harvard [**CS50x**](https://cs50.harvard.edu/x/) course.
This project presents a missile evasion game. In this game, the player maneuvers a target to avoid incoming rockets, which employ various prediction algorithms to anticipate the target's path. The game's objective is not only to achieve the highest score possible but also to demonstrate the advantages and disadvantages of different prediction algorithms.

#### Video Demo
[<div align="center">
    <img src="https://www.gstatic.com/youtube/img/branding/youtubelogo/svg/youtubelogo.svg" width="25%"/>
    </div>
](https://www.youtube.com/)

Running the game
----------------

You need to have:
- preinstalled C++ compiler
- preinstalled cmake
- [LÖVE](https://github.com/love2d/love.git)

LÖVE is included as a submodule, allowing you to build and utilize it directly from the repository. Follow these steps:
1. Clone the repo with the --recursive flag, or run `git submodule update --init --recursive` after cloning.
2. Build it with cmake using `cmake -B build lib/love && cmake --build build`. This will create a binary file `love` in the `build` directory.
3. Run the game with `build/love .` from the root directory of the repo.

As an alternative, you can execute the `setup.sh` script to install the dependencies and build LÖVE.

Local configuration
-------------------

To setup your local configuration file:
- For usage you can change the values in `default-config.lua`.
- For development create a `config.lua` file and place the following code inside. Following the syntax of the default config file, you can override any of the parameters.

<details>
<summary>Example</summary>

```lua
-- Create a local override table
local localConfig = {
    missile = {
        y = 400                       -- Adjust the initial y position of the missile
        -- You can override other missile parameters here
    },
    target = {
        speed = 8         -- Adjust the initial speed of the target
        -- You can override other target parameters here
    }
}

-- Export the configuration
return localConfig

```
</details>

File structure
--------------

- `lib/` - contains submodules
  - `love/` - contains the LÖVE submodule
  - `busted/` - contains the busted submodule - for testing
  - `suit/` - contains the suit submodule - for UI
- `src/` - contains the source code of the game
  - `missile.lua` - contains the missile class
  - `missileFactory.lua` - contains the missileFactory class
  - `algorithms.lua` - contains the algorithms used by the missiles
  - `target.lua` - contains the target class
  - `collectible.lua` - contains the collectible class
  - `suitUI.lua` - contains the UI elements
  - `explosionFactory.lua` - contains the explosionFactory class
  - `utils.lua` - contains the utility functions
- `spec/` - contains the tests for the game logic
- `assets/` - contains the assets for the game
  - `fonts/` - contains the fonts used in the game
  - `images/` - contains the images used in the game
    - `bg/` - contains the background images, used for the parallax effect
- `build/` - contains the build files for the game - not tracked by git
- `default-config.lua` - contains the default configuration for the game
- `config.lua` - contains the local configuration for the game - not tracked by git
- `main.lua` - the entry point of the game
- `README.md` - this file
- `TODO.md` - contains the TODO list for the project
- `setup.sh` - contains the setup script for the project

Design choices
--------------

- The game is written in Lua, using the LÖVE framework
- The game is structured in a way that allows for:
  - easy testing of the game logic
  - easy addition of new algorithms
  - easy addition of new collectibles
  - easy addition of new missiles
  - easy addition of new UI elements
  - easy addition of new explosions for the missiles
  - easy configuration of the game parameters (e.g. missile speed, target speed, etc.) - see `default-config.lua`
  - easy addition of new backgrounds for the parallax effect
