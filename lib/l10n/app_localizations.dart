import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ShopSphere'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Everything you love, in one place.'**
  String get appTagline;

  /// No description provided for @logoLabel.
  ///
  /// In en, this message translates to:
  /// **'ShopSphere logo'**
  String get logoLabel;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get navShop;

  /// No description provided for @navCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'{label}, {count, plural, =1{1 item} other{{count} items}}'**
  String navItemsLabel(String label, int count);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity {quantity}'**
  String quantityLabel(int quantity);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Showing saved products.'**
  String get offlineBanner;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue shopping'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @useDemoAccount.
  ///
  /// In en, this message translates to:
  /// **'Use demo account'**
  String get useDemoAccount;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get usernameRequired;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least {min} characters'**
  String usernameTooShort(int min);

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String passwordTooShort(int min);

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again.'**
  String get errorServer;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and retry.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'The request could not be processed.'**
  String get errorBadRequest;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorParse.
  ///
  /// In en, this message translates to:
  /// **'We received an unexpected response. Please try again.'**
  String get errorParse;

  /// No description provided for @errorCache.
  ///
  /// In en, this message translates to:
  /// **'Could not access saved data on this device.'**
  String get errorCache;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorCartRestore.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t restore your saved cart.'**
  String get errorCartRestore;

  /// No description provided for @errorCartSave.
  ///
  /// In en, this message translates to:
  /// **'Your cart couldn\'t be saved on this device.'**
  String get errorCartSave;

  /// No description provided for @errorCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get errorCartEmpty;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @homeHeadline.
  ///
  /// In en, this message translates to:
  /// **'Discover something new'**
  String get homeHeadline;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get searchHint;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @sortProducts.
  ///
  /// In en, this message translates to:
  /// **'Sort products'**
  String get sortProducts;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @sortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get sortRecommended;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get sortPriceHighLow;

  /// No description provided for @sortTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get sortTopRated;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get sortNameAZ;

  /// No description provided for @promoBeautyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Glow-up week'**
  String get promoBeautyEyebrow;

  /// No description provided for @promoBeautyTitle.
  ///
  /// In en, this message translates to:
  /// **'Beauty bestsellers on sale'**
  String get promoBeautyTitle;

  /// No description provided for @promoPhonesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Just landed'**
  String get promoPhonesEyebrow;

  /// No description provided for @promoPhonesTitle.
  ///
  /// In en, this message translates to:
  /// **'The latest smartphones'**
  String get promoPhonesTitle;

  /// No description provided for @promoFurnitureEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Make it cosy'**
  String get promoFurnitureEyebrow;

  /// No description provided for @promoFurnitureTitle.
  ///
  /// In en, this message translates to:
  /// **'Furniture for every room'**
  String get promoFurnitureTitle;

  /// No description provided for @promoLabel.
  ///
  /// In en, this message translates to:
  /// **'{eyebrow}. {title}. Shop now'**
  String promoLabel(String eyebrow, String title);

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get shopNow;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoriesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load categories · Retry'**
  String get categoriesError;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All products'**
  String get allProducts;

  /// No description provided for @resultsFor.
  ///
  /// In en, this message translates to:
  /// **'Results for \"{query}\"'**
  String resultsFor(String query);

  /// No description provided for @productsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load products'**
  String get productsLoadError;

  /// No description provided for @noProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsTitle;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches \"{query}\". Try a different search.'**
  String noSearchResults(String query);

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'There are no products here yet.'**
  String get noProductsInCategory;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @selectProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a product'**
  String get selectProductTitle;

  /// No description provided for @selectProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick any product to see its photos, details and reviews here.'**
  String get selectProductMessage;

  /// No description provided for @savedProductsFooter.
  ///
  /// In en, this message translates to:
  /// **'These are saved products. Pull to refresh when you\'re back online.'**
  String get savedProductsFooter;

  /// No description provided for @seenAllProducts.
  ///
  /// In en, this message translates to:
  /// **'You\'ve seen all {count} products'**
  String seenAllProducts(int count);

  /// No description provided for @loadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading products'**
  String get loadingProducts;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price {price}'**
  String priceLabel(String price);

  /// No description provided for @priceWasLabel.
  ///
  /// In en, this message translates to:
  /// **'Price {price}, was {original}'**
  String priceWasLabel(String price, String original);

  /// No description provided for @ratedOutOf5.
  ///
  /// In en, this message translates to:
  /// **'Rated {rating} out of 5'**
  String ratedOutOf5(String rating);

  /// No description provided for @productImageLabel.
  ///
  /// In en, this message translates to:
  /// **'{title}, image {index} of {count}'**
  String productImageLabel(String title, int index, int count);

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added {quantity} × {title} to your cart'**
  String addedToCart(int quantity, String title);

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View cart'**
  String get viewCart;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @closeDetails.
  ///
  /// In en, this message translates to:
  /// **'Close details'**
  String get closeDetails;

  /// No description provided for @productNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFoundTitle;

  /// No description provided for @productNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'This product doesn\'t exist or is no longer available.'**
  String get productNotFoundMessage;

  /// No description provided for @backToShop.
  ///
  /// In en, this message translates to:
  /// **'Back to shop'**
  String get backToShop;

  /// No description provided for @productLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this product'**
  String get productLoadError;

  /// No description provided for @reviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 review} other{{count} reviews}}'**
  String reviewCount(int count);

  /// No description provided for @saveDiscount.
  ///
  /// In en, this message translates to:
  /// **'Save {percent}%'**
  String saveDiscount(int percent);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get noDescription;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews'**
  String get customerReviews;

  /// No description provided for @noReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviews;

  /// No description provided for @loadingProduct.
  ///
  /// In en, this message translates to:
  /// **'Loading product'**
  String get loadingProduct;

  /// No description provided for @allInCart.
  ///
  /// In en, this message translates to:
  /// **'All in your cart'**
  String get allInCart;

  /// No description provided for @addWithTotal.
  ///
  /// In en, this message translates to:
  /// **'Add · {total}'**
  String addWithTotal(String total);

  /// No description provided for @inCartMoreAvailable.
  ///
  /// In en, this message translates to:
  /// **'{inCart} in your cart · {available} more available'**
  String inCartMoreAvailable(int inCart, int available);

  /// No description provided for @allStockInCart.
  ///
  /// In en, this message translates to:
  /// **'You have all {stock} in your cart'**
  String allStockInCart(int stock);

  /// No description provided for @stockOnlyLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {stock} left'**
  String stockOnlyLeft(int stock);

  /// No description provided for @stockInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock · {stock} available'**
  String stockInStock(int stock);

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear your cart?'**
  String get clearCartTitle;

  /// No description provided for @clearCartMessage.
  ///
  /// In en, this message translates to:
  /// **'This removes every item from your cart.'**
  String get clearCartMessage;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCart;

  /// No description provided for @removedItem.
  ///
  /// In en, this message translates to:
  /// **'Removed {title}'**
  String removedItem(String title);

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove {title}'**
  String removeItem(String title);

  /// No description provided for @orderFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t place your order. {reason}'**
  String orderFailed(String reason);

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Browse the shop and add something you love.'**
  String get cartEmptyMessage;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start shopping'**
  String get startShopping;

  /// No description provided for @unitPriceEach.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String unitPriceEach(String price);

  /// No description provided for @subtotalItems.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({count, plural, =1{1 item} other{{count} items}})'**
  String subtotalItems(int count);

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place order'**
  String get placeOrder;

  /// No description provided for @simulatedOrderNote.
  ///
  /// In en, this message translates to:
  /// **'Orders are simulated by DummyJSON. No payment is taken.'**
  String get simulatedOrderNote;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order placed'**
  String get orderPlaced;

  /// No description provided for @orderThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for shopping with ShopSphere. We\'ll get it packed and on its way.'**
  String get orderThanks;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get orderNumber;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed'**
  String get orderConfirmed;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutQuestion;

  /// No description provided for @logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again. Your cart on this device will be cleared.'**
  String get logOutMessage;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your profile'**
  String get profileLoadError;

  /// No description provided for @profileRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh your profile. {reason}'**
  String profileRefreshError(String reason);

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @customerId.
  ///
  /// In en, this message translates to:
  /// **'Customer ID'**
  String get customerId;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading profile'**
  String get loadingProfile;

  /// No description provided for @profilePhotoOf.
  ///
  /// In en, this message translates to:
  /// **'Profile photo of {name}'**
  String profilePhotoOf(String name);

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @wishlistWithCount.
  ///
  /// In en, this message translates to:
  /// **'Wishlist ({count})'**
  String wishlistWithCount(int count);

  /// No description provided for @wishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save products you love'**
  String get wishlistEmptySubtitle;

  /// No description provided for @wishlistSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved item} other{{count} saved items}}'**
  String wishlistSavedCount(int count);

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to save it here.'**
  String get wishlistEmptyMessage;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get browseProducts;

  /// No description provided for @savedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Saved to your wishlist'**
  String get savedToWishlist;

  /// No description provided for @removedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from your wishlist'**
  String get removedFromWishlist;

  /// No description provided for @saveToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Save to wishlist'**
  String get saveToWishlist;

  /// No description provided for @removeFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get removeFromWishlist;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
