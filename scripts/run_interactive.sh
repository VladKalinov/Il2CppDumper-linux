#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
PUBLISH_DIR="$ROOT_DIR/publish/linux-x64/fdd"
DLL_PATH="$PUBLISH_DIR/Il2CppDumper.dll"

# 1) Check dotnet presence
if ! command -v dotnet >/dev/null 2>&1; then
  echo "ERROR: dotnet is not installed. Install .NET SDK first, for example via snap:"
  echo "  sudo snap install dotnet-sdk --classic"
  echo "  sudo snap alias dotnet-sdk.dotnet dotnet"
  exit 1
fi

# 2) Ensure FDD publish exists
if [[ ! -f "$DLL_PATH" ]]; then
  echo "FDD publish not found, building it now..."
  bash "$ROOT_DIR/scripts/build_publish_fdd.sh"
fi

# 3) Run without args to enter interactive mode in Program.cs
exec dotnet "$DLL_PATH" "$@"
