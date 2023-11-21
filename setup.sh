# Usage: source ./setup.sh
# Description: Sets up the environment for the project

echo "Setting up rocket-simulator..."

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
if [ -z "$(alias busted)" ]; then
  alias busted='docker run -v "$(pwd):/data" ghcr.io/lunarmodules/busted:latest'
fi

if [ -z "$(alias love)" ]; then
  alias love='build/love'
fi

echo "Setup completed successfully!"