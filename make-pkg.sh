#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PRODUCT="MatrixScreenSaver"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"
BUILD_BUNDLE="$ROOT/build/$PRODUCT.saver"
COMPONENT_PKG="$ROOT/build/$PRODUCT-component.pkg"
PKG_OUT="$ROOT/build/$PRODUCT-$VERSION.pkg"

"$ROOT/build.sh"

xattr -dr com.apple.quarantine "$BUILD_BUNDLE" 2>/dev/null || true

pkgbuild \
  --root "$BUILD_BUNDLE" \
  --install-location "/Library/Screen Savers/$PRODUCT.saver" \
  --scripts "$ROOT/Installer/scripts" \
  --identifier "com.shinobi-resist.matrixscreensaver" \
  --version "$VERSION" \
  "$COMPONENT_PKG"

productbuild \
  --distribution "$ROOT/Installer/distribution.xml" \
  --resources "$ROOT/Installer/resources" \
  --package-path "$ROOT/build" \
  "$PKG_OUT"

rm -f "$COMPONENT_PKG"

echo "Created $PKG_OUT"
