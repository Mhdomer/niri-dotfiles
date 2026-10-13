#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="/tmp/noctalia-qs-rebuild"

echo "==> Preparing build directory: $BUILD_DIR"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

cp "$SCRIPT_DIR/PKGBUILD" "$BUILD_DIR/"

echo "==> Downloading sources..."
makepkg -o --nodeps

echo "==> Applying Qt 6.12 compatibility & Color fix patch..."
patch -p1 -d "$BUILD_DIR/src/noctalia-qs-0.0.12" < "$SCRIPT_DIR/qt6-12-compat-and-color-fix.patch"

echo "==> Compiling and packaging noctalia-qs..."
makepkg -e -f --nodeps

PACKAGE=$(ls -t "$BUILD_DIR"/noctalia-qs-*.pkg.tar.zst | head -n 1)
cp "$PACKAGE" "$SCRIPT_DIR/"

echo "==> Successfully built: $SCRIPT_DIR/$(basename "$PACKAGE")"
echo "==> To install run: sudo pacman -U --noconfirm \"$SCRIPT_DIR/$(basename "$PACKAGE")\""
