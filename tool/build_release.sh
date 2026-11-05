#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

version_name=$(sed -n 's/^version: *\([0-9.]*\).*/\1/p' pubspec.yaml)
history_offset=1000
build_number=$((history_offset + $(git rev-list --count HEAD)))
defines_file=${AKASHIC_DEFINES_FILE:-dart_defines.json}

defines=(--dart-define=APP_VERSION_NAME="$version_name")
if [ -f "$defines_file" ]; then
  defines+=(--dart-define-from-file="$defines_file")
fi

flutter build apk --release --split-per-abi --target-platform android-arm,android-arm64 --obfuscate --split-debug-info=build/debug-symbols \
  --build-name="$version_name" --build-number="$build_number" "${defines[@]}"

echo "Akashic $version_name"
