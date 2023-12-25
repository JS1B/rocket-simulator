# Usage: source ./setup.sh
# Description: Sets up the environment for the project

echo "Setting up rocket-simulator..."

# Function to create alias if it doesn't exist
create_alias() {
  local name=$1
  local command=$2

  # Check if alias is already set in the current session
  if alias "$name" &>/dev/null; then
    echo "Alias for $name already exists in the current session."
  else
    alias "$name=$command"
    echo "Alias for $name created for the current session."
  fi
}

# Check if required programs are installed
for cmd in git cmake docker; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is not installed." >&2
    return 1
  fi
done

# Update submodules if not already done
git submodule update --init --recursive || { echo "Error: Failed to update submodules." >&2; return 1; }

# Build love
cmake -B build lib/love && cmake --build build || { echo "Error: Failed to build love." >&2; return 1; }

# Build busted
docker build -t ghcr.io/lunarmodules/busted:latest lib/busted || { echo "Error: Failed to build busted." >&2; return 1; }

# Create aliases
create_alias busted 'docker run -v "$(pwd):/data" ghcr.io/lunarmodules/busted:latest'
create_alias love 'build/love'

echo "Setup completed successfully!"