import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:marker/app/data/models/redeemed_upcoming_model/redeemed_upcoming_model.dart';
import 'package:marker/app/data/services/payment_service/payment_service.dart';
import 'package:marker/app/global/env_config.dart';
import 'package:marker/app/utils/constants/common_utils.dart';
import 'package:marker/app/utils/helpers/exception/exception.dart';
import 'package:marker/app/utils/helpers/extensions/extensions.dart';
import 'package:marker/app/utils/helpers/injectable/injectable.dart';
import 'package:marker/app/utils/helpers/loading.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StripTerminalController {
  static final terminalState = ApiState.initial().obs;

  static String tip = '';
  static String barId = '';
  static String drinkId = '';
  static String userId = getIt<SharedPreferences>().getUserId ?? '';
  static String transactionId = '';
  static num price = 0;
  static RedeemedUpcomingListData? latestMarkerModel;

  // Stripe Terminal variables

  static StreamSubscription<ConnectionStatus>? onConnectionStatusChangeSub;
  static StreamSubscription<PaymentStatus>? onPaymentStatusChangeSub;
  static StreamSubscription<List<Reader>>? discoverReaderSub;

  // List<Location> _locations = [];
  static Location? selectedLocation;
  static Reader? readerUse;
  static PaymentIntent? paymentIntentUse;
  static CancelableFuture<PaymentIntent>? collectingPaymentMethodUse;

  static final readers = <Reader>[].obs; // Observable list of readers

  // Automatically use simulated reader in debug mode, production reader in release mode
  static bool get isSimulated => kDebugMode;

  static void errorShow(String? message) {
    Loading.dismiss();
    if (message != null) {
      showError(message);
    }
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  /// Check if Tap to Pay is available on the device
  /// Android: Checks if NFC is enabled in settings
  /// iOS: Checks if device supports Tap to Pay (Proximity Reader) - requires iPhone XS or later with iOS 15.4+
  /// Returns false if Tap to Pay is not available - shows appropriate message
  static Future<bool> checkNfcEnabled() async {
    try {
      const platform = MethodChannel('marker.app/nfc');
      final isNfcEnabled = await platform.invokeMethod<bool>('isNfcEnabled');

      if (isNfcEnabled != true) {
        Loading.dismiss(); // Dismiss loading before showing error

        if (Platform.isAndroid) {
          errorShow('NFC is not enabled on your device.');
          final openSettings = await permissionDialogForSettings(
            message: 'NFC is required for tap-to-pay. Please enable NFC in your device settings.',
          );
          if (openSettings == true) {
            await openAppSettings();
          }
        } else {
          // iOS - NFC not available (older device)
          errorShow('NFC is not available on this device. Tap to Pay requires iPhone XS or later with iOS 15.4+.');
        }
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('Error checking NFC status: $e');
      // If we can't check, assume it's available to not block the flow
      return true;
    }
  }

  /// Request necessary permissions for Stripe Terminal (Location & Bluetooth)
  static Future<bool> requestPermissions() async {
    try {
      //debugger();
      print("debuggerdebuggerdebugger 11111");

      final permissions = [
        Permission.locationWhenInUse,
        if (Platform.isAndroid) ...[
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
        ],
        if (Platform.isIOS) Permission.bluetooth,
      ];

      for (final permission in permissions) {
        var result = await permission.status;
        if (result.isDenied) {
          result = await permission.request();
        }
        if (result.isDenied || result.isPermanentlyDenied) {
          Loading.dismiss(); // Dismiss loading before showing error
          errorShow('Location and Bluetooth permissions are required for NFC tap-to-pay.');
          final openSettings = await permissionDialogForSettings(
            message: 'Location and Bluetooth permissions are required for NFC tap-to-pay. Please enable them in Settings.',
          );
          if (openSettings == true) {
            await openAppSettings();
          }
          return false;
        }
      }
      return true;
    } catch (e) {
      print('Error requesting permissions: $e');
      errorShow('Unable to request permissions. Please ensure location and Bluetooth are enabled in Settings.');
      return false;
    }
  }

  /// Get connection token from Stripe API
  static Future<String> getConnectionToken() async {
    //debugger();
    print("debuggerdebuggerdebugger 22222");
    String token = '';
    await getIt<PaymentService>().terminalToken().handler(terminalState, onSuccess: (value) {
      token = value.secret ?? '';
    }, onFailed: (value) {
      errorShow(value.error.description);
    }, isLoading: false);
    return token;
  }

  /// Initialize Stripe Terminal for NFC/Tap-to-Pay functionality
  static Future<void> initTerminal() async {
    try {
      // Check if NFC is enabled on the device (Android only)
      final isNfcEnabled = await checkNfcEnabled();
      if (!isNfcEnabled) return;

      // Request permissions first - returns false if denied (Settings opened)
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) return;

      if (Terminal.isInitialized) {
        await collectPayment();
        return;
      }

      //debugger();
      print("debuggerdebuggerdebugger 3333");
      // Get connection token
      final connectionToken = await getConnectionToken();

      await Terminal.initTerminal(
        shouldPrintLogs: true,
        fetchToken: () async {
          //debugger();
          print("debuggerdebuggerdebugger 44444");

          return connectionToken;
        },
      );

      //debugger();
      print("debuggerdebuggerdebugger 55555");

      getIt<SharedPreferences>().setStripTerminal = true;
      // Listen to connection status changes
      onConnectionStatusChangeSub = Terminal.instance.onConnectionStatusChange.listen((status) {
        debugPrint('Connection Status Changed: ${status.name}');
      });

      // Listen to payment status changes
      onPaymentStatusChangeSub = Terminal.instance.onPaymentStatusChange.listen((status) {
        debugPrint('Payment Status Changed: ${status.name}');
      });

      // Fetch locations
      await fetchLocations();

      // Start discovering readers
      startDiscoverReaders(Terminal.instance);
    } catch (e) {
      errorShow('Error initializing Stripe Terminal: $e');
    }
  }

  /// Fetch available locations from Stripe
  static Future<void> fetchLocations() async {
    //debugger();
    print("debuggerdebuggerdebugger 6666");

    //debugger();
    print("debuggerdebuggerdebugger 7777");

    final locations = await Terminal.instance.listLocations();
    if (locations.isNotEmpty) {
      //debugger();
      print("debuggerdebuggerdebugger 8888");

      selectedLocation = locations.first;
      debugPrint('Selected location: ${selectedLocation?.displayName}');
    } else {
      // No locations found, create a US location
      debugPrint('No locations found. Creating a US location...');
      await createUSLocation();
    }

    if (selectedLocation == null) {
      throw AssertionError('Please create location on stripe dashboard to proceed further!');
    }
  }

  /// Create a US location if none exists
  static Future<void> createUSLocation() async {
    //debugger();
    print("debuggerdebuggerdebugger 99999");

    try {
      // Create a location in New York, USA
      final response = await http.post(
        Uri.parse("https://api.stripe.com/v1/terminal/locations"),
        headers: {
          'Authorization': 'Bearer ${EnvConfig.stripeSecret}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'display_name': 'Marker App - US Location',
          'address[line1]': '1234 Main St',
          'address[city]': 'New York',
          'address[state]': 'NY',
          'address[country]': 'US',
          'address[postal_code]': '10001',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        debugPrint('✅ US Location created successfully: $jsonResponse');

        // Extract location details
        final locationId = jsonResponse['id'];
        final displayName = jsonResponse['display_name'];
        final address = jsonResponse['address'];

        // Print latitude and longitude
        debugPrint('📍 Location ID: $locationId');
        debugPrint('📍 Display Name: $displayName');
        debugPrint('📍 Address: $address');
        debugPrint('📍 Latitude: ${address['latitude']}');
        debugPrint('📍 Longitude: ${address['longitude']}');

        // Fetch locations again to get the created location
        final locations = await Terminal.instance.listLocations();
        // _locations = locations;
        if (locations.isNotEmpty) {
          selectedLocation = locations.first;
          debugPrint('Selected location after creation: ${selectedLocation?.displayName}');
        }
      } else {
        debugPrint('❌ Failed to create location: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to create US location: ${response.body}');
      }
    } catch (e) {
      print("dismiss 22222");
      errorShow('❌ Error creating US location: $e');
      throw e;
    }
  }

  /// Start discovering available readers
  static void startDiscoverReaders(Terminal? terminal) {
    //debugger();
    print("debuggerdebuggerdebugger 10 10 10 10");

    try {
      readers.value = [];

      final discoverReaderStream = terminal?.discoverReaders(
        TapToPayDiscoveryConfiguration(
          isSimulated: isSimulated,
        ),
      );

      //debugger();
      print("debuggerdebuggerdebugger 11 11 11 11");

      discoverReaderSub = discoverReaderStream?.listen((foundReaders) {
        //debugger();
        print("debuggerdebuggerdebugger 12 12 12 12");

        readers.value = foundReaders;
        print("foundReadersfoundReadersfoundReadersfoundReaders ${foundReaders.length}");
        if (foundReaders.isNotEmpty) {
          connectReader(foundReaders.first);
        }
        debugPrint('Found ${foundReaders.length} readers');
      }, onDone: () {
        //debugger();
        print("debuggerdebuggerdebugger 13 13 13 13");

        discoverReaderSub = null;
        if (readers.isEmpty) {}
      });
    } catch (e) {
      print("_startDiscoverReaders_startDiscoverReaders Error is ${e}");
    }
  }

  /// Connect to a specific reader
  static Future<bool> connectReader(Reader reader) async {
    //debugger();
    print("debuggerdebuggerdebugger 14 14 14 14");

    try {
      await connectReaderSecond(Terminal.instance, reader);

      await collectPayment();

      return true;
    } catch (e) {
      print("dismiss 33333");
      errorShow('Failed to connect to reader: $e');
      return false;
    }
  }

  static Future<void> connectReaderSecond(Terminal terminal, Reader reader) async {
    //debugger();
    print("debuggerdebuggerdebugger 15 15 15 15 15");

    final connectedReaders = await tryConnectReader(terminal, reader);
    if (connectedReaders == null) {
      throw Exception("Error connecting to reader! Please try again");
    }
    readerUse = connectedReaders;
  }

  static Future<Reader?> tryConnectReader(Terminal terminal, Reader reader) async {
    //debugger();
    print("debuggerdebuggerdebugger 16 16 16 16");

    String? getLocationId() {
      final locationId = selectedLocation?.id ?? reader.locationId;
      if (locationId == null) throw AssertionError('Missing location');
      return locationId;
    }

    final locationId = getLocationId();
    debugPrint('Connecting to reader with location ID: $locationId');

    //debugger();
    print("debuggerdebuggerdebugger 17 17 17 17");

    return terminal.connectReader(
      reader,
      configuration: TapToPayConnectionConfiguration(
        locationId: locationId!,
        readerDelegate: null,
      ),
    );
  }

  static Future<void> collectPayment() async {
    //debugger();
    print("debuggerdebuggerdebugger 18 18 18 18 18");

    debugPrint('Starting payment collection...');

    // if (_reader == null) {
    //   errorShow('No reader connected. Please connect a reader first.');
    //   return;
    // }

    try {
      // Calculate total amount in cents
      var tempTip = tip;
      if (tempTip.isEmpty) {
        tempTip = '0';
      }
      final totalAmount = (double.tryParse('$price') ?? 0) + (double.tryParse(tempTip) ?? 0);

      // Create payment intent and collect payment
      await createPaymentIntent(Terminal.instance, totalAmount.toString());
    } catch (e) {
      errorShow('Error processing payment: $e');
    }
  }

  /// Create payment intent with Stripe Terminal
  static Future<bool> createPaymentIntent(Terminal terminal, String amount) async {
    //debugger();
    print("debuggerdebuggerdebugger 19 19 19 19 19");

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final userIdSuffix = userId.isNotEmpty && userId.length > 8 ? userId.substring(0, 8) : userId;
      transactionId = 'txn_${timestamp}_$userIdSuffix';
      final paymentIntent = await terminal.createPaymentIntent(
        PaymentIntentParameters(
            amount: (double.parse(double.parse(amount).toStringAsFixed(2)) * 100).ceil(),
            currency: "usd",
            captureMethod: CaptureMethod.automatic,
            paymentMethodTypes: [
              PaymentMethodType.cardPresent,
            ],
            metadata: {
              "projectName": 'TheMarkerAPP',
              'transactionId': transactionId,
              'barId': barId,
              'drinkId': drinkId,
              'ownerId': userId,
              'basePrice': price.toString(),
              'tip': tip.isEmpty ? '0' : tip,
              "hasTip": (tip.isEmpty || tip.trim() == '0') ? 'false' : 'true',
            }),
      );
      //debugger();
      print("debuggerdebuggerdebugger 20 20 20 20");

      paymentIntentUse = paymentIntent;

      if (paymentIntentUse == null) {
        errorShow('Payment intent is not created!');

        return false;
      }

      //debugger();
      print("debuggerdebuggerdebugger 21 21 21 21");

      return await collectPaymentMethod(terminal, paymentIntentUse!);
    } catch (e) {
      errorShow('Error creating payment intent: $e');

      return false;
    }
  }

  /// Collect payment method from customer
  static Future<bool> collectPaymentMethod(Terminal terminal, PaymentIntent paymentIntent) async {
    //debugger();
    print("debuggerdebuggerdebugger 22 22 22 22");

    try {
      final collectingPaymentMethod = terminal.collectPaymentMethod(
        paymentIntent,
        skipTipping: true,
      );
      collectingPaymentMethodUse = collectingPaymentMethod;

      final paymentIntentWithPaymentMethod = await collectingPaymentMethod;
      paymentIntentUse = paymentIntentWithPaymentMethod;
      //debugger();
      print("debuggerdebuggerdebugger 23 23 23 23");

      await confirmPaymentIntent(terminal, paymentIntentUse!);
      return true;
    } on TerminalException catch (exception) {
      switch (exception.code) {
        case TerminalExceptionCode.canceled:
          errorShow('Payment cancelled!');

          return false;
        default:
          errorShow('Payment error: ${exception.message}');

          return false;
      }
    } catch (e) {
      errorShow('Error collecting payment: $e');

      return false;
    }
  }

  /// Confirm and process the payment
  static Future<void> confirmPaymentIntent(Terminal terminal, PaymentIntent paymentIntent) async {
    //debugger();
    print("debuggerdebuggerdebugger 24 24 24 24 ");

    try {
      final processedPaymentIntent = await terminal.confirmPaymentIntent(paymentIntent);
      paymentIntentUse = processedPaymentIntent;
      print('_paymentIntet_paymentIntent ${paymentIntentUse?.metadata}');
      Loading.dismiss();
    } catch (e) {
      errorShow('Payment confirmation failed: $e');

      throw e;
    }
  }
}
