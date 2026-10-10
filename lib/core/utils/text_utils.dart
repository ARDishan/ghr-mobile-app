/// "OCEAN BREEZE PHASE 11 - NEGOMBO" -> "Ocean Breeze Phase 11 - Negombo".
/// ERP names are upper case; roman numerals (II, III, IV ...) stay upper case.
String toTitleCase(String input) {
  final roman = RegExp(r'^(?:II|III|IV|VI|VII|VIII|IX|XI|XII)$');
  return input.trim().toLowerCase().splitMapJoin(
        RegExp(r"[a-z0-9]+(?:'[a-z]+)?"),
        onMatch: (m) {
          final w = m[0]!;
          if (roman.hasMatch(w.toUpperCase())) return w.toUpperCase();
          return w[0].toUpperCase() + w.substring(1);
        },
        onNonMatch: (s) => s,
      );
}
