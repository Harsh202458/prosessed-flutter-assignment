// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ShopSphere';

  @override
  String get appTagline => 'Everything you love, in one place.';

  @override
  String get logoLabel => 'ShopSphere logo';

  @override
  String get navShop => 'Shop';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String navItemsLabel(String label, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$label, $_temp0';
  }

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get cancel => 'Cancel';

  @override
  String get undo => 'Undo';

  @override
  String get close => 'Close';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';

  @override
  String quantityLabel(int quantity) {
    return 'Quantity $quantity';
  }

  @override
  String get offlineBanner => 'You\'re offline. Showing saved products.';

  @override
  String get loginWelcome => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue shopping';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'Enter your username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signIn => 'Sign in';

  @override
  String get useDemoAccount => 'Use demo account';

  @override
  String get usernameRequired => 'Please enter your username';

  @override
  String usernameTooShort(int min) {
    return 'Username must be at least $min characters';
  }

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get errorServer =>
      'Something went wrong on our side. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and retry.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorBadRequest => 'The request could not be processed.';

  @override
  String get errorSessionExpired =>
      'Your session has expired. Please log in again.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorParse =>
      'We received an unexpected response. Please try again.';

  @override
  String get errorCache => 'Could not access saved data on this device.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get errorInvalidCredentials => 'Invalid username or password.';

  @override
  String get errorCartRestore => 'We couldn\'t restore your saved cart.';

  @override
  String get errorCartSave => 'Your cart couldn\'t be saved on this device.';

  @override
  String get errorCartEmpty => 'Your cart is empty.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeHeadline => 'Discover something new';

  @override
  String get searchHint => 'Search products';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get sortProducts => 'Sort products';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortRecommended => 'Recommended';

  @override
  String get sortPriceLowHigh => 'Price: low to high';

  @override
  String get sortPriceHighLow => 'Price: high to low';

  @override
  String get sortTopRated => 'Top rated';

  @override
  String get sortNameAZ => 'Name: A to Z';

  @override
  String get promoBeautyEyebrow => 'Glow-up week';

  @override
  String get promoBeautyTitle => 'Beauty bestsellers on sale';

  @override
  String get promoPhonesEyebrow => 'Just landed';

  @override
  String get promoPhonesTitle => 'The latest smartphones';

  @override
  String get promoFurnitureEyebrow => 'Make it cosy';

  @override
  String get promoFurnitureTitle => 'Furniture for every room';

  @override
  String promoLabel(String eyebrow, String title) {
    return '$eyebrow. $title. Shop now';
  }

  @override
  String get shopNow => 'Shop now';

  @override
  String get categoryAll => 'All';

  @override
  String get categoriesError => 'Couldn\'t load categories · Retry';

  @override
  String get allProducts => 'All products';

  @override
  String resultsFor(String query) {
    return 'Results for \"$query\"';
  }

  @override
  String get productsLoadError => 'Couldn\'t load products';

  @override
  String get noProductsTitle => 'No products found';

  @override
  String noSearchResults(String query) {
    return 'Nothing matches \"$query\". Try a different search.';
  }

  @override
  String get noProductsInCategory => 'There are no products here yet.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get selectProductTitle => 'Select a product';

  @override
  String get selectProductMessage =>
      'Pick any product to see its photos, details and reviews here.';

  @override
  String get savedProductsFooter =>
      'These are saved products. Pull to refresh when you\'re back online.';

  @override
  String seenAllProducts(int count) {
    return 'You\'ve seen all $count products';
  }

  @override
  String get loadingProducts => 'Loading products';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String priceLabel(String price) {
    return 'Price $price';
  }

  @override
  String priceWasLabel(String price, String original) {
    return 'Price $price, was $original';
  }

  @override
  String ratedOutOf5(String rating) {
    return 'Rated $rating out of 5';
  }

  @override
  String productImageLabel(String title, int index, int count) {
    return '$title, image $index of $count';
  }

  @override
  String addedToCart(int quantity, String title) {
    return 'Added $quantity × $title to your cart';
  }

  @override
  String get viewCart => 'View cart';

  @override
  String get productDetails => 'Product details';

  @override
  String get closeDetails => 'Close details';

  @override
  String get productNotFoundTitle => 'Product not found';

  @override
  String get productNotFoundMessage =>
      'This product doesn\'t exist or is no longer available.';

  @override
  String get backToShop => 'Back to shop';

  @override
  String get productLoadError => 'Couldn\'t load this product';

  @override
  String reviewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String saveDiscount(int percent) {
    return 'Save $percent%';
  }

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description available.';

  @override
  String get customerReviews => 'Customer reviews';

  @override
  String get noReviews => 'No reviews yet.';

  @override
  String get loadingProduct => 'Loading product';

  @override
  String get allInCart => 'All in your cart';

  @override
  String addWithTotal(String total) {
    return 'Add · $total';
  }

  @override
  String inCartMoreAvailable(int inCart, int available) {
    return '$inCart in your cart · $available more available';
  }

  @override
  String allStockInCart(int stock) {
    return 'You have all $stock in your cart';
  }

  @override
  String stockOnlyLeft(int stock) {
    return 'Only $stock left';
  }

  @override
  String stockInStock(int stock) {
    return 'In stock · $stock available';
  }

  @override
  String get cartTitle => 'Cart';

  @override
  String get clear => 'Clear';

  @override
  String get clearCartTitle => 'Clear your cart?';

  @override
  String get clearCartMessage => 'This removes every item from your cart.';

  @override
  String get clearCart => 'Clear cart';

  @override
  String removedItem(String title) {
    return 'Removed $title';
  }

  @override
  String removeItem(String title) {
    return 'Remove $title';
  }

  @override
  String orderFailed(String reason) {
    return 'Couldn\'t place your order. $reason';
  }

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage => 'Browse the shop and add something you love.';

  @override
  String get startShopping => 'Start shopping';

  @override
  String unitPriceEach(String price) {
    return '$price each';
  }

  @override
  String subtotalItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Subtotal ($_temp0)';
  }

  @override
  String get discount => 'Discount';

  @override
  String get delivery => 'Delivery';

  @override
  String get free => 'Free';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place order';

  @override
  String get simulatedOrderNote =>
      'Orders are simulated by DummyJSON. No payment is taken.';

  @override
  String get orderPlaced => 'Order placed';

  @override
  String get orderThanks =>
      'Thanks for shopping with ShopSphere. We\'ll get it packed and on its way.';

  @override
  String get orderNumber => 'Order number';

  @override
  String get items => 'Items';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get orderConfirmed => 'Order confirmed';

  @override
  String get profileTitle => 'Profile';

  @override
  String get logOutQuestion => 'Log out?';

  @override
  String get logOutMessage =>
      'You\'ll need to sign in again. Your cart on this device will be cleared.';

  @override
  String get logOut => 'Log out';

  @override
  String get profileLoadError => 'Couldn\'t load your profile';

  @override
  String profileRefreshError(String reason) {
    return 'Couldn\'t refresh your profile. $reason';
  }

  @override
  String get contactDetails => 'Contact details';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get notProvided => 'Not provided';

  @override
  String get account => 'Account';

  @override
  String get customerId => 'Customer ID';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get loadingProfile => 'Loading profile';

  @override
  String profilePhotoOf(String name) {
    return 'Profile photo of $name';
  }

  @override
  String get wishlist => 'Wishlist';

  @override
  String wishlistWithCount(int count) {
    return 'Wishlist ($count)';
  }

  @override
  String get wishlistEmptySubtitle => 'Save products you love';

  @override
  String wishlistSavedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved items',
      one: '1 saved item',
    );
    return '$_temp0';
  }

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptyMessage =>
      'Tap the heart on any product to save it here.';

  @override
  String get browseProducts => 'Browse products';

  @override
  String get savedToWishlist => 'Saved to your wishlist';

  @override
  String get removedFromWishlist => 'Removed from your wishlist';

  @override
  String get saveToWishlist => 'Save to wishlist';

  @override
  String get removeFromWishlist => 'Remove from wishlist';
}
