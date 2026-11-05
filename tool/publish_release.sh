#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

releases_repository=Nova686/akashic-releases
source_repository=Nova686/Akashic
version_name=$(sed -n 's/^version: *\([0-9.]*\).*/\1/p' pubspec.yaml)
tag="v${version_name}"

if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ] || [ -n "$(git status --porcelain)" ]; then
  echo "Publish from a clean, up-to-date main." >&2
  exit 1
fi
git fetch -q origin main --tags
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
  echo "Local main differs from origin/main." >&2
  exit 1
fi
if git ls-remote --exit-code --tags origin "refs/tags/${tag}" > /dev/null; then
  echo "${tag} is already released." >&2
  exit 1
fi

flutter analyze
flutter test

tool/build_release.sh
release_directory=$(mktemp -d)
cp build/app/outputs/flutter-apk/app-arm64-v8a-release.apk "${release_directory}/akashic.apk"
cp build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk "${release_directory}/akashic-armeabi-v7a.apk"

git tag "${tag}"
git push -q origin "${tag}"
gh api "repos/${source_repository}/releases/generate-notes" -f tag_name="${tag}" --jq .body > "${release_directory}/notes.md"
gh release create "${tag}" "${release_directory}/akashic.apk" "${release_directory}/akashic-armeabi-v7a.apk" \
  --repo "${releases_repository}" \
  --target main \
  --title "Akashic ${version_name}" \
  --notes-file "${release_directory}/notes.md"
echo "Akashic ${version_name} published in ${releases_repository}"
