# 🔄 Reader Connection Flow Diagram

## Complete Payment Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Start Payment Flow                        │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│          showReaderSelectionSheet(context)                   │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  📱 Reader Selection Sheet                            │  │
│  │  ────────────────────────                             │  │
│  │  - Initialize Terminal (if needed)                    │  │
│  │  - Request Permissions                                │  │
│  │  - Start Scanning for Readers                         │  │
│  │  - Display Loading Indicator                          │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
               ┌──────────────────────┐
               │  Readers Discovered?  │
               └──────┬───────┬───────┘
                      │       │
                 No   │       │  Yes
                      │       │
        ┌─────────────┘       └─────────────┐
        ▼                                    ▼
┌──────────────────┐              ┌──────────────────────┐
│  No Readers UI   │              │  Reader List UI       │
│  ──────────────  │              │  ───────────────      │
│  "No readers     │              │  📟 Reader 1          │
│   found"         │              │  📟 Reader 2          │
│                  │              │  📟 Reader 3          │
│  [Retry Scan]    │              │  (Tap to connect)     │
└─────────┬────────┘              └──────────┬────────────┘
          │                                  │
          │ User taps "Retry"                │ User taps reader
          │                                  │
          └────────► retryDiscoverReaders() ◄┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   connectReader(reader)                      │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  🔄 Connecting Process                                │  │
│  │  ─────────────────────                                │  │
│  │  1. Show "Connecting..." status                       │  │
│  │  2. Call terminal.connectReader()                     │  │
│  │  3. Store connected reader in _reader                 │  │
│  │  4. Update scanStatus & paymentStatus                 │  │
│  │  5. Show success message                              │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
               ┌──────────────────────┐
               │  Connection Success?  │
               └──────┬───────┬───────┘
                      │       │
                 No   │       │  Yes
                      │       │
        ┌─────────────┘       └─────────────┐
        ▼                                    ▼
┌──────────────────┐              ┌──────────────────────────┐
│  Show Error      │              │  Close Selection Sheet   │
│  Stay on Sheet   │              │  Open Payment Sheet      │
└──────────────────┘              └─────────┬────────────────┘
                                            │
                                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    showNFCSheet(context)                     │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  💳 Payment Collection Sheet                          │  │
│  │  ───────────────────────                              │  │
│  │  ✅ Connected: [Reader Name]                          │  │
│  │  📡 NFC Icon (animated)                               │  │
│  │  📝 Payment Status Message                            │  │
│  │  ⏳ Processing Indicator (if active)                  │  │
│  │                                                        │  │
│  │  [Accept Payment]  [Cancel]                           │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼ User taps "Accept Payment"
┌─────────────────────────────────────────────────────────────┐
│                   collectPayment(context)                    │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  💰 Payment Processing                                │  │
│  │  ──────────────────                                   │  │
│  │  1. Calculate total amount                            │  │
│  │  2. Create payment intent                             │  │
│  │  3. Show "Tap or insert card..."                      │  │
│  │  4. Collect payment method                            │  │
│  │  5. Show "Processing payment..."                      │  │
│  │  6. Confirm payment intent                            │  │
│  │  7. Show success animation ✅                         │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
               ┌──────────────────────┐
               │   Payment Success?    │
               └──────┬───────┬───────┘
                      │       │
                 No   │       │  Yes
                      │       │
        ┌─────────────┘       └─────────────┐
        ▼                                    ▼
┌──────────────────┐              ┌──────────────────────┐
│  Show Error      │              │  Show Success        │
│  "Payment failed"│              │  Green Checkmark ✅  │
│  Stay on Sheet   │              │  Close Sheet         │
└──────────────────┘              │  Show Marker Dialog  │
                                  └──────────────────────┘
```

## 🔑 Key Points

### 1. **Entry Point**
```dart
showReaderSelectionSheet(context: context)
```
- This is the ONLY method you need to call to start the flow
- Everything else happens automatically

### 2. **Reader Connection**
```dart
connectReader(reader)  // Called when user taps a reader
```
- Automatically triggered by user selection
- Returns bool for success/failure
- Updates all status variables

### 3. **Payment Collection**
```dart
collectPayment(context)  // Called when user taps "Accept Payment"
```
- Only works if reader is connected
- Handles full payment lifecycle
- Shows real-time status updates

## 🎨 UI States

### Reader Selection Sheet States
1. **Scanning** - Shows loading spinner
2. **Readers Found** - Shows list of readers
3. **No Readers** - Shows retry button
4. **Connecting** - Shows connection progress

### Payment Sheet States
1. **Ready** - Shows NFC icon, ready for payment
2. **Processing** - Shows progress indicator
3. **Success** - Shows green checkmark animation
4. **Error** - Shows error message

## 🔄 Observable Updates

Throughout the flow, these observables are updated:

```dart
readers.value          // List of discovered readers
isScanning.value       // true/false
scanStatus.value       // "Searching...", "Connected", etc.
paymentStatus.value    // "Ready", "Processing...", etc.
isProcessing.value     // true/false
_reader                // Currently connected reader
```

## ✅ Success Criteria

A successful flow requires:
1. ✅ Terminal initialized
2. ✅ Permissions granted
3. ✅ Reader discovered
4. ✅ Reader connected
5. ✅ Payment collected
6. ✅ Payment confirmed

## 🚨 Error Handling

Errors are handled at each step:
- **Terminal Init Error** → Show error, don't open sheet
- **No Permissions** → Show permission denied error
- **No Readers** → Show retry option
- **Connection Failed** → Show error, stay on selection
- **Payment Failed** → Show error, stay on payment sheet
- **User Cancelled** → Close sheet, no error

## 📱 Example Call from UI

```dart
// From any page/widget
final controller = Get.find<PaymentsController>();

// Set payment details
controller.barId = 'bar_123';
controller.drinkId = 'drink_456';
controller.price = 1500;  // $15.00
controller.tip = '300';   // $3.00

// Start the flow (one line!)
await controller.showReaderSelectionSheet(context: context);

// That's it! Everything else is automatic
```

## 🎯 Testing Scenarios

1. **Happy Path**: Terminal → Scan → Select → Connect → Pay → Success
2. **No Readers**: Terminal → Scan → No readers → Retry → Select → Connect
3. **Connection Fails**: Terminal → Scan → Select → Connection Error → Retry
4. **Payment Cancelled**: Terminal → ... → Connected → Cancel Payment
5. **Payment Failed**: Terminal → ... → Payment → Card Declined → Error

---

**Remember**: Always call `showReaderSelectionSheet()` as your entry point!
