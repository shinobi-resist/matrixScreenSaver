#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PRODUCT="MatrixScreenSaver"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"
PKG="$ROOT/build/$PRODUCT-$VERSION.pkg"
STAGING="$ROOT/build/dmg-staging"
DMG_OUT="$ROOT/build/$PRODUCT-$VERSION.dmg"

"$ROOT/make-pkg.sh"

rm -rf "$STAGING"
mkdir -p "$STAGING"
cp "$PKG" "$STAGING/$PRODUCT-$VERSION.pkg"

rm -f "$DMG_OUT"
hdiutil create \
  -volname "$PRODUCT" \
  -srcfolder "$STAGING" \
  -ov \
  -format UDZO \
  "$DMG_OUT"

rm -rf "$STAGING"
echo "Created $DMG_OUT"
