import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oath_client/domain/members/term/term.dart';

part 'term_state.freezed.dart';

@freezed
class TermState with _$TermState {
  const factory TermState({
    @Default([]) List<Term> terms,
    @Default(false) bool isLoading,
    String? error,
  }) = _TermState;
}
