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

  @override
  String get whatsappChat => 'Chat on WhatsApp';

  @override
  String guestLinkedMessage(int orders, int bookings) {
    return 'We linked $orders previous order(s) and $bookings booking(s) to your account.';
  }

  @override
  String get controlStartsWith => 'Control starts with';

  @override
  String get theRightTire => 'The right tire';

  @override
  String get heroSubtitle =>
      'Shop, book, and install—all in one place, Powered by the latest global tire service technologies';

  @override
  String get watchVideo => 'Watch Video';

  @override
  String get chooseYourTireNow => 'Choose Your Tire Now';

  @override
  String get searchByVehicle => 'Search by Vehicle';

  @override
  String get searchBySize => 'Search by Size';

  @override
  String get model => 'Model';

  @override
  String get selectModel => 'Select Model';

  @override
  String get year => 'Year';

  @override
  String get selectYear => 'Select year';

  @override
  String get make => 'Make';

  @override
  String get selectMake => 'Select Make';

  @override
  String get width => 'Width';

  @override
  String get selectWidth => 'Select width';

  @override
  String get aspectRatio => 'Aspect Ratio';

  @override
  String get selectAspectRatio => 'Select Aspect Ratio';

  @override
  String get rimDiameter => 'Rim Diameter';

  @override
  String get selectRimDiameter => 'Select Rim Diameter';

  @override
  String get findYourTireNow => 'Find Your Tire Now';

  @override
  String get recommendedTiresForYou => 'Recommended Tires for You';

  @override
  String get recommendedOffersForYou => 'Recommended Offers for You';

  @override
  String get showAll => 'Show all';

  @override
  String get allInOneSolutionsForYourVehicle =>
      'All-in-One Solutions for Your Vehicle';

  @override
  String get allInOneDescription =>
      'Find everything your vehicle needs in one place, from premium tires and dependable batteries to expert maintenance and installation services.';

  @override
  String get maintenanceServices => 'Maintenance Services';

  @override
  String get batteryInstallation => 'Battery Installation';

  @override
  String get tireInstallation => 'Tire Installation';

  @override
  String get quickAndEasyBooking => 'Quick and Easy Booking';

  @override
  String get bookYourCarServiceNow => 'Book Your Car Service Now!';

  @override
  String get bookServiceDescription =>
      'Schedule your vehicle service instantly with our professional team.';

  @override
  String get smartBookingSystemWithoutConflicts =>
      'Smart Booking System with No Scheduling Conflicts';

  @override
  String get professionalMaintenanceBySpecializedTeam =>
      'Professional Maintenance by a Specialized Team';

  @override
  String get chooseAppointmentAndBranch =>
      'Select the Appointment Time and Branch That Suit You Best';

  @override
  String get bookServiceNow => 'Book Your Service Now';

  @override
  String get whyChooseTireMax => 'Why Choose TireMax';

  @override
  String get tireMax => 'TireMax';

  @override
  String get genuineWarranty => 'Genuine Warranty';

  @override
  String get genuineWarrantyDescription =>
      'Get up to three years of instant replacement warranty on all tires and batteries.';

  @override
  String get routineMaintenance => 'Routine Maintenance';

  @override
  String get quickTurnaround => 'Quick Turnaround';

  @override
  String get fastServiceDescription =>
      'Our experienced technicians and state-of-the-art equipment guarantee tire installation within minutes.';

  @override
  String get whatOurCustomersSay => 'What Our Customers Say';

  @override
  String get testimonialName => 'Ahmad Mohamed';

  @override
  String get testimonialCity => 'Baghdad';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsDescription =>
      'Do you have a question or want to book a service? Our expert team is always here to help you and ensure your vehicle performs at its best.';

  @override
  String get customerServiceNumber => 'Customer Service Number';

  @override
  String get email => 'Email';

  @override
  String get headOffice => 'Head Office';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get store => 'Store';

  @override
  String get productCatalog => 'Product Catalog';

  @override
  String get offers => 'Offers';

  @override
  String get productCatalogDescription =>
      'Easily find the right tires and batteries for your vehicle.';

  @override
  String get filters => 'Filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get filtersDescription =>
      'Use the filters to find the right product based on size, price, and brand.';

  @override
  String get priceRange => 'Price range';

  @override
  String get brand => 'Brand';

  @override
  String get searchPlaceholder => 'Search for tires, batteries, or brands...';

  @override
  String get search => 'Search';

  @override
  String get filterBy => 'Filter by';

  @override
  String get all => 'All';

  @override
  String get tires => 'Tires';

  @override
  String get batteries => 'Batteries';

  @override
  String get bestSeller => 'Best seller';

  @override
  String get newBadge => 'New';

  @override
  String get bestChoice => 'Best choice';

  @override
  String get specialOffer => 'Special offer';

  @override
  String get noProducts => 'No products available';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get priceIncludesInstallationAndBalancing =>
      'The price includes installation and wheel balancing in Basra.';

  @override
  String get shippingAvailableAllGovernorates =>
      'Shipping is available to all governorates.';

  @override
  String get size => 'Size';

  @override
  String get countryOfOrigin => 'Country of Origin';

  @override
  String get treadPattern => 'Tread Pattern';

  @override
  String get manufactureYear => 'Manufacture year';

  @override
  String get usageType => 'Usage type';

  @override
  String get loadAndSpeed => 'Load and speed';

  @override
  String get availability => 'Availability';

  @override
  String get availableNow => 'Available now';

  @override
  String get notAvailable => 'Not available';

  @override
  String get dualWarrantySystem => 'Dual warranty system';

  @override
  String get cca => 'CCA';

  @override
  String get sizeCode => 'Size code';

  @override
  String get batteryType => 'Battery type';

  @override
  String get voltageAndCapacity => 'Voltage and capacity';

  @override
  String get manufacturesWarranty => 'Manufacture\'s warranty';

  @override
  String get manufacturesWarrantyDescription =>
      'warranty against manufacturing defects for a';

  @override
  String get months => 'months';

  @override
  String get authorizedWarranty => 'Authorized Warranty';

  @override
  String get tireMaxExclusiveMaintenance =>
      'Exclusive periodic maintenance and follow-up services provided by TireMax agency.';

  @override
  String get userReviews => 'User reviews';

  @override
  String get total => 'Total';

  @override
  String get iraqiDinar => 'Iraqi Dinar';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get completeVehicleServices =>
      'Complete Vehicle Services & Maintenance';

  @override
  String get completeVehicleServicesDescription =>
      'We provide all your vehicle maintenance needs under one roof at Tire Max Iraq, delivering premium quality, precision, speed, and a genuine warranty with every service.';

  @override
  String get bookNow => 'Book Now';

  @override
  String get modernTechnology => 'Modern Technology';

  @override
  String get modernTechnologyDescription =>
      'Unmatched precision in every digital inspection.';

  @override
  String get serviceJourneyTitle => 'Your Service Journey in 4 Simple Steps';

  @override
  String get whyChooseTireMaxServices => 'Why Choose Tire Max?';

  @override
  String get dedicatedSupport => 'Dedicated Support';

  @override
  String get dedicatedSupportDescription =>
      'Ongoing assistance, even after purchase.';

  @override
  String get dedicatedSupportDescriptionHighlight => 'even after purchase.';

  @override
  String get customerCareDescription =>
      'At Tire Max, we treat your vehicle as if it were our own. Our advanced system keeps you informed and supported, helping you stay safe on the road.';

  @override
  String get customerSatisfaction => 'Customer Satisfaction';

  @override
  String get ctaTitle => 'Ready to Keep Your Vehicle in Top Condition?';

  @override
  String get ctaDescription =>
      'Don\'t wait for a breakdown. Book your service appointment today and enjoy peace of mind and safer driving on the road.';

  @override
  String get bookYourAppointmentNow => 'Book Your Appointment Now';

  @override
  String get myOrders => 'My Orders';

  @override
  String get youHave => 'You Have';

  @override
  String get orderWord => 'Orders';

  @override
  String get reservationWord => 'Reservations';

  @override
  String get processing => 'Processing';

  @override
  String get onTheWay => 'On the Way';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get noOrdersYet => 'No orders yet';

  @override
  String get orderNumber => 'Order Number';

  @override
  String get viewDetails => 'View Details';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get manageBookingsDescription => 'Manage all your service bookings';

  @override
  String get noBookingYet => 'No bookings yet';

  @override
  String get bookingNumber => 'Booking Number';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get cancelBooking => 'Cancel Booking';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get grandTotal => 'Grand total';

  @override
  String get shippingFee => 'Shipping fee';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get discount => 'Discount';

  @override
  String get needHelp => 'Need Help?';

  @override
  String get supportDescription =>
      'Our support team is available around the clock to answer your questions and assist you.';

  @override
  String get chatWithAnExpert => 'Talk to an Expert';

  @override
  String get orderConfirmedSuccessfully =>
      'Your order has been confirmed successfully.';

  @override
  String get orderConfirmationMessage =>
      'Thank you for choosing Tire Max. We have received your order and are preparing it with the utmost care.';

  @override
  String get orderReference => 'Order reference';

  @override
  String get createAccountToTrack =>
      'Create an account to track your orders and get faster checkout next time.';

  @override
  String get createAccountCta => 'Create an account';

  @override
  String get branchPickup => 'Branch Pickup';

  @override
  String get estimatedDeliveryDate => 'Estimated Delivery Date';

  @override
  String get deliveryStatus => 'Delivery status';

  @override
  String get businessDays => 'Business Days';

  @override
  String get readyForPickup => 'Ready for pickup';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderDetailsDescription =>
      'View all your order details, delivery status, and payment information.';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String get keepOrder => 'Keep Order';

  @override
  String get cancelOrderWarning =>
      'You won\'t be able to restore the order once it has been canceled.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get shoppingCart => 'Shopping cart';

  @override
  String get emptyCart => 'Your cart is empty';

  @override
  String get goToShopping => 'Go to shopping';

  @override
  String get enterOfferCode => 'Enter offer code';

  @override
  String get apply => 'Apply';

  @override
  String get offerApplied => 'Offer applied';

  @override
  String get proceedToCheckout => 'Proceed to checkout';

  @override
  String get flexible72HourReturnGuarantee =>
      'Flexible 72-Hour Return Guarantee';

  @override
  String get easyReturnsAndExchangesDescription =>
      'Your satisfaction is protected! Enjoy easy returns and exchanges.';

  @override
  String get sixMonthAfterSalesSupport => '6-Month After-Sales Support';

  @override
  String get afterSalesSupportDescription =>
      'We\'re always here for you! Enjoy exceptional after-sales service.';

  @override
  String get checkout => 'Checkout';

  @override
  String get orderType => 'Order Type';

  @override
  String get delivery => 'Delivery';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberPlaceholder => '+98560054';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get emailPlaceholder => 'name@example.com';

  @override
  String get haveAnAccount => 'Have an account?';

  @override
  String get logIn => 'Log in';

  @override
  String get createAccountWithOrder => 'Create an account with this order';

  @override
  String get password => 'Password';

  @override
  String get passwordPlaceholder => 'Choose a password (min 6 characters)';

  @override
  String get branchLabel => 'Branch';

  @override
  String get selectBranch => 'Select branch';

  @override
  String get governorate => 'Governorate';

  @override
  String get selectGovernorate => 'Select governorate';

  @override
  String get fullAddress => 'Full address';

  @override
  String get fullAddressPlaceholder =>
      'Enter your street name, building or house number, and the nearest landmark...';

  @override
  String get notes => 'Notes';

  @override
  String get notesPlaceholder => 'Add notes';

  @override
  String get noPaymentMethodsAvailable => 'No payment methods available';

  @override
  String get confirmOrder => 'Confirm order';

  @override
  String get confirmOrderDisclaimer =>
      'By clicking \'Confirm Order,\' you agree to the Terms and Conditions.';

  @override
  String get accountNotCreated =>
      'Your order was placed, but we couldn\'t create the account.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get bookServiceAppointment => 'Book a Service Appointment';

  @override
  String get bookServiceAppointmentDescription =>
      'Choose the service and time that work best for you. We provide your vehicle with the highest level of care, precision, and efficiency.';

  @override
  String get chooseRequiredService => 'Choose the Service You Need';

  @override
  String get chooseNearestBranch => 'Choose the Branch Closest to You';

  @override
  String get chooseDateAndTime => 'Choose Your Preferred Date and Time';

  @override
  String get chooseDate => 'Choose a Date';

  @override
  String get chooseTime => 'Choose a Time';

  @override
  String get chooseDateFirst =>
      'Please select a date first to view available time slots.';

  @override
  String get noTimeAvailable =>
      'No available slots for this date. Please choose another date.';

  @override
  String get continueToConfirmation => 'Continue to Confirmation';

  @override
  String get bookingConfirmation => 'Booking Confirmation';

  @override
  String get reviewBookingDetails =>
      'Review your booking details before confirming.';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get service => 'Service';

  @override
  String get branch => 'Branch';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get estimatedCost => 'Estimated Cost';

  @override
  String get minute => 'Minute';

  @override
  String get free => 'Free';

  @override
  String get contactInformation => 'Contact information';

  @override
  String get confirmBookingButton => 'Confirm Booking';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get phoneRequired => 'Phone number is required';

  @override
  String get phoneInvalid =>
      'Enter a valid Iraqi phone number (e.g. 07701234567)';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get bookingDateInPast => 'Please choose a date and time in the future';

  @override
  String get bookingSuccess => 'Booking confirmed!';

  @override
  String get bookingReference => 'Booking reference';

  @override
  String get viewBooking => 'View booking';

  @override
  String get createAccountToTrackBookings =>
      'Create an account to track and manage your bookings.';

  @override
  String get importantNotes => 'Important Notes';

  @override
  String get arriveEarlyNote =>
      'Please arrive 10 minutes before your scheduled appointment.';

  @override
  String get lateArrivalNote =>
      'Late arrivals may result in your appointment being rescheduled.';

  @override
  String get modifyBookingNote =>
      'You may cancel or modify your booking up to 24 hours in advance.';

  @override
  String get chooseService => 'Choose a Service';

  @override
  String get chooseBranch => 'Choose a Branch';

  @override
  String get chooseAppointment => 'Choose an Appointment';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get step1 => 'Step 1';

  @override
  String get step2 => 'Step 2';

  @override
  String get step3 => 'Step 3';

  @override
  String get step4 => 'Step 4';

  @override
  String get chooseRequiredServiceDescription =>
      'Select the type of service required for your vehicle.';

  @override
  String get chooseThisService => 'Choose this service';

  @override
  String get chooseThisBranch => 'Choose this branch';

  @override
  String get selectedService => 'Selected Service';

  @override
  String get selectedBranch => 'Selected Branch';

  @override
  String get branchInformation => 'Branch Information';

  @override
  String get rate => 'Rate';

  @override
  String get km => 'KM';

  @override
  String get cost => 'Cost';

  @override
  String get duration => 'Duration';

  @override
  String get favorites => 'Favorites';

  @override
  String get savedProductsDescription => 'Products you\'ve saved for later.';

  @override
  String get noFavoriteProducts => 'You don\'t have favorite products yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsHeadingDescription =>
      'Stay up to date with the latest updates on your orders and bookings';

  @override
  String get bestTiresInIraq => 'Best Tires in Iraq';

  @override
  String get chooseYourPerfectTire =>
      'Choose the Right Tire for Iraq\'s Summer';

  @override
  String get chooseYourPerfectTireDescription =>
      'Carefully selected options that provide a safe and comfortable driving experience throughout the summer.';

  @override
  String get youDontHaveNotifications => 'You don\'t have any notifications';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get webProfileWelcome => 'Welcome';

  @override
  String get webProfileAddresses => 'Addresses';

  @override
  String get webProfileSettings => 'Settings';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get bookNewService => 'Book a New Service';

  @override
  String get viewAll => 'View All';

  @override
  String get upcomingBookings => 'Upcoming Bookings';

  @override
  String get primaryAddress => 'Primary Address';

  @override
  String get profileFullName => 'Full Name';

  @override
  String get profilePhoneNumber => 'Phone Number';

  @override
  String get edit => 'Edit';

  @override
  String get profilePersonalInformation => 'Personal Information';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get noReservationYet => 'No reservation yet';

  @override
  String get noAddressYet => 'You haven\'t added an address yet';

  @override
  String get manageAddressesDescription => 'Manage your delivery addresses';

  @override
  String get savedAddresses => 'Saved Addresses';

  @override
  String get addAddress => 'Add Address';

  @override
  String get defaultAddress => 'Default Address';

  @override
  String get setAsDefaultAddress => 'Set as Default Address';

  @override
  String get setAsDefaultAddressWarning =>
      'Are you sure you want to set this address as your default address?';

  @override
  String get set => 'Set';

  @override
  String get removeAddress => 'Remove Address';

  @override
  String get removeAddressWarning =>
      'Are you sure you want to remove this address? This action cannot be undone.';

  @override
  String get remove => 'Remove';

  @override
  String get cancel => 'Cancel';

  @override
  String get city => 'City';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectCityIsRequired => 'City selection is required';

  @override
  String get selectGovernorateIsRequired => 'Governorate selection is required';

  @override
  String get theAddressIsRequired => 'Address is required';

  @override
  String get theAddressMustBeMoreThen12Character =>
      'The address must be more than 12 characters';

  @override
  String get profileFullAddress => 'Full Address';

  @override
  String get profileFullAddressPlaceholder =>
      'Enter your street name, house number, and nearest landmark...';

  @override
  String get createAddress => 'Add Address';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get accountSettingsDescription =>
      'Manage your personal information and security settings';

  @override
  String get profileEmail => 'Email Address';

  @override
  String get securityAndPassword => 'Security & Password';

  @override
  String get profileConfirmPassword => 'Confirm Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get orderUpdates => 'Order Updates';

  @override
  String get orderUpdatesDescription =>
      'Receive notifications about your order status';

  @override
  String get offersAndDiscounts => 'Offers & Discounts';

  @override
  String get offersAndDiscountsDescription =>
      'Receive notifications about special offers';

  @override
  String get newsletter => 'Newsletter';

  @override
  String get newsletterDescription => 'Get the latest news and product updates';

  @override
  String get smsMessages => 'SMS Messages';

  @override
  String get smsMessagesDescription =>
      'Receive text messages for important updates';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get passwordsMustMatch => 'Passwords must match';

  @override
  String get passwordConfirmationRequired =>
      'Password confirmation is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters long';

  @override
  String get emailMaxLength => 'Email must not exceed 120 characters';

  @override
  String get nameMaxLength => 'Name must not exceed 120 characters';

  @override
  String get nameMinLength => 'Name must be at least 6 characters long';

  @override
  String get emailPlaceholderProfile => 'example@example.com';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get authLogin => 'Login';

  @override
  String get authRegister => 'Register';

  @override
  String get authWelcome => 'Welcome';

  @override
  String get enterEmailOrPhoneNumber => 'Enter your email or phone number';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get enterAddress => 'Enter your address';

  @override
  String get logoutTitle => 'Log out';

  @override
  String get logoutWarning =>
      'Are you sure you want to log out? You\'ll be redirected to the home page.';

  @override
  String get logoutConfirm => 'Log out';

  @override
  String get logoutCancel => 'Cancel';

  @override
  String get testimonials0 =>
      'The best tire service in Baghdad. Punctual appointments, highly competitive prices, and the laser wheel balancing made a noticeable difference in my driving experience.';

  @override
  String get testimonials1 =>
      'The warranty is truly genuine. I had a minor issue with one of the tires, and it was replaced immediately with no hassle at all. I highly recommend them.';

  @override
  String get testimonials2 =>
      'A very smooth purchase experience on the website. I booked an appointment and went to the branch, and my tires were installed in less than 15 minutes. Thank you, TireMax.';

  @override
  String get journey0Title => 'Choose a Service';

  @override
  String get journey0Desc => 'Browse our services and select the one you need.';

  @override
  String get journey1Title => 'Schedule Your Appointment';

  @override
  String get journey1Desc => 'Pick the date and time that work best for you.';

  @override
  String get journey2Title => 'Visit Our Service Center';

  @override
  String get journey2Desc => 'Our team will be ready to welcome you.';

  @override
  String get journey3Title => 'Pick Up Your Vehicle';

  @override
  String get journey3Desc =>
      'Collect your vehicle, fully serviced and backed by our service warranty.';

  @override
  String get whyChoose0Title => 'Certified Experts';

  @override
  String get whyChoose0Desc =>
      'Our internationally trained technicians deliver trusted expertise.';

  @override
  String get whyChoose1Title => 'Advanced Equipment';

  @override
  String get whyChoose1Desc => 'Powered by the latest inspection technology.';

  @override
  String get whyChoose2Title => 'Fast Turnaround';

  @override
  String get whyChoose2Desc =>
      'We value your time and complete services efficiently.';

  @override
  String get whyChoose3Title => 'Service Warranty';

  @override
  String get whyChoose3Desc => 'Confidence that extends beyond the repair.';

  @override
  String get whyChoose4Title => 'Exceptional Precision';

  @override
  String get whyChoose4Desc =>
      'Attention to every detail for outstanding results.';

  @override
  String get features0Title => 'Smart Reminders';

  @override
  String get features0Desc =>
      'Automatic reminders for oil changes and tire replacements.';

  @override
  String get features1Title => '24/7 Technical Support';

  @override
  String get features1Desc =>
      'Our experts are available anytime to answer your questions.';

  @override
  String get features2Title => 'Free Inspections';

  @override
  String get features2Desc =>
      'Complimentary tire pressure and tire safety checks for our customers.';

  @override
  String get features3Title => 'Extended Warranty';

  @override
  String get features3Desc =>
      'Enjoy added peace of mind with our genuine warranty plans.';

  @override
  String get privacyPolicyDescription =>
      'At Tire Max Iraq, we are committed to protecting your privacy and ensuring the security of your personal data. This policy explains how we handle your information with transparency and care.';

  @override
  String get dataCollection => 'Data Collection';

  @override
  String get dataCollectionDescription =>
      'We collect information that you provide directly to us when using our services, including:';

  @override
  String get vehicleData =>
      'Vehicle Data: Vehicle type, tire size, and maintenance history.';

  @override
  String get paymentInformation =>
      'Payment Information: Financial transaction details (processed through encrypted channels).';

  @override
  String get locationData =>
      'Location Data: To provide roadside assistance services and locate the nearest branch.';

  @override
  String get howWeUseInformation => 'How We Use Information';

  @override
  String get howWeUseInformationDescription =>
      'We use your data to improve your driving experience, personalize technical offers, and ensure tire safety through regular maintenance reminders. We do not sell your data to third parties for marketing purposes.';

  @override
  String get dataProtection => 'Data Protection';

  @override
  String get dataProtectionDescription =>
      'We implement military-grade encryption protocols (AES-256) to protect our databases. Access to personal information is restricted to employees who need it to serve you.';

  @override
  String get userRights => 'User Rights';

  @override
  String get userRightsDescription =>
      'You have the full right to access your data, correct it, or request its permanent deletion from our systems. You may also object to the processing of your data at any time.';

  @override
  String get havePrivacyQuestions => 'Have Questions About Privacy?';

  @override
  String get havePrivacyQuestionsDescription =>
      'Our legal and technical teams are ready to answer all your questions.';

  @override
  String get termsAndConditionsDescription =>
      'Welcome to Tire Max Iraq. These Terms and Conditions govern your use of our website and services. By accessing our services, you agree to be bound by these terms in full.';

  @override
  String get introductionParagraph1 =>
      'This agreement is entered into between you and Tire Max Iraq. These terms apply to all visitors, users, and others who access or use the service.';

  @override
  String get introductionParagraph2 =>
      'Please read these terms carefully before using the website. If you do not agree to any part of these terms, you may not access the service.';

  @override
  String get informationAccuracy => 'Information Accuracy';

  @override
  String get informationAccuracyDescription =>
      'All information provided during registration must be accurate, current, and complete.';

  @override
  String get accountSecurity => 'Account Security';

  @override
  String get accountSecurityDescription =>
      'You are responsible for maintaining the confidentiality of your password and for all activities that occur under your account.';

  @override
  String get purchasesAndPaymentsParagraph1 =>
      'We reserve the right to refuse or cancel your order at any time for certain reasons, including but not limited to product availability, errors in product descriptions or pricing, or errors in your order.';

  @override
  String get purchasesAndPaymentsParagraph2 =>
      'Payments are made in Iraqi Dinar according to the exchange rate announced by the store.';

  @override
  String get purchasesAndPaymentsParagraph3 =>
      'We use secure and encrypted payment gateways to protect your financial information.';

  @override
  String get warrantiesDescription =>
      'All tires sold through Tire Max Iraq come with a manufacturer\'s warranty against manufacturing defects. Warranty periods and conditions vary by brand and model. The warranty does not cover damage resulting from:';

  @override
  String get misuse => 'Misuse';

  @override
  String get incorrectInstallation =>
      'Incorrect Installation Outside Our Centers';

  @override
  String get improperStorage => 'Improper Storage';

  @override
  String get limitationOfLiabilityParagraph1 =>
      'Under no circumstances shall Tire Max Iraq, its directors, employees, or partners be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, use, or goodwill.';

  @override
  String get limitationOfLiabilityParagraph2 =>
      'We strive to provide the most accurate information, but we do not guarantee that the website will be free from technical or typographical errors.';

  @override
  String get lastUpdated => 'Last Updated: May 20, 2024';

  @override
  String get contactMessageSent =>
      'Your message has been sent. We will get back to you soon.';

  @override
  String get inquirySubject => 'Inquiry Subject';

  @override
  String get inquiryAboutPrices => 'Inquiry about prices';

  @override
  String get message => 'Message';

  @override
  String get howCanWeHelpYouToday => 'How can we help you today';

  @override
  String get sendMessage => 'Send message';

  @override
  String get orContactImmediatelyVia => 'Or contact us instantly via:';

  @override
  String get required => 'Reference and phone number are required';

  @override
  String get notFound => 'No order or booking found for these details';

  @override
  String get error => 'Something went wrong, please try again';

  @override
  String get title => 'Track your order or booking';

  @override
  String get description =>
      'Enter your reference number and the phone number used when ordering.';

  @override
  String get reference => 'Reference';

  @override
  String get track => 'Track';

  @override
  String get address => 'Address';

  @override
  String get price => 'Price';

  @override
  String get cancelBookingWarning =>
      'You won\'t be able to restore the booking once it has been canceled.';

  @override
  String get keepBooking => 'Keep Booking';

  @override
  String get rescheduleBooking => 'Reschedule Booking';

  @override
  String get rescheduleBookingWarning =>
      'Rescheduling will cancel your current booking. Are you sure?';

  @override
  String get status => 'Status';

  @override
  String get headerBookNow => 'Book now';

  @override
  String get now => 'Now!';

  @override
  String get phoneNumberMaxLength => 'Phone number must not exceed 20 digits';

  @override
  String get clearCartQuestion => 'Clear cart?';

  @override
  String get clearCartBody => 'This will remove all items from your cart.';

  @override
  String get clear => 'Clear';

  @override
  String get clearCartTooltip => 'Clear cart';

  @override
  String get bookYourCarService => 'Book Your Car Service';

  @override
  String get whyChoosePrefix => 'Why Choose ';

  @override
  String get bookingDetail => 'Booking Detail';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get dateAndTime => 'Date & Time';

  @override
  String get couldNotCancelBooking => 'Could not cancel the booking.';

  @override
  String get couldNotRescheduleBooking => 'Could not reschedule the booking.';

  @override
  String get noServicesAvailable => 'No services available.';

  @override
  String get noBranchesAvailable => 'No branches available.';

  @override
  String get selectADate => 'Select a date';

  @override
  String get ongoingAssistancePrefix => 'Ongoing assistance, ';

  @override
  String get privacyPersonalInformation =>
      'Personal Information: Name, email address, and phone number.';

  @override
  String get legalSectionIntroduction => 'Introduction';

  @override
  String get legalSectionUserObligations => 'User Obligations';

  @override
  String get legalSectionPurchasesAndPayments => 'Purchases & Payments';

  @override
  String get legalSectionWarranties => 'Warranties';

  @override
  String get legalSectionLimitationOfLiability => 'Limitation of Liability';

  @override
  String minutesCount(int count) {
    return '$count min';
  }

  @override
  String get couldNotCancelOrder => 'Could not cancel the order.';

  @override
  String get bookingFailed => 'Booking failed.';

  @override
  String get couldNotPlaceOrder => 'Could not place order.';

  @override
  String get pleaseFillRequiredFields => 'Please fill in all required fields.';

  @override
  String get phoneMax20 => 'Phone number must not exceed 20 digits';

  @override
  String get addressMax255 => 'The address must not exceed 255 characters';

  @override
  String get setAsDefault => 'Set as default';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameMax120 => 'Name must be at most 120 characters';

  @override
  String get phoneMax30 => 'Phone number must be at most 30 characters';

  @override
  String get subjectRequired => 'Subject is required';

  @override
  String get subjectMax190 => 'Subject must be at most 190 characters';

  @override
  String get messageRequired => 'Message is required';

  @override
  String get messageMax5000 => 'Message must be at most 5000 characters';

  @override
  String get errTimeout => 'The connection timed out. Please try again.';

  @override
  String get errConnection =>
      'Could not connect to the server. Check your internet connection.';

  @override
  String get errCancelled => 'The request was cancelled.';

  @override
  String get errBadCertificate =>
      'A secure connection could not be established.';

  @override
  String get errSomethingWrongTryAgain =>
      'Something went wrong. Please try again.';

  @override
  String get errUnexpected => 'An unexpected error occurred.';

  @override
  String get somethingWentWrongPeriod => 'Something went wrong.';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusComplete => 'Completed';

  @override
  String get statusRescheduled => 'Rescheduled';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusFailed => 'Failed';

  @override
  String get iqdLabel => 'IQD';

  @override
  String get timeAm => 'AM';

  @override
  String get timePm => 'PM';

  @override
  String get bookingNotesHint => 'e.g. Please check wheel balance too';

  @override
  String get trafficAccidents => 'Traffic Accidents';

  @override
  String get viewCart => 'View cart';

  @override
  String get addToFavoritesLabel => 'Add to favorites';

  @override
  String get removeFromFavoritesLabel => 'Remove from favorites';

  @override
  String get emptyStateDefaultTitle => 'Nothing here yet';

  @override
  String resultsCount(int count) {
    return '$count results';
  }

  @override
  String get sectionDescription => 'Description';

  @override
  String get sectionSpecs => 'Specifications';

  @override
  String get sectionWarranty => 'Warranty';

  @override
  String get noReviews => 'No reviews yet';

  @override
  String get productCopied => 'Product details copied';

  @override
  String get shareProduct => 'Share';

  @override
  String durationMinutes(int n) {
    return '$n min';
  }

  @override
  String get loadMoreFailed => 'Could not load more products';

  @override
  String get next => 'Next';

  @override
  String get copyReference => 'Copy';

  @override
  String get referenceCopied => 'Reference copied';

  @override
  String get undo => 'Undo';

  @override
  String get itemRemoved => 'Item removed';

  @override
  String get haveOfferCode => 'Have an offer code?';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String stepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get viewOrder => 'View order';

  @override
  String get profileSectionActivity => 'Activity';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionSupport => 'Support & legal';

  @override
  String get notificationsToday => 'Today';

  @override
  String get notificationsEarlier => 'Earlier';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get orderProgress => 'Order progress';

  @override
  String get bookingProgress => 'Booking progress';

  @override
  String get orderStepPlaced => 'Placed';
}
