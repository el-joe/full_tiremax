// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تايرماكس';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navStore => 'المتجر';

  @override
  String get navServices => 'الخدمات';

  @override
  String get navReservation => 'الحجز';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authEmailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get authEmailOrPhoneRequired =>
      'البريد الإلكتروني أو رقم الهاتف مطلوب';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authPasswordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get authFullName => 'الاسم الكامل';

  @override
  String get authFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get authNameTooLong => 'الاسم طويل جدًا';

  @override
  String get authPhoneNumber => 'رقم الهاتف';

  @override
  String get authPhoneNumberRequired => 'رقم الهاتف مطلوب';

  @override
  String get authPhoneTooLong => 'رقم الهاتف طويل جدًا';

  @override
  String get authEmailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get authEmailTooLong => 'البريد الإلكتروني طويل جدًا';

  @override
  String get authInvalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get authConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور';

  @override
  String get authPasswordsMustMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get authAddressOptional => 'العنوان (اختياري)';

  @override
  String get authAddressTooLong => 'العنوان طويل جدًا';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String profileWelcome(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get profileSettings => 'الإعدادات';

  @override
  String get profileAddresses => 'العناوين';

  @override
  String get profileMyOrders => 'طلباتي';

  @override
  String get profileMyBookings => 'حجوزاتي';

  @override
  String get profileLanguage => 'اللغة';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageArabic => 'العربية';

  @override
  String get profilePrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get profileTerms => 'الشروط والأحكام';

  @override
  String get profileLogOut => 'تسجيل الخروج';

  @override
  String get profileLogOutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonOk => 'حسنًا';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonLoading => 'جارٍ التحميل...';

  @override
  String get commonError => 'حدث خطأ ما';

  @override
  String get commonEmpty => 'لا يوجد شيء لعرضه هنا بعد';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonAddToCart => 'أضف إلى السلة';

  @override
  String get commonBuyNow => 'اشترِ الآن';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonDone => 'تم';

  @override
  String get commonSubmit => 'إرسال';

  @override
  String get commonRemove => 'إزالة';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonSearch => 'بحث';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartEmpty => 'سلتك فارغة';

  @override
  String get cartCheckout => 'الدفع';

  @override
  String get cartSubtotal => 'المجموع الفرعي';

  @override
  String get cartTotal => 'الإجمالي';

  @override
  String get cartQuantity => 'الكمية';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get checkoutShippingAddress => 'عنوان الشحن';

  @override
  String get checkoutPaymentMethod => 'طريقة الدفع';

  @override
  String get checkoutPlaceOrder => 'تأكيد الطلب';

  @override
  String get checkoutOrderConfirmed => 'تم تأكيد الطلب';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmpty => 'لم تقم بإضافة أي عناصر إلى المفضلة بعد';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsEmpty => 'لا توجد لديك إشعارات';

  @override
  String get homeGreeting => 'اعثر على الإطارات المناسبة لسيارتك';

  @override
  String get storeTitle => 'المتجر';

  @override
  String get servicesTitle => 'الخدمات';

  @override
  String get reservationTitle => 'الحجز';

  @override
  String get whatsappChat => 'تواصل عبر واتساب';

  @override
  String guestLinkedMessage(int orders, int bookings) {
    return 'تم ربط $orders طلب و$bookings حجز سابق بحسابك.';
  }

  @override
  String get controlStartsWith => 'التحكم يبدأ من';

  @override
  String get theRightTire => 'الإطار المناسب';

  @override
  String get heroSubtitle =>
      'تسوّق واحجز وقم بالتركيب — كل ذلك في مكان واحد، مدعوم بأحدث تقنيات خدمات الإطارات العالمية';

  @override
  String get watchVideo => 'شاهد الفيديو';

  @override
  String get chooseYourTireNow => 'اختر إطارك الآن';

  @override
  String get searchByVehicle => 'البحث بالسيارة';

  @override
  String get searchBySize => 'البحث بالمقاس';

  @override
  String get model => 'الموديل';

  @override
  String get selectModel => 'اختر الموديل';

  @override
  String get year => 'سنة الصنع';

  @override
  String get selectYear => 'اختر سنة الصنع';

  @override
  String get make => 'الماركة';

  @override
  String get selectMake => 'اختر النوع';

  @override
  String get width => 'العرض';

  @override
  String get selectWidth => 'اختر العرض';

  @override
  String get aspectRatio => 'نسبة الارتفاع';

  @override
  String get selectAspectRatio => 'اختر نسبة الارتفاع';

  @override
  String get rimDiameter => 'قطر الجنط';

  @override
  String get selectRimDiameter => 'اختر قطر الجنط';

  @override
  String get findYourTireNow => 'اعثر على إطارك الآن';

  @override
  String get recommendedTiresForYou => 'إطارات مختارة لك';

  @override
  String get recommendedOffersForYou => 'عروض مختارة لك';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get allInOneSolutionsForYourVehicle => 'حلول متكاملة لسيارتك';

  @override
  String get allInOneDescription =>
      'نوفر لك كل ما تحتاجه لسيارتك في مكان واحد، من إطارات عالية الجودة وبطاريات موثوقة إلى خدمات الصيانة والتركيب بأعلى مستوى من الاحترافية.';

  @override
  String get maintenanceServices => 'خدمات الصيانه';

  @override
  String get batteryInstallation => 'تركيب البطاريات';

  @override
  String get tireInstallation => 'تركيب الإطارات';

  @override
  String get quickAndEasyBooking => 'حجز سريع وسهل';

  @override
  String get bookYourCarServiceNow => 'احجز صيانة سيارتك الآن!';

  @override
  String get bookServiceDescription =>
      'احصل على موعد فوري لصيانة سيارتك مع فريقنا المتخصص';

  @override
  String get smartBookingSystemWithoutConflicts => 'نظام حجز ذكي بدون تداخل';

  @override
  String get professionalMaintenanceBySpecializedTeam =>
      'صيانة احترافية من فريق متخصص';

  @override
  String get chooseAppointmentAndBranch => 'اختر الموعد والفرع المناسب لك';

  @override
  String get bookServiceNow => 'احجز موعد الصيانة الآن';

  @override
  String get whyChooseTireMax => 'لماذا تختار TireMax';

  @override
  String get tireMax => 'TireMax';

  @override
  String get genuineWarranty => 'ضمان حقيقي';

  @override
  String get genuineWarrantyDescription =>
      'ضمان استبدال فوري يصل لثلاث سنوات على جميع الإطارات والبطاريات.';

  @override
  String get routineMaintenance => 'صيانه دوريه';

  @override
  String get quickTurnaround => 'سرعة الإنجاز';

  @override
  String get fastServiceDescription =>
      'فريق عمل مدرب وأجهزة حديثة لضمان تركيب الإطارات في دقائق معدودة.';

  @override
  String get whatOurCustomersSay => 'آراء عملائنا';

  @override
  String get testimonialName => 'أحمد محمد';

  @override
  String get testimonialCity => 'بغداد';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get contactUsDescription =>
      'هل لديك استفسار أو ترغب في حجز خدمة؟ فريقنا المتخصص متواجد دائماً لمساعدتك وضمان أفضل أداء لسيارتك.';

  @override
  String get customerServiceNumber => 'الرقم الموحد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get headOffice => 'المقر الرئيسي';

  @override
  String get trackOrder => 'تتبع الطلب';

  @override
  String get store => 'المتجر';

  @override
  String get productCatalog => 'كتالوج المنتجات';

  @override
  String get offers => 'العروض';

  @override
  String get productCatalogDescription =>
      'اكتشف أفضل الإطارات والبطاريات المناسبة لسيارتك بسهولة.';

  @override
  String get filters => 'الفلاتر';

  @override
  String get clearFilters => 'مسح الكل';

  @override
  String get filtersDescription =>
      'استخدم الفلاتر لاختيار المنتج المناسب حسب المقاس، السعر، والماركة';

  @override
  String get priceRange => 'النطاق السعري';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get searchPlaceholder =>
      'ابحث عن إطارات، بطاريات، أو علامات تجارية...';

  @override
  String get search => 'بحث';

  @override
  String get filterBy => 'فلترحسب';

  @override
  String get all => 'الكل';

  @override
  String get tires => 'الإطارات';

  @override
  String get batteries => 'البطاريات';

  @override
  String get bestSeller => 'الأكثر مبيعًا';

  @override
  String get newBadge => 'جديد';

  @override
  String get bestChoice => 'الاختيار الأفضل';

  @override
  String get specialOffer => 'عرض خاص';

  @override
  String get noProducts => 'لا توجد منتجات متاحة';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get addedToCart => 'تمت الإضافة إلى سلة التسوق';

  @override
  String get priceIncludesInstallationAndBalancing =>
      'السعر يشمل التركيب والترصيص داخل البصرة';

  @override
  String get shippingAvailableAllGovernorates =>
      'تتوفر خدمة الشحن لكافة المحافظات';

  @override
  String get size => 'القياس';

  @override
  String get countryOfOrigin => 'بلد المنشأ';

  @override
  String get treadPattern => 'النقشة';

  @override
  String get manufactureYear => 'سنة الإنتاج';

  @override
  String get usageType => 'نوع الاستخدام';

  @override
  String get loadAndSpeed => 'الحمولة والسرعة';

  @override
  String get availability => 'حالة التوفر';

  @override
  String get availableNow => 'متوفر الآن';

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get dualWarrantySystem => 'نظام الضمان المزدوج';

  @override
  String get cca => 'تيار بدء التشغيل البارد (CCA)';

  @override
  String get sizeCode => 'رمز المقاس';

  @override
  String get batteryType => 'نوع البطارية';

  @override
  String get voltageAndCapacity => 'الجهد والسعة';

  @override
  String get manufacturesWarranty => 'ضمان مصنعي';

  @override
  String get manufacturesWarrantyDescription =>
      'ضمان من الشركة المصنعة ضد عيوب التصنيع لمدة';

  @override
  String get months => 'شهر';

  @override
  String get authorizedWarranty => 'ضمان وكالة';

  @override
  String get tireMaxExclusiveMaintenance =>
      'خدمة صيانة ومتابعة دورية مقدمة حصرياً من وكاله TireMax.';

  @override
  String get userReviews => 'تقييمات المستخدمين';

  @override
  String get total => 'المجموع الكلي';

  @override
  String get iraqiDinar => 'دينار عراقي';

  @override
  String get addToCart => 'إضافة إلى السلة';

  @override
  String get completeVehicleServices => 'خدمات وصيانة متكاملة لسيارتك';

  @override
  String get completeVehicleServicesDescription =>
      'نقدم لك جميع خدمات صيانة السيارات بأعلى جودة تحت سقف واحد في تير ماكس العراق. دقة، سرعة، وضمان حقيقي لكل خدمة نقدمها.';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get modernTechnology => 'تكنولوجيا حديثة';

  @override
  String get modernTechnologyDescription => 'دقة لا تضاهى في كل فحص رقمي.';

  @override
  String get serviceJourneyTitle => 'رحلة خدمتك في 4 خطوات';

  @override
  String get whyChooseTireMaxServices => 'لماذا تختار Tire Max؟';

  @override
  String get dedicatedSupport => 'دعم مخصص';

  @override
  String get dedicatedSupportDescription => 'رعاية تمتد لما بعد البيع.';

  @override
  String get dedicatedSupportDescriptionHighlight => 'لما بعد البيع.';

  @override
  String get customerCareDescription =>
      'في تاير ماكس، نهتم بسيارتك وكأنها سيارتنا. نظامنا المتطور يضمن لك المتابعة المستمرة لتبقى دائماً في أمان على الطريق.';

  @override
  String get customerSatisfaction => 'رضا العملاء';

  @override
  String get ctaTitle => 'جاهز تخلي سيارتك في أفضل حالة؟';

  @override
  String get ctaDescription =>
      'لا تنتظر حدوث عطل، بادر بحجز موعد صيانة اليوم واستمتع براحة البال والقيادة الآمنة على الطريق.';

  @override
  String get bookYourAppointmentNow => 'احجز موعدك الآن';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get youHave => 'لديك';

  @override
  String get orderWord => 'طلبات';

  @override
  String get reservationWord => 'الحجوزات';

  @override
  String get processing => 'قيد المعالجة';

  @override
  String get onTheWay => 'في الطريق';

  @override
  String get delivered => 'تم التوصيل';

  @override
  String get cancelled => 'ملغي';

  @override
  String get noOrdersYet => 'لا توجد طلبات بعد';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get manageBookingsDescription => 'إدارة جميع حجوزات الخدمات الخاصة بك';

  @override
  String get noBookingYet => 'لا توجد حجوزات بعد';

  @override
  String get bookingNumber => 'رقم الحجز';

  @override
  String get reschedule => 'إعادة الجدولة';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get grandTotal => 'الإجمالي النهائي';

  @override
  String get shippingFee => 'رسوم الشحن';

  @override
  String get subtotal => 'الإجمالي الفرعي';

  @override
  String get discount => 'الخصم';

  @override
  String get needHelp => 'تحتاج مساعدة؟';

  @override
  String get supportDescription =>
      'فريق الدعم الفني جاهز للإجابة على استفساراتكم على مدار الساعة.';

  @override
  String get chatWithAnExpert => 'تحدث مع خبير';

  @override
  String get orderConfirmedSuccessfully => 'تم تأكيد طلبك بنجاح';

  @override
  String get orderConfirmationMessage =>
      'شكراً لثقتك بـ Tire Max. لقد تم استلام طلبك وبدأنا في تجهيزه بكل عناية.';

  @override
  String get orderReference => 'رقم الطلب';

  @override
  String get createAccountToTrack =>
      'أنشئ حساباً لتتبع طلباتك وإتمام الشراء بسرعة في المرة القادمة.';

  @override
  String get createAccountCta => 'إنشاء حساب';

  @override
  String get branchPickup => 'استلام من الفرع';

  @override
  String get estimatedDeliveryDate => 'موعد التوصيل المتوقع';

  @override
  String get deliveryStatus => 'حالة التوصيل';

  @override
  String get businessDays => 'أيام عمل';

  @override
  String get readyForPickup => 'جاهز للاستلام';

  @override
  String get paymentMethod => 'طرق الدفع';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderDetailsDescription =>
      'استعرض جميع تفاصيل طلبك وحالة التوصيل ومعلومات الدفع.';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get keepOrder => 'الاحتفاظ بالطلب';

  @override
  String get cancelOrderWarning => 'لن تتمكن من استعادة الطلب بعد إلغائه.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get shoppingCart => 'سلة التسوق';

  @override
  String get emptyCart => 'السلة فارغة';

  @override
  String get goToShopping => 'الذهاب للتسوق';

  @override
  String get enterOfferCode => 'أدخل كود الخصم';

  @override
  String get apply => 'تطبيق';

  @override
  String get offerApplied => 'تم تطبيق العرض';

  @override
  String get proceedToCheckout => 'تابع عملية الشراء';

  @override
  String get flexible72HourReturnGuarantee => 'ضمان استرجاع مرن خلال 72 ساعة';

  @override
  String get easyReturnsAndExchangesDescription =>
      'حقك محفوظ! إمكانية الإرجاع والتبديل بكل سهولة.';

  @override
  String get sixMonthAfterSalesSupport => 'دعم ما بعد البيع لمدة 6 شهور';

  @override
  String get afterSalesSupportDescription =>
      'نحن معك دائماً! خدمات ما بعد البيع المتميزة.';

  @override
  String get checkout => 'إتمام الشراء';

  @override
  String get orderType => 'نوع الطلب';

  @override
  String get delivery => 'توصيل';

  @override
  String get personalInformation => 'البيانات الشخصيه';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterYourFullName => 'أدخل اسمك الثلاثي';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberPlaceholder => '+98560054';

  @override
  String get emailOptional => 'البريد الإلكتروني (اختياري)';

  @override
  String get emailPlaceholder => 'name@example.com';

  @override
  String get haveAnAccount => 'لديك حساب؟';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get createAccountWithOrder => 'إنشاء حساب مع هذا الطلب';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordPlaceholder => 'اختر كلمة مرور (6 أحرف على الأقل)';

  @override
  String get branchLabel => 'الفرع';

  @override
  String get selectBranch => 'اختر الفرع';

  @override
  String get governorate => 'المحافظة';

  @override
  String get selectGovernorate => 'أختر المحافظة';

  @override
  String get fullAddress => 'العنوان بالتفصيل';

  @override
  String get fullAddressPlaceholder =>
      'أدخل الشارع، رقم الدار، أقرب نقطة دالة لموقعك...';

  @override
  String get notes => 'الملاحظات';

  @override
  String get notesPlaceholder => 'ادخل الملاحظات';

  @override
  String get noPaymentMethodsAvailable => 'لا توجد طرق دفع متاحة';

  @override
  String get confirmOrder => 'تأكيد الطلب و التوصيل';

  @override
  String get confirmOrderDisclaimer =>
      'بالنقر على \'تأكيد الطلب\'، فإنك توافق على الشروط والأحكام.';

  @override
  String get accountNotCreated => 'تم تسجيل طلبك، لكن تعذّر إنشاء الحساب.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get bookServiceAppointment => 'احجز موعد الصيانة';

  @override
  String get bookServiceAppointmentDescription =>
      'اختر الخدمة والوقت المناسب لك. نحن نضمن لك أفضل رعاية لسيارتك بدقة وكفاءة عالية.';

  @override
  String get chooseRequiredService => 'اختر الخدمة التي تحتاجها';

  @override
  String get chooseNearestBranch => 'اختر الفرع الأقرب لك';

  @override
  String get chooseDateAndTime => 'اختر التاريخ والوقت المناسب';

  @override
  String get chooseDate => 'اختر التاريخ';

  @override
  String get chooseTime => 'اختر الوقت';

  @override
  String get chooseDateFirst => 'اختر التاريخ أولاً لعرض الأوقات المتاحة';

  @override
  String get noTimeAvailable =>
      'لا توجد أوقات متاحة لهذا التاريخ. يرجى اختيار تاريخ آخر.';

  @override
  String get continueToConfirmation => 'متابعة للتأكيد';

  @override
  String get bookingConfirmation => 'تأكيد الحجز';

  @override
  String get reviewBookingDetails => 'راجع تفاصيل حجزك قبل التأكيد';

  @override
  String get bookingSummary => 'ملخص الحجز';

  @override
  String get service => 'الخدمة';

  @override
  String get branch => 'الفرع';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get estimatedCost => 'التكلفة المتوقعة';

  @override
  String get minute => 'دقيقة';

  @override
  String get free => 'مجاني';

  @override
  String get contactInformation => 'معلومات التواصل';

  @override
  String get confirmBookingButton => 'تأكيد الحجز';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get phoneInvalid => 'أدخل رقم هاتف عراقي صحيح (مثال 07701234567)';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get bookingDateInPast => 'يرجى اختيار تاريخ ووقت في المستقبل';

  @override
  String get bookingSuccess => 'تم تأكيد الحجز!';

  @override
  String get bookingReference => 'رقم الحجز';

  @override
  String get viewBooking => 'عرض الحجز';

  @override
  String get createAccountToTrackBookings =>
      'أنشئ حساباً لتتبع حجوزاتك وإدارتها.';

  @override
  String get importantNotes => 'ملاحظات هامة';

  @override
  String get arriveEarlyNote => 'يرجى الحضور قبل الموعد بـ 10 دقائق';

  @override
  String get lateArrivalNote => 'في حالة التأخير، قد يتم تأجيل الموعد';

  @override
  String get modifyBookingNote => 'يمكنك إلغاء أو تعديل الحجز قبل 24 ساعة';

  @override
  String get chooseService => 'اختر الخدمة';

  @override
  String get chooseBranch => 'اختر الفرع';

  @override
  String get chooseAppointment => 'اختر الموعد';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get step1 => 'خطوة 1';

  @override
  String get step2 => 'خطوة 2';

  @override
  String get step3 => 'خطوة 3';

  @override
  String get step4 => 'خطوة 4';

  @override
  String get chooseRequiredServiceDescription =>
      'حدد نوع الخدمة المطلوبة لسيارتك';

  @override
  String get chooseThisService => 'اختر هذه الخدمة';

  @override
  String get chooseThisBranch => 'اختر هذا الفرع';

  @override
  String get selectedService => 'الخدمة المحددة';

  @override
  String get selectedBranch => 'الفرع المحدد';

  @override
  String get branchInformation => 'معلومات الفرع';

  @override
  String get rate => 'تقييم';

  @override
  String get km => 'كم';

  @override
  String get cost => 'السعر';

  @override
  String get duration => 'المدة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get savedProductsDescription =>
      'المنتجات التي قمت بحفظها لشرائها لاحقاً';

  @override
  String get noFavoriteProducts => 'ليس لديك منتجات مفضلة بعد';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsHeadingDescription =>
      'ابقَ على اطلاع بأحدث تحديثات طلباتك وحجوزاتك';

  @override
  String get bestTiresInIraq => 'أفضل إطارات في العراق';

  @override
  String get chooseYourPerfectTire => 'اختر إطارك المناسب لصيف العراق';

  @override
  String get chooseYourPerfectTireDescription =>
      'اختيارات مدروسة تمنحك قيادة آمنة ومريحة طوال الصيف.';

  @override
  String get youDontHaveNotifications => 'ليس لديك أي إشعارات';

  @override
  String get markAsRead => 'تعليم كمقروء';

  @override
  String get markAllAsRead => 'تعليم الكل كمقروء';

  @override
  String get webProfileWelcome => 'مرحبا';

  @override
  String get webProfileAddresses => 'العناوين';

  @override
  String get webProfileSettings => 'الإعدادات';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get bookNewService => 'حجز خدمة جديدة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get upcomingBookings => 'الحجوزات القادمة';

  @override
  String get primaryAddress => 'العنوان الأساسي';

  @override
  String get profileFullName => 'الاسم الكامل';

  @override
  String get profilePhoneNumber => 'رقم الهاتف';

  @override
  String get edit => 'تعديل';

  @override
  String get profilePersonalInformation => 'البيانات الشخصيه';

  @override
  String get recentOrders => 'آخر الطلبات';

  @override
  String get noReservationYet => 'لا توجد حجوزات بعد';

  @override
  String get noAddressYet => 'لم تقم بإضافة عنوان بعد';

  @override
  String get manageAddressesDescription => 'إدارة عناوين التوصيل الخاصة بك';

  @override
  String get savedAddresses => 'العناوين المحفوظة';

  @override
  String get addAddress => 'إضافة عنوان';

  @override
  String get defaultAddress => 'عنوان افتراضي';

  @override
  String get setAsDefaultAddress => 'تعيين كعنوان افتراضي';

  @override
  String get setAsDefaultAddressWarning =>
      'هل أنت متأكد من تعيين هذا العنوان كعنوان افتراضي؟';

  @override
  String get set => 'تعيين';

  @override
  String get removeAddress => 'حذف العنوان';

  @override
  String get removeAddressWarning =>
      'هل أنت متأكد من حذف هذا العنوان؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get remove => 'حذف';

  @override
  String get cancel => 'إلغاء';

  @override
  String get city => 'المدينة';

  @override
  String get selectCity => 'اختر المدينة';

  @override
  String get selectCityIsRequired => 'اختيار المدينة مطلوب';

  @override
  String get selectGovernorateIsRequired => 'اختيار المحافظة مطلوب';

  @override
  String get theAddressIsRequired => 'العنوان مطلوب';

  @override
  String get theAddressMustBeMoreThen12Character =>
      'يجب أن يكون العنوان أكثر من 12 حرفًا';

  @override
  String get profileFullAddress => 'العنوان بالتفصيل';

  @override
  String get profileFullAddressPlaceholder =>
      'أدخل الشارع، رقم الدار، أقرب نقطة دالة لموقعك...';

  @override
  String get createAddress => 'إضافة عنوان';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get accountSettingsDescription =>
      'إدارة معلوماتك الشخصية وإعدادات الأمان';

  @override
  String get profileEmail => 'البريد الإلكتروني';

  @override
  String get securityAndPassword => 'الأمان وكلمة المرور';

  @override
  String get profileConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get orderUpdates => 'تحديثات الطلبات';

  @override
  String get orderUpdatesDescription => 'احصل على إشعارات حول حالة طلباتك';

  @override
  String get offersAndDiscounts => 'العروض والتخفيضات';

  @override
  String get offersAndDiscountsDescription =>
      'استقبل إشعارات حول العروض الخاصة';

  @override
  String get newsletter => 'النشرة البريدية';

  @override
  String get newsletterDescription => 'احصل على أحدث الأخبار والمنتجات';

  @override
  String get smsMessages => 'رسائل SMS';

  @override
  String get smsMessagesDescription => 'استقبل رسائل نصية للتحديثات المهمة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get passwordsMustMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordConfirmationRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get emailMaxLength => 'يجب ألا يزيد البريد الإلكتروني عن 120 حرفًا';

  @override
  String get nameMaxLength => 'يجب ألا يزيد الاسم عن 120 حرفًا';

  @override
  String get nameMinLength => 'يجب أن يتكون الاسم من 6 أحرف على الأقل';

  @override
  String get emailPlaceholderProfile => 'example@example.com';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authRegister => 'إنشاء حساب';

  @override
  String get authWelcome => 'مرحبا';

  @override
  String get enterEmailOrPhoneNumber => 'أدخل بريدك الإلكتروني أو رقم هاتفك';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get enterEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get confirmYourPassword => 'أكد كلمة المرور';

  @override
  String get enterAddress => 'أدخل عنوانك';

  @override
  String get logoutTitle => 'تسجيل الخروج';

  @override
  String get logoutWarning =>
      'هل أنت متأكد أنك تريد تسجيل الخروج؟ ستتم إعادة توجيهك إلى الصفحة الرئيسية.';

  @override
  String get logoutConfirm => 'تسجيل الخروج';

  @override
  String get logoutCancel => 'إلغاء';

  @override
  String get testimonials0 =>
      'أفضل خدمة إطارات في بغداد. دقة في المواعيد وأسعار منافسة جداً. الموازنة بالليزر فرقت كتير في قيادة السيارة.';

  @override
  String get testimonials1 =>
      'الضمان حقيقي فعلاً. كان عندي مشكلة بسيطة في أحد الإطارات وتم استبداله فوراً بدون أي تعقيدات. أنصح بالتعامل معهم';

  @override
  String get testimonials2 =>
      'تجربة شراء سهلة جداً من الموقع الإلكتروني. حجزت الموعد ورحت الفرع ركبت في أقل من ربع ساعة. شكراً تير ماكس';

  @override
  String get journey0Title => 'اختر الخدمة';

  @override
  String get journey0Desc => 'تصفح خدماتنا وحدد ما تحتاجه.';

  @override
  String get journey1Title => 'حدد الموعد';

  @override
  String get journey1Desc => 'اختر الوقت المناسب لك بدقة.';

  @override
  String get journey2Title => 'احضر لمركزنا';

  @override
  String get journey2Desc => 'سنكون بانتظارك في مركز الخدمة.';

  @override
  String get journey3Title => 'استلم سيارتك';

  @override
  String get journey3Desc => 'استلم سيارتك جاهزة مع ضمان الخدمة.';

  @override
  String get whyChoose0Title => 'خبراء معتمدون';

  @override
  String get whyChoose0Desc => 'فريق عمل مدرب دولياً.';

  @override
  String get whyChoose1Title => 'أجهزة حديثة';

  @override
  String get whyChoose1Desc => 'أحدث تكنولوجيا الفحص.';

  @override
  String get whyChoose2Title => 'سرعة في التنفيذ';

  @override
  String get whyChoose2Desc => 'نحترم وقتك الثمين.';

  @override
  String get whyChoose3Title => 'ضمان على الخدمة';

  @override
  String get whyChoose3Desc => 'ثقة تمتد لما بعد الصيانة.';

  @override
  String get whyChoose4Title => 'دقة عالية';

  @override
  String get whyChoose4Desc => 'إتقان في أدق التفاصيل.';

  @override
  String get features0Title => 'تذكيرات ذكية';

  @override
  String get features0Desc => 'ننبهك بمواعيد تبديل الزيت والإطارات تلقائياً.';

  @override
  String get features1Title => 'دعم فني 24/7';

  @override
  String get features1Desc => 'خبراء جاهزون للرد على استفساراتك في أي وقت.';

  @override
  String get features2Title => 'فحوصات مجانية';

  @override
  String get features2Desc => 'فحص ضغط الهواء وسلامة الإطارات مجاناً لعملائنا.';

  @override
  String get features3Title => 'ضمان ممتد';

  @override
  String get features3Desc => 'نوفر لك راحة البال مع باقات الضمان الحقيقية.';

  @override
  String get privacyPolicyDescription =>
      'في Tire Max Iraq، نلتزم بحماية خصوصيتك وضمان أمان بياناتك الشخصية. توضح هذه السياسة كيفية تعاملنا مع معلوماتك بكل شفافية ودقة.';

  @override
  String get dataCollection => 'جمع البيانات';

  @override
  String get dataCollectionDescription =>
      'نقوم بجمع المعلومات التي تقدمها لنا مباشرة عند استخدام خدماتنا، بما في ذلك:';

  @override
  String get vehicleData =>
      'بيانات المركبة: نوع السيارة، قياس الإطارات، وتاريخ الصيانة.';

  @override
  String get paymentInformation =>
      'معلومات الدفع: تفاصيل المعاملات المالية (تتم معالجتها عبر قنوات مشفرة).';

  @override
  String get locationData =>
      'الموقع الجغرافي: لتقديم خدمات المساعدة على الطريق وتحديد أقرب فرع.';

  @override
  String get howWeUseInformation => 'كيفية استخدام المعلومات';

  @override
  String get howWeUseInformationDescription =>
      'نستخدم بياناتك لتحسين تجربة قيادتك، وتخصيص العروض التقنية، وضمان سلامة إطاراتك من خلال تنبيهات الصيانة الدورية. نحن لا نقوم ببيع بياناتك لأطراف ثالثة لأغراض تسويقية.';

  @override
  String get dataProtection => 'حماية البيانات';

  @override
  String get dataProtectionDescription =>
      'نطبق بروتوكولات تشفير عسكرية (AES-256) لحماية قواعد بياناتنا. يتم تقييد الوصول إلى المعلومات الشخصية فقط للموظفين الذين يحتاجون إليها لخدمتك.';

  @override
  String get userRights => 'حقوق المستخدم';

  @override
  String get userRightsDescription =>
      'لديك الحق الكامل في الوصول إلى بياناتك، تصحيحها، أو طلب مسحها نهائياً من أنظمتنا. يمكنك أيضاً الاعتراض على معالجة بياناتك في أي وقت.';

  @override
  String get havePrivacyQuestions => 'هل لديك استفسارات حول الخصوصية؟';

  @override
  String get havePrivacyQuestionsDescription =>
      'فريقنا القانوني والتقني جاهز للإجابة على جميع تساؤلاتك.';

  @override
  String get termsAndConditionsDescription =>
      'مرحباً بكم في تاير ماكس العراق. تحكم هذه الشروط والأحكام استخدامك لموقعنا وخدماتنا. من خلال الوصول إلى خدماتنا، فإنك توافق على الالتزام بهذه البنود بالكامل.';

  @override
  String get introductionParagraph1 =>
      'هذه الاتفاقية تبرم بينك وبين \"تاير ماكس العراق\". تسري هذه الشروط على جميع الزوار والمستخدمين وغيرهم ممن يصلون إلى الخدمة أو يستخدمونها.';

  @override
  String get introductionParagraph2 =>
      'يرجى قراءة هذه الشروط بعناية قبل البدء في استخدام الموقع. إذا كنت لا توافق على أي جزء من الشروط، فلا يجوز لك الوصول إلى الخدمة.';

  @override
  String get informationAccuracy => 'دقة المعلومات';

  @override
  String get informationAccuracyDescription =>
      'يجب أن تكون جميع المعلومات المقدمة عند التسجيل دقيقة وحديثة وكاملة.';

  @override
  String get accountSecurity => 'أمن الحساب';

  @override
  String get accountSecurityDescription =>
      'أنت مسؤول عن الحفاظ على سرية كلمة المرور الخاصة بك وعن جميع الأنشطة التي تحدث تحت حسابك.';

  @override
  String get purchasesAndPaymentsParagraph1 =>
      'نحن نحتفظ بالحق في رفض أو إلغاء طلبك في أي وقت لأسباب معينة بما في ذلك على سبيل المثال لا الحصر: توفر المنتج، أخطاء في وصف أو سعر المنتج، أو خطأ في طلبك.';

  @override
  String get purchasesAndPaymentsParagraph2 =>
      'يتم الدفع بالدينار العراقي حسب سعر الصرف المعلن في المتجر.';

  @override
  String get purchasesAndPaymentsParagraph3 =>
      'نستخدم بوابات دفع آمنة ومشفرة لضمان حماية بياناتك المالية.';

  @override
  String get warrantiesDescription =>
      'جميع الإطارات المباعة من خلال تاير ماكس العراق تأتي مع ضمان المصنع ضد العيوب المصنعية. مدة الضمان وشروطه تختلف حسب العلامة التجارية والموديل. لا يشمل الضمان الأضرار الناتجة عن:';

  @override
  String get misuse => 'سوء الاستخدام';

  @override
  String get incorrectInstallation => 'التركيب الخاطئ خارج مراكزنا';

  @override
  String get improperStorage => 'التخزين غير السليم';

  @override
  String get limitationOfLiabilityParagraph1 =>
      'في أي حال من الأحوال، لن تكون تاير ماكس العراق أو مدراؤها أو موظفوها أو شركاؤها مسؤولين عن أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو عقابية، بما في ذلك على سبيل المثال لا الحصر، خسارة الأرباح أو البيانات أو الاستخدام أو السمعة الطيبة.';

  @override
  String get limitationOfLiabilityParagraph2 =>
      'نحن نسعى لتقديم أدق المعلومات، ولكننا لا نضمن خلو الموقع من الأخطاء التقنية أو المطبعية.';

  @override
  String get lastUpdated => 'تاريخ آخر تحديث: 20 مايو 2024';

  @override
  String get contactMessageSent => 'تم إرسال رسالتك. سنتواصل معك قريباً.';

  @override
  String get inquirySubject => 'موضوع الاستفسار';

  @override
  String get inquiryAboutPrices => 'استفسار عن الأسعار';

  @override
  String get message => 'الرسالة';

  @override
  String get howCanWeHelpYouToday => 'كيف يمكننا مساعدتك اليوم؟';

  @override
  String get sendMessage => 'إرسال الرسالة';

  @override
  String get orContactImmediatelyVia => 'أو تواصل فوراً عبر:';

  @override
  String get required => 'الرقم المرجعي ورقم الهاتف مطلوبان';

  @override
  String get notFound => 'لا يوجد طلب أو حجز بهذه البيانات';

  @override
  String get error => 'حدث خطأ، يرجى المحاولة مرة أخرى';

  @override
  String get title => 'تتبع طلبك أو حجزك';

  @override
  String get description =>
      'أدخل الرقم المرجعي ورقم الهاتف المستخدم عند الطلب.';

  @override
  String get reference => 'الرقم المرجعي';

  @override
  String get track => 'تتبع';

  @override
  String get address => 'العنوان';

  @override
  String get price => 'السعر';

  @override
  String get cancelBookingWarning => 'لن تتمكن من استعادة الحجز بعد إلغائه.';

  @override
  String get keepBooking => 'الاحتفاظ بالحجز';

  @override
  String get rescheduleBooking => 'إعادة جدولة الحجز';

  @override
  String get rescheduleBookingWarning =>
      'ستؤدي إعادة الجدولة إلى إلغاء حجزك الحالي. هل أنت متأكد؟';

  @override
  String get status => 'الحالة';

  @override
  String get headerBookNow => 'احجز الآن';

  @override
  String get now => 'الآن!';

  @override
  String get phoneNumberMaxLength => 'يجب ألا يزيد رقم الهاتف عن 20 رقمًا';

  @override
  String get clearCartQuestion => 'تفريغ السلة؟';

  @override
  String get clearCartBody => 'سيتم إزالة جميع المنتجات من سلتك.';

  @override
  String get clear => 'تفريغ';

  @override
  String get clearCartTooltip => 'تفريغ السلة';

  @override
  String get bookYourCarService => 'احجز خدمة سيارتك';

  @override
  String get whyChoosePrefix => 'لماذا تختار ';

  @override
  String get bookingDetail => 'تفاصيل الحجز';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get couldNotCancelBooking => 'تعذّر إلغاء الحجز.';

  @override
  String get couldNotRescheduleBooking => 'تعذّرت إعادة جدولة الحجز.';

  @override
  String get noServicesAvailable => 'لا توجد خدمات متاحة.';

  @override
  String get noBranchesAvailable => 'لا توجد فروع متاحة.';

  @override
  String get selectADate => 'اختر التاريخ';

  @override
  String get ongoingAssistancePrefix => 'دعم مستمر، ';

  @override
  String get privacyPersonalInformation =>
      'المعلومات الشخصية: الاسم، عنوان البريد الإلكتروني، ورقم الهاتف.';

  @override
  String get legalSectionIntroduction => 'مقدمة';

  @override
  String get legalSectionUserObligations => 'التزامات المستخدم';

  @override
  String get legalSectionPurchasesAndPayments => 'المشتريات والمدفوعات';

  @override
  String get legalSectionWarranties => 'الضمانات';

  @override
  String get legalSectionLimitationOfLiability => 'حدود المسؤولية';

  @override
  String minutesCount(int count) {
    return '$count دقيقة';
  }

  @override
  String get couldNotCancelOrder => 'تعذّر إلغاء الطلب.';

  @override
  String get bookingFailed => 'فشل الحجز.';

  @override
  String get couldNotPlaceOrder => 'تعذّر إتمام الطلب.';

  @override
  String get pleaseFillRequiredFields => 'يرجى ملء جميع الحقول المطلوبة.';

  @override
  String get phoneMax20 => 'يجب ألا يتجاوز رقم الهاتف 20 رقماً';

  @override
  String get addressMax255 => 'يجب ألا يتجاوز العنوان 255 حرفاً';

  @override
  String get setAsDefault => 'تعيين كافتراضي';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get nameMax120 => 'يجب ألا يتجاوز الاسم 120 حرفاً';

  @override
  String get phoneMax30 => 'يجب ألا يتجاوز رقم الهاتف 30 حرفاً';

  @override
  String get subjectRequired => 'الموضوع مطلوب';

  @override
  String get subjectMax190 => 'يجب ألا يتجاوز الموضوع 190 حرفاً';

  @override
  String get messageRequired => 'الرسالة مطلوبة';

  @override
  String get messageMax5000 => 'يجب ألا تتجاوز الرسالة 5000 حرف';

  @override
  String get errTimeout => 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get errConnection =>
      'تعذّر الاتصال بالخادم. تحقق من اتصالك بالإنترنت.';

  @override
  String get errCancelled => 'تم إلغاء الطلب.';

  @override
  String get errBadCertificate => 'تعذّر إنشاء اتصال آمن.';

  @override
  String get errSomethingWrongTryAgain => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get errUnexpected => 'حدث خطأ غير متوقع.';

  @override
  String get somethingWentWrongPeriod => 'حدث خطأ ما.';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusComplete => 'مكتمل';

  @override
  String get statusRescheduled => 'أعيدت جدولته';

  @override
  String get statusPaid => 'مدفوع';

  @override
  String get statusFailed => 'فشل';

  @override
  String get iqdLabel => 'د.ع';

  @override
  String get timeAm => 'ص';

  @override
  String get timePm => 'م';

  @override
  String get bookingNotesHint => 'مثال: يرجى فحص توازن العجلات أيضاً';

  @override
  String get trafficAccidents => 'الحوادث المرورية';
}
