// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TireMax';

  @override
  String get navHome => 'Home';

  @override
  String get navStore => 'Store';

  @override
  String get navServices => 'Services';

  @override
  String get navReservation => 'Reservation';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authEmailOrPhone => 'Email or phone number';

  @override
  String get authEmailOrPhoneRequired => 'Email or phone number is required';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get authFullName => 'Full name';

  @override
  String get authFullNameRequired => 'Full name is required';

  @override
  String get authNameTooLong => 'Name is too long';

  @override
  String get authPhoneNumber => 'Phone number';

  @override
  String get authPhoneNumberRequired => 'Phone number is required';

  @override
  String get authPhoneTooLong => 'Phone number is too long';

  @override
  String get authEmailOptional => 'Email (optional)';

  @override
  String get authEmailTooLong => 'Email is too long';

  @override
  String get authInvalidEmail => 'Invalid email address';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get authConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get authPasswordsMustMatch => 'Passwords must match';

  @override
  String get authAddressOptional => 'Address (optional)';

  @override
  String get authAddressTooLong => 'Address is too long';

  @override
  String get profileTitle => 'Profile';

  @override
  String profileWelcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileAddresses => 'Addresses';

  @override
  String get profileMyOrders => 'My Orders';

  @override
  String get profileMyBookings => 'My Bookings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageArabic => 'العربية';

  @override
  String get profilePrivacyPolicy => 'Privacy Policy';

  @override
  String get profileTerms => 'Terms & Conditions';

  @override
  String get profileLogOut => 'Log Out';

  @override
  String get profileLogOutConfirm => 'Are you sure you want to log out?';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonEmpty => 'Nothing to show here yet';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonAddToCart => 'Add to cart';

  @override
  String get commonBuyNow => 'Buy now';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDone => 'Done';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSearch => 'Search';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartQuantity => 'Quantity';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutShippingAddress => 'Shipping address';

  @override
  String get checkoutPaymentMethod => 'Payment method';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String get checkoutOrderConfirmed => 'Order confirmed';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'You haven\'t added any favorites yet';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'You have no notifications';

  @override
  String get homeGreeting => 'Find the right tires for your car';

  @override
  String get storeTitle => 'Store';

  @override
  String get servicesTitle => 'Services';

  @override
  String get reservationTitle => 'Reservation';
}
