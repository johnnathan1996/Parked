package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.example.appsettings.AppSettingsPlugin;
import io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin;
import io.flutter.plugins.firebaseauth.FirebaseAuthPlugin;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.firebase.storage.FirebaseStoragePlugin;
import fr.g123k.flutterappbadger.FlutterAppBadgerPlugin;
import dev.leadcode.flutter_device_locale.FlutterDeviceLocalePlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import com.aloisdeniel.geocoder.GeocoderPlugin;
import com.noeatsleepdev.geoflutterfire.GeoflutterfirePlugin;
import com.baseflow.geolocator.GeolocatorPlugin;
import com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin;
import io.flutter.plugins.googlemaps.GoogleMapsPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.codeheadlabs.libphonenumber.LibphonenumberPlugin;
import com.baseflow.location_permissions.LocationPermissionsPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugins.share.SharePlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.jaumard.smsautofill.SmsAutoFillPlugin;
import com.plushundred.speechbubble.SpeechBubblePlugin;
import com.tekartik.sqflite.SqflitePlugin;
import de.jonasbark.stripepayment.StripePaymentPlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AppSettingsPlugin.registerWith(registry.registrarFor("com.example.appsettings.AppSettingsPlugin"));
    CloudFirestorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    FirebaseAuthPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    FirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FirebaseCorePlugin"));
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FirebaseStoragePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.storage.FirebaseStoragePlugin"));
    FlutterAppBadgerPlugin.registerWith(registry.registrarFor("fr.g123k.flutterappbadger.FlutterAppBadgerPlugin"));
    FlutterDeviceLocalePlugin.registerWith(registry.registrarFor("dev.leadcode.flutter_device_locale.FlutterDeviceLocalePlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
    GeocoderPlugin.registerWith(registry.registrarFor("com.aloisdeniel.geocoder.GeocoderPlugin"));
    GeoflutterfirePlugin.registerWith(registry.registrarFor("com.noeatsleepdev.geoflutterfire.GeoflutterfirePlugin"));
    GeolocatorPlugin.registerWith(registry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
    GoogleApiAvailabilityPlugin.registerWith(registry.registrarFor("com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin"));
    GoogleMapsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.googlemaps.GoogleMapsPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    LibphonenumberPlugin.registerWith(registry.registrarFor("com.codeheadlabs.libphonenumber.LibphonenumberPlugin"));
    LocationPermissionsPlugin.registerWith(registry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    SharePlugin.registerWith(registry.registrarFor("io.flutter.plugins.share.SharePlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SmsAutoFillPlugin.registerWith(registry.registrarFor("com.jaumard.smsautofill.SmsAutoFillPlugin"));
    SpeechBubblePlugin.registerWith(registry.registrarFor("com.plushundred.speechbubble.SpeechBubblePlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    StripePaymentPlugin.registerWith(registry.registrarFor("de.jonasbark.stripepayment.StripePaymentPlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
