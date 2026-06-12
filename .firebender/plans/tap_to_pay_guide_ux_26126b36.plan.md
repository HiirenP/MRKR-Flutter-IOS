<!--firebender-plan
name: Tap to Pay Guide UX
overview: Update Tap to Pay guide points into tappable accordion items that reveal descriptive text and an image when expanded, while keeping localization-friendly strings.
todos:
  - id: refactor-guide-ui
    content: "Convert TapToPayGuide page tiles into tappable accordion items with expand/collapse behavior"
  - id: add-guide-descriptions
    content: "Add localized description keys for each Tap to Pay guide point in app_en.arb"
  - id: show-image-on-expand
    content: "Render existing tap_to_pay_image.png inside expanded accordion content with proper styling"
  - id: sync-l10n-generated
    content: "Update localization generated Dart files to expose the new description keys"
-->

# Tap to Pay Guide: Expandable Descriptions + Image

## Goal
`Tap to Pay Guide` screen ma existing points ne interactive banavvu:
- Point par tap karta description open/close thavu (accordion)
- Expanded state ma `tap_to_pay_image.png` show karvu

## Current State (quick context)
- [lib/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart) ma currently static `_GuideTile` only title show kare chhe.
- [lib/l10n/app_en.arb](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/l10n/app_en.arb) ma title strings available chhe, pan per-point description strings nathi.
- Image already available via generated assets API (`Assets.images.png.tapToPayImage`) in [lib/gen/assets.gen.dart](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/gen/assets.gen.dart).

## Implementation Plan
1. `tap_to_pay_guide_page.dart` ma list UI ne stateful accordion structure ma convert karvu (single-expand or multi-expand, default: single-expand for cleaner UX).
2. Existing 3 guide points mate description text localization keys add karva in `app_en.arb`.
3. Expanded tile content ma:
   - Description text
   - Reused `Assets.images.png.tapToPayImage` with proper sizing and rounded corners
4. Current theme/style follow karvu (existing `context.colorScheme`, spacing helpers, `AppText`).
5. L10n generated files sync karva (if project flow requires): `app_localizations.dart` and `app_localizations_en.dart`.

## Files to Update
- [lib/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/app/ui/pages/member_main/home/tap_to_pay_guide_page.dart)
- [lib/l10n/app_en.arb](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/l10n/app_en.arb)
- [lib/l10n/app_localizations.dart](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/l10n/app_localizations.dart) *(generated)*
- [lib/l10n/app_localizations_en.dart](/Users/nikunj/StudioProjects/MarkerAll/Final/marker_flutter/lib/l10n/app_localizations_en.dart) *(generated)*

## Notes
- Existing static item line pattern (current state):
  - `_GuideTile(title: AppStrings.T.howToAcceptCards)` etc.
- This will be replaced by data-driven tappable guide items with title + description + optional image block in expanded view.
