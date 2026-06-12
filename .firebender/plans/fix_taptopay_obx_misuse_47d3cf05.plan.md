<!--firebender-plan
name: Fix TapToPay Obx misuse
overview: Create a focused fix plan for the GetX runtime error by removing conditional non-reactive usage inside `Obx` in the Tap to Pay enable bottom sheet.
todos:
  - id: refactor-obx-scope
    content: "Split button UI into reactive and non-reactive branches so `Obx` always reads an Rx value."
  - id: preserve-current-flow
    content: "Ensure labels, toggle behavior, and `_enableNow()` semantics remain unchanged."
  - id: validate-runtime
    content: "Verify no GetX misuse warning appears and behavior matches both enabled/disabled states."
-->

# Fix GetX Obx Misuse in TapToPay Enable Sheet

## Findings
- The crash points to `Obx` in [`/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart`](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart) around line 131.
- In that `Obx` builder, `_isChecked.value` is only read when `getTapToPayEnabled` is `false`; when it is `true`, no Rx is accessed, which triggers GetX's “improper use of a GetX” runtime error.

## Implementation Plan
- Refactor button rendering in [`tap_to_pay_enable_page.dart`](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_enable_page.dart) to avoid a mixed reactive/non-reactive `Obx` block:
  - Render a non-reactive always-enabled button path when Tap to Pay is already enabled.
  - Render an `Obx`-driven button path only for the pre-enable flow where `_isChecked.value` controls enabled state.
- Keep existing behavior for labels (`Enable now` / `Disable now`) and `_enableNow()` logic unchanged.
- Re-run analyzer/lints for the edited file and verify the runtime warning no longer appears when opening this sheet on iOS.

## Verification
- Launch app and open the Tap to Pay enable sheet in both states:
  - Tap to Pay disabled: checkbox toggles button enabled state.
  - Tap to Pay enabled: button renders without `Obx` misuse warning.
- Confirm no GetX “improper use” exception from this widget.
