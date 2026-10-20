// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'ShopSphere';

  @override
  String get appTagline => 'आपकी पसंद की हर चीज़, एक ही जगह।';

  @override
  String get logoLabel => 'ShopSphere लोगो';

  @override
  String get navShop => 'शॉप';

  @override
  String get navCart => 'कार्ट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String navItemsLabel(String label, int count) {
    return '$label, $count आइटम';
  }

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get undo => 'पहले जैसा करें';

  @override
  String get close => 'बंद करें';

  @override
  String get decreaseQuantity => 'मात्रा घटाएँ';

  @override
  String get increaseQuantity => 'मात्रा बढ़ाएँ';

  @override
  String quantityLabel(int quantity) {
    return 'मात्रा $quantity';
  }

  @override
  String get offlineBanner =>
      'आप ऑफ़लाइन हैं। सहेजे गए उत्पाद दिखाए जा रहे हैं।';

  @override
  String get loginWelcome => 'फिर से स्वागत है';

  @override
  String get loginSubtitle => 'खरीदारी जारी रखने के लिए साइन इन करें';

  @override
  String get usernameLabel => 'यूज़रनेम';

  @override
  String get usernameHint => 'अपना यूज़रनेम डालें';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get passwordHint => 'अपना पासवर्ड डालें';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get useDemoAccount => 'डेमो अकाउंट इस्तेमाल करें';

  @override
  String get usernameRequired => 'कृपया अपना यूज़रनेम डालें';

  @override
  String usernameTooShort(int min) {
    return 'यूज़रनेम कम से कम $min अक्षरों का होना चाहिए';
  }

  @override
  String get passwordRequired => 'कृपया अपना पासवर्ड डालें';

  @override
  String passwordTooShort(int min) {
    return 'पासवर्ड कम से कम $min अक्षरों का होना चाहिए';
  }

  @override
  String get errorServer =>
      'हमारी ओर से कुछ गड़बड़ हो गई। कृपया फिर से कोशिश करें।';

  @override
  String get errorNetwork =>
      'इंटरनेट कनेक्शन नहीं है। अपना नेटवर्क जाँचें और फिर से कोशिश करें।';

  @override
  String get errorTimeout =>
      'अनुरोध में बहुत समय लग गया। कृपया फिर से कोशिश करें।';

  @override
  String get errorBadRequest => 'अनुरोध पूरा नहीं हो सका।';

  @override
  String get errorSessionExpired =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से लॉग इन करें।';

  @override
  String get errorNotFound => 'आप जो खोज रहे थे वह हमें नहीं मिला।';

  @override
  String get errorParse => 'हमें अनपेक्षित जवाब मिला। कृपया फिर से कोशिश करें।';

  @override
  String get errorCache => 'इस डिवाइस पर सहेजा गया डेटा नहीं खुल सका।';

  @override
  String get errorUnknown =>
      'एक अनपेक्षित त्रुटि हुई। कृपया फिर से कोशिश करें।';

  @override
  String get errorInvalidCredentials => 'यूज़रनेम या पासवर्ड गलत है।';

  @override
  String get errorCartRestore => 'हम आपका सहेजा गया कार्ट वापस नहीं ला सके।';

  @override
  String get errorCartSave => 'आपका कार्ट इस डिवाइस पर सहेजा नहीं जा सका।';

  @override
  String get errorCartEmpty => 'आपका कार्ट खाली है।';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'नमस्कार';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeHeadline => 'कुछ नया खोजें';

  @override
  String get searchHint => 'उत्पाद खोजें';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get sortProducts => 'उत्पाद क्रमबद्ध करें';

  @override
  String get sortBy => 'इसके अनुसार क्रमबद्ध करें';

  @override
  String get sortRecommended => 'सुझाए गए';

  @override
  String get sortPriceLowHigh => 'कीमत: कम से ज़्यादा';

  @override
  String get sortPriceHighLow => 'कीमत: ज़्यादा से कम';

  @override
  String get sortTopRated => 'सबसे अच्छी रेटिंग';

  @override
  String get sortNameAZ => 'नाम: A से Z';

  @override
  String get promoBeautyEyebrow => 'ग्लो-अप वीक';

  @override
  String get promoBeautyTitle => 'ब्यूटी बेस्टसेलर्स सेल पर';

  @override
  String get promoPhonesEyebrow => 'अभी-अभी आए';

  @override
  String get promoPhonesTitle => 'नए स्मार्टफ़ोन';

  @override
  String get promoFurnitureEyebrow => 'घर को बनाएँ आरामदायक';

  @override
  String get promoFurnitureTitle => 'हर कमरे के लिए फ़र्नीचर';

  @override
  String promoLabel(String eyebrow, String title) {
    return '$eyebrow। $title। अभी खरीदें';
  }

  @override
  String get shopNow => 'अभी खरीदें';

  @override
  String get categoryAll => 'सभी';

  @override
  String get categoriesError =>
      'श्रेणियाँ लोड नहीं हो सकीं · फिर से कोशिश करें';

  @override
  String get allProducts => 'सभी उत्पाद';

  @override
  String resultsFor(String query) {
    return '\"$query\" के नतीजे';
  }

  @override
  String get productsLoadError => 'उत्पाद लोड नहीं हो सके';

  @override
  String get noProductsTitle => 'कोई उत्पाद नहीं मिला';

  @override
  String noSearchResults(String query) {
    return '\"$query\" से कुछ नहीं मिला। कुछ और खोजकर देखें।';
  }

  @override
  String get noProductsInCategory => 'यहाँ अभी कोई उत्पाद नहीं है।';

  @override
  String get clearFilters => 'फ़िल्टर हटाएँ';

  @override
  String get selectProductTitle => 'कोई उत्पाद चुनें';

  @override
  String get selectProductMessage =>
      'उसकी तस्वीरें, जानकारी और समीक्षाएँ यहाँ देखने के लिए कोई भी उत्पाद चुनें।';

  @override
  String get savedProductsFooter =>
      'ये सहेजे गए उत्पाद हैं। ऑनलाइन होने पर रीफ़्रेश करने के लिए नीचे खींचें।';

  @override
  String seenAllProducts(int count) {
    return 'आपने सभी $count उत्पाद देख लिए हैं';
  }

  @override
  String get loadingProducts => 'उत्पाद लोड हो रहे हैं';

  @override
  String get outOfStock => 'स्टॉक में नहीं';

  @override
  String priceLabel(String price) {
    return 'कीमत $price';
  }

  @override
  String priceWasLabel(String price, String original) {
    return 'कीमत $price, पहले $original';
  }

  @override
  String ratedOutOf5(String rating) {
    return '5 में से $rating रेटिंग';
  }

  @override
  String productImageLabel(String title, int index, int count) {
    return '$title, तस्वीर $index / $count';
  }

  @override
  String addedToCart(int quantity, String title) {
    return '$quantity × $title आपके कार्ट में जोड़ा गया';
  }

  @override
  String get viewCart => 'कार्ट देखें';

  @override
  String get productDetails => 'उत्पाद की जानकारी';

  @override
  String get closeDetails => 'जानकारी बंद करें';

  @override
  String get productNotFoundTitle => 'उत्पाद नहीं मिला';

  @override
  String get productNotFoundMessage =>
      'यह उत्पाद मौजूद नहीं है या अब उपलब्ध नहीं है।';

  @override
  String get backToShop => 'शॉप पर वापस जाएँ';

  @override
  String get productLoadError => 'यह उत्पाद लोड नहीं हो सका';

  @override
  String reviewCount(int count) {
    return '$count समीक्षाएँ';
  }

  @override
  String saveDiscount(int percent) {
    return '$percent% बचाएँ';
  }

  @override
  String get description => 'विवरण';

  @override
  String get noDescription => 'कोई विवरण उपलब्ध नहीं है।';

  @override
  String get customerReviews => 'ग्राहकों की समीक्षाएँ';

  @override
  String get noReviews => 'अभी कोई समीक्षा नहीं।';

  @override
  String get loadingProduct => 'उत्पाद लोड हो रहा है';

  @override
  String get allInCart => 'सब आपके कार्ट में है';

  @override
  String addWithTotal(String total) {
    return 'जोड़ें · $total';
  }

  @override
  String inCartMoreAvailable(int inCart, int available) {
    return '$inCart आपके कार्ट में · $available और उपलब्ध';
  }

  @override
  String allStockInCart(int stock) {
    return 'सभी $stock आपके कार्ट में हैं';
  }

  @override
  String stockOnlyLeft(int stock) {
    return 'सिर्फ़ $stock बचे हैं';
  }

  @override
  String stockInStock(int stock) {
    return 'स्टॉक में · $stock उपलब्ध';
  }

  @override
  String get cartTitle => 'कार्ट';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get clearCartTitle => 'अपना कार्ट साफ़ करें?';

  @override
  String get clearCartMessage => 'इससे आपके कार्ट से सभी आइटम हट जाएँगे।';

  @override
  String get clearCart => 'कार्ट साफ़ करें';

  @override
  String removedItem(String title) {
    return '$title हटाया गया';
  }

  @override
  String removeItem(String title) {
    return '$title हटाएँ';
  }

  @override
  String orderFailed(String reason) {
    return 'आपका ऑर्डर नहीं हो सका। $reason';
  }

  @override
  String get cartEmptyTitle => 'आपका कार्ट खाली है';

  @override
  String get cartEmptyMessage => 'शॉप देखें और अपनी पसंद की कोई चीज़ जोड़ें।';

  @override
  String get startShopping => 'खरीदारी शुरू करें';

  @override
  String unitPriceEach(String price) {
    return '$price प्रति नग';
  }

  @override
  String subtotalItems(int count) {
    return 'उप-योग ($count आइटम)';
  }

  @override
  String get discount => 'छूट';

  @override
  String get delivery => 'डिलीवरी';

  @override
  String get free => 'मुफ़्त';

  @override
  String get total => 'कुल';

  @override
  String get placeOrder => 'ऑर्डर करें';

  @override
  String get simulatedOrderNote =>
      'ऑर्डर DummyJSON द्वारा सिम्युलेट किए जाते हैं। कोई भुगतान नहीं लिया जाता।';

  @override
  String get orderPlaced => 'ऑर्डर हो गया';

  @override
  String get orderThanks =>
      'ShopSphere से खरीदारी के लिए धन्यवाद। हम इसे जल्द पैक करके भेज देंगे।';

  @override
  String get orderNumber => 'ऑर्डर नंबर';

  @override
  String get items => 'आइटम';

  @override
  String get continueShopping => 'खरीदारी जारी रखें';

  @override
  String get orderConfirmed => 'ऑर्डर की पुष्टि हो गई';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get logOutQuestion => 'लॉग आउट करें?';

  @override
  String get logOutMessage =>
      'आपको फिर से साइन इन करना होगा। इस डिवाइस पर आपका कार्ट साफ़ हो जाएगा।';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get profileLoadError => 'आपकी प्रोफ़ाइल लोड नहीं हो सकी';

  @override
  String profileRefreshError(String reason) {
    return 'आपकी प्रोफ़ाइल रीफ़्रेश नहीं हो सकी। $reason';
  }

  @override
  String get contactDetails => 'संपर्क जानकारी';

  @override
  String get email => 'ईमेल';

  @override
  String get phone => 'फ़ोन';

  @override
  String get notProvided => 'उपलब्ध नहीं';

  @override
  String get account => 'अकाउंट';

  @override
  String get customerId => 'ग्राहक आईडी';

  @override
  String get appearance => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'सिस्टम';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get loadingProfile => 'प्रोफ़ाइल लोड हो रही है';

  @override
  String profilePhotoOf(String name) {
    return '$name की प्रोफ़ाइल फ़ोटो';
  }

  @override
  String get wishlist => 'विशलिस्ट';

  @override
  String wishlistWithCount(int count) {
    return 'विशलिस्ट ($count)';
  }

  @override
  String get wishlistEmptySubtitle => 'अपनी पसंद के उत्पाद सहेजें';

  @override
  String wishlistSavedCount(int count) {
    return '$count सहेजे गए आइटम';
  }

  @override
  String get wishlistEmptyTitle => 'आपकी विशलिस्ट खाली है';

  @override
  String get wishlistEmptyMessage =>
      'किसी भी उत्पाद को यहाँ सहेजने के लिए दिल पर टैप करें।';

  @override
  String get browseProducts => 'उत्पाद देखें';

  @override
  String get savedToWishlist => 'आपकी विशलिस्ट में सहेजा गया';

  @override
  String get removedFromWishlist => 'आपकी विशलिस्ट से हटाया गया';

  @override
  String get saveToWishlist => 'विशलिस्ट में सहेजें';

  @override
  String get removeFromWishlist => 'विशलिस्ट से हटाएँ';
}
