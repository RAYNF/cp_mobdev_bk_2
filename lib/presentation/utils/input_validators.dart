import 'package:flutter/material.dart';

String? notEmptyString(var value) {
  if (value == null || value.isEmpty) {
    return "Isian Tidak Boleh Kosong";
  } else {
    return null;
  }
}

String? notEmptyInt(var value) {
  if (value == null) {
    return "Isian Tidak Boleh Kosong";
  } else {
    return null;
  }
}

String? passConfirmationValidator(
    var value, TextEditingController passController) {
  String? notEmpty = notEmptyString(value);

  if (notEmpty != null) {
    return notEmpty;
  }

  if (value.length < 6) {
    return "Password minimal 6 karakter";
  }

  if (value != passController.value.text) {
    return "Password dan konfirmasi harus sama";
  }

  return null;
}
