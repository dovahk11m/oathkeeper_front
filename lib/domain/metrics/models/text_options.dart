class TextOptions {
  final String mode; // 'rules' | 'prompt' | 'llm'
  final String? style;
  final String? notes;
  final int? seed;
  final Map<int, String>? nameMap;

  TextOptions({
    required this.mode,
    this.style,
    this.notes,
    this.seed,
    this.nameMap,
  });

  Map<String, dynamic> toJson() => {
        'mode': mode,
        if (style != null) 'style': style,
        if (notes != null) 'notes': notes,
        if (seed != null) 'seed': seed,
        if (nameMap != null)
          'name_map':
              nameMap!.map((k, v) => MapEntry(k.toString(), v)), // 키를 문자열로
      };
}
