import 'package:mini_app_sdk/mini_app_sdk.dart';

SecAcntBankOption mapSecAcntBankOptionFromFiBomInst(FiBomInstDto fiBomInst) {
  final String label = _resolveBankLabel(fiBomInst);
  final String shortLabel = _buildBankShortLabel(label, fallback: fiBomInst.fiCode);

  return SecAcntBankOption(
    fiBomInst.fiCode,
    label,
    shortLabel,
    fiBomInst.logo ?? fiBomInst.logoDim ?? fiBomInst.logoDark ?? fiBomInst.logoDimDark ?? '',
  );
}

String _resolveBankLabel(FiBomInstDto fiBomInst) {
  final List<String?> candidates = <String?>[
    fiBomInst.name,
    fiBomInst.brief,
    fiBomInst.name2,
    fiBomInst.brief2,
    fiBomInst.fiCode,
  ];

  for (final String? candidate in candidates) {
    final String normalized = candidate?.trim() ?? '';
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }

  return fiBomInst.fiCode;
}

String _buildBankShortLabel(String title, {required String fallback}) {
  final List<String> parts = title.trim().split(RegExp(r'[\s/()-]+')).where((String part) => part.isNotEmpty).toList(growable: false);

  if (parts.length >= 2) {
    return '${_firstLetter(parts[0])}${_firstLetter(parts[1])}'.toUpperCase();
  }
  if (parts.length == 1) {
    return _firstLetter(parts.first).toUpperCase();
  }
  return _firstLetter(fallback).toUpperCase();
}

String _firstLetter(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '?';
  }
  return trimmed.substring(0, 1);
}
