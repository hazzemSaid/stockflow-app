# Google's J2ObjC annotations
-keep class com.google.j2objc.annotations.** { *; }

# Keep all classes that are referenced by the AndroidManifest
-keep class * extends android.app.Activity
-keep class * extends android.app.Application
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Firebase
# This tells R8: keep Firebase classes because the app may need them at runtime.
-keep class com.google.firebase.** { *; }
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Play Core (referenced by Flutter engine for deferred components, not used in this app)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.j2objc.annotations.RetainedWith
