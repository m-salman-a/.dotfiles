#!/bin/bash

# Find the local binary paths for fast lookup (bypass npx)
LOG_FILE="/tmp/zed-format-debug.log"

FILE_PATH="$1"

if [[ -z "$FILE_PATH" ]]; then
  echo "Error: Missing arguments. Usage: $0 {buffer_path} {working_directory}" >&2
  exit 1
fi

echo "Formatting started at $(date)" >> $LOG_FILE
echo "Target file: $1" >> $LOG_FILE

SEARCH_PATH=$(dirname "$FILE_PATH")

BIOME_BIN="./node_modules/.bin/biome"
PRETTIER_BIN="./node_modules/.bin/prettier"

# Climb the tree until we find biome.json or hit the Zed workspace root
while [[ "$SEARCH_PATH" != "/" ]]; do
  if [[ -f "$SEARCH_PATH/biome.json" ]] || [[ -f "$SEARCH_PATH/biome.jsonc" ]]; then
    echo "Found Biome!" >> $LOG_FILE

    # Use the local binary in node_modules if it exists for speed
    if [ -f $BIOME_BIN ]; then
      echo "Using local binary" >> $LOG_FILE
      exec $"$BIOME_BIN" check --write --stdin-file-path "$FILE_PATH"
    else
      echo "Fallback using npx" >> $LOG_FILE
      exec npx --no-install @biomejs/biome check --write --stdin-file-path "$FILE_PATH"
    fi
  fi
  
  # STOP if we have reached the workspace folder opened in Zed
  if [[ "$SEARCH_PATH" == "$WORKSPACE_ROOT" ]]; then
    break
  fi

  SEARCH_PATH=$(dirname "$SEARCH_PATH")
done

echo "Falling back to Prettier" >> $LOG_FILE

# If we broke out of the loop without finding Biome, fallback to Prettier
if [ -f $PRETTIER_BIN ]; then
  echo "Using local binary" >> $LOG_FILE
  exec $PRETTIER_BIN --stdin-filepath "$FILE_PATH"
else
  echo "Fallback using npx" >> $LOG_FILE
  exec npx --no-install prettier --stdin-filepath "$FILE_PATH"
fi
