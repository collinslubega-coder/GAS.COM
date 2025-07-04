import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

// **THEME COLOR IS NOW THE CORRECT FIERY BLUE**
// The primary color is now the vibrant blue from your logo.
const Color primaryColor = Color(0xFF00AEEF);

// A new MaterialColor swatch based on the new primary blue.
// This allows Flutter to automatically generate shades for UI elements.
const MaterialColor primaryMaterialColor = MaterialColor(
  0xFF00AEEF,
  <int, Color>{
    50: Color(0xFFE0F7FF),
    100: Color(0xFFB3E9FF),
    200: Color(0xFF80D9FF),
    300: Color(0xFF4DC9FF),
    400: Color(0xFF26BCFF),
    500: primaryColor,
    600: Color(0xFF00A6E8),
    700: Color(0xFF009BDE),
    800: Color(0xFF0091D4),
    900: Color(0xFF007EC2),
  },
);

// The rest of the constants remain the same.
const String grandisExtendedFont = "Grandis Extended";

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(4, errorText: 'password must be at least 4 digits long'),
  MaxLengthValidator(20, errorText: 'password must not be more than 20 digits long'),
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

const pasNotMatchErrorText = "passwords do not match";