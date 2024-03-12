#!/bin/bash

# Usage: ./scripts/run.sh
# Description: Runs the game.

# Navigate to the script's directory, then to the project root
cd "$(dirname "$0")"/..

# Check if the build exists and run the game
if [ -f ./build/love ]; then
    echo "Running the game..."
    ./build/love . || { echo "Error: Failed to run the game." >&2; exit 1;}
else
    echo "Error: Game not built. Please build the game first." >&2
    exit 1
fi
