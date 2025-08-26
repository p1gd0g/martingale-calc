import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// App Theme Configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color Palette
  static const Color backgroundColor = Color(0xFF0B1426);
  static const Color cardBackgroundColor = Color(0xFF1E2329);
  static const Color inputBackgroundColor = Color(0xFF2B3139);
  static const Color borderColor = Color(0xFF373D47);
  static const Color secondaryBorderColor = Color(0xFF2B3139);
  static const Color textSecondaryColor = Color(0xFF848E9C);
  static const Color orangeAccentColor = Color(0xFFF7931A);
  static const Color longPositionColor = Color(0xFF02C076);
  static const Color shortPositionColor = Color(0xFFF6465D);
  static const Color whiteTextColor = Colors.white;

  // Main App Theme Data
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.deepBlue,
      subThemesData: const FlexSubThemesData(
        inputSelectionSchemeColor: SchemeColor.white,
      ),
    );
  }

  // Custom Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    color: whiteTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    color: whiteTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle labelStyle = TextStyle(
    color: textSecondaryColor,
    fontSize: 12,
  );

  static const TextStyle inputStyle = TextStyle(color: whiteTextColor);

  static const TextStyle suffixStyle = TextStyle(
    color: textSecondaryColor,
    fontSize: 12,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tableHeaderStyle = TextStyle(
    color: textSecondaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tableDataStyle = TextStyle(
    color: whiteTextColor,
    fontSize: 11,
  );

  static const TextStyle directionButtonStyle = TextStyle(
    color: whiteTextColor,
    fontWeight: FontWeight.w500,
  );

  // Custom Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBackgroundColor,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: secondaryBorderColor),
  );

  static BoxDecoration get inputDecoration => BoxDecoration(
    color: inputBackgroundColor,
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: borderColor),
  );

  static BoxDecoration bitcoinIconDecoration = BoxDecoration(
    color: orangeAccentColor,
    borderRadius: BorderRadius.circular(6),
  );

  // Direction Button Decorations
  static BoxDecoration getLongButtonDecoration(bool isSelected) =>
      BoxDecoration(
        color: isSelected ? longPositionColor : inputBackgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isSelected ? longPositionColor : borderColor),
      );

  static BoxDecoration getShortButtonDecoration(bool isSelected) =>
      BoxDecoration(
        color: isSelected ? shortPositionColor : inputBackgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? shortPositionColor : borderColor,
        ),
      );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: orangeAccentColor,
    foregroundColor: whiteTextColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    elevation: 0,
  );

  // Data Table Theme
  static WidgetStateProperty<Color?> get tableHeaderRowColor =>
      WidgetStateProperty.all(inputBackgroundColor);

  static WidgetStateProperty<Color?> get tableDataRowColor =>
      WidgetStateProperty.all(cardBackgroundColor);

  // Common Widget Properties
  static const double cardBorderRadius = 8.0;
  static const double inputBorderRadius = 4.0;
  static const double buttonBorderRadius = 4.0;
  static const EdgeInsets cardPadding = EdgeInsets.all(20);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  );
  static const EdgeInsets directionButtonPadding = EdgeInsets.symmetric(
    vertical: 12,
  );

  // Common Spacings
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 16.0;
  static const double extraLargeSpacing = 20.0;

  // Icon Properties
  static const double appBarIconSize = 20.0;
  static const double bitcoinIconSize = 32.0;
  static const double appBarTitleSpacing = 12.0;

  // Button Properties
  static const double buttonHeight = 48.0;
  static const double tableDividerThickness = 1.0;
  static const double tableColumnSpacing = 16.0;
}
