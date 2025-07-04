# GAS.COM App - Testing and Deployment Guide
This document outlines the recommended strategies for testing the
GAS.COM mobile application and the steps involved in building and
deploying it to app stores.
## 1. Testing Strategy
A robust testing strategy is crucial for ensuring the stability,
functionality, and user experience of the GAS.COM app. Flutter
provides excellent built-in tools for various types of testing.
### 1.1 Types of Tests
* **Unit Tests (`flutter test`):**
* **Purpose:** To verify individual functions, methods, or classes
in isolation. They focus on the smallest testable parts of the
application's business logic.
* **Application:** Ideal for testing your `services/` (e.g.,
`UserDataService`, `CartService`, `BookmarkService`), `models/` (e.g.,
`OrderModel`, `ProductModel`) logic, data transformations, and utility
functions.
* **Location:** Typically placed in the `test/` folder, mirroring
the `lib/` structure (e.g.,
`test/services/user_data_service_test.dart`).
* **Widget Tests (`flutter test`):**
* **Purpose:** To verify that individual widgets or small groups
of widgets render correctly, respond to user input, and display the
expected UI based on given state. They don't require a device or
emulator.
* **Application:** Use for testing `components/` (e.g.,
`new_product_card.dart`, `cart_button.dart`, `dot_indicators.dart`),
and smaller `screens/` that don't involve complex navigation.
* **Location:** In the `test/` folder, usually mirroring the
widget's path (e.g.,
`test/components/product/new_product_card_test.dart`).
* **Integration Tests (`flutter drive` or `integration_test`
package):**
* **Purpose:** To verify entire user flows or significant portions

of the application, ensuring that different modules and services work
correctly together. These tests run on a real device or emulator.
* **Application:** Essential for testing complex flows like the
multi-stage authentication (onboarding -> password -> user login/admin
auth), the complete order placement process, and navigation between
major screens.
* **Location:** Typically in `integration_test/` folder within
your project.
### 1.2 Testing Best Practices
* **Test Coverage:** Aim for a high percentage of code coverage,
especially for critical business logic and UI components.
* **Mocking Dependencies:** Use `mockito` or manual mocks to isolate
units or widgets from their external dependencies (e.g.,
`SharedPreferences`, API calls). This ensures tests are fast,
reliable, and truly unit-focused.
* **Clear Test Names:** Test method names should clearly describe what
they are testing (e.g., `test('Login with valid credentials should
navigate to home screen')`).
* **Maintainable Tests:** Keep tests clean, readable, and focused.
Avoid complex logic within tests.
## 2. Deployment Guide
This section covers the steps necessary to build and deploy the
GAS.COM app to the Google Play Store (Android) and Apple App Store
(iOS).
### 2.1 Prerequisites
Before deployment, ensure you have:
* **Flutter SDK:** Latest stable version installed.
* **Android Studio & Android SDK:** For Android development.
* **Xcode:** For iOS development (macOS required).
* **Google Play Console Account:** For publishing Android apps
(one-time registration fee).
* **Apple Developer Program Account:** For publishing iOS apps (annual
fee).
* **Version Control:** Ensure your code is properly committed to a Git
repository.
### 2.2 Version Management
Always update the `version` in your `pubspec.yaml` before each
release. The `version` string consists of
`major.minor.patch+build_number`.

```yaml
version: 3.0.0+1 # Example: 3.0.0 is the human-readable version, 1 is
the build number
● Increment the build_number (+1) for every build you make (especially for internal
testing/CI/CD).
● Increment patch for bug fixes, minor for new features, and major for significant changes.
2.3 Building the Application
2.3.1 Android Builds
1. Navigate to Project Root: Open your terminal and cd into your project's root directory.
2. Generate Keystore (Once): For signing your Android app, you need a keystore. If you
don't have one:
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA
-keysize 2048 -validity 10000 -alias upload
○ Store upload-keystore.jks securely and remember the password, alias, and key
password.
3. Configure Signing:
○ Create a file ~/.gradle/gradle.properties (if it doesn't exist) and add your keystore
details (replace with your actual values):
MYAPP_UPLOAD_STORE_FILE=/home/collins/upload-keystore.jks
MYAPP_UPLOAD_KEY_ALIAS=upload
MYAPP_UPLOAD_STORE_PASSWORD=your_store_password
MYAPP_UPLOAD_KEY_PASSWORD=your_key_password
○ Edit android/app/build.gradle and configure the signingConfigs and buildTypes for
release. Look for the signingConfigs and buildTypes { release { ... } } blocks and
uncomment/update them based on Flutter's official guide.
4. Build Android App Bundle (.aab - Recommended for Play Store):
flutter build appbundle --release
○ The .aab file will be generated in build/app/outputs/bundle/release/app-release.aab.
5. Build APK (.apk - For direct sharing/testing):
flutter build apk --release
○ The .apk file will be in build/app/outputs/flutter-apk/app-release.apk.
2.3.2 iOS Builds (macOS Required)
1. Navigate to Project Root: Open your terminal and cd into your project's root directory.
2. Open Xcode Workspace:
open ios/Runner.xcworkspace
3. Configure Signing in Xcode:

○ In Xcode, select Runner in the project navigator.
○ Go to the Signing & Capabilities tab.
○ Select your Team.
○ Ensure Automatically manage signing is checked. Xcode will create/manage
necessary certificates and provisioning profiles.
4. Update App Icon & Launch Screen (if not done yet): Ensure
ios/Runner/Assets.xcassets/AppIcon.appiconset and
ios/Runner/Base.lproj/LaunchScreen.storyboard are correctly configured.
5. Build iOS Archive (for App Store Connect/TestFlight):
○ In Xcode, select Runner -> Generic iOS Device as the target.
○ Go to Product -> Archive.
○ After archiving, the Organizer window will appear. Select your archive and click
Distribute App.
○ Choose App Store Connect as the distribution method and follow the prompts to
upload your build.
6. Build IPA (for Ad Hoc/Enterprise distribution - not App Store):
flutter build ipa --release
○ The .ipa file will be in build/ios/archive/Runner.xcarchive/Products/Applications/.
This is generally not for App Store submission.

2.4 App Store Submission
2.4.1 Google Play Console (Android)
1. Create an App: Log in to your Google Play Console and create a new application.
2. Fill App Details: Provide app name, descriptions, privacy policy URL, category, contact
details, etc.
3. Upload App Bundle: Go to Release -> Production (or Internal testing, Open testing, etc.)
-> Create new release. Upload your app-release.aab file.
4. Testing Tracks: Utilize internal testing and closed testing tracks before rolling out to
production.
5. Content Rating: Complete the content rating questionnaire.
6. Pricing & Distribution: Set pricing (if any) and target countries.
7. Review & Rollout: Submit your app for review. Once approved, you can gradually roll out
the update.
2.4.2 Apple App Store Connect (iOS)
1. Create App Record: Log in to App Store Connect. Go to My Apps and create a new app
record.
2. Fill App Information: Provide app name, categories, privacy policy URL, copyright, etc.
3. Upload Build: Upload your archived build from Xcode (as described in 2.3.2). It will
appear under the TestFlight tab.
4. TestFlight (Beta Testing): Distribute builds to internal and external testers via TestFlight
for feedback.
5. Prepare for Submission:
○ In App Store Connect, go to App Store -> [Your App Version].

○ Provide screenshots, promotional text, keywords, and review notes.
○ Select the build you want to submit from TestFlight.
6. Submit for Review: Submit your app for Apple's review process. Be prepared for
potential rejections and follow their guidelines carefully.