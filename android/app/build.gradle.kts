import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing — see android/key.properties (gitignored, never commit it
// or the .jks it points to). Falls back to null (and the debug signingConfig
// below) when key.properties doesn't exist, so `flutter run --release` and
// CI checkouts without the real keystore still build.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.nabvera.app"
    // permission_handler_android requires API 37 or higher.
    compileSdk = maxOf(flutter.compileSdkVersion, 37)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        // Required by flutter_local_notifications (v10+) for its scheduled
        // -notification backward compatibility — see its README's
        // "desugaring" section. Needed even though we schedule inexact
        // reminders, not just exact ones.
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.nabvera.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // health requires API 26 or higher.
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Real release signing when key.properties/the keystore are
            // present (a real machine set up for release builds); falls
            // back to the debug key otherwise so `flutter run --release`
            // still works on a fresh checkout without the production
            // keystore. A Play Store upload built without the real
            // keystore present would silently ship debug-signed — always
            // confirm `keystorePropertiesFile.exists()` before uploading.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Required alongside isCoreLibraryDesugaringEnabled above — see the
    // matching comment on that line.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
