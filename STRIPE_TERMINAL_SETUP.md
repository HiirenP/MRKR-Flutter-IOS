# Stripe Terminal (Tap-to-Pay) Integration Guide

## Overview

This guide explains the complete Stripe Terminal integration that has been implemented in your Flutter app for tap-to-pay functionality.

## What Was Implemented

### 1. **PaymentsController** (`lib/app/controllers/member_main/home/payments_controller.dart`)

The controller now includes complete Stripe Terminal functionality:

#### Key Features:
- **Permission Management**: Requests location and Bluetooth permissions for terminal access
- **Terminal Initialization**: Sets up Stripe Terminal with connection token
- **Reader Discovery**: Discovers available payment readers (physical or simulated)
- **Reader Connection**: Connects to selected readers
- **Payment Processing**: Creates payment intents, collects payment methods, and confirms payments
- **Real-time Status Updates**: Provides reactive status updates throughout the payment flow

#### Key Methods:
- `requestPermissions()` - Requests necessary device permissions
- `getConnectionToken()` - Retrieves Stripe connection token
- `initTerminal()` - Initializes the Stripe Terminal SDK
- `connectReader(Reader)` - Connects to a specific reader
- `collectPayment(BuildContext)` - Processes the payment
- `cancelPaymentCollection()` - Cancels ongoing payment collection

## Setup Instructions

### Step 1: Create .env File

1. Copy `.env.example` to `.env`:
   ```bash
   copy .env.example .env
   ```

2. Edit `.env` and add your Stripe secret key:
   ```env
   STRIPE_SECRET=sk_test_your_actual_stripe_secret_key_here
   ```

   **Important**: 
   - Get your secret key from: https://dashboard.stripe.com/apikeys
   - Never commit the `.env` file to version control
   - Use test keys during development

### Step 2: Configure Stripe Dashboard

1. **Enable Tap-to-Pay**:
   - Log in to your Stripe Dashboard
   - Navigate to Terminal → Settings
   - Enable "Tap to Pay on Android/iOS"

2. **Create Locations**:
   - Go to Terminal → Locations
   - Create at least one location
   - Make sure the location is in a country where Stripe Tap-to-Pay is available
   - Supported countries: US, UK, Canada, Australia, and more (check Stripe docs)

### Step 3: Configure Android Permissions

Edit `android/app/src/main/AndroidManifest.xml` and ensure these permissions are present:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### Step 4: Testing Configuration

In `payments_controller.dart`, line 75:

```dart
final bool _isSimulated = true;  // Set to true for testing
```

- **For testing**: Set `_isSimulated = true` to use the Stripe simulator
- **For production**: Set `_isSimulated = false` to use real devices

## Usage Flow

### 1. User Journey

1. User navigates to Payment Page
2. User taps on "NFC" option
3. System requests permissions (if not granted)
4. System initializes Stripe Terminal
5. System discovers available readers
6. User selects a reader (or auto-connects)
7. User taps "Accept Payment"
8. System creates payment intent
9. System prompts for card tap/insert
10. Customer taps their card
11. Payment is processed and confirmed
12. Success screen is displayed

### 2. Code Usage Example

The NFC payment is triggered from the Payment Page:

```dart
GestureDetector(
  onTap: () => controller.showNFCSheet(context: context),
  child: Container(
    // NFC payment option UI
  ),
)
```

### 3. Status Monitoring

The controller provides reactive status updates:

```dart
// Payment status
Obx(() => Text(controller.paymentStatus.value))

// Processing indicator
Obx(() => controller.isProcessing.value 
    ? CircularProgressIndicator() 
    : SizedBox.shrink())

// Reader scan status
Obx(() => Text(controller.scanStatus.value))
```

## Important Considerations

### Currency Support

The implementation uses USD by default (line 338):

```dart
currency: "usd",
```

**To change currency**:
- Modify the currency code in `_createPaymentIntent()` method
- Ensure the currency is supported in your Stripe location
- Check Stripe's currency support: https://stripe.com/docs/currencies

### Amount Calculation

Amounts are automatically calculated in cents:

```dart
amount: (double.parse(double.parse(amount).toStringAsFixed(2)) * 100).ceil(),
```

This ensures proper formatting for Stripe's API (which expects amounts in smallest currency unit).

### Error Handling

The implementation includes comprehensive error handling:
- Permission denials
- Connection failures
- Payment cancellations
- Terminal exceptions
- Network errors

### Testing with Simulator

When `_isSimulated = true`:
- No physical hardware required
- Stripe provides a test interface
- You can simulate various card scenarios
- Perfect for development and testing

### Production Considerations

Before going to production:

1. **Set simulation to false**:
   ```dart
   final bool _isSimulated = false;
   ```

2. **Use live Stripe keys**:
   ```env
   STRIPE_SECRET=sk_live_your_live_key_here
   ```

3. **Test on real devices** with actual payment readers

4. **Handle edge cases**:
   - Poor network connectivity
   - Bluetooth connectivity issues
   - Reader battery issues
   - Payment timeouts

## State Management

The controller uses GetX for reactive state management:

- `paymentStatus` - Current payment operation status
- `isProcessing` - Whether a payment is being processed
- `scanStatus` - Reader discovery status
- `isScanning` - Whether readers are being discovered
- `isPaymentSuccessful` - Payment completion state

## Architecture

```
PaymentPage (UI)
    ↓
PaymentsController (Business Logic)
    ↓
Stripe Terminal SDK
    ↓
Stripe API
```

## Troubleshooting

### Issue: "Terminal not initialized"
**Solution**: Ensure `initTerminal()` is called before attempting payments

### Issue: "No reader connected"
**Solution**: Call `connectReader()` after discovering readers

### Issue: "Permission denied"
**Solution**: Ensure all required permissions are granted in AndroidManifest.xml

### Issue: "Failed to get connection token"
**Solution**: 
- Check that `.env` file exists and contains valid `STRIPE_SECRET`
- Verify the secret key is correct
- Check network connectivity

### Issue: "No locations found"
**Solution**: Create at least one location in Stripe Dashboard → Terminal → Locations

## Security Notes

⚠️ **Important Security Considerations**:

1. **Never expose your Stripe secret key** in client-side code
2. The current implementation includes the secret key for demonstration
3. **For production**, move the `getConnectionToken()` logic to your backend API
4. Implement proper authentication for your backend API
5. Add `.env` to `.gitignore` to prevent committing secrets

### Recommended Production Architecture:

```
Flutter App → Your Backend API → Stripe API
```

Your backend should:
- Authenticate the user
- Generate the connection token
- Return it to the Flutter app
- Never expose the secret key

## Additional Resources

- [Stripe Terminal Documentation](https://stripe.com/docs/terminal)
- [mek_stripe_terminal Package](https://pub.dev/packages/mek_stripe_terminal)
- [Stripe API Reference](https://stripe.com/docs/api)
- [Tap to Pay Documentation](https://stripe.com/docs/terminal/payments/setup-reader/tap-to-pay)

## Support

For issues specific to:
- **Stripe Terminal**: Contact Stripe Support
- **mek_stripe_terminal package**: Visit the [GitHub repository](https://github.com/BreX900/mek-packages)
- **Your implementation**: Review this documentation and the code comments
