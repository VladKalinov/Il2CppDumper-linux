#!/usr/bin/env bash
set -euo pipefail

# Build and publish framework-dependent (FDD) package for linux-x64
# Requires: dotnet SDK >= 8.0

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PUBLISH_DIR="$ROOT_DIR/publish/linux-x64/fdd"

mkdir -p "$PUBLISH_DIR"

pushd "$ROOT_DIR" >/dev/null
  dotnet publish Il2CppDumper/Il2CppDumper.csproj \
    -c Release \
    -f net8.0 \
    -r linux-x64 \
    --self-contained false \
    -o "$PUBLISH_DIR"
popd >/dev/null

echo "Published to: $PUBLISH_DIR"
echo "Run: dotnet $PUBLISH_DIR/Il2CppDumper.dll --help"
