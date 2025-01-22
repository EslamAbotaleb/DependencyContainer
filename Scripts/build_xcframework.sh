#!/bin/bash

# Set your SDKs
SIMULATOR_SDK="iphonesimulator"
DEVICE_SDK="iphoneos"

# Set your package name and scheme
PACKAGE="DependencyContainer"  # Change this to your package name
CONFIGURATION="Release"
DEBUG_SYMBOLS="true"

BUILD_DIR="$(pwd)/build"
DIST_DIR="$(pwd)/dist"

# Function to build framework
build_framework() {
  scheme=$1
  sdk=$2
  if [ "$2" = "$SIMULATOR_SDK" ]; then
    dest="generic/platform=iOS Simulator"
  elif [ "$2" = "$DEVICE_SDK" ]; then
    dest="generic/platform=iOS"
  else
    echo "Unknown SDK $2"
    exit 11
  fi

  echo "Building framework for $scheme"
  echo "Scheme: $scheme"
  echo "Configuration: $CONFIGURATION"
  echo "SDK: $sdk"
  echo "Destination: $dest"
  echo

  # Ensure we are in the root of the package
  cd "$(dirname "$0")/.."

  # Run the build command for the framework
  xcodebuild \
      -scheme "$scheme" \
      -configuration "$CONFIGURATION" \
      -destination "$dest" \
      -sdk "$sdk" \
      -derivedDataPath "$BUILD_DIR" \
      SKIP_INSTALL=NO \
      BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
      OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" || exit 12

  product_path="$BUILD_DIR/Build/Products/$CONFIGURATION-$sdk"
  framework_path="$BUILD_DIR/Build/Products/$CONFIGURATION-$sdk/PackageFrameworks/$scheme.framework"

  # Copy Headers
  headers_path="$framework_path/Headers"
  mkdir -p "$headers_path"
  cp -pv \
    "$BUILD_DIR/Build/Intermediates.noindex/$PACKAGE.build/$CONFIGURATION-$sdk/$scheme.build/Objects-normal/arm64/$scheme-Swift.h" \
    "$headers_path/" || exit 13

  # Copy other headers from Sources/
  headers=$(find "$PACKAGE/Sources" -name "*.h")
  for h in $headers; do
    cp -pv "$h" "$headers_path" || exit 14
  done

  # Copy Modules
  modules_path="$framework_path/Modules"
  mkdir -p "$modules_path"
  cp -pv \
    "$BUILD_DIR/Build/Intermediates.noindex/$PACKAGE.build/$CONFIGURATION-$sdk/$scheme.build/$scheme.modulemap" \
    "$modules_path" || exit 15
  mkdir -p "$modules_path/$scheme.swiftmodule"
  cp -pv "$product_path/$scheme.swiftmodule"/*.* "$modules_path/$scheme.swiftmodule/" || exit 16

  # Copy Bundle (if any)
  bundle_dir="$product_path/${PACKAGE}_$scheme.bundle"
  if [ -d "$bundle_dir" ]; then
    cp -prv "$bundle_dir"/* "$framework_path/" || exit 17
  fi
}

# Function to create the XCFramework
create_xcframework() {
  scheme=$1

  echo "Creating $scheme.xcframework"

  args=""
  shift 1
  for p in "$@"; do
    args+=" -framework $BUILD_DIR/Build/Products/$CONFIGURATION-$p/PackageFrameworks/$scheme.framework"
    if [ "$DEBUG_SYMBOLS" = "true" ]; then
      args+=" -debug-symbols $BUILD_DIR/Build/Products/$CONFIGURATION-$p/$scheme.framework.dSYM"
    fi
  done

  xcodebuild -create-xcframework $args -output "$DIST_DIR/$scheme.xcframework" || exit 21
}

# Reset package type to static (in case it was changed earlier)
reset_package_type() {
  cd "$(dirname "$0")/.."
  sed -i '' 's/( type: .dynamic,)//g' Package.swift || exit
}

# Set the package type to dynamic
set_package_type_as_dynamic() {
  cd "$(dirname "$0")/.."
  sed -i '' "s/(.library(name: *\"$1\",)/1 type: .dynamic,/g" Package.swift || exit
}

# Main script execution
echo "**********************************"
echo "******* Build XCFrameworks *******"
echo "**********************************"
echo

# Clean up previous build and dist directories
rm -rf "$BUILD_DIR"
rm -rf "$DIST_DIR"

# Reset and set package type as dynamic
reset_package_type
set_package_type_as_dynamic "DependencyContainer"

# Build frameworks for both simulators and device SDKs
build_framework "DependencyContainer" "$SIMULATOR_SDK"
build_framework "DependencyContainer" "$DEVICE_SDK"

# Create the XCFramework from both builds
create_xcframework "DependencyContainer" "$SIMULATOR_SDK" "$DEVICE_SDK"

echo "Build process complete!"
