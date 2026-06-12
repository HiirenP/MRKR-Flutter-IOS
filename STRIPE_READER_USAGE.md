# Stripe Terminal - Reader Connection Guide

## 🎯 Overview
This guide explains how to use the new `connectReader` implementation for Stripe Terminal payments.

## 📱 User Flow

### 1. **Show Reader Selection Sheet**
```dart
// Call this method to start the payment flow
await paymentsController.showReaderSelectionSheet(context: context);
```

This will:
- ✅ Initialize Stripe Terminal (if not already initialized)
- ✅ Request necessary permissions (Location, Bluetooth)
- ✅ Start scanning for available readers
- ✅ Display a list of found readers

### 2. **User Selects a Reader**
- Users will see all available readers in a list
- Each reader shows:
  - Reader name/label
  - Device type
  - Tap icon for easy identification

### 3. **Automatic Connection**
When user taps a reader:
```dart
await connectReader(reader);
```

This will:
- ✅ Connect to the selected reader
- ✅ Show connection status
- ✅ Display success/error messages
- ✅ Automatically proceed to payment sheet if successful

### 4. **Payment Collection**
After successful connection, the NFC payment sheet shows:
- Connected reader information
- NFC icon for tap-to-pay
- "Accept Payment" button
- Real-time payment status

```dart
await collectPayment(context);
```

### 5. **Process Payment**
The payment flows through:
1. Create payment intent
2. Collect payment method (tap card)
3. Confirm payment
4. Show success animation

## 🔧 Key Methods

### `showReaderSelectionSheet()`
**Purpose**: Entry point for starting payment flow  
**Shows**: Reader selection UI with scan status  
**Actions**: 
- Scan for readers
- Retry button if no readers found
- Connect to selected reader

### `connectReader(Reader reader)`
**Purpose**: Connect to a specific reader  
**Returns**: `Future<bool>` - true if successful  
**Updates**: 
- `_reader` - stores connected reader
- `scanStatus` - connection status messages
- `paymentStatus` - ready state

### `retryDiscoverReaders()`
**Purpose**: Rescan for readers if none found  
**Usage**: Called automatically by "Retry Scan" button

### `showNFCSheet()`
**Purpose**: Show payment collection UI  
**Requires**: Reader must be connected first  
**Shows**: NFC icon, payment status, cancel option

### `disconnectReader()`
**Purpose**: Disconnect current reader  
**When**: Called automatically in `paymentDismiss()`

## 📊 Observable Variables

```dart
final readers = <Reader>[].obs;           // List of discovered readers
final scanStatus = 'Ready to scan'.obs;   // Scan status message
final isScanning = false.obs;             // Scanning state
final paymentStatus = 'Ready'.obs;        // Payment status
final isProcessing = false.obs;           // Processing state
final isPaymentSuccessful = false.obs;    // Success animation trigger
```

## 🎨 UI Features

### Reader Selection Sheet
- ✅ Real-time scanning status
- ✅ Loading indicator while scanning
- ✅ Beautiful reader list with icons
- ✅ "No readers found" state
- ✅ Retry scan button
- ✅ Cancel option

### Payment Collection Sheet
- ✅ Connected reader badge
- ✅ Animated NFC icon
- ✅ Real-time payment status
- ✅ Processing indicator
- ✅ Success animation (green checkmark)
- ✅ Cancel payment option

## 🔄 Complete Example Usage

```dart
// In your UI (e.g., payment page)
ElevatedButton(
  onPressed: () async {
    final controller = Get.find<PaymentsController>();
    
    // Set payment details
    controller.barId = 'bar123';
    controller.drinkId = 'drink456';
    controller.price = 1500; // $15.00 in cents
    controller.tip = '300';  // $3.00 in cents
    
    // Start the flow - this handles everything!
    await controller.showReaderSelectionSheet(context: context);
  },
  child: Text('Pay with Tap to Pay'),
)
```

## ⚙️ Configuration

### Simulated vs Production Mode
```dart
// In payments_controller.dart
final bool _isSimulated = true;  // Change to false for production
```

- **Simulated mode**: For testing without physical readers
- **Production mode**: For real card transactions

### Required Permissions
The controller automatically requests:
- ✅ Location (When in Use)
- ✅ Bluetooth
- ✅ Bluetooth Scan (Android)
- ✅ Bluetooth Connect (Android)

## 🛠️ Error Handling

All methods include comprehensive error handling:
- Terminal not initialized
- Permission denied
- No readers found
- Connection failures
- Payment errors
- Cancellations

Errors are displayed via:
```dart
showError('Error message');   // Red snackbar
showSuccess('Success message'); // Green snackbar
```

## 🧹 Cleanup

The controller automatically cleans up when dismissed:
```dart
paymentDismiss() {
  // Disconnects reader
  // Cancels subscriptions
  // Clears reader list
  // Resets state
}
```

## 🎯 Testing Checklist

- [ ] Terminal initializes successfully
- [ ] Permissions are requested and granted
- [ ] Readers are discovered and displayed
- [ ] Retry scan works when no readers found
- [ ] Reader connects successfully when tapped
- [ ] Connected reader info shows in payment sheet
- [ ] Payment can be collected
- [ ] Cancel works during payment
- [ ] Success animation shows after payment
- [ ] Cleanup works on dismiss
- [ ] Error messages display correctly

## 📞 Support

For issues with:
- **Stripe Terminal**: Check `STRIPE_TERMINAL_SETUP.md`
- **API Configuration**: Check `STRIPE_QUICK_START.md`
- **Code Issues**: Check debug logs in console

## 🚀 Next Steps

1. Test in simulated mode
2. Verify all UI states
3. Test error scenarios
4. Switch to production mode
5. Test with real card reader
6. Deploy to production

---

**Note**: Always test thoroughly in simulated mode before using real payment cards!
