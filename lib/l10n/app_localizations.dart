import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @continueW.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueW;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @approval.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get approval;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @getDetails.
  ///
  /// In en, this message translates to:
  /// **'Get Details'**
  String get getDetails;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @makePayment.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get makePayment;

  /// No description provided for @beerSummary.
  ///
  /// In en, this message translates to:
  /// **'Beer Summary'**
  String get beerSummary;

  /// No description provided for @barReview.
  ///
  /// In en, this message translates to:
  /// **'Bar Review'**
  String get barReview;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @currentAddress.
  ///
  /// In en, this message translates to:
  /// **'CURRENT ADDRESS'**
  String get currentAddress;

  /// No description provided for @tip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get tip;

  /// No description provided for @enterTipAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Tip Amount'**
  String get enterTipAmount;

  /// No description provided for @tipAmount.
  ///
  /// In en, this message translates to:
  /// **'Tip Amount: {tipAmounts}'**
  String tipAmount(String tipAmounts);

  /// No description provided for @wouldTip.
  ///
  /// In en, this message translates to:
  /// **'Would you like to give a tip for this bar?'**
  String get wouldTip;

  /// No description provided for @profileType.
  ///
  /// In en, this message translates to:
  /// **'Profile Type'**
  String get profileType;

  /// No description provided for @selectAProfile.
  ///
  /// In en, this message translates to:
  /// **'Select a profile type to continue.'**
  String get selectAProfile;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @friendInvite.
  ///
  /// In en, this message translates to:
  /// **'Friend Invite'**
  String get friendInvite;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @redeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// No description provided for @markers.
  ///
  /// In en, this message translates to:
  /// **'Markers'**
  String get markers;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @enterMarkerCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Marker Code'**
  String get enterMarkerCode;

  /// No description provided for @markerCode.
  ///
  /// In en, this message translates to:
  /// **'Marker Code'**
  String get markerCode;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @viaMarkerCode.
  ///
  /// In en, this message translates to:
  /// **'Via Marker Code'**
  String get viaMarkerCode;

  /// No description provided for @barOwner.
  ///
  /// In en, this message translates to:
  /// **'Bar Owner'**
  String get barOwner;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue.'**
  String get pleaseLogin;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @registerRedirect.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get registerRedirect;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @writeMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a Message'**
  String get writeMessage;

  /// No description provided for @enterYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your details below to continue'**
  String get enterYourDetails;

  /// No description provided for @barProfile.
  ///
  /// In en, this message translates to:
  /// **'Bar Profile'**
  String get barProfile;

  /// No description provided for @addDrink.
  ///
  /// In en, this message translates to:
  /// **'Add Drink'**
  String get addDrink;

  /// No description provided for @enterDrinkName.
  ///
  /// In en, this message translates to:
  /// **'Enter Drink Name'**
  String get enterDrinkName;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter Price'**
  String get enterPrice;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enterDescription;

  /// No description provided for @editDrink.
  ///
  /// In en, this message translates to:
  /// **'Edit Drink'**
  String get editDrink;

  /// No description provided for @deleteDrink.
  ///
  /// In en, this message translates to:
  /// **'Delete Drink'**
  String get deleteDrink;

  /// No description provided for @areYouSureDeleteDrink.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this drink detail?'**
  String get areYouSureDeleteDrink;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @addAvailability.
  ///
  /// In en, this message translates to:
  /// **'Add Availability'**
  String get addAvailability;

  /// No description provided for @editAvailability.
  ///
  /// In en, this message translates to:
  /// **'Edit Availability'**
  String get editAvailability;

  /// No description provided for @blockOff.
  ///
  /// In en, this message translates to:
  /// **'Block Off'**
  String get blockOff;

  /// No description provided for @daysOpen.
  ///
  /// In en, this message translates to:
  /// **'Days Open'**
  String get daysOpen;

  /// No description provided for @specificDayOff.
  ///
  /// In en, this message translates to:
  /// **'Specific Day Off'**
  String get specificDayOff;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get vacation;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @editBarProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Bar Profile'**
  String get editBarProfile;

  /// No description provided for @noWorries.
  ///
  /// In en, this message translates to:
  /// **'No worries, we\'ll help you to reset your password.'**
  String get noWorries;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @dontReceive.
  ///
  /// In en, this message translates to:
  /// **'Didn’t receive a code?'**
  String get dontReceive;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @yourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account. `Make sure it\'s strong and easy to remember'**
  String get yourNewPassword;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPasswordLabel;

  /// No description provided for @pleaseCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Please create your account to continue.'**
  String get pleaseCreateAccount;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @chooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose Gender'**
  String get chooseGender;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Address'**
  String get enterAddress;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose Country'**
  String get chooseCountry;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @iAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to '**
  String get iAgreeTo;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// No description provided for @yourProfileCreated.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been created successfully.'**
  String get yourProfileCreated;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @chooseUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload photo.'**
  String get chooseUploadPhoto;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @provideYourPersonal.
  ///
  /// In en, this message translates to:
  /// **'Provide your personal information below.'**
  String get provideYourPersonal;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @ownerProfile.
  ///
  /// In en, this message translates to:
  /// **'Owner Profile'**
  String get ownerProfile;

  /// No description provided for @addDrinks.
  ///
  /// In en, this message translates to:
  /// **'Add Drinks'**
  String get addDrinks;

  /// No description provided for @provideBarDetails.
  ///
  /// In en, this message translates to:
  /// **'Provide your bar details below.'**
  String get provideBarDetails;

  /// No description provided for @provideDrinkDetails.
  ///
  /// In en, this message translates to:
  /// **'Provide details of the drinks you serve.'**
  String get provideDrinkDetails;

  /// No description provided for @enterBarName.
  ///
  /// In en, this message translates to:
  /// **'Enter Bar Name'**
  String get enterBarName;

  /// No description provided for @selectOpeningHours.
  ///
  /// In en, this message translates to:
  /// **'Select Opening Hours'**
  String get selectOpeningHours;

  /// No description provided for @uploadBarPhotos.
  ///
  /// In en, this message translates to:
  /// **'Upload Bar Photos'**
  String get uploadBarPhotos;

  /// No description provided for @uploadBarLogo.
  ///
  /// In en, this message translates to:
  /// **'Upload Bar Logo'**
  String get uploadBarLogo;

  /// No description provided for @uploadDrink.
  ///
  /// In en, this message translates to:
  /// **'Upload Drink Photo'**
  String get uploadDrink;

  /// No description provided for @uploadBankFront.
  ///
  /// In en, this message translates to:
  /// **'Bank Card Front Photo'**
  String get uploadBankFront;

  /// No description provided for @uploadBankBack.
  ///
  /// In en, this message translates to:
  /// **'Bank Card Back Photo'**
  String get uploadBankBack;

  /// No description provided for @chooseBarLogo.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload bar logo.'**
  String get chooseBarLogo;

  /// No description provided for @chooseBarPhotos.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload bar photos.'**
  String get chooseBarPhotos;

  /// No description provided for @chooseBarDrink.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload drink photo.'**
  String get chooseBarDrink;

  /// No description provided for @chooseBankFront.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload  Bank card front photo.'**
  String get chooseBankFront;

  /// No description provided for @chooseBankBack.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to upload  Bank card back photo.'**
  String get chooseBankBack;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @addBank.
  ///
  /// In en, this message translates to:
  /// **'Add Bank'**
  String get addBank;

  /// No description provided for @enterDOB.
  ///
  /// In en, this message translates to:
  /// **'Select Date of Birth'**
  String get enterDOB;

  /// No description provided for @enterIdentityNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Identity Number'**
  String get enterIdentityNumber;

  /// No description provided for @enterPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Postal Code'**
  String get enterPostalCode;

  /// No description provided for @selectExternalAccount.
  ///
  /// In en, this message translates to:
  /// **'Select External Account Count'**
  String get selectExternalAccount;

  /// No description provided for @enterExternalAccountCurrency.
  ///
  /// In en, this message translates to:
  /// **'Enter External Account Currency'**
  String get enterExternalAccountCurrency;

  /// No description provided for @enterBankAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Bank Account Number'**
  String get enterBankAccountNumber;

  /// No description provided for @enterRoutingNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Routing Number'**
  String get enterRoutingNumber;

  /// No description provided for @uploadFrontImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Front Image'**
  String get uploadFrontImage;

  /// No description provided for @uploadBackImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Back Image'**
  String get uploadBackImage;

  /// No description provided for @yourPaymentBankAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your payment bank added successfully.'**
  String get yourPaymentBankAddedSuccess;

  /// No description provided for @upcomingMarker.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Marker'**
  String get upcomingMarker;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @nearBy.
  ///
  /// In en, this message translates to:
  /// **'Near By'**
  String get nearBy;

  /// No description provided for @markerRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Marker Redeemed!'**
  String get markerRedeemed;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rateYourExperience;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReview;

  /// No description provided for @allDone.
  ///
  /// In en, this message translates to:
  /// **'All Done'**
  String get allDone;

  /// No description provided for @thankYouSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Thank you for submitting your review. Would you like to share this beer on your social media?'**
  String get thankYouSubmitting;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get drinks;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get review;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @nfc.
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get nfc;

  /// No description provided for @payPal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get payPal;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @yourPasswordSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully.'**
  String get yourPasswordSuccessfully;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @secure1.
  ///
  /// In en, this message translates to:
  /// **'Secure, 1-click checkout with Link'**
  String get secure1;

  /// No description provided for @enterCardHolder.
  ///
  /// In en, this message translates to:
  /// **'Enter Card Holder Name'**
  String get enterCardHolder;

  /// No description provided for @enterCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Card Number'**
  String get enterCardNumber;

  /// No description provided for @mMYY.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get mMYY;

  /// No description provided for @cVC.
  ///
  /// In en, this message translates to:
  /// **'CVC'**
  String get cVC;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @chooseExpiry.
  ///
  /// In en, this message translates to:
  /// **'Choose Expiry'**
  String get chooseExpiry;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @totalTips.
  ///
  /// In en, this message translates to:
  /// **'Total tips'**
  String get totalTips;

  /// No description provided for @tipsByManager.
  ///
  /// In en, this message translates to:
  /// **'Tips by bartender'**
  String get tipsByManager;

  /// No description provided for @yourTips.
  ///
  /// In en, this message translates to:
  /// **'Your tips'**
  String get yourTips;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYears.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYears;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @n0.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get n0;

  /// No description provided for @n1.
  ///
  /// In en, this message translates to:
  /// **'10'**
  String get n1;

  /// No description provided for @n2.
  ///
  /// In en, this message translates to:
  /// **'20'**
  String get n2;

  /// No description provided for @n3.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get n3;

  /// No description provided for @n4.
  ///
  /// In en, this message translates to:
  /// **'40'**
  String get n4;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @userActivity.
  ///
  /// In en, this message translates to:
  /// **'User Activity'**
  String get userActivity;

  /// No description provided for @totalMarkers.
  ///
  /// In en, this message translates to:
  /// **'Total Markers : '**
  String get totalMarkers;

  /// No description provided for @redeemedMarkers.
  ///
  /// In en, this message translates to:
  /// **'Redeemed Markers : '**
  String get redeemedMarkers;

  /// No description provided for @redemptionRates.
  ///
  /// In en, this message translates to:
  /// **'Redemption Rates'**
  String get redemptionRates;

  /// No description provided for @paymentDone.
  ///
  /// In en, this message translates to:
  /// **'Payment Done'**
  String get paymentDone;

  /// No description provided for @yourPayment.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been sent successfully.'**
  String get yourPayment;

  /// No description provided for @sendMarker.
  ///
  /// In en, this message translates to:
  /// **'Send Marker to Friend'**
  String get sendMarker;

  /// No description provided for @searchName.
  ///
  /// In en, this message translates to:
  /// **'Search name'**
  String get searchName;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type Message...'**
  String get typeMessage;

  /// No description provided for @searchForDrinks.
  ///
  /// In en, this message translates to:
  /// **'Search for drinks'**
  String get searchForDrinks;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter City'**
  String get enterCity;

  /// No description provided for @enterState.
  ///
  /// In en, this message translates to:
  /// **'Enter State'**
  String get enterState;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @beerDescription.
  ///
  /// In en, this message translates to:
  /// **'Beer Description'**
  String get beerDescription;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @clearSelectedChats.
  ///
  /// In en, this message translates to:
  /// **'Clear Selected'**
  String get clearSelectedChats;

  /// No description provided for @clearAllChats.
  ///
  /// In en, this message translates to:
  /// **'Clear All Chats'**
  String get clearAllChats;

  /// No description provided for @clearChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear chat history for the selected conversations? This only removes messages on your device.'**
  String get clearChatConfirm;

  /// No description provided for @clearAllChatsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear chat history for all conversations? This only removes messages on your device.'**
  String get clearAllChatsConfirm;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @withdrawHistory.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get withdrawHistory;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @editBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Bank Details'**
  String get editBankDetails;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your Balance'**
  String get yourBalance;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Hello World in description'**
  String get description;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @enterSubject.
  ///
  /// In en, this message translates to:
  /// **'Enter Subject'**
  String get enterSubject;

  /// No description provided for @frontImage.
  ///
  /// In en, this message translates to:
  /// **'Front Image'**
  String get frontImage;

  /// No description provided for @backImage.
  ///
  /// In en, this message translates to:
  /// **'Back Image'**
  String get backImage;

  /// No description provided for @routingNumber.
  ///
  /// In en, this message translates to:
  /// **'Routing Number'**
  String get routingNumber;

  /// No description provided for @bankAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Number'**
  String get bankAccountNumber;

  /// No description provided for @externalAccountCurrency.
  ///
  /// In en, this message translates to:
  /// **'External Account Currency'**
  String get externalAccountCurrency;

  /// No description provided for @externalAccountCountry.
  ///
  /// In en, this message translates to:
  /// **'External Account Country'**
  String get externalAccountCountry;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @identityNumber.
  ///
  /// In en, this message translates to:
  /// **'Identity Number'**
  String get identityNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @friendList.
  ///
  /// In en, this message translates to:
  /// **'Friend List'**
  String get friendList;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @searchByNameMobile.
  ///
  /// In en, this message translates to:
  /// **'Search by name or mobile number'**
  String get searchByNameMobile;

  /// No description provided for @areYouSureFriend.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this friend?'**
  String get areYouSureFriend;

  /// No description provided for @deleteFriend.
  ///
  /// In en, this message translates to:
  /// **'Delete Friend'**
  String get deleteFriend;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Current Password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get enterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @chooseReason.
  ///
  /// In en, this message translates to:
  /// **'Choose a Reason'**
  String get chooseReason;

  /// No description provided for @itSpam.
  ///
  /// In en, this message translates to:
  /// **'It\'s a Spam'**
  String get itSpam;

  /// No description provided for @privacyConcerns.
  ///
  /// In en, this message translates to:
  /// **'Privacy Concerns'**
  String get privacyConcerns;

  /// No description provided for @violenceThreats.
  ///
  /// In en, this message translates to:
  /// **'Violence Threats'**
  String get violenceThreats;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @writeReason.
  ///
  /// In en, this message translates to:
  /// **'Write a Reason'**
  String get writeReason;

  /// No description provided for @areYouDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get areYouDeleteAccount;

  /// No description provided for @youWillLose.
  ///
  /// In en, this message translates to:
  /// **'You will lose all your data and your account will not be recovered.'**
  String get youWillLose;

  /// No description provided for @areYouLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouLogout;

  /// No description provided for @falseInformation.
  ///
  /// In en, this message translates to:
  /// **'False Information'**
  String get falseInformation;

  /// No description provided for @locationServices.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServices;

  /// No description provided for @locationService.
  ///
  /// In en, this message translates to:
  /// **'Location services'**
  String get locationService;

  /// No description provided for @turnLocationService.
  ///
  /// In en, this message translates to:
  /// **'Turn on Location services'**
  String get turnLocationService;

  /// No description provided for @locationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location access helps us find the best bars around you. Grant permission to continue.'**
  String get locationAccess;

  /// No description provided for @locationPermissions.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissions;

  /// No description provided for @locationPermissionsPermanently.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied, we cannot request permissions.'**
  String get locationPermissionsPermanently;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get codeLabel;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @forgotPasswordRedirect.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordRedirect;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again'**
  String get loginFailed;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again'**
  String get registerFailed;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset email'**
  String get passwordResetFailed;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get passwordResetSuccess;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @codeVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code verification successful'**
  String get codeVerificationSuccess;

  /// No description provided for @codeVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Code verification failed'**
  String get codeVerificationFailed;

  /// No description provided for @emptyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a email address'**
  String get emptyEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @emptyPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get emptyPassword;

  /// No description provided for @emptyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get emptyName;

  /// No description provided for @reviewEnter.
  ///
  /// In en, this message translates to:
  /// **'Please enter drink review'**
  String get reviewEnter;

  /// No description provided for @enter6Digit.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit pincode'**
  String get enter6Digit;

  /// No description provided for @pleaseEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter pincode'**
  String get pleaseEnterPin;

  /// No description provided for @emptyLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get emptyLastName;

  /// No description provided for @emptyFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get emptyFirstName;

  /// No description provided for @emptyDob.
  ///
  /// In en, this message translates to:
  /// **'Please select date of birth'**
  String get emptyDob;

  /// No description provided for @emptyIdentifyNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter identity number'**
  String get emptyIdentifyNumber;

  /// No description provided for @emptyPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter postal code'**
  String get emptyPostalCode;

  /// No description provided for @emptyCurrencyAccount.
  ///
  /// In en, this message translates to:
  /// **'Please enter currency account'**
  String get emptyCurrencyAccount;

  /// No description provided for @emptyBankAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter bank account number'**
  String get emptyBankAccountNumber;

  /// No description provided for @emptyRoutingNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter routing number'**
  String get emptyRoutingNumber;

  /// No description provided for @routingNumberMust9.
  ///
  /// In en, this message translates to:
  /// **'Routing number must have 9 digits'**
  String get routingNumberMust9;

  /// No description provided for @emptyExternalAccount.
  ///
  /// In en, this message translates to:
  /// **'Please select external account country'**
  String get emptyExternalAccount;

  /// No description provided for @emptyAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full address'**
  String get emptyAddress;

  /// No description provided for @emptyAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get emptyAmount;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @pleaseSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Please select image'**
  String get pleaseSelectImage;

  /// No description provided for @pleaseSelectProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Please select profile image'**
  String get pleaseSelectProfileImage;

  /// No description provided for @pleaseSelectBarLogo.
  ///
  /// In en, this message translates to:
  /// **'Please select bar logo'**
  String get pleaseSelectBarLogo;

  /// No description provided for @pleaseSelectBarImage.
  ///
  /// In en, this message translates to:
  /// **'Please select at least 1 bar image'**
  String get pleaseSelectBarImage;

  /// No description provided for @pleaseSelectBankFront.
  ///
  /// In en, this message translates to:
  /// **'Please select bank card front photo'**
  String get pleaseSelectBankFront;

  /// No description provided for @pleaseSelectBankBack.
  ///
  /// In en, this message translates to:
  /// **'Please select bank card back photo'**
  String get pleaseSelectBankBack;

  /// No description provided for @emptyCountry.
  ///
  /// In en, this message translates to:
  /// **'Please select your country'**
  String get emptyCountry;

  /// No description provided for @emptyGender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get emptyGender;

  /// No description provided for @emptyPassOrLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a digit, and a special character.'**
  String get emptyPassOrLength;

  /// No description provided for @youMustAccept.
  ///
  /// In en, this message translates to:
  /// **'You must accept the Privacy Policy and Terms and Conditions'**
  String get youMustAccept;

  /// No description provided for @emptyPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get emptyPhoneNumber;

  /// No description provided for @emptyOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get emptyOTP;

  /// No description provided for @emptyConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter confirm password'**
  String get emptyConfirmPassword;

  /// No description provided for @emptyVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get emptyVerificationCode;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again later'**
  String get apiError;

  /// No description provided for @apiErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. Please try again later.'**
  String get apiErrorDescription;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme Demo'**
  String get theme;

  /// No description provided for @deletingYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for deleting your account.'**
  String get deletingYourAccount;

  /// No description provided for @pleaseSubject.
  ///
  /// In en, this message translates to:
  /// **'Please enter subject'**
  String get pleaseSubject;

  /// No description provided for @pleaseContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter message for contact'**
  String get pleaseContact;

  /// No description provided for @barName.
  ///
  /// In en, this message translates to:
  /// **'Please enter bar name'**
  String get barName;

  /// No description provided for @pleaseAddDrink.
  ///
  /// In en, this message translates to:
  /// **'Please add drink'**
  String get pleaseAddDrink;

  /// No description provided for @pleaseDrink.
  ///
  /// In en, this message translates to:
  /// **'Please enter drink name'**
  String get pleaseDrink;

  /// No description provided for @pleasePrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter drink price'**
  String get pleasePrice;

  /// No description provided for @pleaseDes.
  ///
  /// In en, this message translates to:
  /// **'Please enter drink description'**
  String get pleaseDes;

  /// No description provided for @openBarTime.
  ///
  /// In en, this message translates to:
  /// **'Please select open bar time '**
  String get openBarTime;

  /// No description provided for @closeBarTime.
  ///
  /// In en, this message translates to:
  /// **'Please select close bar time '**
  String get closeBarTime;

  /// No description provided for @pleasSelectOpening.
  ///
  /// In en, this message translates to:
  /// **'Please select opening hours'**
  String get pleasSelectOpening;

  /// No description provided for @pleasEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter bar city'**
  String get pleasEnterCity;

  /// No description provided for @pleasEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter bar state'**
  String get pleasEnterState;

  /// No description provided for @pleasEnterCityBank.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get pleasEnterCityBank;

  /// No description provided for @pleasEnterStateBank.
  ///
  /// In en, this message translates to:
  /// **'Please enter state'**
  String get pleasEnterStateBank;

  /// No description provided for @pleasUploadBar.
  ///
  /// In en, this message translates to:
  /// **'Please upload bar logo'**
  String get pleasUploadBar;

  /// No description provided for @pleasUploadBarPhotos.
  ///
  /// In en, this message translates to:
  /// **'Please upload bar photos'**
  String get pleasUploadBarPhotos;

  /// No description provided for @typeDeletingYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Please type reason for deleting your account.'**
  String get typeDeletingYourAccount;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get connectionTimeout;

  /// No description provided for @connectionTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Oops! It seems the connection timed out. Please check your internet connection and try again.'**
  String get connectionTimeoutDesc;

  /// No description provided for @sendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get sendTimeout;

  /// No description provided for @sendTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Oops! It seems the connection timed out. Please check your internet connection and try again.'**
  String get sendTimeoutDesc;

  /// No description provided for @receiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Data Reception Issue'**
  String get receiveTimeout;

  /// No description provided for @receiveTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Oops! We\'re having trouble receiving data right now. Please try again later.'**
  String get receiveTimeoutDesc;

  /// No description provided for @badCertificate.
  ///
  /// In en, this message translates to:
  /// **'Security Certificate Problem'**
  String get badCertificate;

  /// No description provided for @badCertificateDesc.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there\'s a problem with the security certificate. Please contact support for assistance.'**
  String get badCertificateDesc;

  /// No description provided for @badResponse.
  ///
  /// In en, this message translates to:
  /// **'Unexpected Server Response'**
  String get badResponse;

  /// No description provided for @badResponseDesc.
  ///
  /// In en, this message translates to:
  /// **'Oh no! We received an unexpected response from the server. Please try again later.'**
  String get badResponseDesc;

  /// No description provided for @cancelDesc.
  ///
  /// In en, this message translates to:
  /// **'Your request has been cancelled. Please try again.'**
  String get cancelDesc;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Issue'**
  String get connectionError;

  /// No description provided for @connectionErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'re having trouble connecting to the server. Please check your internet connection and try again.'**
  String get connectionErrorDesc;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknown;

  /// No description provided for @unknownDesc.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong. Please try again later.'**
  String get unknownDesc;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @code200.
  ///
  /// In en, this message translates to:
  /// **'The request was successful.'**
  String get code200;

  /// No description provided for @code201.
  ///
  /// In en, this message translates to:
  /// **'A new resource was created successfully.'**
  String get code201;

  /// No description provided for @code202.
  ///
  /// In en, this message translates to:
  /// **'The request was accepted for processing, but the processing has not been completed.'**
  String get code202;

  /// No description provided for @code301.
  ///
  /// In en, this message translates to:
  /// **'The resource has been permanently moved to a new location.'**
  String get code301;

  /// No description provided for @code302.
  ///
  /// In en, this message translates to:
  /// **'The resource has been temporarily moved to a new location.'**
  String get code302;

  /// No description provided for @code304.
  ///
  /// In en, this message translates to:
  /// **'The resource has not been modified since the last request.'**
  String get code304;

  /// No description provided for @code400.
  ///
  /// In en, this message translates to:
  /// **'The server could not understand the request due to malformed syntax.'**
  String get code400;

  /// No description provided for @code401.
  ///
  /// In en, this message translates to:
  /// **'The request requires user authentication.'**
  String get code401;

  /// No description provided for @code403.
  ///
  /// In en, this message translates to:
  /// **'The server understood the request, but refuses to fulfill it.'**
  String get code403;

  /// No description provided for @code404.
  ///
  /// In en, this message translates to:
  /// **'The requested resource could not be found.'**
  String get code404;

  /// No description provided for @code405.
  ///
  /// In en, this message translates to:
  /// **'The method specified in the request is not allowed for the requested resource.'**
  String get code405;

  /// No description provided for @code409.
  ///
  /// In en, this message translates to:
  /// **'The request could not be completed due to a conflict with the current state of the resource.'**
  String get code409;

  /// No description provided for @code500.
  ///
  /// In en, this message translates to:
  /// **'The server encountered an unexpected condition which prevented it from fulfilling the request.'**
  String get code500;

  /// No description provided for @code503.
  ///
  /// In en, this message translates to:
  /// **'The server is currently unable to handle the request.'**
  String get code503;

  /// No description provided for @transactionTitle.
  ///
  /// In en, this message translates to:
  /// **'No transaction history yet'**
  String get transactionTitle;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have notification'**
  String get notificationTitle;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven’t received any notifications. When something important happens, you’ll see it right here.'**
  String get notificationSubtitle;

  /// No description provided for @transactionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven’t made any transactions yet. Once you do, they’ll show up here for review.'**
  String get transactionSubtitle;

  /// No description provided for @withdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'No withdraw history yet'**
  String get withdrawTitle;

  /// No description provided for @drinkBarTitle.
  ///
  /// In en, this message translates to:
  /// **'No drinks added yet'**
  String get drinkBarTitle;

  /// No description provided for @drinkTitle.
  ///
  /// In en, this message translates to:
  /// **'No drinks found'**
  String get drinkTitle;

  /// No description provided for @drinkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or adding a new drink to your list.'**
  String get drinkSubtitle;

  /// No description provided for @nearByBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby bar not found'**
  String get nearByBarTitle;

  /// No description provided for @drinkReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here... yet.'**
  String get drinkReviewSubtitle;

  /// No description provided for @inefficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Inefficient balance'**
  String get inefficientBalance;

  /// No description provided for @upcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'No upcoming data'**
  String get upcomingTitle;

  /// No description provided for @redeemedTitle.
  ///
  /// In en, this message translates to:
  /// **'No redeemed data'**
  String get redeemedTitle;

  /// No description provided for @upcomingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There\'s nothing new to show right now. Check back later!'**
  String get upcomingSubtitle;

  /// No description provided for @drinkBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New drinks will appear here once added. Start building your menu and showcase your best offerings!'**
  String get drinkBarSubtitle;

  /// No description provided for @withdrawSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven’t made any withdrawals yet. Your transactions will appear here once available.'**
  String get withdrawSubtitle;

  /// No description provided for @noFriendsFound.
  ///
  /// In en, this message translates to:
  /// **'No friend found yet'**
  String get noFriendsFound;

  /// No description provided for @pleaseScanQr.
  ///
  /// In en, this message translates to:
  /// **'Please scan QR code'**
  String get pleaseScanQr;

  /// No description provided for @pleaseEnterMarker.
  ///
  /// In en, this message translates to:
  /// **'please enter marker code'**
  String get pleaseEnterMarker;

  /// No description provided for @pleaseWaitDo.
  ///
  /// In en, this message translates to:
  /// **'Please wait don\'t go back'**
  String get pleaseWaitDo;

  /// No description provided for @noChatFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No chat found yet'**
  String get noChatFoundTitle;

  /// No description provided for @requiredPermissionNotGrant.
  ///
  /// In en, this message translates to:
  /// **'Required permission not granted'**
  String get requiredPermissionNotGrant;

  /// No description provided for @requiredPermissionCGSMessage.
  ///
  /// In en, this message translates to:
  /// **'To provide the best experience, Marker app needs access to your Camera, Gallery, and Storage. This allows you to take photos, choose images, and store or retrieve files as needed.'**
  String get requiredPermissionCGSMessage;

  /// No description provided for @pleaseWaitForRemoteUser.
  ///
  /// In en, this message translates to:
  /// **'Please wait for remote user to join'**
  String get pleaseWaitForRemoteUser;

  /// No description provided for @bankUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bank details updated successfully'**
  String get bankUpdatedSuccess;

  /// No description provided for @validOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct OTP'**
  String get validOTP;

  /// No description provided for @ringing.
  ///
  /// In en, this message translates to:
  /// **'Ringing...'**
  String get ringing;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks'**
  String get noThanks;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionRequired;

  /// No description provided for @sendMarkerLabel.
  ///
  /// In en, this message translates to:
  /// **'Send Marker'**
  String get sendMarkerLabel;

  /// No description provided for @realtimeAvailabilityNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Real-time availability is not available yet.'**
  String get realtimeAvailabilityNotAdded;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @myMarkers.
  ///
  /// In en, this message translates to:
  /// **'My Markers'**
  String get myMarkers;

  /// No description provided for @chatTextSize.
  ///
  /// In en, this message translates to:
  /// **'Chat Text Size'**
  String get chatTextSize;

  /// No description provided for @chatTextSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get chatTextSizeSmall;

  /// No description provided for @chatTextSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get chatTextSizeMedium;

  /// No description provided for @chatTextSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get chatTextSizeLarge;

  /// No description provided for @tipAmountCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Amount in USD (\$)'**
  String get tipAmountCurrencyHint;

  /// No description provided for @nearByMarkerBars.
  ///
  /// In en, this message translates to:
  /// **'Nearby Marker bars'**
  String get nearByMarkerBars;

  /// No description provided for @reviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewLabel;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @blockUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Users'**
  String get blockUsers;

  /// No description provided for @noBankDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No bank details found'**
  String get noBankDetailsFound;

  /// No description provided for @toSendTheCode.
  ///
  /// In en, this message translates to:
  /// **'To send the code to your phone, select it'**
  String get toSendTheCode;

  /// No description provided for @warningMessage.
  ///
  /// In en, this message translates to:
  /// **'Please set up real-time availability to ensure users can see when you\'re open. Real-time availability is required to show open/closed status accurately.'**
  String get warningMessage;

  /// No description provided for @shareBarMessage.
  ///
  /// In en, this message translates to:
  /// **'Let’s grab a drink at {barName}! 🍹 Great vibes, better drinks'**
  String shareBarMessage(String barName);

  /// No description provided for @shareDrinkBarMessage.
  ///
  /// In en, this message translates to:
  /// **'Sip a smooth {drinkName} at {barName}. Crafted to impress.'**
  String shareDrinkBarMessage(String drinkName, String barName);

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'({rates} reviews)'**
  String reviews(String rates);

  /// No description provided for @barRate.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience with “{rates}”'**
  String barRate(String rates);

  /// No description provided for @markerBelong.
  ///
  /// In en, this message translates to:
  /// **'This Marker belongs to {oBarName}. Would you like to allow the user to redeem it at {barName}? If you press \"Yes,\" the user will receive a notification and must accept it to proceed further.'**
  String markerBelong(String oBarName, String barName);

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @drinkAmount.
  ///
  /// In en, this message translates to:
  /// **'Drink Amount: {price}'**
  String drinkAmount(String price);

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount: {total}'**
  String totalAmount(String total);

  /// No description provided for @getYourViaSMS.
  ///
  /// In en, this message translates to:
  /// **'Get your verification code via SMS'**
  String get getYourViaSMS;

  /// No description provided for @nfcNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'NFC is not available on this device'**
  String get nfcNotAvailable;

  /// No description provided for @tagNotNdef.
  ///
  /// In en, this message translates to:
  /// **'This tag is not NDEF formatted'**
  String get tagNotNdef;

  /// No description provided for @noDataNfc.
  ///
  /// In en, this message translates to:
  /// **'No data found on NFC tag'**
  String get noDataNfc;

  /// No description provided for @scanNfc.
  ///
  /// In en, this message translates to:
  /// **'Scan NFC Tag'**
  String get scanNfc;

  /// No description provided for @bartender.
  ///
  /// In en, this message translates to:
  /// **'Bartender'**
  String get bartender;

  /// No description provided for @holdDevice.
  ///
  /// In en, this message translates to:
  /// **'Hold your device near the NFC tag to scan'**
  String get holdDevice;

  /// No description provided for @enterVerification.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your {channelType}'**
  String enterVerification(String channelType);

  /// No description provided for @nfcCode.
  ///
  /// In en, this message translates to:
  /// **'NFC Code: {nfcCode}'**
  String nfcCode(String nfcCode);

  /// No description provided for @nfcError.
  ///
  /// In en, this message translates to:
  /// **'NFC error: {error}'**
  String nfcError(String error);

  /// No description provided for @tapToPayiPhone.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pay on iPhone'**
  String get tapToPayiPhone;

  /// No description provided for @enableTapToPay.
  ///
  /// In en, this message translates to:
  /// **'Enable Tap to Pay'**
  String get enableTapToPay;

  /// No description provided for @acceptPaymentsWithTapToPay.
  ///
  /// In en, this message translates to:
  /// **'Accept payments with Tap to Pay on iPhone'**
  String get acceptPaymentsWithTapToPay;

  /// No description provided for @enableNow.
  ///
  /// In en, this message translates to:
  /// **'Enable Now'**
  String get enableNow;

  /// No description provided for @startAcceptingContactlessPayments.
  ///
  /// In en, this message translates to:
  /// **'Start accepting contactless payments'**
  String get startAcceptingContactlessPayments;

  /// No description provided for @tapToPayGuide.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pay Guide'**
  String get tapToPayGuide;

  /// No description provided for @howToAcceptCards.
  ///
  /// In en, this message translates to:
  /// **'How to accept contactless cards'**
  String get howToAcceptCards;

  /// No description provided for @howToAcceptCardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask your customer to hold their contactless card near the top of your iPhone until you hear a confirmation tone.'**
  String get howToAcceptCardsDesc;

  /// No description provided for @acceptApplePayAndWallets.
  ///
  /// In en, this message translates to:
  /// **'Accept Apple Pay & wallets'**
  String get acceptApplePayAndWallets;

  /// No description provided for @acceptApplePayAndWalletsDesc.
  ///
  /// In en, this message translates to:
  /// **'Customers can pay with Apple Pay, digital wallets, or compatible contactless cards using the same tap flow.'**
  String get acceptApplePayAndWalletsDesc;

  /// No description provided for @holdCardNearIPhone.
  ///
  /// In en, this message translates to:
  /// **'Hold card near iPhone'**
  String get holdCardNearIPhone;

  /// No description provided for @holdCardNearIPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep the card or device close to the iPhone reader area for a few seconds until the payment status appears.'**
  String get holdCardNearIPhoneDesc;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing payment...'**
  String get processingPayment;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// No description provided for @tapToPayOnIPhone.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pay on iPhone'**
  String get tapToPayOnIPhone;

  /// No description provided for @tapToPayOnAndroid.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pay on Android'**
  String get tapToPayOnAndroid;

  /// No description provided for @acceptContactlessPaymentsWithOnlyIPhone.
  ///
  /// In en, this message translates to:
  /// **'Accept contactless payments with only an iPhone.'**
  String get acceptContactlessPaymentsWithOnlyIPhone;

  /// No description provided for @tapToPayIphoneNowAvailable.
  ///
  /// In en, this message translates to:
  /// **'Tap to Pay on iPhone is now available on the Example Payment app. Try it out on us.'**
  String get tapToPayIphoneNowAvailable;

  /// No description provided for @holdHereToPay.
  ///
  /// In en, this message translates to:
  /// **'Hold Here to Pay'**
  String get holdHereToPay;

  /// No description provided for @contactlessReady.
  ///
  /// In en, this message translates to:
  /// **'Contactless Ready'**
  String get contactlessReady;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @lorem.
  ///
  /// In en, this message translates to:
  /// **'Lorem'**
  String get lorem;

  /// No description provided for @disableNow.
  ///
  /// In en, this message translates to:
  /// **'Disable Now'**
  String get disableNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
