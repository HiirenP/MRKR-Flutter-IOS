<!--firebender-plan
name: tap-to-pay enable flow
overview: Show an iOS-style “Enable Now” screen before `initTerminal()` runs, then continue payment immediately after enable is completed, with `Learn More` opening the guide page.
todos:
  - id: wire-enable-check-before-init
    content: "Gate NFC init in payments controller and continue init immediately after successful enable."
  - id: redesign-enable-page
    content: "Implement iOS-style Enable Now UI layout with primary and secondary actions."
  - id: wire-learn-more
    content: "Connect Learn More action to tap-to-pay guide flow."
  - id: localization-update-if-needed
    content: "Add/adjust localization entries required by the new button/text copy."
  - id: validate-flow
    content: "Verify first-time and repeat tap-to-pay behavior paths conceptually and with code checks."
-->

# Tap to Pay Enable-First Flow

## What I found
- `initTerminal()` is currently called directly in [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/controllers/member_main/home/payments_controller.dart`] inside `infoSheet()` at the NFC branch (around lines 232-233).
- A tap-to-pay enable screen already exists at [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart`], but it is checklist-style and does not match the iOS modal style from your image.
- SharedPrefs flags already exist in [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/utils/helpers/extensions/extensions.dart`]: `getTapToPayEnabled`, `setTapToPayEnabled`, etc.

## Planned changes
- Update NFC flow in [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/controllers/member_main/home/payments_controller.dart`]:
  - Before `StripTerminalController.initTerminal()`, check `getTapToPayEnabled`.
  - If disabled, navigate to `TapToPayEnablePage` and wait for result.
  - If result is success (`true`), immediately continue with `Loading.show()` + `await StripTerminalController.initTerminal()`.
  - If cancelled/back, stop flow safely.
- Redesign [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart`] to match your screenshot style:
  - Prominent heading/subheading layout.
  - Center visual area (use available app widgets/styles; if no dedicated asset exists, use a clean fallback visual block).
  - Bottom actions:
    - Primary: `Enable Now` → set enabled flags and return success.
    - Secondary: `Learn More` → open `TapToPayGuidePage`.
- Add localization key(s) only if needed for exact copy (e.g., `Learn More`) in:
  - [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/l10n/app_en.arb`]
  - generated localization files if your repo keeps them committed.

## Validation
- Verify behavior manually from Payment page:
  - First NFC attempt (disabled): show new enable UI.
  - Tap `Enable Now`: returns and immediately starts terminal init/payment flow.
  - Tap `Learn More`: opens guide page.
  - Subsequent NFC attempts (already enabled): skip enable UI and go straight to init/payment.
