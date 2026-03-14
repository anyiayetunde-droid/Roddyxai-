#!/bin/bash

# setup_gateway.sh
# This script sets up the OpenClaw gateway in a Termux-like environment on Android.
#
# IMPORTANT: This script is intended to be executed within a Termux environment
# or an app with similar system-level access. Standard Android app sandboxes
# may block the package manager commands (pkg/apt).

set -e

echo "Setting up OpenClaw Gateway..."

# 1. Update and install basic dependencies
if command -v pkg &> /dev/null; then
    pkg update -y
    pkg install -y git nodejs
elif command -v apt &> /dev/null; then
    apt update -y
    apt install -y git nodejs npm
fi

# 2. Install OpenClaw globally
if ! command -v openclaw &> /dev/null; then
    echo "Installing OpenClaw via npm..."
    npm install -g openclaw@latest --ignore-scripts
fi

# 3. Apply Android/Termux patches (Bionic Bypass)
# OpenClaw needs some adjustments to run on Android's Bionic libc
PATCH_DIR="$HOME/.openclaw-android/patches"
mkdir -p "$PATCH_DIR"

cat <<EOF > "$PATCH_DIR/glibc-compat.js"
const os = require('os');
const originalNetworkInterfaces = os.networkInterfaces;
os.networkInterfaces = () => {
    try {
        return originalNetworkInterfaces();
    } catch (e) {
        return {};
    }
};
EOF

# Set environment variables for OpenClaw
export NODE_OPTIONS="-r $PATCH_DIR/glibc-compat.js"
export TMPDIR="$HOME/tmp"
mkdir -p "$TMPDIR"

echo "OpenClaw Gateway setup complete!"
echo "You can now run 'openclaw onboard' to configure and 'openclaw gateway' to start."
