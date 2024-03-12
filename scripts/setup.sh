#!/bin/bash

# Usage: ./scripts/setup.sh
# Description: Sets up the environment for the rocket-simulator project.

echo "Setting up rocket-simulator..."

# Ask to install development dependencies
echo
read -p "Do you want to install development dependencies? (y/[n]) " -n 1 -r
echo
echo

install_dev_dependencies=false
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install_dev_dependencies=true
fi

# Function to create alias if it doesn't exist
create_alias() {
  local name=$1
  local command=$2

  # Check if alias is already set in the current session
  if alias "$name" &>/dev/null; then
    echo "Alias for $name already exists in the current session."
  else
    alias "$name=$command"
  fi
}

# Check if required programs are installed
required_commands=("git" "cmake")
if [ "$install_dev_dependencies" = true ]; then
  required_commands+=("docker") # Add docker to the list if dev dependencies are needed
fi

for cmd in "${required_commands[@]}"; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is not installed." >&2
    exit 1
  fi
done

# Update submodules
echo "Updating submodules..."
git submodule update --init --recursive || { echo "Error: Failed to update submodules." >&2; exit 1; }

# Build love
echo "Building love..."
cmake -B build lib/love && cmake --build build || { echo "Error: Failed to build love." >&2; exit 1; }

if [ "$install_dev_dependencies" = true ]; then
  # Build busted
  echo "Building busted..."
  docker build -t ghcr.io/lunarmodules/busted:latest lib/busted || { echo "Error: Failed to build busted." >&2; exit 1; }
  create_alias busted 'docker run -v "$(pwd):/data" ghcr.io/lunarmodules/busted:latest'
fi

# Create aliases
create_alias love 'build/love'

echo "Setup completed successfully!"
