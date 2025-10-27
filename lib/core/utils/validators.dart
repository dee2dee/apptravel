import 'dart:io';
import 'package:flutter/services.dart';

class Validators {
  // ========================
  //  FULL NAME
  // ========================
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nama wajib diisi";
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value.trim())) {
      return "Nama hanya boleh berisi huruf dan spasi";
    }
    return null;
  }

  static final List<TextInputFormatter> inputFormattersFullName = [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z ]')),
  ];

  // ========================
  //  EMAIL
  // ========================
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email wajib diisi";
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Format email tidak valid";
    }
    return null;
  }

  static final List<TextInputFormatter> inputFormattersEmail = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
  ];

  // ========================
  //  PHONE
  // ========================
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nomor WhatsApp wajib diisi";
    }

    String phone = value.trim();

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return "Nomor hanya boleh angka";
    }

    // hapus 0 di depan
    if (phone.startsWith('0')) {
      phone = phone.replaceFirst(RegExp(r'^0+'), '');
    }

    if (phone.isEmpty) {
      return "Nomor tidak boleh kosong setelah hapus awalan 0";
    }

    if (phone.length > 12) {
      return "Nomor maksimal 12 digit";
    }

    return null;
  }

  static final List<TextInputFormatter> inputFormattersPhone = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(12),
  ];

  // ========================
  //  PASSWORD
  // ========================
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password wajib diisi";
    }
    if (value.length < 6) {
      return "Password minimal 6 karakter";
    }
    if (value.length > 8) {
      return "Password maksimal 8 karakter";
    }
    return null;
  }

  static final List<TextInputFormatter> inputFormattersPassword = [
    LengthLimitingTextInputFormatter(8),
  ];

  // ========================
  //  DRIVER PROFILE
  // ========================
  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nama bank wajib dipilih";
    }
    return null;
  }

  static String? validateBankAccount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Nomor rekening wajib diisi";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return "Nomor rekening hanya boleh angka";
    }
    if (value.length < 6) {
      return "Nomor rekening minimal 6 digit";
    }
    return null;
  }

  static final List<TextInputFormatter> inputFormattersBankAccount = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(16), // biasanya max 16 digit
  ];

  // ========================
  //  FILE (KTP, STNK, FOTO DRIVER)
  // ========================
  static String? validateImage(File? file, String fieldName,
      {int maxSizeMB = 2}) {
    if (file == null) {
      return "$fieldName wajib diunggah";
    }

    final fileSize = file.lengthSync();
    final maxSize = maxSizeMB * 1024 * 1024;
    if (fileSize > maxSize) {
      return "$fieldName maksimal ${maxSizeMB}MB";
    }

    return null;
  }
}
