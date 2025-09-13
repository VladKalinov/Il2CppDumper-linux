#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PUBLISH_DIR="$ROOT_DIR/publish/linux-x64/fdd"

if [[ ! -f "$PUBLISH_DIR/Il2CppDumper.dll" ]]; then
  echo "FDD publish not found at $PUBLISH_DIR/Il2CppDumper.dll"
  echo "Run scripts/build_publish_fdd.sh first."
  exit 1
fi

exec dotnet "$PUBLISH_DIR/Il2CppDumper.dll" --help
