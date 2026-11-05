#!/usr/bin/env bash
# Run from the folder that contains level1_lifted/ and final/
set -e
HERE="$(pwd)"
flutter create shop
cd shop

# --- Level 1 -> commit "lifted"
rm -rf lib && cp -R "$HERE/level1_lifted/lib" lib
dart format .
git init -q 2>/dev/null || true
git add -A && git commit -qm "lifted"

# --- Final (Levels 2-5)
flutter pub add provider
rm -rf lib && cp -R "$HERE/final/lib" lib
cp "$HERE/final/NOTES.md" .
dart format .
flutter analyze
git add -A && git commit -qm "provider: Cart model, select, consumer, snackbar, dialog"
echo "Done. Now: flutter run, take screenshots, commit, push."
