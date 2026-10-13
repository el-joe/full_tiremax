import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TireMax'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get navStore;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navReservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get navReservation;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get authEmailOrPhone;

  /// No description provided for @authEmailOrPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number is required'**
  String get authEmailOrPhoneRequired;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordMinLength;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authFullNameRequired;

  /// No description provided for @authNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get authNameTooLong;

  /// No description provided for @authPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get authPhoneNumber;

  /// No description provided for @authPhoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get authPhoneNumberRequired;

  /// No description provided for @authPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get authPhoneTooLong;

  /// No description provided for @authEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get authEmailOptional;

  /// No description provided for @authEmailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email is too long'**
  String get authEmailTooLong;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authInvalidEmail;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get authConfirmPasswordRequired;

  /// No description provided for @authPasswordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get authPasswordsMustMatch;

  /// No description provided for @authAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get authAddressOptional;

  /// No description provided for @authAddressTooLong.
  ///
  /// In en, this message translates to:
  /// **'Address is too long'**
  String get authAddressTooLong;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String profileWelcome(String name);

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get profileAddresses;

  /// No description provided for @profileMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get profileMyOrders;

  /// No description provided for @profileMyBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get profileMyBookings;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// No description provided for @profileLanguageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get profileLanguageArabic;

  /// No description provided for @profilePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profilePrivacyPolicy;

  /// No description provided for @profileTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileTerms;

  /// No description provided for @profileLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogOut;

  /// No description provided for @profileLogOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get profileLogOutConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show here yet'**
  String get commonEmpty;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get commonAddToCart;

  /// No description provided for @commonBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get commonBuyNow;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckout;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cartQuantity;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get checkoutShippingAddress;

  /// No description provided for @checkoutPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get checkoutPaymentMethod;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutOrderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get checkoutOrderConfirmed;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added any favorites yet'**
  String get favoritesEmpty;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get notificationsEmpty;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Find the right tires for your car'**
  String get homeGreeting;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get storeTitle;

  /// No description provided for @servicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesTitle;

  /// No description provided for @reservationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservationTitle;

  /// No description provided for @whatsappChat.
  ///
  /// In en, this message translates to:
  /// **'Chat on WhatsApp'**
  String get whatsappChat;

  /// No description provided for @guestLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'We linked {orders} previous order(s) and {bookings} booking(s) to your account.'**
  String guestLinkedMessage(int orders, int bookings);

  /// No description provided for @controlStartsWith.
  ///
  /// In en, this message translates to:
  /// **'Control starts with'**
  String get controlStartsWith;

  /// No description provided for @theRightTire.
  ///
  /// In en, this message translates to:
  /// **'The right tire'**
  String get theRightTire;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shop, book, and install—all in one place, Powered by the latest global tire service technologies'**
  String get heroSubtitle;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @chooseYourTireNow.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Tire Now'**
  String get chooseYourTireNow;

  /// No description provided for @searchByVehicle.
  ///
  /// In en, this message translates to:
  /// **'Search by Vehicle'**
  String get searchByVehicle;

  /// No description provided for @searchBySize.
  ///
  /// In en, this message translates to:
  /// **'Search by Size'**
  String get searchBySize;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get selectYear;

  /// No description provided for @make.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// No description provided for @selectMake.
  ///
  /// In en, this message translates to:
  /// **'Select Make'**
  String get selectMake;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @selectWidth.
  ///
  /// In en, this message translates to:
  /// **'Select width'**
  String get selectWidth;

  /// No description provided for @aspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Aspect Ratio'**
  String get aspectRatio;

  /// No description provided for @selectAspectRatio.
  ///
  /// In en, this message translates to:
  /// **'Select Aspect Ratio'**
  String get selectAspectRatio;

  /// No description provided for @rimDiameter.
  ///
  /// In en, this message translates to:
  /// **'Rim Diameter'**
  String get rimDiameter;

  /// No description provided for @selectRimDiameter.
  ///
  /// In en, this message translates to:
  /// **'Select Rim Diameter'**
  String get selectRimDiameter;

  /// No description provided for @findYourTireNow.
  ///
  /// In en, this message translates to:
  /// **'Find Your Tire Now'**
  String get findYourTireNow;

  /// No description provided for @recommendedTiresForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended Tires for You'**
  String get recommendedTiresForYou;

  /// No description provided for @recommendedOffersForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended Offers for You'**
  String get recommendedOffersForYou;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @allInOneSolutionsForYourVehicle.
  ///
  /// In en, this message translates to:
  /// **'All-in-One Solutions for Your Vehicle'**
  String get allInOneSolutionsForYourVehicle;

  /// No description provided for @allInOneDescription.
  ///
  /// In en, this message translates to:
  /// **'Find everything your vehicle needs in one place, from premium tires and dependable batteries to expert maintenance and installation services.'**
  String get allInOneDescription;

  /// No description provided for @maintenanceServices.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Services'**
  String get maintenanceServices;

  /// No description provided for @batteryInstallation.
  ///
  /// In en, this message translates to:
  /// **'Battery Installation'**
  String get batteryInstallation;

  /// No description provided for @tireInstallation.
  ///
  /// In en, this message translates to:
  /// **'Tire Installation'**
  String get tireInstallation;

  /// No description provided for @quickAndEasyBooking.
  ///
  /// In en, this message translates to:
  /// **'Quick and Easy Booking'**
  String get quickAndEasyBooking;

  /// No description provided for @bookYourCarServiceNow.
  ///
  /// In en, this message translates to:
  /// **'Book Your Car Service Now!'**
  String get bookYourCarServiceNow;

  /// No description provided for @bookServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Schedule your vehicle service instantly with our professional team.'**
  String get bookServiceDescription;

  /// No description provided for @smartBookingSystemWithoutConflicts.
  ///
  /// In en, this message translates to:
  /// **'Smart Booking System with No Scheduling Conflicts'**
  String get smartBookingSystemWithoutConflicts;

  /// No description provided for @professionalMaintenanceBySpecializedTeam.
  ///
  /// In en, this message translates to:
  /// **'Professional Maintenance by a Specialized Team'**
  String get professionalMaintenanceBySpecializedTeam;

  /// No description provided for @chooseAppointmentAndBranch.
  ///
  /// In en, this message translates to:
  /// **'Select the Appointment Time and Branch That Suit You Best'**
  String get chooseAppointmentAndBranch;

  /// No description provided for @bookServiceNow.
  ///
  /// In en, this message translates to:
  /// **'Book Your Service Now'**
  String get bookServiceNow;

  /// No description provided for @whyChooseTireMax.
  ///
  /// In en, this message translates to:
  /// **'Why Choose TireMax'**
  String get whyChooseTireMax;

  /// No description provided for @tireMax.
  ///
  /// In en, this message translates to:
  /// **'TireMax'**
  String get tireMax;

  /// No description provided for @genuineWarranty.
  ///
  /// In en, this message translates to:
  /// **'Genuine Warranty'**
  String get genuineWarranty;

  /// No description provided for @genuineWarrantyDescription.
  ///
  /// In en, this message translates to:
  /// **'Get up to three years of instant replacement warranty on all tires and batteries.'**
  String get genuineWarrantyDescription;

  /// No description provided for @routineMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Routine Maintenance'**
  String get routineMaintenance;

  /// No description provided for @quickTurnaround.
  ///
  /// In en, this message translates to:
  /// **'Quick Turnaround'**
  String get quickTurnaround;

  /// No description provided for @fastServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Our experienced technicians and state-of-the-art equipment guarantee tire installation within minutes.'**
  String get fastServiceDescription;

  /// No description provided for @whatOurCustomersSay.
  ///
  /// In en, this message translates to:
  /// **'What Our Customers Say'**
  String get whatOurCustomersSay;

  /// No description provided for @testimonialName.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Mohamed'**
  String get testimonialName;

  /// No description provided for @testimonialCity.
  ///
  /// In en, this message translates to:
  /// **'Baghdad'**
  String get testimonialCity;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you have a question or want to book a service? Our expert team is always here to help you and ensure your vehicle performs at its best.'**
  String get contactUsDescription;

  /// No description provided for @customerServiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Customer Service Number'**
  String get customerServiceNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @headOffice.
  ///
  /// In en, this message translates to:
  /// **'Head Office'**
  String get headOffice;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @productCatalog.
  ///
  /// In en, this message translates to:
  /// **'Product Catalog'**
  String get productCatalog;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @productCatalogDescription.
  ///
  /// In en, this message translates to:
  /// **'Easily find the right tires and batteries for your vehicle.'**
  String get productCatalogDescription;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @filtersDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the filters to find the right product based on size, price, and brand.'**
  String get filtersDescription;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get priceRange;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for tires, batteries, or brands...'**
  String get searchPlaceholder;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filterBy.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get filterBy;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @tires.
  ///
  /// In en, this message translates to:
  /// **'Tires'**
  String get tires;

  /// No description provided for @batteries.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get batteries;

  /// No description provided for @bestSeller.
  ///
  /// In en, this message translates to:
  /// **'Best seller'**
  String get bestSeller;

  /// No description provided for @newBadge.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBadge;

  /// No description provided for @bestChoice.
  ///
  /// In en, this message translates to:
  /// **'Best choice'**
  String get bestChoice;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'Special offer'**
  String get specialOffer;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProducts;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @priceIncludesInstallationAndBalancing.
  ///
  /// In en, this message translates to:
  /// **'The price includes installation and wheel balancing in Basra.'**
  String get priceIncludesInstallationAndBalancing;

  /// No description provided for @shippingAvailableAllGovernorates.
  ///
  /// In en, this message translates to:
  /// **'Shipping is available to all governorates.'**
  String get shippingAvailableAllGovernorates;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @countryOfOrigin.
  ///
  /// In en, this message translates to:
  /// **'Country of Origin'**
  String get countryOfOrigin;

  /// No description provided for @treadPattern.
  ///
  /// In en, this message translates to:
  /// **'Tread Pattern'**
  String get treadPattern;

  /// No description provided for @manufactureYear.
  ///
  /// In en, this message translates to:
  /// **'Manufacture year'**
  String get manufactureYear;

  /// No description provided for @usageType.
  ///
  /// In en, this message translates to:
  /// **'Usage type'**
  String get usageType;

  /// No description provided for @loadAndSpeed.
  ///
  /// In en, this message translates to:
  /// **'Load and speed'**
  String get loadAndSpeed;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get availableNow;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @dualWarrantySystem.
  ///
  /// In en, this message translates to:
  /// **'Dual warranty system'**
  String get dualWarrantySystem;

  /// No description provided for @cca.
  ///
  /// In en, this message translates to:
  /// **'CCA'**
  String get cca;

  /// No description provided for @sizeCode.
  ///
  /// In en, this message translates to:
  /// **'Size code'**
  String get sizeCode;

  /// No description provided for @batteryType.
  ///
  /// In en, this message translates to:
  /// **'Battery type'**
  String get batteryType;

  /// No description provided for @voltageAndCapacity.
  ///
  /// In en, this message translates to:
  /// **'Voltage and capacity'**
  String get voltageAndCapacity;

  /// No description provided for @manufacturesWarranty.
  ///
  /// In en, this message translates to:
  /// **'Manufacture\'s warranty'**
  String get manufacturesWarranty;

  /// No description provided for @manufacturesWarrantyDescription.
  ///
  /// In en, this message translates to:
  /// **'warranty against manufacturing defects for a'**
  String get manufacturesWarrantyDescription;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @authorizedWarranty.
  ///
  /// In en, this message translates to:
  /// **'Authorized Warranty'**
  String get authorizedWarranty;

  /// No description provided for @tireMaxExclusiveMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Exclusive periodic maintenance and follow-up services provided by TireMax agency.'**
  String get tireMaxExclusiveMaintenance;

  /// No description provided for @userReviews.
  ///
  /// In en, this message translates to:
  /// **'User reviews'**
  String get userReviews;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @iraqiDinar.
  ///
  /// In en, this message translates to:
  /// **'Iraqi Dinar'**
  String get iraqiDinar;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @completeVehicleServices.
  ///
  /// In en, this message translates to:
  /// **'Complete Vehicle Services & Maintenance'**
  String get completeVehicleServices;

  /// No description provided for @completeVehicleServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'We provide all your vehicle maintenance needs under one roof at Tire Max Iraq, delivering premium quality, precision, speed, and a genuine warranty with every service.'**
  String get completeVehicleServicesDescription;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @modernTechnology.
  ///
  /// In en, this message translates to:
  /// **'Modern Technology'**
  String get modernTechnology;

  /// No description provided for @modernTechnologyDescription.
  ///
  /// In en, this message translates to:
  /// **'Unmatched precision in every digital inspection.'**
  String get modernTechnologyDescription;

  /// No description provided for @serviceJourneyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Service Journey in 4 Simple Steps'**
  String get serviceJourneyTitle;

  /// No description provided for @whyChooseTireMaxServices.
  ///
  /// In en, this message translates to:
  /// **'Why Choose Tire Max?'**
  String get whyChooseTireMaxServices;

  /// No description provided for @dedicatedSupport.
  ///
  /// In en, this message translates to:
  /// **'Dedicated Support'**
  String get dedicatedSupport;

  /// No description provided for @dedicatedSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Ongoing assistance, even after purchase.'**
  String get dedicatedSupportDescription;

  /// No description provided for @dedicatedSupportDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'even after purchase.'**
  String get dedicatedSupportDescriptionHighlight;

  /// No description provided for @customerCareDescription.
  ///
  /// In en, this message translates to:
  /// **'At Tire Max, we treat your vehicle as if it were our own. Our advanced system keeps you informed and supported, helping you stay safe on the road.'**
  String get customerCareDescription;

  /// No description provided for @customerSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Customer Satisfaction'**
  String get customerSatisfaction;

  /// No description provided for @ctaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Keep Your Vehicle in Top Condition?'**
  String get ctaTitle;

  /// No description provided for @ctaDescription.
  ///
  /// In en, this message translates to:
  /// **'Don\'t wait for a breakdown. Book your service appointment today and enjoy peace of mind and safer driving on the road.'**
  String get ctaDescription;

  /// No description provided for @bookYourAppointmentNow.
  ///
  /// In en, this message translates to:
  /// **'Book Your Appointment Now'**
  String get bookYourAppointmentNow;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @youHave.
  ///
  /// In en, this message translates to:
  /// **'You Have'**
  String get youHave;

  /// No description provided for @orderWord.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderWord;

  /// No description provided for @reservationWord.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservationWord;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get onTheWay;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @manageBookingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage all your service bookings'**
  String get manageBookingsDescription;

  /// No description provided for @noBookingYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingYet;

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking Number'**
  String get bookingNumber;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get orderSummary;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotal;

  /// No description provided for @shippingFee.
  ///
  /// In en, this message translates to:
  /// **'Shipping fee'**
  String get shippingFee;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Our support team is available around the clock to answer your questions and assist you.'**
  String get supportDescription;

  /// No description provided for @chatWithAnExpert.
  ///
  /// In en, this message translates to:
  /// **'Talk to an Expert'**
  String get chatWithAnExpert;

  /// No description provided for @orderConfirmedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed successfully.'**
  String get orderConfirmedSuccessfully;

  /// No description provided for @orderConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for choosing Tire Max. We have received your order and are preparing it with the utmost care.'**
  String get orderConfirmationMessage;

  /// No description provided for @orderReference.
  ///
  /// In en, this message translates to:
  /// **'Order reference'**
  String get orderReference;

  /// No description provided for @createAccountToTrack.
  ///
  /// In en, this message translates to:
  /// **'Create an account to track your orders and get faster checkout next time.'**
  String get createAccountToTrack;

  /// No description provided for @createAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountCta;

  /// No description provided for @branchPickup.
  ///
  /// In en, this message translates to:
  /// **'Branch Pickup'**
  String get branchPickup;

  /// No description provided for @estimatedDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated Delivery Date'**
  String get estimatedDeliveryDate;

  /// No description provided for @deliveryStatus.
  ///
  /// In en, this message translates to:
  /// **'Delivery status'**
  String get deliveryStatus;

  /// No description provided for @businessDays.
  ///
  /// In en, this message translates to:
  /// **'Business Days'**
  String get businessDays;

  /// No description provided for @readyForPickup.
  ///
  /// In en, this message translates to:
  /// **'Ready for pickup'**
  String get readyForPickup;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @orderDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'View all your order details, delivery status, and payment information.'**
  String get orderDetailsDescription;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @keepOrder.
  ///
  /// In en, this message translates to:
  /// **'Keep Order'**
  String get keepOrder;

  /// No description provided for @cancelOrderWarning.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to restore the order once it has been canceled.'**
  String get cancelOrderWarning;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping cart'**
  String get shoppingCart;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @goToShopping.
  ///
  /// In en, this message translates to:
  /// **'Go to shopping'**
  String get goToShopping;

  /// No description provided for @enterOfferCode.
  ///
  /// In en, this message translates to:
  /// **'Enter offer code'**
  String get enterOfferCode;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @offerApplied.
  ///
  /// In en, this message translates to:
  /// **'Offer applied'**
  String get offerApplied;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to checkout'**
  String get proceedToCheckout;

  /// No description provided for @flexible72HourReturnGuarantee.
  ///
  /// In en, this message translates to:
  /// **'Flexible 72-Hour Return Guarantee'**
  String get flexible72HourReturnGuarantee;

  /// No description provided for @easyReturnsAndExchangesDescription.
  ///
  /// In en, this message translates to:
  /// **'Your satisfaction is protected! Enjoy easy returns and exchanges.'**
  String get easyReturnsAndExchangesDescription;

  /// No description provided for @sixMonthAfterSalesSupport.
  ///
  /// In en, this message translates to:
  /// **'6-Month After-Sales Support'**
  String get sixMonthAfterSalesSupport;

  /// No description provided for @afterSalesSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'re always here for you! Enjoy exceptional after-sales service.'**
  String get afterSalesSupportDescription;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @orderType.
  ///
  /// In en, this message translates to:
  /// **'Order Type'**
  String get orderType;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'+98560054'**
  String get phoneNumberPlaceholder;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailPlaceholder;

  /// No description provided for @haveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAnAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @createAccountWithOrder.
  ///
  /// In en, this message translates to:
  /// **'Create an account with this order'**
  String get createAccountWithOrder;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Choose a password (min 6 characters)'**
  String get passwordPlaceholder;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get selectBranch;

  /// No description provided for @governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// No description provided for @selectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get selectGovernorate;

  /// No description provided for @fullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get fullAddress;

  /// No description provided for @fullAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your street name, building or house number, and the nearest landmark...'**
  String get fullAddressPlaceholder;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get notesPlaceholder;

  /// No description provided for @noPaymentMethodsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available'**
  String get noPaymentMethodsAvailable;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm order'**
  String get confirmOrder;

  /// No description provided for @confirmOrderDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By clicking \'Confirm Order,\' you agree to the Terms and Conditions.'**
  String get confirmOrderDisclaimer;

  /// No description provided for @accountNotCreated.
  ///
  /// In en, this message translates to:
  /// **'Your order was placed, but we couldn\'t create the account.'**
  String get accountNotCreated;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @bookServiceAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book a Service Appointment'**
  String get bookServiceAppointment;

  /// No description provided for @bookServiceAppointmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the service and time that work best for you. We provide your vehicle with the highest level of care, precision, and efficiency.'**
  String get bookServiceAppointmentDescription;

  /// No description provided for @chooseRequiredService.
  ///
  /// In en, this message translates to:
  /// **'Choose the Service You Need'**
  String get chooseRequiredService;

  /// No description provided for @chooseNearestBranch.
  ///
  /// In en, this message translates to:
  /// **'Choose the Branch Closest to You'**
  String get chooseNearestBranch;

  /// No description provided for @chooseDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Preferred Date and Time'**
  String get chooseDateAndTime;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a Date'**
  String get chooseDate;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a Time'**
  String get chooseTime;

  /// No description provided for @chooseDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a date first to view available time slots.'**
  String get chooseDateFirst;

  /// No description provided for @noTimeAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this date. Please choose another date.'**
  String get noTimeAvailable;

  /// No description provided for @continueToConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Continue to Confirmation'**
  String get continueToConfirmation;

  /// No description provided for @bookingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmation'**
  String get bookingConfirmation;

  /// No description provided for @reviewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Review your booking details before confirming.'**
  String get reviewBookingDetails;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get estimatedCost;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInformation;

  /// No description provided for @confirmBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBookingButton;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Iraqi phone number (e.g. 07701234567)'**
  String get phoneInvalid;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// No description provided for @bookingDateInPast.
  ///
  /// In en, this message translates to:
  /// **'Please choose a date and time in the future'**
  String get bookingDateInPast;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingSuccess;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Booking reference'**
  String get bookingReference;

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// No description provided for @createAccountToTrackBookings.
  ///
  /// In en, this message translates to:
  /// **'Create an account to track and manage your bookings.'**
  String get createAccountToTrackBookings;

  /// No description provided for @importantNotes.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get importantNotes;

  /// No description provided for @arriveEarlyNote.
  ///
  /// In en, this message translates to:
  /// **'Please arrive 10 minutes before your scheduled appointment.'**
  String get arriveEarlyNote;

  /// No description provided for @lateArrivalNote.
  ///
  /// In en, this message translates to:
  /// **'Late arrivals may result in your appointment being rescheduled.'**
  String get lateArrivalNote;

  /// No description provided for @modifyBookingNote.
  ///
  /// In en, this message translates to:
  /// **'You may cancel or modify your booking up to 24 hours in advance.'**
  String get modifyBookingNote;

  /// No description provided for @chooseService.
  ///
  /// In en, this message translates to:
  /// **'Choose a Service'**
  String get chooseService;

  /// No description provided for @chooseBranch.
  ///
  /// In en, this message translates to:
  /// **'Choose a Branch'**
  String get chooseBranch;

  /// No description provided for @chooseAppointment.
  ///
  /// In en, this message translates to:
  /// **'Choose an Appointment'**
  String get chooseAppointment;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @step1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1;

  /// No description provided for @step2.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2;

  /// No description provided for @step3.
  ///
  /// In en, this message translates to:
  /// **'Step 3'**
  String get step3;

  /// No description provided for @step4.
  ///
  /// In en, this message translates to:
  /// **'Step 4'**
  String get step4;

  /// No description provided for @chooseRequiredServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the type of service required for your vehicle.'**
  String get chooseRequiredServiceDescription;

  /// No description provided for @chooseThisService.
  ///
  /// In en, this message translates to:
  /// **'Choose this service'**
  String get chooseThisService;

  /// No description provided for @chooseThisBranch.
  ///
  /// In en, this message translates to:
  /// **'Choose this branch'**
  String get chooseThisBranch;

  /// No description provided for @selectedService.
  ///
  /// In en, this message translates to:
  /// **'Selected Service'**
  String get selectedService;

  /// No description provided for @selectedBranch.
  ///
  /// In en, this message translates to:
  /// **'Selected Branch'**
  String get selectedBranch;

  /// No description provided for @branchInformation.
  ///
  /// In en, this message translates to:
  /// **'Branch Information'**
  String get branchInformation;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get km;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @savedProductsDescription.
  ///
  /// In en, this message translates to:
  /// **'Products you\'ve saved for later.'**
  String get savedProductsDescription;

  /// No description provided for @noFavoriteProducts.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have favorite products yet'**
  String get noFavoriteProducts;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsHeadingDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay up to date with the latest updates on your orders and bookings'**
  String get notificationsHeadingDescription;

  /// No description provided for @bestTiresInIraq.
  ///
  /// In en, this message translates to:
  /// **'Best Tires in Iraq'**
  String get bestTiresInIraq;

  /// No description provided for @chooseYourPerfectTire.
  ///
  /// In en, this message translates to:
  /// **'Choose the Right Tire for Iraq\'s Summer'**
  String get chooseYourPerfectTire;

  /// No description provided for @chooseYourPerfectTireDescription.
  ///
  /// In en, this message translates to:
  /// **'Carefully selected options that provide a safe and comfortable driving experience throughout the summer.'**
  String get chooseYourPerfectTireDescription;

  /// No description provided for @youDontHaveNotifications.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications'**
  String get youDontHaveNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @webProfileWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get webProfileWelcome;

  /// No description provided for @webProfileAddresses.
  ///
  /// In en, this message translates to:
  /// **'Addresses'**
  String get webProfileAddresses;

  /// No description provided for @webProfileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get webProfileSettings;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileLogout;

  /// No description provided for @bookNewService.
  ///
  /// In en, this message translates to:
  /// **'Book a New Service'**
  String get bookNewService;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @upcomingBookings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Bookings'**
  String get upcomingBookings;

  /// No description provided for @primaryAddress.
  ///
  /// In en, this message translates to:
  /// **'Primary Address'**
  String get primaryAddress;

  /// No description provided for @profileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFullName;

  /// No description provided for @profilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhoneNumber;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @profilePersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInformation;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @noReservationYet.
  ///
  /// In en, this message translates to:
  /// **'No reservation yet'**
  String get noReservationYet;

  /// No description provided for @noAddressYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added an address yet'**
  String get noAddressYet;

  /// No description provided for @manageAddressesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your delivery addresses'**
  String get manageAddressesDescription;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get savedAddresses;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @defaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Default Address'**
  String get defaultAddress;

  /// No description provided for @setAsDefaultAddress.
  ///
  /// In en, this message translates to:
  /// **'Set as Default Address'**
  String get setAsDefaultAddress;

  /// No description provided for @setAsDefaultAddressWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to set this address as your default address?'**
  String get setAsDefaultAddressWarning;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @removeAddress.
  ///
  /// In en, this message translates to:
  /// **'Remove Address'**
  String get removeAddress;

  /// No description provided for @removeAddressWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this address? This action cannot be undone.'**
  String get removeAddressWarning;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @selectCityIsRequired.
  ///
  /// In en, this message translates to:
  /// **'City selection is required'**
  String get selectCityIsRequired;

  /// No description provided for @selectGovernorateIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Governorate selection is required'**
  String get selectGovernorateIsRequired;

  /// No description provided for @theAddressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get theAddressIsRequired;

  /// No description provided for @theAddressMustBeMoreThen12Character.
  ///
  /// In en, this message translates to:
  /// **'The address must be more than 12 characters'**
  String get theAddressMustBeMoreThen12Character;

  /// No description provided for @profileFullAddress.
  ///
  /// In en, this message translates to:
  /// **'Full Address'**
  String get profileFullAddress;

  /// No description provided for @profileFullAddressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your street name, house number, and nearest landmark...'**
  String get profileFullAddressPlaceholder;

  /// No description provided for @createAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get createAddress;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @accountSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your personal information and security settings'**
  String get accountSettingsDescription;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get profileEmail;

  /// No description provided for @securityAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Security & Password'**
  String get securityAndPassword;

  /// No description provided for @profileConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get profileConfirmPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @orderUpdates.
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get orderUpdates;

  /// No description provided for @orderUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about your order status'**
  String get orderUpdatesDescription;

  /// No description provided for @offersAndDiscounts.
  ///
  /// In en, this message translates to:
  /// **'Offers & Discounts'**
  String get offersAndDiscounts;

  /// No description provided for @offersAndDiscountsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications about special offers'**
  String get offersAndDiscountsDescription;

  /// No description provided for @newsletter.
  ///
  /// In en, this message translates to:
  /// **'Newsletter'**
  String get newsletter;

  /// No description provided for @newsletterDescription.
  ///
  /// In en, this message translates to:
  /// **'Get the latest news and product updates'**
  String get newsletterDescription;

  /// No description provided for @smsMessages.
  ///
  /// In en, this message translates to:
  /// **'SMS Messages'**
  String get smsMessages;

  /// No description provided for @smsMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive text messages for important updates'**
  String get smsMessagesDescription;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @passwordsMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get passwordsMustMatch;

  /// No description provided for @passwordConfirmationRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get passwordConfirmationRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get passwordMinLength;

  /// No description provided for @emailMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Email must not exceed 120 characters'**
  String get emailMaxLength;

  /// No description provided for @nameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed 120 characters'**
  String get nameMaxLength;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 6 characters long'**
  String get nameMinLength;

  /// No description provided for @emailPlaceholderProfile.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get emailPlaceholderProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get authWelcome;

  /// No description provided for @enterEmailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get enterEmailOrPhoneNumber;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterAddress;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// No description provided for @logoutWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You\'ll be redirected to the home page.'**
  String get logoutWarning;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutConfirm;

  /// No description provided for @logoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get logoutCancel;

  /// No description provided for @testimonials0.
  ///
  /// In en, this message translates to:
  /// **'The best tire service in Baghdad. Punctual appointments, highly competitive prices, and the laser wheel balancing made a noticeable difference in my driving experience.'**
  String get testimonials0;

  /// No description provided for @testimonials1.
  ///
  /// In en, this message translates to:
  /// **'The warranty is truly genuine. I had a minor issue with one of the tires, and it was replaced immediately with no hassle at all. I highly recommend them.'**
  String get testimonials1;

  /// No description provided for @testimonials2.
  ///
  /// In en, this message translates to:
  /// **'A very smooth purchase experience on the website. I booked an appointment and went to the branch, and my tires were installed in less than 15 minutes. Thank you, TireMax.'**
  String get testimonials2;

  /// No description provided for @journey0Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a Service'**
  String get journey0Title;

  /// No description provided for @journey0Desc.
  ///
  /// In en, this message translates to:
  /// **'Browse our services and select the one you need.'**
  String get journey0Desc;

  /// No description provided for @journey1Title.
  ///
  /// In en, this message translates to:
  /// **'Schedule Your Appointment'**
  String get journey1Title;

  /// No description provided for @journey1Desc.
  ///
  /// In en, this message translates to:
  /// **'Pick the date and time that work best for you.'**
  String get journey1Desc;

  /// No description provided for @journey2Title.
  ///
  /// In en, this message translates to:
  /// **'Visit Our Service Center'**
  String get journey2Title;

  /// No description provided for @journey2Desc.
  ///
  /// In en, this message translates to:
  /// **'Our team will be ready to welcome you.'**
  String get journey2Desc;

  /// No description provided for @journey3Title.
  ///
  /// In en, this message translates to:
  /// **'Pick Up Your Vehicle'**
  String get journey3Title;

  /// No description provided for @journey3Desc.
  ///
  /// In en, this message translates to:
  /// **'Collect your vehicle, fully serviced and backed by our service warranty.'**
  String get journey3Desc;

  /// No description provided for @whyChoose0Title.
  ///
  /// In en, this message translates to:
  /// **'Certified Experts'**
  String get whyChoose0Title;

  /// No description provided for @whyChoose0Desc.
  ///
  /// In en, this message translates to:
  /// **'Our internationally trained technicians deliver trusted expertise.'**
  String get whyChoose0Desc;

  /// No description provided for @whyChoose1Title.
  ///
  /// In en, this message translates to:
  /// **'Advanced Equipment'**
  String get whyChoose1Title;

  /// No description provided for @whyChoose1Desc.
  ///
  /// In en, this message translates to:
  /// **'Powered by the latest inspection technology.'**
  String get whyChoose1Desc;

  /// No description provided for @whyChoose2Title.
  ///
  /// In en, this message translates to:
  /// **'Fast Turnaround'**
  String get whyChoose2Title;

  /// No description provided for @whyChoose2Desc.
  ///
  /// In en, this message translates to:
  /// **'We value your time and complete services efficiently.'**
  String get whyChoose2Desc;

  /// No description provided for @whyChoose3Title.
  ///
  /// In en, this message translates to:
  /// **'Service Warranty'**
  String get whyChoose3Title;

  /// No description provided for @whyChoose3Desc.
  ///
  /// In en, this message translates to:
  /// **'Confidence that extends beyond the repair.'**
  String get whyChoose3Desc;

  /// No description provided for @whyChoose4Title.
  ///
  /// In en, this message translates to:
  /// **'Exceptional Precision'**
  String get whyChoose4Title;

  /// No description provided for @whyChoose4Desc.
  ///
  /// In en, this message translates to:
  /// **'Attention to every detail for outstanding results.'**
  String get whyChoose4Desc;

  /// No description provided for @features0Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Reminders'**
  String get features0Title;

  /// No description provided for @features0Desc.
  ///
  /// In en, this message translates to:
  /// **'Automatic reminders for oil changes and tire replacements.'**
  String get features0Desc;

  /// No description provided for @features1Title.
  ///
  /// In en, this message translates to:
  /// **'24/7 Technical Support'**
  String get features1Title;

  /// No description provided for @features1Desc.
  ///
  /// In en, this message translates to:
  /// **'Our experts are available anytime to answer your questions.'**
  String get features1Desc;

  /// No description provided for @features2Title.
  ///
  /// In en, this message translates to:
  /// **'Free Inspections'**
  String get features2Title;

  /// No description provided for @features2Desc.
  ///
  /// In en, this message translates to:
  /// **'Complimentary tire pressure and tire safety checks for our customers.'**
  String get features2Desc;

  /// No description provided for @features3Title.
  ///
  /// In en, this message translates to:
  /// **'Extended Warranty'**
  String get features3Title;

  /// No description provided for @features3Desc.
  ///
  /// In en, this message translates to:
  /// **'Enjoy added peace of mind with our genuine warranty plans.'**
  String get features3Desc;

  /// No description provided for @privacyPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'At Tire Max Iraq, we are committed to protecting your privacy and ensuring the security of your personal data. This policy explains how we handle your information with transparency and care.'**
  String get privacyPolicyDescription;

  /// No description provided for @dataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get dataCollection;

  /// No description provided for @dataCollectionDescription.
  ///
  /// In en, this message translates to:
  /// **'We collect information that you provide directly to us when using our services, including:'**
  String get dataCollectionDescription;

  /// No description provided for @vehicleData.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Data: Vehicle type, tire size, and maintenance history.'**
  String get vehicleData;

  /// No description provided for @paymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information: Financial transaction details (processed through encrypted channels).'**
  String get paymentInformation;

  /// No description provided for @locationData.
  ///
  /// In en, this message translates to:
  /// **'Location Data: To provide roadside assistance services and locate the nearest branch.'**
  String get locationData;

  /// No description provided for @howWeUseInformation.
  ///
  /// In en, this message translates to:
  /// **'How We Use Information'**
  String get howWeUseInformation;

  /// No description provided for @howWeUseInformationDescription.
  ///
  /// In en, this message translates to:
  /// **'We use your data to improve your driving experience, personalize technical offers, and ensure tire safety through regular maintenance reminders. We do not sell your data to third parties for marketing purposes.'**
  String get howWeUseInformationDescription;

  /// No description provided for @dataProtection.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get dataProtection;

  /// No description provided for @dataProtectionDescription.
  ///
  /// In en, this message translates to:
  /// **'We implement military-grade encryption protocols (AES-256) to protect our databases. Access to personal information is restricted to employees who need it to serve you.'**
  String get dataProtectionDescription;

  /// No description provided for @userRights.
  ///
  /// In en, this message translates to:
  /// **'User Rights'**
  String get userRights;

  /// No description provided for @userRightsDescription.
  ///
  /// In en, this message translates to:
  /// **'You have the full right to access your data, correct it, or request its permanent deletion from our systems. You may also object to the processing of your data at any time.'**
  String get userRightsDescription;

  /// No description provided for @havePrivacyQuestions.
  ///
  /// In en, this message translates to:
  /// **'Have Questions About Privacy?'**
  String get havePrivacyQuestions;

  /// No description provided for @havePrivacyQuestionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Our legal and technical teams are ready to answer all your questions.'**
  String get havePrivacyQuestionsDescription;

  /// No description provided for @termsAndConditionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tire Max Iraq. These Terms and Conditions govern your use of our website and services. By accessing our services, you agree to be bound by these terms in full.'**
  String get termsAndConditionsDescription;

  /// No description provided for @introductionParagraph1.
  ///
  /// In en, this message translates to:
  /// **'This agreement is entered into between you and Tire Max Iraq. These terms apply to all visitors, users, and others who access or use the service.'**
  String get introductionParagraph1;

  /// No description provided for @introductionParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Please read these terms carefully before using the website. If you do not agree to any part of these terms, you may not access the service.'**
  String get introductionParagraph2;

  /// No description provided for @informationAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Information Accuracy'**
  String get informationAccuracy;

  /// No description provided for @informationAccuracyDescription.
  ///
  /// In en, this message translates to:
  /// **'All information provided during registration must be accurate, current, and complete.'**
  String get informationAccuracyDescription;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get accountSecurity;

  /// No description provided for @accountSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your password and for all activities that occur under your account.'**
  String get accountSecurityDescription;

  /// No description provided for @purchasesAndPaymentsParagraph1.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to refuse or cancel your order at any time for certain reasons, including but not limited to product availability, errors in product descriptions or pricing, or errors in your order.'**
  String get purchasesAndPaymentsParagraph1;

  /// No description provided for @purchasesAndPaymentsParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Payments are made in Iraqi Dinar according to the exchange rate announced by the store.'**
  String get purchasesAndPaymentsParagraph2;

  /// No description provided for @purchasesAndPaymentsParagraph3.
  ///
  /// In en, this message translates to:
  /// **'We use secure and encrypted payment gateways to protect your financial information.'**
  String get purchasesAndPaymentsParagraph3;

  /// No description provided for @warrantiesDescription.
  ///
  /// In en, this message translates to:
  /// **'All tires sold through Tire Max Iraq come with a manufacturer\'s warranty against manufacturing defects. Warranty periods and conditions vary by brand and model. The warranty does not cover damage resulting from:'**
  String get warrantiesDescription;

  /// No description provided for @misuse.
  ///
  /// In en, this message translates to:
  /// **'Misuse'**
  String get misuse;

  /// No description provided for @incorrectInstallation.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Installation Outside Our Centers'**
  String get incorrectInstallation;

  /// No description provided for @improperStorage.
  ///
  /// In en, this message translates to:
  /// **'Improper Storage'**
  String get improperStorage;

  /// No description provided for @limitationOfLiabilityParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Under no circumstances shall Tire Max Iraq, its directors, employees, or partners be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, use, or goodwill.'**
  String get limitationOfLiabilityParagraph1;

  /// No description provided for @limitationOfLiabilityParagraph2.
  ///
  /// In en, this message translates to:
  /// **'We strive to provide the most accurate information, but we do not guarantee that the website will be free from technical or typographical errors.'**
  String get limitationOfLiabilityParagraph2;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: May 20, 2024'**
  String get lastUpdated;

  /// No description provided for @contactMessageSent.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent. We will get back to you soon.'**
  String get contactMessageSent;

  /// No description provided for @inquirySubject.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Subject'**
  String get inquirySubject;

  /// No description provided for @inquiryAboutPrices.
  ///
  /// In en, this message translates to:
  /// **'Inquiry about prices'**
  String get inquiryAboutPrices;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @howCanWeHelpYouToday.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today'**
  String get howCanWeHelpYouToday;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @orContactImmediatelyVia.
  ///
  /// In en, this message translates to:
  /// **'Or contact us instantly via:'**
  String get orContactImmediatelyVia;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Reference and phone number are required'**
  String get required;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'No order or booking found for these details'**
  String get notFound;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get error;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Track your order or booking'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Enter your reference number and the phone number used when ordering.'**
  String get description;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @cancelBookingWarning.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to restore the booking once it has been canceled.'**
  String get cancelBookingWarning;

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep Booking'**
  String get keepBooking;

  /// No description provided for @rescheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Booking'**
  String get rescheduleBooking;

  /// No description provided for @rescheduleBookingWarning.
  ///
  /// In en, this message translates to:
  /// **'Rescheduling will cancel your current booking. Are you sure?'**
  String get rescheduleBookingWarning;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @headerBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get headerBookNow;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now!'**
  String get now;

  /// No description provided for @phoneNumberMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number must not exceed 20 digits'**
  String get phoneNumberMaxLength;

  /// No description provided for @clearCartQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear cart?'**
  String get clearCartQuestion;

  /// No description provided for @clearCartBody.
  ///
  /// In en, this message translates to:
  /// **'This will remove all items from your cart.'**
  String get clearCartBody;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearCartTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCartTooltip;

  /// No description provided for @bookYourCarService.
  ///
  /// In en, this message translates to:
  /// **'Book Your Car Service'**
  String get bookYourCarService;

  /// No description provided for @whyChoosePrefix.
  ///
  /// In en, this message translates to:
  /// **'Why Choose '**
  String get whyChoosePrefix;

  /// No description provided for @bookingDetail.
  ///
  /// In en, this message translates to:
  /// **'Booking Detail'**
  String get bookingDetail;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @dateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateAndTime;

  /// No description provided for @couldNotCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel the booking.'**
  String get couldNotCancelBooking;

  /// No description provided for @couldNotRescheduleBooking.
  ///
  /// In en, this message translates to:
  /// **'Could not reschedule the booking.'**
  String get couldNotRescheduleBooking;

  /// No description provided for @noServicesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No services available.'**
  String get noServicesAvailable;

  /// No description provided for @noBranchesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No branches available.'**
  String get noBranchesAvailable;

  /// No description provided for @selectADate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectADate;

  /// No description provided for @ongoingAssistancePrefix.
  ///
  /// In en, this message translates to:
  /// **'Ongoing assistance, '**
  String get ongoingAssistancePrefix;

  /// No description provided for @privacyPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information: Name, email address, and phone number.'**
  String get privacyPersonalInformation;

  /// No description provided for @legalSectionIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get legalSectionIntroduction;

  /// No description provided for @legalSectionUserObligations.
  ///
  /// In en, this message translates to:
  /// **'User Obligations'**
  String get legalSectionUserObligations;

  /// No description provided for @legalSectionPurchasesAndPayments.
  ///
  /// In en, this message translates to:
  /// **'Purchases & Payments'**
  String get legalSectionPurchasesAndPayments;

  /// No description provided for @legalSectionWarranties.
  ///
  /// In en, this message translates to:
  /// **'Warranties'**
  String get legalSectionWarranties;

  /// No description provided for @legalSectionLimitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get legalSectionLimitationOfLiability;

  /// No description provided for @minutesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesCount(int count);

  /// No description provided for @couldNotCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel the order.'**
  String get couldNotCancelOrder;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed.'**
  String get bookingFailed;

  /// No description provided for @couldNotPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Could not place order.'**
  String get couldNotPlaceOrder;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get pleaseFillRequiredFields;

  /// No description provided for @phoneMax20.
  ///
  /// In en, this message translates to:
  /// **'Phone number must not exceed 20 digits'**
  String get phoneMax20;

  /// No description provided for @addressMax255.
  ///
  /// In en, this message translates to:
  /// **'The address must not exceed 255 characters'**
  String get addressMax255;

  /// No description provided for @setAsDefault.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get setAsDefault;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameMax120.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most 120 characters'**
  String get nameMax120;

  /// No description provided for @phoneMax30.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at most 30 characters'**
  String get phoneMax30;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Subject is required'**
  String get subjectRequired;

  /// No description provided for @subjectMax190.
  ///
  /// In en, this message translates to:
  /// **'Subject must be at most 190 characters'**
  String get subjectMax190;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get messageRequired;

  /// No description provided for @messageMax5000.
  ///
  /// In en, this message translates to:
  /// **'Message must be at most 5000 characters'**
  String get messageMax5000;

  /// No description provided for @errTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Please try again.'**
  String get errTimeout;

  /// No description provided for @errConnection.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Check your internet connection.'**
  String get errConnection;

  /// No description provided for @errCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get errCancelled;

  /// No description provided for @errBadCertificate.
  ///
  /// In en, this message translates to:
  /// **'A secure connection could not be established.'**
  String get errBadCertificate;

  /// No description provided for @errSomethingWrongTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errSomethingWrongTryAgain;

  /// No description provided for @errUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errUnexpected;

  /// No description provided for @somethingWentWrongPeriod.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrongPeriod;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusComplete.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusComplete;

  /// No description provided for @statusRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get statusRescheduled;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @iqdLabel.
  ///
  /// In en, this message translates to:
  /// **'IQD'**
  String get iqdLabel;

  /// No description provided for @timeAm.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get timeAm;

  /// No description provided for @timePm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get timePm;

  /// No description provided for @bookingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Please check wheel balance too'**
  String get bookingNotesHint;

  /// No description provided for @trafficAccidents.
  ///
  /// In en, this message translates to:
  /// **'Traffic Accidents'**
  String get trafficAccidents;

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get viewCart;

  /// No description provided for @addToFavoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavoritesLabel;

  /// No description provided for @removeFromFavoritesLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavoritesLabel;

  /// No description provided for @emptyStateDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyStateDefaultTitle;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String resultsCount(int count);

  /// No description provided for @sectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sectionDescription;

  /// No description provided for @sectionSpecs.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get sectionSpecs;

  /// No description provided for @sectionWarranty.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get sectionWarranty;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviews;

  /// No description provided for @productCopied.
  ///
  /// In en, this message translates to:
  /// **'Product details copied'**
  String get productCopied;

  /// No description provided for @shareProduct.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareProduct;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String durationMinutes(int n);

  /// No description provided for @loadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load more products'**
  String get loadMoreFailed;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @copyReference.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyReference;

  /// No description provided for @referenceCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference copied'**
  String get referenceCopied;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @itemRemoved.
  ///
  /// In en, this message translates to:
  /// **'Item removed'**
  String get itemRemoved;

  /// No description provided for @haveOfferCode.
  ///
  /// In en, this message translates to:
  /// **'Have an offer code?'**
  String get haveOfferCode;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(int current, int total);

  /// No description provided for @viewOrder.
  ///
  /// In en, this message translates to:
  /// **'View order'**
  String get viewOrder;

  /// No description provided for @profileSectionActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get profileSectionActivity;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support & legal'**
  String get profileSectionSupport;

  /// No description provided for @notificationsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsToday;

  /// No description provided for @notificationsEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notificationsEarlier;

  /// No description provided for @filterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get filterUpcoming;

  /// No description provided for @orderProgress.
  ///
  /// In en, this message translates to:
  /// **'Order progress'**
  String get orderProgress;

  /// No description provided for @bookingProgress.
  ///
  /// In en, this message translates to:
  /// **'Booking progress'**
  String get bookingProgress;

  /// No description provided for @orderStepPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get orderStepPlaced;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
