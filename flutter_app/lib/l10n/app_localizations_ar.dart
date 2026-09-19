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
}
