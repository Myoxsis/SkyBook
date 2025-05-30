#!/bin/bash
# Patch gallery_saver plugin to add namespace for AGP 8+
set -e
PLUGIN_VERSION="2.3.2"
PLUGIN_DIR="$HOME/.pub-cache/hosted/pub.dev/gallery_saver-$PLUGIN_VERSION/android"
GRADLE_FILE="$PLUGIN_DIR/build.gradle"

if [ -f "$GRADLE_FILE" ]; then
  if ! grep -q "namespace" "$GRADLE_FILE"; then
    sed -i '/^android {/a\\    namespace "com.example.gallery_saver"' "$GRADLE_FILE"
    echo "Added namespace to $GRADLE_FILE"
  else
    echo "Namespace already present in $GRADLE_FILE"
  fi
else
  echo "gallery_saver plugin not found at $GRADLE_FILE"
fi
