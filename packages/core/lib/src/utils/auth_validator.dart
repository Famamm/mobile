class AuthValidator {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Semua field harus diisi';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value!)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Semua field harus diisi';
    }

    if (value!.length < 8) {
      return 'Kata sandi harus minimal 8 karakter';
    }

    return null;
  }
}
