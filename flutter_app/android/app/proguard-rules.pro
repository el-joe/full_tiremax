# Flutter embedding / plugins (R8 safe defaults)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Play Core (deferred components) is referenced by the engine but not bundled
-dontwarn com.google.android.play.core.**

# flutter_secure_storage (Tink / androidx.security)
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**

# Keep annotations / generic signatures used by reflection-based plugins
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod
