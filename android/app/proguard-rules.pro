-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }
-keep interface com.google.android.gms.location.** { *; }

# Flutter CallKit Incoming keep rules
-keep class com.hiennv.flutter_callkit_incoming.** { *; }
-keepclassmembers class com.hiennv.flutter_callkit_incoming.** { *; }

# Firebase Messaging / FCM
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# Prevent stripping BroadcastReceiver, Service, etc.
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.app.Service

# Keep all Agora SDK classes
-keep class io.agora.** { *; }

# Keep JNI classes
-keep class **.RTC** { *; }

# Required to prevent obfuscation of callback methods
-keepclassmembers class * {
    public <init>(...);
}

# Needed for reflection
-keepattributes *Annotation*, InnerClasses

# Prevent removal of callbacks used in Agora
# Note: The overly broad "keep class **" rule has been removed
# If you need to keep specific Agora callbacks, add them specifically:
# -keepclassmembers class io.agora.rtc.** {
#     public void on*(...);
# }

# Avoid stripping of classes implementing interfaces
-keep interface io.agora.** { *; }
-keep class * implements io.agora.** { *; }

# If using JSON parsing libraries (like Gson)
-keep class com.google.gson.** { *; }

# Flutter plugins in general
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Optional: If you're using `flutter_callkit_incoming` or notifications
-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Required for WorkManager
-keep class androidx.work.impl.** { *; }
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.background.systemjob.SystemJobService { *; }

# Required for Flutter plugins using WorkManager
-keep class androidx.lifecycle.LiveData { *; }
-keep class androidx.lifecycle.MutableLiveData { *; }
-keep class androidx.lifecycle.ViewModel { *; }

# Prevent removing your workers
-keep class * extends androidx.work.Worker { *; }
-keepclassmembers class * extends androidx.work.Worker {
    public <init>(...);
}
# Keep Firebase Messaging Service
-keep class com.google.firebase.messaging.FirebaseMessagingService { *; }

# Keep Firebase classes used by messaging
-keep class com.google.firebase.** { *; }
-keepclassmembers class * extends com.google.firebase.messaging.FirebaseMessagingService {
    <init>();
    void onMessageReceived(com.google.firebase.messaging.RemoteMessage);
    void onNewToken(java.lang.String);
}

# Keep methods called by reflection (e.g., Flutter plugins)
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry

-keep class com.hiennv.flutter_callkit_incoming.** { *; }
-keep class vn.hunghd.flutter_callkit_incoming.** { *; }
-keep class io.flutter.plugin.common.MethodChannel$IncomingMethodCallHandler { *; }
-keep class io.flutter.plugin.common.EventChannel$StreamHandler { *; }

-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**

# ============================================================
# Stripe Payment SDK ProGuard Rules
# ============================================================

# Keep all Stripe classes
-keep class com.stripe.android.** { *; }
-keep interface com.stripe.android.** { *; }
-keepclassmembers class com.stripe.android.** { *; }

# Keep Stripe model classes (for API responses)
-keep class com.stripe.android.model.** { *; }
-keepclassmembers class com.stripe.android.model.** {
    <fields>;
    <methods>;
}

# Keep Stripe payment methods and card information
-keep class com.stripe.android.paymentsheet.** { *; }
-keep class com.stripe.android.view.** { *; }

# Keep Stripe payment authentication
-keep class com.stripe.android.payments.** { *; }
-keep class com.stripe.android.stripe3ds2.** { *; }

# Keep Stripe network classes
-keep class com.stripe.android.networking.** { *; }

# Keep Stripe CustomerSession
-keep class com.stripe.android.CustomerSession { *; }
-keep class com.stripe.android.CustomerSession$* { *; }

# Keep Stripe PaymentConfiguration
-keep class com.stripe.android.PaymentConfiguration { *; }
-keep class com.stripe.android.PaymentConfiguration$* { *; }

# Keep Stripe exception classes
-keep class com.stripe.android.exception.** { *; }

# Keep Stripe core classes
-keep class com.stripe.android.core.** { *; }

# Keep Stripe UI components
-keep class com.stripe.android.ui.** { *; }

# Prevent obfuscation of Stripe callbacks
-keepclassmembers class * implements com.stripe.android.ApiResultCallback {
    <methods>;
}
-keepclassmembers class * implements com.stripe.android.PaymentResultCallback {
    <methods>;
}

# Keep Stripe annotations
-keepattributes *Annotation*
-keep @com.stripe.android.** class * { *; }

# Stripe 3DS2 authentication
-keep class com.stripe.android.stripe3ds2.init.** { *; }
-keep class com.stripe.android.stripe3ds2.transaction.** { *; }

# Keep Flutter Stripe plugin classes
-keep class com.flutter.stripe.** { *; }
-keep class io.flutter.plugins.stripe.** { *; }
-keepclassmembers class io.flutter.plugins.stripe.** { *; }

# Don't warn about Stripe
-dontwarn com.stripe.android.**

# ============================================================
# Additional Essential ProGuard Rules for Flutter Production
# ============================================================

# Keep Kotlin Metadata for reflection
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# Keep Kotlin Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}

# Keep all model classes (add your package name if you have data models)
-keep class com.marker.app.models.** { *; }
-keep class com.marker.app.data.** { *; }

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep native methods
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Keep view constructors (for XML inflation)
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep R class and all its inner classes
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Additional attributes to keep for debugging
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions
-keepattributes EnclosingMethod

# Rename source file attribute to hide actual source file names
-renamesourcefileattribute SourceFile

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# OkHttp and Retrofit (if using HTTP libraries)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Retrofit
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}

# Gson (JSON serialization) - Important for payment data
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.examples.android.model.** { <fields>; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep BuildConfig
-keep class com.marker.app.BuildConfig { *; }

# Keep ApplicationInfo
-keep class android.content.pm.ApplicationInfo { *; }

# Keep all Activity, Service, and BroadcastReceiver classes
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Fragment
-keep public class * extends androidx.fragment.app.Fragment

# Remove logging in release builds (keep errors for debugging)
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# Keep crash reporting classes (important for payment issues)
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# WebView JavaScript Interface (if using for payment redirects)
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
   public *;
}

# Image loading libraries (if using)
-dontwarn com.squareup.picasso.**
-keep class com.squareup.picasso.** { *; }

# Database (Room/SQLite) - for storing payment info locally
-keep class * extends androidx.room.RoomDatabase
-keep @androidx.room.Entity class *
-dontwarn androidx.room.paging.**

# Keep MethodHandles (for Java 8+ compatibility)
-keepclassmembers class java.lang.invoke.** {
    *;
}

# Security - SSL/TLS (Critical for payment security)
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**
-keep class javax.net.ssl.** { *; }
-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**

# ============================================================
# Payment Security & Encryption
# ============================================================

# Keep security provider classes
-keep class com.google.android.gms.security.** { *; }
-keep class org.spongycastle.** { *; }
-dontwarn org.spongycastle.**

# Keep all classes related to encryption
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }

# End of ProGuard Rules
