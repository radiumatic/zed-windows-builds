#!/bin/bash

# Script to prepare release files from build artifacts

set -euo pipefail

ARTIFACTS_DIR="artifacts"
RELEASE_DIR="release"

# Create release directory
mkdir -p "$RELEASE_DIR"

# Check if GLES build exists
if [ -f "$ARTIFACTS_DIR/zed-linux-gles/zed" ]; then
    echo "Found GLES build, adding to release..."
    mv "$ARTIFACTS_DIR/zed-linux-gles/zed" "$RELEASE_DIR/zed"
    zip -j "$RELEASE_DIR/zed-linux-gles.zip" -9 "$RELEASE_DIR/zed"
fi

# Generate checksums for existing files in release folder
cd "$RELEASE_DIR"
if ls * >/dev/null 2>&1; then
    echo "Generating checksums..."
    sha256sum * > sha256sums.txt
    echo "Release files prepared successfully:"
    ls -la
else
    echo "Error: No release files found in release folder"
    exit 1
fi
