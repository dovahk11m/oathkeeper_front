class TextOptions {
  final String mode;           // "rules" | "prompt"
  final String style;          // "casual", "formal" 등
  final String notes;          // 프롬프트 메모
  final int? seed;             // 랜덤 시드
  final Map<int, String>? nameMap; // memberId -> name

  TextOptions({
    this.mode = 'rules',
    this.style = '',
    this.notes = '',
    this.seed,
    this.nameMap,
  });

  Map<String, dynamic> toJson() {
    // FastAPI는 name_map 키를 기대, 키는 문자열/정수 모두 허용하므로 문자열로 맞춰 보냄
    final nm = nameMap?.map((k, v) => MapEntry(k.toString(), v));
    return {
      'mode': mode,
      'style': style,
      'notes': notes,
      'seed': seed,
      'name_map': nm,
    };
  }
}
