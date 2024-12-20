import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';

void unfocusKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

String? Function(String?)? requiredValidator({String? error}) {
  return RequiredValidator(errorText: error ?? 'This field is required*').call;
}

MultiValidator emailValidator() {
  return MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Invalid email address'),
  ]);
}

MultiValidator passwordValidator() {
  return MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
    MaxLengthValidator(20,
        errorText: 'Password must not be more than 20 digits long'),
  ]);
}

String? Function(String?)? phoneValidator() {
  return (String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    } else if (value.length < 14) {
      return 'Please enter a complete number';
    }
    return null;
  };
}

String? validateMessage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '';
  }
  return null;
}

String? Function(String?)? requiredValidatorName({String? error}) {
  return (String? value) {
    if (value != null && value.startsWith(' ')) {
      return error ?? 'Name cannot start with a space';
    }
    return RequiredValidator(errorText: error ?? 'This field is required*')
        .call(value);
  };
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return toBeginningOfSentenceCase(input)!;
}
