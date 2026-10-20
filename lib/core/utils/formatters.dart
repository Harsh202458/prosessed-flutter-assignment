import 'package:intl/intl.dart';

/// Display formatting for prices, discounts and ratings.
abstract final class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
  );

  /// `12.5` → `$12.50`
  static String price(num value) => _currency.format(value);

  /// `12.456` → `-12%`
  static String discount(num percentage) => '-${percentage.round()}%';

  /// `4.567` → `4.6`
  static String rating(num value) => value.toStringAsFixed(1);

  /// `2025-04-30` → `Apr 30, 2025` (or `30 अप्रैल 2025` for `hi`).
  static String date(DateTime value, [String locale = 'en_US']) =>
      DateFormat.yMMMd(locale).format(value);
}
