// Validator functions
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'الاسم مطلوب';
  } else if (value.length < 3) {
    return ' يجب أن يكون الاسم على الأقل 3 أحرف';
  }
  return null;
}

String? validateEmail(String? value) {
  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (value == null || value.isEmpty) {
    return 'البريد الإلكتروني مطلوب';
  } else if (!regex.hasMatch(value)) {
    return 'البريد الإلكتروني غير صالح';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'كلمة المرور مطلوبة';
  } else if (value.length < 8) {
    return 'يجب أن تكون كلمة المرور مكونة من 8 أحرف على الأقل';
  }
  return null;
}