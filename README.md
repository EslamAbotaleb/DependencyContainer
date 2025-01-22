# To convert custom swift package manager into xcframework 
 
 # Build for iOS device
xcodebuild build \
  -scheme <SchemeName> \  # Replace <SchemeName> with your actual scheme name
  -sdk iphoneos \
  -configuration Release \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  -destination 'generic/platform=iOS' \
  -derivedDataPath <DerivedDataPath>/iphoneos  # Replace <DerivedDataPath> with your desired path

# Build for iOS simulator
xcodebuild build \
  -scheme <SchemeName> \  # Replace <SchemeName> with your actual scheme name
  -sdk iphonesimulator \
  -configuration Release \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath <DerivedDataPath>/iphonesimulator  # Replace <DerivedDataPath> with your desired path

  # Create an XCFramework
xcodebuild -create-xcframework \
  -framework <DerivedDataPath>/iphoneos/Build/Products/Release-iphoneos/<FrameworkName>.framework \  # Replace <DerivedDataPath> and <FrameworkName>
  -framework <DerivedDataPath>/iphonesimulator/Build/Products/Release-iphonesimulator/<FrameworkName>.framework \  # Replace <DerivedDataPath> and <FrameworkName>
  -output <OutputPath>/<XCFrameworkName>.xcframework  # Replace <OutputPath> and <XCFrameworkName>
